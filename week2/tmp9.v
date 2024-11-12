// 2024.9.23 Epi Week 2 code 9
// target: simulate circuit1
module top_module (
    input in1,
    input in2,
    input in3,
    output out);
    wire w1 = ~(in1 ^ in2);
    assign out = w1 ^ in3;
endmodule