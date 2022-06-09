module ALU(input [3:0] aluin_a, aluin_b, OPCODE, input Cin, output reg[3:0] alu_out, output reg Cout, OF);
	//declarations
	reg [3:0] A, B, twosCompB;
	reg addCin, zeroCin;
	wire [3:0] Sum, Diff, AShift;
	wire inCout, inOF;
	assign zeroCin = 1'b0;
	
	//module references
	FA4 fa4(A, B, addCin, Sum, inCout, inOF);
	Rsub4 rs4(A, B, Diff, inCout, inOF);
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
				Cout = inCout;
				OF = inOF;
			end
			4'b0010: begin //Add no Cin
				A = aluin_a;
				B = aluin_b;
				addCin = zeroCin;
				
				alu_out = Sum; 
				Cout = inCout;
				OF = inOF; 
			end
			4'b0011: begin //Sub B from A
				A = aluin_a;
				B = aluin_b;
				
				alu_out = Diff;
				Cout = inCout;
				OF = inOF;
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
			default:
				alu_out = 4'b0;
				Cout = 1'b0;
				OF = 1'b0;
			end
		endcase
	end
endmodule