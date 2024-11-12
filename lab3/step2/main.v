module main(
    input wire clk,
    input wire rst_n,
    input wire B1, 
    input wire B2,
    input wire [1:0] K, 
    output wire alarm_led,
    output wire [3:0] pos,
    output wire [7:0] cnt
);
    wire B1_filtered;
    wire B2_filtered;
    reg alarm_flag;
    reg [3:0] num_cnt;
    reg [4:0] rate;
    wire clk_bps;
    assign pos = 4'b0001;
    key_filter B1_filter_inst(
        .clk(clk),
        .rst_n(rst_n),
        .key_in(B1),
        .key_flag(B1_filtered)
    );
    key_filter B2_filter_inst(
        .clk(clk),
        .rst_n(rst_n),
        .key_in(B2),
        .key_flag(B2_filtered)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            alarm_flag <= 1'b0;
            num_cnt <= 4'b0000;
            rate <= 5'b00000;
        end
        else begin
            if (B1_filtered) begin
                alarm_flag <= !alarm_flag;
                if (!alarm_flag) begin
                    num_cnt <= num_cnt + 1;
                end
            end
            
            if (B2_filtered) begin
                num_cnt <= 4'b0001;
            end
            case (K)
                2'b01: rate <= num_cnt*2;
                2'b10: rate <= num_cnt*4;
                default: rate <= num_cnt;
            endcase
        end
    end
    segmsg segmsg_inst(
        .seg(num_cnt),
        .led(cnt)
    );

    HzDown HzDown_inst(
        .clk(clk),
        .rst_n(rst_n),
        .rate(rate),
        .clk_bps(clk_bps)
    );

    assign alarm_led = alarm_flag && clk_bps;
endmodule
