module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q
);
reg [3:0] D;

always @(posedge clk) begin
    if (reset) D <= 1;
    else if (enable) begin
        if (D == 12) D <= 1;
        else D <= D + 1;
    end
end
assign Q = D;
endmodule