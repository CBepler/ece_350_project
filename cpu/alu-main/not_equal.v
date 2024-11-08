module not_equal(out, sub_result);
    input[31:0] sub_result;
    output out;

    wire p1, p2, p3, p4;

    or or1(p1, sub_result[0], sub_result[1], sub_result[2], sub_result[3], sub_result[4], sub_result[5], sub_result[6], sub_result[7]);
    or or2(p2, sub_result[8], sub_result[9], sub_result[10], sub_result[11], sub_result[12], sub_result[13], sub_result[14], sub_result[15]);
    or or3(p3, sub_result[16], sub_result[17], sub_result[18], sub_result[19], sub_result[20], sub_result[21], sub_result[22], sub_result[23]);
    or or4(p4, sub_result[24], sub_result[25], sub_result[26], sub_result[27], sub_result[28], sub_result[29], sub_result[30], sub_result[31]);

    or or5(out, p1, p2, p3, p4);
endmodule