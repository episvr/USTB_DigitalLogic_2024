`timescale 1ns/1ps

module segmeg_tb;
    reg key1, key2, key3, key4;
    wire [3:0] pos;
    wire [7:0] seg;
    segmeg uut (
        .key1(key1),
        .key2(key2),
        .key3(key3),
        .key4(key4),
        .pos(pos),
        .seg(seg)
    );
    initial begin
        key1 = 0; key2 = 0; key3 = 0; key4 = 0;
        {key4, key3, key2, key1} = 4'b0000; #10; 
        {key4, key3, key2, key1} = 4'b0001; #10; 
        {key4, key3, key2, key1} = 4'b0010; #10; 
        {key4, key3, key2, key1} = 4'b0011; #10; 
        {key4, key3, key2, key1} = 4'b0100; #10; 
        {key4, key3, key2, key1} = 4'b0101; #10; 
        {key4, key3, key2, key1} = 4'b0110; #10; 
        {key4, key3, key2, key1} = 4'b0111; #10; 
        {key4, key3, key2, key1} = 4'b1000; #10; 
        {key4, key3, key2, key1} = 4'b1001; #10; 
        {key4, key3, key2, key1} = 4'b1010; #10; 
        $finish;
    end
endmodule
