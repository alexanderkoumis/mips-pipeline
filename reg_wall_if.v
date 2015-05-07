module reg_wall_if(
        input clk,
        input reset,
        input [31:0] instr_d,
        input [31:0] pc_plus_4_d,
        output reg [31:0] instr_q,
        output reg [31:0] pc_plus_4_q
);

    always @ (posedge clk, posedge reset) begin
        if (reset) begin
            instr_q <= 0;
            pc_plus_4_q <= 0;
        end else begin
            instr_q <= instr_d;
            pc_plus_4_q <= pc_plus_4_d;
        end
    end

endmodule