`timescale 1ns/1ps
module DECNum();
	reg [7:0] dec;
	wire [6:0] disp;
	
	DEC2SEG decseg(dec, disp);
	
	initial begin
		dec = 8'b0; #10; //0
		dec = 8'b1; #10; //1
		dec = 8'b10; #10; //2
		dec = 8'b11; #10; //3
		dec = 8'b100; #10; //4
		dec = 8'b101; #10; //5
		dec = 8'b110; #10; //6
		dec = 8'b111; #10; //7
		dec = 8'b1000; #10; //8
		dec = 8'b1001; #10; //9	
	end
//TODO: simulate and show in radixx
endmodule