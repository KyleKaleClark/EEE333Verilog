module FSM(input clk, reset, SW1, SW2, SW3, SW4, output logic [2:0] state, output logic [1:0] Z);
	localparam S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;
	logic [2:0] nextState;
	
	//synchronous parttttttt
	always_ff @ (posedge clk or posedge reset) begin
		if (reset)
			state <= S0;
		else 
			state <= nextState;
	end
	
	//combinatorial parttttttt
	always_comb begin
		nextState = state;
		
		//Z configurement here vvv
		case(state)
			S0: Z = 2'b01;
			S1: Z = 2'b01;
			S2: Z = 2'b10;
			S3: Z = 2'b11;
			S4: Z = 2'b10;
		endcase
		
		case(state)
			S0: begin
				if(SW1 & ~SW2 & ~SW3 & ~SW4)
					nextState = S1;
              			else if(SW3 & ~SW1 & ~SW2 & ~SW4)
					nextState = S3;
				else
					nextState = S0;
			end
			S1: begin
				if(SW2 & ~SW1 & ~SW3 & ~SW4)
					nextState = S2;
				else
					nextState = S1;
			end
			S2: begin
				if(SW2 & ~SW1 & ~SW3 & ~SW4)
					nextState = S1;
              			else if(SW3 & ~SW1 & ~SW2 & ~SW4)
					nextState = S3;
				else
					nextState = S2;
			end
			S3: begin
				if(SW1 & ~SW2 & ~SW3 & ~SW4)
					nextState = S4;
				else if(SW2 & ~SW1 & ~SW3 & ~SW4)
					nextState = S1;
				else
					nextState = S3;
			end
			S4: begin
				if(SW2 & ~SW1 & ~SW3 & ~SW4)
					nextState = S1;
				else
					nextState = S4; 
			end	
		endcase
	end
endmodule

module FSM_tb();
	reg clk, reset, SW1, SW2, SW3, SW4;
	logic [2:0] state;
	logic [1:0] Z;
	
	FSM finiteState(clk, reset, SW1, SW2, SW3, SW4, state, Z);
	
	initial begin
     		$monitor("reset=%b clk=%b SW1=%b SW2=%b SW3=%b SW4=%b state=%d Z=%b", reset, clk, SW1, SW2, SW3, SW4, state, Z);
		clk = 1'b0; SW1 = 1'b0; SW2 = 1'b0; SW3 = 1'b0; SW4 = 1'b0;
		
		reset = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		reset = 1'b0; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW1 = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW1 = 1'b0; #10; 
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW2 = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW2 = 1'b0; #10; 
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW2 = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW2 = 1'b0; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW2 = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW2 = 1'b0; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW4 = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW4 = 1'b0; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW3 = 1'b1; #10; 
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW3 = 1'b0; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW1 = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW1 = 1'b0; #10; 
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW2 = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW2 = 1'b0; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW2 = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW2 = 1'b0; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW3 = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW3 = 1'b0; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW2 = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW2 = 1'b0; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		#10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		reset = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		reset = 1'b0; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW1 = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW1 = 1'b0; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW2 = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW2 = 1'b0; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW3 = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW3 = 1'b0; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW1 = 1'b1; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		SW1 = 1'b0; #10;
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		reset = 1'b1; #10; //SW0!?!
		clk = 1'b1; #10;
		clk = 1'b0; #10;
		reset = 1'b0; #10;		
		
	end
endmodule
























