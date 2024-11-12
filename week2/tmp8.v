// 2024.9.23 Epi Week 2 code 8
// target: module 7548

module top_module ( 
    input p1a, p1b, p1c, p1d, p1e, p1f,
    output p1y,

    input p2a, p2b, p2c, p2d,
    output p2y);

    wire w1 = p1a & p1b & p1c;
    wire w2 = p1d & p1e & p1f;
    wire w3 = w1 | w2;
    wire w4 = p2a & p2b;
    wire w5 = p2c & p2d;
    wire w6 = w4 | w5;
    assign p1y = w3;
    assign p2y = w6;
endmodule