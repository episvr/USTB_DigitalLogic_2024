module clkDiv(
    input clk100mhz,
    output clk190hz,
    output clk3hz
);
    reg [30:0]cnt = 0;
    assign clk190hz = cnt[16];
    assign clk3hz = cnt[28];
    always@(posedge clk100mhz) cnt<=cnt+1;
endmodule