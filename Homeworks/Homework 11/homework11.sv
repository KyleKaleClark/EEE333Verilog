parameter Width = 8;
parameter Size = 5;
typedef struct {logic [Width-1:0] Z [Size-1:0];} REG;

module ShiftregWd(input clk, reset, input [Width-1:0] X, output REG rreg);
	integer i;
	always_ff @(posedge clk or posedge reset) begin
		if(reset)
			rreg.Z[0] <= {Width{1'b0}};
		else begin
			for(i=Size-1; i>0; i=i-1)
				rreg.Z[i] <= rreg.Z[i-1];
			rreg.Z[0] <= X;
		end
	end
endmodule

module average5point(input clk, reset, input [Width-1:0] X, input REG Coef, output logic [Width-1:0] Y);
	
	REG rreg;
	logic [Width-1:0] YY;
	integer i;
	ShiftregWd SRWd1(clk, reset, X, rreg);
	
	always_comb begin
		YY = {Width{1'b0}};
		for(i=Size-1; i>=0; i=i-1)
			YY = YY + Coef.Z[i]*rreg.Z[i];
	end
	assign Y = YY;
endmodule




`timescale 1ns/1ps
module filterf_tb();
	localparam N = 20;
	REG Coef;
	integer i, fd, fr, fc, err;
	logic clk, reset;
	logic [Width-1:0] X, Y;
	
	average5point F0 (clk, reset, X, Coef, Y);
	
	initial begin
		fr = $fopen("xinput.csv", "r");
		fc = $fopen("coef.csv", "r");
		fd = $fopen("Filterma.csv");
		$fwrite(fd, "#, X, Y\n");
		for(i=0; i<Size; i=i+1)
			err = $fscanf(fc, "%d", Coef.Z[i]);
		$fclose(fc);
		
		X = 0; clk = 1'b0; reset = 1'b1; #10;
		reset = 1'b0; #10;
		
		for(i=0; i<Size; i=i+1) begin
			clk = 1'b1; #10;
			clk = 1'b0; #10;
		end		
		
		for(i=0;i<N;i=i+1) begin
			err = $fscanf(fr, "%d", X);
			clk = 1'b1; #10;
			clk = 1'b0; #10;
			$display("X=%d, Y=%d", X, Y/5);
			$fwrite(fd, "%d, %d, %d\n", i, X, Y/5);
		end		
		$fclose(fr);
		$fclose(fd);
	end
endmodule
