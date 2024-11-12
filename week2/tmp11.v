// 2024.9.23 Epi Week 2 code 11
// target: swap circuit
module swap(
    input wire io_i1,
    input wire io_i2,
    input wire io_s,
    output reg io_o1,
    output reg io_o2
);
always @(*) begin
    if (io_s) begin
        io_o1 = io_i2;
        io_o2 = io_i1;
    end else begin
        io_o1 = io_i1;
        io_o2 = io_i2;    
    end
end
endmodule