module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;      //A: multiplicand,      B: multiplier
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // add your code here

    wire prevOp, operation; //0 for mult 1 for divide
    dffe_ref op(prevOp, operation, clock, 1'b1, 1'b0);
    assign operation = ctrl_DIV ? 1'b1 : (ctrl_MULT ? 1'b0 : prevOp);

    wire [65:0] result, d, product;
    //[0] sign bit, [32:1] product,    [64:33] multiplier,        [65] hold bit    For Mult
    //[0] none,     [32:1] Remainder,  [64:33] Quotient/dividend  [65] none        For Div

    wire ena, clr;
    assign ena = !data_resultRDY;
    assign clr = operation ? ctrl_DIV : ctrl_MULT;

    register66 result_reg(result, d, clock, 1'b0, 1'b1);

    wire[4:0] count;
    counter_32 counter(count, clock, ena, !clr);

    wire[2:0] select_bits;
    assign select_bits[2:0] = result[2:0];

    //Division negative handling
    wire[31:0] operandA, operandB, negA, negB;
    wire o3, o4;
    thirty_two_bit_adder negate3(o3, negA, ~data_operandA, 32'd1, 1'b0);
    thirty_two_bit_adder negate4(o4, negB, ~data_operandB, 32'd1, 1'b0);
    assign operandA =  operation ? (data_operandA[31] ? negA : data_operandA) : data_operandA;
    assign operandB =  operation ? (data_operandB[31] ? negB : data_operandB) : data_operandB;


    wire[31:0] add, multAdd;
    wire[31:0] neg_M, neg_2M;
    wire o;
    thirty_two_bit_adder negate(o, neg_M, ~operandA, 32'd1, 1'b0);
    assign neg_2M = neg_M << 1;
    mux_8 choose(multAdd, select_bits, 32'b0, operandA, operandA, operandA << 1, neg_2M, neg_M, neg_M, 32'b0); //000 nothing (+0), 100 -2M, 010 +M, 110 -M, 001 +M, 101 -M, 011 +2M, 111 nothing(+0)

    wire[31:0] negDivisor, divAdd;
    wire o2;
    thirty_two_bit_adder negate2(o2, negDivisor, ~operandB, 32'd1, 1'b0);
    assign divAdd = result[64] ? operandB : negDivisor;
    assign add = operation ? divAdd : multAdd;
    wire overflow;
    thirty_two_bit_adder adder(overflow, product[64:33], result[64:33], add, 1'b0);
    assign product[32:0] = result[32:0];
    assign product[65] = (select_bits[2] & ~select_bits[1] & ~select_bits[0]) ? neg_M[31] : ((~select_bits[2] & select_bits[1] & select_bits[0]) ? operandA[31] : product[64]);

    wire[65:0] shiftMult, divQCorrect, shiftDiv;
    sra66 sra(shiftMult, product, 6'd2);
    assign divQCorrect = {product[65:1], product[64] ? 1'b0 : 1'b1};
    assign shiftDiv = divQCorrect << 1;

    assign d = operation ? (!clr ? shiftDiv : {32'b0, operandA, 2'b00}) :(!clr ? shiftMult : {33'b0, operandB, 1'b0});

    wire[31:0] negResult;
    wire o5;
    thirty_two_bit_adder negate5(o5, negResult, ~d[32:1], 32'd1, 1'b0);

    assign data_result = operation ? (data_exception ? 32'd0 : ((data_operandA[31] ^ data_operandB[31]) ? negResult :d[32:1])) :d[32:1];

    assign data_resultRDY = operation ? ((count[0] & count[1] & count[2] & count[3] & count[4]) ? 1'b1 : 1'b0) :((count[0] & count[1] & count[2] & count[3]) ? 1'b1 : 1'b0);

    assign data_exception = operation ? (~(|operandB) ? 1'b1 : 1'b0) : ((~(|operandB) || ~(|operandA)) ? 1'b0 : (((operandB[31] & operandA[31]) || (~operandB[31] & ~operandA[31])) ? (|d[65:32]) : ~(&d[65:32])));
    

endmodule