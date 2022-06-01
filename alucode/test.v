`timescale 1ns/1ps
module testALU();
	reg [3:0] aluAin, aluBin, opCode;
	reg Cin; 
	
	wire [3:0] aluOut;
	wire Cout, OF;

	ALU alu1(aluAin, aluBin, opCode, Cin, aluOut, Cout, OF);
	
	//OPCODE REFERENCE
	//0001 Add w/ Cin
	//0010 Add no Cin
	//0011 Sub B from A
	//0100 Bitwise AND A, B
	//0101 Bitwise NOR A, B
	//0110 Bitwise XNOR A, B
	//0111 Bitwise NOT ~A
	//1000 Logical Shift Right A
	
	initial begin
			aluAin = 4'b0011; aluBin = 4'b0011; Cin = 1'b0; opCode = 4'b0010; #10; 
			aluAin = 4'b0110; aluBin = 4'b0101; Cin = 1'b1; opCode = 4'b0001; #10;
			aluAin = 4'b0111; aluBin = 4'b0110; Cin = 1'b0; opCode = 4'b0011; #10;
			aluAin = 4'b0111; aluBin = 4'b1010; Cin = 1'b0; opCode = 4'b0100; #10;
			aluAin = 4'b0111; aluBin = 4'b0011; Cin = 1'b0; opCode = 4'b0101; #10;
			aluAin = 4'b0101; aluBin = 4'b1110; Cin = 1'b0; opCode = 4'b0110; #10;
			aluAin = 4'b1011; aluBin = 4'b0000; Cin = 1'b0; opCode = 4'b0111; #10;
			aluAin = 4'b0101; aluBin = 4'b0000; Cin = 1'b0; opCode = 4'b1000; #10;
	end
endmodule 