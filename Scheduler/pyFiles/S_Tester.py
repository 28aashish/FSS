from io import StringIO
import os
import math
import json


if __name__ == "__main__":
    f = open('./Scheduler/cppFiles/IO.json')
    
    # returns JSON object as
    # a dictionary
    data = json.load(f)
    NUM_PORT=data['NUM_PORT']
    NUM_BRAM=data['NUM_BRAM']
    NUM_MAC_DIV_S=data['NUM_MAC_DIV_S']
    ADDR_WIDTH=data['ADDR_WIDTH']
    ADDR_WIDTH_DATA_BRAM=data['ADDR_WIDTH_DATA_BRAM']
    CTRL_WIDTH=data['CTRL_WIDTH']
    AU_SEL_WIDTH=data['AU_SEL_WIDTH']
    BRAM_SEL_WIDTH=data['BRAM_SEL_WIDTH']
    # Iterating through the json
    # list 
    # Closing file
    f.close()
    Tester  = open("./Scheduler/S_tester/automate_Tester.cpp", 'w')

    stringer="""
#include <iostream>
using namespace std;
#define f_type float
#define BRAM_COUNT {0}
#define BRAM_DEPTH {1}"""
    Tester.write(stringer.format(NUM_BRAM, 2**ADDR_WIDTH_DATA_BRAM ))
    Tester.write("""
int main(){

""")
    verification = open("./Scheduler/cppFiles/Verification_ALU.txt", 'r')
    Tester.write(verification.read())
    
    verification = open("./Scheduler/S_tester/BRAM_dump.h", 'r')
    Tester.write(verification.read())
    
    Tester.write("""
    int i,j,invalid_values;
    float delta,percent_error;

    //Verification for L
    cout<<"Verifying L values:-"<<endl;
    invalid_values = 0;
    for(int i=0;i<BRAM_COUNT;i++){
        for(int j=0;j<BRAM_DEPTH;j++){
            if(L[i][j] != -11110000){//It indicates that, that value of L does not exist
                delta = L[i][j]-bram_dump[i][j];
                if(L[i][j] != 0){
                    percent_error = (delta/L[i][j])*100;
                    if(percent_error>5 || percent_error<-5){
                        invalid_values = invalid_values + 1;
                        //cout<<"i = "<<i<<", j = "<<j<<", percent_error = "<<percent_error<<"%, L["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"] = "<<L[i][j]<<endl;
                        cout<<"L["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"], percent_error = "<<percent_error<<"%, correct value = "<<L[i][j]<<", calculated value = "<<bram_dump[i][j]<<endl;
                    }
                }
                else if(delta<-0.0001 || delta>0.0001){
                    invalid_values = invalid_values + 1;
                    //cout<<"i = "<<i<<", j = "<<j<<", delta = "<<delta<<", L["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"] = "<<L[i][j]<<"--------------------------------------"<<endl;
                    cout<< "L["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"], delta = " << delta <<", correct value = "<<L[i][j]<<", calculated value = "<<bram_dump[i][j]<<endl;
                }
            }
        }
    }

    cout<<"Invalid Values = "<<invalid_values<<endl<<endl;

    //Verification for U
    cout<<"Verifying U values:-"<<endl;
    invalid_values = 0;
    for(int i=0;i<BRAM_COUNT;i++){
        for(int j=0;j<BRAM_DEPTH;j++){
            if(U[i][j] != -11110000){//It indicates that, that value of L does not exist
                delta = U[i][j]-bram_dump[i][j];
                if(U[i][j] != 0){
                    percent_error = (delta/U[i][j])*100;
                    if(percent_error>5 || percent_error<-5){
                        invalid_values = invalid_values + 1;
                        //cout<<"i = "<<i<<", j = "<<j<<", percent_error = "<<percent_error<<"%, U["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"] = "<<U[i][j]<<endl;
                        cout<<"U["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"], percent_error = "<<percent_error<<"%, correct value = "<<U[i][j]<<", calculated value = "<<bram_dump[i][j]<<endl;
                    }
                }
                else if(delta<-0.0001 || delta>0.0001){
                    invalid_values = invalid_values + 1;
                    //cout<<"i = "<<i<<", j = "<<j<<", delta = "<<delta<<", U["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"] = "<<U[i][j]<<"--------------------------------------"<<endl;
                    cout<< "U["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"], delta = " << delta <<", correct value = "<<U[i][j]<<", calculated value = "<<bram_dump[i][j]<<endl;
                }
            }
        }
    }

    cout<<"Invalid Values = "<<invalid_values<<endl;

    return 0;
}
    """)