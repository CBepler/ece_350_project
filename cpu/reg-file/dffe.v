module dffe(q, d, clk, clrn, ena);
    input d;
    input clk, clrn, ena;
    output q;

    wire nclk;
    not n_clk(nclk, clk);

    wire q1;
    d_latch d1(q1, d, nclk);

    wire data2;
    assign data2 = clrn ? (ena ? (q1) : q) : 0;
    d_latch d2(q, data2, clk);
endmodule