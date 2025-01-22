module uartTransmitter(
    input  wire         clk,         // System clock
    input  wire         rst,         // Reset signal
    output reg          tx,          // UART transmit signal
    input  wire [7:0]   wdata,       // Data to transmit
    input  wire         wvalid       // Data valid signal
);

    // Internal registers
    reg [8:0] divider_1;              // Divider for bit timing
    reg [7:0] locker_wdata;           // Data to transmit
    reg locker_wvalid;                // Holds valid data for transmission
    reg wvalid_delay;                 // Delayed version of wvalid
    reg [4:0] write_counter;          // Bit counter for transmission
    reg [3:0] cnt;                    // Bit position for transmission
    reg wdone;                        // Flag for transmission done

    wire b_clk;                       // Bit clock signal
    wire s_clk;                       // Sample clock signal

    // Bit clock: active when divider reaches a certain threshold
    assign b_clk = (divider_1 == 9'd485);    // Adjust divider for desired baud rate
    assign s_clk = (write_counter == 5'd16); // Sample clock after 16 bits

    // Delay the wvalid signal to properly latch the data
    always @(posedge clk) begin
        wvalid_delay <= wvalid;
    end

    // Latch the data to be transmitted when wvalid goes high
    always @(posedge clk) begin
        if (rst) 
            locker_wdata <= 8'd0;
        else if (~wvalid & wvalid_delay)
            locker_wdata <= wdata;
    end

    // Latch the valid flag to indicate data is ready to be transmitted
    always @(posedge clk) begin
        if (rst)
            locker_wvalid <= 1'b0;
        else if (wvalid & wvalid_delay)
            locker_wvalid <= 1'b1;
        else if (wdone)
            locker_wvalid <= 1'b0;
    end

    // Divider logic for generating bit clock
    always @(posedge clk) begin
        if (rst)
            divider_1 <= 9'd0;
        else
            divider_1 <= divider_1 + 9'd1;
    end

    // Control write counter for tracking the transmission state
    always @(posedge clk) begin
        if (rst || (wdone && s_clk))
            write_counter <= 5'd0;
        else if (s_clk)
            write_counter <= write_counter + 5'd1;
        else if (b_clk)
            write_counter <= 5'd0;
    end

    // Control transmission of the data
    always @(posedge clk) begin
        if (rst)
            cnt <= 4'd0;
        else if (s_clk && (cnt != 4'd9))
            cnt <= cnt + 4'd1;
        else if (cnt == 4'd9 && s_clk)
            cnt <= 4'd0;
    end

    // Transmit the data byte via the UART transmission line
    always @(posedge clk) begin
        if (rst)
            tx <= 1'b1;  // Idle state of UART (high)
        else if (s_clk) begin
            case (cnt)
                4'd0:  tx <= 1'b0;              // Start bit
                4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8: 
                    tx <= locker_wdata[cnt - 4'd1]; // Transmit data bits
                4'd9:  tx <= 1'b1;              // Stop bit
                default: tx <= 1'b1;
            endcase
        end
    end

    // Set the wdone flag when the byte is fully transmitted
    always @(posedge clk) begin
        if (rst)
            wdone <= 1'b0;
        else if (cnt == 4'd9 && s_clk)
            wdone <= 1'b1;
    end

endmodule // uartTransmitter
