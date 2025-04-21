
module userInput2 (clk, reset, KEY, snakeDirection);
	input logic clk, reset;
	input logic [3:0] KEY;
	output logic [1:0] snakeDirection;
	
   logic [3:0] prevKEY;

   always_ff @(posedge clk) begin
		if (reset) begin
           snakeDirection <= 2'b00;
           prevKEY <= 4'b1111;     
       end 
		 else begin
           prevKEY <= KEY; 

           if (~KEY[0] && prevKEY[0])         // W
               snakeDirection <= 2'b00;
           else if (~KEY[1] && prevKEY[1])    // A
               snakeDirection <= 2'b01;
           else if (~KEY[2] && prevKEY[2])    // S
               snakeDirection <= 2'b10;
           else if (~KEY[3] && prevKEY[3])    // D
               snakeDirection <= 2'b11;
       end
   end
endmodule

module userInput2_testbench();
	logic clk, reset;
	logic [3:0] KEY;
	logic [1:0] snakeDirection;
	
	userInput2 userInput (.clk, .reset, .KEY, .snakeDirection);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		KEY <= 0;
		reset <= 0;
		@(posedge clk);
		
		reset <= 1;
		@(posedge clk);
		reset <= 0;
		@(posedge clk);
		
		KEY[0] <= 1;
		repeat(2) @(posedge clk);
		KEY[0] <= 0;
		repeat(2) @(posedge clk);
		
		KEY[1] <= 1;
		repeat(2) @(posedge clk);
		KEY[1] <= 0;
		repeat(2) @(posedge clk);
		
		KEY[2] <= 1;
		repeat(2) @(posedge clk);
		KEY[2] <= 0;
		repeat(2) @(posedge clk);
		
		KEY[3] <= 1;
		repeat(2) @(posedge clk);
		KEY[3] <= 0;
		repeat(2) @(posedge clk);
		
		$stop;
	end
endmodule
