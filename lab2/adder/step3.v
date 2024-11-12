// created by epi
// date: 2021-09-15 15:49:53
`timescale 1ns / 1ps
module rcadd32 (
    input  wire [31: 0] a,
    input  wire [31: 0] b,
    input  wire cin,
    output wire [31: 0] s,
    output wire cout
);
    wire [31: 0] c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18, c19, c20, c21, c22, c23, c24, c25, c26, c27, c28, c29, c30, c31, c32;
    add1 add1_0 (a[0], b[0], cin, s[0], c1[0]);
    add1 add1_1 (a[1], b[1], c1[0], s[1], c2[1]);
    add1 add1_2 (a[2], b[2], c2[1], s[2], c3[2]);
    add1 add1_3 (a[3], b[3], c3[2], s[3], c4[3]);
    add1 add1_4 (a[4], b[4], c4[3], s[4], c5[4]);
    add1 add1_5 (a[5], b[5], c5[4], s[5], c6[5]);
    add1 add1_6 (a[6], b[6], c6[5], s[6], c7[6]);
    add1 add1_7 (a[7], b[7], c7[6], s[7], c8[7]);
    add1 add1_8 (a[8], b[8], c8[7], s[8], c9[8]);
    add1 add1_9 (a[9], b[9], c9[8], s[9], c10[9]);
    add1 add1_10 (a[10], b[10], c10[9], s[10], c11[10]);
    add1 add1_11 (a[11], b[11], c11[10], s[11], c12[11]);
    add1 add1_12 (a[12], b[12], c12[11], s[12], c13[12]);
    add1 add1_13 (a[13], b[13], c13[12], s[13], c14[13]);
    add1 add1_14 (a[14], b[14], c14[13], s[14], c15[14]);
    add1 add1_15 (a[15], b[15], c15[14], s[15], c16[15]);
    add1 add1_16 (a[16], b[16], c16[15], s[16], c17[16]);
    add1 add1_17 (a[17], b[17], c17[16], s[17], c18[17]);
    add1 add1_18 (a[18], b[18], c18[17], s[18], c19[18]);
    add1 add1_19 (a[19], b[19], c19[18], s[19], c20[19]);
    add1 add1_20 (a[20], b[20], c20[19], s[20], c21[20]);
    add1 add1_21 (a[21], b[21], c21[20], s[21], c22[21]);
    add1 add1_22 (a[22], b[22], c22[21], s[22], c23[22]);
    add1 add1_23 (a[23], b[23], c23[22], s[23], c24[23]);
    add1 add1_24 (a[24], b[24], c24[23], s[24], c25[24]);
    add1 add1_25 (a[25], b[25], c25[24], s[25], c26[25]);
    add1 add1_26 (a[26], b[26], c26[25], s[26], c27[26]);
    add1 add1_27 (a[27], b[27], c27[26], s[27], c28[27]);
    add1 add1_28 (a[28], b[28], c28[27], s[28], c29[28]);
    add1 add1_29 (a[29], b[29], c29[28], s[29], c30[29]);
    add1 add1_30 (a[30], b[30], c30[29], s[30], c31[30]);
    add1 add1_31 (a[31], b[31], c31[30], s[31], c32[31]);
    assign cout = c32[31];
endmodule
module add1(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
assign #4 sum = a ^ b ^ cin;
assign #2 cout =  (cin==1) | (cin==0) ? ((a & cin) | (b & cin)| (a & b)) : 1'bx;
endmodule


// //////////////testbench///////////////////
module add32_tb();
    reg [31:0]a;
    reg [31:0]b;
    reg cin;
    reg clk;
    wire [31:0]s0,s1,s2;
    wire cout0,cout1,cout2;
    initial begin
        a = 4'bxxxx;
        b = 4'bxxxx;
        cin = 1'bx;
        clk = 0;
    end
    always #100 clk = ~clk;
    always@ (posedge clk) begin
        a= {$random} % 2**30;
        b= {$random} % 2**30;
        cin = {$random} % 2;
        #150;
        cin = 1'bx; //ok，but why?
    end
    // csadd32 A(a,b,cin,s0,cout0);
    rcadd32 B(a,b,cin,s1,cout1);
endmodule