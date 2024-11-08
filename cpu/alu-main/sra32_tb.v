module sra32_tb;
    reg [31:0] A;
    reg [4:0] shiftamt;
    wire [31:0] Out;

    sra32 sra_test(Out, A, shiftamt);

    reg [31:0] expected_Out;

    reg [68:0] test_cases[19:0];
    integer i;

    initial begin
        test_cases[0]  = {32'h00000001, 5'd0, 32'h00000001}; // Shift 0 places => Out=00000001
        test_cases[1]  = {32'h00000001, 5'd1, 32'h00000000}; // Shift 1 place => Out=00000000
        test_cases[2]  = {32'h00000001, 5'd31, 32'h00000000}; // Shift 31 places => Out=80000000
        test_cases[3]  = {32'h80000000, 5'd0, 32'h80000000}; // Shift 0 places => Out=80000000
        test_cases[4]  = {32'h80000000, 5'd1, 32'hC0000000}; // Shift 1 place => Out=80000000
        test_cases[5]  = {32'h80000000, 5'd31, 32'hFFFFFFFF}; // Shift 31 places => Out=80000000
        test_cases[6]  = {32'hFFFFFFFF, 5'd0, 32'hFFFFFFFF}; // Shift 0 places => Out=FFFFFFFF
        test_cases[7]  = {32'hFFFFFFFF, 5'd16, 32'hFFFFFFFF}; // Shift 16 places => Out=FFFFFFFF
        test_cases[8]  = {32'h0000FFFF, 5'd16, 32'h00000000}; // Shift 16 places => Out=0000FFFF
        test_cases[9]  = {32'h12345678, 5'd4, 32'h1234567}; // Shift 4 places => Out=12345678
        test_cases[10] = {32'h12345678, 5'd8, 32'h123456}; // Shift 8 places => Out=12345678
        test_cases[11] = {32'h12345678, 5'd16, 32'h1234}; // Shift 16 places => Out=12345678
        test_cases[12] = {32'h12345678, 5'd24, 32'h12}; // Shift 24 places => Out=12345678
        test_cases[13] = {32'h12345678, 5'd31, 32'h00000000}; // Shift 31 places => Out=F8000000
        test_cases[14] = {32'h00000001, 5'd5, 32'h00000000}; // Shift 5 places => Out=00000000
        test_cases[15] = {32'h00000001, 5'd10, 32'h00000000}; // Shift 10 places => Out=00000000
        test_cases[16] = {32'h00000001, 5'd15, 32'h00000000}; // Shift 15 places => Out=00000000
        test_cases[17] = {32'h00000001, 5'd20, 32'h00000000}; // Shift 20 places => Out=00000000
        test_cases[18] = {32'h00000001, 5'd25, 32'h00000000}; // Shift 25 places => Out=00000000
        test_cases[19] = {32'h00000001, 5'd30, 32'h00000000}; // Shift 30 places => Out=00000000


        for(i = 0; i < 20; i = i + 1) begin
            {A, shiftamt, expected_Out} = test_cases[i];

            #20;
            if (Out === expected_Out)
                $display("Test %d PASSED: A:%b, shiftamt:%d => Out:%b", i, A, shiftamt, Out);
            else
                $display("Test %d FAILED: A:%b, shiftamt:%d => Out:%b (expected %b)", 
                          i, A, shiftamt, Out, expected_Out);
        end

        $finish;
    end

    initial begin
        $dumpfile("sra32.vcd");
        $dumpvars(0, sra32_tb);
    end
endmodule
