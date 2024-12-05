module response(
    input clk,            // 100MHz clock input
    input rst,            // Reset signal
    input stimulated,     // Start ticking
    input break,          // Stop ticking
    output [3:0] pos,     // 7-segment digit position
    output [7:0] response, // 7-segment segment data
    output randomtick
);
    wire clk500Hz, clk1250Hz;
    reg [7:0] cnt_r;
    reg [1:0] state;
    parameter IDLE = 2'b00, TICKING = 2'b01, DISPLAY = 2'b10;

    stimulate_tick stim_tick(
       .clk(clk500Hz),
       .rst(rst),
       .stimulated(stimulated),
       .randomtick(randomtick)
    );

    clkDiv clk_div(
        .clk100MHz(clk),
        .rst(rst),
        .clk500Hz(clk500Hz),
        .clk1250Hz(clk1250Hz)
    );

    segMsg seg_msg(
        .clk500Hz(clk500Hz),
        .rst(rst),
        .dataBus(cnt_r),
        .pos(pos),
        .seg(response)
    );

    always @(posedge clk1250Hz or posedge rst) begin
        if (rst) begin
            cnt_r <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (randomtick) state <= TICKING;
                    cnt_r <= 0;
                end
                TICKING: begin
                    if (break) state <= DISPLAY;
                    else if (cnt_r < 99) cnt_r <= cnt_r + 1;
                end
                DISPLAY: begin
                    if (rst) state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule