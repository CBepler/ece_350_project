module d_latch (q, d, clk);
    input d, clk;
    output q;

    wire n1, n2, n3;

    nand nand1(n1, d, clk);
    nand nand2(n2, n1, clk);
    nand nand3(n3, n2, q);
    nand nand4(q, n3, n1);

endmodule
