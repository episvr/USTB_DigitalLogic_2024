
`timescale 1ns / 1ps

module clkDiv (
    input  wire clk,
    input  wire rst,
    output wire clk_bps
);
    reg [10:0] cnt_first;
    reg [10:0] cnt_second;
    
    always @(posedge clk)
        if(rst)
            cnt_first <= 11'd0;
        else if(cnt_first == (11'd1000))
            cnt_first <= 11'd0;
        else 
            cnt_first <= cnt_first + 1'b1;

    always @(posedge clk)
        if(rst)
            cnt_second <= 11'd0;
        else if(cnt_second == 11'd100)
            cnt_second <= 11'd0;
        else if(cnt_first == 11'd1000)
            cnt_second <= cnt_second + 1'b1;

    assign clk_bps = cnt_second == 11'd100 ? 1'b1 : 1'b0;
endmodule