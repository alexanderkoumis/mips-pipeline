# SJSU CmpE 140 Single-cycle MIPS processor

## Control Unit

* Supported op-codes
  - Original: add, sub, and, or, slt, lw, sw, beq, j, addi
  - Extended: multu, mfhi, mflo, jr, jal

* Control signals
  - Original: mem_to_reg, mem_write, pc_src, alu_src, reg_dst_sel, reg_write, jump
  - Extended: mov_lo_to_hi, mult_mem, jal_mux, mul_mux

## Data Path

### Components added

* Mux_Jump
  - 0: Mux_PCSrc_1
  - 1: SL2_IR_15_0
  - Out -> Mux_PCSrc_2
* Mux_PCSrc_2
  - 0: Mux_Jump
  - 1: RF.RD1
  - Out -> IR.A
* Mux_JalMux_1
  - 0: Mux_RegDst
  - 1: 5'b11111 
  - Out -> RF.WA
* Mux_JalMux_2
  - 0: Mux_MultiMem
  - 1: ALU_PCP4
  - Out -> RF.WD
* Mux_MultiMem
  - 0: Mux_MemToReg
  - 1: Mux_MulMux
  - Out -> Mux_JalMux_2
* Mux_MulMux
  - 0: Reg_Hi.Q
  - 1: Reg_Lo.Q 
  - Out -> Mux_MultiMem.1
* Mult
  - X: RF.RD1
  - Y: RF.RD2
  - ZH: Reg_Hi.D
  - ZL: Reg_Lo.D
* Reg_Hi
  - D: Mult.ZH
  - Q: Mux_MulMux.0
  - clk
* Reg_Hi
  - D: Mult.ZL
  - Q: Mux_MulMux.1
  - clk
