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
