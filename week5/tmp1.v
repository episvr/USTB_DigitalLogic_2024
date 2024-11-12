module mealy(
    input wire clk,
    input wire areset,
    input wire in,
    output wire out
);
reg state = 0;

always @(*) begin
    if(areset) begin
        state = 0;    
    end
end
always @(posedge clk) begin
    state <= in;
end
assign out = (in==1&&state==1)?1:0;
endmodule