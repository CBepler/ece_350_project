module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    // add your code here:

    wire [31:0] add_result, sub_result, and_result, or_result, sll_result, sra_result;
    wire add_overflow, sub_overflow;

    thirty_two_bit_adder add_module(add_overflow, add_result, data_operandA, data_operandB, 1'b0);

    wire[31:0] notB;
    not32 n_B(notB, data_operandB);
    thirty_two_bit_adder sub_module(sub_overflow, sub_result, data_operandA, notB, 1'b1);

    and32 and_module(and_result, data_operandA, data_operandB);

    or32 or_module(or_result, data_operandA, data_operandB);

    sll32 sll_module(sll_result, data_operandA, ctrl_shiftamt);

    sra32 sra_module(sra_result, data_operandA, ctrl_shiftamt);

    wire[31:0] invalid_opcode;

    mux_32 result_mux(data_result, ctrl_ALUopcode, add_result, sub_result, and_result, or_result, sll_result, sra_result, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode);

    wire [31:0] overflow_out, sub_overflow_big, add_overflow_big;
    assign add_overflow_big[0] = add_overflow;
    assign sub_overflow_big[0] = sub_overflow;
    mux_32 overflow_mux(overflow_out, ctrl_ALUopcode, add_overflow_big, sub_overflow_big, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode, invalid_opcode);
    assign overflow = overflow_out[0];

    not_equal check_equality(isNotEqual, sub_result);

    wire subFlip;
    xor flipSub(subFlip, sub_result[31], 1);
    assign isLessThan = overflow ? subFlip : sub_result[31];


endmodule