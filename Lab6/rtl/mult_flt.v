`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2024 16:12:25
// Design Name: 
// Module Name: mult_flt
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

module mult_flt(input [7:0] A,
                input [7:0] B, 
                output [7:0] D);
            
wire [2:0] A_exp, B_exp; 
wire [3:0] A_frac, B_frac; 

assign {A_exp, A_frac} = A[6:0]; 
assign {B_exp, B_frac} = B[6:0]; 

wire [9:0] full_frac_prod; 
wire [3:0] sum_exp_prod;

assign full_frac_prod = {1'b1, A_frac} * {1'b1, B_frac}; 
assign sum_exp_prod = (A_exp + B_exp);

// Sign 
wire D_sign;
assign D_sign = A[7] ^ B[7]; 

wire isanyInpZero = isZero(A) || isZero(B); 

// Fraction_prod
reg [3:0] prod_frac;
reg [3:0] prod_exp;   
 
wire [8:0] full_frac_prod_normed; 
                     
assign full_frac_prod_normed = full_frac_prod[8:0];  

always @(*) begin 
    prod_exp = 'b0;
    prod_frac = 'b0;
     
    if (isanyInpZero) begin
        prod_exp = 'b0;
        prod_frac = 'b0; 
    end else begin 
        // check is frac overflow
        if (full_frac_prod[9] == 1'b1) begin 
            prod_frac = full_frac_prod[8:5];
            if (sum_exp_prod < 2'd2) begin
                // underflow 
                prod_frac = 'b0; 
                prod_exp = 'b0;
            end else if ((sum_exp_prod - 2'd2) > 3'd7) begin 
                //overflow 
                prod_frac = {4{1'b1}};
                prod_exp = 3'd7;
            end else begin
                prod_exp = (sum_exp_prod - 2'd2);
            end 
        end else begin
            prod_frac = full_frac_prod_normed[7:4];
            if (sum_exp_prod < 2'd3) begin
                // underflow 
                prod_frac = 'b0; 
                prod_exp = 'b0;
            end else if ((sum_exp_prod - 2'd3) > 3'd7) begin 
                //overflow 
                prod_frac = {4{1'b1}};
                prod_exp = 3'd7;
            end else begin
                prod_exp = (sum_exp_prod - 2'd3);
            end 
        end
    end 
end 

assign D = {D_sign, prod_exp[2:0], prod_frac}; 


`ifndef SYNTHESIS
 real Areal, Breal, Drefreal, Dreal;
 always @(*) begin
    Areal = getReal(A); 
    Breal = getReal(B); 
    Drefreal =  `max(`min(Areal*Breal, 31.0), -31.0); 
    Dreal = getReal(D);
 end
`endif

function isZero(input [7:0] flt_num); 
begin
     // both the exponent and the fraction are zero 
    isZero = (~|flt_num[3:0]) && (~|flt_num[6:4]);
end
endfunction

endmodule
