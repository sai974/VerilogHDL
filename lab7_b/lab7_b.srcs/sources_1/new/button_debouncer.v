`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2024 13:46:35
// Design Name: 
// Module Name: button_debouncer
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


module button_debouncer #(parameter BIT_W = 2, 
                          parameter DEBOUNCE_CLKS = 5)
                          (input clk, 
                           input arst,
                           input  [BIT_W - 1: 0] in, 
                           output reg [BIT_W - 1: 0] out);

reg [BIT_W - 1:0] temp; 
reg [$clog2(DEBOUNCE_CLKS) - 1:0] cntr; 

always @(posedge clk or posedge arst) begin 
    if (arst) begin 
        cntr <= 'b0; 
        temp <= 'b0; 
        out <= 'b0; 
    end else begin 
        temp <= in;
        
        if (cntr == DEBOUNCE_CLKS) begin 
            out <= temp; 
        end 
        
        cntr <= (temp != in) ? 'b0 : // if there is mismatch then reset counter
                (cntr == DEBOUNCE_CLKS) ? 'b0 : cntr + 1'b1;  
    end 
end 


endmodule
