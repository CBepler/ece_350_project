module lessThan(out, A, B);
    input [31:0] A, B;
    output out;

    wire [31:0] not_B;
    wire [31:0] A_xor_B;
    wire [31:0] A_and_not_B;
    wire [31:0] propagate;
    wire [32:0] generate_term;

    // Generate ~B (not A)
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : not_B_gen
            not not_B_gate(not_B[i], B[i]);
        end
    endgenerate

    // Generate A XOR B and A AND ~B
    generate
        for (i = 0; i < 32; i = i + 1) begin : xor_and_gen
            xor xor_gate(A_xor_B[i], A[i], B[i]);
            and and_gate(A_and_not_B[i], A[i], not_B[i]);
        end
    endgenerate

    assign propagate[0] = 1'b1;
    generate
        for (i = 1; i < 32; i = i + 1) begin : propagate_gen
            and and_gate(propagate[i], propagate[i-1], A_xor_B[i-1]);
        end
    endgenerate

    assign generate_term[0] = 1'b0;
    generate
        for (i = 1; i < 33; i = i + 1) begin : generate_gen
            or or_gate(generate_term[i], generate_term[i-1], 
                       (propagate[i-1] & A_and_not_B[i-1]));
        end
    endgenerate

    assign out = generate_term[32];

endmodule