
module key_filter(
    input wire clk,
    input wire rst_n,
    input wire key_in,
    output reg key_flag
);
    reg [2:0] key_state;
    reg key_last;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_state <= 3'b000;
            key_flag <= 1'b0; 
            key_last <= 1'b1; 
        end else begin
            key_last <= key_in;

            if (key_in == key_last) begin
                key_state <= {key_state[1:0], key_in};
            end
            else begin
                key_state <= 3'b000;
            end
            if (key_state == 3'b111 && !key_in) begin
                key_flag <= 1'b1;
            end 
            else begin
                key_flag <= 1'b0;
            end
        end
    end
endmodule
