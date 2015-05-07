module mips (
        input clk,
        input reset,
        input [4:0]  disp_sel,
        input [31:0] read_data,
        input [31:0] instr,
        output mem_write,
        output [31:0] pc_q,
        output [31:0] alu_out,
        output [31:0] rf_rd2,
        output [31:0] disp_data,
        output [31:0] s0,
        output reg_write,
        output jal_sel,
/// Debug
        output [4:0] jal_wa_data,
        output [31:0] jal_pc_data
);

    wire mem_to_reg;
    wire pc_src_sel;
    wire zero;
    wire alu_src;
    wire reg_dst_sel;
    wire jump_sel;
    wire [2:0] alu_cont;
// Extension begin
    wire [3:0] ext_cont;
// Extension end

    controller controller (
        .zero        (zero),
        .op          (instr[31:26]),
        .funct       (instr[5:0]),
        .mem_to_reg_sel  (mem_to_reg_sel),
        .mem_write   (mem_write),
        .pc_src_sel  (pc_src_sel),
        .alu_src     (alu_src),
        .reg_dst_sel (reg_dst_sel),
        .reg_write   (reg_write),
        .jump_sel    (jump_sel),
        .jal_sel     (jal_sel),
        .alu_cont    (alu_cont),
        .ext_cont    (ext_cont)
    );

    data_path data_path (
        .clk            (clk),
        .reset          (reset),
        .mem_to_reg_sel     (mem_to_reg_sel),
        .pc_src_sel     (pc_src_sel),
        .alu_src        (alu_src),
        .reg_dst_sel    (reg_dst_sel),
        .reg_write      (reg_write),
        .jal_sel        (jal_sel),
        .jump_sel       (jump_sel),
        .alu_cont       (alu_cont),
        .ext_cont       (ext_cont),
        .disp_sel       (disp_sel),
        .instr          (instr),
        .read_data      (read_data),
        .zero           (zero),
        .pc_q           (pc_q),
        .alu_out        (alu_out),
        .rf_rd2_id      (rf_rd2),
        .disp_data      (disp_data),
        .s0             (s0),
        .jal_wa_data_wb (jal_wa_data),
        .jal_pc_data_wb (jal_pc_data)

    );

endmodule