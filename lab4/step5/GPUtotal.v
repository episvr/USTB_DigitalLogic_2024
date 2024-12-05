
module GPU_total(
    input wire clk100MHz,
    input wire clk3Hz,
    input wire rst,
    input wire [15:0] updatedata,
    output wire [15:0] data_high,
    output wire [15:0] data_low
);
    GPU_high GPU_high_inst(
       .clk100MHz(clk100MHz),
       .clk3Hz(clk3Hz),
       .rst(rst),
       .dataBus(data_high)
    );
    assign data_low = updatedata;
endmodule


module GPU_high(
    input wire clk100MHz, 
    input wire clk3Hz,    
    input wire rst,        
    output reg [15:0] dataBus
);
    reg [3:0] cnt;    
    reg [3:0] cnt_h;    
    reg [3:0] cnt_l;  
    parameter NUMBER = 8'hAB; 

    always @(*) begin
        dataBus = {NUMBER, cnt_h, cnt_l};
    end

    always @(posedge clk3Hz or posedge rst) begin
        if (rst) begin
            cnt <= 0;
            cnt_h <= 0;
            cnt_l <= 0;
        end else if (cnt == 10) begin
            cnt <= 0;
            cnt_h <= 1;
            cnt_l <= 0;
        end else begin
            cnt <= cnt + 1;
            cnt_h <= cnt / 10;
            cnt_l <= cnt % 10;
        end
    end
endmodule