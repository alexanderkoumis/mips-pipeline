module alu (
        input [2:0]  alu_cont, 
        input [31:0] a,
        input [31:0] b,
        output zero,
        output reg [31:0] result
);

    wire [31:0] b2;
    wire [31:0] sum;
    wire [31:0] slt;

    assign b2 = alu_cont[2] ? ~b:b; 
    assign sum = a + b2 + alu_cont[2];
    assign slt = sum[31];
    assign zero = (result == 32'b0);

    always @(*) begin
        case(alu_cont[1:0])
          2'b00: result <= a & b;
          2'b01: result <= a | b;
          2'b10: result <= sum;
          2'b11: result <= slt;
        endcase
    end

endmodule