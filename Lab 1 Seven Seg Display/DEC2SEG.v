//convert dec value (as 8 bit binary) to 7 segment display
module DEC2SEG(input [7:0] binVal, output reg [6:0] HexSeg);
	always @ (*) begin
	HexSeg = 7'd0;
	$display("Decimal Value %b", binVal);
	case(binVal)
		8'b0: HexSeg[6] = 1; //0
		8'b1: begin //1
			HexSeg[0] = 1; HexSeg[3] = 1; HexSeg[4] = 1; HexSeg[5] = 1; HexSeg[6] = 1;
			end
		8'b10: begin //2
			HexSeg[5] = 1; HexSeg[2] = 1;
			end
		8'b11: begin //3
			HexSeg[5] = 1; HexSeg[4] = 1;
			end
		8'b100: begin //4
			HexSeg[0] = 1; HexSeg[4] = 1; HexSeg[3] = 1;
			end
		8'b101: begin //5
			HexSeg[1] = 1; HexSeg[4] = 1;
			end
		
		8'b110: HexSeg[1] = 1; //6
		
		8'b111:  begin //7
			HexSeg[5] = 1; HexSeg[4] = 1; HexSeg[6] = 1; HexSeg[3] = 1;
			end
			
		8'b1000: HexSeg[0] = 0; //8
		
		8'b1001: HexSeg[4] = 1; //9
		

endmodule