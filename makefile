MIPS_PARTS=adder.v alu.v alu_dec.v ext_dec.v flopr.v main_dec.v mult.v mux_2.v reg_file.v sign_ext.v sl_2.v hi_lo_reg.v clk_gen.v
MIPS_REG=reg_wall_if.v reg_wall_id.v
MIPS_MEM=d_mem.v i_mem.v
MIPS_TOP=mips_top.v mips.v controller.v data_path.v disp_hex.v
MIPS_FILES=mips_tb.v $(MIPS_TOP) $(MIPS_MEM) $(MIPS_REG) $(MIPS_PARTS)

all:
	iverilog -o mips $(MIPS_FILES)
