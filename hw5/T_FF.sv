module T_FF(input T, R, En, clk, output reg Q, output Qn);
	always @(posedge clk) begin
		if(En) begin
			if (R) Q <= 1'b0; 
			else Q <= T ^ Q;
		end
	end
	assign Qn = ~Q;
endmodule

module T_FF_tb();
//`timescale 1ns/1ps
	reg T, R, En, clk, Q; 
	wire Qn; 
	
	T_FF teeflipflop(T, R, En, clk, Q, Qn);
	
	initial begin
		$monitor("R=%b En=%b T=%b Q=%b", R, En, T, Q);
		
		En = 1'b0; //testing no enable ALL 0s
		T = 1'b0; clk = 1'b0; #10; clk = 1'b1; #10;
		T = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10;
		T = 1'b0; clk = 1'b0; #10; clk = 1'b1; #10;
		T = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10;
		clk = 1'b0; #10; clk = 1'b1; #10;
		
		En = 1'b1; //tested w/ enables 
		T = 1'b0; clk = 1'b0; #10; clk = 1'b1; #10;
		T = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10;
		T = 1'b0; clk = 1'b0; #10; clk = 1'b1; #10;
		T = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10;
		clk = 1'b0; #10; clk = 1'b1; #10;
		
		T = 1'b0; clk = 1'b0; #10; clk = 1'b1; #10;
		T = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10;
		clk = 1'b0; #10; clk = 1'b1; #10;
		R = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10; //test reset :)
	end
endmodule