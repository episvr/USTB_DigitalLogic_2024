`timescale 1ns / 1ps
module adder_with_seven_segment (
    input [1:0] A,
    input [1:0] B, 
    output reg pos,
    output reg [6:0] seg, 
    output Carry  
);
wire [2:0] Sum;  
wire c1;               

assign Sum[0] = A[0] ^ B[0];
assign c1 = A[0] & B[0]; 

assign Sum[1] = A[1] ^ B[1] ^ c1; 
assign Carry = (A[1] & B[1]) | (c1 & (A[1] ^ B[1]));

assign Sum[2] = (A[1] & B[1]) | (c1 & (A[1] ^ B[1]));

always @(Sum) begin
    pos = 1;
    case(Sum)
        3'b000: seg = 7'b0111111;
        3'b001: seg = 7'b0000110;
        3'b010: seg = 7'b1011011;
        3'b011: seg = 7'b1001111;
        3'b100: seg = 7'b1100110;
        3'b101: seg = 7'b1101101;
        3'b110: seg = 7'b1111101;
        3'b111: seg = 7'b0000111;
        default: seg = 7'b0000000;
    endcase
end
endmodule
