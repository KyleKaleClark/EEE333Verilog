module freqDiv_tb();
	
	logic clk, clkout;
	logic reset;
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
		clk = 1'b0; 
		
		set_hour = 1'b1; #10;
		repeat (6) begin
			clk = ~clk; #10;
		end
		set_hour = 1'b0; 
		
		set_min = 1'b1; #10;
		repeat(80) begin
			clk = ~clk; #10;
		end	
		set_min = 1'b0; #10;

		repeat (7202) begin
			clk = ~clk; #10;
		end
		
		
	end
endmodule


module alarmClk_tb();
	
	logic clk, reset, time_set, alarm_set, sethrs1min0, run, activatealarm, alarmreset, alrm;
	logic [7:0] sec, min, hrs, sec_alrm, min_alrm, hrs_alrm;
	
	alarm_clock clockalarm(clk, reset, time_set, alarm_set, sethrs1min0, run, activatealarm, alarmreset, sec, min, hrs, sec_alrm, min_alrm, hrs_alrm, alrm);
	
	initial begin
	
		reset = 1'b1; #10; 
		reset = 1'b0; #10;
		
		clk = 1'b0;
		
		alarmreset = 1'b1; #10; clk = 1'b1; #10; clk = 1'b0; #10;
		alarmreset = 1'b0; #10; clk = 1'b1; #10; clk = 1'b0; #10;
		activatealarm = 1'b1; 
		sethrs1min0 = 1'b0; #10;
		
		alarm_set = 1'b1; #10;
		repeat(20) begin
			clk = ~clk; #10;
		end //alarm = 10 minutes
		sethrs1min0 = 1'b1; #10;
		repeat(2) begin
			clk = ~clk; #10;
		end //alarm = 1 hour
		alarm_set = 1'b0;
		
		time_set = 1'b1;
		sethrs1min0 = 1'b0; #10;
		
		
		
		///////////////////////////////////////
		repeat(18) begin
			clk = ~clk; #10;
		end //clock = 9 minutes
		sethrs1min0 = 1'b1;
		repeat(2) begin
			clk = ~clk; #10;
		end //clock = 1 hour
		time_set = 1'b0; #10;
		
		repeat(500) begin
			clk = ~clk; #10;
		end
		
		
	end
endmodule

