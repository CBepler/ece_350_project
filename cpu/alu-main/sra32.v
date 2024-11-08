module sra32(Out, A, shiftamt);
    
    input [31:0] A;
    input [4:0] shiftamt;
    output [31:0] Out;

    wire [31:0] stage1, stage2, stage3, stage4;

    assign stage1 = shiftamt[4] ? {{16{A[31]}}, A[31:16]} : A;

    assign stage2 = shiftamt[3] ? {{8{A[31]}}, stage1[31:8]} : stage1;

    assign stage3 = shiftamt[2] ? {{4{A[31]}}, stage2[31:4]} : stage2;

    assign stage4 = shiftamt[1] ? {{2{A[31]}}, stage3[31:2]} : stage3;

    assign Out = shiftamt[0] ? {{1{A[31]}}, stage4[31:1]} : stage4;

endmodule
