module eight_bit_adder(S, A, B, Cin, carry_bits);
    
    input Cin;
    input [7:0] A, B, carry_bits;
    output [7:0] S;

    xor xor1(S[0], A[0], B[0], Cin);
    xor xor2(S[1], A[1], B[1], carry_bits[0]);
    xor xor3(S[2], A[2], B[2], carry_bits[1]);
    xor xor4(S[3], A[3], B[3], carry_bits[2]);
    xor xor5(S[4], A[4], B[4], carry_bits[3]);
    xor xor6(S[5], A[5], B[5], carry_bits[4]);
    xor xor7(S[6], A[6], B[6], carry_bits[5]);
    xor xor8(S[7], A[7], B[7], carry_bits[6]);


    
endmodule