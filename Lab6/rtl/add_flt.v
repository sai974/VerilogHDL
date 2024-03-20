`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2024 16:12:25
// Design Name: 
// Module Name: add_flt
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

`define TWOS_COMP(a) (~a + 1'b1)

module add_flt(input [7:0] A,
               input [7:0] B, 
               output [7:0] C);

wire [2:0] A_exp, B_exp; 
wire [3:0] A_frac, B_frac; 

wire sum_sign;
reg [2:0] sum_exp; 
reg [3:0] sum_frac; 

assign {A_exp, A_frac} = A[6:0]; 
assign {B_exp, B_frac} = B[6:0]; 

wire signed [5:0] A_frac_2_4s; 
wire signed [5:0] B_frac_2_4s;

wire signed [12:0] A_frac_2_11s; 
wire signed [12:0] B_frac_2_11s; 

assign A_frac_2_4s = ~|A[6:0] ? 'b0 : 
                      A[7] ? `TWOS_COMP({1'b0, 1'b1, A_frac}) : 
                      {1'b0, 1'b1, A_frac}; 
assign B_frac_2_4s = ~|B[6:0] ? 'b0 :
                      B[7] ? `TWOS_COMP({1'b0, 1'b1, B_frac}) :  
                      {1'b0, 1'b1, B_frac};

assign A_frac_2_11s = A_frac_2_4s <<< 7; 
assign B_frac_2_11s = B_frac_2_4s <<< 7; 

wire [2:0] abs_exp_diff; 
wire [2:0] A_B_max_exp; 
assign abs_exp_diff = (A_exp > B_exp) ? A_exp - B_exp : B_exp - A_exp; 
assign A_B_max_exp = (A_exp > B_exp) ? A_exp : B_exp; 

reg signed [12:0] un_norm_frac_2_11s, ref_frac_2_11s; 
reg signed [13:0] added_un_norm_frac_3_11s;
wire signed [13:0] added_un_norm_frac_3_11s_negated;
wire [12:0] added_un_norm_frac_2_11s_SM;

assign added_un_norm_frac_3_11s_negated = `TWOS_COMP(added_un_norm_frac_3_11s); 
assign added_un_norm_frac_2_11s_SM = added_un_norm_frac_3_11s[13] ?
                                     added_un_norm_frac_3_11s_negated[12:0] : 
                                     added_un_norm_frac_3_11s[12:0];

assign sum_sign = added_un_norm_frac_3_11s[13]; 

always @(*) begin
    un_norm_frac_2_11s = A_frac_2_11s >>> abs_exp_diff; 
    ref_frac_2_11s = B_frac_2_11s;
     
    if (A_exp > B_exp) begin
         un_norm_frac_2_11s = B_frac_2_11s >>> abs_exp_diff;
         ref_frac_2_11s = A_frac_2_11s;
    end
    
    added_un_norm_frac_3_11s = un_norm_frac_2_11s + ref_frac_2_11s;
    
end

wire [3:0] cnt_frac_one_pos; 
leading_ones_det #(.INP_BIT_W(12),.OUT_BIT_W(4))
    u_leading_ones_det (added_un_norm_frac_2_11s_SM[11:0], 
                        cnt_frac_one_pos);

wire [3:0] shift_sat; 
wire [11:0] full_frac_sum_normed; 
assign shift_sat  = (cnt_frac_one_pos > A_B_max_exp) ? 
                     A_B_max_exp : cnt_frac_one_pos;  
assign full_frac_sum_normed = added_un_norm_frac_2_11s_SM[11:0] << shift_sat; 

always @(*) begin
    sum_frac = 'b0; 
    sum_exp = 'b0;
    if (added_un_norm_frac_2_11s_SM == 'b0) begin 
        sum_frac = 'b0; 
        sum_exp = 'b0;
    end else if (added_un_norm_frac_2_11s_SM[12]) begin 
        sum_frac = added_un_norm_frac_2_11s_SM[11:8]; 
        sum_exp = ((A_B_max_exp + 1'b1) > 3'd7) ? 
                    3'd7 : (A_B_max_exp + 1'b1); // MAYBE WRONG OVERFLOW??
    end else begin 
        sum_frac = full_frac_sum_normed[11:7]; 
        sum_exp = (A_B_max_exp - shift_sat); 
    end
end

assign C = {sum_sign, sum_exp, sum_frac};

`ifndef SYNTHESIS
 real Creal, Areal, Breal, Crefreal;
 always @(*) begin
    Areal = getReal(A); 
    Breal = getReal(B); 
    Crefreal =  `max(`min(Areal + Breal, 31.0), -31.0);
    Creal = getReal(C);
 end
`endif
       
endmodule
