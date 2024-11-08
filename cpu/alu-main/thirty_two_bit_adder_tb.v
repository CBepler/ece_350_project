module thirty_two_bit_adder_tb;
    reg [31:0] A, B;
    reg Cin;
    wire [31:0] S;
    wire overflow;

    thirty_two_bit_adder adder(overflow, S, A, B, Cin);

    reg [31:0] expected_S;
    reg expected_overflow;

    reg [97:0] test_cases[19:0];
    integer i;

    initial begin
        test_cases[0]  = {32'h00000001, 32'h00000001, 1'b0, 32'h00000002, 1'b0}; // A=1, B=1 => S=2, no overflow
        test_cases[1]  = {32'h7FFFFFFF, 32'h00000001, 1'b0, 32'h80000000, 1'b1}; // A=2147483647, B=1 => S=-2147483648, overflow
        test_cases[2]  = {32'h80000000, 32'h80000000, 1'b0, 32'h00000000, 1'b1}; // A=-2147483648, B=-2147483648 => S=0, overflow
        test_cases[3]  = {32'h55555555, 32'h55555555, 1'b0, 32'hAAAAAAAA, 1'b1}; // A=1431655765, B=1431655765 => S=-1431655766, overflow
        test_cases[4]  = {32'h00000000, 32'h00000001, 1'b0, 32'h00000001, 1'b0}; // A=0, B=1 => S=1, no overflow
        test_cases[5]  = {32'h80000000, 32'h00000001, 1'b0, 32'h80000001, 1'b0}; // A=-2147483648, B=1 => S=-2147483647, no overflow
        test_cases[6]  = {32'h00000001, 32'h00000001, 1'b0, 32'h00000002, 1'b0}; // A=1, B=1 => S=2, no overflow
        test_cases[7]  = {32'h80000000, 32'h7FFFFFFF, 1'b0, 32'hFFFFFFFF, 1'b0}; // A=-2147483648, B=2147483647 => S=-1, no overflow
        test_cases[8]  = {32'h80000000, 32'h80000000, 1'b0, 32'h00000000, 1'b1}; // A=-2147483648, B=-2147483648 => S=0, overflow
        test_cases[9]  = {32'h00000001, 32'h00000001, 1'b0, 32'h00000002, 1'b0}; // A=1, B=1 => S=2, no overflow
        test_cases[10] = {32'h7FFFFFFF, 32'h7FFFFFFF, 1'b0, 32'hFFFFFFFE, 1'b1}; // A=2147483647, B=2147483647 => S=-2, overflow
        test_cases[11] = {32'h7FFFFFFF, 32'h00000000, 1'b0, 32'h7FFFFFFF, 1'b0}; // A=2147483647, B=0 => S=2147483647, no overflow
        test_cases[12] = {32'h00000000, 32'h80000000, 1'b0, 32'h80000000, 1'b0}; // A=0, B=-2147483648 => S=-2147483648, no overflow
        test_cases[13] = {32'h80000000, 32'h00000000, 1'b0, 32'h80000000, 1'b0}; // A=-2147483648, B=0 => S=-2147483648, no overflow
        test_cases[14] = {32'h00000001, 32'hFFFFFFFE, 1'b0, 32'hFFFFFFFF, 1'b0}; // A=1, B=-2 => S=-1, no overflow
        test_cases[15] = {32'hFFFFFFFF, 32'h00000001, 1'b0, 32'h00000000, 1'b0}; // A=-1, B=1 => S=0, no overflow
        test_cases[16] = {32'h00000000, 32'h00000001, 1'b0, 32'h00000001, 1'b0}; // A=0, B=1 => S=1, no overflow
        test_cases[17] = {32'h00000000, 32'h80000000, 1'b0, 32'h80000000, 1'b0}; // A=0, B=-2147483648 => S=-2147483648, no overflow
        test_cases[18] = {32'h7FFFFFFF, 32'h00000001, 1'b0, 32'h80000000, 1'b1}; // A=2147483647, B=1 => S=-2147483648, overflow
        test_cases[19] = {32'h00000000, 32'h00000000, 1'b0, 32'h00000000, 1'b0}; // A=0, B=0 => S=0, no overflow



        for(i = 0; i < 20; i = i + 1) begin
            {A, B, Cin, expected_S, expected_overflow} = test_cases[i];

            #20;
            if (S === expected_S && overflow === expected_overflow)
                $display("Test %d PASSED: A:%b, B:%b, Cin:%b => S:%b, overflow:%b", i, A, B, Cin, S, overflow);
            else
                $display("Test %d FAILED: A:%b, B:%b, Cin:%b => S:%b (expected %b) overflow:%b (expected:%b)", 
                          i, A, B, Cin, S, expected_S, overflow, expected_overflow);
        end

        $finish;
    end

    initial begin
        $dumpfile("thirty_two_bit_adder.vcd");
        $dumpvars(0, thirty_two_bit_adder_tb);
    end
endmodule
