
module LFSR (clk, reset, lfsrOut, enable);
	input logic clk, reset, enable;
	output logic [3:0] lfsrOut;
	
	
	always_ff @(posedge clk) begin
		if (reset)
			lfsrOut <= 4'b0110;
		else
			lfsrOut <= {lfsrOut[2:0], ~(lfsrOut[3] ^ lfsrOut[2])};
	end
endmodule

