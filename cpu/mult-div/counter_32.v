module counter_32(out, clk, ena, clrn);
    input clk, ena, clrn;
    output[4:0] out;

    wire q1, t2, q2, t3, q3, t4, q4, t5, q5;
    tff tff1(q1, ena, clk, clrn, ena);

    and a1(t2, q1, ena);
    tff tff2(q2, t2, clk, clrn, ena);

    and a2(t3, q2, t2);
    tff tff3(q3, t3, clk, clrn, ena);

    and a3(t4, t3, q3);
    tff tff4(q4, t4, clk, clrn, ena);

    and a4(t5, t4, q4);
    tff tff5(q5, t5, clk, clrn, ena);

    assign out[0] = q1;
    assign out[1] = q2;
    assign out[2] = q3;
    assign out[3] = q4;
    assign out[4] = q5;
endmodule