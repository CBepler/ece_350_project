module mult_32(multiplicand, multiplier, clk, ctrl_MULT, data_result, data_exception, data_resultRDY);
    input [31:0] multiplicand, multiplier;      //A: multiplicand,      B: multiplier
    input clk, ctrl_MULT;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire [65:0] result, d, product; //[0] sign bit, [32:1] product, [64:33] multiplier,   [65] hold bit

    wire ena, clr;
    assign ena = !data_resultRDY;
    assign clr = ctrl_MULT;

    register66 result_reg(result, d, clk, 1'b0, 1'b1);

    wire[3:0] count;
    counter_16 counter(count, clk, ena, !clr);

    wire[2:0] select_bits;
    assign select_bits[2:0] = result[2:0];

    wire[31:0] add;
    wire[31:0] neg_M, neg_2M;
    wire o;
    thirty_two_bit_adder negate(o, neg_M, ~multiplicand, 32'd1, 1'b0);
    assign neg_2M = neg_M << 1;
    mux_8 choose(add, select_bits, 32'b0, multiplicand, multiplicand, multiplicand << 1, neg_2M, neg_M, neg_M, 32'b0); //000 nothing (+0), 100 -2M, 010 +M, 110 -M, 001 +M, 101 -M, 011 +2M, 111 nothing(+0)

    wire overflow;
    thirty_two_bit_adder adder(overflow, product[64:33], result[64:33], add, 1'b0);
    assign product[32:0] = result[32:0];
    assign product[65] = (select_bits[2] & ~select_bits[1] & ~select_bits[0]) ? neg_M[31] : ((~select_bits[2] & select_bits[1] & select_bits[0]) ? multiplicand[31] : product[64]);

    wire[65:0] shift;
    sra66 sra(shift, product, 6'd2);

    assign d = !clr ? shift : {33'b0, multiplier, 1'b0};

    assign data_result = d[32:1];

    assign data_resultRDY = ((count[0] & count[1] & count[2] & count[3]) ? 1'b1 : 1'b0);

    assign data_exception = (~(|multiplier) || ~(|multiplicand)) ? 1'b0 : (((multiplier[31] & multiplicand[31]) || (~multiplier[31] & ~multiplicand[31])) ? (|d[65:32]) : ~(&d[65:32]));

endmodule