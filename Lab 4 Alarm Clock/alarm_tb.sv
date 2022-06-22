module freqDiv_tb();
	
	logic clk, clkout;
	logic reset;
	//huh i dont think this will work??? base of clk seems weird .........
	fdivby2 divider(clk, reset, clkout);
	
	initial begin
		$monitor ("clk=%b clkout=%b", clk, clkout);
		reset = 1'b1; #10; clk = 1'b1; #10; clk = 1'b0; #10;
		reset = 1'b0; #10; clk = 1'b1; #10; clk = 1'b0; #10;
		
		repeat(20) begin
			clk = ~clk; #10;
		end	
	end
endmodule

module clocktime_tb();

	logic clk, enable, reset, clkout;
	logic [7:0] Maxval, Count;
	
	clocktime crocker(clk, enable, reset, Maxval, Count, clkout);
	
	initial begin
		$monitor("reset=%b enable=%b Maxval=%d clk=%b Count=%d clkout=%b", reset, enable, Maxval, clk, Count, clkout);
		clk = 1'b0; enable = 1'b1; reset = 1'b1; Maxval = 8'd59; #10;
		reset = 1'b0; clk = 1'b1; #10; clk = 1'b0; #10;
		repeat (120) begin
			clk = ~clk; #10;
		end
	end
endmodule

module timer_tb();
	
	logic [7:0] seconds, minutes, hours;
	logic clk, reset, set_min, set_hour;
	
	timer tim(clk, reset, set_min, set_hour, seconds, minutes, hours);
	
	initial begin
		reset = 1'b1; #10;
		reset = 1'b0; #10;
		
		repeat (3601) begin
			clk = ~clk; #10;
		end
		
		set_hour = 1'b1; #10;
		repeat (2) begin
			clk = ~clk;
		end
		set_hour = 1'b0; 
		
		set_min = 1'b1; #10;
		repeat(4) begin
			clk = ~clk; #10;
		end	
	end
endmodule




















