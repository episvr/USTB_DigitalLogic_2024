module clkDiv #(parameter DIV190HZ = 17, DIV3HZ = 29)(
    input wire clk100MHz,
    input wire rst,
    output wire clk190Hz,
    output wire clk3Hz
);
    reg [30:0] cnt;
    assign clk190Hz = cnt[DIV190HZ - 1];
    assign clk3Hz = cnt[DIV3HZ - 1];
    always @(posedge clk100MHz or posedge rst) begin
        if (rst)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end
endmodule