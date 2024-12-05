
module top(
    input wire clk100MHz,
    input wire rst,
    output wire [3:0] pos,
    output wire [7:0] seg
);
    wire clk190Hz, clk3Hz;
    wire [15:0] dataBus;

    clkDiv #(.DIV190HZ(17), .DIV3HZ(24)) clk_div (
        .clk100MHz(clk100MHz),
        .rst(rst),
        .clk190Hz(clk190Hz),
        .clk3Hz(clk3Hz)
    );

    GPU gpu (
        .clk3Hz(clk3Hz),
        .rst(rst),
        .dataBus(dataBus)
    );

    segMsg seg_msg (
        .clk190Hz(clk190Hz),
        .rst(rst),
        .dataBus(dataBus),
        .pos(pos),
        .seg(seg)
    );
endmodule

module clkDiv #(parameter DIV190HZ = 17, DIV3HZ = 29)(
    input wire clk100MHz,
    input wire rst,
    output wire clk190Hz,
    output wire clk3Hz
);
    reg [30:0] cnt;
    assign clk190Hz = cnt[DIV190HZ - 1];
    assign clk3Hz = cnt[DIV3HZ - 1];
    always @(posedge clk100MHz or posedge rst) begin
        if (rst)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end
endmodule

module GPU(
    input wire clk3Hz,
    input wire rst,
    output wire [15:0] dataBus
);
    reg [39:0] msgArray = 40'hA202342568;
    assign dataBus = msgArray[39:24];
    always @(posedge clk3Hz or posedge rst) begin
        if (rst)
            msgArray <= 40'hA202342568;
        else
            msgArray <= {msgArray[35:0], msgArray[39:36]};
    end
endmodule

module segMsg(
    input wire clk190Hz,
    input wire rst,
    input wire [15:0] dataBus,
    output reg [3:0] pos,
    output reg [7:0] seg
);
    reg [1:0] posC; 
    reg [3:0] dataP; 

    always @(posedge clk190Hz or posedge rst) begin
        if (rst) begin
            posC <= 0;
            pos <= 4'b1111;
        end else begin
            posC <= posC + 1;
            case (posC)
                2'd0: {pos, dataP} <= {4'b0001, dataBus[3:0]};
                2'd1: {pos, dataP} <= {4'b0010, dataBus[7:4]};
                2'd2: {pos, dataP} <= {4'b0100, dataBus[11:8]};
                2'd3: {pos, dataP} <= {4'b1000, dataBus[15:12]};
            endcase
        end
    end

    always @(*) begin
        case(dataP)
            4'h0: seg = 8'b0011_1111;
            4'h1: seg = 8'b0000_0110;
            4'h2: seg = 8'b0101_1011;
            4'h3: seg = 8'b0100_1111;
            4'h4: seg = 8'b0110_0110;
            4'h5: seg = 8'b0110_1101;
            4'h6: seg = 8'b0111_1101;
            4'h7: seg = 8'b0000_0111;
            4'h8: seg = 8'b0111_1111;
            4'h9: seg = 8'b0110_1111;
            4'hA: seg = 8'b0011_1110;
            default: seg = 8'b0100_0000; 
        endcase
    end
endmodule