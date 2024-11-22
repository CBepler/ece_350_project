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
 				input reset,
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

	wire clock;
	assign clock = clk_29;
	
	 clk_wiz_0 pll(
	      // Clock out ports
	      .clk_out1(clk_29),
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
	localparam INSTR_FILE = "basic_box_movement";
	
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


	 assign memDataOut = (memAddr[11:0] == 0) ? button : dmemDataOut; 

	 reg [31:0] x_values_reg, y_values_reg;
	 wire [31:0] x_values, y_values;
	
	assign x_values = x_values_reg;
	assign y_values = y_values_reg;

	always @(posedge clk_29) begin
		if(memAddr[11:0] == 300 && mwe) begin
			x_values_reg = memDataIn;
		end

		if(memAddr[11:0] == 400 && mwe) begin
			y_values_reg = memDataIn;
		end
	end
	
	
	


	 reg [31:0] game_done_reg;
	 wire [31:0] game_done;

	always @(posedge clk_29) begin
		if(game_done_reg != 32'd1) begin
			game_done_reg = (mwe && memAddr[11:0] == 1) ? memDataIn : 1'b0;
		end
	end

	assign game_done = game_done_reg;



	 VGAController control(.clk(clk_100mhz), .reset(reset), .x_values(x_values), .y_values(y_values), .game_done(game_done), .hSync(hSync), .vSync(vSync), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B), .ps2_clk(ps2_clk), .ps2_data(ps2_data));

	//  wire [31:0] led_bits;
	//  assign led_bits = memDataIn;

	//  wire led_we;
	//  assign led_we = (mwe && memAddr[11:0] == 1) ? 1'b1 : 1'b0;


	//  led light(.leds(led_bits), .LED(LED), .clk(clk_29), .led_we(led_we));

endmodule
