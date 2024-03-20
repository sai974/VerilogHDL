`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2024 13:44:15
// Design Name: 
// Module Name: top
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
module top( input clk, 
            input [1:0] sw,
            output [7:0] led);

wire halt, rst; 
wire [7:0] R0_lsbs; 

assign led = R0_lsbs; 

switch_inp_sync #(.BIT_W(2))
    u_switch_sync( clk, 
                  {sw[1:0]}, 
                  {halt, rst}); 

wire clk_1Hz_en; 

gen_clk_div_en #(.DIV_RATIO(100000000)) 
                (clk, 
                clk_1Hz_en); 
                
Complete_MIPS u_complete_mips (clk,
                               clk_1Hz_en, 
                               rst, 
                               halt, 
                               R0_lsbs);
                      
endmodule
