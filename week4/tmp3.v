module PalindromicSequenceDetector (
    input wire CLK,
    input wire IN,
    output reg OUT
);
    reg [4:0] shift_reg = 5'b00000;
    always @(posedge CLK) begin
        shift_reg <= {shift_reg[3:0], IN};
    end
    always @(*) begin
       OUT = (shift_reg[3] == IN) && (shift_reg[2] == shift_reg[0]);
    end
endmodule


// module tb_PalindromicSequenceDetector;

//     // 输入信号和输出信号的定义
//     reg CLK;
//     reg IN;
//     wire OUT;

//     // 实例化待测试模块
//     PalindromicSequenceDetector uut (
//         .CLK(CLK),
//         .IN(IN),
//         .OUT(OUT)
//     );

//     // 产生时钟信号
//     initial begin
//         CLK = 1;
//         forever #5 CLK = ~CLK;
//     end

//     initial begin
//         IN = 0;
        
//         #10 IN = 1;  // 时间单位：1
//         #10 IN = 0;  // 时间单位：2
//         #10 IN = 1;  // 时间单位：3
//         #10 IN = 1;  // 时间单位：4
//         #10 IN = 1;  // 时间单位：5
//         #10 IN = 1;  // 时间单位：6
//         #10 IN = 0;  // 时间单位：7
//         #10 IN = 0;  // 时间单位：8
//         #10 IN = 0;  // 时间单位：9
//         #10 IN = 0;  // 时间单位：10
//         #10 IN = 1;  // 时间单位：11
//         #10 IN = 0;  // 时间单位：12
//         #10 IN = 0;  // 时间单位：13
//         #10 IN = 0;  // 时间单位：14
//         #10 IN = 1;  // 时间单位：15

//         // 模拟结束
//         #10 $finish;
//     end

// endmodule

