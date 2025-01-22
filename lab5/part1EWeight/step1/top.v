module GPU (
    input clk3hz,
    input clr,
    input Go,
    input [3:0] weight,
    input [3:0] price,
    output reg [15:0] dataBus1,
    output reg [15:0] dataBus2,
    output reg [15:0] total,
    output reg [7:0] count
);
    wire [7:0] wtp; assign wtp = weight * price;
    parameter NORM = 1'b0, ACCU = 1'b1;
    reg [31:0] msg;
    reg CURR_STATE, NEXT_STATE;

    wire [7:0]  w_tmp; reg [7:0]  w_t;
    wire [7:0]  p_tmp; reg [7:0]  p_t;
    wire [15:0] m_tmp; reg [15:0] mul_t;

    reg [7:0] total_tmp; wire [15:0] total_t;
    reg accComp;

    initial begin
        total[15:0] = 0;
        count[7:0] = 0;
        msg[31:0] = 0;  
        CURR_STATE = NORM;
        NEXT_STATE = ACCU;
        mul_t[15:0] = 0;
        total_tmp[7:0] = 0;
        accComp = 0;
    end

    always @(posedge clk3hz or posedge clr) begin
        if (clr) begin
            dataBus1[15:0] <= 16'b0;
            dataBus2[15:0] <= 16'b0;
        end else begin
            case (CURR_STATE)
                NORM: {dataBus1, dataBus2} <= msg;

                ACCU: {dataBus1, dataBus2} <= {8'hAC, count[7:0], total[15:0]};
            endcase
        end
    end

    always @(posedge clk3hz or posedge clr) begin
        if (clr) begin
            NEXT_STATE <= NORM;
            msg <= 32'b0;
            count <= 8'b0;
            total_tmp <= 7'b0;
            accComp <= 0;
        end else begin
            if (Go) NEXT_STATE <= ACCU;
            if (CURR_STATE == ACCU) begin
                if (msg[31:16] != {w_t[7:0], p_t[7:0]}) begin
                    NEXT_STATE <= NORM;
                    accComp <= 0;
                end
            end
            else begin
                if (NEXT_STATE == NORM) msg <= {w_t, p_t, mul_t};
                else if (accComp == 0) begin
                    if(wtp != 0) count <= count + 1;
                    total_tmp <= total_tmp + wtp;
                    accComp <= 1;
                end
            end
        end
    end

    always @(posedge clk3hz) begin
        w_t <= w_tmp;
        p_t  <= p_tmp;
        mul_t    <= m_tmp;
    end

    always @(posedge clk3hz or posedge clr) begin
        if (clr) begin
            CURR_STATE <= NORM;
            total <= 16'b0;
        end else begin
            total <= total_t;
            if (CURR_STATE == NORM && NEXT_STATE == ACCU) begin
                if (accComp == 1) CURR_STATE <= NEXT_STATE;
                else CURR_STATE <= CURR_STATE;
            end else CURR_STATE <= NEXT_STATE;
        end
    end

    decoder_8 decode_w(weight,w_tmp);
    decoder_8 decode_p(price, p_tmp);
    decoder_16 decode_m(wtp, m_tmp);
    decoder_16 decode_t(total_tmp, total_t);
endmodule

module decoder_8(input [3:0] in, output [7:0] out);
    assign out[7:4] = in / 10;
    assign out[3:0] = in % 10;
endmodule

module decoder_16(input [7:0] in, output [15:0] out);
    assign out[15:12] = in / 1000;
    assign out[11:8]  = (in / 100) % 10;
    assign out[7:4]   = (in / 10) % 10;
    assign out[3:0]   = in % 10;
endmodule
