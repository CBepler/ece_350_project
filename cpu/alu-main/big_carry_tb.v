`timescale 1 ns / 100 ps
module big_carry_tb;
    wire[7:0] A, B;
    wire Cin;
    wire Cout;

    big_carry big_carry_test(Cout, A, B, Cin);

    integer i;
    assign {A, B, Cin} = i[16:0];
    initial begin
        for(i = 0; i < 2048; i = i + 1) begin
            #20;
            $display("A:%b, B:%b, Cin:%b => Cout:%b", A, B, Cin, Cout);
        end
        $finish;
    end

    initial begin
        $dumpfile("big_carry.vcd");
        $dumpvars(0, big_carry_tb);
    end
endmodule