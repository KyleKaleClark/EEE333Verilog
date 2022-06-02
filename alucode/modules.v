module twosComp(input [3:0] inVal, output [3:0] twosC);
	wire [3:0] oneComp;
	assign oneComp = inVal ^ 4'b1111; //a more fundamental invert :p
	reg [3:0] plusOne = 1'b1; //consistent +1 for twos
	//empty wires to feed into ripple adder
	wire Cin = 1'b0;
	wire Cout, OF;
	//4 bit ripple adder
	RA4 rA2C(OneComp, plusOne, Cin, twosC, Cout, OF); //add onesComp + 1 to output Twos Comp to output 
	
endmodule

module Rsub4(input [3:0] A, B, output [3:0] diff, Cout, OF);
	wire [3:0] twosCompB; //the twos comp of B
	twosComp twC(B, twosCompB); //getting the twos comp
	wire Cin = 1'b0; //empty
	
	RA4 raSub(A, twosCompB, Cin, diff, Cout, OF); //Adding but with a negative number (subtracting hmm)
endmodule

module logicalShiftRight(input [3:0] A, output [3:0] Aout);
	wire A0, A1, A2, A3;
	
	A0 = A[1];
	A1 = A[2];
	A2 = A[3];
	A3 = 1'b0;

	Aout[3] = A3;
	Aout[2] = A2;
	Aout[1] = A1;
	Aout[0] = A0;
	
endmodule