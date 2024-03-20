`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.02.2024 21:07:40
// Design Name: 
// Module Name: REG
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

module REG( input CLK,
            input RegW,
            input [4:0] DR,
            input [4:0] SR1,
            input [4:0] SR2,
            input [31:0] Reg_In,
            output reg [31:0] ReadReg1,
            output reg [31:0] ReadReg2, 
            output [7:0] R0_lsbs);
              
reg [31:0] REG [0:31]; 
integer i;
 
initial begin 
    ReadReg1 = 0; 
    ReadReg2 = 0;
    for (i = 0; i < 32; i = i + 1) begin 
        REG[i] = 0; 
    end 
end 

always @(posedge CLK) begin 
    if(RegW == 1'b1) begin
        REG[DR] <= Reg_In[31:0]; 
    end
    
    ReadReg1 <= REG[SR1]; 
    ReadReg2 <= REG[SR2];
end

assign R0_lsbs = REG[0][7:0]; 

endmodule
