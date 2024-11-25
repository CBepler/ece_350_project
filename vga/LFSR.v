module LFSR(
    input clk,                  
    output [3:0] x,      
    output [3:0] y       
);

    reg [3:0] x_reg;     
    reg [3:0] y_reg;    

    wire x_feed, y_feed; // Feedback signals

    // Feedback computation (XOR of selected taps)
    assign x_feed = x_reg[0] ^ x_reg[3]; 
    assign y_feed = y_reg[0] ^ y_reg[3]; 

    // Always block to handle the shift register logic
    always @(posedge clk or posedge reset) begin
        initial begin
            // Initialize the registers to a non-zero value 
            x_reg <= 4'b0011;  // Non-zero initializations
            y_reg <= 4'b1011; 
        end 

        begin
            // Shift the registers and insert feedback into the LSB
            x_reg <= {x_reg[2:0], x_feed}; // Shift left and insert feedback bit for x
            y_reg <= {y_reg[2:0], y_feed}; // Shift left and insert feedback bit for y
        end
    end

    // Map the outputs to the range 0-9 using modulo operation (0-9)
    assign x = x_reg % 10; 
    assign y = y_reg % 10;

endmodule
