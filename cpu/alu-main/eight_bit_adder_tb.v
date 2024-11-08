module eight_bit_adder_tb;
    reg [7:0] A, B;
    reg Cin;
    wire [7:0] S;
    wire [7:0] carry_bits;

    eight_bit_adder adder(S, A, B, Cin, carry_bits);
    carry test_carry(carry_bits, A, B, Cin);

    reg [7:0] expected_S;

    reg [24:0] test_cases[19:0];
    integer i;

    initial begin
        test_cases[0]  = {8'h01, 8'h01, 1'b0, 8'h02}; // A=1, B=1, Cin=0 => S=2
        test_cases[1]  = {8'hFF, 8'h01, 1'b0, 8'h00}; // A=255, B=1, Cin=0 => S=0
        test_cases[2]  = {8'h0F, 8'h0F, 1'b1, 8'h1F}; // A=15, B=15, Cin=1 => S=31
        test_cases[3]  = {8'hA5, 8'h5A, 1'b1, 8'h00}; // A=165, B=90, Cin=1 => S=0
        test_cases[4]  = {8'h00, 8'h00, 1'b0, 8'h00}; // A=0, B=0, Cin=0 => S=0
        test_cases[5]  = {8'h80, 8'h80, 1'b0, 8'h00}; // A=128, B=128, Cin=0 => S=0
        test_cases[6]  = {8'hFF, 8'hFF, 1'b0, 8'hFE}; // A=255, B=255, Cin=0 => S=254
        test_cases[7]  = {8'h55, 8'h55, 1'b0, 8'hAA}; // A=85, B=85, Cin=0 => S=170
        test_cases[8]  = {8'h33, 8'h33, 1'b1, 8'h67}; // A=51, B=51, Cin=1 => S=103
        test_cases[9]  = {8'h7F, 8'h01, 1'b1, 8'h81}; // A=127, B=1, Cin=1 => S=129
        test_cases[10] = {8'hAA, 8'h55, 1'b1, 8'h00}; // A=170, B=85, Cin=1 => S=0
        test_cases[11] = {8'h10, 8'hEF, 1'b0, 8'hFF}; // A=16, B=239, Cin=0 => S=255
        test_cases[12] = {8'h22, 8'hDD, 1'b1, 8'h00}; // A=34, B=221, Cin=1 => S=0
        test_cases[13] = {8'hFE, 8'h01, 1'b0, 8'hFF}; // A=254, B=1, Cin=0 => S=255
        test_cases[14] = {8'h01, 8'hFE, 1'b1, 8'h00}; // A=1, B=254, Cin=1 => S=0
        test_cases[15] = {8'h77, 8'h88, 1'b0, 8'hFF}; // A=119, B=136, Cin=0 => S=255
        test_cases[16] = {8'hAB, 8'hCD, 1'b1, 8'h79}; // A=171, B=205, Cin=1 => S=121
        test_cases[17] = {8'hF0, 8'h0F, 1'b0, 8'hFF}; // A=240, B=15, Cin=0 => S=255
        test_cases[18] = {8'h12, 8'hED, 1'b1, 8'h00}; // A=18, B=237, Cin=1 => S=0
        test_cases[19] = {8'h99, 8'h66, 1'b0, 8'hFF}; // A=153, B=102, Cin=0 => S=255

        for(i = 0; i < 20; i = i + 1) begin
            {A, B, Cin, expected_S} = test_cases[i];

            #20;
            if (S === expected_S)
                $display("Test %d PASSED: A:%b, B:%b, Cin:%b => S:%b, carry bits:%b", i, A, B, Cin, S, carry_bits);
            else
                $display("Test %d FAILED: A:%b, B:%b, Cin:%b => S:%b (expected %b), carry bits:%b", 
                          i, A, B, Cin, S, expected_S, carry_bits);
        end

        $finish;
    end

    initial begin
        $dumpfile("eight_bit_adder.vcd");
        $dumpvars(0, eight_bit_adder_tb);
    end
endmodule
