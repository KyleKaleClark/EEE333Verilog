module LFSR8bit(input clk, reset, load, input [7:0] seed, output [7:0] randomNum, output randomBit);
	
	logic nextbit;
	logic [7:0] state_in, state_out;
	
	MUX21 #(8) muxr (seed, {state_out[6:0], nextbit}, load, state_in);
	DReg #(8) dregg (state_in, clk, reset, state_out);
	
	assign nextbit = ( ((state_out[7] ^ state_out[5]) ^ state_out[4]) ^ state_out[3]);
	assign randomBit = nextbit;
	assign randomNum = state_out;
	
endmodule

module DReg #(parameter Size=8)(input [Size-1:0] D, input clk, reset, output logic [Size-1:0] Q);	
	always_ff @ (posedge clk or posedge reset) begin
		if (reset) Q<={Size{1'b0}};
		else Q <= D;	
	end
endmodule

module MUX21 #(parameter Size=8)(input [Size-1:0] A, B, input S, output [Size-1:0] Y);
	assign Y = (S) ? A : B;
endmodule

/*
TODO: Compile code in modelsim, run,
capture waveform for PDF. Check csv file for export 
of random numbers. 

Port to quartus, gen RTL Netlist & capture image.

Questions: Are the blocks what you anticipated 
*/

`timescale 1ns/1ps
module LFSR_tb();
	
	
	integer fd;
	logic clk, reset, load, randoBit;
	logic [7:0] seed, randomNum;
	
	LFSR8bit rando(clk, reset, load, seed, randomNum, randoBit);
	
	initial begin
		//load to file stuff around here :) 
		fd = $fopen("randomNumbers.csv");
		
		seed = 8'b11111111; reset = 1'b1; load = 1'b0; clk = 1'b0; #10;
		reset = 1'b0; #10;
		
		
		load = 1'b0; #10; 
		repeat(4) begin
			clk = ~clk; #10;
		end
		load = 1'b1; #10;
		load = 1'b0; #10;
		load = 1'b1; #10;
		repeat(20) begin
			clk = ~clk; #10;
			//load = ~load; #10;
			$display("clk=%b, randomNum=%d", clk, randomNum);
			$fwrite(fd, "%d", randomNum);
		end
		$fclose(fd);
		
	end	
endmodule
