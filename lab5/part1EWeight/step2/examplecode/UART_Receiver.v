module uartReceiver(
    input  wire         clk,         // System clock
    input  wire         rst,         // Reset signal
    input  wire         rx,          // UART receive signal

    output wire [7:0]   rdata,       // Received data
    output reg          rvalid       // Valid data flag
);

    // Internal registers
    reg [8:0] divider_1;
    reg [4:0] state, next_state;
    reg [7:0] locker_rdata;  // Register for the received data
    reg rx_delay;             // Delayed version of rx for sampling
    reg [4:0] read_counter;
    reg [15:0] first_counter;
    reg [399:0] filter_buffer;   // Filter buffer for rx signal
    reg [10:0] ones_counter;     // Count of ones in the filter buffer

    wire discard_is_one;
    wire add_is_one;

    // Counter to track the number of bits received
    reg [3:0] cnt = 0;
    
    integer i;
    
    // Calculate the number of ones in filter buffer
    always @(*) begin
        ones_counter = 0;
        for(i = 0; i < 400; i = i + 1) begin
            ones_counter = ones_counter + filter_buffer[i];
        end
    end

    // Clocks for bit timing
    wire b_clk = (divider_1 == 9'd485);    // Bit clock
    wire s_clk = (read_counter == 5'd16);  // Sample clock

    // Read start signal, triggered when conditions are met
    wire read_start = rx_filtered && (first_counter == 0);

    assign rdata = locker_rdata;

    // Filter the RX signal (debounce/filter noisy input)
    always @(posedge clk) begin
        if (rst) begin
            filter_buffer <= {400{1'b1}};  // Reset the filter buffer
        end else begin
            filter_buffer <= {filter_buffer[398:0], rx};  // Shift RX signal into buffer
        end
    end

    // Determine the filtered value based on the majority of ones
    wire rx_filtered = (ones_counter > 350) ? 1'b1 : 1'b0;

    // Divider to create bit-clock timing
    always @(posedge clk) begin
        if (rst || (divider_1 == 9'd485) || read_start) begin
            divider_1 <= 0;
        end else begin
            divider_1 <= divider_1 + 1;
        end
    end

    // Counter for first bit reception (start bit detection)
    always @(posedge clk) begin
        if (rst || (first_counter == 16'd3888)) begin
            first_counter <= 0;
        end else if (read_start) begin
            first_counter <= 1;
        end else if (first_counter != 0) begin
            first_counter <= first_counter + 1;
        end
    end

    // Delay the RX signal for proper edge sampling
    always @(posedge clk) begin
        if (rst) begin
            rx_delay <= 0;
        end else begin
            rx_delay <= rx;
        end
    end

    // Read counter logic to track bit positions
    always @(posedge clk) begin
        if (rst || s_clk || (first_counter == 16'd3888)) begin
            read_counter <= 0;
        end else if (b_clk) begin
            read_counter <= read_counter + 1;
        end
    end

    // State machine to handle receiving the data byte
    always @(posedge clk) begin
        if (rst || (rvalid && s_clk)) begin
            cnt <= 0;
        end else if ((state == 5'b00001) && (cnt != 4'd7)) begin
            cnt <= cnt + 1;
        end else if ((cnt == 4'd7) && s_clk) begin
            cnt <= 0;
        end else if (s_clk) begin
            cnt <= 0;
        end
    end

    // State machine to manage UART data reception
    always @(posedge clk) begin
        if (rst) begin
            state <= 5'b00000;
        end else begin
            state <= next_state;
        end
    end

    // Define the next state based on current state and other conditions
    always @(*) begin
        case(state)
            5'b00000: next_state = read_start ? 5'b00001 : 5'b00000;  // Idle state
            5'b00001: next_state = (cnt == 4'd7) ? 5'b00000 : 5'b00001;  // Receiving data
            default: next_state = 5'b00000;
        endcase
    end

    // Load data into locker when it's fully received
    always @(posedge clk) begin
        if (rst || (cnt == 4'd7) || (state == 5'b00000)) begin
            locker_rdata <= 0;
        end else if (state == 5'b00001) begin
            locker_rdata <= {rx_delay, locker_rdata[7:1]};  // Shift in received bit
        end
    end

    // Set the rvalid signal when a byte is fully received
    always @(posedge clk) begin
        if (rst) begin
            rvalid <= 0;
        end else if (cnt == 4'd7 && s_clk) begin
            rvalid <= 1;
        end else if (rvalid && s_clk) begin
            rvalid <= 0;
        end
    end

endmodule // uartReceiver
