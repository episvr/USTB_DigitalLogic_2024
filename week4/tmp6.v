module top_module (
    input clk,
    input reset,
    output [3:0] q);
    reg [3:0] d;
    always @(posedge clk) begin
        if (reset)
            d <= 0;
        else
            d <= d + 1;
    end
    assign q = d;
endmodule