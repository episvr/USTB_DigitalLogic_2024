`timescale 1ns / 1ps

module CPU(
    input clk,
    input rst_n,
    input [7:0] op,
    input [7:0] Data,
    input prog_done,
    output reg [7:0] pos,
    output reg [6:0] seg1,
    output reg [6:0] seg2 
);
    wire rst;
    assign rst = ~rst_n;
    wire clk_bps;

    reg [7:0] R [3:0];
    reg [15:0] dict[31:0];
    wire set;
    reg [3:0] PC;
    reg [3:0] num;

    keyfilter Setfilter(clk, rst, prog_done, set);
    clkDiv ClkDiv(clk, rst, clk_bps);
    segMsg segMsg(clk,num, pos, seg1, seg2);

    //alu
    always @ (posedge rst or posedge clk) begin
        if(rst) begin
            PC <= 0;
            num <= 0;
            pos <= 8'b00000001;
            {R[0], R[1], R[2], R[3]} <= 0;
            {dict[ 0], dict[ 1], dict[ 2], dict[ 3], dict[ 4], 
             dict[ 5], dict[ 6], dict[ 7], dict[ 8], dict[ 9],
             dict[10], dict[11], dict[12], dict[13], dict[14],
             dict[15], dict[16], dict[17], dict[18], dict[19],
             dict[20], dict[21], dict[22], dict[23], dict[24],
             dict[25], dict[26], dict[27], dict[28], dict[29], dict[30], dict[31]} <= 0;
        end
        else if(clk) begin
            if(set) begin
                case(op[7:4])
                    4'b0000: begin // LOAD
                        R[op[3:2]] <= Data;
                        dict[PC+1] <= Data;
                        PC <= PC + 1;
                    end
                    4'b0001: begin  //MOV
                        R[op[3:2]] <= R[op[1:0]];
                        dict[PC+1] <= R[op[1:0]];
                        PC <= PC + 1;
                    end 
                    4'b0010: begin  //ADD
                        R[op[3:2]] <= R[op[3:2]] + R[op[1:0]];
                        dict[PC+1] <= R[op[3:2]] + R[op[1:0]];
                        PC <= PC + 1;;
                    end 
                    4'b0011: begin //SUB
                        R[op[3:2]] <= R[op[3:2]] - R[op[1:0]];
                        dict[PC+1] <= R[op[3:2]] - R[op[1:0]];
                        PC <= PC + 1;
                    end
                    4'b0100: begin //MUL
                        //dict[PC+1] <= R[op[3:2]] * R[op[1:0]];
                        dict[PC+1] <= (R[op[1:0]][0] ? R[op[3:2]]<<0 : 0) + 
                                      (R[op[1:0]][1] ? R[op[3:2]]<<1 : 0) +
                                      (R[op[1:0]][2] ? R[op[3:2]]<<2 : 0) +
                                      (R[op[1:0]][3] ? R[op[3:2]]<<3 : 0) +
                                      (R[op[1:0]][4] ? R[op[3:2]]<<4 : 0) +
                                      (R[op[1:0]][5] ? R[op[3:2]]<<5 : 0) +
                                      (R[op[1:0]][6] ? R[op[3:2]]<<6 : 0) +
                                      (R[op[1:0]][7] ? R[op[3:2]]<<7 : 0) ;
                        PC <= PC + 1;
                    end
                    default: ;
                endcase
            end

            //num 
            if(clk_bps) begin
                pos <= (pos << 1) | (pos >> 7);
            end
            if(op[7:4] == 4'b1111) begin
                case(pos)
                    8'b00000001: num <= dict[op[3:0]]%10;
                    8'b00000010: num <= dict[op[3:0]]/10%10;
                    8'b00000100: num <= dict[op[3:0]]/100%10;
                    8'b00001000: num <= dict[op[3:0]]/1000%10;
                    8'b00010000: num <= dict[op[3:0]]/10000;
                    8'b00100000: num <= op[3:0]%10;
                    8'b01000000: num <= op[3:0]/10%10;
                    8'b10000000: num <= op[3:0]/100;
                    default: num <= 0;
                endcase
            end   
            else begin
                num <= 0;
            end       
        end
    end
endmodule

