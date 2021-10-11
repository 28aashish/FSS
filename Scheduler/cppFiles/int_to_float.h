#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

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
        printf("integer = %d, Not a float !!!\n",number);
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
            printf("Mantissa greater than 23 bits!!!\n");
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
