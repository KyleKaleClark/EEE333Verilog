module DebounceUpDate #(parameter cntSize=8) (input reset, clk, pb, output logic pulse);
	logic [cntSize-1:0] cnt;
	
	always_ff @ (posedge clk) begin
		if (reset) begin
			cnt <= {cntSize{1'b1}};
			pulse <= 1'b1;
		end
		else begin
			cnt <= {cnt[cntSize-2:0], pb};
			if (&cnt)
				pulse <= 1'b1;
			else if (~|cnt)
				pulse <= 1'b0;
		end
	end
endmodule