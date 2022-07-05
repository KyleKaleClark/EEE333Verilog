/*
TODOs:
Cout 
physical implementation
and UH i think thats it :D
*/
module lab5_pv(input clk, SW0, SW1, KEY0, SW2, SW3, SW4, output logic [6:0] SevSeg5, SevSeg4, SevSeg3, SevSeg2, SevSeg1, SevSeg0, output logic LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7);
	
	//CLK - 50MHz to div to 1000Hz	SW0 - Asynch Reset	SW1 - Single Step [0-Auto Mode, 1-Single Step] 
	//KEY0 - Step Single Step	LED7-0 should be address
	//SW2-4 used to determine display onto Segment display
	logic [15:0] count;
	logic Hz1k, clockStepOrAuto, cout, of;
	logic [1:0] state;
	logic [7:0] pc, alu_out, w_reg;
	logic [3:0] opcode;
	logic [7:0] seg [5:0];
	//Freq div 50Mhz to 1kHz
	pmcntr #(16) MHz50toHz1k(clk, SW0, 16'd50000, count, Hz1k); 
	//the actual thing
	lab5 lab(clockStepOrAuto, SW0, opcode, state, pc, alu_out, w_reg, cout, of);
	//auto mode vs single step mode;
	always_comb begin
		clockStepOrAuto = Hz1k;
		if(SW1)
			clockStepOrAuto = ~KEY0;
		else
			clockStepOrAuto = Hz1k;
	end	
	
	//Segment Display Comb logic
	always_comb begin
		seg[0] = "";
		seg[1] = "";
		seg[2] = "";
		seg[3] = "";
		seg[4] = "";
		seg[5] = "";
		if (~SW4 && ~SW3 && ~SW2) begin
			seg[0] = "";
			seg[1] = "K";
			seg[2] = "R";
			seg[3] = "A";
			seg[4] = "L";
			seg[5] = "C";
		end
		//if you want to display has HEX you need to do it in the ASCII27Seg module. literally change the display, mod and div by 16
		if(SW4 && SW3 && ~SW2) begin //Point Counter
			//seg = pc[5:0]; //feel like this isn't right since they're different lenghts??? same for below ones
			seg[5] = "P";
			seg[4] = "C";
			seg[3] = "d";
			seg[2] = "'";
			seg[1] = pc/8'd10;
			seg[0] = pc%8'd10;
			end
		else if (SW4 && ~SW3 && SW2) begin //W_reg Value
			seg[5] = "W";
			seg[4] = "R";
			seg[3] = "d";
			seg[2] = "'";
			seg[1] = w_reg/8'd10;
			seg[0] = w_reg%8'd10;
			end
		else if (~SW4 && SW3 && SW2) begin //Alu Out Value
			seg[5] = "A";
			seg[4] = "L";
			seg[3] = "U";
			seg[2] = "'";
			seg[1] = alu_out/8'd10;
			seg[0] = alu_out%8'd10;
			end
		else if (SW4 && SW3 && SW2) begin //OPCODE
			//need to retrieve opcode somehow..... prob need to retreive above same way.
			seg[5] = "O";
			seg[4] = "P";
			seg[3] = opcode[3];
			seg[2] = opcode[2];
			seg[1] = opcode[1];
			seg[0] = opcode[0];
			end
		else begin
			seg[0] = "";
			seg[1] = "";
			seg[2] = "";
			seg[3] = "";
			seg[4] = "";
			seg[5] = "";
		end
	end
	ASCII27Seg SevH0(seg[0], SevSeg0);
	ASCII27Seg SevH1(seg[1], SevSeg1);
	ASCII27Seg SevH2(seg[2], SevSeg2);
	ASCII27Seg SevH3(seg[3], SevSeg3);
	ASCII27Seg SevH4(seg[4], SevSeg4);
	ASCII27Seg SevH5(seg[5], SevSeg5);
	
	//LEDs
	assign LED0 = pc[0];
	assign LED1 = pc[1];
	assign LED2 = pc[2];
	assign LED3 = pc[3];
	assign LED4 = pc[4];
	assign LED5 = pc[5];
	assign LED6 = pc[6];
	assign LED7 = pc[7];
	
	
	
endmodule

