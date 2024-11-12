`timescale 1ns / 1ps

module test_adder_with_seven_segment;
reg [1:0] A;
reg [1:0] B;
wire pos;
wire [6:0] seg;
wire Carry;
adder_with_seven_segment uut (
    .A(A),
    .B(B),
    .pos(pos),
    .seg(seg),
    .Carry(Carry)
);

initial begin
    $monitor("A=%b, B=%b, Sum(seg)=%b, Carry=%b", A, B, seg, Carry);
    A = 2'b00; B = 2'b00; #10;
    A = 2'b01; B = 2'b00; #10;
    A = 2'b01; B = 2'b01; #10;
    A = 2'b10; B = 2'b00; #10;
    A = 2'b10; B = 2'b01; #10;
    A = 2'b10; B = 2'b10; #10;
    A = 2'b11; B = 2'b01; #10;
    A = 2'b11; B = 2'b11; #10;
    $finish;
end

endmodule
