// Data Path (excluding the instruction and data memories)
module data_path(
        input clk,
        input reset,
        input mem_to_reg_sel,
        input pc_src_sel,
        input alu_src,
        input reg_dst_sel,
        input reg_write,
        input jump_sel,
        input jal_sel,
        input [2:0] alu_cont,
        input [4:0] disp_sel,
        input [31:0] instr,
        input [31:0] read_data,
        input [3:0] ext_cont,
        output zero,
        output [31:0] pc_q,
        output [31:0] alu_out,
        output [31:0] rf_rd2_id,
        output [31:0] disp_data,
// Debug
        output [31:0] s0,
        output [4:0] jal_wa_data_wb,
        output [31:0] jal_pc_data_wb
);

    wire [4:0]  reg_dst_data;
    wire [31:0] jump_data;
    wire [31:0] pc_src_data;
    wire [31:0] pc_plus_4;
    wire [31:0] add_branch;
    wire [31:0] instr_sext_id;
    wire [31:0] instr_sext_sh_id;
    wire [31:0] rf_rd1_id;
    wire [31:0] alu_src_b;
    wire [31:0] mem_to_reg_data;

    wire [31:0] zh_d;
    wire [31:0] zh_q;
    wire [31:0] zl_d;
    wire [31:0] zl_q;
    wire  [4:0] jal_wa_data_wb;
    wire [31:0] jal_pc_data_wb;
    wire [31:0] jr_data;
    wire [31:0] mul_hi_lo_data;
    wire [31:0] mul_rd_data;


//// INSTRUCTION FETCH ///////////////////

    wire [31:0] instr_if;
    wire [31:0] pc_plus_4_if;

    flopr #(32) reg_pc (
        .clk   (clk),
        .reset (reset),
        .d     (jr_data),
        .q     (pc_q)
    );

    adder adder_pc_plus_4 (
        .a (pc_q),
        .b (32'b100),
        .y (pc_plus_4)
    );

//// INSTRUCTION FETCH ////////////////
///////////////////////////////////////

    reg_wall_if reg_wall_if(
        .clk         (clk),
        .reset       (reset),
        .instr_d     (instr),
        .pc_plus_4_d (pc_plus_4),
        .instr_q     (instr_if),
        .pc_plus_4_q (pc_plus_4_if)
    );

///////////////////////////////////////
//// INSTRUCTION DECODE ///////////////


    reg_file reg_file(
        .clk (clk),
        .we3 (reg_write),
        .ra1 (instr_if[25:21]),
        .ra2 (instr_if[20:16]),
        .wa3 (jal_wa_data_wb),
        .wd3 (jal_pc_data_wb),
        .rd1 (rf_rd1_id),
        .rd2 (rf_rd2_id),
        .ra4 (disp_sel),
        .rd4 (disp_data)
    );

    sign_ext sign_ext (
        .a (instr_if[15:0]),
        .y (instr_sext_id)
    );

//// INSTRUCTION DECODE ///////////////
///////////////////////////////////////

    

    // reg_wall_id reg_wall_id (
    //     .clk              (clk),
    //     .reset            (reset),
    //     .jal_sel_d        (jal_sel_id)
    //     .pc_src_sel_d     (pc_src_sel_id)
    //     .jump_sel_d       (jump_sel_id)
    //     .reg_dst_sel_d    (reg_dst_sel_id)
    //     .mem_to_reg_sel_d (mem_to_reg_sel_id)
    //     .alu_src_d        (alu_src_id)
    //     .rf_rd1_d         (rf_rd1_id),
    //     .rf_rd2_d         (rf_rd2_id),
    //     .instr_d          (instr_if),
    //     .sext_d           (sext_e),

    //     .rf_rd1_q         (rf_rd1_e),
    //     .rf_rd2_q         (rf_rd2_e),
    //     .instr_q          (instr_e),
    //     .sext_q           (sext_q),
    //     .jal_sel_q        (jal_sel_e),
    //     .pc_src_sel_q     (pc_src_sel_e),
    //     .jump_sel_q       (jump_sel_e),
    //     .reg_dst_sel_q    (reg_dst_sel_e),
    //     .mem_to_reg_sel_q (mem_to_reg_sel_e),
    //     .alu_src_q        (alu_src_e)
    // );




///////////////////////////////////////
//// EXECUTE //////////////////////////





//// EXECUTE //////////////////////////



    mux_2 #(32) mux_jal_pc (
        .s  (jal_sel),
        .d0 (mul_rd_data),
        .d1 (pc_plus_4_if),
        .y  (jal_pc_data_wb)
    );

    mult mult (
        .x  (rf_rd1_id),
        .y  (rf_rd2_id),
        .zh (zh_d),
        .zl (zl_d)
    );
    
    hi_lo_reg reg_hi (
        .clk   (clk),
        .reset (reset),
          .we       (ext_cont[1]),
        .d     (zh_d),
        .q     (zh_q)
    );

    hi_lo_reg reg_lo (
        .clk   (clk),
        .reset (reset),
          .we       (ext_cont[1]),
        .d     (zl_d),
        .q     (zl_q)
    );

    mux_2 #(32) mux_mul_hi_lo (
        .s  (ext_cont[0]),
        .d0 (zl_q),
        .d1 (zh_q),
        .y  (mul_hi_lo_data)
    );

    mux_2 #(32) mux_mul_mem (
        .s  (ext_cont[2]),
        .d0 (mem_to_reg_data),
        .d1 (mul_hi_lo_data),
        .y  (mul_rd_data)
    );

    mux_2 #(5) mux_jal_wa (
        .s  (jal_sel),
        .d0 (reg_dst_data),
        .d1 (5'b11111),
        .y  (jal_wa_data_wb)
    );


    mux_2 #(32) mux_jr (
        .s  (ext_cont[3]),
        .d0 (jump_data),
        .d1 (rf_rd1_id),
        .y  (jr_data)
    );
// Extension end



    adder adder_pc_branch (
        .a (pc_plus_4_if),
        .b (instr_sext_sh_id),
        .y (add_branch)
    );

    sl_2 sl_2_sign_imm (
        .a (instr_sext_id),
        .y (instr_sext_sh_id)
    );

    mux_2 #(32) mux_pc_src (
        .s  (pc_src_sel),
        // .d0 (pc_plus_4),
        .d0 (pc_plus_4_if),
        .d1 (add_branch),
        .y  (pc_src_data)
    );

    mux_2 #(32) pc_mux (
        .s  (jump_sel),
        .d0 (pc_src_data),
        .d1 ({pc_plus_4_if[31:28], instr_if[25:0], 2'b00}),
        .y  (jump_data)
    );
    mux_2 #(5) wr_mux(
        .s  (reg_dst_sel),
        .d0 (instr_if[20:16]),
        .d1 (instr_if[15:11]),
        .y  (reg_dst_data)
    );

    mux_2 #(32) mux_mem_to_reg (
        .s  (mem_to_reg_sel),
        .d0 (alu_out),
        .d1 (read_data),
        .y  (mem_to_reg_data)
    );



    // ALU logic
    mux_2 #(32) mux_alu_src (
        .s  (alu_src),
        .d0 (rf_rd2_id),
        .d1 (instr_sext_id),
        .y  (alu_src_b)
    );

    alu alu (
        .alu_cont (alu_cont),
        .a        (rf_rd1_id),
        .b        (alu_src_b),
        .zero     (zero),
        .result   (alu_out)
    );




endmodule
