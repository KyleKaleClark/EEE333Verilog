module synCounterStructural(input clk, R, input [3:0] maxCount, output logic [3:0] count, output logic Z);

	logic [3:0] count, nextCount;
	logic Z;
	wire [2:0] D;
	assign nextCount = Count + 1'b1;
	assign Z = (count == maxCount) ? 1 : 0;
	MUX21 mux(3'b0, nextCount, (Z | R), D);
	//might need to ^ swap A and B
	DReg dregi(D, clk, (Z|R), count);

endmodule

//instantiated modules
module DReg(input [2:0] D, input clk, reset, output logic [2:0] Q);	
	always_ff @ (posedge clk or posedge reset) begin
		if (reset) Q<=3'd0;
		else Q <= D;	
	end
endmodule

module MUX21(input [2:0] A, B, input S, output [2:0] Y);
	assign Y = (S) ? A : B;
endmodule


//testbenches
module CounterComparisons_tb();
`timescale 1ns/1ps
	reg clk, R, maxCount;
	logic [3:0] countB, countS;
	logic ZB, ZS;

	synCounter Bcounter(clk, R, maxCount, countB, ZB);
	synCounterStructural(clk, R, maxCount, countS, ZS);
	
	initial begin
		maxCount = 1'd6;
		countB = 1'b0; countS = 1'b0;
		ZB = 1'b0; ZS = 1'b0;

		$monitor("R=%b clk=%b countB=%b countS=%b ZB=%b ZS=%b", R, clk, countB, countS, ZB, ZS);
		
		R = 1'b1;
		clk = 1'b0; #10; clk = 1'b1; #10;
		R = 1'b0;
		clk = 1'b0; #10; clk = 1'b1; #10;//0
		clk = 1'b0; #10; clk = 1'b1; #10;//1
		clk = 1'b0; #10; clk = 1'b1; #10;//2
		clk = 1'b0; #10; clk = 1'b1; #10;//3
		clk = 1'b0; #10; clk = 1'b1; #10;//4
		clk = 1'b0; #10; clk = 1'b1; #10;//5
		clk = 1'b0; #10; clk = 1'b1; #10;//0
		clk = 1'b0; #10; clk = 1'b1; #10;//1
		clk = 1'b0; #10; clk = 1'b1; #10;//2
		clk = 1'b0; #10; clk = 1'b1; #10;//3
		clk = 1'b0; #10; clk = 1'b1; #10;//4
		clk = 1'b0; #10; clk = 1'b1; #10;//5
		clk = 1'b0; #10; clk = 1'b1; #10;//0
		clk = 1'b0; #10; clk = 1'b1; #10;//1





endmodule

















