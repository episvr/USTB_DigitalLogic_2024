
module segMsgout(
    input clk190hz,
    input [15:0]dataBus, 
    output reg [3:0] pos,
    output reg [7:0] seg
);
	reg [1:0] posC; 
	reg [3:0] dataP;
always @(posedge clk190hz )begin
case(posC)
	0: begin
	pos<=4'b1000;
    dataP<=dataBus[15:12];
	end
	1:begin
	pos <=4'b0100;
	dataP <= dataBus[11:8];
	end
	2:begin
	pos <=4'b0010;
	dataP <= dataBus[7:4];
	end
	3:begin
	pos <=4'b0001;
	dataP <= dataBus[3:0];
	end
	endcase
	posC = posC + 2'b01;
 end
 always @(dataP)
 case(dataP)
        4'b0000:seg=8'b0011_1111;
        4'b0001:seg=8'b0000_0110;
        4'b0010:seg=8'b0101_1011;
        4'b0011:seg=8'b0100_1111;
        4'b0100:seg=8'b0110_0110;
        4'b0101:seg=8'b0110_1101;
        4'b0110:seg=8'b0111_1101;
        4'b0111:seg=8'b0000_0111;
        4'b1000:seg=8'b0111_1111;
        4'b1001:seg=8'b0110_1111;
        
	    4'b1010:seg=8'b0111_0111; //A
	    4'b1100:seg=8'b0011_1001; //C
	    
        default:seg=8'b0000_1000;
 endcase
endmodule