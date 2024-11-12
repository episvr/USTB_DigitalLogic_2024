//created by epi 2021.08.11
// CPU 
`timescale 1ns/1ps
module display(
    input wire [5:0] rx,
    input wire [5:0] ry,
    input wire [3:0] op,
    output wire [7:0] data
    // output wire [1:0] fs_to_ds_bus,
);
    wire [1:0] rx_addr = 2'b00;
    wire [1:0] ry_addr = 2'b01;
    wire [10:0] tmp_data;
    wire [7:0] rx_value;
    wire [7:0] ry_value;
    assign rx_value = {2'b0, rx};
    assign ry_value = {2'b0, ry};
    reg [7:0] pc = 8'b00000000; 
    id id_instance(
       .fs_to_ds_bus({pc, op, ry_addr, rx_addr}),
       .ds_to_es_bus(),
       .rx(rx_addr),
       .ry(ry_addr),
       .rx_value(rx_value),
       .ry_value(ry_value),
       .rf_bus(tmp_data)
    );

    assign data = tmp_data[7:0];
endmodule

module id(
    input wire [15:0] fs_to_ds_bus,
    output wire [27:0] ds_to_es_bus,
    output wire [1:0] rx,
    output wire [1:0] ry,
    input wire [7:0] rx_value,
    input wire [7:0] ry_value,
    output wire [10:0] rf_bus
);
reg [7:0] write_data;
reg write_enable;
reg [3:0] op; 

always @(*) begin
    write_enable = 0; 
    write_data = 8'b00000000; 
    case (fs_to_ds_bus[7:4])
        //ALU 
        4'b0001: begin 
            op = 4'b1000; // MOV
            write_enable = 1; 
            write_data = rx_value; 
        end
        4'b0010: begin 
            op = 4'b0100; // ADD
            write_enable = 1; 
            write_data = rx_value + ry_value; 
        end
        4'b0011: begin
            op = 4'b0010; // SUB
            write_enable = 1; 
            write_data = rx_value - ry_value; 
        end
        4'b0100: begin 
            op = 4'b0001; // MUL
            write_enable = 1; 
            write_data = rx_value * ry_value; 
        end
        default: begin 
            op = 4'b0000; // Default
        end
    endcase
end
assign {ds_to_es_bus,ry,rx} = {op, ry_value, rx_value, fs_to_ds_bus[15:8],fs_to_ds_bus[3:2],fs_to_ds_bus[1:0]};
assign rf_bus = {write_enable, rx, write_data};

endmodule

