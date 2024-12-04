`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (input clk_100mhz,
				input BTNU,
				input BTNR,
				input BTND,
				input BTNL,
				output [15:0] LED,
				output hSync, 		// H Sync Signal
				output vSync, 		// Veritcal Sync Signal
				output[3:0] VGA_R,  // Red Signal Bits
				output[3:0] VGA_G,  // Green Signal Bits
				output[3:0] VGA_B,  // Blue Signal Bits
				inout ps2_clk,
				inout ps2_data);
	
	wire reset;
	assign reset = 1'b0;

	wire clock, clk_25;
	assign clock = clk_25;
	
	 clk_wiz_0 pll(
	      // Clock out ports
	      .clk_out1(clk_25),
	      // Status and control signals
	      .reset(1'b0),
	      .locked(locked),
	     // Clock in ports
	      .clk_in1(clk_100mhz)
	    );
	    
	wire [2:0] button;
	
	buttons b(.BTNU(BTNU), .BTNR(BTNR), .BTND(BTND), .BTNL(BTNL), .clk(clock), .button_reg(button));


	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut, dmemDataOut;


	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "score";
	
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(dmemDataOut));


	 assign memDataOut = (memAddr[11:0] == 0) ? button :
	                     (memAddr[11:0] == 7) ? random_x :
	                     (memAddr[11:0] == 8) ? random_y :
	                      dmemDataOut;

	 reg [3199:0] x_values_reg, y_values_reg;
	 wire [3199:0] x_values, y_values;
	 
	 initial begin
	       x_values_reg = -1;
	       y_values_reg = -1;
	 end
	
	assign x_values = x_values_reg;
	assign y_values = y_values_reg;

	always @(posedge clk_25) begin
	    if(memAddr[11:0] == 5 && mwe) begin
	       x_values_reg  = -1;
	       y_values_reg  = -1;
	    end
	
		if(memAddr[11:0] >= 300 && memAddr[11:0] <= 399 && mwe) begin
			x_values_reg[(memAddr[11:0] - 300) * 32 +: 32] = memDataIn;
		end

		if(memAddr[11:0] >= 400 && memAddr[11:0] <= 499 && mwe) begin
			y_values_reg[(memAddr[11:0] - 400) * 32 +: 32] = memDataIn;
		end
	end
	
	reg[31:0] random_x, random_y;
	initial begin
	   random_x = 5;
	   random_y = 5;
	end
	
	wire[3:0] rand_x_orig, rand_y_orig;
	
	
	LFSR random_gen(.clk(clk_25), .x(rand_x_orig), .y(rand_y_orig));
	
	always @(posedge clk_25 ) begin
	   random_x = {27'b0, rand_x_orig};
	   random_y = {27'b0, rand_y_orig};
	end
	
	


	 reg [31:0] game_done_reg;
	 wire [31:0] game_done;

	always @(posedge clk_25) begin
		if(game_done_reg != 32'd1) begin
			game_done_reg = (mwe && memAddr[11:0] == 1) ? memDataIn : 1'b0;
		end
	end

	assign game_done = game_done_reg;
	
	
	reg[31:0] food_x_reg, food_y_reg;
	wire[31:0] food_x, food_y;
	
	assign food_x  = food_x_reg;
	assign food_y  = food_y_reg;
	
	initial begin
	   food_x_reg = 5;
	   food_y_reg = 5;
	end
	
	always @(posedge clk_25) begin
	   if(memAddr[11:0] == 9 && mwe) begin
	       food_x_reg = memDataIn;
	   end
	   if(memAddr[11:0] == 10 && mwe) begin
	       food_y_reg = memDataIn;
	   end
	end


	reg[31:0] current_score_reg, high_score_reg;
	wire[31:0] current_score, high_score;
	
	assign current_score  = current_score_reg;
	assign high_score  = high_score_reg;
	
	initial begin
	   current_score_reg = 0;
	   high_score_reg = 0;
	end
	
	always @(posedge clk_25) begin
	   if(memAddr[11:0] == 14 && mwe) begin
	       current_score_reg = memDataIn;
	   end
	   if(memAddr[11:0] == 15 && mwe) begin
	       high_score_reg = memDataIn;
	   end
	end



	 VGAController control(.clk(clk_100mhz), .clk25(clk_25), .reset(reset), .x_values(x_values), .y_values(y_values), .food_x(food_x), .score(current_score), .high_score(high_score), .food_y(food_y), .game_done(game_done), .hSync(hSync), .vSync(vSync), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B), .ps2_clk(ps2_clk), .ps2_data(ps2_data));

	wire [31:0] led_bits;
	assign led_bits = rand_x_orig;

	wire led_we;
	//assign led_we = (mwe && memAddr[11:0] == 302) ? 1'b1 : 1'b0;
	assign led_we = 1'b1;


	led light(.leds(led_bits), .LED(LED), .clk(clk_25), .led_we(led_we));

endmodule
