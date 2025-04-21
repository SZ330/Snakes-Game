
module userInput (clk, reset, makeBreak, valid, outCode, snakeDirection);
	input logic clk, reset, makeBreak, valid;
	input logic [7:0] outCode;
	output logic [1:0] snakeDirection;
	
	always_ff @(posedge clk) begin
		if (reset)
			snakeDirection <= 2'b00;
		else if (valid && makeBreak) begin			
			if (outCode == 8'h1D)
				snakeDirection <= 2'b00; // W
			else if (outCode == 8'h1C)
				snakeDirection <= 2'b01; // A
			else if (outCode == 8'h1B)
				snakeDirection <= 2'b10; // S
			else if (outCode == 8'h23)
				snakeDirection <= 2'b11; // D
		end
	end		
endmodule


module userInput_testbench();
	logic clk, reset, makeBreak, valid;
	// logic enable;
	logic [7:0] outCode;
	logic snakeDirection;
	
	userInput snakeMovement (.clk(clk), .reset(reset), .makeBreak(makeBreak), .valid(valid), .outCode(outCode), .snakeDirection(snakeDirection));
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end

	initial begin
        // Reset
        reset <= 1; makeBreak <= 0; valid <= 0; @(posedge clk);
        reset <= 0;          @(posedge clk);
		  
		  valid <= 1; makeBreak <= 1;
		  outCode <= 8'h1D; 
		  repeat(4) @(posedge clk);
		  
		  valid <= 0; makeBreak <= 0;
		  repeat(2) @(posedge clk);
		  
		  valid <= 1; makeBreak <= 1;
		  outCode <= 8'h1C; 
		  repeat(4)  @(posedge clk);
		  
		  valid <= 0; makeBreak <= 0;
		  repeat(2) @(posedge clk);
		  
		  valid <= 1; makeBreak <= 1;
		  outCode <= 8'h1B; 
		  repeat(4)  @(posedge clk);
		  
		  valid <= 0; makeBreak <= 0;
		  repeat(2) @(posedge clk);
		  
		  valid <= 1; makeBreak <= 1;
		  outCode <= 8'h23; 
		  repeat(4)  @(posedge clk);
		$stop;
	end
endmodule
