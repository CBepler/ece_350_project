VERILOG_COMPILER = iverilog
SIMULATOR = vvp

SRC = d_latch.v dffe.v DFFtri.v reg.v and32.v decoder.v or32.v regfile.v
TB = regfile_tb.v

OUTPUT = regFile
VCD_FILE = $(OUTPUT).vcd

all: compile

compile:
	$(VERILOG_COMPILER) -o $(OUTPUT).vvp $(SRC) $(TB)

simulate: compile
	$(SIMULATOR) $(OUTPUT).vvp

clean:
	rm -f *.vvp *.vcd *diff.csv *actual.csv