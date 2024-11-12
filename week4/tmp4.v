module top_module (
    input clk,
    input reset,
    output reg [3:0] q
);
    initial begin
        q = 1;
    end
  
    always @(posedge clk) begin
        if (reset) 
            q = 1;
        else if (q == 9) 
            q = 0;
        else 
            q <= q + 1;
    end
endmodule
