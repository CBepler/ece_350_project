module decoder(out, in);
    input [4:0] in;
    output [31:0] out;

    wire [4:0] n_in;

    not n0(n_in[0], in[0]);
    not n1(n_in[1], in[1]);
    not n2(n_in[2], in[2]);
    not n3(n_in[3], in[3]);
    not n4(n_in[4], in[4]);

    wire [31:0] temp;

    and and0(temp[0], n_in[4], n_in[3], n_in[2], n_in[1], n_in[0]);
    and and1(temp[1], n_in[4], n_in[3], n_in[2], n_in[1], in[0]);
    and and2(temp[2], n_in[4], n_in[3], n_in[2], in[1], n_in[0]);
    and and3(temp[3], n_in[4], n_in[3], n_in[2], in[1], in[0]);
    and and4(temp[4], n_in[4], n_in[3], in[2], n_in[1], n_in[0]);
    and and5(temp[5], n_in[4], n_in[3], in[2], n_in[1], in[0]);
    and and6(temp[6], n_in[4], n_in[3], in[2], in[1], n_in[0]);
    and and7(temp[7], n_in[4], n_in[3], in[2], in[1], in[0]);
    and and8(temp[8], n_in[4], in[3], n_in[2], n_in[1], n_in[0]);
    and and9(temp[9], n_in[4], in[3], n_in[2], n_in[1], in[0]);
    and and10(temp[10], n_in[4], in[3], n_in[2], in[1], n_in[0]);
    and and11(temp[11], n_in[4], in[3], n_in[2], in[1], in[0]);
    and and12(temp[12], n_in[4], in[3], in[2], n_in[1], n_in[0]);
    and and13(temp[13], n_in[4], in[3], in[2], n_in[1], in[0]);
    and and14(temp[14], n_in[4], in[3], in[2], in[1], n_in[0]);
    and and15(temp[15], n_in[4], in[3], in[2], in[1], in[0]);
    and and16(temp[16], in[4], n_in[3], n_in[2], n_in[1], n_in[0]);
    and and17(temp[17], in[4], n_in[3], n_in[2], n_in[1], in[0]);
    and and18(temp[18], in[4], n_in[3], n_in[2], in[1], n_in[0]);
    and and19(temp[19], in[4], n_in[3], n_in[2], in[1], in[0]);
    and and20(temp[20], in[4], n_in[3], in[2], n_in[1], n_in[0]);
    and and21(temp[21], in[4], n_in[3], in[2], n_in[1], in[0]);
    and and22(temp[22], in[4], n_in[3], in[2], in[1], n_in[0]);
    and and23(temp[23], in[4], n_in[3], in[2], in[1], in[0]);
    and and24(temp[24], in[4], in[3], n_in[2], n_in[1], n_in[0]);
    and and25(temp[25], in[4], in[3], n_in[2], n_in[1], in[0]);
    and and26(temp[26], in[4], in[3], n_in[2], in[1], n_in[0]);
    and and27(temp[27], in[4], in[3], n_in[2], in[1], in[0]);
    and and28(temp[28], in[4], in[3], in[2], n_in[1], n_in[0]);
    and and29(temp[29], in[4], in[3], in[2], n_in[1], in[0]);
    and and30(temp[30], in[4], in[3], in[2], in[1], n_in[0]);
    and and31(temp[31], in[4], in[3], in[2], in[1], in[0]);

    assign out = temp;

endmodule
