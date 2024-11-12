module top_module (
    input clk,
    input reset,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q);
    reg [3:0] count;
    always @(posedge clk) begin
        if (reset)
            count <= 0;
        if (count_ena)
            count <= count - 1;
        if (shift_ena)
            count <= {count[2:0],data};
    end
    assign q = count;
endmodule