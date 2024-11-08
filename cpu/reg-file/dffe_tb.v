module tb_dffe;

    reg d, clk, clrn, ena;
    
    wire q;
    
    dffe dff_test (q, d, clk, clrn, ena);
    
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        clk = 0;
        d = 0;
        clrn = 1;
        ena = 1;

        // Test Case 1: Set the D input, enable, no clear
        #10;
        d = 1;
        ena = 1;
        clrn = 1;

        #10;

        // Test Case 2: Clear the output
        #10;
        clrn = 0;

        #10;
        clrn = 1;

        // Test Case 3: Disable the flip-flop (retain previous value)
        #10;
        ena = 0;
        d = 0;

        #10;

        // Test Case 4: Enable and check flip-flop operation
        #10;
        ena = 1;
        d = 1;

        #10;

        // Test Case 5: Test with various enable and clear conditions
        #10;
        ena = 1;
        clrn = 0;

        #10;
        clrn = 1;
        d = 0;

        #10;

        // Finish simulation
        $finish;
    end
    
    // Monitor output
    initial begin
        $monitor("Time: %0t | d: %b | clk: %b | clrn: %b | ena: %b | q: %b", 
                 $time, d, clk, clrn, ena, q);
    end

endmodule
