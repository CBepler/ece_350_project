module mwPipe(out1, out2, out3, exception_out, overflow_out, in1, in2, in3, exception_in, overflow_in, clk, clr);
    output[31:0] out1, out2, out3;
    output exception_out, overflow_out;
    input[31:0] in1, in2, in3;
    input clk, clr, exception_in, overflow_in;
    register reg1(.out(out1), .d(in1), .clk(clk), .clr(clr), .read_enable(1'b1), .write_enable(1'b1));
    register reg2(.out(out2), .d(in2), .clk(clk), .clr(clr), .read_enable(1'b1), .write_enable(1'b1));
    register reg3(.out(out3), .d(in3), .clk(clk), .clr(clr), .read_enable(1'b1), .write_enable(1'b1));
    dffe_ref overflow(.q(overflow_out), .d(overflow_in), .clk(clk), .en(1'b1), .clr(clr));
    dffe_ref exception(.q(exception_out), .d(exception_in), .clk(clk), .en(1'b1), .clr(clr));
endmodule