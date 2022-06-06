module ALU(input [3:0] aluin_a, aluin_b, OPCODE, input Cin, output reg[3:0] alu_out, output reg Cout, OF);
	//declarations
	reg [3:0] A, B, twosCompB;
	reg addCin;
	wire [3:0] Sum, Diff, AShift;
	wire sumCout, diffCout, sumOF, diffOF;
	
	
	//module references
	FA4 fa4(A, B, addCin, Sum, sumCout, sumOF);
	Rsub4 rs4(A, B, Diff, diffCout, diffOF);
	logicalShiftRight LSR(A, AShift);
	
	always @ (*) begin
		case(OPCODE)
			4'b0001: begin //Add w/ Cin 
				//inputs
				A = aluin_a;
				B = aluin_b;
				addCin = Cin;
				//outputs
				alu_out = Sum; 
				Cout = sumCout;
				OF = sumOF;
			end
			4'b0010: begin //Add no Cin
				A = aluin_a;
				B = aluin_b;
				addCin = 1'b0;
				
				alu_out = Sum; 
				Cout = sumCout;
				OF = sumOF; 
			end
			4'b0011: begin //Sub B from A
				A = aluin_a;
				B = aluin_b;
				
				alu_out = Diff;
				Cout = diffCout;
				OF = diffOF;
			end
			4'b0100: begin //Bitwise AND A, B
				A = aluin_a;
				B = aluin_b;
				
				alu_out = A & B;
				Cout = 1'b0;
				OF = 1'b0;
			end
			4'b0101: begin //Bitwise NOR A, B
				A = aluin_a;
				B = aluin_b;
				
				alu_out = ~(A | B);
				Cout = 1'b0;
				OF = 1'b0;
			end
			4'b0110: begin //Bitwise XNOR A, B
				A = aluin_a;
				B = aluin_b;
				
				alu_out = ~(A ^ B);
				Cout = 1'b0;
				OF = 1'b0;
			end
			4'b0111: begin //Bitwise NOT ALU
				A = aluin_a;
	
				alu_out = ~A;
				Cout = 1'b0;
				OF = 1'b0;
			end
			4'b1000: begin //Logical Shift Right for A
				A = aluin_a;
				
				alu_out = AShift;
				Cout = 1'b0;
				OF = 1'b0;
			end
			default: begin 
				alu_out = 4'b0;
				Cout = 1'b0;
				OF = 1'b0;
			end
		endcase
	end
endmodule


module HA(input A, B, output Sum, Cout);
	assign Sum = A^B;
	assign Cout = A&B;
endmodule //HA, this is functionally good

module FA(input A, B, Cin, output Sum, Cout);
	wire sum1, cout1, cout2;
	HA ha1 (A, B, sum1, cout1);
	HA ha2 (sum1, Cin, Sum, cout2);

	assign Cout = cout1 | cout2;
endmodule //FA, this is functionally good

module FA4(input [3:0] A, B, input Cin, output [3:0] Sum, output Cout, OF);

	wire C1, C2, C3;
		// A      B  Carryin Sum   Carry out    
	FA fa1(A[0], B[0], Cin, Sum[0], C1);
	FA fa2(A[1], B[1], C1, Sum[1], C2);
	FA fa3(A[2], B[2], C2, Sum[2], C3);
	FA fa4(A[3], B[3], C3, Sum[3], Cout);

	assign OF = C3 ^ Cout;
endmodule //Ripple Adder 4 bit, 

module twosComp(input [3:0] inVal, output [3:0] twosC);
	wire [3:0] oneComp;
	assign oneComp = inVal ^ 4'b1111; //a more fundamental invert :p
	reg [3:0] plusOne = 4'b0001; //consistent +1 for twos
	//empty wires to feed into ripple adder
	wire Cin = 1'b0;
	wire Cout, OF;
	//4 bit ripple adder
	//FA4 rA2C(OneComp, plusOne, Cin, twosC, Cout, OF); //add onesComp + 1 to output Twos Comp to output 
	assign twosC = oneComp + plusOne;
endmodule //twos comp

module Rsub4(input [3:0] A, B, output [3:0] diff, Cout, OF);
	wire [3:0] twosCompB; //the twos comp of B
	twosComp twC(B, twosCompB); //getting the twos comp
	wire Cin = 1'b0; //empty
	
	FA4 raSub(A, twosCompB, Cin, diff, Cout, OF); //Adding but with a negative number (subtracting hmm)
endmodule

module logicalShiftRight(input [3:0] A, output [3:0] Aout);
	wire A0, A1, A2, A3;
	
	assign A0 = A[1]; //pretty sure this
	assign A1 = A[2];
	assign A2 = A[3];
	assign A3 = 1'b0;

	assign Aout[3] = A3; //and this
	assign Aout[2] = A2; //are redundant
	assign Aout[1] = A1;
	assign Aout[0] = A0;
	
endmodule