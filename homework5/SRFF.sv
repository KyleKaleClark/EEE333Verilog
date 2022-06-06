module SRFF(input S, R, clk, En, output reg Q, output Qn);
	always_ff @(posedge clk) begin
		if(En)
			begin
				if ((R==1) && (S==0)) begin
					Q <= 1'b0;
					end
				else if((S==1)&&(R==1)) begin
					Q <= 1'bx;
					end
				else begin
					Q <= (S | (~R&Q));
					end
			end
		//1'b0: Q <= Q;		
	end
	assign Qn = ~Q;
	
endmodule //SRFF


module SRff_tb();
	reg S, R, clk, En, Q;
	wire Qn;
	
	SRFF srfflop(S, R, clk, En, Q, Qn);
	
	initial begin
		$monitor("En=%b S=%b R=%b Q=%b", En, S, R, Q);
		
		En = 1'b0; //Start with no Enable
		S = 1'b0; R = 1'b0; 	Q = 0; clk = 1'b0; #10; clk = 1'b1; #10;  
		S = 1'b0; R = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10;
		S = 1'b1; R = 1'b0; clk = 1'b0; #10; clk = 1'b1; #10;
		S = 1'b1; R = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10; #10;//illegal


		En = 1'b1; //Start with Enable
		S = 1'b0; R = 1'b0; 	Q = 0; clk = 1'b0; #10; clk = 1'b1; #10; 
		S = 1'b0; R = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10;
		S = 1'b1; R = 1'b0; clk = 1'b0; #10; clk = 1'b1; #10;
		S = 1'b1; R = 1'b1; clk = 1'b0; #10; clk = 1'b1; #10; //illegal
	
	
	
	end
	
	//forever begin //clock clock 
		//	clk = 1'b0;
		//	#10; 
		//	clk = ~clk;
		//	#10;
		//end
endmodule //srff_tb