module segMsg(
    input clk,
    input [3:0] show,
    input [7:0] pos,
    output reg [6:0] seg1,
    output reg [6:0] seg2
);
    always @ (posedge clk) begin 
        if(pos <= 8'b0000_1000) begin
            case (show)
                4'd0: seg1 = 7'b0111111; 
                4'd1: seg1 = 7'b0000110; 
                4'd2: seg1 = 7'b1011011; 
                4'd3: seg1 = 7'b1001111; 
                4'd4: seg1 = 7'b1100110; 
                4'd5: seg1 = 7'b1101101; 
                4'd6: seg1 = 7'b1111101; 
                4'd7: seg1 = 7'b0000111; 
                4'd8: seg1 = 7'b1111111; 
                4'd9: seg1 = 7'b1101111; 
                default: seg1 = 7'b0111111; 
            endcase    
        end  
        else begin
            case (show)
                4'd0: seg2 = 7'b0111111; 
                4'd1: seg2 = 7'b0000110; 
                4'd2: seg2 = 7'b1011011; 
                4'd3: seg2 = 7'b1001111; 
                4'd4: seg2 = 7'b1100110; 
                4'd5: seg2 = 7'b1101101; 
                4'd6: seg2 = 7'b1111101; 
                4'd7: seg2 = 7'b0000111; 
                4'd8: seg2 = 7'b1111111; 
                4'd9: seg2 = 7'b1101111; 
                default: seg2 = 7'b0111111; 
            endcase            
        end  
    end
endmodule
