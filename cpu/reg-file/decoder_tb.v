module decoder_tb;

    reg [4:0] in;
    wire [31:0] out;

    decoder test_decoder (out, in);

    initial begin
        for (integer i = 0; i < 32; i = i + 1) begin
            in = i;
            #10;
            $display("Input: %0d, Output: %b", in, out);
        end

        $finish; 
    end

endmodule
