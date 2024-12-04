`timescale 1 ns/ 100 ps
module VGAController(    
    input clk, 
	input clk25, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	input [3199:0] x_values, 	//these values are the array that will hold the individual parts of the snake 
	input [3199:0] y_values,	//we will only be changing the size of the head --> -1 if there is not a part
	input game_done,
	input [31:0] food_x,
	input [31:0] food_y,
    input [31:0] score, 
	input [31:0] high_score, 

	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data);


	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/cgb45/Downloads/ece_350_project-main/ece_350_project-main/vga/";

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA Height
	
	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   

	// Image Data to Map Pixel Location to Color Address
	localparam 
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen

		SPRITE_COUNT = 94, 
		APPLE_COUNT = 94, 
		SPRITE_ADDRESS_WIDTH = $clog2(SPRITE_COUNT*2500) + 1,
        APPLE_ADDRESS_WIDTH = $clog2(APPLE_COUNT*2500) + 1,
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command

		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	assign imgAddress = x + 640*y;				 // Address calculated coordinate

	RAM_VGA #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "image.mem"})) // Memory initialization
	ImageData(
		.clk(clk25), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel

	RAM_VGA #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colors.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk25), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always 

	// SCORE RAM / CODE
	RAM_VGA #(
		.DEPTH(SPRITE_COUNT * 2500), 		       		
		.DATA_WIDTH(1'b1), 		      
		.ADDRESS_WIDTH(SPRITE_ADDRESS_WIDTH),    
		.MEMFILE({FILES_PATH, "sprites.mem"}))  
	ScoreData(
		.clk(clk), 							   	   
		.addr(score_address),					     
		.dataOut(score_colorAddr),				       
		.wEn(1'b0)); 	

	// HIGH SCORE RAM / CODE
	RAM_VGA #(
		.DEPTH(SPRITE_COUNT * 2500), 		       		
		.DATA_WIDTH(1'b1), 		      
		.ADDRESS_WIDTH(SPRITE_ADDRESS_WIDTH),    
		.MEMFILE({FILES_PATH, "sprites.mem"}))  
	HighScoreData(
		.clk(clk), 							   	   
		.addr(high_score_address),					     
		.dataOut(high_score_colorAddr),				       
		.wEn(1'b0)); 	

	// HIGH SCORE RAM / CODE
	RAM_VGA #(
		.DEPTH(SPRITE_COUNT * 2500), 		       		
		.DATA_WIDTH(1'b1), 		      
		.ADDRESS_WIDTH(SPRITE_ADDRESS_WIDTH),    
		.MEMFILE({FILES_PATH, "sprites.mem"}))  
	EyesData(
		.clk(clk), 							   	   
		.addr(eyeball_address),					     
		.dataOut(eyeballs_colorAddr),				       
		.wEn(1'b0)); 	

    // APPLE RAM / CODE
	RAM_VGA #(
		.DEPTH(SPRITE_COUNT * 1600), 		       		
		.DATA_WIDTH(1'b1), 		      
		.ADDRESS_WIDTH(APPLE_ADDRESS_WIDTH),    
		.MEMFILE({FILES_PATH, "apple.mem"}))  
	AppleData(
		.clk(clk), 							   	   
		.addr(apple_address),					     
		.dataOut(apple_colorAddr),				       
		.wEn(1'b0)); 	

		
    ///////////////////////////////////////////////////////
    // calculate apple address 
    wire[APPLE_ADDRESS_WIDTH-1:0] apple_address;  
    wire apple_colorAddr; //output of apple color 
    assign apple_address = ((y - board_y_start) % 40) * 40 + ((x - board_x_start) % 40); //hardcode apple sprite address to 1st??? (check tho)

	//calculate digits for sprite
	integer score_digits[2:0];	//array to store individual digits 
	integer high_score_digits[2:0]; 

	// calculate sprite address 
	reg[SPRITE_ADDRESS_WIDTH-1:0] score_address, high_score_address, eyeball_address; 

	wire eyeballs_colorAddr; 	//calculate eyeball address 
	wire score_colorAddr, high_score_colorAddr;
	integer score_x_start = 473;
	integer score_y_start = 88; //output of sprite colors
	integer high_score_x_start = 473;
	integer high_score_y_start = 208;
	integer digit_index, digit_index0, current_digit, current_digit0; 
        	

///////////////////////////////////////////////////////
	wire active, screenEnd;
	wire[31:0] x;
	wire[31:0] y;

	//initialize map borders
	integer board_x_start = 48;
	integer board_y_start = 48;
	integer tile_size = 40;

	integer box_size = 40; 	//tile size

	// Temporary register to hold the snake's color for the current pixel
	reg [11:0] box_color;  
	reg [31:0] prev_high_score; 	//change in high score indicator bit 
	initial begin 
		box_color = 12'H0F0; //intialize to green 
	end 

	integer food_color = 12'HF00;

	reg [31:0] current_x;
	reg [31:0] current_y;
	integer j;

	reg[BITS_PER_COLOR-1:0] colorDataBox; 
	reg [31:0] snake_pos_x, snake_pos_y, food_pos_x, food_pos_y; 


    //try slowing clock with clock division
	always @(posedge clk) begin
		colorDataBox = colorData;
		if(box_color == 0) begin
			box_color = 12'H00F;
		end
		else if(high_score != prev_high_score)begin 
			box_color = box_color << 4; //change 
		end
		
		prev_high_score = high_score; 

		for (j = 0; j < 100; j = j + 1) begin

			current_x = x_values[32*(j) +: 32];
			current_y = y_values[32*(j) +: 32];
			//current_x = x_values[31:0];
			//current_y = y_values[31:0];
		
				if (current_x != -1 && current_y != -1) begin
					snake_pos_x = board_x_start + current_x * tile_size; 
					snake_pos_y = board_y_start + current_y * tile_size;

					if (((x >= (snake_pos_x)) && 
						(x < (snake_pos_x + box_size))) &&
						((y >= (snake_pos_y)) && 
						(y < (snake_pos_y + box_size)))) 
					begin

						if(j==0)begin 
        					eyeball_address = (11 * 2500) + 	//assign it the correct sprite.mem values 
										((x - snake_pos_x)%50) + 	//X offset within digit
										((y - snake_pos_y)*50); 	//Y offset within digit

							if(eyeballs_colorAddr == 1'b1)begin
										colorDataBox = 12'H00;
										end else begin 
										colorDataBox = box_color; 
										end 
						end 
						
						else begin 
						colorDataBox = box_color; 
						end 

						//for the first head --> must assign 
						
					end 
				end
		end

	/////// food generation code ////////
		food_pos_x = board_x_start + food_x * tile_size;
		food_pos_y = board_y_start + food_y * tile_size;


		//check if red box or sprite 
		if (((x >= (food_pos_x)) && (x < (food_pos_x + box_size))) && ((y >= (food_pos_y)) && (y < (food_pos_y + box_size)))) begin
			if (apple_colorAddr == 1'b1) begin
				colorDataBox = food_color;  // red for apple pixels
			end else begin
				colorDataBox = colorData;  // Default to background
			end
		end

		//calc digs for sprite
		score_digits[0] = score % 10; 			//ones place 
		score_digits[1] = (score / 10) % 10; 	//tenths place
		score_digits[2] = (score / 100) % 10; 	//hundredths 

		high_score_digits[0] = high_score % 10; 			//ones place 
		high_score_digits[1] = (high_score / 10) % 10; 	//tenths place
		high_score_digits[2] = (high_score / 100) % 10; 	//hundredths 

        //check if in score display location // 
    	if ((x >= score_x_start) && (x < (score_x_start + 50 * 3)) && (y >= score_y_start) && (y < (score_y_start + 50))) begin

			// calc which digit we're currently on
        	digit_index = (x - score_x_start) / 50; //divides X coordinate into sections 
        	current_digit = score_digits[3 - digit_index - 1];	//calculates what digit we're one based on what X section

        	score_address = (current_digit * 2500) + 	//assign it the correct sprite.mem values 
									((x - score_x_start)%50) + 	//X offset within digit
									((y - score_y_start)*50); 	//Y offset within digit


			if(score_colorAddr == 1'b1) begin 
				colorDataBox = 12'H000; //black
			end else begin 
				colorDataBox = colorData; //default to background
			end 
		end

		//check if in high score display location // 
    	if ((x >= high_score_x_start) && (x < (high_score_x_start + 50 * 3)) && (y >= high_score_y_start) && (y < (high_score_y_start + 50))) begin

			// calc which digit we're currently on
        	digit_index0 = (x - high_score_x_start) / 50; //divides X coordinate into sections 
        	current_digit0 = high_score_digits[3 - digit_index0 - 1];	//calculates what digit we're one based on what X section

        	high_score_address = (current_digit0 * 2500) + 	//assign it the correct sprite.mem values 
									((x - high_score_x_start)%50) + 	//X offset within digit
									((y - high_score_y_start)*50); 	//Y offset within digit

			if(high_score_colorAddr == 1'b1) begin 
				colorDataBox = 12'H000; //black
			end else begin 
				colorDataBox = colorData; //default to background
			end 
		end


	end

	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut;
	assign colorOut = active ? colorDataBox : 12'd0; // When not active, output black
		
	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
	
endmodule