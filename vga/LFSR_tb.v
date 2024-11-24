//Testbench for LFSR module --> works!!!
`timescale 1ns/1ps

module LFSR_tb;

    // Declare signals for the testbench
    reg clk;
    reg reset;
    wire [3:0] x;  // 4-bit output for x
    wire [3:0] y;  // 4-bit output for y

    // Instantiate the LFSR module
    LFSR uut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y)
    );

    // Clock generation (50 MHz clock)
    initial clk = 0;
    always #10 clk = ~clk;  // 10 ns period for 50 MHz clock

    // Test sequence
    initial begin
        // Display header
        $display("Time\tReset\tX\tY");
        $monitor("%d\t%b\t%d\t%d", $time, reset, x, y);

        // Initialize signals
        reset = 1;  // Assert reset
        #20;         // Wait for a few clock cycles to propagate reset
        reset = 0;   // Deassert reset
        #500;        // Run simulation for 500 ns

        // End simulation
        $stop;  // Stop the simulation
    end

    // Dump waveform to a VCD file (for visualization in a waveform viewer)
    initial begin
        $dumpfile("LFSR_tb.vcd");
        $dumpvars(0, LFSR_tb);
    end

endmodule
