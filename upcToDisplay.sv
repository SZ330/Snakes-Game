module upcToDisplay (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, SW);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [1:0] LEDR;
	input logic [9:0] SW;
	logic discount, expensive;
	
	assign discount = (~SW[9] & ~SW[8]) | (SW[9] & ~SW[7]); // Discounted light with logic
	assign expensive = (~SW[8] & ~SW[7] & ~SW[0]) | (SW[9] & SW[7] & ~SW[0]);  // Stolen light
	
	assign LEDR[0]  = discount;
	assign LEDR[1] = expensive;
	
	always_comb begin
		HEX0 = 7'b1111111;
		HEX1 = 7'b1111111;
		HEX2 = 7'b1111111;
		HEX3 = 7'b1111111;
		HEX4 = 7'b1111111;
		HEX5 = 7'b1111111;
		
		case (SW[9:7])
			3'b000: begin // bALL
				HEX5 = 7'b0000011;
				HEX4 = 7'b0001000;
				HEX3 = 7'b1000111;
				HEX2 = 7'b1000111;
			end 
						
			3'b001: begin // CrocS
				HEX5 = 7'b1000110;
				HEX4 = 7'b0101111;
				HEX3 = 7'b0100011;
				HEX2 = 7'b0100111;
				HEX1 = 7'b0010010;
			end
						
			3'b010: begin // lgLoo
				HEX5 = 7'b1111001;
				HEX4 = 7'b0010000;
				HEX3 = 7'b1000111;
				HEX2 = 7'b0100011;
				HEX1 = 7'b0100011;
			end
						
			3'b101: begin // drESS
				HEX5 = 7'b0100001;
				HEX4 = 7'b0101111;
				HEX3 = 7'b0000110;
				HEX2 = 7'b0010010;
				HEX1 = 7'b0010010;
			end
						
			3'b110: begin // ChESS
				HEX5 = 7'b1000110;
				HEX4 = 7'b0001011;
				HEX3 = 7'b0000110;
				HEX2 = 7'b0010010;
				HEX1 = 7'b0010010;
			end
						
			3'b111: begin // goLd
				HEX5 = 7'b0010000;
				HEX4 = 7'b0100011;
				HEX3 = 7'b1000111;
				HEX2 = 7'b0100001;
			end
			default: begin
				HEX0 = 7'b1111111;
				HEX1 = 7'b1111111;
				HEX2 = 7'b1111111;
				HEX3 = 7'b1111111;
				HEX4 = 7'b1111111;
				HEX5 = 7'b1111111;
			end
		endcase
	end
endmodule
			