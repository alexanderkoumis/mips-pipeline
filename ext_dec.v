// Extension begin
module ext_dec(
		  input	[5:0] op,
        input  [5:0] funct,
		  input reg_file_write_sel,
		  input reg_dst_sel_m,
        output reg [3:0] ext_cont,
		  output reg reg_write,
		  output reg reg_dst_sel
);

    always @(*) begin
	 case(op)
		6'b0:
        case (funct)
            6'b001000: ext_cont <= 4'b1000; // jr
            6'b011001: ext_cont <= 4'b0010; // multu
            6'b010010: ext_cont <= 4'b0100; // mflo
            6'b010000: ext_cont <= 4'b0101; // mfhi
            default:   ext_cont <= 4'b0000;
        endcase
		  default: ext_cont <= 4'b0000;
	 endcase
    end
    always @(*) begin
			reg_write = (ext_cont == 4'b0010) ? 0 : reg_file_write_sel;
			reg_dst_sel = (ext_cont == 4'b0010) ? 0 : reg_dst_sel_m;
	 end
endmodule
// Extension end
/*
	 {jr_sel, mul_rd_sel, mul_wr_sel, mul_hi_lo_sel}
*/