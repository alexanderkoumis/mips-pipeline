`timescale 1ns / 1ps
module mips_tb();

    localparam max_cycles = 100;
    integer num_cycles;

    reg clk;
    reg reset;
    reg [7:0] switches;
    reg [31:0] last_pc;
    reg [31:0] last_instr;
    reg [4:0] reg_probe;


    wire mem_write;
    wire sink_bit;
    wire [3:0] top_an;
    wire [7:0] top_sseg;
    wire signed [31:0] instr;
    wire [31:0] s0;
    reg [31:0] exp_next_pc;

    integer i;
    wire [31:0] pc_q;
    wire [4:0] jal_wa_data;
    wire [31:0] jal_pc_data;
    wire [31:0] disp_data;

    mips_top mips_top(
        .reg_probe   (reg_probe),
        .clk         (clk),
        .reset       (reset),
        .switches    (switches),
        .memwrite    (mem_write),
        .sinkBit     (sink_bit),
        .top_an      (top_an),
        .top_sseg    (top_sseg),
        .instr       (instr),
        .s0          (s0),
        .pc          (pc_q),
        .reg_write   (reg_write),
        .jal_sel     (jal_sel),
        .jal_wa_data (jal_wa_data),
        .jal_pc_data (jal_pc_data),
        .dispDat     (disp_data)
    );

    initial begin

        $dumpfile("mips.vcd");
        $dumpvars(0, mips_tb);

        num_cycles = 0;
        clk = 0;
        switches = 8'b00000000;
        reset = 1;
        i = 0;

        #5
        reset = 0;
        reg_probe = 0;

    end

    always @ (posedge clk) begin
        test_op(instr);
        if(instr == 32'h08000015) begin
            if (s0 != 24) begin
                $display("Error! 4! != %d", s0);
            end else begin
                $display("Success! 4! == 24\n");
            end
            $finish;
        end
    end

    task test_op;
        input [31:0] instr;
        case (instr[31:26])
            6'b000000: case(instr[5:0])
                 6'b100000: r_type("add");
                 6'b001000: r_type("jr");
            endcase
            6'b001000: i_type("addi");
            6'b000010: j_type("j");
            6'b000011: j_type("jal");
        endcase
    endtask

    task i_type (input [4*8:0] str);
        case (str)
            "addi": begin
                i_print(str);
                if (!reg_write) begin
                    $display("Error - %addi: Mem write should be 1");
                end
            end
        endcase
    endtask

    task j_type(input [4*8:0] str);
        case (str)
            "jal": begin
                j_print(str);
                last_pc = pc_q;
                last_instr = instr;
                if (!jal_sel) begin
                    $display("Error - JAL: Jal select should be 1");
                end else if (!reg_write) begin
                    $display("Error - JAL: Mem write should be 1");
                end else if (jal_wa_data !== 31) begin
                    $display("Error - JAL: Write address: %d, not 31", jal_wa_data);
                end else if (jal_pc_data !== pc_q + 8) begin
                    $display("Error - JAL: PC stored should be %d, not %d", pc_q + 8, jal_pc_data);
                end
                reg_probe = 31;
                exp_next_pc = {last_pc[31:28], last_instr[25:0], 2'b0};
                #10
                if (pc_q !== exp_next_pc) begin
                    $display("Error - JAL: PC after JAL should be %d, not %d", exp_next_pc, pc_q);
                end else if (disp_data !== last_pc + 8) begin
                    $display("Error - JAL: PC stored should be %d, not %d", last_pc + 8, disp_data);
                end
            end
        endcase
    endtask

    task r_type(input [4*8:0] str);
        case(str)
            "add": begin
                r_print(str);
            end
            "jr": begin
                r_print(str);
            end
            "j": begin
                r_print(str);
            end
        endcase
    endtask

    task i_print (input [4*8:0] str);
        $display("pc: %x\top: %s\trs: %d\trt: %d\timm: %d", pc_q, str, instr[25:21], instr[20:16],  instr[15:0]);
    endtask

    task j_print (input [4*8:0] str);
        $display("pc: %x\top: %s\timm: %x", pc_q, str, instr[25:0]);
    endtask

    task r_print (input [4*8:0] str);
        $display("pc: %x\top: %s\trs: %d\trt: %d\trd: %d\tsh_amt: %d\tbinary: %b", pc_q, str, instr[25:21], instr[20:16], instr[15:11], instr[10:6], instr[5:0]);
    endtask

    task reg_print;
        for (i = 0; i < 32; i = i + 1) begin
            reg_probe = i;
            #10
            $display("reg %d: %x", i, disp_data);
        end
    endtask

    always begin
        #5 clk = !clk;
    end

endmodule