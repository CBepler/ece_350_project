module carry(carry_bits, A, B, Cin);
    
    input Cin;
    input [7:0] A, B;

    output [7:0] carry_bits;

    wire [7:0] prop, gen;
    or c_prop0(prop[0], A[0], B[0]);
    or c_prop1(prop[1], A[1], B[1]);
    or c_prop2(prop[2], A[2], B[2]);
    or c_prop3(prop[3], A[3], B[3]);
    or c_prop4(prop[4], A[4], B[4]);
    or c_prop5(prop[5], A[5], B[5]);
    or c_prop6(prop[6], A[6], B[6]);
    or c_prop7(prop[7], A[7], B[7]);
    and c_gen0(gen[0], A[0], B[0]);
    and c_gen1(gen[1], A[1], B[1]);
    and c_gen2(gen[2], A[2], B[2]);
    and c_gen3(gen[3], A[3], B[3]);
    and c_gen4(gen[4], A[4], B[4]);
    and c_gen5(gen[5], A[5], B[5]);
    and c_gen6(gen[6], A[6], B[6]);
    and c_gen7(gen[7], A[7], B[7]);



    wire prop0;
    and m_prop0(prop0, Cin, prop[0]);
    or carry0(carry_bits[0], prop0, gen[0]);

    wire prop1A, prop1B;
    and m_prop1A(prop1A, Cin, prop[0], prop[1]);
    and m_prop1B(prop1B, gen[0], prop[1]);
    or carry1(carry_bits[1], prop1A, prop1B, gen[1]);

    wire prop2A, prop2B, prop2C;
    and m_prop2A(prop2A, Cin, prop[0], prop[1], prop[2]);
    and m_prop2B(prop2B, gen[0], prop[1], prop[2]);
    and m_prop2C(prop2C, gen[1], prop[2]);
    or carry2(carry_bits[2], prop2A, prop2B, prop2C, gen[2]);

    wire prop3A, prop3B, prop3C, prop3D;
    and m_prop3A(prop3A, Cin, prop[0], prop[1], prop[2], prop[3]);
    and m_prop3B(prop3B, gen[0], prop[1], prop[2], prop[3]);
    and m_prop3C(prop3C, gen[1], prop[2], prop[3]);
    and m_prop3D(prop3D, gen[2], prop[3]);
    or carry3(carry_bits[3], prop3A, prop3B, prop3C, prop3D, gen[3]);

    wire prop4A, prop4B, prop4C, prop4D, prop4E;
    and m_prop4A(prop4A, Cin, prop[0], prop[1], prop[2], prop[3], prop[4]);
    and m_prop4B(prop4B, gen[0], prop[1], prop[2], prop[3], prop[4]);
    and m_prop4C(prop4C, gen[1], prop[2], prop[3], prop[4]);
    and m_prop4D(prop4D, gen[2], prop[3], prop[4]);
    and m_prop4E(prop4E, gen[3], prop[4]);
    or carry4(carry_bits[4], prop4A, prop4B, prop4C, prop4D, prop4E, gen[4]);

    wire prop5A, prop5B, prop5C, prop5D, prop5E, prop5F;
    and m_prop5A(prop5A, Cin, prop[0], prop[1], prop[2], prop[3], prop[4], prop[5]);
    and m_prop5B(prop5B, gen[0], prop[1], prop[2], prop[3], prop[4], prop[5]);
    and m_prop5C(prop5C, gen[1], prop[2], prop[3], prop[4], prop[5]);
    and m_prop5D(prop5D, gen[2], prop[3], prop[4], prop[5]);
    and m_prop5E(prop5E, gen[3], prop[4], prop[5]);
    and m_prop5F(prop5F, gen[4], prop[5]);
    or carry5(carry_bits[5], prop5A, prop5B, prop5C, prop5D, prop5E, prop5F, gen[5]);

    wire prop6A, prop6B, prop6C, prop6D, prop6E, prop6F, prop6G;
    and m_prop6A(prop6A, Cin, prop[0], prop[1], prop[2], prop[3], prop[4], prop[5], prop[6]);
    and m_prop6B(prop6B, gen[0], prop[1], prop[2], prop[3], prop[4], prop[5], prop[6]);
    and m_prop6C(prop6C, gen[1], prop[2], prop[3], prop[4], prop[5], prop[6]);
    and m_prop6D(prop6D, gen[2], prop[3], prop[4], prop[5], prop[6]);
    and m_prop6E(prop6E, gen[3], prop[4], prop[5], prop[6]);
    and m_prop6F(prop6F, gen[4], prop[5], prop[6]);
    and m_prop6G(prop6G, gen[5], prop[6]);
    or carry6(carry_bits[6], prop6A, prop6B, prop6C, prop6D, prop6E, prop6F, prop6G, gen[6]);

    wire prop7A, prop7B, prop7C, prop7D, prop7E, prop7F, prop7G, prop7H;
    and m_prop7A(prop7A, Cin, prop[0], prop[1], prop[2], prop[3], prop[4], prop[5], prop[6], prop[7]);
    and m_prop7B(prop7B, gen[0], prop[1], prop[2], prop[3], prop[4], prop[5], prop[6], prop[7]);
    and m_prop7C(prop7C, gen[1], prop[2], prop[3], prop[4], prop[5], prop[6], prop[7]);
    and m_prop7D(prop7D, gen[2], prop[3], prop[4], prop[5], prop[6], prop[7]);
    and m_prop7E(prop7E, gen[3], prop[4], prop[5], prop[6], prop[7]);
    and m_prop7F(prop7F, gen[4], prop[5], prop[6], prop[7]);
    and m_prop7G(prop7G, gen[5], prop[6], prop[7]);
    and m_prop7H(prop7H, gen[6], prop[7]);
    or carry7(carry_bits[7], prop7A, prop7B, prop7C, prop7D, prop7E, prop7F, prop7G, prop7H, gen[7]);

endmodule