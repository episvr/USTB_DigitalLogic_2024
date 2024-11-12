`timescale 1ns / 1ps
module full_adder (
    input wire A,      
    input wire B,      
    input wire Cin,    
    output wire Sum,    
    output wire Carry   
);
assign Sum = A ^ B ^ Cin;
assign Carry = (A & B) | (Cin & (A ^ B));
endmodule


module two_bit_half_adder (
    input wire [1:0] A,          
    input wire [1:0] B,          
    output wire [1:0] Sum,       
    output wire Carry            
);
wire Sum0;  
wire Carry0;                   
wire Sum1;       
full_adder FA0 (
    	.A(A[0]),
    	.B(B[0]),
    	.Cin(),    
    	.Sum(Sum0),
    	.Carry(Carry0)
);
full_adder FA1 (
    	.A(A[1]),
    	.B(B[1]),
    	.Cin(Carry0),     
    	.Sum(Sum1),
    	.Carry(Carry)
);
assign Sum = {Sum1, Sum0};
endmodule