module masterDir7(input clkHs, reset, car_EW, car_LT, output logic [7:0] lightsNS [2:0], output logic [7:0] lightsEW [2:0]);
	localparam Gr=2'b00, Yw=2'b01, Rd=2'b10;
	localparam Goes=2'b00, Waits=2'b01, Done=2'b10;
	localparam Gr2=3'b001, Yw2=3'b010, Rd2=3'b100;
	
	logic [1:0] lightNS, lightEW;
	logic [1:0] light_state;
	logic done, next_dir, dir;
	
	lights6 light6(clkHs, reset, ~dir&(car_LT|car_EW), dir, light_state);
	
	DFF3 #(1) mstr_dir (clkHs, reset, next_dir, dir);
	
	assign done = light_state==Done;
	
	always_comb begin
		next_dir = dir;
		case(dir)
			1'b0: begin
				next_dir = (done) ? ~dir : dir;
				end
			1'b1: begin
				next_dir = (done) ? ~dir : dir;
				end
			default: next_dir = 1'b0;
		endcase
	end
	
	assign lightNS = (light_state == Goes) ? ((dir==0) ? Gr : Rd) : ((dir==0) ? Yw : Rd);
	assign lightEW = (light_state == Goes) ? ((dir==1) ? Gr : Rd) : ((dir==1) ? Yw : Rd);
	
	assign lightsNS = (lightNS==Gr) ? '{"G","R","E"} : ((lightsNS==Yw) ? '{"Y","E","L"} : '{"R","E","D"})
	assign lightsEW = (lightEW==Gr) ? '{"G","R","E"} : ((lightsNS==Yw) ? '{"Y","E","L"} : '{"R","E","D"})
endmodule

//instantiated modules
module lights6(input clk1Hz, reset, carwaiting, dir, output logic [1:0] light_state);
	localparam Gr=2'b00, Yw=2'b01, Rd=2'b10;
	localparam Goes = 2'b00, Waits=2'b01, Done=2'b10;
	localparam Sec0=9'd0, Sec10=9'd10, Sec50=9'd50, Sec60=9'd60, Sec300=9'd300;
	
	logic [1:0] next_light;
	logic [8:0] maxval;
	logic tdone;
	
	Timer3 #(9) t1(clk1Hz, reset, maxval, tdone);
	
	DFF3 #(2) mstr_state(clk1Hz, reset, next_light, light_state);
endmodule

module DFF3 #(parameter n=8)(input clk, reset, input [n-1:0] nextstate, output logic [n-1: 0] state);
	always_ff @ (posedge clk or posedge reset)
		if (reset)
			state <= {n{1'b0}};
		else
			state <= nextstate
endmodule

module Timer3 #(parameter n=8) (input clk, reset, input[n-1:0] maxval, output logic done);
	logic [n-1:0] count, One, Zero, next_count_, next_count;
	assign Zero = {n{1'b0}}; assign One = {{n-1{1'b0}},1'b1};
	assign {next_count_,done} = (count >= maxval) ? {Zero,1'b1} : {count + One,1'b0};
	
	DFF3 #(n) state_reg(clk, reset|!maxval, next_count, count);
	
	MUX2213 #(n) mux1(Zero, next_count_, reset, next_count);
endmodule

module MUX2213 #(parameter n=8) (input [n-1:0] A, B, input Sel, output [n-1:0] F);
	assign F = (Sel) ? A : B;
endmodule 
