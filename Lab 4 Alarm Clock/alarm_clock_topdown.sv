/*
TODO:
incorporate the RUN variable somewhere int he alarm clock LOL. 
Then just focus on working on physical verification. 
Also bump my code against the lab manual. I think i'm actually pretty close to being done :) 
*/

module alarm_clock_pv(input CLK, SW5, SW4, SW3, SW2, SW1, SW0, KEY1, KEY0, output logic [6:0] SEC_LSD, SEC_MSD, MIN_LSD, MIN_MSD, HR_LSD, HR_MSD, output logic LED7, LED5, LED4, LED3, LED2, LED1, LED0);
	//CLK - 50MHz
	//SW0 - Reset	SW1 - Alarm_set		SW2 - Time_set		SW3 - set (1 Hours 0 Min)
	//SW4 - Activate Alarm_set		SW5 - RUN		KEY0 - Alarm Reset 
	//KEY1 - Moves Clock on hold.

	logic [7:0] sec_tens, sec_ones, min_tens, min_ones, hr_tens, hr_ones, sec, min, hrs, secA, minA, hrsA;
	logic clk_2_0hz, alarm;

	freqDiv divid(CLK, Hz2); //Module to divide 50MHz down to 2Hz

	alarm_clock alarmClk(clk_2_0hz, SW0, SW2, SW1, SW3, (SW5 && ~SW1 && ~SW2), SW4, KEY0, sec, min, hrs, secA, minA, hrsA, alarm);
					//   clk, rst, tSet ASet hr/min       run         act-alm alm-res OUTPUTS
	
	always_comb begin
		clk_2_0hz = 1'b0; 					//(KEY1 && ~SW1) || (KEY1 && ~SW0)
		sec_tens = secA/8'd10; 
		sec_ones = secA%8'd10; //if doesn't default, displays alarm time kinda weird inverse way
		min_tens = minA/8'd10; 
		min_ones = minA%8'd10;
		hr_tens = hrA/8'd10; 
		hr_ones = hrA%8'd10;
		if ((~KEY1 && SW2) || (~KEY1 && SW1) || (KEY1 && ~SW1 && ~SW0)) begin
			clk_2_0hz = Hz2;
		end
		if(~alarm_set)begin
			sec_tens = sec/8'd10; //Kind of defaults to these
			sec_ones = sec%8'd10;
			min_tens = min/8'd10; 
			min_ones = min%8'd10;
			hr_tens = hr/8'd10; 
			hr_ones = hr%8'd10;
		end
	end
	
	//draw to segment displays

	ASCII27Seg SevH0(sec_ones, SEC_LSD);
	ASCII27Seg SevH1(sec_tens, SEC_MSD);
	ASCII27Seg SevH2(min_ones, MIN_LSD);
	ASCII27Seg SevH3(min_tens, MIN_MSD);
	ASCII27Seg SevH4(hr_ones, HR_LSD);
	ASCII27Seg SevH5(hr_tens, HR_MSD);
	
	//LEDs
	assign LED7 = alarm;
	assign LED5 = SW5;
	assign LED4 = SW4;
	assign LED3 = SW3;
	assign LED2 = SW2;
	assign LED1 = SW1;
	assign LED0 = SW0;

endmodule //alarm_clock_pv

//====================================================================================================

module alarm_clock(input CLK_2Hz, reset, time_set, alarm_set, sethrs1min0, run, activatealarm, alarmreset, output logic [7:0] sec, min, hrs, sec_alrm, min_alrm, hrs_alrm, output logic alrm);

	logic clk_alarm, clk_clk, Hz1; 
	//need to incorporate RUN somewhere??? 
	timer clock(clk_clk, reset, (~sethrs1min0 && time_set), (sethrs1min0 && time_set), sec, min, hrs);
	timer alarm(clk_alarm, reset, (~sethrs1min0 && alarm_set), (sethrs1min0 && alarm_set), sec_alrm, min_alrm, hrs_alrm);
	
	//freq down to 1 HZ
	freqDiv divid(CLK_2Hz, Hz1);
	
	always_comb begin
		clk_alarm = 1'b0;
		clk_clk = 1'b0;
		if (sec-8'd1==sec_alrm && min == min_alrm && hrs==hrs_alrm && activatealarm) begin
				alrm = 1'b1;
			end
		if (alarmreset)
			alrm = 1'b0;
		if (alarm_set)
			clk_alarm = CLK_2Hz;
		if(time_set)
			clk_clk = CLK_2Hz;
		if(run)
			clk_clk = Hz1;
	end
endmodule //alarm clock

//====================================================================================================


//Timer module works as intended!!!!!!! The only thing thats still questionable is the Frequency Divider!!!!!!!!!!!!!!! BUT LETS GO
module timer(input clk, input reset, set_min, set_hour, output logic [7:0] seconds, minutes, hours);

	//clk by default will be passed in as 2Hz
	
	//logic [7:0] clk_min, clk_hr, hourOut, Min_in, Hour_in, Hz1;
	logic secEn, minEn, hourEn, clk_sec, clk_min, clk_hr;
	
	clocktime secClk(clk_sec, secEn, reset, 8'd59, seconds, Min_in);
	clocktime minClk(clk_min, minEn, reset, 8'd59, minutes, Hour_in);
	clocktime hourClk(clk_hr, hourEn, reset, 8'd23, hours, hourOut);

	fdivby2 div2(clk, reset, Hz1);

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

module fdivby2 (input clk, reset, output logic clkout);
	
	always_ff @ (posedge clk or posedge reset) begin
		if (reset)
			clkout <= 1'b0;
		else
			clkout <= ~clkout;
	end
endmodule

