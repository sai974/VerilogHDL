`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2024 13:49:49
// Design Name: 
// Module Name: switch_inp_sync
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


module switch_inp_sync #(parameter BIT_W = 7)
                        ( input clk, 
                          input [BIT_W-1:0] in, 
                          output reg [BIT_W-1:0] out
                         );

reg [BIT_W-1:0] temp; 

always @(posedge clk) begin
    temp <= in;
    out <= temp;
end

endmodule
