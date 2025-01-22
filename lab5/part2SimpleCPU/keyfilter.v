`timescale 1ns / 1ps

module filter(
    input   wire  clk,
    input   wire  rst,
    input   wire  key_in,
    output  reg   key_flag            
);  
    reg [19:0] cnt_10ms;
    parameter CNT_10MS_MAX=20'd1000_000;

    always @ (posedge clk or posedge rst) begin
        if(rst)
            cnt_10ms<=20'd0;
        else if(!key_in)
            cnt_10ms<=20'd0;
        else if(cnt_10ms==CNT_10MS_MAX && key_in==1)
            cnt_10ms<=CNT_10MS_MAX;
        else
            cnt_10ms<=cnt_10ms+1'b1;
    end
    
    always @ (posedge clk or posedge rst) begin
        if(rst)
            key_flag<=1'b0;
        else if(cnt_10ms==CNT_10MS_MAX-1'b1)
            key_flag<=1'b1;
        else
            key_flag<=1'b0;
    end

endmodule
