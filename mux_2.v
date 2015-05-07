// Parameterized 2-to-1 MUX
module mux_2 #(parameter WIDTH = 8) (
        input s,
        input [WIDTH-1:0] d0,
        input [WIDTH-1:0] d1, 
        output [WIDTH-1:0] y
);

    assign y = s ? d1 : d0; 

endmodule