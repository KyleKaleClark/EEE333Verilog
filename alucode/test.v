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
	
	//notes for self:
	//Cout and OF don't seem to work!!
	//i think it might be a linking error from the thing to the thing hm 
	//subtract doesn't output either, something lost, similar to above. Will investigate herm
	//Logical shift is good! (surprisingly o3o)
	
	initial begin
			aluAin = 4'b0011; aluBin = 4'b0011; Cin = 1'b0; opCode = 4'b0010; #10; //Add no Cin
			aluAin = 4'b0110; aluBin = 4'b1001; Cin = 1'b1; opCode = 4'b0001; #10; //Add w Cin //result 4'b0 w/ OF
			aluAin = 4'b0111; aluBin = 4'b0110; Cin = 1'b0; opCode = 4'b0011; #10; //Sub B from A
			aluAin = 4'b0111; aluBin = 4'b1010; Cin = 1'b0; opCode = 4'b0100; #10; //Bitwise AND
			aluAin = 4'b0111; aluBin = 4'b0011; Cin = 1'b0; opCode = 4'b0101; #10; //Bitwise NOR
			aluAin = 4'b0101; aluBin = 4'b1110; Cin = 1'b0; opCode = 4'b0110; #10; //Bitwise XNOR
			aluAin = 4'b1011; aluBin = 4'b0000; Cin = 1'b0; opCode = 4'b0111; #10; //Bitwise NOT
			aluAin = 4'b1010; aluBin = 4'b0000; Cin = 1'b0; opCode = 4'b1000; #10; //Logical Shift Right
	end
endmodule 