// 2024.9.23 Epi Week 2 code 4
// target: NOR gate
module top_module(input a, input b, output out);
    assign out = ~(a|b);
endmodule