`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2024 06:58:59 PM
// Design Name: 
// Module Name: buttons
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module buttons(
    input BTNU,
    input BTNR,
    input BTND,
    input BTNL,
    input clk,
    output reg [2:0] button_reg
    );
        
    always @(posedge clk) begin
        if(BTNU) begin
            button_reg <= 1;
        end
        else if(BTNR) begin
            button_reg <= 2;
        end
        else if(BTND) begin
            button_reg <= 3;
        end
        else if(BTNL) begin
            button_reg <= 4;
        end
        else begin
            button_reg <= 0;
        end
    end
        
endmodule
