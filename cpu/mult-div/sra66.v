module sra66(Out, A, shiftamt);
    
    input [65:0] A;
    input [5:0] shiftamt;
    output [65:0] Out;

    wire [65:0] stage1, stage2, stage3, stage4, stage5;

    assign stage1 = shiftamt[5] ? {{32{A[65]}}, A[65:32]} : A;

    assign stage2 = shiftamt[4] ? {{16{A[65]}}, stage1[65:16]} : stage1;

    assign stage3 = shiftamt[3] ? {{8{A[65]}}, stage2[65:8]} : stage2;

    assign stage4 = shiftamt[2] ? {{4{A[65]}}, stage3[65:4]} : stage3;

    assign stage5 = shiftamt[1] ? {{2{A[65]}}, stage4[65:2]} : stage4;

    assign Out = shiftamt[0] ? {{1{A[65]}}, stage5[65:1]} : stage5;

endmodule