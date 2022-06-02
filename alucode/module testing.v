`timescale 1ns/1ps
module testers();
	reg [3:0] AddA, AddB, SubA, SubB, InVal;
	reg Cin; 
	
	wire [3:0] Sum, twosC, Diff;
	wire sumCout, diffCout, sumOF, diffOF;
	
	FA4 fa4(AddA, AddB, Cin, Sum, sumCout, sumOF);
	twosComp twC(InVal, twosC);
	Rsub4 rsub(SubA, SubB, Diff, diffCout, diffOF);
	
	initial begin
		AddA = 4'b0011; AddB = 4'b1100; Cin = 1'b0; #10; //= 1111 C-0 OF-0
		AddA = 4'b1110; AddB = 4'b0011; Cin = 1'b0; #10; //= 0001 C-1 OF-1(?)
		AddA = 4'b1010; AddB = 4'b0101; Cin = 1'b1; #10; //= 0000 C-1 OF-1(?)
		AddA = 4'b0010; AddB = 4'b0100; Cin = 1'b1; #10; //= 0111 C-0 OF-1(?)
		
		InVal = 4'b0001; #10; //= 1110 -> 1111
		InVal = 4'b0100; #10; //= 1011 -> 1100
		InVal = 4'b1111; #10; //= 0000 -> 0001
		InVal = 4'b1010; #10; //= 0101 -> 0110
		
		SubA = 4'b0111; SubB = 4'b0011; #10; // = 0100
		SubA = 4'b1010; SubB = 4'b1100; #10; // = 1110
		SubA = 4'b0010; SubB = 4'b0001; #10; // = 0001
		SubA = 4'b1101; SubB = 4'b0111; #10; // = 0110
	end
	
endmodule