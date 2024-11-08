module getReadRegs(A, B, instruction);
    output[4:0] A, B;
    input[31:0] instruction;

    wire[4:0] opcode;
    assign opcode = instruction[31:27];

    wire isIType;
    isImmediate i(.isI(isIType), .opcode(opcode));

    assign A = (opcode == 5'b00000 ? instruction[21:17] :
                isIType ? instruction[21:17] :
                ((opcode == 5'b00100) || (opcode == 5'b00010) || (opcode == 5'b00110)) ? instruction[26:22] : //jr, blt, bne get $rd
                (opcode == 5'b10110) ? 5'd30 : 5'd0);

    assign B = (opcode == 5'b00000 ? instruction[16:12] : 
                (opcode == 5'b00111 ? instruction[26:22] : //sw
                ((opcode == 5'b00010) || (opcode == 5'b00110) ? instruction[21:17] : //blt, bne need $rs
                5'd0)));
endmodule