module or32_tb;
    reg [31:0] A, B;
    wire [31:0] Out;

    or32 or_test(Out, A, B);

    reg [31:0] expected_Out;

    reg [95:0] test_cases[19:0];
    integer i;

    initial begin
        test_cases[0]  = {32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF}; // A=all 1s, B=all 1s => Out=all 1s
        test_cases[1]  = {32'hAAAAAAAA, 32'h55555555, 32'hFFFFFFFF}; // A=1010..., B=0101... => Out=all 1s
        test_cases[2]  = {32'h00000000, 32'hFFFFFFFF, 32'hFFFFFFFF}; // A=all 0s, B=all 1s => Out=all 1s
        test_cases[3]  = {32'h12345678, 32'h87654321, 32'h97755779};
        test_cases[4]  = {32'hFFFFFFFF, 32'h00000000, 32'hFFFFFFFF}; // A=all 1s, B=all 0s => Out=all 1s
        test_cases[5]  = {32'hFFFFFFFF, 32'hAAAAAAAA, 32'hFFFFFFFF}; // A=all 1s, B=alternating 1010... => Out=all 1s
        test_cases[6]  = {32'h0000FFFF, 32'hFFFF0000, 32'hFFFFFFFF}; // A=lower 16 bits 1, B=upper 16 bits 1 => Out=all 1s
        test_cases[7]  = {32'h12345678, 32'hFFFFFFFF, 32'hFFFFFFFF}; // A=12345678, B=all 1s => Out=all 1s
        test_cases[8]  = {32'h80000000, 32'h7FFFFFFF, 32'hFFFFFFFF}; // A=most significant bit 1, B=all but most significant bit 1 => Out=all 1s
        test_cases[9]  = {32'h11111111, 32'h11111111, 32'h11111111}; // A=11111111, B=11111111 => Out=11111111
        test_cases[10] = {32'hFFFFFFFF, 32'h88888888, 32'hFFFFFFFF}; // A=all 1s, B=some bits set => Out=all 1s
        test_cases[11] = {32'h00FF00FF, 32'hFF00FF00, 32'hFFFFFFFF}; // A=00FF00FF, B=FF00FF00 => Out=all 1s
        test_cases[12] = {32'hAAAAAAAA, 32'hFFFFFFFF, 32'hFFFFFFFF}; // A=alternating 1010..., B=all 1s => Out=all 1s
        test_cases[13] = {32'h55555555, 32'hAAAAAAAA, 32'hFFFFFFFF}; // A=0101..., B=1010... => Out=all 1s
        test_cases[14] = {32'h01234567, 32'h89ABCDEF, 32'h89ABCDEF}; // A=01234567, B=89ABCDEF => Out=89ABCDEF
        test_cases[15] = {32'hFFFFFFFF, 32'h0000FFFF, 32'hFFFFFFFF}; // A=all 1s, B=lower 16 bits 1 => Out=all 1s
        test_cases[16] = {32'hF0F0F0F0, 32'h0F0F0F0F, 32'hFFFFFFFF}; // A=F0F0F0F0, B=0F0F0F0F => Out=all 1s
        test_cases[17] = {32'h12345678, 32'h87654321, 32'h97755779};
        test_cases[18] = {32'hFEDCBA98, 32'h76543210, 32'hFEDCBA98}; // A=FEDCBA98, B=76543210 => Out=FEDCBA98
        test_cases[19] = {32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF}; // A=all 1s, B=all 1s => Out=all 1s (again)

        for(i = 0; i < 20; i = i + 1) begin
            {A, B, expected_Out} = test_cases[i];

            #20;
            if (Out === expected_Out)
                $display("Test %d PASSED: A:%b, B:%b => Out:%b", i, A, B, Out);
            else
                $display("Test %d FAILED: A:%b, B:%b => Out:%b (expected %b)", 
                          i, A, B, Out, expected_Out);
        end

        $finish;
    end

    initial begin
        $dumpfile("or32.vcd");
        $dumpvars(0, or32_tb);
    end
endmodule
