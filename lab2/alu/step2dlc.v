`timescale 1ns/1ps
module top(
    input wire [3:0] a,
    input wire [3:0] b,
    input wire [3:0] op,
    output wire [3:0] pos,
    output reg [7:0] result_segmsg
);
    reg [11:0] alu_op;
    wire [3:0] alu_result;
    always @(*) begin
        case (op)
            4'b0001: alu_op = 12'h001; //plus
            4'b0010: alu_op = 12'h002; //minus
            4'b0011: alu_op = 12'h004; //digit AND
            4'b0100: alu_op = 12'h008; //logic OR
            4'b0101: alu_op = 12'h010; //logic left shift
            4'b0110: alu_op = 12'h020; //arithmetic right shift
            4'b0111: alu_op = 12'h040; //loop right shift
            4'b1000: alu_op = 12'h080; //less than (signed)
            4'b1001: alu_op = 12'h100; //less than (unsigned)
            4'b1010: alu_op = 12'h200; //special ADD
            4'b1011: alu_op = 12'h400; //XOR
            //4'b1100: alu_op = 12'h800; //complex op `ι`
            default: alu_op = 12'h000; // default case
        endcase
    end
    ALU alu(a, b, alu_op, alu_result);
    //segmsg
    assign pos = 4'b0001;
    always @(*) begin
        case (alu_result)
            4'b0000: result_segmsg = 8'b11111100; // 0
            4'b0001: result_segmsg = 8'b01100000; // 1
            4'b0010: result_segmsg = 8'b11011010; // 2
            4'b0011: result_segmsg = 8'b11110010; // 3
            4'b0100: result_segmsg = 8'b01100110; // 4
            4'b0101: result_segmsg = 8'b10110110; // 5
            4'b0110: result_segmsg = 8'b10111110; // 6
            4'b0111: result_segmsg = 8'b11100000; // 7
            4'b1000: result_segmsg = 8'b11111110; // 8
            4'b1001: result_segmsg = 8'b11110110; // 9
            4'b1010: result_segmsg = 8'b11101110; // A
            4'b1011: result_segmsg = 8'b00111110; // B
            4'b1100: result_segmsg = 8'b10011100; // C
            4'b1101: result_segmsg = 8'b01111010; // D
            4'b1110: result_segmsg = 8'b10011110; // E
            4'b1111: result_segmsg = 8'b10001110; // F
            default: result_segmsg = 8'b00000000; //default
        endcase
    end
endmodule // top



module ALU (
    input wire [3:0] alu_src1,
    input wire [3:0] alu_src2,    
    input wire [11:0] alu_op,    
    output wire [3:0] alu_result  
);
wire signed [3:0] src1,src2;
assign src1 = alu_src1;
assign src2 = alu_src2;
reg [3:0] answer;
reg [4:0] tmp;
// reg [3:0] shift;
always @(*) begin
    case (alu_op)
    12'h001: answer = src1 + src2;                                                               //plus
    12'h002: answer = src1 - src2;                                                               //minus
    12'h004: answer = alu_src1 & alu_src2;                                                       //digit AND
    12'h008: answer = alu_src1 || alu_src2;                                                      //logic OR
    12'h010: answer = alu_src1 << alu_src2[1:0];                                                 //logic left shift
    12'h020: answer = src1 >>> src2[1:0];                                                        //arithmetic right shift
    12'h040: answer = {src1, src1} >> src2[1:0];                                                 //loop right shift
    12'h080: answer = src1 < src2;                                                               //less than (signed)
    12'h100: answer = alu_src1 < alu_src2;                                                       //less than (unsigned)
    12'h400: answer = src1 ^ src2;                                                               //XOR
    12'h200: begin                                                                               //special ADD
            tmp = {1'b0, alu_src1} + {1'b0, alu_src2};
            answer = tmp[4] ? tmp[4:1] : tmp[3:0]; 
        end
    /* 
    12'h800: begin                                                                               //complex op `ι`
            if(src2[4]) {tmp, shift} = {{alu_src2[3:0], alu_src1[1:0], alu_src1[7:6]}, alu_src1[5:2]};
            else if(src2[5]) {tmp, shift} = {{alu_src2[3:0], alu_src1[5:4], alu_src1[3:2]}, {alu_src1[7:6], alu_src1[1:0]}};
            else if(src2[6]) {tmp, shift} = {{alu_src2[3:0], alu_src1[7:6], alu_src1[3:2]}, {alu_src1[5:4], alu_src1[1:0]}};
            else if(src2[7]){tmp, shift} = {{alu_src2[3:0], alu_src1[5:4], alu_src1[1:0]}, {alu_src1[7:6], alu_src1[3:2]}};
            else {tmp, shift} = {8'b0, 4'b0};
            answer = shift[0] ? ({tmp[7:0],tmp[7:0]} >> (8 - shift[3:1])) : ({tmp[7:0],tmp[7:0]} >> shift[3:1]); 
        end
    */
    default : answer = 4'b0;
    endcase
end
assign alu_result = answer;
endmodule