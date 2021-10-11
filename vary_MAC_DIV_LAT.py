from io import StringIO
import json
import os
import subprocess

if __name__ == "__main__":
    MAX_BRAM=17
    MAX_NUM_MACDIV=33
    MAX_LAT=33
    f = open('./Scheduler/cppFiles/stdafx.h','w')
    stringer="""// All global header file includes
#ifndef _STDAFX_H_
#define _STDAFX_H_

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <iomanip>
#include <vector>
#include <string>
#include <map>
// For VS Only
#include <unordered_map>
#include <set>
#include <bits/stdc++.h>
#include <algorithm>
#include <utility>
#include <limits>
#include <tuple>
#include <fstream>

#ifdef DEFINE_VARIABLES
#define EXTERN                  
#define INITIALIZER(...)        = __VA_ARGS__
#else
#define EXTERN                  extern
#define INITIALIZER(...)       
#endif 

using namespace std;

/*******  Things to change  ***************************************************/
// defines the data type of the matrix values
#define f_type float

EXTERN f_type g_nzThreshold;
EXTERN f_type g_errThreshold;

// print debug messages
#define PRINT_DEBUG_MSG
// make graphical picture of graph
// #define MAKE_GRAPH
#define GRAPH_DPI "100"

#define CTRL_DELAY 2

// Hardware Requirements
#define instBRAMSize 4096
#define BRAMSize 1024

//IP Requirements
        
//Instruction BRAM Ports
#define PORT_of_BRAM 2
//Total Instruction BRAM 
//⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ at max 16
#define Total_BRAMs_for_Data {0}
//iff numMAC_DIVUnits = 4 i.e. 4 MAC Unit and 4 Div Unit
#define numMAC_DIVUnits {1}

//#define delay_DIV 31
//#define delay_MAC 22

#define delay_DIV {2}
#define delay_MAC {3}

// Map Delays
EXTERN map<string, int> opDelay INITIALIZER({{{{"+", 12}}, {{"-", 12}}, {{"*",9}}, {{"/", delay_DIV}}, {{"rd", 2}}, 
    {{"wr", 2}}, {{"mac_add", delay_MAC}}, {{"mac_sub",delay_MAC}}, {{"const", 0}}, {{"pass", 0}}}});

#define BRAMIndNULL -1
#define BRAMAddrNULL -1
#define BRAMPortNULL -1
#define BRAMIndConst -2
#define BRAMAddrConst0 0
#define BRAMAddrConst1 1
#define priorityNULL 0
#define levelNULL -1
#define nodeIdNULL -1
#define nodeIdStart 10
#define BRAM_WRITE 1
#define BRAM_READ 0
#define BRAM_NOTHING -1

#define SEL_BITSET_WIDTH 32
#define ADDR_BITSET_WIDTH 32
/******************************************************************************/


#ifdef PRINT_DEBUG_MSG
EXTERN ofstream debugFile;
// define three message levels
// #define PRINT_DEBUG_0
//#define PRINT_DEBUG_1
// #define PRINT_DEBUG_2
#endif

#endif

// #include <chrono>       // time seed generartion
// #include <random>       // random number generartion"""
    ans="""{0},{1},{2},{3},{4}
"""
#    i=8
#    j=31
#    k=22
#    f.write(stringer.format(i,j,k))
#    f.close()
    ansf = open('./analysis.csv','w')
    ansf.write("""NUM_BRAM.numMAC_DIVUnits,delay_DIV,delay_MAC
""")
    ansf.close()
    for i0 in range(2,MAX_BRAM,1):
        for i in range(1,MAX_NUM_MACDIV,1):
            for j in range(1,MAX_LAT,1):
                for k in range(1,MAX_LAT,1):
                    f = open('./Scheduler/cppFiles/stdafx.h','w')
                    print("NUM_BRAM {0} numMAC_DIVUnits {1} delay_DIV {2} delay_MAC {3}".format(i0,i,j,k))
                    f.write(stringer.format(i0,i,j,k))
                    f.close()
                    os.system('make all_nox TEST_MATRIX=rajat11')
                    os.system('make all_noy TEST_MATRIX=rajat11 > log')
                    x=subprocess.getoutput('grep Instructions log | cut -d " " -f 5')
                    ansf = open('./analysis.csv','a')
                    ansf.write(ans.format(i0,i,j,k,x))
                    ansf.close()

