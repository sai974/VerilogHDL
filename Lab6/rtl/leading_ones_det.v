`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2024 15:44:06
// Design Name: 
// Module Name: leading_ones_det
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


module leading_ones_det #(parameter INP_BIT_W = 4, 
                          parameter OUT_BIT_W = 2)
        ( input  [INP_BIT_W - 1:0] in, 
          output reg [OUT_BIT_W - 1:0] cnt); 

reg [INP_BIT_W - 1: 0] orRed; 
wire [INP_BIT_W - 1:0] oneHOT;

integer i; 
always @(*) begin 
    orRed = 'b0; 
    for (i = 0; i <= INP_BIT_W - 2; i = i + 1'b1) begin 
        orRed[INP_BIT_W - 2 - i] = orRed[INP_BIT_W - 1 - i] || 
                                   in[INP_BIT_W - 1 - i];
    end
end

assign oneHOT = in & ~orRed; 

integer j;
always @(*) begin 
    cnt = 'b0;
    for (j = 0; j <= INP_BIT_W-1; j = j + 1) begin 
        if (oneHOT[INP_BIT_W-1 - j]) begin
            cnt = j; 
        end
    end 
end

endmodule
