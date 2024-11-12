`timescale 1ns/1ps
module segmeg(
    input key1,
    input key2,
    input key3,
    input key4,
    output reg [3:0] pos,
    output reg [7:0] seg
);
    wire [3:0] data = {key4, key3, key2, key1}; 
    always @(data) begin
        pos = 4'b0001;
        case (data)
            4'b0000: seg = 8'b11111100; // 0
            4'b0001: seg = 8'b01100000; // 1
            4'b0010: seg = 8'b11011010; // 2
            4'b0011: seg = 8'b11110010; // 3
            4'b0100: seg = 8'b01100110; // 4
            4'b0101: seg = 8'b10110110; // 5
            4'b0110: seg = 8'b10111110; // 6
            4'b0111: seg = 8'b11100000; // 7
            4'b1000: seg = 8'b11111110; // 8
            4'b1001: seg = 8'b11110110; // 9
            default: seg = 8'b00000000; //default
        endcase
    end
endmodule