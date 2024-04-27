`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2024 13:44:15
// Design Name: 
// Module Name: top
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
module top( input clk, 
            input [3:0] sw,
            input btnL, 
            input btnR, 
            output reg [15:0] led, 
            output [6:0] seg, 
            output [3:0] an);

wire rst; 
wire [7:0] R0_lsbs; 
wire [3:0] sw_sync; 
wire [1:0] btn_sync, btn_input; 

wire slowClk;
clk_divider_bad #(.DIV_RATIO(2))
               u_clk_divider (clk, slowClk);
                
assign func_clk = slowClk; 

switch_inp_sync #(.BIT_W(6))
    u_switch_sync( func_clk, 
                  {btnR, btnL, sw[3:0]}, 
                  {btn_sync, sw_sync[3:0]}); 
assign rst = sw_sync[3]; 

button_debouncer #(.BIT_W(2), .DEBOUNCE_CLKS(2000000))
     u_button_Debounce (.clk(func_clk),
                        .arst(rst), 
                        .in(btn_sync), 
                        .out(btn_input)); 
     
wire clk_1Hz_en; 

gen_clk_div_en #(.DIV_RATIO(1000000)) 
                (func_clk, 
                 clk_1Hz_en); 
                
wire [31:0] R1, R2; 
assign R1 = {29'b0, sw_sync[2:0]}; 

Complete_MIPS u_complete_mips (.CLK(func_clk),
                               .CLK_1HZ_en(clk_1Hz_en), 
                               .RST(rst), 
                               .R1(R1), 
                               .R0_lsbs(R0_lsbs), 
                               .R2(R2));

wire [15:0] R2_disp;
assign R2_disp = (btn_input == 2'b0) ? R2[15:0] : R2[31:16] ; 


always @(*) begin
    case(btn_input)
        2'd0: led = R2[15:0]; 
        default: led = R2[31:16]; 
    endcase
end

seven_segment_disp  u_segment_disp(  .clk_100Mhz(func_clk),
                                     .clr_n(!rst), 
                                     .displayed_number(R2_disp),
                                     .anode_sel(an), 
                                     .segR(seg));

endmodule
