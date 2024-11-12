// created by epi
// date: 2021-09-15 15:49:53
module csadd32 (
    input  wire [31: 0] a,
    input  wire [31: 0] b,
    input  wire cin,
    output wire [31: 0] s,
    output wire cout
);
    wire c1, c2, c3, c4, c5, c6, c7, c8;
    csadd4 u1(a[3:0], b[3:0], cin, s[3:0], c1);
    csadd4 u2(a[7:4], b[7:4], c1, s[7:4], c2);
    csadd4 u3(a[11:8], b[11:8], c2, s[11:8], c3);
    csadd4 u4(a[15:12], b[15:12], c3, s[15:12], c4);
    csadd4 u5(a[19:16], b[19:16], c4, s[19:16], c5);
    csadd4 u6(a[23:20], b[23:20], c5, s[23:20], c6);
    csadd4 u7(a[27:24], b[27:24], c6, s[27:24], c7);
    csadd4 u8(a[31:28], b[31:28], c7, s[31:28], c8);
    assign cout = c8;
endmodule
module csadd4(
    input  wire [3: 0] a,
    input  wire [3: 0] b,
    input  wire cin,
    output wire [3: 0] s,
    output wire cout
);
    wire [3: 0] s1, s2;
    wire tmp1,tmp2;
    add4 u1(a, b, 1'b0, s1, tmp1);
    add4 u2(a, b, 1'b1, s2, tmp2);
    assign s = (cin == 1'b0) ? s1 : s2;
    assign cout = (cin == 1'b0) ? tmp1 : tmp2;
endmodule
module add4 (
    input  wire [3: 0] a,
    input  wire [3: 0] b,
    input  wire cin,
    output wire [3: 0] s,
    output wire cout
);
wire c1, c2, c3, c4;
add1 u1(a[0], b[0], cin, s[0], c1);
add1 u2(a[1], b[1], c1, s[1], c2);
add1 u3(a[2], b[2], c2, s[2], c3);
add1 u4(a[3], b[3], c3, s[3], c4);
assign cout = c4;
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

// ///////////// testbench /////////////
// module test_csadd32;
//     reg [31:0] a;
//     reg [31:0] b;
//     reg cin;
//     wire [31:0] s;
//     wire cout;
//     csadd32 uut (
//         .a(a), 
//         .b(b), 
//         .cin(cin), 
//         .s(s), 
//         .cout(cout)
//     );
//     initial begin
//         a = 32'h00000000; b = 32'h00000000; cin = 1'b0;
//         #20; 
//         a = 32'hFFFFFFFF; b = 32'h00000001; cin = 1'b0;
//         #20;
//         a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; cin = 1'b1;
//         #20;
//         a = 32'hA3F5C9D7; b = 32'h4B6E89A2; cin = 1'b1;
//         #20;
//         $finish;
//     end
// endmodule