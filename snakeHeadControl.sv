
module snakeHeadControl(clk, reset, snakeDirection, snakeHeadX, snakeHeadY, enable);
	input logic clk, reset;
	input logic enable;
	input logic [1:0] snakeDirection;
	output logic [3:0] snakeHeadX, snakeHeadY;
	
	
	always_ff @(posedge clk) begin
		if (reset) begin
			snakeHeadX <= 4'd9;
			snakeHeadY <= 4'd10;
		end
		else if (enable && snakeDirection == 2'b00)   // W
			snakeHeadX <= snakeHeadX - 4'd1;
		else if (enable && snakeDirection == 2'b01)   // A
			snakeHeadY <= snakeHeadY + 4'd1;
		else if (enable && snakeDirection == 2'b10)
			snakeHeadX <= snakeHeadX + 4'd1;  			 // S
		else if (enable && snakeDirection == 2'b11)
			snakeHeadY <= snakeHeadY - 4'd1;  			 // D
	end
endmodule


module snakeHeadControl_testbench();
	logic clk, reset; 
	logic enable;
	logic [1:0] snakeDirection;
	logic [3:0] snakeHeadX, snakeHeadY;
	
	snakeHeadControl snakeHead (.clk, .reset, .snakeDirection, .snakeHeadX, .snakeHeadY, .enable);

	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		reset <= 0;
		snakeDirection <= 2'b11; // X = 9, Y = 10
		@(posedge clk);
		
		
		// W
		reset <= 1;
		@(posedge clk);
		reset <= 0;
		@(posedge clk);
		enable <= 1;
		snakeDirection <= 2'b00; // X = 9, Y = 9
		@(posedge clk);
		
		
		// A
		reset <= 1;
		@(posedge clk);				
		reset <= 0;
		@(posedge clk);
		enable <= 1;
		snakeDirection <= 2'b01; // X = 10, Y = 10
		@(posedge clk);
		
		
		// S
		reset <= 1;					 
		@(posedge clk);
		reset <= 0;
		@(posedge clk);
		enable <= 1;
		snakeDirection <= 2'b10; // X = 10, Y = 11
		@(posedge clk);
		
		
		// D
		reset <= 1;
		@(posedge clk);
		reset <= 0;
		@(posedge clk);
		enable <= 1;
		snakeDirection <= 2'b11; // X = , Y =
		@(posedge clk);
		
		$stop;
	end
endmodule
