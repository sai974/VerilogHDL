`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.02.2024 01:29:08
// Design Name: 
// Module Name: PE
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


module PE #(parameter BIT_W = 4)( input clk, 
                                  input rst, 
                                  input [BIT_W -1:0] top, 
                                  input [BIT_W- 1:0] left, 
                                  output reg [BIT_W-1:0] right, 
                                  output reg [BIT_W-1:0] bottom);

reg [BIT_W - 1:0] C; 
wire [BIT_W - 1:0] next_C; 

always @ (posedge clk or posedge rst) begin 
    if (rst) begin 
        right <= 'b0;
        bottom <= 'b0;
        C <= 'b0; 
    end else begin 
        right <= left; 
        bottom <= top;
        C <= next_C;
    end
end


/*always @(*) begin 
    next_C = C + top*left;
end
*/ 

MAC u_mac(top, left, C, next_C); 

`ifndef SYNTHESIS
 real Creal, Areal, Breal, nextCreal;
 always @(*) begin
    Creal = getReal(C); 
    Areal = getReal(top); 
    Breal = getReal(left); 
    nextCreal = getReal(next_C);
 end
`endif
`include "realFlt.vh"

endmodule
