`timescale 1ns / 1ps
module counter(
    input  wire clk,
    input  wire rst,
    output wire clk_bps
);
    reg [13: 0] cnt_first, cnt_second;

    always @(posedge clk)
        if(rst)
            cnt_first <= 14'd0;
        else if(cnt_first == 14'd10000)
            cnt_first <= 14'd0;
        else
            cnt_first <= cnt_first + 1'b1;

    always @(posedge clk)
        if(rst)
            cnt_second <= 14'd0;
        else if(cnt_second == 14'd10000)
            cnt_second <= 14'd0;
        else if(cnt_first == 14'd10000)
            cnt_second <= cnt_second + 1'b1;

    assign clk_bps = cnt_second == 14'd10000 ? 1'b1 : 1'b0;
endmodule

module flash_led_ctl(
 	 	input clk,
 	 	input rst,
 	 	input dir,
 	 	input clk_bps,
 	 	output reg[15:0]led
 	 	);
 	 	always @( posedge clk or posedge rst )
 	 		if( rst )
 	 			led <= 16'h8000;
 	 		else
 	 			case( dir )
 	 				1'b0:  			
 	 					if( clk_bps )
 	 				 		if( led != 16'd1 )
 	 							led <= led >> 1'b1;
 	 						else
 	 							led <= 16'h8000;
 	 				1'b1:  			 
 	 			 		if( clk_bps )
 	 						if( led != 16'h8000 )
 	 							led <= led << 1'b1;
 	 						else
 	 							led <= 16'd1;
 	 			endcase
endmodule



module flash_led_top(
        input clk,
 	 	input rst_n,
 	 	input sw0,
 	 	output [15:0]led
 	 	);
 	 	wire clk_bps;
 	 	wire rst;
 	 	assign rst = ~rst_n;
 	 	
 	 	counter counter(
 	 		.clk( clk ),
 	 		.rst( rst ),
 	 		.clk_bps( clk_bps )
 	 	);
 	 	flash_led_ctl flash_led_ctl(
 	 		.clk( clk ),
 	 		.rst( rst ),
 	 		.dir( sw0 ),
 	 		.clk_bps( clk_bps ),
 	 		.led( led )
 	 	);
endmodule

module flash_led_top_tb;
 	 	reg clk,rst,sw0;
 	 	wire [15:0] led;
 	  	initial begin
 	 		clk = 1'b0;
 	 		rst = 1'b1;
 	 		sw0 = 1'b0;
 	 		#10 rst = 1'b0;
 	 		#10 rst = 1'b1;
 	 		#1000000000				 //6ms后改变位移方向
 	 		#1000000000
 	 		#1000000000
 	 		#1000000000
 	 		#1000000000
 	 		#1000000000
 	 		sw0 = 1'b1;
 	 	end
 	 	always #5 clk <= ~clk;
 	 	flash_led_top flash_led_top(
 	 		.clk( clk ),
 	 		.rst_n( rst ),
 	 		.sw0( sw0 ),
 	 		.led( led )
 	 	);
endmodule
