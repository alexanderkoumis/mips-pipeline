// Control Unit
module controller(
        input zero,
        input [5:0] op,
        input [5:0] funct,
        output mem_to_reg_sel,
        output mem_write,
        output pc_src_sel,
        output alu_src,
        output reg_dst_sel,
        output reg_write,
        output jump_sel,
        output [2:0] alu_cont,
// Extension begin
        output jal_sel,
        output [3:0] ext_cont
// Extension end
);

    wire branch_sel;
    wire [1:0] alu_op;
	 wire reg_file_write_sel;
	 wire reg_dst_sel_m;

    main_dec main_dec (
        .op          (op),
        .mem_to_reg_sel  (mem_to_reg_sel),
        .mem_write   (mem_write),
        .branch_sel      (branch_sel),
        .alu_src     (alu_src),
        .reg_dst_sel_m (reg_dst_sel_m),
        .reg_file_write_sel   (reg_file_write_sel),
		  .jump_sel		(jump_sel),
        .alu_op      (alu_op),
		  .jal_sel		(jal_sel)
    );

    alu_dec alu_dec (
        .funct    (funct),
        .alu_op   (alu_op),
        .alu_cont (alu_cont)
    );

// Extension begin
    ext_dec ext_dec (
		  .op					(op),
        .funct    		(funct),
		  .reg_file_write_sel (reg_file_write_sel),
		  .reg_dst_sel_m	(reg_dst_sel_m),
        .ext_cont 		(ext_cont),
		  .reg_write		(reg_write),
		  .reg_dst_sel		(reg_dst_sel)
    );
// Extension end

    assign pc_src_sel = branch_sel & zero;

endmodule

