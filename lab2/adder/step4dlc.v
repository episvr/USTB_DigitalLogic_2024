module carry_select_adder32(
    input [31:0] a,
    input [31:0] b,
    input cin,
    output [31:0] sum,
    output cout
);
    wire [15:0] sum0, sum1;
    wire cout0, cout1;
    carry_select_adder16 U1 (
        .a(a[15:0]), 
        .b(b[15:0]), 
        .cin(cin), 
        .sum(sum[15:0]), 
        .cout(cout0)
    );
    carry_select_adder16 U2 (
        .a(a[31:16]), 
        .b(b[31:16]), 
        .cin(1'b0), 
        .sum(sum0), 
        .cout(cout1)
    );
    carry_select_adder16 U3 (
        .a(a[31:16]), 
        .b(b[31:16]), 
        .cin(1'b1), 
        .sum(sum1), 
        .cout(cout)
    );
    assign sum[31:16] = (cout0 == 1'b0) ? sum0 : sum1;

endmodule
module carry_select_adder16(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
    wire [7:0] sum0, sum1;
    wire cout0, cout1;

    ripple_carry_adder8 U1 (
        .a(a[7:0]), 
        .b(b[7:0]), 
        .cin(cin), 
        .sum(sum[7:0]), 
        .cout(cout0)
    );
    ripple_carry_adder8 U2 (
        .a(a[15:8]), 
        .b(b[15:8]), 
        .cin(1'b0), 
        .sum(sum0), 
        .cout(cout1)
    );
    ripple_carry_adder8 U3 (
        .a(a[15:8]), 
        .b(b[15:8]), 
        .cin(1'b1), 
        .sum(sum1), 
        .cout(cout)
    );
    assign sum[15:8] = (cout0 == 1'b0) ? sum0 : sum1;

endmodule
module ripple_carry_adder8 (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [7:0] p, g, c;
    
    assign p = a ^ b;
    assign g = a & b;
    
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    
    assign sum = p ^ c;
    assign cout = g[7] | (p[7] & c[7]);
    
endmodule