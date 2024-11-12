module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah );
    reg walkstate, downstate;
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    parameter AHAH = 1'b0;
    parameter Normal = 1'b1;
    always@(posedge clk or posedge areset) begin
        if(areset) begin
            walkstate = LEFT;
            downstate = Normal;
        end
        if(!ground) begin
            walkstate <= walkstate;
            downstate <= AHAH;
        end
        else begin
            downstate <= Normal;
            if(downstate==Normal) begin
                case({bump_left, bump_right})
                    2'b00: walkstate <= walkstate;
                    2'b01: walkstate <= LEFT;
                    2'b10: walkstate <= RIGHT;
                    2'b11: walkstate <=(walkstate==LEFT)?RIGHT:LEFT;
                endcase
            end
        end
    end
    assign aaah = (downstate==AHAH)?1'b1:1'b0;
    assign walk_left = (downstate==Normal)?(walkstate==LEFT):1'b0;
    assign walk_right = (downstate==Normal)?(walkstate==RIGHT):1'b0;
endmodule