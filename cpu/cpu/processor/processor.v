/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
    //Fetch
    wire[31:0] fetch_pc, pc_next, pc_plus_one, true_fetch;
    assign pc_next = reset ? 32'b0 : 
                    (mult_status || needStall) ? fetch_pc :
                    pc_plus_one;
    register pc(.out(fetch_pc), .d(pc_next), .clk(!clock), .clr(reset), .read_enable(1'b1), .write_enable(1'b1));
    wire overflow;
    assign true_fetch = (execute_opcode == 5'b00001 || execute_opcode == 5'b00011 || approved_bex) ? {5'b0, execute_instruction[26:0]} : //j and jal
                    ((execute_opcode == 5'b00100) && !needStall) ? execute_regA :
                    ((approved_blt || approved_bne) && !needStall) ? pc_plus_one_plus_N :
                    fetch_pc;

    thirty_two_bit_adder pc_add(.overflow(overflow), .S(pc_plus_one), .A(true_fetch), .B(32'd1), .Cin(1'b0));

    assign address_imem = true_fetch;

    //Decode
    wire[31:0] decode_pc, decode_instruction, decode_prev_instruction, rom_instruction;
    fdPipe fetchDecode(.out1(decode_pc), .out2(decode_prev_instruction), .out3(rom_instruction), .in1(pc_next), .in2(decode_instruction), .in3(q_imem), .clk(!clock), .clr(reset)); //multDiv stall works automatically with pc_next being stalled

    wire decode_stall, decode_stall_next;
    assign decode_stall_next = needStall ? 1'b1 : 1'b0;
    dffe_ref d_stall(.q(decode_stall), .d(decode_stall_next), .clk(!clock), .en(1'b1), .clr(1'b0));

    assign decode_instruction = fd_nops ? 32'd0 :
                                (((mult_status && mult_prev) || mult_ready) || decode_stall) ? decode_prev_instruction : rom_instruction;

    getReadRegs regs(.A(ctrl_readRegA), .B(ctrl_readRegB), .instruction(decode_instruction));

    //execute
    wire[31:0] dx_pc, dx_instruction, dx_regA, dx_regB;
    //Logic for stalling if multDiv is happening or needStall
    assign dx_pc = (mult_status || needStall) ? execute_pc : decode_pc;
    assign dx_instruction = (mult_status || needStall) ? execute_instruction : 
                            fd_nops ? 32'd0 :
                            decode_instruction;
    assign dx_regA = (mult_status || needStall) ? execute_regA : data_readRegA;
    assign dx_regB = (mult_status || needStall) ? execute_regB : data_readRegB;

    wire[31:0] execute_pc, execute_instruction, execute_regA, hold_execute_regA, execute_regB, hold_execute_regB;
    dxPipe decodeExecute(.out1(execute_pc), .out2(execute_instruction), .out3(hold_execute_regA), .out4(hold_execute_regB), .in1(dx_pc), .in2(dx_instruction), .in3(dx_regA), .in4(dx_regB), .clk(!clock), .clr(reset));

    //bypassing
    wire needStall;
    bypass b_a(.reg_outA(execute_regA), .reg_outB(execute_regB), .stall(needStall), .ex_instruction(execute_instruction), .m_instruction(memory_instruction), .w_instruction(writeback_instruction), .hold_regA(hold_execute_regA), .hold_regB(hold_execute_regB), .m_reg_data(memory_alu_output), .w_reg_data(data_writeReg));
    // assign needStall = 1'b0;
    // assign execute_regA = hold_execute_regA;
    // assign execute_regB = hold_execute_regB;

    wire[4:0] aluOpcode;
    assign aluOpcode = (execute_instruction[31:27] == 5'b00000) ? execute_instruction[6:2] : 
                        ((execute_instruction[31:27] == 5'b00010) || (execute_instruction[31:27] == 5'b00110) || (execute_instruction[31:27] == 5'b10110)) ? 5'b00001 : //sub for bne or blt
                        5'b00000;
    wire mult_ready, mult_status, mult_prev;
    assign mult_status = (mult_ready || needStall) ? 1'b0 : ((aluOpcode == 5'b00110 || aluOpcode == 5'b00111) ? 1 : 1'b0);
    dffe_ref mult_check(.q(mult_prev), .d(mult_status), .clk(!clock), .en(1'b1), .clr(1'b0));

    wire[31:0] extended_immediate;
    extend_immediate extender(.extended_immediate(extended_immediate), .instruction(execute_instruction));

    wire[4:0] execute_opcode;
    assign execute_opcode = execute_instruction[31:27];

    wire isIType;
    isImmediate i(.isI(isIType), .opcode(execute_opcode));

    wire[31:0] data_operandB, data_operandA;
    assign data_operandB = (isIType) ? extended_immediate :
                            ((execute_opcode == 5'b00011 || execute_opcode == 5'b10101 || execute_opcode == 5'b10110) ? 32'd0 : execute_regB);
    assign data_operandA = (execute_opcode == 5'b00011) ? execute_pc :
                      (execute_opcode == 5'b10101) ? {5'b0, execute_instruction[26:0]} : execute_regA;

    wire[31:0] data_result;
    wire isNotEqual, isLessThan, ex_overflow, data_exception;
    aluWrapper unit(.data_operandA(data_operandA), .data_operandB(data_operandB), .ctrl_ALUopcode(aluOpcode), .ctrl_shiftamt(execute_instruction[11:7]), .clk(clock), .multDivPrev(mult_prev), .data_result(data_result), .isNotEqual(isNotEqual), .isLessThan(isLessThan), .overflow(ex_overflow), .data_exception(data_exception), .data_resultRDY(mult_ready));
	
    wire approved_blt, approved_bne, approved_bex;
    assign approved_bex = (execute_opcode == 5'b10110 && isNotEqual) ? 1'b1 : 1'b0;
    assign approved_blt = (execute_opcode == 5'b00110 && isLessThan) ? 1'b1 : 1'b0;
    assign approved_bne = (execute_opcode == 5'b00010 && isNotEqual) ? 1'b1 : 1'b0;
    //lessThan l(.out(branch_less_than), .A(execute_regA), .B(execute_regB));

    wire[31:0] pc_plus_one_plus_N;
    wire branch_overflow;
    thirty_two_bit_adder pc_branch(.overflow(branch_overflow), .S(pc_plus_one_plus_N), .A(execute_pc), .B(extended_immediate), .Cin(1'b0));

    wire fd_nops;
    assign fd_nops = (execute_opcode == 5'b00001 || execute_opcode == 5'b00011 || (execute_opcode == 5'b00100 && !needStall) || ((approved_blt || approved_bne || approved_bex) && !needStall)) ? 1'b1 : 1'b0;

    wire [14:0] exception_instruction;
    assign exception_instruction = 15'b001011111000000; //addi $30, $0, (add on immediate)

    wire[31:0] xm_dataResult, xm_regB, xm_instruction; //all 0 instruction : $r0 = $r0 + $r0  -> nop
    wire xm_exception, xm_overflow;
    //overwrite input to next stage to nop if multDiv is going
    assign xm_dataResult = (mult_status || needStall) ? 32'b0 : 
                            (ex_overflow && execute_opcode == 5'b00000 && execute_instruction[6:2] == 5'b00000) ? 32'd1 :
                            (ex_overflow && execute_opcode == 5'b00101) ? 32'd2 :
                            (ex_overflow && execute_opcode == 5'b00000 && execute_instruction[6:2] == 5'b00001) ? 32'd3 :
                            (data_exception && execute_opcode == 5'b00000 && execute_instruction[6:2] == 5'b00110) ? 32'd4 :
                            (data_exception && execute_opcode == 5'b00000 && execute_instruction[6:2] == 5'b00111) ? 32'd5:
                            data_result;
    assign xm_regB = (mult_status || needStall) ? 32'b0 : execute_regB;
    assign xm_instruction = (mult_status || needStall) ? 32'b0 : 
                            (ex_overflow && execute_opcode == 5'b00000 && execute_instruction[6:2] == 5'b00000) ? {exception_instruction, 17'd1} :
                            (ex_overflow && execute_opcode == 5'b00101) ? {exception_instruction, 17'd2} :
                            (ex_overflow && execute_opcode == 5'b00000 && execute_instruction[6:2] == 5'b00001) ? {exception_instruction, 17'd3} :
                            (data_exception && execute_opcode == 5'b00000 && execute_instruction[6:2] == 5'b00110) ? {exception_instruction, 17'd4} :
                            (data_exception && execute_opcode == 5'b00000 && execute_instruction[6:2] == 5'b00111) ? {exception_instruction, 17'd5} :
                            execute_instruction;
    assign xm_exception = (mult_status || needStall) ? 1'b0 : data_exception;
    assign xm_overflow = (mult_status || needStall) ? 1'b0 : ex_overflow;

    //Memory
    wire[31:0] memory_alu_output, data_regB, memory_instruction;
    wire memory_exception, memory_overflow;
    xmPipe executeMemory(.out1(memory_alu_output), .out2(data_regB), .out3(memory_instruction), .exception_out(memory_exception), .overflow_out(memory_overflow), .in1(xm_dataResult), .in2(xm_regB), .in3(xm_instruction), .exception_in(xm_exception), .overflow_in(xm_overflow), .clk(!clock), .clr(reset));

    wire[4:0] memory_opcode;
    assign memory_opcode = memory_instruction[31:27];

    assign address_dmem = memory_alu_output; 
    memBypass m_b(.d(data), .m_instruction(memory_instruction), .w_instruction(writeback_instruction), .hold_data(data_regB), .w_reg_data(data_writeReg));
    //assign data = data_regB;
    assign wren = (memory_opcode == 5'b00111) ? 1'b1 : 1'b0;


    //Writeback

    wire[31:0] writeback_alu_output, writeback_instruction, mem_data;
    wire writeback_exception, writeback_overflow;
    mwPipe memoryWriteback(.out1(writeback_alu_output), .out2(writeback_instruction), .out3(mem_data), .exception_out(writeback_exception), .overflow_out(writeback_overflow), .in1(memory_alu_output), .in2(memory_instruction), .in3(q_dmem), .exception_in(memory_exception), .overflow_in(memory_overflow), .clk(!clock), .clr(reset));

    wire[4:0] writeback_opcode;
    assign writeback_opcode = writeback_instruction[31:27];

    wire [31:0] write_before_exception;
    assign data_writeReg = (writeback_opcode == 5'b01000) ? mem_data : //lw
                                    (writeback_opcode == 5'b00000 || writeback_opcode == 5'b00101 || writeback_opcode == 5'b00011 || writeback_opcode == 5'b10101) ? writeback_alu_output : //R-type, addi, jal, setx
                                    32'b0;
    
    // wire add_overflow, addi_overflow, sub_overflow, mult_overflow, div_exception;
    // assign add_overflow = (writeback_overflow && writeback_opcode == 5'b00000 && writeback_instruction[6:2] == 5'b00000);
    // assign addi_overflow = (writeback_overflow && writeback_opcode == 5'b00101);
    // assign sub_overflow = (writeback_overflow && writeback_opcode == 5'b00000 && writeback_instruction[6:2] == 5'b00001);
    // assign mult_overflow = (writeback_exception && writeback_opcode == 5'b00000 && writeback_instruction[6:2] == 5'b00110);
    // assign div_exception = (writeback_exception && writeback_opcode == 5'b00000 && writeback_instruction[6:2] == 5'b00111);

    // assign data_writeReg = add_overflow ? 32'd1 : //add exception
    //                        addi_overflow ? 32'd2 : //addi exception
    //                        sub_overflow ? 32'd3 : //sub exception
    //                        mult_overflow ? 32'd4 : //mul exception
    //                        div_exception ? 32'd5 : //div exception
    //                        write_before_exception; //no exception

    assign ctrl_writeEnable = (writeback_opcode == 5'b00111 ||
                                writeback_opcode == 5'b00001 ||
                                writeback_opcode == 5'b00010 ||
                                writeback_opcode == 5'b00100 ||
                                writeback_opcode == 5'b00110 ||
                                writeback_opcode == 5'b10110) ? 1'b0 : 1'b1;

    assign ctrl_writeReg = (writeback_opcode == 5'b00000 || writeback_opcode == 5'b00101 || writeback_opcode == 5'b01000) ? writeback_instruction[26:22] :
                           (writeback_opcode == 5'b00011) ? 5'd31 :
                           (writeback_opcode == 5'b10101) ? 5'd30 :
                           5'd0;

	/* END CODE */

endmodule
