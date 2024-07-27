`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2024 11:11:25
// Design Name: 
// Module Name: master
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


module master(
    input clk,
    input rst,
    input [7:0]datain,
    output reg chip_select,
    output reg slave_clk,
    output reg data
    );
    reg [1:0]state;
    reg [3:0] counter;
    localparam IDLE = 2'b00,LOAD = 2'b01,TRANSFER = 2'b10;
    always @(posedge clk or posedge rst)
    begin
        if(rst)begin
            counter <= 4'b1000;
            chip_select <= 1'b1;
            slave_clk <= 0;
            state <= IDLE;
        end
        else begin
            case(state)
            IDLE:begin
                chip_select <= 0;
                data <= 0;
                counter <= 4'b1000;
                slave_clk <= 0;
                state <= LOAD;
            end
            LOAD:begin
                if(!chip_select)data <= datain[counter-1];
                #5 slave_clk = 1;
                state <= TRANSFER;
            end
            TRANSFER:begin
                slave_clk = 0;
                if(counter >1)begin
                counter <= counter-1;
                #4 state <= LOAD;
                end
                else begin
                    data <= 0;
                    chip_select <= 1;
                end
            end
            default:state<=IDLE;
            endcase
        end
    end
endmodule


module slave(
    input clk,
    input slave_chip_select,
    input data,
    output [7:0]data_rc);
    reg [7:0]ds;
    reg [2:0]bit_counter;
    assign data_rc = ds;
    initial begin
    bit_counter <= 0;
    ds <=0;
    end
    always @(posedge clk)begin
        if(!slave_chip_select & bit_counter < 8) begin
           ds <= {ds[6:0],data};
           bit_counter <= bit_counter +1;
         end
         else begin
            bit_counter <= 0;
         end
    end
endmodule

module spi(
    input clk,
    input rst,
    input [7:0]master_data_in,
    output [7:0]slave_data);
    wire chip_select;
    wire data;
    wire sclk;
    master master_instance(clk,rst,master_data_in,chip_select,sclk,data);
    slave slave_instance(sclk,chip_select,data,slave_data);
endmodule