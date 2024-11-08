module extend_immediate(extended_immediate, instruction);
    input[31:0] instruction;
    output[31:0] extended_immediate;

    wire[4:0] opcode;
    assign opcode = instruction[31:27];

    wire isIType;
    isImmediate i(.isI(isIType), .opcode(opcode));

    assign extended_immediate = (
            (isIType || (opcode == 5'b00010 || opcode == 5'b00110)) ? {{15{instruction[16]}}, instruction[16:0]} :
            (((opcode == 5'b00001) || //JI-types
            (opcode == 5'b00011) ||
            (opcode == 5'b10110) ||
            (opcode == 5'b10101)) ? {5'b0, instruction[26:0]} : 32'd0));
endmodule