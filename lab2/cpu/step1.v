`timescale 1ns/1ps
module id(
    input wire [15:0] fs_to_ds_bus,
    output wire [27:0] ds_to_es_bus,
    output wire [1:0] rx,
    output wire [1:0] ry,
    input wire [7:0] rx_value,
    input wire [7:0] ry_value
);
reg [3:0] op; 
always @(*) begin
    case (fs_to_ds_bus[7:4])
        4'b0001: op = 4'b1000; // MOV
        4'b0010: op = 4'b0100; // ADD
        4'b0011: op = 4'b0010; // SUB
        4'b0100: op = 4'b0001; // MUL
        default: op = 4'b0000; // Default
    endcase
end
assign {ds_to_es_bus,ry,rx} = {op, ry_value, rx_value, fs_to_ds_bus[15:8],fs_to_ds_bus[3:2],fs_to_ds_bus[1:0]};
endmodule


// ////////////////////////////////////testbench///////////////////////////////////
// module tb_id;
//     reg [15:0] fs_to_ds_bus;
//     reg [7:0] rx_value;
//     reg [7:0] ry_value;
//     wire [27:0] ds_to_es_bus;
//     wire [1:0] rx;
//     wire [1:0] ry;
//     id uut (
//         .fs_to_ds_bus(fs_to_ds_bus),
//         .ds_to_es_bus(ds_to_es_bus),
//         .rx(rx),
//         .ry(ry),
//         .rx_value(rx_value),
//         .ry_value(ry_value)
//     );
//     initial begin
//         $monitor("Time: %t | fs_to_ds_bus: %b | rx_value: %b | ry_value: %b | ds_to_es_bus: %b | rx: %b | ry: %b", 
//                  $time, fs_to_ds_bus, rx_value, ry_value, ds_to_es_bus, rx, ry);
//         // {ds_to_es_bus,ry,rx} = {op, ry_value, rx_value, fs_to_ds_bus[15:8],fs_to_ds_bus[3:2],fs_to_ds_bus[1:0]};
//         //MOV 
//         fs_to_ds_bus = 16'b00010000_0001_01_01;
//         rx_value = 8'b00000001;
//         ry_value = 8'b00000010;
//         #10;

//         //ADD
//         fs_to_ds_bus = 16'b00100000_0010_10_00;
//         rx_value = 8'b00000011;
//         ry_value = 8'b00000100;
//         #10;

//         //SUB
//         fs_to_ds_bus = 16'b00110000_0011_00_11;
//         rx_value = 8'b00000101;
//         ry_value = 8'b00000110;
//         #10;

//         //MUL
//         fs_to_ds_bus = 16'b01000000_0100_10_11;
//         rx_value = 8'b00000111;
//         ry_value = 8'b00001000;
//         #10;

//         //Default
//         fs_to_ds_bus = 16'b11110000_1111_00_00;
//         rx_value = 8'b00001001;
//         ry_value = 8'b00001010;
//         #10;
//         $finish;
//     end
// endmodule
