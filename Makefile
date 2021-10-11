
TEST_MATRIX =
PYTHON3 = python3
.PHONY: clean preprocess process all all_wo_matlab build_wo_matlab run_wo_matlab cleanall cleanup all_graph 

#all: cleanall preprocess process buildHardware
all: cleanall preprocess process buildHardware
all_mat: cleanall preprocess buildHardware

all_wo_matlab: cleanall
	(cd Scheduler/cppFiles;make c_run)

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
	${PYTHON3} ./Scheduler/pyFiles/SW_Code.py

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
