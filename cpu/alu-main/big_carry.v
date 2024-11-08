module big_carry(Cout, A, B, Cin);
    
    input Cin;
    input [7:0] A, B;

    output Cout;

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



    wire b_prop, b_gen;
    and m_b_prop(b_prop, prop[0], prop[1], prop[2], prop[3], prop[4], prop[5], prop[6], prop[7]);

    wire bA, bB, C, D, E, F, G, H;
    and m_A(bA, prop[7], prop[6], prop[5], prop[4], prop[3], prop[2], prop[1], gen[0]);
    and m_B(bB, prop[7], prop[6], prop[5], prop[4], prop[3], prop[2], gen[1]);
    and m_C(C, prop[7], prop[6], prop[5], prop[4], prop[3], gen[2]);
    and m_D(D, prop[7], prop[6], prop[5], prop[4], gen[3]);
    and m_E(E, prop[7], prop[6], prop[5], gen[4]);
    and m_F(F, prop[7], prop[6], gen[5]);
    and m_G(G, prop[7], gen[6]);
    and m_H(H, gen[7]);

    or m_b_gen(b_gen, bA, bB, C, D, E, F, G, H);

    wire propagate;
    and m_propagate(propagate, b_prop, Cin);

    or out(Cout, b_gen, propagate);
    
endmodule