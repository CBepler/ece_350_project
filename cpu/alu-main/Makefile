VERILOG_COMPILER = iverilog
SIMULATOR = vvp
WAVE_VIEWER = gtkwave

SRC32 = thirty_two_bit_adder.v eight_bit_adder.v carry.v big_carry.v
TB32 = thirty_two_bit_adder_tb.v

SRC = alu.v and32.v big_carry.v carry.v eight_bit_adder.v not32.v or32.v sll32.v sra32.v thirty_two_bit_adder.v mux_2.v mux_4.v mux_8.v mux_16.v mux_32.v not_equal.v
TB = alu_tb.v

OUTPUT = alu
OUTPUT32 = thirty_two_bit_add
VCD_FILE = $(OUTPUT).vcd

all: compile

compile:
	$(VERILOG_COMPILER) -o $(OUTPUT).vvp $(SRC) $(TB)

compile32:
	$(VERILOG_COMPILER) -o $(OUTPUT32).vvp $(SRC32) $(TB32)

simulate: compile
	$(SIMULATOR) $(OUTPUT).vvp

view: compile
	$(WAVE_VIEWER) $(VCD_FILE)

clean:
	rm -f *.vvp *.vcd *diff.csv *actual.csv