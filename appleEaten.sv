
module appleEaten(clk, reset, win, currentSnakeLength, snakeHeadX, snakeHeadY, RedPixels, enable);
	input logic clk, reset, enable;
	input logic [3:0] snakeHeadX, snakeHeadY;
	input logic [15:0][15:0] RedPixels;
	output logic win;
	output logic [4:0] currentSnakeLength;
	
	// logic prevApple;

   always_ff @(posedge clk) begin
		if (reset) begin
			win <= 0;
         currentSnakeLength <= 5'd3;
         // prevApple <= 0;
      end 
		else begin
            
         if (enable && RedPixels[snakeHeadX][snakeHeadY] == 1) begin
				win <= 1;
            currentSnakeLength <= currentSnakeLength + 5'd1;
         end 
			else begin
             win <= 0;
         end
     end
   end
endmodule


module appleEaten_testbench();
	logic clk, reset, enable;
	logic [3:0] snakeHeadX, snakeHeadY;
	logic [15:0][15:0] RedPixels;
	logic win;
	logic [4:0] currentSnakeLength;
	
	appleEaten eaten (.clk, .reset, .win, .currentSnakeLength, .snakeHeadX, .snakeHeadY, .RedPixels);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		reset <= 0;
		snakeHeadX <= 0;
		snakeHeadY <= 0;
		RedPixels <= 0;
		@(posedge clk);
		
		reset <= 1;
		@(posedge clk);
		reset <= 0;
		@(posedge clk);
		
		enable <= 1;
		RedPixels[5][5] <= 1;
		snakeHeadX <= 5;
		snakeHeadY <= 5;
		@(posedge clk);
		
		reset <= 1;
		RedPixels[5][5] <= 0;
		@(posedge clk);
		reset <= 0;
		@(posedge clk);
		
		RedPixels[13][11] <= 1;
		snakeHeadX <= 13;
		snakeHeadY <= 11;
		@(posedge clk);
		
		reset <= 1;
		RedPixels[13][11] <= 0;
		@(posedge clk);
		reset <= 0;
		@(posedge clk);
		
		RedPixels[12][12] <= 1;
		snakeHeadX <= 2;
		snakeHeadY <= 4;
		@(posedge clk);
		@(posedge clk);
		
		reset <= 1;
		RedPixels[12][12] <= 0;
		@(posedge clk);
		reset <= 0;
		@(posedge clk);
		$stop;
	end
	
endmodule
	