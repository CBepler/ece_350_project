module tb_reg;

    reg clk;
    reg clr;
    reg read_enable;
    reg write_enable;
    reg [31:0] d;

    wire [31:0] out;

    register my_register (
        .out(out),
        .d(d),
        .clk(clk),
        .clr(clr),
        .read_enable(read_enable),
        .write_enable(write_enable)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        read_enable = 1;
        clr = 0;

        // Test Case 1: Write data into the register
        write_enable = 1;
        d = 32'hA5A5A5A5;
        #10;

        if (out !== 32'hA5A5A5A5) begin
            $display("Error: Write failed, expected %h but got %h", 32'hA5A5A5A5, out);
        end else begin
            $display("Write successful: %h", out);
        end

        write_enable = 0;
        #10;

        d = 32'hFFA5A5A5;

        // Test Case 2: Read the data from the register
        #10;

        if (out !== 32'hA5A5A5A5) begin
            $display("Error: Read failed, expected %h but got %h", 32'hA5A5A5A5, out);
        end else begin
            $display("Read successful: %h", out);
        end
        #10;

        // Test Case 3: Write new data
        write_enable = 1;
        d = 32'h5A5A5A5A;
        #10;

        if (out !== 32'h5A5A5A5A) begin
            $display("Error: Write failed, expected %h but got %h", 32'h5A5A5A5A, out);
        end else begin
            $display("Write successful: %h", out);
        end

        write_enable = 0;
        d = 32'hFFA5A5A5;
        #10;

        // Test Case 4: Read the new data
        #10;

        if (out !== 32'h5A5A5A5A) begin
            $display("Error: Read failed, expected %h but got %h", 32'h5A5A5A5A, out);
        end else begin
            $display("Read successful: %h", out);
        end

        clr = 1;
        write_enable = 1;

        #10

        if (out !== 32'h00000000) begin
            $display("Error: Read failed, expected %h but got %h", 32'h00000000, out);
        end else begin
            $display("Read successful: %h", out);
        end

        #10;

        clr = 0;
        read_enable = 0;

        #10

        if (out !== 32'hzzzzzzzz) begin
            $display("Error: Read failed, expected %h but got %h", 32'hzzzzzzzz, out);
        end else begin
            $display("Read successful: %h", out);
        end

        $finish;
    end

    initial begin
        $monitor("Time: %0t | d: %h | clk: %b | clr: %b | read_enable: %b | write_enable: %b | out: %h", 
                 $time, d, clk, clr, read_enable, write_enable, out);
    end

endmodule
