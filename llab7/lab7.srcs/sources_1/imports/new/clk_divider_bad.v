`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.02.2024 14:02:52
// Design Name: 
// Module Name: clk_divider_bad
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


module clk_divider_bad #(parameter DIV_RATIO = 25000000)
                (input clk100Mhz, output reg slowClk);
 reg[31:0] counter;
 
 initial
 begin
     counter = 0;
 end
 
 always @ (posedge clk100Mhz)
 begin
     if(counter == DIV_RATIO) begin
         counter <= 1;
         slowClk <= ~slowClk;
     end
     else begin
         counter <= counter + 1; 
     end
 end

endmodule
