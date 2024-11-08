module sll32_tb;
    reg [31:0] A;
    reg [4:0] shiftamt;
    wire [31:0] Out;

    sll32 sll_test(Out, A, shiftamt);

    reg [31:0] expected_Out;

    reg [68:0] test_cases[19:0];
    integer i;

    initial begin
        test_cases[0]  = {32'h00000001, 5'd0, 32'h00000001}; // Shift 0 places => Out=00000001
        test_cases[1]  = {32'h00000001, 5'd1, 32'h00000002}; // Shift 1 place => Out=00000002
        test_cases[2]  = {32'h00000001, 5'd31, 32'h80000000}; // Shift 31 places => Out=80000000
        test_cases[3]  = {32'h00000001, 5'd0, 32'h00000001}; // Shift 32 places => Out=00000000
        test_cases[4]  = {32'h80000000, 5'd1, 32'h00000000}; // Shift MSB 1 place => Out=00000000
        test_cases[5]  = {32'h80000000, 5'd31, 32'h00000000}; // Shift MSB 31 places => Out=00000001
        test_cases[6]  = {32'hFFFFFFFF, 5'd0, 32'hFFFFFFFF}; // Shift 0 places => Out=FFFFFFFF
        test_cases[7]  = {32'hFFFFFFFF, 5'd16, 32'hFFFF0000}; // Shift 16 places => Out=FFFFFFFF
        test_cases[8]  = {32'h0000FFFF, 5'd16, 32'hFFFF0000}; // Shift 16 places => Out=FFFF0000
        test_cases[9]  = {32'h12345678, 5'd4, 32'h23456780}; // Shift 4 places => Out=23456780
        test_cases[10] = {32'h12345678, 5'd8, 32'h34567800}; // Shift 8 places => Out=34567800
        test_cases[11] = {32'h12345678, 5'd16, 32'h56780000}; // Shift 16 places => Out=56780000
        test_cases[12] = {32'h12345678, 5'd24, 32'h78000000}; // Shift 24 places => Out=78000000
        test_cases[13] = {32'h12345678, 5'd31, 32'h00000000}; // Shift 31 places => Out=80000000
        test_cases[14] = {32'h00000001, 5'd5, 32'h00000020}; // Shift 5 places => Out=00000020
        test_cases[15] = {32'h00000001, 5'd10, 32'h00000400}; // Shift 10 places => Out=00000400
        test_cases[16] = {32'h00000001, 5'd15, 32'h00008000}; // Shift 15 places => Out=00008000
        test_cases[17] = {32'h00000001, 5'd20, 32'h00100000}; // Shift 20 places => Out=00100000
        test_cases[18] = {32'h00000001, 5'd25, 32'h02000000}; // Shift 25 places => Out=02000000
        test_cases[19] = {32'h00000001, 5'd30, 32'h40000000}; // Shift 30 places => Out=40000000


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
        $dumpfile("sll32.vcd");
        $dumpvars(0, sll32_tb);
    end
endmodule
