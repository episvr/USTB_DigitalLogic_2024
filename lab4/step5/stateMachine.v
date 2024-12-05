module stateMachine(
    input wire clk,
    input wire rst,
    input wire confirm_in,
    input wire [3:0] in_data,
    output wire [15:0] data_low,
    output reg [3:0] signal_led
);
    reg [2:0] state;
    reg [3:0] input_buffer[3:0];
    integer i;
    localparam IDLE = 3'b000, 
               INPUT1 = 3'b001, 
               INPUT2 = 3'b010, 
               INPUT3 = 3'b011, 
               INPUT4 = 3'b100, 
               DISPLAY = 3'b101;
    assign data_low = {input_buffer[3], input_buffer[2], input_buffer[1], input_buffer[0]};
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            signal_led <= 4'b0000;
            for (i = 0; i < 4; i = i + 1)
                input_buffer[i] <= 4'hF;
        end else begin
            case (state)
                IDLE: begin
                    signal_led <= 4'b0000;
                    if (confirm_in)
                        state <= INPUT1;
                end
                INPUT1: begin
                    signal_led <= 4'b0001;
                    if (confirm_in) begin
                        input_buffer[0] <= in_data;
                        state <= INPUT2;
                    end
                end
                INPUT2: begin
                    signal_led <= 4'b0010;
                    if (confirm_in) begin
                        input_buffer[1] <= in_data;
                        state <= INPUT3;
                    end
                end
                INPUT3: begin
                    signal_led <= 4'b0100;
                    if (confirm_in) begin
                        input_buffer[2] <= in_data;
                        state <= INPUT4;
                    end
                end
                INPUT4: begin
                    signal_led <= 4'b1000;
                    if (confirm_in) begin
                        input_buffer[3] <= in_data;
                        state <= DISPLAY;
                    end
                end
                DISPLAY: begin
                    signal_led <= 4'b1111;
                    if (confirm_in) begin
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule