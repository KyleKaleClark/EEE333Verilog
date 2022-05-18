`timescale lns/lps
module test_hwk2();
	reg A, B, C;
	wire F, Fs;


	homework2_1 hwk21 (F, Fs, A, B, C);


	initial begin
		A = 0; B = 0; C = 0; #10; 	//000
		C = 1; #10;					//001
		B = 1; C = 0; #10;			//010
		C = 1; #10					//011
		A = 1; B = 0; C = 0; #10;	//100
		C = 1; #10					//101
		B = 1; C = 0; #10;			//110
		C = 1; #10					//111
	end
endmodule //test_hwk2

//Compile
//Click "Simulate" > "Start Simulate", select "test_hwk2", View tab > "Object" & "wave" window, select all variables