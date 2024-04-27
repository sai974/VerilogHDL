`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.02.2024 13:37:33
// Design Name: 
// Module Name: Complete_MIPS
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

module MIPS_Testbench (); 
reg CLK; 
reg RST;
wire CS; 
wire WE; 
wire [31:0] Mem_Bus; 
wire [31:0] Address; 

wire clk_1Hz_en; 

gen_clk_div_en #(.DIV_RATIO(1)) 
    u_gen_div_clk_en(CLK, 
                     clk_1Hz_en); 

wire [31:0] R2; 
reg [31:0] R1; 
          
MIPS CPU(CLK, clk_1Hz_en, RST, R1, CS, WE, Address, R0_lsbs, R2, Mem_Bus); 
Memory MEM(CS, WE, CLK, Address, Mem_Bus); 
/////////////////////////////////
initial begin 
    CLK = 0; 
end

always begin 
    #10 CLK = !CLK; 
end 
////////////////////////////////
localparam N = 10;

integer i; 

initial begin 
    RST = 1'b1; 
    //reset the processor 
    //Notice that the memory is initialize in the in the memory module not here 
   @(posedge CLK); // driving reset low here puts processor in normal operating mode
   @(posedge CLK); 
   #1; RST = 1'b0;

    R1 = 'b0; 
    repeat(40) @(posedge CLK);  
    R1 = 3'b1; 
    repeat(40) @(posedge CLK);
    R1 = 3'd2; 
    repeat(40) @(posedge CLK);
    R1 = 3'd3; 
    repeat(40) @(posedge CLK);
    R1 = 3'd4; 
    repeat(40) @(posedge CLK);
    R1 = 3'd5; 
    repeat(40) @(posedge CLK);
    R1 = 3'd0; 
    repeat(80) @(posedge CLK);
    $display("TEST COMPLETE"); 
    $finish;
end 


endmodule

