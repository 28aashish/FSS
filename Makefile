TEST_MATRIX =
PYTHON3 = python3
SHELL := /bin/bash
.PHONY: clean preprocess process all all_wo_matlab build_wo_matlab run_wo_matlab cleanall cleanup all_graph 

#all: cleanall preprocess process buildFPGA
all: cleanall preprocess process buildFPGA buildShakti_IP buildASIC
all_mat: cleanall preprocess buildFPGA
all_wo_matlab: cleanall 
	(cd Scheduler/cppFiles; make c_run)
	
build_wo_matlab: cleanall
	(cd Scheduler/cppFiles;make cbuild_only)

run_wo_matlab:
	(cd Scheduler/cppFiles; ./main $(TEST_MATRIX))

all_graph: cleanall preprocess process grapher
#all_graph: cleanall process grapher

buildFPGA:
	(yes | cp -if ./Scheduler/cppFiles/IO.json ./FPGA/IO.json)
	(yes | cp -if ./Scheduler/cppFiles/*.svh ./FPGA/autoFiles/SVFile)
	(yes | cp -if ./Scheduler/cppFiles/FPGA*.h ./FPGA/C_files)
	(yes | cp -if ./Scheduler/cppFiles/float_to_int.h ./FPGA/C_files)
	(yes | cp -if ./Scheduler/cppFiles/int_to_float.h ./FPGA/C_files)
	(cd ./FPGA;$(PYTHON3) ../Scheduler/pyFiles/HDL_inteconnect.py)
	(cd ./FPGA;$(PYTHON3) ../Scheduler/pyFiles/Verilog_inteconnect.py)
	${PYTHON3} ./Scheduler/pyFiles/SW_Code.py

buildShakti_IP: buildFPGA
	(yes | cp -if ./Scheduler/cppFiles/IO.json ./Shakti_IP/IO.json)
	(cd ./Shakti_IP/verilog;rm -f ./*.v)
	(cp ./FPGA/autoFiles/VFile/*.v ./Shakti_IP/verilog)
	(cp ./FPGA/autoFiles/VFile/const_file/*.v ./Shakti_IP/verilog)
	(cd ./Shakti_IP/C_files;rm -f ./*.h)
	(cd ./Shakti_IP/C_files;rm -f ./*.c)
	(yes | cp -if ./Scheduler/cppFiles/FPGA*.h ./Shakti_IP/C_files)
	(yes | cp -if ./Scheduler/cppFiles/float_to_int.h ./Shakti_IP/C_files)
	(yes | cp -if ./Scheduler/cppFiles/int_to_float.h ./Shakti_IP/C_files)
	(yes | cp -if ./FPGA/C_files/SW.c ./Shakti_IP/C_files)
	(cd ./Shakti_IP;$(PYTHON3) ../Scheduler/pyFiles/Shakti_IP.py)

buildASIC: buildFPGA
	(yes | cp -if ./Scheduler/cppFiles/IO.json ./ASIC/IO.json)
	(cd ./ASIC/verilog/autoFiles;rm -f ./*.v)
	(cp ./FPGA/autoFiles/VFile/*.v ./ASIC/verilog/autoFiles)
	(cp ./FPGA/autoFiles/VFile/const_file/*.v ./ASIC/verilog/autoFiles)
	(cd ./ASIC;$(PYTHON3) ../Scheduler/pyFiles/ASIC_IP.py)
	
buildHDtest:
	$(PYTHON3) ./Scheduler/pyFiles/S_Tester.py
	(cd ./Scheduler/S_tester;$(CXX) automate_Tester.cpp)
	(cd ./Scheduler/S_tester;./a.out)
	
cleanall:
	(cd Scheduler/cppFiles; make cleanall)

preprocess:
	(cd Scheduler/cppFiles; make buildPreprocessTests)
	(cd Scheduler/cppFiles; make preprocessTests)

process:
	(cd Scheduler/cppFiles; make all TEST_MATRIX=$(TEST_MATRIX))
	(cd Scheduler/cppFiles; ./main $(TEST_MATRIX))

grapher:
	(pwd)
	(dot -Tsvg ./Scheduler/cppFiles/exeTree.dot -o ../../test/exported/$(TEST_MATRIX)/FPGA_output.svg)

cleanup:
	(cd Scheduler/cppFiles; make clean)
	(cd Scheduler/cppFiles; make cleanPreprocess)
	(cd Scheduler/test; rm -f *.csv)
	(rm -rf Scheduler/test/exported)

V18:
	$(SHELL) ./Scheduler/bash/Ver2018.sh ./FPGA/autoFiles/VFile
#	$(SHELL) ./Scheduler/bash/Ver2018.sh ./ASIC/verilog/autoFiles
#	$(SHELL) ./Scheduler/bash/Ver2018.sh ./Shakti_IP/verilog
openRAM:
	(cd ./ASIC/OpenRAM_config;../../Scheduler/bash/openRAM.sh)

