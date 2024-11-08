module isImmediate(isI, opcode); //does not include bne or blt
    input[4:0] opcode;
    output isI;

    assign isI = ((opcode == 5'b00101) ||
                (opcode == 5'b00111) ||
                (opcode == 5'b01000)) ? 1'b1 : 1'b0;
endmodule