module clkDiv(
  input wire clk100MHz,   
  input wire rst,
  output wire clk500Hz,  // N1 = 2*10^5
  output wire clk1250Hz  // N2 = 8*10^4  actually its 1250Hz...
);
  reg [25:0] count500Hz, count1250Hz;
  reg clk500Hz_r, clk1250Hz_r;
  parameter N1 = 200000;
  parameter N2 = 80000;
  initial begin
    clk500Hz_r = 0;
    clk1250Hz_r = 0;
  end
  always @(posedge clk100MHz) begin
    if (rst) begin
      count500Hz <= 0;
      count1250Hz <= 0;
    end
    else begin
      if (count500Hz < N1-1)
        count500Hz <= count500Hz + 1;
      else begin
        count500Hz <= 0;
        clk500Hz_r <= ~clk500Hz_r;
      end

      if (count1250Hz < N2-1)
        count1250Hz <= count1250Hz + 1;
      else begin
        count1250Hz <= 0;
        clk1250Hz_r <= ~clk1250Hz_r;
      end
    end
  end
  assign clk500Hz = clk500Hz_r;
  assign clk1250Hz = clk1250Hz_r;
endmodule //tested ok