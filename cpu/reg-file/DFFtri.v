module DFFtri(out, d, clk, clr, in_enable, out_enable);
    input d, clk, clr, pr, in_enable, out_enable;
    output out;
    wire q;

    dffe_ref a_dff(.q(q), .d(d), .clk(clk), .en(in_enable), .clr(clr));

    assign out = out_enable ? q : 1'bz;
endmodule