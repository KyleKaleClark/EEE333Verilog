module FSM_pv(input KEY0, SW0, SW1, SW2, SW3, SW4, output logic [6:0] SEG0, SEG1, SEG2, SEG3, output logic [6:0] LED_SW);
	
	reg [7:0] Message[3:0];
	logic [2:0] state;
	logic [1:0] Z;
	
	
	//if this KEY0 is fucked just throw a fucking ~ at it LOLOL easier to fix here than there B)
	FSM FSMachine(KEY0, SW0, SW1, SW2, SW3, SW4, state, Z);
	ASCII27Seg SevH3(Message[3], SEG3);
	ASCII27Seg SevH2(Message[2], SEG2);
	ASCII27Seg SevH1(Message[1], SEG1);
	ASCII27Seg SevH0(Message[0], SEG0);
	
	always_comb begin
		Message[3] = "C";
		Message[2] = "l";
		Message[1] = "a";
		Message[0] = "r";
		
		//LEDs
		LED_SW[6] = Z[1];
		LED_SW[5] = Z[0];
		LED_SW[4] = SW4;
		LED_SW[3] = SW3;
		LED_SW[2] = SW2;
		LED_SW[1] = SW1;
		LED_SW[0] = SW0;
		
		//Segment
		case(state);
			3'b000: begin
				Message[3] = "C";
				Message[2] = "l";
				Message[1] = "a";
				Message[0] = "r";
			end
			3'b001: begin
				Message[3] = "S";
				Message[2] = "_";
				Message[1] = "0";
				Message[0] = "1";
			end
			3'b010: begin
				Message[3] = "S";
				Message[2] = "_";
				Message[1] = "0";
				Message[0] = "2";
			end
			3'b011: begin
				Message[3] = "S";
				Message[2] = "_";
				Message[1] = "0";
				Message[0] = "3";
			end
			3'b100: begin
				Message[3] = "S";
				Message[2] = "_";
				Message[1] = "0";
				Message[0] = "4";
			end
			default: begin
				Message[3] = "C";
				Message[2] = "l";
				Message[1] = "a";
				Message[0] = "r";
			end
		endcase	
	end
	
	
endmodule //fsm_pv