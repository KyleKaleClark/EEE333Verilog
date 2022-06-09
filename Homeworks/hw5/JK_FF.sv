module JK_FF(input J, K, clk, R, En, output reg Q, output Qn);
	always_ff @(posedge clk) begin
		if(En) begin
			if ((R)) Q <= 1'b0;
			else Q <= (J&~Q) | (~K&Q);
		end	
		assign Qn = ~Q;
	end
endmodule //JK_FF


module JK_FF_tb();
`timescale 1ns/1ps
	reg J, K, clk, R, En, Q;
	wire Qn;
	
	JK_FF jkfflop(J, K, clk, R, En, Q, Qn);
	
	initial begin
		$monitor("R=%b En=%b J=%b K=%b Q=%b", R, En, J, K, Q);
		
		En = 1'b0; //testing no enable
		J = 1'b0; K = 1'b0; R = 1'b0; Q = 1'b0; clk = 1'b0; #10; clk = 1'b1; #10;
		J = 1'b0; K = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10;
		J = 1'b1; K = 1'b0; clk = 1'b0; #10; clk = 1'b1; #10;
		J = 1'b1; K = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10;
		R = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10;
		clk = 1'b0; #10; clk = 1'b1; #10;		//testing reset and also resetting for the next set 
		
		En = 1'b1; //testing with an enable
		J = 1'b0; K = 1'b0; R = 1'b0; Q = 1'b0; clk = 1'b0; #10; clk = 1'b1; #10;
		J = 1'b0; K = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10;
		J = 1'b1; K = 1'b0; clk = 1'b0; #10; clk = 1'b1; #10;
		J = 1'b1; K = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10;
		R = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10;
		clk = 1'b0; #10; clk = 1'b1; #10;

	end
endmodule //testbench



























