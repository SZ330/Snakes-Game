
module greenLED (clk, reset, currentSnakeLength, snakeHeadX, snakeHeadY, GrnPixels, died, enable);
	input logic clk, reset, enable;
	input logic [4:0] currentSnakeLength;
	input logic [3:0] snakeHeadX, snakeHeadY;
	input logic died;
	output logic [15:0][15:0] GrnPixels;
	
	genvar x, y;
	generate
		for (x = 0; x < 16; x++) begin: eachRow
			for (y = 0; y < 16; y++) begin: eachCol
				light pixel (.clk, .reset, .snakeHeadX(snakeHeadX), .snakeHeadY(snakeHeadY), .light_x(x), .light_y(y), .lightOn(GrnPixels[x][y]), .currentSnakeLength, .died, .enable);
			end
		end
	endgenerate
endmodule	
	 
	 
// Light up the snakeHead for as long as the current length of the snake
module light (clk,  reset, snakeHeadX, snakeHeadY, light_x, light_y, lightOn, currentSnakeLength, died, enable);
	input logic clk, reset, enable;
	input logic [3:0] snakeHeadX, snakeHeadY;	
	input logic [3:0] light_x, light_y;
	input logic [4:0] currentSnakeLength;
	input logic died;
	output logic lightOn;

	logic [4:0] lightTime;
	
	// The head of the snake being displayed
	always_ff @(posedge clk) begin
		if (reset | died)
			lightTime <= 0;
		else begin
			if (enable && (snakeHeadX == light_x) && (snakeHeadY == light_y))
				lightTime <= currentSnakeLength;
			else if (enable && lightTime > 0) 
				lightTime <= lightTime - 5'd1;
		end
	end
	
	assign lightOn = (lightTime > 0);
endmodule


module greenLED_testbench();
	logic clk, reset, enable, died;
	logic [4:0] currentSnakeLength;
	logic [3:0] snakeHeadX, snakeHeadY;
	logic [15:0][15:0] GrnPixels;
	
	greenLED led(.clk, .reset, .currentSnakeLength, .snakeHeadX, .snakeHeadY, .GrnPixels, .died, .enable);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		reset <= 0;
		enable <= 0;
		currentSnakeLength <= 0;
		snakeHeadX <= 0;
		snakeHeadY <= 0;
		died <= 0;
		@(posedge clk);
		
		reset <= 1;
		@(posedge clk);
		reset <= 0;
		@(posedge clk);
		
		enable <= 1;
		currentSnakeLength <= 3;
		snakeHeadX <= 9;
		snakeHeadY <= 10;
		repeat(5) @(posedge clk);
		
		snakeHeadX <= 9;
		snakeHeadY <= 9;
		repeat(5) @(posedge clk);
		
		snakeHeadX <= 9;
		snakeHeadY <= 8;
		repeat(5) @(posedge clk);
		$stop;
	end
endmodule
		