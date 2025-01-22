module baudgen
(
    input wire clk,
    input wire rst_n,
    output reg bit_flag
);
    parameter BAUD_CNT_MAX = 100_000_000 / 9600;
    reg [13:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            bit_flag <= 0;
        end else if (cnt == BAUD_CNT_MAX - 1) begin
            cnt <= 0;
            bit_flag <= 1;
        end else begin
            cnt <= cnt + 1;
            bit_flag <= 0;
        end
    end
endmodule

module uart_tx
(
    input wire clk,
    input wire rst_n,
    input wire bit_flag,
    input wire [7:0] data_in,
    input wire start,
    output reg tx,
    output reg busy
);
    reg [3:0] bit_cnt;
    reg [9:0] tx_shift;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx <= 1;
            bit_cnt <= 0;
            tx_shift <= 10'b1111111111;
            busy <= 0;
        end else if (start && !busy) begin
            tx_shift <= {1'b1, data_in, 1'b0};
            bit_cnt <= 0;
            busy <= 1;
        end else if (busy && bit_flag) begin
            tx <= tx_shift[0];
            tx_shift <= {1'b1, tx_shift[9:1]};
            bit_cnt <= bit_cnt + 1;
            if (bit_cnt == 4'd9) begin
                busy <= 0;
                tx <= 1;
            end
        end
    end
endmodule

module uart_rx
(
    input wire clk,
    input wire rst_n,
    input wire bit_flag,
    input wire rx,
    output reg [7:0] data_out,
    output reg data_ready
);
    reg [3:0] bit_cnt;
    reg [7:0] rx_shift;
    reg busy;
    reg start_bit_detected;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 0;
            rx_shift <= 0;
            busy <= 0;
            data_ready <= 0;
            start_bit_detected <= 0;
        end else if (!busy && !rx) begin
            busy <= 1;
            start_bit_detected <= 1;
            bit_cnt <= 0;
            data_ready <= 0;
        end else if (busy && bit_flag) begin
            if (start_bit_detected) begin
                start_bit_detected <= 0;
            end else begin
                rx_shift <= {rx, rx_shift[7:1]};
                bit_cnt <= bit_cnt + 1;

                if (bit_cnt == 4'd8) begin
                    data_out <= rx_shift;
                    data_ready <= 1;
                    busy <= 0;
                end
            end
        end else if (data_ready) begin
            data_ready <= 0;
        end
    end
endmodule

module uart_top
(
    input wire clk,            
    input wire rst_n,
    input wire rx,
    input wire [7:0] tx_data,
    input wire tx_start,
    output wire tx,
    output wire [7:0] rx_data,
    output wire tx_busy,
    output wire rx_ready
);
    wire bit_flag;
    baudgen baudgen_inst (
        .clk(clk),
        .rst_n(rst_n),
        .bit_flag(bit_flag)
    );
    uart_tx uart_tx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .bit_flag(bit_flag),
        .data_in(tx_data),
        .start(tx_start),
        .tx(tx),
        .busy(tx_busy)
    );
    uart_rx uart_rx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .bit_flag(bit_flag),
        .rx(rx),
        .data_out(rx_data),
        .data_ready(rx_ready)
    );
endmodule

