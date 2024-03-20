`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2024 16:24:26
// Design Name: 
// Module Name: test_tb
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

`include "defines.vh"

module test_tb();

reg clk; 

initial begin 
    clk = 1'b0; 
    forever #2 clk = !clk; 
end

reg [8:0] full_frac_prod; 
wire [3:0] cnt_frac_one_pos; 

initial begin 
    full_frac_prod = 'b0; 
    @(negedge clk); full_frac_prod = 9'h1F0; 
    @(negedge clk); full_frac_prod = 9'h088;
    @(negedge clk); full_frac_prod = 9'h048;
    @(negedge clk); full_frac_prod = 9'h020; 
    @(negedge clk); full_frac_prod = 9'h018;
    @(negedge clk); full_frac_prod = 9'h009;
    @(negedge clk); full_frac_prod = 9'h004;
    @(negedge clk); full_frac_prod = 9'h003;
    @(negedge clk); full_frac_prod = 9'h001;
end

leading_ones_det #(.INP_BIT_W(9),.OUT_BIT_W(4))
        u_leading_ones_det (full_frac_prod[8:0], 
                            cnt_frac_one_pos);
                            
 reg [7:0] A, B; 
 wire [7:0] C, A_add_B; 
 
 integer kk, jj; 
 
 initial begin 
    A = 'b0; 
    B = 'b0;
    
    // +  +
    /*for (jj = 0; jj < 7; jj = jj + 1) begin
        for (kk = 0; kk < 15; kk = kk + 3) begin 
            @(negedge clk); A = genFlt(0, jj, kk); B = genFlt(0, jj, kk);
        end
    end
    
    for (jj = 0; jj < 7; jj = jj + 1) begin
        for (kk = 0; kk < 15; kk = kk + 3) begin 
            @(negedge clk); A = genFlt(1, jj, kk); B = genFlt(1, jj, kk);
        end
    end
    
    for (jj = 0; jj < 7; jj = jj + 1) begin
        for (kk = 0; kk < 15; kk = kk + 3) begin 
            @(negedge clk); A = genFlt(1, jj, kk); B = genFlt(0, jj, kk);
        end
    end
    
    for (jj = 0; jj < 7; jj = jj + 1) begin
        for (kk = 0; kk < 15; kk = kk + 3) begin 
            @(negedge clk); A = genFlt(0, jj, kk); B = genFlt(1, jj, kk);
        end
    end
    */
    
    for (jj = 0; jj < 60; jj = jj + 1) begin
        @(negedge clk); A = genFlt($random,$random, $random); 
        B = genFlt($random,$random, $random);
    end
    
    
    repeat(5) @(negedge clk); 
    $finish;
 end 

mult_flt u_mult_flt(A, B, C); 
add_flt u_add_flt(A, B, A_add_B); 

real A_real, B_real, C_real, C_dut, A_add_B_real, A_plus_B;
real add_Error, mult_Error; 

always @(*) begin  
    A_real = getReal(A); 
    B_real = getReal(B);
    C_real = `max(`min(A_real*B_real, 31.0), -31.0); 
    C_dut = getReal(C);
    A_add_B_real = getReal(A_add_B);
    A_plus_B = `max(`min(A_real + B_real, 31.0), -31.0);
    add_Error = A_plus_B - A_add_B_real;
    mult_Error = C_dut - C_real;
end

`include "realFlt.vh"

endmodule
`undef min
`undef max