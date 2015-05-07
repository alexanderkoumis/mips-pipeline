module mult (
        input  [31:0] x,
        input  [31:0] y,
        output [31:0] zl,
        output [31:0] zh
);

    wire [63:0] result;
    assign result = x * y;
    assign zl = result[31:0];
    assign zh = result[63:32];

endmodule