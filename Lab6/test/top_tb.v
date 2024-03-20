`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.03.2024 20:53:04
// Design Name: 
// Module Name: top_tb
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
`define sel(row, col) (row*N + col)*BIT_W+:BIT_W

module top_tb();

parameter N = 3; 
parameter BIT_W = 8; 

reg clk, rst;
initial begin 
    clk = 1'b0; 
    forever #2 clk = !clk;
end

reg start; 
reg [N*N*BIT_W-1:0] matA; 
reg [N*N*BIT_W-1:0] matB;

real  matCref[N-1:0][N-1:0], matC_calc[N-1:0][N-1:0];
real  matAreal[N-1:0][N-1:0], matBreal[N-1:0][N-1:0];

integer i, j, k; 

initial begin 
    start = 0;
    /////////////////////////////////////////////
    rst = 1; @(negedge clk); rst = 0;  
    // one identity and other random
    for (i = 0; i < N; i = i + 1) begin 
        for (j = 0; j < N; j = j + 1) begin
            matA[`sel(i, j)] = (i ==j) ? genFlt(0, 3, 0) : genFlt(0, 0, 0);
            matB[`sel(i, j)] = genFlt($random, $random, $random);
        end
    end
    
    @(negedge clk); start = 1; @(negedge clk); start = 0; 
    repeat(10) @(posedge clk);
    /////////////////////////////////////////////
    rst = 1; @(negedge clk); rst = 0;
     // one all constant and other 4, 2, 1
    for (i = 0; i < N; i = i + 1) begin 
        for (j = 0; j < N; j = j + 1) begin
            matA[`sel(i, j)] = genFlt(0, 3, 0);
            matB[`sel(i, j)] = genFlt(0, 3+j, 0);
        end
    end
    
    @(negedge clk); start = 1; @(negedge clk); start = 0; 
    repeat(10) @(posedge clk);
    /////////////////////////////////////////////
    rst = 1; @(negedge clk); rst = 0;
     // one all negative constant
    for (i = 0; i < N; i = i + 1) begin 
        for (j = 0; j < N; j = j + 1) begin
            matA[`sel(i, j)] = genFlt(1, 4, 0);
            matB[`sel(i, j)] = genFlt(0, 2+j, $random);
        end
    end
    
    @(negedge clk); start = 1; @(negedge clk); start = 0; 
    repeat(10) @(posedge clk);
    /////////////////////////////////////////////
    rst = 1; @(negedge clk); rst = 0;
     // one all constant and other 4, 2, 1
    for (i = 0; i < N; i = i + 1) begin 
        for (j = 0; j < N; j = j + 1) begin
            matA[`sel(i, j)] = genFlt(1, 3, $random);
            matB[`sel(i, j)] = genFlt(0, 3+j, $random);
        end
    end
    
    @(negedge clk); start = 1; @(negedge clk); start = 0; 
    repeat(10) @(posedge clk);
    /////////////////////////////////////////////
    rst = 1; @(negedge clk); rst = 0;
     // all random
    for (i = 0; i < N; i = i + 1) begin 
        for (j = 0; j < N; j = j + 1) begin
            matA[`sel(i, j)] = genFlt($random, i+2, $random);
            matB[`sel(i, j)] = genFlt($random, j+2, $random);
        end
    end
    
    @(negedge clk); start = 1; @(negedge clk); start = 0; 
    repeat(10) @(posedge clk);
    /////////////////////////////////////////////
    rst = 1; @(negedge clk); rst = 0;
    // all random
    for (i = 0; i < N; i = i + 1) begin 
        for (j = 0; j < N; j = j + 1) begin
            matA[`sel(i, j)] = genFlt($random, i, $random);
            matB[`sel(i, j)] = genFlt($random, j+3, $random);
        end
    end
    
    @(negedge clk); start = 1; @(negedge clk); start = 0; 
    repeat(10) @(posedge clk);
    /////////////////////////////////////////////
    rst = 1; @(negedge clk); rst = 0;
    // all random
    for (i = 0; i < N; i = i + 1) begin 
        for (j = 0; j < N; j = j + 1) begin
            matA[`sel(i, j)] = genFlt($random, i, i*2);
            matB[`sel(i, j)] = genFlt($random, j+3, i*j);
        end
    end
    
    @(negedge clk); start = 1; @(negedge clk); start = 0; 
    repeat(10) @(posedge clk);
    /////////////////////////////////////////////
    $finish;
end 

top #(.N(3), .BIT_W(8))
         u_top( clk, 
                rst,
                start, 
                matA, 
                matB);

always @(*) begin 
    for (i =0; i < N; i = i + 1) begin 
        for (j = 0; j < N; j = j + 1) begin 
            matAreal[i][j] = getReal(matA[`sel(i,j)]);
            matBreal[i][j] = getReal(matB[`sel(i,j)]);
        end
     end
    
     for (i =0; i < N; i = i + 1) begin 
        for (j = 0; j < N; j = j + 1) begin 
            matCref[i][j] = 0;
            for (k = 0; k < N; k = k + 1) begin 
                matCref[i][j] =  matCref[i][j] + (matAreal[i][k]*matBreal[k][j]);
            end
        end
    end
end 
always @(*) begin 
    matC_calc[0][0] = getReal(u_top.u_systolic_arr.u_pe00.C);
    matC_calc[0][1] = getReal(u_top.u_systolic_arr.u_pe01.C);
    matC_calc[0][2] = getReal(u_top.u_systolic_arr.u_pe02.C);
    matC_calc[1][0] = getReal(u_top.u_systolic_arr.u_pe10.C);
    matC_calc[1][1] = getReal(u_top.u_systolic_arr.u_pe11.C);
    matC_calc[1][2] = getReal(u_top.u_systolic_arr.u_pe12.C);
    matC_calc[2][0] = getReal(u_top.u_systolic_arr.u_pe20.C);
    matC_calc[2][1] = getReal(u_top.u_systolic_arr.u_pe21.C);
    matC_calc[2][2] = getReal(u_top.u_systolic_arr.u_pe22.C);

end

`include "realFlt.vh"

endmodule
