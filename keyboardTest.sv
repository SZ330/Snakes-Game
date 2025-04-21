
module keyboardTest (clk, reset, makeBreak, valid, outCode, LEDR);
	input logic clk, reset, makeBreak, valid;
	input logic [7:0] outCode;
	output logic [9:0] LEDR;
	
	always_ff @(posedge clk) begin
		if (reset)
			LEDR <= 0;
		else if (valid & makeBreak) begin
			if (outCode == 8'h1C)
				LEDR[0] <= 1;
		end
	end
endmodule

module keyboardTest_testbench();	
	logic clk, reset, makeBreak, valid;
	logic [7:0] outCode;
	logic [9:0] LEDR;
	
	keyboardTest keyboard(.clk, .reset, .makeBreak, .valid, .outCode, .LEDR);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		reset <= 0;
		makeBreak <= 0;
		valid <= 0;
		outCode <= 0;
		LEDR <= 0;
		@(posedge clk);
		
		reset <= 1;
		@(posedge clk);
		reset <= 0;
		@(posedge clk);
		
		valid <= 1;
		makeBreak <= 1;
		outCode <= 8'h1C;
		repeat(5) @(posedge clk);
		
		$stop;
	end
endmodule
