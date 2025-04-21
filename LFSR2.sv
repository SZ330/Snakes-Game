
module LFSR2 (clk, reset, lfsrOut2, enable);
	input logic clk, reset, enable;
	output logic [3:0] lfsrOut2;
	
	
	always_ff @(posedge clk) begin
		if (reset)
			lfsrOut2 <= 4'b1010;
		else
			lfsrOut2 <= {lfsrOut2[2:0], ~(lfsrOut2[3] ^ lfsrOut2[2])};
	end
endmodule
