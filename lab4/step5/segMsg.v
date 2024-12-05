module segMsg(
    input wire clk190Hz,
    input wire rst,
    input wire [15:0] dataBus,
    output reg [3:0] pos,
    output reg [7:0] seg
);
    reg [1:0] posC; 
    reg [3:0] dataP; 

    always @(posedge clk190Hz or posedge rst) begin
        if (rst) begin
            posC <= 0;
            pos <= 4'b1111;
        end else begin
            posC <= posC + 1;
            case (posC)
                2'd0: {pos, dataP} <= {4'b0001, dataBus[3:0]};
                2'd1: {pos, dataP} <= {4'b0010, dataBus[7:4]};
                2'd2: {pos, dataP} <= {4'b0100, dataBus[11:8]};
                2'd3: {pos, dataP} <= {4'b1000, dataBus[15:12]};
            endcase
        end
    end

    always @(*) begin
        case(dataP)
            4'h0: seg = 8'b0011_1111;
            4'h1: seg = 8'b0000_0110;
            4'h2: seg = 8'b0101_1011;
            4'h3: seg = 8'b0100_1111;
            4'h4: seg = 8'b0110_0110;
            4'h5: seg = 8'b0110_1101;
            4'h6: seg = 8'b0111_1101;
            4'h7: seg = 8'b0000_0111;
            4'h8: seg = 8'b0111_1111;
            4'h9: seg = 8'b0110_1111;
            4'hA: seg = 8'b0101_1110;
            4'hB: seg = 8'b0111_1110;
            default: seg = 8'b0100_0000; 
        endcase
    end
endmodule