module stimulate_tick(
    input clk,
    input rst,
    input stimulated, 
    output reg randomtick
);
    reg [15:0] counter;
    reg [7:0] lfsr;
    wire feedback;
    reg [15:0] random_delay;

    assign feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            randomtick <= 0;
            lfsr <= 8'h1;
            counter <= 0; 
            random_delay <= 16'hFFFF;
        end else if (stimulated) begin
            lfsr <= {lfsr[6:0], feedback}; // Shift LFSR to update random sequence
            random_delay <= {lfsr, 8'h00}; // Generate a 16-bit random delay from LFSR

            if (counter < random_delay) begin
                counter <= counter + 1;
            end else begin
                randomtick <= 1;
            end
        end else begin
            counter <= 0;
            randomtick <= 0;
        end
    end
endmodule
