// All global header file includes
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
#define instBRAMSize 16384
#define BRAMSize 4096

//IP Requirements
        
//Instruction BRAM Ports
#define PORT_of_BRAM 1
//Total Instruction BRAM 
//⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ at max 16
#define Total_BRAMs_for_Data 4
//iff numMAC_DIVUnits = 4 i.e. 4 MAC Unit and 4 Div Unit
#define numMAC_DIVUnits 1

//#define delay_DIV 31
//#define delay_MAC 22

#define delay_DIV 10
#define delay_MAC 11

// Map Delays
EXTERN map<string, int> opDelay INITIALIZER({{"+", 12}, {"-", 12}, {"*",9}, {"/", delay_DIV}, {"rd", 2}, 
    {"wr", 2}, {"mac_add", delay_MAC}, {"mac_sub",delay_MAC}, {"const", 0}, {"pass", 0}});

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
// #include <random>       // random number generartion
