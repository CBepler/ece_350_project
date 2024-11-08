`timescale 1 ns / 100 ps
module carry_tb;
    wire[7:0] A, B;
    wire Cin;
    wire[7:0] carry_bits;

    carry carry_test(carry_bits, A, B, Cin);

    integer i;
    assign {A, B, Cin} = i[16:0];
    initial begin
        for(i = 0; i < 2048; i = i + 1) begin
            #20;
            $display("A:%b, B:%b, Cin:%b => carry_bits:%b", A, B, Cin, carry_bits);
        end
        $finish;
    end

    initial begin
        $dumpfile("carry.vcd");
        $dumpvars(0, carry_tb);
    end
endmodule