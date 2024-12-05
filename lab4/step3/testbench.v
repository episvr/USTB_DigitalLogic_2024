module test_flash_led_top;
    reg clk;
    reg rst_n;
    reg sw0;
    wire [15:0] led_out;
    flash_led_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .sw0(sw0),
        .led_out(led_out)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        rst_n = 0; #10;
        rst_n = 1; #10;
        sw0 = 0; #100; 
        sw0 = 1; #100;
        rst_n = 0; #10;
        rst_n = 1; #10;
        $finish;
    end
endmodule