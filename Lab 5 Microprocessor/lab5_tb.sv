module lab5_tb();

	logic clk, reset;

	lab5 labtb(clk, reset, opcode, state, pc, alu_out, w_reg, cout, of);
	
	initial begin
	
		
		clk = 1'b0; reset = 1'b1; #10;
		reset = 1'b0; #10;
		
		repeat(700) begin
			clk = ~clk;
		end	
	end
endmodule