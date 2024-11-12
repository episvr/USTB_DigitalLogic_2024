`timescale 1ns/1ps
module ALU (
    input wire [7:0] alu_src1,
    input wire [7:0] alu_src2,    
    input wire [11:0] alu_op,    
    output wire [7:0] alu_result  
);
wire signed [7:0] src1,src2;
assign src1 = alu_src1;
assign src2 = alu_src2;
reg [7:0] answer;
reg [8:0] tmp;
reg [3:0] shift; 
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
            answer = tmp[8] ? tmp[8:1] : tmp[7:0]; 
        end
    12'h800: begin                                                                               //complex op `ι`
            if(src2[4]) {tmp, shift} = {{alu_src2[3:0], alu_src1[1:0], alu_src1[7:6]}, alu_src1[5:2]};
            else if(src2[5]) {tmp, shift} = {{alu_src2[3:0], alu_src1[5:4], alu_src1[3:2]}, {alu_src1[7:6], alu_src1[1:0]}};
            else if(src2[6]) {tmp, shift} = {{alu_src2[3:0], alu_src1[7:6], alu_src1[3:2]}, {alu_src1[5:4], alu_src1[1:0]}};
            else if(src2[7]){tmp, shift} = {{alu_src2[3:0], alu_src1[5:4], alu_src1[1:0]}, {alu_src1[7:6], alu_src1[3:2]}};
            else {tmp, shift} = {8'b0, 4'b0};
            answer = shift[0] ? ({tmp[7:0],tmp[7:0]} >> (8 - shift[3:1])) : ({tmp[7:0],tmp[7:0]} >> shift[3:1]);
        end
    endcase
end
assign alu_result = answer;
endmodule

// /////////////////////////////////testbench//////////////////////////////////////
// `timescale 1ns/1ps
// module ALU_tb;

// reg [7:0] src1, src2;
// reg [11:0] op;
// wire [7:0] result;

// ALU uut (
//     .alu_src1(src1),
//     .alu_src2(src2),
//     .alu_op(op),
//     .alu_result(result)
// );

// initial begin
//     src1 = 8'h05; src2 = 8'h03; op = 12'h001; #10;//expected result: 8'h08
//     src1 = 8'h05; src2 = 8'h02; op = 12'h002; #10;//expected result: 8'h03
//     src1 = 8'h0F; src2 = 8'hF0; op = 12'h004; #10;//expected result: 8'h00
//     src1 = 8'h0F; src2 = 8'h00; op = 12'h008; #10;//expected result: 8'h01
//     src1 = 8'h01; src2 = 8'h02; op = 12'h010; #10;//expected result: 8'h04
//     src1 = 8'h80; src2 = 8'h01; op = 12'h020; #10;//expected result: 8'h40
//     src1 = 8'b10000001; src2 = 8'h01; op = 12'h040; #10;//expected result: 8'b11000000
//     src1 = 8'h03; src2 = 8'h04; op = 12'h080; #10;//expected result: 8'h01
//     src1 = 8'b11111111; src2 = 8'h01; op = 12'h100; #10;//expected result: 8'h00
//     src1 = 8'h0F; src2 = 8'hF0; op = 12'h400; #10;//expected result: 8'hFF
//     // special ADD
//     src1 = 8'hFF; src2 = 8'h01; op = 12'h200; #10;//expected result: 8'b10000000
//     // complex operation
//     src1 = 8'b1011_0110; src2 = 8'b1100_1110 ; op = 12'h800; #10; //expected result: 8'b1101_0011
//     $display("result:%b", result);
//     $finish;
// end

// endmodule