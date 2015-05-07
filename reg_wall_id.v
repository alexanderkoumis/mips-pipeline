// module reg_wall_id(
//         input        clk,
//         input        reset,
//         input        jal_sel_d,
//         input        pc_src_sel_d,
//         input        jump_sel_d,
//         input        reg_dst_sel_d,
//         input        mem_to_reg_sel_d,
//         input        alu_src_d,
//         input [3:0]  ext_cont_d,
//         input [31:0] rf_rd1_d,
//         input [31:0] rf_rd2_d,
//         input [31:0] instr_d,
//         input [15:0] sext_d,

//         output            jal_sel_q,
//         output            pc_src_sel_q,
//         output            jump_sel_q,
//         output            reg_dst_sel_q,
//         output            mem_to_reg_sel_q,
//         output            alu_src_q,
//         output      [3:0] ext_cont_q,
//         output reg [31:0] rf_rd1_q,
//         output reg [31:0] rf_rd2_q,
//         output reg [31:0] instr_q,
//         output reg [15:0] sext_q
// );

//     always @ (posedge clk, posedge reset) begin
//         if (reset) begin
//             jal_sel_q <= 0;
//             pc_src_sel_q <= 0;
//             jump_sel_q <= 0;
//             reg_dst_sel_q <= 0;
//             mem_to_reg_sel_q <= 0;
//             alu_src_q <= 0;
//             ext_cont_q <= 0;
//             rf_rd1_q <= 0;
//             rf_rd2_q <= 0;
//             instr_q <= 0;
//             sext_q <= 0;
//         end else begin
//             jal_sel_q <= jal_sel_d;
//             pc_src_sel_q <= pc_src_sel_d;
//             jump_sel_q <= jump_sel_d;
//             reg_dst_sel_q <= reg_dst_sel_d;
//             mem_to_reg_sel_q <= mem_to_reg_sel_d;
//             alu_src_q <= alu_src_d;
//             ext_cont_q <= ext_cont_d;
//             rf_rd1_q <= rf_rd1_d;
//             rf_rd2_q <= rf_rd2_d;
//             instr_q <= instr_d;
//             sext_q <= sext_d;
//         end
//     end

// endmodule