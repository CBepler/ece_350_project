module thirty_two_bit_adder(overflow, S, A, B, Cin);
    
    input Cin;
    input [31:0] A, B;
    output [31:0] S;
    output overflow;

    wire [7:0] first_carry;
    carry f_carry(first_carry, A[7:0], B[7:0], Cin);
    eight_bit_adder first(S[7:0], A[7:0], B[7:0], Cin, first_carry);

    wire first_big_carry;
    big_carry f_big_carry(first_big_carry, A[7:0], B[7:0], Cin);
    wire[7:0] second_carry;
    carry s_carry(second_carry, A[15:8], B[15:8], first_big_carry);
    eight_bit_adder second(S[15:8], A[15:8], B[15:8], first_big_carry, second_carry);

    wire second_big_carry;
    big_carry s_big_carry(second_big_carry, A[15:8], B[15:8], first_big_carry);
    wire[7:0] third_carry;
    carry t_carry(third_carry, A[23:16], B[23:16], second_big_carry);
    eight_bit_adder third(S[23:16], A[23:16], B[23:16], second_big_carry, third_carry);

    wire third_big_carry;
    big_carry t_big_carry(third_big_carry, A[23:16], B[23:16], second_big_carry);
    wire[7:0] fourth_carry;
    carry fo_carry(fourth_carry, A[31:24], B[31:24], third_big_carry);
    eight_bit_adder fourth(S[31:24], A[31:24], B[31:24], third_big_carry, fourth_carry);

    xor overflow_check(overflow, fourth_carry[7], fourth_carry[6]);


    
endmodule