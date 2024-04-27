`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2024 13:54:39
// Design Name: 
// Module Name: seven_segment_disp
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


module seven_segment_disp(input clk_100Mhz,
                          input clr_n, 
                          input [15:0] displayed_number,
                          output reg [3:0] anode_sel, 
                          output [6:0] segR);
                          
reg [19:0] refresh_counter; 
wire [1:0] LED_activating_counter; 
reg [3:0] LED_BCD;
reg [6:0] seg; 

assign segR = {seg[0], seg[1], seg[2], seg[3], seg[4], seg[5], seg[6]};

always @(posedge clk_100Mhz or negedge clr_n)
begin 
 if(!clr_n)
  refresh_counter <= 0;
 else
  refresh_counter <= refresh_counter + 1;
end 

assign LED_activating_counter = refresh_counter[19:18];

always @(*)
begin
    case(LED_activating_counter)
    2'b00: begin
        anode_sel = 4'b0111; 
        LED_BCD = displayed_number[15:11];
    end
    2'b01: begin
        anode_sel = 4'b1011; 
        LED_BCD = displayed_number[10:8];
    end
    2'b10: begin
        anode_sel = 4'b1101; 
        LED_BCD = displayed_number[7:4];
    end
    2'b11: begin
        anode_sel = 4'b1110; 
        LED_BCD = displayed_number[3:0];
    end   
    default:begin
        anode_sel = 4'b0111; 
        LED_BCD = displayed_number[15:11];
    end
    endcase
end


always @(*)
begin
 case(LED_BCD)
 // Middle
 4'b0000: seg = 7'b0000001; // "0"  
 4'b0001: seg = 7'b1001111; // "1" 
 4'b0010: seg = 7'b0010010; // "2" 
 4'b0011: seg = 7'b0000110; // "3" 
 4'b0100: seg = 7'b1001100; // "4" 
 4'b0101: seg = 7'b0100100; // "5" 
 4'b0110: seg = 7'b0100000; // "6" 
 4'b0111: seg = 7'b0001111; // "7" 
 4'b1000: seg = 7'b0000000; // "8"  
 4'b1001: seg = 7'b0000100; // "9" 
 4'b1010: seg = 7'b0000000;//A 
 4'b1011: seg = BIT_PATT(0, 0, 1, 1, 1, 1, 1); //b
 4'b1100: seg = BIT_PATT(1, 0, 0, 1, 1, 1, 0); //C
 4'b1101: seg = BIT_PATT(0, 1, 1, 1, 1, 0, 1); //d
 4'b1110: seg = BIT_PATT(1, 0, 0, 1, 1, 1, 1); //E
 4'b1111: seg = BIT_PATT(1, 0, 0, 0, 1, 1, 1);//F
 default: seg = 7'b0000001; // "0"
 endcase
end

function [7:0] BIT_PATT(input  up, upr, lr, b, bl, upl, m); // se the input bit to high if we want to be lit 
 begin
   BIT_PATT = ~{up, upr, lr, b, bl, upl, m};
 end
endfunction 
endmodule

