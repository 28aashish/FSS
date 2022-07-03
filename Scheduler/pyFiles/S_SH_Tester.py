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
    Tester2  = open("./Scheduler/S_tester_SHAKTI/automate_Tester.cpp", 'w')

    stringer="""
#include <iostream>
using namespace std;
#define f_type float
#define BRAM_COUNT {0}
#define BRAM_DEPTH {1}"""
    Tester2.write(stringer.format(NUM_BRAM, 2**ADDR_WIDTH_DATA_BRAM ))
    Tester2.write("""
float int_to_float(int number);
int main(){

""")

    verification = open("./Scheduler/cppFiles/Verification_ALU.txt", 'r')
    Tester2.write(verification.read())
    
    verification = open("./Scheduler/S_tester_SHAKTI/BRAM_dump.h", 'r')
    Tester2.write(verification.read())
    
    Tester2.write("""
    int i,j,invalid_values;
    float delta,percent_error;

    //Verification for L
    cout<<"Verifying L values:-"<<endl;
    invalid_values = 0;
    for(int i=0;i<BRAM_COUNT;i++){
        for(int j=0;j<BRAM_DEPTH;j++){
            if(L[i][j] != -11110000){//It indicates that, that value of L does not exist
                delta = L[i][j]-int_to_float(bram_dump[i][j]);
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
                delta = U[i][j]-int_to_float(bram_dump[i][j]);
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

float int_to_float(int number){
    if(number == 0){
        return 0;
    }


    int i;
    int mantissa;
    int mantissa_binary[23]; //Mantissa is of 23 bits
    int exponent,actual_exp,sign;
    double d_ret;

    mantissa = number & 0x007fffff;
    exponent = (number & 0x7f800000)>>23;
    if(exponent == 0){
        actual_exp = -127 + 1;
    }
    else if(exponent == 255){
        printf("integer = %d, Not a float !!!\\n",number);
        return 0;
    }
    else{
        actual_exp = exponent - 127;
    }
    sign = (number & 0x80000000)>>31;

    //Initialize the binary array to 0
    for(int i=0;i<23;i++){
        mantissa_binary[i] = 0;
    }

    //converting to binary
    int temp_no = mantissa;
    int rem;
    i = 0;
    while(temp_no != 0){
        if(i==23){
            printf("Mantissa greater than 23 bits!!!\\n");
            return 0;
        }
        rem = temp_no %2;
        temp_no = temp_no/2;
        mantissa_binary[i] = rem;
        i++;
    }

    //populating the binary representation of fractional part

    //finding the integer part
    d_ret = 0;
    float weight = 1;
    for(int i=0;i<23;i++){
        weight = weight/2;
        d_ret = d_ret + weight*mantissa_binary[22-i];
    }
    if(exponent != 0){
        d_ret = d_ret + 1;
    }

    //finding the final value
    float power = 1;
    if(actual_exp>0){
        power = 2<<(actual_exp-1);
    }
    else{
        int pos_actual_exp = actual_exp * -1;
        for(i=0;i<pos_actual_exp;i++){
            power = power/2;
        }
    }
    d_ret = d_ret * power;

    if(sign == 1){
        d_ret = d_ret*-1;
    }
    return (float)d_ret;
}
""")