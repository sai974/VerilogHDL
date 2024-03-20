`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.03.2024 15:37:09
// Design Name: 
// Module Name: systolic_array
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


module systolic_array #(parameter BIT_W = 4, 
                        parameter N = 3)( input clk,
                                          input rst, 
                                          input [N*BIT_W -1 : 0] hor_reg, 
                                          input [N*BIT_W -1 : 0] vert_reg);

wire [N*BIT_W - 1:0] top_inps[N:0];
wire [N*BIT_W - 1:0] left_inps[N:0];

assign top_inps[0] = hor_reg; 
assign left_inps[0] = vert_reg; 

generate 
    // ROW 0 START 
    PE #(.BIT_W(BIT_W))  u_pe00(.clk(clk), 
                                .rst(rst), 
                                .top   (top_inps  [0  ][0*BIT_W+:BIT_W]), 
                                .left  (left_inps [0  ][0*BIT_W+:BIT_W]), 
                                .right (left_inps [0+1][0*BIT_W+:BIT_W]), 
                                .bottom(top_inps  [0+1][0*BIT_W+:BIT_W])
                                );
    PE #(.BIT_W(BIT_W))  u_pe01(.clk(clk), 
                                .rst(rst), 
                                .top   (top_inps  [0  ][1*BIT_W+:BIT_W]), 
                                .left  (left_inps [1  ][0*BIT_W+:BIT_W]), 
                                .right (left_inps [1+1][0*BIT_W+:BIT_W]), 
                                .bottom(top_inps  [0+1][1*BIT_W+:BIT_W])
                                );
    PE #(.BIT_W(BIT_W))  u_pe02(.clk(clk), 
                                .rst(rst), 
                                .top   (top_inps  [0  ][2*BIT_W+:BIT_W]), 
                                .left  (left_inps [2  ][0*BIT_W+:BIT_W]), 
                                .right (left_inps [2+1][0*BIT_W+:BIT_W]), 
                                .bottom(top_inps  [0+1][2*BIT_W+:BIT_W])
                                );
    // ROW 0 END
    // ROW 1 START 
    PE #(.BIT_W(BIT_W))  u_pe10(.clk(clk), 
                                .rst(rst), 
                                .top   (top_inps  [1  ][0*BIT_W+:BIT_W]), 
                                .left  (left_inps [0  ][1*BIT_W+:BIT_W]), 
                                .right (left_inps [0+1][1*BIT_W+:BIT_W]), 
                                .bottom(top_inps  [1+1][0*BIT_W+:BIT_W])
                                );
                                
    PE #(.BIT_W(BIT_W))  u_pe11(.clk(clk), 
                                .rst(rst), 
                                .top   (top_inps  [1  ][1*BIT_W+:BIT_W]), 
                                .left  (left_inps [1  ][1*BIT_W+:BIT_W]), 
                                .right (left_inps [1+1][1*BIT_W+:BIT_W]), 
                                .bottom(top_inps  [1+1][1*BIT_W+:BIT_W])
                                );
                                
   PE #(.BIT_W(BIT_W))  u_pe12(.clk(clk), 
                               .rst(rst), 
                               .top   (top_inps  [1  ][2*BIT_W+:BIT_W]), 
                               .left  (left_inps [2  ][1*BIT_W+:BIT_W]), 
                               .right (left_inps [2+1][1*BIT_W+:BIT_W]), 
                               .bottom(top_inps  [1+1][2*BIT_W+:BIT_W])
                               );
   // ROW 1 END
   // ROW 2 START
   PE #(.BIT_W(BIT_W))  u_pe20(.clk(clk), 
                               .rst(rst), 
                               .top   (top_inps  [2  ][0*BIT_W+:BIT_W]), 
                               .left  (left_inps [0  ][2*BIT_W+:BIT_W]), 
                               .right (left_inps [0+1][2*BIT_W+:BIT_W]), 
                               .bottom(top_inps  [2+1][0*BIT_W+:BIT_W])
                               );
                                
   PE #(.BIT_W(BIT_W))  u_pe21(.clk(clk), 
                               .rst(rst), 
                               .top   (top_inps  [2  ][1*BIT_W+:BIT_W]), 
                               .left  (left_inps [1  ][2*BIT_W+:BIT_W]), 
                               .right (left_inps [1+1][2*BIT_W+:BIT_W]), 
                               .bottom(top_inps  [2+1][1*BIT_W+:BIT_W])
                               );
   PE #(.BIT_W(BIT_W))  u_pe22(.clk(clk), 
                               .rst(rst), 
                               .top   (top_inps  [2  ][2*BIT_W+:BIT_W]), 
                               .left  (left_inps [2  ][2*BIT_W+:BIT_W]), 
                               .right (left_inps [2+1][2*BIT_W+:BIT_W]), 
                               .bottom(top_inps  [2+1][2*BIT_W+:BIT_W])
                               );
   // ROW 2 END
   
endgenerate

/*for (genvar i = 0; i < N; i= i+1) begin :SYSROWS
    for (genvar j = 0; j < N; j=j+1) begin
        PE #(.BIT_W(BIT_W))  u_pe(.clk(clk), 
                                  .rst(rst), 
                                  .top   (top_inps  [i  ][j*BIT_W+:BIT_W]), 
                                  .left  (left_inps [j  ][i*BIT_W+:BIT_W]), 
                                  .right (left_inps [j+1][i*BIT_W+:BIT_W]), 
                                  .bottom(top_inps  [i+1][j*BIT_W+:BIT_W])
                                  );
    end 
end
*/
endmodule
