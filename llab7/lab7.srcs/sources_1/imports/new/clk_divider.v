`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2024 23:48:31
// Design Name: 
// Module Name: clk_divider
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


module clk_divider #(parameter DIV_RATIO = 25000000)
                (input clk100Mhz, output reg slowClkEnable);

 reg[31:0] counter;
 
 initial
 begin
     counter = 0;
 end
 
 always @ (posedge clk100Mhz)
 begin
     if(counter == DIV_RATIO) begin
         counter <= 1;
         slowClkEnable <= 1'b1;
     end
     else begin
         counter <= counter + 1;
         slowClkEnable <= 1'b0; 
     end
 end

endmodule

