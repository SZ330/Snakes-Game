
module collisionOccurs (clk, reset, snakeHeadX, snakeHeadY, snakeDirection, GrnPixels, died, HEX5, HEX4, HEX3, HEX2, enable);
	input logic clk, reset;
	input logic [3:0] snakeHeadX, snakeHeadY;
	input logic [1:0] snakeDirection;
	input logic [15:0][15:0] GrnPixels;
	output logic died; 
	input logic enable;
	output logic [6:0] HEX5, HEX4, HEX3, HEX2;
	
	
	// Collision detection for body hit and boundary hit
	always_ff @(posedge clk) begin
		if (reset) begin
			died <= 0;
		end
		else if (enable && (GrnPixels[snakeHeadX][snakeHeadY] == 1)) begin
			died <= 1;
		end
		else if (enable && (snakeHeadX == 0) && (snakeDirection == 2'b00)) begin   // W
			died <= 1;
		end
		else if (enable && (snakeHeadY == 15) && (snakeDirection == 2'b01)) begin // A
			died <= 1;
		end
		else if (enable && (snakeHeadX == 15) && (snakeDirection == 2'b10)) begin  // S
			died <= 1;
		end
		else if (enable && (snakeHeadY == 0) && (snakeDirection == 2'b11)) begin   // D
			died <= 1;
		end
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			HEX5 <= 7'b1111111;
			HEX4 <= 7'b1111111;
			HEX3 <= 7'b1111111;
			HEX2 <= 7'b1111111;
		end
		else if (died) begin
			HEX5 <= 7'b0100001;
			HEX4 <= 7'b0000110;
			HEX3 <= 7'b0001000;
			HEX2 <= 7'b0100001;
		end
	end
endmodule


module collisionOccurs_testbench();
	logic clk, reset, died, enable;
	logic [3:0] snakeHeadX, snakeHeadY;
	logic [1:0] snakeDirection;
	logic [15:0][15:0] RedPixels, GrnPixels;
	logic [6:0] HEX5, HEX4, HEX3, HEX2;
	
	collisionOccurs collide (.clk(clk), .reset, .snakeHeadX, .snakeHeadY, .snakeDirection, .GrnPixels, .died, .HEX5, .HEX4, .HEX3, .HEX2, .enable);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end 
	
	initial begin
		reset <= 0;
		snakeHeadX <= 0;
		snakeHeadY <= 0;
		snakeDirection <= 2'b11;
		GrnPixels <= 0;
		@(posedge clk);
		
		reset <= 1;
		@(posedge clk);
		reset <= 0;
		@(posedge clk);
		
		// Snake crashes into itself
		GrnPixels[9][9] <= 1;
		snakeHeadX <= 9;
		snakeHeadY <= 9;
		repeat(3) @(posedge clk);
		
		reset <= 1;
		@(posedge clk);
		reset <= 0;
		@(posedge clk);
		
		snakeHeadX <= 0;
		snakeDirection <= 2'b00;
		repeat(3) @(posedge clk);
		
		
		reset <= 1;
		@(posedge clk);
		reset <= 0;
		@(posedge clk);
		
		snakeHeadY <= 15;
		snakeDirection <= 2'b01;
		repeat(3) @(posedge clk);
		
		
		reset <= 1;
		@(posedge clk);
		reset <= 0;
		@(posedge clk);
		
		snakeHeadX <= 15;
		snakeDirection <= 2'b10;
		repeat(3) @(posedge clk);
		
		
		reset <= 1;
		@(posedge clk);
		reset <= 0;
		@(posedge clk);
		
		snakeHeadY <= 0;
		snakeDirection <= 2'b11;
		repeat(3) @(posedge clk);
		
		$stop;
	end
endmodule
