module sll32(Out, A, shiftamt);
    
    input [31:0] A;
    input [4:0] shiftamt;
    output [31:0] Out;

    wire [31:0] stage1, stage2, stage3, stage4;

    assign stage1 = shiftamt[4] ? {A[15:0], 16'b0} : A;

    assign stage2 = shiftamt[3] ? {stage1[23:0], 8'b0} : stage1;

    assign stage3 = shiftamt[2] ? {stage2[27:0], 4'b0} : stage2;

    assign stage4 = shiftamt[1] ? {stage3[29:0], 2'b0} : stage3;

    assign Out = shiftamt[0] ? {stage4[30:0], 1'b0} : stage4;

endmodule
