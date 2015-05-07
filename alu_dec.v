module alu_dec(
        input      [5:0] funct,
        input      [1:0] alu_op,
        output reg [2:0] alu_cont
);

    wire extended;

    assign extended = funct[5];

    always @(*) begin
        case (alu_op)
            2'b00: alu_cont <= 3'b010;         // add
            2'b01: alu_cont <= 3'b110;         // sub
            default: case(funct)               // rtype
                6'b100000: alu_cont <= 3'b010; // add
                6'b100010: alu_cont <= 3'b110; // sub
                6'b100100: alu_cont <= 3'b000; // and
                6'b100101: alu_cont <= 3'b001; // or
                6'b101010: alu_cont <= 3'b111; // slt
                6'b001000: alu_cont <= 3'b000; // jr
                6'b011001: alu_cont <= 3'b000; // multu
                6'b010010: alu_cont <= 3'b000; // mflo
                6'b010011: alu_cont <= 3'b000; // mfhi
                default:   alu_cont <= 3'b0; // ???
            endcase
        endcase
    end
    
endmodule