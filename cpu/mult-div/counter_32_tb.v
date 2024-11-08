`timescale 1ns / 1ps

module counter_32_tb;

    // Inputs
    reg clk;
    reg ena;
    reg clrn;

    // Outputs
    wire [4:0] out;  // Changed to 5 bits

    // Instantiate the Unit Under Test (UUT)
    counter_32 uut (
        .out(out), 
        .clk(clk), 
        .ena(ena), 
        .clrn(clrn)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Testbench behavior
    initial begin
        // Initialize Inputs
        ena = 0;
        clrn = 0;

        // Wait for global reset
        #100;
        
        // Release reset and enable counter
        clrn = 1;
        ena = 1;
        
        // Wait for a full count cycle (32 clock cycles for 5-bit counter)
        #320;  // Changed to 320ns (32 * 10ns clock period)
        
        // Disable counter
        ena = 0;
        #20;
        
        // Re-enable counter
        ena = 1;
        #320;  // Changed to 320ns
        
        // Reset counter
        clrn = 0;
        #10;
        clrn = 1;
        
        // Let it run for a while
        #320;  // Changed to 320ns
        
        // Finish simulation
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time=%0t ena=%b clrn=%b out=%d", $time, ena, clrn, out);
        $dumpfile("count32.vcd");
        $dumpvars(0, counter_32_tb);
    end

endmodule