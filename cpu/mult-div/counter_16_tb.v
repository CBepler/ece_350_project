`timescale 1ns / 1ps

module counter_16_tb;

    // Inputs
    reg clk;
    reg ena;
    reg clrn;

    // Outputs
    wire [3:0] out;

    // Instantiate the Unit Under Test (UUT)
    counter_16 uut (
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
        
        // Wait for a full count cycle (16 clock cycles)
        #160;
        
        // Disable counter
        ena = 0;
        #20;
        
        // Re-enable counter
        ena = 1;
        #160;
        
        // Reset counter
        clrn = 0;
        #10;
        clrn = 1;
        
        // Let it run for a while
        #160;
        
        // Finish simulation
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time=%0t ena=%b clrn=%b out=%d", $time, ena, clrn, out);
        $dumpfile("count.vcd");
        $dumpvars(0, counter_16_tb);
    end

endmodule