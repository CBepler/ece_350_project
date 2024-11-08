module register(out, d, clk, clr, read_enable, write_enable);
    input[31:0] d;
    input clk, clr, read_enable, write_enable;
    output[31:0] out;

    genvar i;

    generate
        for (i = 0; i < 32; i = i + 1) begin : dff_loop
            dffe_ref a_dff(.q(out), .d(d), .clk(clk), .en(write_enable), .clr(clr));
        end
    endgenerate

endmodule