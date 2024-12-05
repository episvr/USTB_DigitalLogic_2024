module counter(
    input  wire clk,
    input  wire rst,
    output wire clk_bps
);
    reg [13: 0] cnt_first, cnt_second;

    always @(posedge clk)
        if(rst)
            cnt_first <= 14'd0;
        else if(cnt_first == 14'd3500)
            cnt_first <= 14'd0;
        else
            cnt_first <= cnt_first + 1'b1;

    always @(posedge clk)
        if(rst)
            cnt_second <= 14'd0;
        else if(cnt_second == 14'd3500)
            cnt_second <= 14'd0;
        else if(cnt_first == 14'd3500)
            cnt_second <= cnt_second + 1'b1;

    assign clk_bps = cnt_second == 14'd3500 ? 1'b1 : 1'b0;
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

module ledpwm (
    input clk,
    input rst,
    input data,
    output reg led
);
    parameter [1:0] STATE_ON = 2'b00,
                  STATE_BLINK = 2'b01,
                  STATE_OFF = 2'b10;
    reg [1:0] current_state, next_state;

    reg [6:0] cnt_2us;   
    reg [9:0] cnt_2ms;
    reg [9:0] cnt_2s;
    parameter [6:0] Max_2us = 9'd300; 
    parameter [9:0] Max_2ms = 10'd1000;
    parameter [9:0] Max_2s = 10'd1000;
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
        cnt_2s <= 0;
        else if((cnt_2ms == Max_2ms) && (cnt_2us == Max_2us))
        cnt_2s <= cnt_2s + 10'b1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= STATE_OFF;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            STATE_ON: begin
                if (data) begin
                    next_state = STATE_ON;
                end 
                else begin
                    next_state = STATE_BLINK;
                end
            end
            STATE_BLINK: begin
                if (cnt_2s == Max_2s) begin
                    next_state = STATE_OFF;
                end
                else begin
                    next_state = STATE_BLINK;
                end
            end
            STATE_OFF: begin
                if (data) begin
                    next_state = STATE_ON;
                end else begin
                    next_state = STATE_OFF;
                end
            end

            default: next_state = STATE_OFF;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            led <= 1'b0;
        end else begin
            case (current_state)
                STATE_ON: led <= 1'b1;
                STATE_BLINK: led <= (cnt_2ms > cnt_2s) ? 1'b1 : 1'b0;
                STATE_OFF: led <= 1'b0;
                default: led <= 1'b0;
            endcase
        end
    end
endmodule

module flash_led_top(
    input clk,
    input rst_n,
    input sw0,
    output [15:0] led_out
);
    wire clk_bps;
    wire rst;
    wire [15:0] led;

    assign rst = ~rst_n;
    counter counter_inst(
        .clk(clk),
        .rst(rst),
        .clk_bps(clk_bps)
    );
    flash_led_ctl flash_led_ctl_inst(
        .clk(clk),
        .rst(rst),
        .dir(sw0),
        .clk_bps(clk_bps),
        .led(led)
    );
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : ledpwm_gen
            ledpwm ledpwm_inst(
                .clk(clk),
                .rst(rst),
                .data(led[i]),    
                .led(led_out[i])
            );
        end
    endgenerate
endmodule
