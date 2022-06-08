module FSM(input clk, reset, SW1, SW2, SW3, SW4, output logic [2:0] state, output logic [1:0] Z);
	localparam S0 = 2'b01, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11, S4 = 2'b10;
	logic [2:0] nextState;
	
	//synchronous parttttttt
	always_ff @ (posedge clk or posedge reset) begin
		if (reset)
			state <= S0;
		else 
			state <= nextState;
	end
	
	always_comb begin
		nextState = state;
		//Z configurement here
		
		case(state) begin
			S0: begin
				if(SW1 & !SW2 & !SW3 & !Sw4)
					nextState = S1;
				else if(S3 & !SW1 & !SW2 & !SW4)
					nextState = S3;
				else
					nextState = S0;
			end
			S1: begin
				if(SW2 & !SW1 & !SW3 & !SW4)
					nextState = S2;
				else
					nextState = S1;
			end
			S2: begin
				if(SW2 & !SW1 & !SW3 & !SW4)
					nextState = S1;
				else
					nextState = S2;
			end
			S3: 
		end	
	end
	
endmodule