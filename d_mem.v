// Data Memory
module d_mem (
        input clk,
        input we,
        input [31:0] addr,
        input [31:0] wd,
        output [31:0] rd
);
  
    reg [31:0] ram[63:0];
    integer n;

    assign rd = ram[addr[31:2]];

    //initialize ram to all FFs
    initial begin
        for (n = 0; n < 64; n = n + 1) begin
            ram[n] = 8'hff;
        end
    end

    always @(posedge clk) begin
        if (we) begin
            ram[addr[31:2]] = wd;
        end
    end
    
endmodule