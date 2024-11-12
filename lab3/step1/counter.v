`timescale 1ns / 1ps

module counter(
    input  wire clk,
    input  wire rst,
    input wire [2:0] speed,
    output wire clk_bps
);
    reg [13:0] cnt_first, cnt_second;
    reg [13:0] maxcount;
    always @(*) begin
        case (speed)
            // 3'b000 : begin maxcount = 14'd10000; rst = 1; end
            3'b000: maxcount = 14'd10000; // 状态 0
            3'b001: maxcount = 14'd08714; // 状态 1
            3'b010: maxcount = 14'd07428; // 状态 2
            3'b011: maxcount = 14'd06142; // 状态 3
            3'b100: maxcount = 14'd04856; // 状态 4
            3'b101: maxcount = 14'd03570; // 状态 5
            3'b110: maxcount = 14'd02284; // 状态 6
            3'b111: maxcount = 14'd01000; // 状态 7
            default: maxcount = 14'd10000;
        endcase
        // maxcount = maxcount/100;  //this line is for simulation, to make the counter run faster for purposes
    end

    always @(posedge clk) begin
        if (rst)
            cnt_first <= 14'd0;
        else if (cnt_first == maxcount)
            cnt_first <= 14'd0;
        else
            cnt_first <= cnt_first + 1'b1;
    end

    always @(posedge clk) begin
        if (rst)
            cnt_second <= 14'd0;
        else if (cnt_second == maxcount)
            cnt_second <= 14'd0;
        else if (cnt_first == maxcount)
            cnt_second <= cnt_second + 1'b1;
    end

    assign clk_bps = (cnt_second == maxcount) ? 1'b1 : 1'b0;
endmodule



module flash_led_ctl(
    input clk,
    input rst,
    input dir,
    input clk_bps,
    output reg [15:0] led
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            led <= 16'h8000;
        else begin
            case (dir)
                1'b0: 
                    if (clk_bps) 
                        if (led != 16'd1)
                            led <= led >> 1'b1;
                        else
                            led <= 16'h8000;
                1'b1: 
                    if (clk_bps) 
                        if (led != 16'h8000)
                            led <= led << 1'b1;
                        else
                            led <= 16'd1;
            endcase
        end
    end
endmodule

module epi_flash_led_top(
    input clk,
    input [7:0] speed_ctrl,
    output wire [15:0] led
);
    wire clk_bps;
    wire [2:0] speedgrade;
    reg [2:0] grade;
    reg rst;
    integer i;

    always @(*) begin
        grade = 3'd0;
        for (i = 0; i < 8; i = i + 1) begin
            if (speed_ctrl[i]) begin
                grade = grade + 1;
            end
        end

        if (grade == 3'd0) begin
            rst = 1'b1; 
        end
        else begin
            rst = 1'b0;
            // $display("grade: %d, rst: %b", grade, rst);
        end
    end

    counter counter_inst(
        .clk(clk),
        .rst(rst),
        .speed(grade),
        .clk_bps(clk_bps)
    );

    flash_led_ctl flash_led_ctl_inst(
        .clk(clk),
        .rst(rst),
        .dir(speed_ctrl[7]),
        .clk_bps(clk_bps),
        .led(led)
    );
endmodule
////////////////////////testbench//////////////////////////////
// module epi_flash_led_top_tb;
//  	 	reg clk;
//         reg [7:0] speed_ctrl;
//  	 	wire [15:0] led;
//  	  	initial begin
//  	 		clk = 1'b0;
//  	 		speed_ctrl = 8'b00000000;
//  	 		#1000000 speed_ctrl = 8'b00000001;
//  	 		#1000000 speed_ctrl = 8'b00011011;
//  	 		#300000 speed_ctrl = 8'b00000000;
//  	 		#1000000 speed_ctrl = 8'b11101111;
//  	 	end
//  	 	always #5 clk <= ~clk;
//  	 	epi_flash_led_top epi_flash_led_top(
//  	 		.clk( clk ),
//  	 		.speed_ctrl( speed_ctrl ),
//  	 		.led( led )
//  	 	);
// endmodule
