// Main Decoder
module main_dec(
        input [5:0] op,
        output mem_to_reg_sel,
        output mem_write,
        output branch_sel,
        output alu_src,
        output reg_dst_sel_m,
        output reg_file_write_sel,
        output jump_sel,
        output [1:0] alu_op,
		  output jal_sel
);

    reg  [9:0] controls;

    assign {reg_file_write_sel, reg_dst_sel_m, alu_src, branch_sel, mem_write, mem_to_reg_sel, jump_sel, alu_op, jal_sel} = controls;

    always @(*)
        case(op)
            6'b000000: controls <= 10'b1100000100; //Rtype
            6'b100011: controls <= 10'b1010010000; //LW
            6'b101011: controls <= 10'b0010100000; //SW
            6'b000100: controls <= 10'b0001000010; //BEQ
            6'b001000: controls <= 10'b1010000000; //ADDI
            6'b000010: controls <= 10'b0000001000; //J
// Extended begin
            6'b000011: controls <= 10'b1000001001; //JAL
// Extended end
            default:   controls <= 10'b0; //???
        endcase
endmodule

