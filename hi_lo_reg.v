`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:11:05 04/15/2015 
// Design Name: 
// Module Name:    hi_lo_reg 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module hi_lo_reg(
				input clk, we, reset,
				input [31:0] d,
				output reg [31:0] q );
	always @ (posedge clk, posedge reset) begin
		if (reset) begin
			q <= 0;
		end
		else if (we) begin
			q <= d;
		end
		else
			q <= q;
	end

endmodule
