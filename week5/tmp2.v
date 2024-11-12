module top_module(
    input clk,
    input areset,
    input in,
    output out);
    
    reg state;
    parameter A = 0;
    parameter B = 1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            if (in == 0 && state == B) begin
                state <= A;
            end
            else if (in == 1 && state == B) begin
                state <= B;
            end
            else if (in == 0 && state == A) begin
                state <= B;
            end
            else if (in == 1 && state == A) begin
                state <= A;
            end
        end
    end
    assign out = state;
endmodule
