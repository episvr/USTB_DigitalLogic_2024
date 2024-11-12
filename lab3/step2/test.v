module HzDown(
    input  wire clk,
    input  wire rst_n,
    input  wire [3:0] rate,
    output wire clk_bps
);
    reg [13:0] cnt_first, cnt_second;
    reg [13:0] maxcount;
    always @(*) begin
        maxcount = 14'd10000 / (rate+1);
    end
    always @(posedge clk) begin
        if (!rst_n)
            cnt_first <= 14'd0;
        else if (cnt_first == maxcount)
            cnt_first <= 14'd0;
        else
            cnt_first <= cnt_first + 1'b1;
    end

    always @(posedge clk) begin
        if (!rst_n)
            cnt_second <= 14'd0;
        else if (cnt_second == 14'd10000)
            cnt_second <= 14'd0;
        else if (cnt_first == maxcount)
            cnt_second <= cnt_second + 1'b1;
    end

    assign clk_bps = (cnt_second == 14'd10000) ? 1'b1 : 1'b0;
endmodule