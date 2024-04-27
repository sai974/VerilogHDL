`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2024 00:32:12
// Design Name: 
// Module Name: MIPS
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
/////////////////////////////////////////////////////////////////////////////////
`define opcode      instr[31:26]
`define sr1         instr[25:21]
`define sr2         instr[20:16]
`define f_code      instr[5:0]
`define numshift    instr[10:6]

module MIPS(    input CLK,
                input CLK_EN, 
                input RST,
                input [31:0] R1,
                output reg CS, 
                output reg WE, 
                output [31:0] ADDR,
                output [7:0] R0_lsbs,
                output [31:0] R2, 
                inout [31:0] Mem_Bus);

// special instructions (opcode == 000000), values of F code (bits 5-0) :
parameter add  = 6'b100000;
parameter sub  = 6'b100010; 
parameter xor1 = 6'b100110; 
parameter and1 = 6'b100100; 
parameter or1  = 6'b100101; 
parameter slt  = 6'b101010; 
parameter srl  = 6'b000010; 
parameter sll  = 6'b000000; 
parameter jr   = 6'b001000; 
parameter rbit = 6'b101111;//NEW 
parameter rev  = 6'b110000;//NEW  
parameter add8 = 6'b101101;//NEW 
parameter sadd =6'b110001;//NEW 
parameter ssub = 6'b110010;//NEW 

// non special instructions, values of opcodes
parameter addi = 6'b001000; 
parameter andi = 6'b001100; 
parameter ori  = 6'b001101; 
parameter lw   = 6'b100011; 
parameter sw   = 6'b101011; 
parameter beq  = 6'b000100; 
parameter bne  = 6'b000101; 
parameter j    = 6'b000010; 
parameter jal  = 6'b000011; //NEW
parameter lui  = 6'b001111; //NEW

//instruction format 
parameter R = 2'd0; 
parameter I = 2'd1; 
parameter J = 2'd2; 
//internal signals 
reg [5:0] op, opsave; 
wire [1:0] format; 
reg [31:0] instr, pc, npc, alu_result; 
wire [31:0] imm_ext, alu_in_A, alu_in_B, reg_in, readreg1, readreg2; 
reg [31:0] alu_result_save; 
reg alu_or_mem, alu_or_mem_save, regw, writing, reg_or_imm, reg_or_imm_save; 
reg fetchDorI;
wire [4:0] dr; 
reg [2:0] state, nstate; 

