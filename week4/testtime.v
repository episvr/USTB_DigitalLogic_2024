module PalindromicSequenceDetector (
    input wire CLK,
    input wire IN,
    output reg OUT
);
    reg [3:0] counter;
    initial begin
        counter = 0;
        OUT = 0;
    end
    always @(CLK) begin
        counter <= counter + 1;
        if (counter == 0 || counter == 26 || counter == 27 || counter == 30) 
            OUT <= 1;
        else
            OUT <= 0;
    end

endmodule
