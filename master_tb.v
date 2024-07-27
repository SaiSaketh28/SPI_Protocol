`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2024 11:12:13
// Design Name: 
// Module Name: master_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module master_tb();
    reg clk,rst;
    reg [7:0] datain;
    wire [7:0]data_out;
    spi dut(.clk(clk),.rst(rst),.master_data_in(datain),.slave_data(data_out));
    always #5 clk = ~clk;
    initial begin
    #0 rst = 1'b1;clk = 1'b0;
    #2 rst = 1'b0;
    #5 datain <= 8'b10101010;
    #400 $finish;
    end
endmodule