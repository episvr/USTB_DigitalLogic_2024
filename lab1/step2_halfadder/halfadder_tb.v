`timescale 1ns / 1ps
module tb_two_bit_half_adder; 
    reg [1:0] A; 
    reg [1:0] B;   
    wire [1:0] Sum;          
    wire Carry;             

    two_bit_half_adder uut (
        .A(A),
        .B(B),
        .Sum(Sum),
        .Carry(Carry)
    );

    initial begin
        A = 2'b00; B = 2'b00; // 0 + 0
        #10;
        $display("A = %b, B = %b, Sum = %b, Carry = %b", A, B, Sum, Carry);
        A = 2'b01; B = 2'b01; // 1 + 1
        #10; 
        $display("A = %b, B = %b, Sum = %b, Carry = %b", A, B, Sum, Carry);
        A = 2'b10; B = 2'b10; // 2 + 2
        #10; 
        $display("A = %b, B = %b, Sum = %b, Carry = %b", A, B, Sum, Carry);
        A = 2'b11; B = 2'b11; // 3 + 3
        #10; 
        $display("A = %b, B = %b, Sum = %b, Carry = %b", A, B, Sum, Carry);
        $finish;
    end
endmodule
