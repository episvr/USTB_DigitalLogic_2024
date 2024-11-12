module top_module (
    input [7:0] a, b, c, d,
    output [7:0] min
);
wire [7:0] minab, mindc;
assign minab = (a < b)? a : b;
assign mindc = (c < d)? c : d;
assign min = (minab < mindc)? minab : mindc;
endmodule