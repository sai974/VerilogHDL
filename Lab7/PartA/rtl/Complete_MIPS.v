module Complete_MIPS( input CLK,
                      input CLK_1HZ_en, 
                      input RST, 
                      input halt, 
                      output [7:0] R0_lsbs);
                         
/* Will need to be modified to add functioality */ 

wire CS, WE; 
wire [31:0] ADDR, Mem_Bus;

MIPS CPU(.CLK(CLK), .CLK_EN(CLK_1HZ_en), .RST(RST), .halt(halt), .CS(CS),
         .WE(WE), .ADDR(ADDR), .R0_lsbs(R0_lsbs), .Mem_Bus(Mem_Bus));
         
Memory MEM(CS, WE, CLK, ADDR, Mem_Bus);

endmodule