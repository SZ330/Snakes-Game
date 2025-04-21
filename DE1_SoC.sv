
// module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50);
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50, PS2_DAT, PS2_CLK);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic [9:0]  LEDR;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
    output logic [35:0] GPIO_1;
    input logic CLOCK_50;
	 input logic PS2_DAT;
	 input logic PS2_CLK;
	 
	 
	 /* Set up system base clock to 1526 Hz (50 MHz / 2**(14+1))
	    ===========================================================*/
	 logic [31:0] clk;
	 logic SYSTEM_CLOCK;
	 parameter whichClock = 14;
	 logic RST; 
	 
	 clock_divider divider (.clock(CLOCK_50), .reset(RST), .divided_clocks(clk)); 
	 
	 /* If you notice flickering, set SYSTEM_CLOCK faster.
	    However, this may reduce the brightness of the LED board. */
	
	`ifdef ALTERA_RESERVED_QIS
		assign SYSTEM_CLOCK = clk[whichClock]; // for board
	`else
		assign SYSTEM_CLOCK = CLOCK_50; // for simulation
	`endif
	 
	 /* Set up LED board driver
	    ================================================================== */
	 logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs
    logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs
                  // reset - toggle this on startup
	 
	 assign RST = SW[9];
	 
	 /* Standard LED Driver instantiation - set once and 'forget it'. 
	    See LEDDriver.sv for more info. Do not modify unless you know what you are doing! */
	 LEDDriver Driver (.CLK(SYSTEM_CLOCK), .RST, .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);
	 
	 
	 /* LED board test submodule - paints the board with a static pattern.
	    Replace with your own code driving RedPixels and GrnPixels.
		 
	 	 KEY0      : Reset
		 =================================================================== */
	 // LED_test test (.RST(SW[9]), .RedPixels, .GrnPixels);
	 logic valid, makeBreak;
	 logic [7:0] outCode;
	 logic increment, win, died, enable;
	 logic [1:0] snakeDirection;
	 logic [4:0] currentSnakeLength;
	 logic [3:0] snakeHeadX;
	 logic [3:0] snakeHeadY;
	 logic [10:0] count;
	 
	`ifdef ALTERA_RESERVED_QIS
		parameter enableTime = 800; // for board
	`else
		parameter enableTime = 1; // for simulation
	`endifS
	 
	 always_ff @(posedge SYSTEM_CLOCK) begin
		if (RST) begin
			enable <= 0;
			count <= 0;
		end
		else if (count != enableTime) begin
			enable <= 0;
			count <= count + 1;
		end
		else if (count == enableTime) begin
			enable <= 1;
			count <= 0;
		end
	end
	
	always_ff @(posedge CLOCK_50) begin
		if (valid && makeBreak) begin
			LEDR[7:0] <= outCode;
		end
	end
	
	assign LEDR[9:8] = snakeDirection;
	
	keyboard_press_driver (.CLOCK_50(CLOCK_50), .valid, .makeBreak, .outCode, .PS2_DAT, .PS2_CLK, .reset(RST)); 
	userInput user(.clk(CLOCK_50), .reset(RST), .makeBreak(makeBreak), .valid(valid), .outCode(outCode), .snakeDirection(snakeDirection));
	//userInput2 user (.clk(SYSTEM_CLOCK), .reset(RST), .KEY, .snakeDirection(snakeDirection));
	snakeHeadControl snakeControl (.clk(SYSTEM_CLOCK), .reset(RST), .snakeDirection(snakeDirection), .snakeHeadX(snakeHeadX), .snakeHeadY(snakeHeadY), .enable);
	 
	greenLED leds (.clk(SYSTEM_CLOCK), .reset(RST), .currentSnakeLength, .snakeHeadX, .snakeHeadY, .GrnPixels, .died, .enable);
	displayApple apples (.clk(SYSTEM_CLOCK), .reset(RST), .win(win), .RedPixels(RedPixels), .died, .enable);
	appleEaten eaten (.clk(SYSTEM_CLOCK), .reset(RST), .win(win), .currentSnakeLength(currentSnakeLength), .snakeHeadX(snakeHeadX), .snakeHeadY(snakeHeadY), .RedPixels(RedPixels), .enable);
	 
	counters counter1(.clk(SYSTEM_CLOCK), .reset(RST), .win(win), .increment(increment), .score(HEX0));
	counters2 counter2(.clk(SYSTEM_CLOCK), .reset(RST), .win(win), .increment(increment), .score(HEX1));
	 
	collisionOccurs collision (.clk(SYSTEM_CLOCK), .reset(RST), .snakeHeadX, .snakeHeadY, .snakeDirection, .GrnPixels, .died, .HEX5, .HEX4, .HEX3, .HEX2, .enable);
endmodule

module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0]  LEDR;
	logic [3:0]  KEY;
	logic [9:0]  SW;
	logic [35:0] GPIO_1;
	logic CLOCK_50;
	logic PS2_DAT, PS2_CLK;
	
	// DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .SW, .LEDR, .GPIO_1, .CLOCK_50);
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .SW, .LEDR, .GPIO_1, .CLOCK_50, .PS2_DAT, .PS2_CLK);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	
	initial begin
		SW[9] <= 0;
		KEY <= '1;
		@(posedge CLOCK_50);
		
		SW[9] <= 1;
		repeat(5) @(posedge CLOCK_50);
		SW[9] <= 0;
		@(posedge CLOCK_50);


		KEY[0] <= 0;
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		KEY[0] <= 1;
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		
		KEY[1] <= 0;
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		KEY[0] <= 1;
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		$stop;
	end
endmodule
