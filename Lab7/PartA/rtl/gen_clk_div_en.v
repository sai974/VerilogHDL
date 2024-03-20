`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2024 14:07:06
// Design Name: 
// Module Name: gen_clk_div_en
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


module gen_clk_div_en #(parameter DIV_RATIO = 250000)
                       (input clk, 
                        output div_clk_en);

localparam BITS_CNT = $clog2(DIV_RATIO); 



reg [BITS_CNT - 1: 0] cntr; 

initial begin 
    cntr = 3'd3; 
end

always @(posedge clk) begin 
    cntr <= (cntr >= (DIV_RATIO-1'b1)) ? 'b0 : cntr + 1'b1;
end

assign div_clk_en = (cntr == 'b0); 

endmodule
