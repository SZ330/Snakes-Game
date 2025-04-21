
module displayApple(clk, reset, win, RedPixels, died, enable);
	input logic clk, reset, win, died, enable;
	output logic [15:0][15:0] RedPixels;
	
	logic [3:0] lfsrOut, lfsrOut2;
	logic [5:0] counter;
	
	LFSR lfsr1 (.clk, .reset, .lfsrOut, .enable);
	LFSR2 lfsr2 (.clk, .reset, .lfsrOut2, .enable);
	
	
	// Counter for displaying apples
	always_ff @(posedge clk) begin
		if (reset)
			counter <= 6'b00000;
		else if (win && counter != 6'b111111)
			counter <= counter + 1'b1;
	end
	
	// Display apples using LFSRs
	always_ff @(posedge clk) begin
		if (reset) begin
			logic [15:0][15:0] initialBoard;
			initialBoard = '0;
			initialBoard[lfsrOut][lfsrOut2] = 1'b1;
			RedPixels <= initialBoard;
		end
		else if (win && counter != 6'b111111) begin
			RedPixels <= 0;
			RedPixels[lfsrOut][lfsrOut2] <= 1;
		end
	end
endmodule


module displayApple_testbench();
	logic clk, reset, win, died;
	logic [4:0] counter;
	logic [15:0][15:0] RedPixels;
	
	displayApple apples(.clk, .reset, .win, .RedPixels, .died);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		reset <= 0;
      win <= 0;
      died <= 0;
      @(posedge clk);
        
      reset <= 1;
      @(posedge clk);
      reset <= 0;
      @(posedge clk);
        
      win <= 1;
      repeat(5) @(posedge clk);
        
      win <= 1;
      repeat(5) @(posedge clk);
        
      win <= 1;
      repeat(5) @(posedge clk);
        
      win <= 1;
      repeat(5) @(posedge clk);
        
      win <= 1;
      repeat(5) @(posedge clk);
        
      win <= 1;
      repeat(5) @(posedge clk);
        
      win <= 1;
      repeat(5) @(posedge clk);
        
      win <= 1;
      repeat(5) @(posedge clk);
        
      win <= 1;
      repeat(5) @(posedge clk);
        
      $stop;
    end
endmodule

