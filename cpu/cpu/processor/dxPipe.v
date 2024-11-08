module dxPipe(out1, out2, out3, out4, in1, in2, in3, in4, clk, clr);
    output[31:0] out1, out2, out3, out4;
    input[31:0] in1, in2, in3, in4;
    input clk, clr;
    register reg1(.out(out1), .d(in1), .clk(clk), .clr(clr), .read_enable(1'b1), .write_enable(1'b1));
    register reg2(.out(out2), .d(in2), .clk(clk), .clr(clr), .read_enable(1'b1), .write_enable(1'b1));
    register reg3(.out(out3), .d(in3), .clk(clk), .clr(clr), .read_enable(1'b1), .write_enable(1'b1));
    register reg4(.out(out4), .d(in4), .clk(clk), .clr(clr), .read_enable(1'b1), .write_enable(1'b1));
endmodule