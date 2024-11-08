VERILOG_COMPILER = iverilog
SIMULATOR = vvp

ALU-PATH = ../alu-main/
REG-PATH = ../reg-file/

SRC = multdiv.v reg66.v counter_32.v tff.v ${REG-PATH}dffe_ref.v ${ALU-PATH}mux_2.v ${ALU-PATH}mux_4.v ${ALU-PATH}mux_8.v ${ALU-PATH}thirty_two_bit_adder.v ${ALU-PATH}eight_bit_adder.v ${ALU-PATH}carry.v ${ALU-PATH}big_carry.v sra66.v
TB = multdiv_tb.v

countSRC = counter_16.v tff.v ${REG-PATH}dffe.v ${REG-PATH}d_latch.v
countTB = counter_16_tb.v

OUTPUT = multdiv
countOUT = count
VCD_FILE = $(OUTPUT).vcd

all: compile

compile:
	$(VERILOG_COMPILER) -o $(OUTPUT).vvp $(SRC) $(TB)

count:
	$(VERILOG_COMPILER) -o $(countOUT).vvp $(countSRC) $(countTB)

simulate: compile
	$(SIMULATOR) $(OUTPUT).vvp

clean:
	rm -f *.vvp *.vcd *diff.csv *actual.csv