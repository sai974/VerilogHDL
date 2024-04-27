`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.02.2024 13:37:33
// Design Name: 
// Module Name: Memory
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

module Memory(  input CS, 
                input WE,
                input CLK, 
                input [31:0] ADDR,
                inout [31:0] Mem_Bus); 
 
reg [31:0] data_out; 
reg [31:0] RAM [0:127]; 

integer i;
initial begin 
    for (i= 0; i < 128; i = i + 1) begin
        RAM[i] = 32'd0;  
    end
    //$readmemh("MIPS_Instructions.mem", RAM);
    $readmemh("lab_partb.mem", RAM);
end

assign Mem_Bus = ((CS == 1'b0) || (WE == 1'b1)) ? 32'bz : data_out; 

always @(negedge CLK) begin 
    if((CS == 1'b1) && (WE == 1'b1)) begin
        RAM[ADDR] <= Mem_Bus[31:0]; 
    end
    data_out <= RAM[ADDR]; 
end
endmodule
