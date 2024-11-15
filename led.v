module led(leds, LED, clk, led_we);
    input clk, led_we;
    input [31:0] leds;
    output reg[15:0] LED;

    always @(posedge clk) begin
        if(led_we) begin
            LED = leds[15:0];
        end
    end



endmodule