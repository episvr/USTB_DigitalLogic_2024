module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging);
    reg [4:0] falling_time;
    reg [1:0] walkstate, downstate;
    parameter LEFT = 2'b00;
    parameter RIGHT = 2'b01;
    parameter AHAH = 2'b10;
    parameter NORMAL = 2'b11;
    parameter DIGGING = 2'b01;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walkstate <= LEFT;
            downstate <= NORMAL;
            falling_time <= 0;
        end
        else if (!ground) begin
            walkstate <= walkstate;
            downstate <= AHAH;
            if(falling_time <= 20) begin
                falling_time <= falling_time + 1;
            end
        end
        else if (downstate == DIGGING) begin
            downstate <= DIGGING;
            if (!ground) begin
                downstate <= AHAH;
            end
        end
        else begin
            downstate <= NORMAL;
            if (downstate == NORMAL) begin
                if (dig) begin
                    downstate <= DIGGING;
                end else begin
                    case ({bump_left, bump_right})
                        2'b00: walkstate <= walkstate;
                        2'b01: walkstate <= LEFT;
                        2'b10: walkstate <= RIGHT;
                        2'b11: walkstate <= (walkstate == LEFT) ? RIGHT : LEFT;
                    endcase
                end
            end
        end
    end

    assign digging = (downstate == DIGGING) ? 1'b1 : 1'b0;
    assign aaah = (downstate == AHAH) ? 1'b1 : 1'b0;
    assign walk_left = (downstate == NORMAL&&falling_time <= 20) ? (walkstate == LEFT) : 1'b0;
    assign walk_right = (downstate == NORMAL&&falling_time <= 20) ? (walkstate == RIGHT) : 1'b0;
endmodule