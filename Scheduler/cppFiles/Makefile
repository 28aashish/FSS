CXX = g++
CXXFLAGS = -std=c++11 -O3 -w #-DMAKE_GRAPH# -DPRINT_DEBUG_1

MATLAB =/usr/local/bin/matlab
PYTHON3 = python3
TEST_MATRIX=rajat11


# CXXFLAGS = -std=c++0x -g

.PHONY: clean cleanall cleanPreprocess all run cbuild_only c_run

all: main

run:
	./main

# File dependency tree
CCS.o: CCS.h stdafx.h CCS.cpp
	$(CXX) $(CXXFLAGS) -c CCS.cpp

Graph.o: Graph.h stdafx.h Graph.cpp
	$(CXX) $(CXXFLAGS) -c Graph.cpp

sparseLU.o: stdafx.h CCS.h Graph.h sparseLU.h sparseLU.cpp
	$(CXX) $(CXXFLAGS) -c sparseLU.cpp

Schedule.o: stdafx.h Graph.h Schedule.h Schedule.cpp Hardware.h
	$(CXX) $(CXXFLAGS) -c Schedule.cpp

main.o: stdafx.h CCS.h Graph.h sparseLU.h Schedule.h Hardware.h main.cpp
	$(CXX) $(CXXFLAGS) -c main.cpp

main: CCS.o Graph.o sparseLU.o Schedule.o main.o
	$(CXX) $(CXXFLAGS) -o $@ $^

clean: 
	rm -f main main.o sparseLU.o Graph.o CCS.o Schedule.o *.dot *.json

buildPreprocessTests: processTests.o CCS.o
	$(CXX) $(CXXFLAGS) -o preprocessTest $^

preprocessTests:
	$(MATLAB) -nodisplay -nosplash -nodesktop -r "file='$(TEST_MATRIX)';save('filename','file');run('../matlabScripts/processMsparseMatrices.m'); exit;"
	$(PYTHON3) ../pyFiles/preprocess.py $(TEST_MATRIX)

processTests.o: stdafx.h CCS.h processTests.cpp
	$(CXX) $(CXXFLAGS) -c processTests.cpp	

cleanPreprocess:
	rm -f preprocessTest processTests.o

cleanall:
	rm -f *.mat *.o *.txt *.csv *.png *.dot main preprocessTest

cbuild_only:
	$(CXX) $(CXXFLAGS) -c processTests.cpp
	$(CXX) $(CXXFLAGS) -c CCS.cpp
	$(CXX) $(CXXFLAGS) -o preprocessTest processTests.o CCS.o
	$(PYTHON3) ../pyFiles/preprocess.py $(TEST_MATRIX)
	$(CXX) $(CXXFLAGS) -c Graph.cpp
	$(CXX) $(CXXFLAGS) -c sparseLU.cpp
	$(CXX) $(CXXFLAGS) -c Schedule.cpp
	$(CXX) $(CXXFLAGS) -c main.cpp
	$(CXX) $(CXXFLAGS) -o main CCS.o Graph.o sparseLU.o Schedule.o main.o
c_run:
	$(CXX) $(CXXFLAGS) -c processTests.cpp
	$(CXX) $(CXXFLAGS) -c CCS.cpp
	$(CXX) $(CXXFLAGS) -o preprocessTest processTests.o CCS.o
	$(PYTHON3) ../pyFiles/preprocess.py $(TEST_MATRIX)
	$(CXX) $(CXXFLAGS) -c Graph.cpp
	$(CXX) $(CXXFLAGS) -c sparseLU.cpp
	$(CXX) $(CXXFLAGS) -c Schedule.cpp
	$(CXX) $(CXXFLAGS) -c main.cpp
	$(CXX) $(CXXFLAGS) -o main CCS.o Graph.o sparseLU.o Schedule.o main.o
	./main $(TEST_MATRIX)
	
