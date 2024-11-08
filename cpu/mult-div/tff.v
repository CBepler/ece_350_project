module tff(Q, T, clk, clrn, ena);
    input T, clk, clrn, ena;
    output Q;

    wire a1, a2;
    and and_1(a1, Q, ~T);
    and and_2(a2, ~Q, T);

    wire d;
    or or_1(d, a1, a2);

    dffe_ref dff(Q, d, clk, ena, ~clrn);
endmodule