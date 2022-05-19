`timescale 1ns/1ps
module ASCIINum();
	reg [7:0] ascii;
	wire [6:0] disp;
	
	ASCII27Seg asciiseg(ascii, disp);
	
	initial begin
		ascii = 8'h30; #10; //0
		ascii = 8'h31; #10; //1
		ascii = 8'h32; #10; //2
		ascii = 8'h33; #10; //3
		ascii = 8'h34; #10; //4
		ascii = 8'h35; #10; //5
		ascii = 8'h36; #10; //6
		ascii = 8'h37; #10; //7
		ascii = 8'h38; #10; //8
		ascii = 8'h39; #10;	//9
	end
	//TODO: show codes using radix to ascii
endmodule