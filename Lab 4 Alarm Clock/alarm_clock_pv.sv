module alarm_clock_pv(input CLK, SW5, SW4, SW3, SW2, SW1, SW0, KEY1, KEY0, output logic [6:0] SEC_LSD, SEC_MSD, MIN_LSD, MIN_MSD, HR_LSD, HR_MSD, output logic LED7, LED5, LED4, LED3, LED2, LED1, LED0);
	//CLK - 50MHz
	//SW0 - Reset	SW1 - Alarm_set		SW2 - Time_set		SW3 - set (1 Hours 0 Min)
	//SW4 - Activate Alarm_set		SW5 - RUN		KEY0 - Alarm Reset 
	//KEY1 - Moves Clock on hold.

	logic [7:0] sec_tens, sec_ones, min_tens, min_ones, hr_tens, hr_ones, sec, min, hrs, secA, minA, hrsA;
	logic Hz2;
	logic alarm, oscillateAlarm;

	frequencyDivider #(26) Mhz50toHz2(CLK, SW0, 26'd16000000, Hz2);
	
  	alarm_clock alarmClk(Hz2, SW0, (SW2&&~KEY1), (SW1&&~KEY1), SW3, (SW5 && ~SW1 && ~SW2), SW4, ~KEY0, sec, min, hrs, secA, minA, hrsA, alarm);
					//   		clk, rst, 	tSet 				ASet 		hr/min       run         	act-alm alm-res OUTPUTS
	
	always_comb begin 					
		sec_tens = secA/8'd10; 
		sec_ones = secA%8'd10; 
		min_tens = minA/8'd10; 
		min_ones = minA%8'd10;
		hr_tens = hrsA/8'd10; 
		hr_ones = hrsA%8'd10;
		if(~SW1)begin
			sec_tens = sec/8'd10; //Kind of defaults to these
			sec_ones = sec%8'd10;
			min_tens = min/8'd10; 
			min_ones = min%8'd10;
			hr_tens = hrs/8'd10; 
			hr_ones = hrs%8'd10;
		end
	end
	
	
	//This is all definitely redundant and could be optimzed I'm sure
	//however this was the only way I could figure out how to get the
	//LED to oscillate instead of holding 1 steady value......
	always_ff @(posedge alarm or posedge SW0 or posedge ~KEY0) begin
		if (SW0 || ~KEY0)
			oscillateAlarm <= 1'b0;
		else
			oscillateAlarm <= 1'b1;
	end
	
	always_ff @(posedge Hz2 or posedge SW0) begin
		if (SW0) begin
			LED7 = 1'b0;
		end
		else begin
			if (oscillateAlarm)
				LED7 = ~LED7;
			else
				LED7 = 1'b0;
		end
	end

	
	//Hex Display
	ASCII27Seg SevH0(sec_ones, SEC_LSD);
	ASCII27Seg SevH1(sec_tens, SEC_MSD);
	ASCII27Seg SevH2(min_ones, MIN_LSD);
	ASCII27Seg SevH3(min_tens, MIN_MSD);
	ASCII27Seg SevH4(hr_ones, HR_LSD);
	ASCII27Seg SevH5(hr_tens, HR_MSD);
	
	
	//LEDs
	assign LED5 = SW5;
	assign LED4 = SW4;
	assign LED3 = SW3;
	assign LED2 = SW2;
	assign LED1 = SW1;
	assign LED0 = SW0;

endmodule //alarm_clock_pv


//====================================================================================================

module alarm_clock(input CLK_2Hz, reset, time_set, alarm_set, sethrs1min0, run, activatealarm, alarmreset, 
							output logic [7:0] sec, min, hrs, sec_alrm, min_alrm, hrs_alrm, output logic alrm);

	logic clk_alarm, clk_clk, Hz1; 
	logic set_alarm;	
	
	timer clock(clk_clk, reset, (~sethrs1min0 && time_set), (sethrs1min0 && time_set), sec, min, hrs);
  	timer alarm(clk_alarm, reset, (~sethrs1min0 && alarm_set), (sethrs1min0 && alarm_set), sec_alrm, min_alrm, hrs_alrm);

	
	always_comb begin
		clk_alarm = 1'b0; 
		clk_clk = 1'b0; 
		set_alarm = 1'b0; 
		if (sec-8'd1==sec_alrm && min == min_alrm && hrs==hrs_alrm) 
			set_alarm = 1'b1;
		if(run || time_set)
			clk_clk = CLK_2Hz;
      if(alarm_set)
        	clk_alarm = CLK_2Hz; //clock only moves if you're setting alarm
	end
  
  
	//"latches" the alarm signal until reset
	always_ff @(posedge set_alarm or posedge alarmreset or posedge reset) begin
    	if(alarmreset || reset)
      		alrm <= 1'b0;
		else begin
			if(activatealarm)
				alrm <= 1'b1; 
		end
  	end
    
    
endmodule //alarm clock

//==========================================================================================

module timer(input clk, input reset, set_min, set_hour, output logic [7:0] seconds, minutes, hours);
	
	logic secEn, minEn, hourEn, clk_sec, clk_min, clk_hr;
	
	clocktime secClk(clk_sec, secEn, reset, 8'd59, seconds, Min_in);
	clocktime minClk(clk_min, minEn, reset, 8'd59, minutes, Hour_in);
	clocktime hourClk(clk_hr, hourEn, reset, 8'd23, hours, hourOut);

	frequencyDivider #(2) Mhz50toHz2(clk, reset, 2'd2, Hz1);
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
//These two modules are literally the same, except ones just non-paramitized. Could defintely optimze the
//code by just using the bottom frequency divider as a paramited clock for the actual clocks; however,
//i wrote it this way, and feel as though i'd rather keep it like this for the clarity of the lab. 
module frequencyDivider#(parameter Size = 26)(input clk, reset, input [Size-1:0] Maxval, output logic clkout);
	logic [Size-1:0] Count;
	always_ff @ (posedge clk or posedge reset) begin
		if (reset) begin
			Count <= {Size{1'b0}};
			clkout <= 1'b0;
		end
		else if (Count<Maxval) begin
				Count <= Count + {{(Size-1){1'b0}},1'b1};
				clkout <= 1'b0;
			end
		else begin
				Count <= {Size{1'b0}};
				clkout <= 1'b1;
		end
	
	end

endmodule

//====================================================================================================