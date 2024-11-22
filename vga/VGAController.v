`timescale 1 ns/ 100 ps
module VGAController(    
    input clk, 
	input clk25, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	input [3199:0] x_values, 	//these values are the array that will hold the individual parts of the snake 
	input [3199:0] y_values,	//we will only be changing the size of the head
	input game_done,
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data);


	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/cgb45/Downloads/ece_350_project-main/ece_350_project-main/vga/";

	// Clock divider 100 MHz -> 25 MHz
//	wire clk25; // 25MHz clock

//	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
//    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
//	always @(posedge clk) begin
//		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
//	end

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA Height

	wire active, screenEnd;
	wire[31:0] x;
	wire[31:0] y;

	//initialize map borders
	wire[31:0] map_width_min, map_width_max;
	wire[31:0] map_height_min, map_height_max; 
	assign map_width_min = 48;
	assign map_width_max = 449;
	assign map_height_min = 48;
	assign map_height_max = 441;


	integer board_x_start = 48;
	integer board_y_start = 48;
	integer tile_size = 40;
	

	////// Imitialize array for snake location
	reg [31:0]snake_pos_pixel_x, snake_pos_pixel_y; 
	always @(posedge clk25) begin
		snake_pos_pixel_x = board_x_start + x_values[31:0] * tile_size; 
		snake_pos_pixel_y = board_y_start + y_values[31:0] * tile_size;
	end
	
	integer box_size = 40; 	//tile size

	wire read_data;
	wire[7:0] rx_data;
	
	Ps2Interface ps(.ps2_clk(ps2_clk), .ps2_data(ps2_data), .rx_data(rx_data), .read_data(read_data));
	
	
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
	wire[BITS_PER_COLOR-1:0] colorData, colorDataBox; // 12-bit color data at current pixel

	RAM_VGA #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colors.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk25), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
	
	//assign color to green box 
	wire inBox;
	assign inBox = (((x >= snake_pos_pixel_x) && (x < snake_pos_pixel_x + box_size)) && ((y >= snake_pos_pixel_y) && (y < snake_pos_pixel_y + box_size))) ? 1 : 0;
	
	integer box_color = 12'd8;
	assign colorDataBox = inBox ? box_color : colorData; 

	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	assign colorOut = active ? colorDataBox : 12'd0; // When not active, output black

	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;

endmodule