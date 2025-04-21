
// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC_test (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50, valid, makeBreak, outCode);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic [9:0]  LEDR;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
	 input logic [7:0] outCode;
	 input logic valid, makeBreak;
    output logic [35:0] GPIO_1;
    input logic CLOCK_50;
	 
	 
	 /* Set up system base clock to 1526 Hz (50 MHz / 2**(14+1))
	    ===========================================================*/
	 logic [31:0] clk;
	 logic SYSTEM_CLOCK;
	 
	 parameter whichClock = 14; // 1526 Hz clock signal	
	 clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk)); 
	  
	 
	 /* If you notice flickering, set SYSTEM_CLOCK faster.
	    However, this may reduce the brightness of the LED board. */
	
	 
	 /* Set up LED board driver
	    ================================================================== */
	 logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs
    logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs
	 logic RST;                   // reset - toggle this on startup
	 
	 assign RST = SW[9];
	 
	`ifdef ALTERA_RESERVED_QIS
		assign SYSTEM_CLOCK = clk[whichClock]; // for board
	`else
		assign SYSTEM_CLOCK = CLOCK_50; // for simulation
	`endif
	 
	 /* Standard LED Driver instantiation - set once and 'forget it'. 
	    See LEDDriver.sv for more info. Do not modify unless you know what you are doing! */
	 LEDDriver Driver (.CLK(SYSTEM_CLOCK), .RST, .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);
	 
	 
	 /* LED board test submodule - paints the board with a static pattern.
	    Replace with your own code driving RedPixels and GrnPixels.
		 
	 	 KEY0      : Reset
		 =================================================================== */
	 // LED_test test (.RST(SW[9]), .RedPixels, .GrnPixels);
	 
	 logic increment, win;
	 logic [1:0] snakeDirection;
	 logic [4:0] currentSnakeLength;
	 logic [3:0] snakeHeadX;
	 logic [3:0] snakeHeadY;
	 logic died;
	 logic enable;
	 logic [10:0] count;
	 
	`ifdef ALTERA_RESERVED_QIS
		parameter enableTime = 2000; // for board
	`else
		parameter enableTime = 1; // for simulation
	`endif
	 
	 always_ff @(posedge SYSTEM_CLOCK) begin
		if (RST) begin
			enable <= 0;
			count <= 0;
		end
		else if (count < enableTime) begin
			enable <= 0;
			count <= count + 1;
		end
		else if (count == enableTime) begin
			enable <= 1;
			count <= 0;
		end
	end
	 
	 
	// keyboard_press_driver keyboard(.CLOCK_50, .valid(valid), .makeBreak(makeBreak), .outCode(outCode), .PS2_DAT(PS2_DAT), .PS2_CLK(PS2_CLK), .reset(RST));
	userInput user(.clk(SYSTEM_CLOCK), .reset(RST), .makeBreak(makeBreak), .valid(valid), .outCode(outCode), .snakeDirection(snakeDirection));
	snakeHeadControl snakeControl (.clk(SYSTEM_CLOCK), .reset(RST), .snakeDirection(snakeDirection), .snakeHeadX(snakeHeadX), .snakeHeadY(snakeHeadY), .enable);
	// userInput2 user (.clk(SYSTEM_CLOCK), .reset(RST), .KEY, .snakeDirection);
	 
	greenLED leds (.clk(SYSTEM_CLOCK), .reset(RST), .currentSnakeLength, .snakeHeadX, .snakeHeadY, .GrnPixels, .died, .enable);
	displayApple apples (.clk(SYSTEM_CLOCK), .reset(RST), .win(win), .RedPixels(RedPixels), .died);
	appleEaten eaten (.clk(SYSTEM_CLOCK), .reset(RST), .win(win), .currentSnakeLength(currentSnakeLength), .snakeHeadX(snakeHeadX), .snakeHeadY(snakeHeadY), .RedPixels(RedPixels));
	 
	counters counter1(.clk(SYSTEM_CLOCK), .reset(RST), .win(win), .increment(increment), .score(HEX0));
	counters2 counter2(.clk(SYSTEM_CLOCK), .reset(RST), .win(win), .increment(increment), .score(HEX1));
	 
	collisionOccurs collision (.clk(SYSTEM_CLOCK), .reset(RST), .snakeHeadX, .snakeHeadY, .snakeDirection, .GrnPixels, .died, .HEX5, .HEX4, .HEX3, .HEX2, .enable);
endmodule

module DE1_SoC_test_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0]  LEDR;
	logic [3:0]  KEY;
	logic [9:0]  SW;
	logic [7:0] outCode;
	logic valid, makeBreak;
	logic [35:0] GPIO_1;
	logic CLOCK_50;
	
	DE1_SoC_test dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .SW, .LEDR, .GPIO_1, .CLOCK_50, .valid, .makeBreak, .outCode);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	
	initial begin
		SW[9] <= 0;
		outCode <= 0;
		valid <= 0;
		makeBreak <= 0;
		@(posedge CLOCK_50);
		
		SW[9] <= 1;
		repeat(3) @(posedge CLOCK_50);
		SW[9] <= 0;
		repeat(3) @(posedge CLOCK_50);
		
		makeBreak <= 1;
		valid <= 1;
		outCode <= 8'h1D;
		repeat(6) @(posedge CLOCK_50);
		
		makeBreak <= 1;
		valid <= 1;
		outCode <= 8'h23;
		repeat(6) @(posedge CLOCK_50);
		$stop;
	end
endmodule
