module alarm_clock_pv(input CLK, SW5, SW4, SW3, SW2, SW1, SW0, KEY1, KEY0, output logic [6:0] SEC_LSD, SEC_MSD, MIN_LSD, MIN_MSD, HR_LSD, HR_MSD, ouput logic LED7, LED5, LED4, LED3, LED2, LED1, LED0);

	

endmodule //alarm_clock_pv

//====================================================================================================

module alarm_clock(input CLK_2Hz, reset, time_set, alarm_set, sethrs1min0, run, activatealarm, alarmreset, output logic [7:0] sec, min, hrs, sec_alrm, min_alrm, hrs_alrm, output logic alrm);

	timer clock(CLK_2Hz, reset, (~sethrs1min0 && time_set), (sethrs1min0 && time_set), sec, min, hrs);
	timer alarm(CLK_2Hz, reset, (~sethrs1min0 && alarm_set), (sethrs1min0 && alarm_set), sec_alrm, min_alrm, hrs_alrm);
	
	always_comb begin
		alrm = 1'b0;
		if (sec-8'd1==sec_alrm && min == min_alrm && hrs==hrs_alrm) begin
			alrm = 1'b1;
		end
		//if ()
	end
endmodule //alarm clock

//====================================================================================================

module timer(input [7:0] clk, reset, set_min, set_hour, output seconds, minutes, hours);

	//clk by default will be passed in as 2Hz
	
	logic [7:0] clk_min, clk_hr, hourOut, Min_in, Hour_in, Hz1;
	logic secEn, minEn, hourEn;
	
	clocktime secClk(clk_sec, secEn, reset, 8'd59, seconds, Min_in);
	clocktime minClk(clk_min, minEn, reset, 8'd59, minutes, Hour_in);
	clocktime hourClk(clk_hr, hourEn, reset, 8'd23, hours, hourOut);

	fdivby2 #(8) div2(clk, reset, Hz1);

	always_comb begin
		clk_sec = Hz1; 
		clk_min = Min_in;
		clk_hr = Hour_in;
		secEn = 1'b1; minEn = 1'b1; hourEn = 1'b1;
		
		if(set_min) begin
			clk_sec = 1'b0; secEn = 1'b0; minEn = 1'b1; hourEn = 1'b0;
			clk_min = clk; 
			clk_hr = 1'b0;
		end
		if(set_hour) begin
			clk_sec = 1'b0; secEn = 1'b0; minEn = 1'b0; hourEn = 1'b1;
			clk_min = 1'b0;
			clk_hr = clk; 
		end
	end
	
endmodule //timer

//====================================================================================================

module clocktime(input clk, enable, reset, input [7:0] Maxval, output logic [7:0] Count, output logic clkout);

	always_ff @ (posedge clk or posedge reset) begin
		if (reset) begin
			Count <= 8'd0;
			clkout <= 1'b0;
		end
		else begin
			if (enable) begin
				if (Count<Maxval) begin
					Count <= Count + 8'd1;
					clkout <= 1'b0;
				end
				else begin
					Count <= 8'd0;
					clkout <= 1'b1;
				end
			end
		end
	end

endmodule//clocktimer

//====================================================================================================

module fdivby2 #(parameter Size=8)(input [Size-1:0] clk, reset, output logic [Size-1:0] clkout);
	
	always_ff @ (posedge clk or posedge reset) begin
		if (reset)
			clkout <= {Size{1'b0}};
		else
			clkout <= ~clkout;
	end
endmodule













