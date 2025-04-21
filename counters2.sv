
module counters2 (clk, reset, win, increment, score);
	input logic clk, reset, win, increment;
	output logic [6:0] score;
	
	logic [3:0] counter;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			counter <= 4'b0000;
		end
		else if (increment & (counter != 4'b1001)) begin
			counter <= counter + 1'b1;
		end
   end
	
	always_comb begin
		case(counter)
			4'b0000: score = 7'b1000000;  // 0
			4'b0001: score = 7'b1111001;  // 1
			4'b0010: score = 7'b0100100;  // 2
			4'b0011: score = 7'b0110000;  // 3
			4'b0100: score = 7'b0011001;  // 4
			4'b0101: score = 7'b0010010;  // 5
			4'b0110: score = 7'b0000010;  // 6
			4'b0111: score = 7'b1111000;  // 7
			4'b1000: score = 7'b0000000;  // 8
			4'b1001: score = 7'b0010000; 	// 9
			default: score = 7'b1111111;
		endcase
	end
endmodule

module counters2_testbench ();
	logic clk, reset, win, increment;
	logic [6:0] score;
	
	counters2 count (.clk(clk), .reset(reset), .win(win), .increment(increment), .score(score));
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		// Initialize inputs
		reset <= 0;
		win <= 0;
		increment <= 1;
		@(posedge clk);

		// Test 1: Reset the counter
		reset <= 1;
		@(posedge clk);
		reset <= 0;
		@(posedge clk);

		win <= 1;
		@(posedge clk);
		win <= 0;
		@(posedge clk);

		win <= 1;
		@(posedge clk);
		win <= 0;
		@(posedge clk);
		
		win <= 1;
		@(posedge clk);
		win <= 0;
		@(posedge clk);
		
		win <= 1;
		@(posedge clk);
		win <= 0;
		@(posedge clk);
		
		win <= 1;
		@(posedge clk);
		win = 0;
		@(posedge clk);
		
		win <= 1;
		@(posedge clk);
		win <= 0;
		@(posedge clk);
		
		win <= 1;
		@(posedge clk);
		win <= 0;
		@(posedge clk);
		
		win <= 1;
		@(posedge clk);
		win <= 0;
		@(posedge clk);
		
		win <= 1;
		@(posedge clk);
		win <= 0;
		@(posedge clk);
		
		win <= 1;
		@(posedge clk);
		win <= 0;
		@(posedge clk);
		
		win <= 1;
		@(posedge clk);
		win <= 0;
		@(posedge clk);
		
		$stop;
	end
endmodule
	