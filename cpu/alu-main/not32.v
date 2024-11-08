module not32(Out, A);
    
    input [31:0] A;
    output [31:0] Out;

    xor flip0(Out[0], A[0], 1);
    xor flip1(Out[1], A[1], 1);
    xor flip2(Out[2], A[2], 1);
    xor flip3(Out[3], A[3], 1);
    xor flip4(Out[4], A[4], 1);
    xor flip5(Out[5], A[5], 1);
    xor flip6(Out[6], A[6], 1);
    xor flip7(Out[7], A[7], 1);
    xor flip8(Out[8], A[8], 1);
    xor flip9(Out[9], A[9], 1);
    xor flip10(Out[10], A[10], 1);
    xor flip11(Out[11], A[11], 1);
    xor flip12(Out[12], A[12], 1);
    xor flip13(Out[13], A[13], 1);
    xor flip14(Out[14], A[14], 1);
    xor flip15(Out[15], A[15], 1);
    xor flip16(Out[16], A[16], 1);
    xor flip17(Out[17], A[17], 1);
    xor flip18(Out[18], A[18], 1);
    xor flip19(Out[19], A[19], 1);
    xor flip20(Out[20], A[20], 1);
    xor flip21(Out[21], A[21], 1);
    xor flip22(Out[22], A[22], 1);
    xor flip23(Out[23], A[23], 1);
    xor flip24(Out[24], A[24], 1);
    xor flip25(Out[25], A[25], 1);
    xor flip26(Out[26], A[26], 1);
    xor flip27(Out[27], A[27], 1);
    xor flip28(Out[28], A[28], 1);
    xor flip29(Out[29], A[29], 1);
    xor flip30(Out[30], A[30], 1);
    xor flip31(Out[31], A[31], 1);
    
endmodule