module led(input clk,input rst,output reg led);
reg[6:0] cnt_2us;
reg[9:0] cnt_2ms;
reg[9:0] cnt_2s;
parameter [7:0] Max_2us = 7'd100;
parameter [9:0] Max_2ms = 10'd1000;
parameter [9:0] Max_2s = 10'd1000;
reg dir;
always@(posedge clk)
begin
    if(rst == 1'd1)
        cnt_2us <= 7'd0;
    else if(cnt_2us == Max_2us)  
        cnt_2us <= 7'd0;
    else
        cnt_2us <= cnt_2us + 7'b1;
end
always@(posedge clk)
begin
    if(rst == 1'b1)
        cnt_2ms <= 10'b0;
    else if((cnt_2ms == Max_2ms) &&(cnt_2us == Max_2us))
        cnt_2ms <= 10'b0;
    else if(cnt_2us == Max_2us)
        cnt_2ms <= cnt_2ms + 10'b1;
end
always@(posedge clk)
begin
    if(rst == 1'b1)
        cnt_2s <= 10'b0;
    else if((cnt_2s == Max_2s) && (cnt_2ms == Max_2ms) && (cnt_2us == Max_2us))
        cnt_2s <= 10'b0;
    else if((cnt_2ms == Max_2ms) && (cnt_2us == Max_2us))
        cnt_2s <= cnt_2s + 10'b1;
end
always@(posedge clk)
begin
    if(rst == 1'b1)
        dir <= 1'b0;
    else if((cnt_2s == Max_2s) && (cnt_2ms == Max_2ms) && (cnt_2us == Max_2us))
        dir <= ~dir;
end
always@(posedge clk)
begin
    if(rst == 1'b1)
        led <= 1'b0;
    else if(dir ^ (cnt_2ms < cnt_2s))
        led <= 1'b1;
    else
        led <= 1'b0;
end
endmodule
