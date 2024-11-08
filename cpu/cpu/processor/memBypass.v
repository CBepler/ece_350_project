module memBypass(d, m_instruction, w_instruction, hold_data, w_reg_data);
    output[31:0] d;
    input[31:0] m_instruction, w_instruction, hold_data, w_reg_data;

    wire[4:0] w_changed_reg;
    //getChangedReg will return the number of the register that has or will be changed by the instruction provided
    getChangedReg wBack_R(.register(w_changed_reg), .instruction(w_instruction));

    wire[4:0] regA_num, regB_num;
    //Get registers that this stage needs the correct values for
    getReadRegs regs(.A(regA_num), .B(regB_num), .instruction(m_instruction));

    wire[4:0] m_opcode, w_opcode;
    assign m_opcode = m_instruction[31:27];
    assign w_opcode = w_instruction[31:27];
    
    assign d = (w_changed_reg == regB_num) && ((w_opcode == 5'b01000))  ? w_reg_data : hold_data;
endmodule