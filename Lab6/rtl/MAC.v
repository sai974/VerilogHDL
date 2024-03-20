`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2024 00:07:03
// Design Name: 
// Module Name: MAC
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
module MAC( input [7:0] A,
            input [7:0] B, 
            input [7:0] C, 
            output [7:0] D);

wire [7:0] Ctemp; 
         
mult_flt u_mult(A, B, Ctemp); 
add_flt u_add(C, Ctemp, D); 

`ifndef SYNTHESIS
 real Creal, Areal, Breal, Ctmpreal, Dreal;
 always @(*) begin
    Creal = getReal(C); 
    Areal = getReal(A); 
    Breal = getReal(B); 
    Ctmpreal = getReal(Ctemp);
    Dreal = getReal(D);
 end
`endif
endmodule