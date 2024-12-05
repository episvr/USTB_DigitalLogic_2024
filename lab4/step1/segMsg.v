module segMsg(
  input wire clk190Hz,
  input wire rst,
  input wire [7:0] dataBus,
  output reg [3:0] pos,
  output reg [7:0] seg
);
  wire [3:0] ten = dataBus/10;
  wire [3:0] one = dataBus%10;
  reg [3:0] dataP;

  always @(posedge clk190Hz) begin
    if (rst) begin
      pos <= 4'b0001;
      dataP <= 4'h0;
    end else begin
      case (pos)
        4'b0001: begin
          pos <= 4'b0010;
          dataP <= ten;
        end
        4'b0010: begin
          pos <= 4'b0001;
          dataP <= one;
        end
        default : begin
          pos <= 4'b0001;
          dataP <= 4'h0;
        end
      endcase
    end
  end

  always @(dataP) begin
    case (dataP)
      0: seg = 8'b0011_1111;
      1: seg = 8'b0000_0110;
      2: seg = 8'b0101_1011;
      3: seg = 8'b0100_1111;
      4: seg = 8'b0110_0110;
      5: seg = 8'b0110_1101;
      6: seg = 8'b0111_1101;
      7: seg = 8'b0000_0111;
      8: seg = 8'b0111_1111;
      9: seg = 8'b0110_1111;
      10: seg = 8'b0100_0000;
      11: seg = 8'b0000_0000;
      default: seg = 8'b0000_1000;
    endcase
  end
endmodule