`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.02.2024 01:29:08
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
`define sel(row, col) ((row)*N + (col))*BIT_W+:BIT_W

module top #(parameter N = 3,
             parameter BIT_W = 4
             )( input clk, 
                input rst,
                input start, 
                input [N*N*BIT_W-1:0] matA, 
                input [N*N*BIT_W-1:0] matB);
                
localparam IDLE = 2'b00; 
localparam RUN = 2'b01; 
localparam READY = 2'b10; 

localparam NUM_STEPS = N + N - 1; 
localparam CNT_BITS = $clog2(NUM_STEPS) ; 

reg [CNT_BITS - 1: 0] cnt; 
reg [1:0] state; 

always @(posedge clk or posedge rst) begin 
    if (rst) begin 
        cnt <= 'b0;
        state <= IDLE; 
    end else begin 
        state <= (state == IDLE) ? ((start) ? RUN : IDLE) :
                 (state == READY) ? READY : 
                 (cnt == (NUM_STEPS-1)) ? READY : RUN;
                  
        cnt <= (state == IDLE)  ? 'b0:
               (state == READY) ? cnt : 
               (state == RUN)   ? cnt + 1'b1 : cnt;                
    end
end 

reg  [N*BIT_W - 1:0] hor, next_hor; 
reg  [N*BIT_W - 1:0] vert, next_vert;

always @(posedge clk or posedge rst) begin 
    if (rst) begin 
        hor <= 'b0; 
        vert <= 'b0; 
    end else begin 
        hor <= next_hor; 
        vert = next_vert;
    end
end

integer i; 

always @(*) begin 
    case (state)
        RUN: begin 
            for (i = 0; i < N; i = i + 1) begin 
                next_hor[i*BIT_W+:BIT_W] = ((cnt+1'b1) >= i) && (cnt < (i + N - 1'b1)) ? 
                               matB[`sel((1'b1 + cnt - i), i)] : 'b0;
                next_vert[i*BIT_W+:BIT_W] = ((cnt+1'b1) >= i) && (cnt < (i + N - 1'b1)) ? 
                                matA[`sel(i, (1'b1 + cnt - i))] : 'b0;
            end
        end
         IDLE: begin 
            for (i = 0; i < N; i = i + 1) begin 
                next_hor[i*BIT_W+:BIT_W] = 'b0;
                next_vert[i*BIT_W+:BIT_W] = 'b0;
            end
            
            if (start) begin
                next_hor[0+:BIT_W] = matB[`sel(0, 0)]; 
                next_vert[0+:BIT_W] = matA[`sel(0, 0)];
            end
        end
        
        default: begin 
            for (i = 0; i < N; i = i + 1) begin 
                next_hor[i*BIT_W+:BIT_W] = 'b0;
                next_vert[i*BIT_W+:BIT_W] = 'b0;
            end
        end
    endcase
end 

systolic_array #(.BIT_W(BIT_W), .N(N)) 
                 u_systolic_arr( .clk(clk),
                                 .rst(rst),
                                 .hor_reg(hor), 
                                 .vert_reg(vert));
               
endmodule
