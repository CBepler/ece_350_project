module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	// add your code here

	wire [31:0] read_enable1, read_enable2, write_enable;
	wire [31:0] out [0:31];

	decoder r1_decode(read_enable1, ctrl_readRegA);
	decoder r2_decode(read_enable2, ctrl_readRegB);
	decoder w_decode(write_enable, ctrl_writeReg);

	wire [31:0] write_enable_gated;
	and32 w_and(write_enable_gated, write_enable, {32{ctrl_writeEnable}});


	//wire [31:0] combined_read_enable;
	//or32 r_or(combined_read_enable, read_enable1, read_enable2);

	assign out[0] = 32'b0;
	assign data_readRegA = read_enable1[0] ? out[0] : 32'bz;
	assign data_readRegB = read_enable2[0] ? out[0] : 32'bz;

    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin : reg_loop
            register reg_instance(out[i], data_writeReg, clock, ctrl_reset, 1'b1, write_enable_gated[i]);
            
            assign data_readRegA = read_enable1[i] ? out[i] : 32'bz;
            assign data_readRegB = read_enable2[i] ? out[i] : 32'bz;
        end
    endgenerate
endmodule