// combinational 
assign imm_ext = (instr[15] == 1) ? {16'hFFFF, instr[15:0]} :
                                    {16'h0000, instr[15:0]};// sign extend the immediate field 

wire [4:0] dr_format_R; 
assign dr_format_R = ((`f_code == rbit) || (`f_code == rev)) ? instr[25:21] : instr[15:11]; 

// Destination Register MUX (MUX1)
assign dr = (`opcode != jal) ? ((format == R) ? dr_format_R : instr[20:16]) : 
                               5'd31; //NEW

// ALU MUX (MUX2) 
assign alu_in_A = readreg1;
assign alu_in_B = (reg_or_imm_save) ? imm_ext : readreg2 ;
//Data MUX
assign reg_in = (alu_or_mem_save) ? Mem_Bus : alu_result_save;

assign format = (`opcode == 6'd0) ? R : ((`opcode == 6'd2) ? J : I ); 

//drive memory bus only during the writes 
assign Mem_Bus = (writing) ? readreg2 : 32'bz; 

assign ADDR = (fetchDorI) ? pc : alu_result_save; 
//ADDR Mux
REG Register (CLK, regw, dr, `sr1, `sr2, reg_in, readreg1, readreg2, R0_lsbs, R2, R1); 

initial begin 
    op = and1; 
    opsave = and1; 
    state = 3'b0; 
    nstate = 3'b0; 
    alu_or_mem = 0; 
    regw = 0; 
    fetchDorI = 0; 
    writing = 0; 
    reg_or_imm = 0; 
    reg_or_imm_save = 0; 
    alu_or_mem_save = 0; 
end 

always @(*) begin 
    fetchDorI = 0; 
    CS = 0; 
    WE = 0; 
    regw = 0; 
    writing = 0; 
    alu_result = 32'd0; 
    npc = pc; 
    op = jr; 
    reg_or_imm = 0; 
    alu_or_mem = 0;
    
    nstate = 3'd0;// ADDED TODO 

    case (state)
        0: begin //fetch 
            npc = pc + 32'd1; 
            CS = 1; 
            nstate = 3'd1; 
            fetchDorI = 1;
        end
        1: begin 
            nstate = 3'd2; 
            reg_or_imm = 0; 
            alu_or_mem = 0; 
            if (format == J) begin // jump, and finish 
                npc = {pc[31:26], instr[25:0]}; 
                nstate = 3'd0; 
            end else if (format == R) begin // register instructions 
                op = `f_code; 
            end else if (format == I) begin // immediate instruction 
                reg_or_imm = 1; 
                if (`opcode == lw) begin 
                    op = add; 
                    alu_or_mem = 1; 
                end else if ((`opcode == lw) || (`opcode == sw) || (`opcode == addi)) begin 
                    op = add;
                end else if ((`opcode == beq) || (`opcode == bne)) begin 
                    op = sub; 
                    reg_or_imm = 0;
                end else if (`opcode == andi) op = and1; 
                else if (`opcode == ori) op = or1; 
                else if (`opcode == lui) begin // NEW
                    op = lui;//NEW
                end 
                else if (`opcode == jal) begin 
                    op = add;//NEW
                end
            end 
        end
        2: begin //execute 
            nstate = 3'd3; 
            if (opsave == and1) alu_result = alu_in_A & alu_in_B; 
            else if (opsave == or1) alu_result = alu_in_A | alu_in_B; 
            else if (opsave == add) alu_result = alu_in_A + alu_in_B; 
            else if (opsave == sub) alu_result = alu_in_A - alu_in_B; 
            else if (opsave == srl) alu_result = alu_in_B >> `numshift; 
            else if (opsave == sll) alu_result = alu_in_B << `numshift; 
            else if (opsave == slt) alu_result = (alu_in_A < alu_in_B) ? 32'd1 : 32'd0; 
            else if (opsave == xor1) alu_result = alu_in_A ^ alu_in_B; 
            else if (opsave == rbit) alu_result = reverseBits(alu_in_B); //NEW
            else if (opsave == rev)  alu_result = reverseBytes(alu_in_B); //NEW
            else if (opsave == add8) alu_result = addBytewise(alu_in_A, alu_in_B); //NEW 
            else if (opsave == sadd) alu_result = saturatingAdd(alu_in_A, alu_in_B); //NEW
            else if (opsave == ssub) alu_result = saturatingSub(alu_in_A, alu_in_B); //NEW
            else if (opsave == lui)  alu_result = alu_in_B << 16; //NEW

            if (((alu_in_A == alu_in_B) && (`opcode == beq)) || 
                ((alu_in_A != alu_in_B) && (`opcode == bne))) begin 
                npc = pc + imm_ext; 
                nstate = 3'd0;
            end else if ((`opcode == bne) && (`opcode == beq)) nstate = 3'd0; 
            else if (`opcode == jal) begin 
                alu_result = pc;
                nstate = 3'd3; 
            end else if (opsave == jr) begin 
                npc = alu_in_A; 
                nstate = 3'd0; 
            end 
        end
        3: begin // prepare to write to mem 
            nstate = 3'd0; 
            if (`opcode == jal) begin
                regw = 1; 
                npc = imm_ext;
            end if ((format == R) || (`opcode == addi) || 
                    (`opcode == andi) || (`opcode == ori) || 
                    (`opcode == lui)) begin
                regw = 1; 
            end else if (`opcode == sw) begin 
                CS = 1; 
                WE = 1; 
                writing = 1; 
            end else if (`opcode == lw) begin 
                CS = 1; 
                nstate = 3'd4; 
            end 
        end 
        4: begin 
            nstate = 3'd0; 
            CS = 1; 
            if (`opcode == lw) regw = 1; 
            
        end
        default : begin 
            nstate = 3'd0;
        end 
    endcase

end // always 

always @(posedge CLK) begin 
    if (CLK_EN) begin
        if (RST) begin 
          state <= 3'd0 ; 
          pc <= 32'd0; 
        end else begin 
          state <= nstate; 
          pc <= npc;
        end
    
        if (state == 3'd0) begin 
           instr <= Mem_Bus;
        end else if (state == 3'd1) begin 
            opsave <= op; 
            reg_or_imm_save <= reg_or_imm; 
            alu_or_mem_save <= alu_or_mem;
        end else if  (state == 3'd2) begin 
            alu_result_save <= alu_result; 
        end
    end
end // always 


function [31:0] reverseBits(input [31:0] input_word);
integer i; 
begin 
    for (i = 0; i < 32;i = i + 1'b1) begin 
        reverseBits[31-i] = input_word[i];
    end 
end
endfunction 
 
function [31:0] reverseBytes(input [31:0] input_word); 
integer i; 
begin 
    for (i = 0; i < (32/8);i = i + 1'b1) begin 
        reverseBytes[(31-i*8)-:8] = input_word[i*8+:8];
    end 
end
endfunction 

function [31:0] addBytewise(input [31:0] input_word1, input_word2);
integer i;
begin 
    for (i = 0; i < (32/8);i = i + 1'b1) begin 
        addBytewise[i*8+:8] = input_word1[i*8+:8] + input_word2[i*8+:8];
    end 
end
endfunction  

function [31:0] saturatingAdd(input [31:0] input_word1, input_word2);
integer i;
integer overflow;
begin 
   saturatingAdd = input_word1 + input_word2;
   overflow = (input_word1[31] && input_word2[31] && !saturatingAdd[31]) ||
              (!input_word1[31] && !input_word2[31] && saturatingAdd[31]); 
   saturatingAdd = (overflow) ? {31{1'b1}} : saturatingAdd;
end
endfunction 

function [31:0] saturatingSub(input [31:0] input_word1, input_word2);
integer i;
integer underflow;
begin 
   underflow = input_word1 < input_word2; 
   saturatingSub = input_word1 - input_word2;
   saturatingSub = (underflow) ? {31{1'b0}} : saturatingSub;
end
endfunction            

endmodule
