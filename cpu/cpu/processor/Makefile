VERILOG_COMPILER = iverilog
SIMULATOR = vvp

SRC = ./*.v ../../alu-main/*.v ../../mult-div/*.v ../../reg-file/dffe_ref.v ../../reg-file/reg.v ../../reg-file/DFFtri.v ../../reg-file/decoder.v ../../reg-file/regfile.v
TB = Wrapper_tb

OUTPUT = proc
VCD_FILE = $(OUTPUT).vcd
TEST_FILE = sort

all: compile

compile:
	$(VERILOG_COMPILER) -o $(OUTPUT).vvp $(SRC) -s $(TB) -P $(TB).FILE=\"$(TEST_FILE)\"

simulate: compile
	$(SIMULATOR) $(OUTPUT).vvp

clean:
	rm -f *.vvp *.vcd *diff.csv *actual.csv ./Test\ Files/Output\ Files/*