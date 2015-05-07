// Instruction Memory
module i_mem (
        input  [5:0]  addr,
        output [31:0] instr
);
  
    reg [31:0] rom[0:63];
  
    //initialize rom from memfile_s.dat
    initial begin
        $readmemh("memfile_s.dat", rom);
    end

    assign instr = rom[addr];

endmodule