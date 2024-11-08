`timescale 1ns / 1ps

module mult_32_tb;

    // Inputs
    reg [31:0] multiplicand;
    reg [31:0] multiplier;
    reg clk;
    reg ctrl_MULT;

    // Outputs
    wire [31:0] data_result;
    wire data_exception;
    wire data_resultRDY;

    // Instantiate the Unit Under Test (UUT)
    mult_32 uut (
        .multiplicand(multiplicand), 
        .multiplier(multiplier), 
        .clk(clk), 
        .ctrl_MULT(ctrl_MULT), 
        .data_result(data_result), 
        .data_exception(data_exception), 
        .data_resultRDY(data_resultRDY)
    );

    // clk generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clk
    end

    // Test case structure
    task test_multiply;
        input [31:0] a;
        input [31:0] b;
        input [63:0] expected;
        begin
            multiplicand = a;
            multiplier = b;
            ctrl_MULT = 1;
            @(posedge clk);
            ctrl_MULT = 0;
            
            repeat(17) @(posedge clk); // Wait for 17 clk cycles (16 for multiplication + 1 for setup)
            
            if (data_resultRDY) begin
                if ({32'b0, data_result} == expected[31:0]) begin
                    $display("PASS: %d * %d = %d", $signed(a), $signed(b), $signed(data_result));
                end else begin
                    $display("FAIL: %d * %d = %d (Expected %d)", $signed(a), $signed(b), $signed(data_result), $signed(expected[31:0]));
                end
            end else begin
                $display("FAIL: Multiplication not ready after expected cycles");
            end
            
            @(posedge clk);
        end
    endtask

    // Testbench stimulus
    initial begin
        // Initialize Inputs
        multiplicand = 0;
        multiplier = 0;
        ctrl_MULT = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Test case 1: Positive * Positive
        test_multiply(5, 7, 35);
        
        // Test case 2: Positive * Negative
        test_multiply(10, -3, -30);
        
        // Test case 3: Negative * Positive
        test_multiply(-8, 6, -48);
        
        // Test case 4: Negative * Negative
        test_multiply(-12, -5, 60);
        
        // Test case 5: Multiplication by 0
        test_multiply(100, 0, 0);
        
        // Test case 6: Multiplication by 1
        test_multiply(-25, 1, -25);
        
        // Test case 7: Large numbers
        test_multiply(65535, 2, 131070);
        
        // Test case 8: Max positive * 2
        test_multiply(2147483647, 2, 4294967294);
        
        // Test case 9: Min negative * -1
        test_multiply(-2147483648, -1, 2147483648);

        // Finish the simulation
        #100;
        $finish;
    end
      
    // Optional: Monitor changes
    initial begin
        $monitor("Time=%0t multiplicand=%d multiplier=%d result=%d ready=%b exception=%b", 
                 $time, multiplicand, multiplier, data_result, 
                 data_resultRDY, data_exception);
        $dumpfile("mult.vcd");
        $dumpvars(0, mult_32_tb);
    end

endmodule