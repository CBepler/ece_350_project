`timescale 1 ns/ 100 ps
module VGAController(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data,
	input BTND,
	input BTNU,
	input BTNR,
	input BTNL);
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/audre/OneDrive/Documents/ECE350/ece350/Lab6_7/lab6_kit/";

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock

	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA Height

	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;
	
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
		SPRITE_ADDRESS_WIDTH = $clog2(SPRITE_COUNT*2500) + 1,
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		ASCII_ADDRESS_WIDTH = $clog2(256) + 1, 
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	assign imgAddress = x + 640*y;				 // Address calculated coordinate

	

	RAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "image.mem"})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel

	RAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colors.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading

	RAM #(
		.DEPTH(SPRITE_COUNT * 2500), 		       		
		.DATA_WIDTH(1'b1), 		      
		.ADDRESS_WIDTH(SPRITE_ADDRESS_WIDTH),    
		.MEMFILE({FILES_PATH, "sprites.mem"}))  
	SpriteData(
		.clk(clk), 							   	   
		.addr(square_Address),					     
		.dataOut(square_colorAddr),				       
		.wEn(1'b0)); 		

	RAM #(
		.DEPTH(256), 		       		
		.DATA_WIDTH(8), 		      
		.ADDRESS_WIDTH(8),    
		.MEMFILE({FILES_PATH, "ascii.mem"}))  
	ASCIIData(
		.clk(clk), 							   	   
		.addr(reg_rx_data),					     
		.dataOut(ascii_Addr),				       
		.wEn(1'b0)); 					      


	 wire[7:0] rx_data;
	 reg[7:0] reg_rx_data;
	 wire read_data;
	 PS2Interface ps2module(.ps2_clk(ps2_clk), .ps2_data(ps2_data), .clk(clk), .rst(reset), .tx_data(8'b0), .write_data(1'b0), .rx_data(rx_data), .read_data(read_data), .busy(1'b0), .err(1'b0));

	always @(posedge clk) begin
		if (read_data==1) begin
			reg_rx_data = rx_data;
		end
	end

	wire [9:0] sprite_x;
	wire [8:0] sprite_y;
	wire[SPRITE_ADDRESS_WIDTH-1:0] square_Address;  	
	wire square_colorAddr; 	
	wire [7:0] ascii_Addr; 	
	assign square_Address = sprite_x + 50*sprite_y + (ascii_Addr-33)*2500;	

	// Assign to output color from register if active
	reg [9:0] ref_x;
	reg [8:0] ref_y;
	initial begin
		ref_x = 320;
		ref_y = 240;
	end
	assign sprite_x = x - ref_x;
	assign sprite_y = y - ref_y;
	wire [9:0] x_boundary;
	assign x_boundary = ref_x + 50;
	wire [8:0] y_boundary;
	assign y_boundary = ref_y + 50;
	wire in_square, sprite_bit;
	assign in_square = (x >= ref_x && x < x_boundary && y >= ref_y && y < y_boundary);
	assign sprite_bit = (in_square && square_colorAddr);
	wire [BITS_PER_COLOR-1:0] colorData_real;
	assign colorData_real =  sprite_bit ? 12'h000 : colorData;
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	assign colorOut = /*active ?*/ colorData_real /*: 12'd0*/; // When not active, output black 
	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;

	

	always @(posedge clk) begin
		if(screenEnd) begin
			if(BTNU && ref_y > 0) begin
				ref_y = ref_y - 1;
			end
			if(BTND && ref_y < 480) begin
				ref_y = ref_y + 1;
			end
			if(BTNR && ref_x > 0) begin
				ref_x = ref_x + 1;
			end
			if(BTNL && ref_x < 640) begin
				ref_x = ref_x - 1;
			end
		end
	end

endmodule