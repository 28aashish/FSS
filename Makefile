TEST_MATRIX =
PYTHON3 = python3
.PHONY: clean preprocess process all all_wo_matlab build_wo_matlab run_wo_matlab cleanall cleanup all_graph 

#all: cleanall preprocess process buildHardware
all: cleanall preprocess process buildHardware buildShakti_IP buildASIC
all_mat: cleanall preprocess buildHardware
all_wo_matlab: cleanall 
	(cd Scheduler/cppFiles; make c_run)
	
build_wo_matlab: cleanall
	(cd Scheduler/cppFiles;make cbuild_only)

run_wo_matlab:
	(cd Scheduler/cppFiles; ./main $(TEST_MATRIX))

all_graph: cleanall preprocess process grapher
#all_graph: cleanall process grapher

buildHardware:
	(yes | cp -if ./Scheduler/cppFiles/IO.json ./Hardware/IO.json)
	(yes | cp -if ./Scheduler/cppFiles/*.svh ./Hardware/autoFiles/SVFile)
	(yes | cp -if ./Scheduler/cppFiles/FPGA*.h ./Hardware/C_files)
	(yes | cp -if ./Scheduler/cppFiles/float_to_int.h ./Hardware/C_files)
	(yes | cp -if ./Scheduler/cppFiles/int_to_float.h ./Hardware/C_files)
	(cd ./Hardware;$(PYTHON3) ../Scheduler/pyFiles/HDL_inteconnect.py)
	(cd ./Hardware;$(PYTHON3) ../Scheduler/pyFiles/Verilog_inteconnect.py)
	${PYTHON3} ./Scheduler/pyFiles/SW_Code.py

buildShakti_IP:
	(yes | cp -if ./Scheduler/cppFiles/IO.json ./Shakti_IP/IO.json)
	(cd ./Shakti_IP/verilog;rm -f ./*.v)
	(cp ./Hardware/autoFiles/VFile/*.v ./Shakti_IP/verilog)
	(cp ./Hardware/autoFiles/VFile/const_file/*.v ./Shakti_IP/verilog)
	(cd ./Shakti_IP/C_files;rm -f ./*.h)
	(cd ./Shakti_IP/C_files;rm -f ./*.c)
	(yes | cp -if ./Scheduler/cppFiles/FPGA*.h ./Shakti_IP/C_files)
	(yes | cp -if ./Scheduler/cppFiles/float_to_int.h ./Shakti_IP/C_files)
	(yes | cp -if ./Scheduler/cppFiles/int_to_float.h ./Shakti_IP/C_files)
	(yes | cp -if ./Hardware/C_files/SW.c ./Shakti_IP/C_files)
	(cd ./Shakti_IP;$(PYTHON3) ../Scheduler/pyFiles/Shakti_IP.py)

buildASIC:
	(yes | cp -if ./Scheduler/cppFiles/IO.json ./ASIC/IO.json)
	(cd ./ASIC/verilog/autoFiles;rm -f ./*.v)
	(cp ./Hardware/autoFiles/VFile/*.v ./ASIC/verilog/autoFiles)
	(cp ./Hardware/autoFiles/VFile/const_file/*.v ./ASIC/verilog/autoFiles)
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
#(cd Scheduler/test; rm -f *.csv)
#(rm -rf Scheduler/test/exported)

#Vers2018:
# 	(sed -i "s/.BRAM_PORTA_/.BRAM_PORTA_0_/g" ./Hardware/autoFiles/VFile/*.v)
# 	(sed -i "s/.BRAM_PORTB_/.BRAM_PORTB_0_/g" ./Hardware/autoFiles/VFile/*.v)
# 	(sed -i "s/.M_AXIS_RESULT_/.M_AXIS_RESULT_0_/g" ./Hardware/autoFiles/VFile/*.v)
# 	(sed -i "s/.S_AXIS_A_/.S_AXIS_A_0_/g" ./Hardware/autoFiles/VFile/*.v)
# 	(sed -i "s/.S_AXIS_B_/.S_AXIS_B_0_/g" ./Hardware/autoFiles/VFile/*.v)
# 	(sed -i "s/.S_AXIS_C_/.S_AXIS_C_0_/g" ./Hardware/autoFiles/VFile/*.v)
# 	(sed -i "s/.S_AXIS_OPERATION_/.S_AXIS_OPERATION_0_/g" ./Hardware/autoFiles/VFile/*.v)