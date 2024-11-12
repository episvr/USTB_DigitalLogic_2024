// 2024.9.23 Epi Week 2 code 10
// target: simulate circuit2
module top_module (
    input in1,
    input in2,
    output out);
    assign out = in1 & ~in2;
endmodule