module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right);
    reg state;
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    always@(posedge clk or posedge areset) begin
        if(areset) begin
            state = 0;    
        end
        case({bump_left, bump_right})
            2'b00: state <= state;
            2'b01: state <= LEFT;
            2'b10: state <= RIGHT;
            2'b11: state <= (state==LEFT)?RIGHT:LEFT;
        endcase
    end
    assign walk_left = (state==LEFT);
    assign walk_right = (state==RIGHT);
endmodule