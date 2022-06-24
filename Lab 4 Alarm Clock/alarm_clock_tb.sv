module alarm_clock_tb();
	
	logic Hz2, reset, time_set, alarm_set, KEY1, sethrs1min0, run, activatealarm, alarmreset, alarm;
	logic [7:0] sec, min, hr, secA, minA, hrA;
	
	alarm_clock almclk(Hz2, reset, time_set&&KEY1, alarm_set&&KEY1, sethrs1min0, run&&~alarm_set&&~time_set, activatealarm, alarmreset, sec, min, hr, secA, minA, hrA, alarm);
	
	initial begin
	
		$monitor("reset=%b run=%b activatealarm=%b KEY1=%b alarm_set=%b time_set=%b sethrs1min0=%b Hz2=%b sec=%d min=%d hr=%d secA=%d minA=%d hrA=%d alarm=%b", reset, run, activatealarm, KEY1, alarm_set, time_set, sethrs1min0, Hz2, sec, min, hr, secA, minA, hrA, alarm);
	
		reset = 1'b1; #10;
		reset = 1'b0; #10;
		Hz2 = 1'b0; 
		
		alarm_set = 1'b1; KEY1 = 1'b1; sethrs1min0 = 1'b0; #10;
		repeat(44) begin//22 min
			Hz2 = ~Hz2; #10;
		end
		sethrs1min0 = 1'b1;
		repeat(14) begin//7 hour
			Hz2 = ~Hz2; #10;
		end
		alarm_set = 1'b0; time_set = 1'b1; sethrs1min0 = 1'b0; #10;
		repeat(42) begin//21 min
			Hz2 = ~Hz2; #10;
		end
		sethrs1min0 = 1'b1;
		repeat(14) begin//7 hour
			Hz2 = ~Hz2; #10;
		end
		time_set = 1'b0; KEY1 = 1'b0; #10;
		activatealarm = 1'b1; run = 1'b1; #10;
		
		repeat(3000) begin
			Hz2 = ~Hz2; #10;
		end
			alarmreset = 1'b1; #10;
			alarmreset = 1'b0; #10;
		repeat(60) begin
			Hz2 = ~Hz2; #10;
		end
		
	end	
endmodule