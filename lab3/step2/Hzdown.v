module HzDown(
    input  wire clk,
    input  wire rst_n,
    input  wire [4:0] rate,
    output reg clk_bps
);
    reg [27:0] cnt;
    reg [27:0] maxcount;

    always @(*) begin
        maxcount = (rate == 0) ? 28'd100000000 : 28'd100000000 / rate;  // 降低频率
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_bps <= 0;
        end else if (cnt >= maxcount) begin
            cnt <= 0;
            clk_bps <= ~clk_bps;
        end else begin
            cnt <= cnt + 1;
        end
    end
endmodule
