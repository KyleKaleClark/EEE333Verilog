module homework2_1(output F, Fs, input A, B, C);
	assign F=~A&~B&~C | A&~B&~C | A&B&~C | A&B&C;
	assign Fs = A&B | ~B&~C;
endmodule
//TODO: open in ModelSim & Compile
//check if the message is correct 