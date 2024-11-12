module top_module (
    input x, 
    input y, 
    output z
);
wire z1, z2;
    A IA1(
        .x(x),
       .y(y),
       .z(z1)
    );
    B IB1(
        .x(x),
       .y(y),
       .z(z2)
    );
    assign z = (z1 || z2)^(z1 && z2);

endmodule