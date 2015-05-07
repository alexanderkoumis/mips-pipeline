// register file with one write port and three read ports
// the 3rd read port is for prototyping dianosis
module reg_file( 
        input clk, 
        input we3, 
        input [4:0] ra1,
        input [4:0] ra2,
        input [4:0] wa3, 
        input  [31:0] wd3, 
        output [31:0] rd1,
        output [31:0] rd2,
        input  [4:0]  ra4,
        output [31:0]  rd4,
        output [31:0] s0
);

  reg  [31:0]  rf[31:0];
  integer     n;
  
  //initialize registers to all 0s
  initial begin
    for (n=0; n<32; n=n+1) 
      rf[n] = 32'h00;
    rf[29] = 32'h3c;  
	end
  //write first order, include logic to handle special case of $0
    always @(posedge clk)
      if (we3) begin
        if (~wa3[4]) begin
          rf[{28'b0,wa3[3:0]}] <= wd3;
        end else begin
          rf[{28'b1,wa3[3:0]}] <= wd3;
        end
      end
      // this leads to 72 warnings
      //rf[wa3] <= wd3;
      
      // this leads to 8 warnings
      //if (~ wa3[4])
      //  rf[{0,wa3[3:0]}] <= wd3;
      //else
      //  rf[{1,wa3[3:0]}] <= wd3;
    
  assign rd1 = (ra1 != 0) ? rf[ra1[4:0]] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2[4:0]] : 0;
  assign rd4 = (ra4 != 0) ? rf[ra4[4:0]] : 0;
  assign s0 = rf[16];
endmodule

