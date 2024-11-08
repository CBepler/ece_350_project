module aluWrapper(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, clk, multDivPrev, data_result, isNotEqual, isLessThan, overflow, data_exception, data_resultRDY);
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
    input clk, multDivPrev;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow, data_exception, data_resultRDY;

    wire ctrl_MULT, ctrl_DIV;
    assign ctrl_MULT = (!multDivPrev) ? 1'b1 : 1'b0; //Set ctrl_MULT for all cycles that aren't actually doing multDiv so that data_RDY from multDiv will never hit a false posotive
    assign ctrl_DIV = (ctrl_ALUopcode == 5'b00111 && !multDivPrev) ? 1'b1 : 1'b0;

    wire[31:0] aluOut, multdivOut;
    alu a(.data_operandA(data_operandA), .data_operandB(data_operandB), .ctrl_ALUopcode(ctrl_ALUopcode), .ctrl_shiftamt(ctrl_shiftamt), .data_result(aluOut), .isNotEqual(isNotEqual), .isLessThan(isLessThan), .overflow(overflow));

    multdiv m(.data_operandA(data_operandA), .data_operandB(data_operandB), .ctrl_MULT(ctrl_MULT), .ctrl_DIV(ctrl_DIV), .clock(clk), .data_result(multdivOut), .data_exception(data_exception), .data_resultRDY(data_resultRDY));

    assign data_result = data_resultRDY ? multdivOut : aluOut;
endmodule