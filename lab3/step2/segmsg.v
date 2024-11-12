/////testcomplete//////
module segmsg (
    input wire [3:0] seg, 
    output reg [7:0] led
);
    always @(*) begin
        case (seg)
            4'b0000: led = 8'b11111100; // 0
            4'b0001: led = 8'b01100000; // 1
            4'b0010: led = 8'b11011010; // 2
            4'b0011: led = 8'b11110010; // 3
            4'b0100: led = 8'b01100110; // 4
            4'b0101: led = 8'b10110110; // 5
            4'b0110: led = 8'b10111110; // 6
            4'b0111: led = 8'b11100000; // 7
            4'b1000: led = 8'b11111110; // 8
            4'b1001: led = 8'b11110110; // 9
            4'b1010: led = 8'b11101100; // A
            4'b1011: led = 8'b00111110; // b
            4'b1100: led = 8'b10011100; // C
            4'b1101: led = 8'b01111010; // d
            4'b1110: led = 8'b10011110; // E
            4'b1111: led = 8'b10001110; // F
            default: led = 8'b00000000; //default
        endcase
    end
endmodule