module lab5(input clk, reset, output logic [3:0] OPCODE, output logic [1:0] State, output logic [7:0] PC, Alu_out, W_Reg, output logic Cout, OF);
	localparam IF = 2'b00, FD = 2'b01, EX = 2'b10, RWB = 2'b11;
	
	logic [7:0] A, B, nextPC;
	logic [15:0] IR;
	logic [3:0] RA, RB, RD;
	logic [1:0] nextstate;
	//logic [1:0] State; hartin put this here but i'm CONFIDENT its an accident 
	
	
	
	//csv write, comment out for physical
	///*
	integer fd; 
	always_comb begin
		fd = $fopen("log.csv");
		if(State==2'b10) begin
			$fwrite(fd, "%h, %h, %h, %h, %h, %h, %h, %h, %h \n", PC, IR, OPCODE, RA, RB, RD, W_Reg, Cout, OF);
		end
	end
	//*/
	
	//instantiations
	//ROM
	ROM Prog1(PC, IR);
	
	//REGFile
	RegFile Reg8bit(clk, reset, RA, RB, RD, OPCODE, State, W_Reg, A, B);
	
	//ALU
	ALU alu (OPCODE, RA, RB, A, B, PC, Alu_out);
	
	//Instruction register via contin assigns
	assign OPCODE = IR[15:12];
	assign RA = IR[11:8];
	assign RB = IR[7:4];
	assign RD = IR[3:0];
	 //Completely redundant I know
		//ir[11:8], ir[7:4], ir[3:0], ir[15:12], 
		//current_state, RF_data_in, //how i initially did it 
		//RF_data_out0, RF_data_out1);
		
	//control Module determine state
	//ALU will input the RF_data_out0/1
	//W Register will output RF_data_in to go into reg file
	//or it will go to PC
	//PC needs to increment i THINK?!
	always_comb begin
		OF = 1'b0;
		Cout = 1'b0;
		if (OPCODE == 4'b0001 || OPCODE == 4'b0011 || OPCODE == 4'b0100 || OPCODE == 4'b0101 || OPCODE == 4'b0110 || OPCODE == 4'b0111 || OPCODE == 4'b1000 || OPCODE == 4'b0001) begin
			OF = (~A[7]^B[7])&Alu_out[7];
			Cout = A[7] + B[7];
		end
		else begin
			OF = 1'b0;
			Cout = 1'b0;
		end
	end

	
	// W register
	always_ff @(posedge clk or posedge reset) begin
		if(reset) begin
			PC <= 8'd0;
			State <= IF;
			W_Reg <= 8'd0;
			end
		else begin
			PC <= nextPC;
			State <= nextstate;
			W_Reg <= Alu_out;
			end
	end
	
	//control state machine
	always_comb begin
		nextstate = State;
		nextPC = PC;
		case(State)
			IF: nextstate = FD;
			FD: nextstate = EX; //might need to break these down to conditionals based off the OPCODE
			EX: nextstate = RWB;
			RWB: begin
				nextstate = IF;
				// set PC based on going to the next instruction (? this might be our skips) based on OPCODE
				nextPC = PC + 8'd1; //jumps handled below //A HALT would just not increment PC
				if(OPCODE == 4'hE)
					nextPC = {RA, RB};
				else if (OPCODE == 4'hD) begin
					if (A >= B) begin
						nextPC = PC + RD;
						end
					end
				else if(OPCODE == 4'hF) begin
					nextPC = PC;
					end
				end
				
			default: begin
				nextstate = State;
				nextPC = PC;
				end
		endcase
	end


	

endmodule 
/* professor just incorporated this in the lab5 module
module Control(input clk, reset, input [3:0] OPCODE, input [1:0] current_state, output [1:0] state);
	
	localparam IF = 2'b00, FD = 2'b01, EX = 2'b10, RWB = 2'b11; 
	logic [1:0] nextstate;
	
	always_ff @ (posedge clk or posedge reset) begin
		if (reset)
			state <= IF;
		else
			state <= nextstate;
	end
	
	always_comb begin
		nextstate = state;
		
		case(current_state)
			IF: nextstate = FD;
			FD: nextstate = EX; //might need to break these down to conditionals based off the OPCODE
			EX: nextstate = RWB;
			RWB: nextstate = IF;
			default: nextstate = state;
		endcase
	end
endmodule
*/
module ALU(input [3:0] OPCODE, RA, RB, input [7:0] A, B, PC, output logic [7:0] alu_out);
	//localparam ADD = 4'h1,
	always_comb begin
		alu_out = 8'd0;
		//nextPC = PC;
		
		case(OPCODE)
			4'h1: begin //Add
				alu_out = A + B;
				end
			4'h2: begin
				alu_out = {RA, RB};
				end
			4'h3: begin
				alu_out = A - B;
				end
			4'h4: begin
				alu_out = A + RB;
				end
			4'h5: begin
				alu_out = A/B;
				end
			4'h6: begin
				alu_out = A*B;
				end
			4'h7: begin
				alu_out = B - 8'd1;
				end
			4'h8: begin
				alu_out = B + 8'd1;
				end
			4'h9: begin
				alu_out = ~(A | B);
				end
			4'hA: begin
				alu_out = ~(A&B);
				end
			4'hB: begin
				alu_out = (A^B);
				end
			4'hC: begin
				alu_out = ~B;
				end
			/*4'hD: begin
					if (A >= B) begin
						nextPC = PC + alu_out;
					end
				end
			4'hE: begin
				nextPC = alu_out;		//these jumps are taken care of in the lab portion above
				end
			4'hF: begin
				//halt somehow................ 
				nextPC = 8'd0; //?? perchance
				end*/ 
			default: begin 
				alu_out = 8'd0;
				end
		endcase
	end
endmodule

module RegFile(
	input clk, reset,
	input [3:0] RA, input [3:0] RB, input [3:0] RD, input [3:0] OPCODE, 
	input [1:0] current_state, input [7:0] RF_data_in, //output of the W Register
	output logic [7:0] RF_data_out0, output logic [7:0] RF_data_out1);

	localparam IF=2'b00, FD=2'b01, EX=2'b10, RWB=2'b11; //maybe?

	logic [7:0] RF [15:0];
	int i;
	
	always_ff @ (posedge clk or posedge reset)
	begin
		i = 0; //just easiest way to reset RF, i believe
		if (reset) begin
			RF_data_out0 <= 8'd0;
			RF_data_out1 <= 8'd0;
			for (i=0; i<16; i=i+1) begin //above
				RF[i] <= 8'd0;
			end
		end
		else begin
			RF_data_out0 <= RF[RA];
			RF_data_out1 <= RF[RB];
		
			if (current_state == RWB && ~(OPCODE == 4'd13 || OPCODE == 4'd14 || OPCODE == 4'd15)) begin
				RF[RD] <= RF_data_in;
			end
		end
	end

endmodule

module ROM(input [7:0] PC, output logic [15:0] IR);

	logic [15:0] mem [20:0];
	
	assign mem[8'h00] = 16'h2000;
	assign mem[8'h01] = 16'h2011;
	assign mem[8'h02] = 16'h2002;
	assign mem[8'h03] = 16'h20A3;
	assign mem[8'h04] = 16'hD236;
	assign mem[8'h05] = 16'h1014;
	assign mem[8'h06] = 16'h4100;
	assign mem[8'h07] = 16'h4401;
	assign mem[8'h08] = 16'h8022;
	assign mem[8'h09] = 16'hE040;
	assign mem[8'h0A] = 16'h4405;
	assign mem[8'h0B] = 16'h5536;
	assign mem[8'h0C] = 16'h6637;
	assign mem[8'h0D] = 16'h3538;
	assign mem[8'h0E] = 16'h4329;
	assign mem[8'h0F] = 16'h709A;
	assign mem[8'h10] = 16'h70AB;
	assign mem[8'h11] = 16'hBB8C;
	assign mem[8'h12] = 16'h9D8E;
	assign mem[8'h13] = 16'hC0EF;
	assign mem[8'h14] = 16'hF000;

	assign IR = mem[PC];
endmodule

module pmcntr #(parameter siz=5) (input clk, reset, input [siz-1:0] count_max, output logic [siz-1:0] count, output logic clkout); 
	always_ff @ (posedge clk or posedge reset)  
		if (reset) begin   
			count <= {siz{1'b0}};   
			clkout <= 1'b0;   
		end  
		else if (count<count_max)   
			count <= count + {{(siz-1){1'b0}},1'b1}; 
		else begin   
			count <= {siz{1'b0}};   
			clkout <= ~clkout;  
		end 
endmodule 