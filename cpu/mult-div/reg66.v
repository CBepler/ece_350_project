module register66(out, d, clk, clr, enable);
    input[65:0] d;
    input clk, clr, enable;
    output[65:0] out;

    genvar i;

    generate
        for (i = 0; i < 66; i = i + 1) begin : dff_loop
            dffe_ref dff_instance(.q(out[i]), .d(d[i]), .clk(clk), .en(enable), .clr(clr));
        end
    endgenerate

endmodule