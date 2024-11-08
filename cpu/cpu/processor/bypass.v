module bypass(reg_outA, reg_outB, stall, ex_instruction, m_instruction, w_instruction, hold_regA, hold_regB, m_reg_data, w_reg_data);
    output[31:0] reg_outA, reg_outB;
    output stall;
    input[31:0] ex_instruction, m_instruction, w_instruction, hold_regA, hold_regB, m_reg_data, w_reg_data;

    wire[4:0] m_changed_reg, w_changed_reg;
    //getChangedReg will return the number of the register that has or will be changed by the instruction provided
    getChangedReg mem_R(.register(m_changed_reg), .instruction(m_instruction)); //returns register 0 if nothing has been changed
    getChangedReg wBack_R(.register(w_changed_reg), .instruction(w_instruction));

    wire[4:0] regA_num, regB_num;
    //Get registers that this stage needs the correct values for
    getReadRegs regs(.A(regA_num), .B(regB_num), .instruction(ex_instruction));

    wire[4:0] ex_opcode, m_opcode, w_opcode;
    assign ex_opcode = ex_instruction[31:27];
    assign m_opcode = m_instruction[31:27];
    assign w_opcode = w_instruction[31:27];

    assign stall = ((m_changed_reg == regA_num || m_changed_reg == regB_num) && (m_opcode == 5'b01000) && (ex_opcode != 5'b00111 || m_changed_reg == regA_num)) ? 1'b1 : 1'b0;

    assign reg_outA =   (regA_num == 5'b0) ? 32'b0 :
                        ((m_changed_reg == regA_num) && ((m_opcode == 5'b00000) || (m_opcode == 5'b00101)) || 
                        ((5'd31 == regA_num) && (m_opcode == 5'b00011)) ||
                        ((5'd30 == regA_num) && (m_opcode == 5'b10101))) ? m_reg_data :
                        ((w_changed_reg == regA_num) && ((w_opcode == 5'b00000) || (w_opcode == 5'b00101) || (w_opcode == 5'b01000)) || 
                        ((5'd31 == regA_num) && (w_opcode == 5'b00011)) ||
                        ((5'd30 == regA_num) && (w_opcode == 5'b10101))) ? w_reg_data :
                        hold_regA;
    
    assign reg_outB = (regB_num == 5'b0) ? 32'b0 :
                    ((m_changed_reg == regB_num) && ((m_opcode == 5'b00000) || (m_opcode == 5'b00101)) || 
                    ((5'd31 == regB_num) && (m_opcode == 5'b00011)) ||
                    ((5'd30 == regB_num) && (m_opcode == 5'b10101))) ? m_reg_data :
                    ((w_changed_reg == regB_num) && ((w_opcode == 5'b00000) || (w_opcode == 5'b00101) || (w_opcode == 5'b01000)) || 
                    ((5'd31 == regB_num) && (w_opcode == 5'b00011)) ||
                    ((5'd30 == regB_num) && (w_opcode == 5'b10101))) ? w_reg_data :
                    hold_regB;


endmodule