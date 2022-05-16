module ASCII27Seg(input [7:0] AsciiCode, output reg [6:0] HexSeg);

	always @ (*) begin
	HexSeg = 7'd0;
	$display("AsciiCode %b", AsciiCode);
	case (AsciiCode)
		//A / a
		8'h41: HexSeg[3] = 1;
		8'h61: HexsSeg[3] = 1;
		//B / b
		8'h42: begin
			HexSeg[0] = 1; HexSeg[1] = 1;
			end
		8'h62: begin
			HexSeg[0] = 1; HexSeg[1] = 1;
			end
		//C / c
		8'h43: begin
			HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[6] = 1;
			end
		8'h63: begin
			HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[6] = 1;
			end

		//D / d
		8'h44: begin
			HexSeg[5] = 1; HexSeg[0] = 1;
			end
		8'h64: begin
			HexSeg[5] = 1; HexSeg[0] = 1;
			end

		//E / e



endmodule //ascii
