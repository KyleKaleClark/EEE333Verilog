module synCounter(input clk, R, input [3:0] maxCount, output logic [3:0] count, output logic Z);
	
	always @ (posedge clk)
		begin
			if (R) begin
				count <= 3'b0;
				Z <= 1'b0; 
			end
			else if (count < maxCount) begin
				count <= count + 3'd1;
				Z <= 1'b0;
			end
			else begin
				count <= 3'b0;
				Z <= 1'b1;
			end
		end
		
endmodule

module synCounter_tb();
	`timescale 1ns/1ps
	reg clk, R, maxCount;
	logic [3:0] count;
	logic Z;
	
	synCounter counter(clk, R, maxCount, count, Z);
	
	initial begin
		$monitor("R=%b clk=%b count=%b Z=%b", R, clk, count, Z);
		
		maxCount = 1'd6;
		count = 1'b0;
		Z = 1'b0; 
		
		R = 1'b1;
		clk = 1'b0; #10; clk = 1'b1; #10;
		R = 1'b0;
		clk = 1'b0; #10; clk = 1'b1; #10; //0
		clk = 1'b0; #10; clk = 1'b1; #10; //1
		clk = 1'b0; #10; clk = 1'b1; #10; //2
		clk = 1'b0; #10; clk = 1'b1; #10; //3
		clk = 1'b0; #10; clk = 1'b1; #10; //4
		clk = 1'b0; #10; clk = 1'b1; #10; //5
		clk = 1'b0; #10; clk = 1'b1; #10; //0 and Z = 1
		clk = 1'b0; #10; clk = 1'b1; #10; //repeat 0
		clk = 1'b0; #10; clk = 1'b1; #10; //1
		clk = 1'b0; #10; clk = 1'b1; #10; //2
		clk = 1'b0; #10; clk = 1'b1; #10; //3
		clk = 1'b0; #10; clk = 1'b1; #10; //4
		clk = 1'b0; #10; clk = 1'b1; #10; //5
		clk = 1'b0; #10; clk = 1'b1; #10; //0 and Z = 1
		
	end


endmodule 

















