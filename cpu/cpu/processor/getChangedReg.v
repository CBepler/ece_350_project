module getChangedReg(register, instruction);
    input[31:0] instruction;
    output[4:0] register;

    wire[4:0] opcode;

    assign opcode = instruction[31:27];

    assign register = (opcode == 5'b00000 || opcode == 5'b00101 || opcode == 5'b01000) ? instruction[26:22] :
                      (opcode == 5'b00011) ? 5'd31 :
                      (opcode == 5'b10101) ? 5'd30 :
                      5'd0;
endmodule