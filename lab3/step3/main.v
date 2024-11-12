module lock(
    input clk,        
    input rst,       
    input in,
    output reg unlock 
);

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100; 

reg [2:0] current_state, next_state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        current_state <= S0;
        unlock <= 0;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        S0: next_state = (in == 1'b0) ? S1 : S0;
        S1: next_state = (in == 1'b0) ? S2 : S0;
        S2: next_state = (in == 1'b1) ? S3 : S2;
        S3: next_state = (in == 1'b0) ? S4 : S0;
        S4: next_state = S4;
        default: next_state = S0; 
    endcase
end


always @(posedge clk or posedge rst) begin
    if (rst) begin
        unlock <= 0;
    end else if (current_state == S4) begin
        unlock <= 1;
    end
end

endmodule
