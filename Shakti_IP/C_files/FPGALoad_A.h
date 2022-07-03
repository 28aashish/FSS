
#define XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR 0x00050000
#include "uart.h"
#include "utils.h" 

//Large arrays in FPGA should be declared global to prevent later issues
int A_size = 10;
float A[10] = {8, 1, 7, 5, 2, -2, 1, 2, -3, 9};


int A_BRAMInd_size = 10;
int A_BRAMInd[10] = {0, 1, 0, 1, 1, 0, 1, 0, 1, 0};


int A_BRAMAddr_size = 10;
int A_BRAMAddr[10] = {0, 0, 1, 1, 2, 3, 3, 5, 5, 6};


void delay_FPGALoad_A(){
int count = 100;
for(int i=0;i<count;){
i = i + 1;
}
}


//Function to initialize/clear data BRAMs
void clearDataBRAM(){
int i,j;
//Making enable and write_enable 0 for all the BRAMS
for(i=0;i<2;i++){
write_word(base + (10+i), 0); //Making enable 0
delay_FPGALoad_A();
write_word(base + (12+i), 0); //Making write enable 0
delay_FPGALoad_A();
}
for(i=0;i<2;i++){
for(j=0;j<128;j++){
write_word(base + (4+i), j); //Writing address,(4+i) is the offset
delay_FPGALoad_A();
write_word(base + (6+i), 0); //Writing data in din
delay_FPGALoad_A();
write_word(base + (10+i), 1); //Making enable 1
delay_FPGALoad_A();
write_word(base + (12+i), 1); //Making write enable 1
delay_FPGALoad_A();
write_word(base + (10+i), 0); //Making enable 0
delay_FPGALoad_A();
write_word(base + (12+i), 0); //Making write enable 0
delay_FPGALoad_A();
}
}
}


//Function to verify if the data BRAMs is properly cleared
void verifyClearDataBRAM(){
int i,j;
int val,error_count;
error_count = 0;
//Making enable and write_enable 0 for all the BRAMS
for(i=0;i<2;i++){
write_word(base + (10+i), 0); //Making enable 0
delay_FPGALoad_A();
write_word(base + (12+i), 0); //Making write enable 0
delay_FPGALoad_A();
}
for(i=0;i<2;i++){
for(j=0;j<128;j++){
write_word(base + (4+i), j); //Writing address,(4+i) is the offset
delay_FPGALoad_A();
write_word(base + (10+i), 1); //Making enable 1
delay_FPGALoad_A();
val = -1;
val = read_word(base + (8+i)); //Reading from BRAM
delay_FPGALoad_A();
write_word(base + (10+i), 0); //Making enable 0
delay_FPGALoad_A();
if(val != 0){
error_count = error_count + 1;
}
}
}
printf("Initialization errors in Data BRAMs = %d\n",error_count);
}


//Function to write data into BRAM
void FPGALoadA(){
int i;
int val_int;
//The base address of the LUD accelerator may needed to be changed. The base address assumed is 'base'
//Making enable and write_enable 0 for all the BRAMS
for(i=0;i<2;i++){
write_word(base + (10+i), 0); //Making enable 0
delay_FPGALoad_A();
write_word(base + (12+i), 0); //Making write enable 0
delay_FPGALoad_A();
}
//Writing A into BRAM
for(i=0;i<A_size;i++){
write_word(base + (4+A_BRAMInd[i]), A_BRAMAddr[i]); //Writing address,(4+A_BRAMInd[i]) is the offset
delay_FPGALoad_A();
val_int = float_to_int(A[i]);
write_word(base + (6+A_BRAMInd[i]), val_int); //Writing data in din
delay_FPGALoad_A();
write_word(base + (10+A_BRAMInd[i]), 1); //Making enable 1
delay_FPGALoad_A();
write_word(base + (12+A_BRAMInd[i]), 1); //Making write enable 1
delay_FPGALoad_A();
write_word(base + (10+A_BRAMInd[i]), 0); //Making enable 0
delay_FPGALoad_A();
write_word(base + (12+A_BRAMInd[i]), 0); //Making write enable 0
delay_FPGALoad_A();
}
}


//Function to verify if A matrix is properly loaded into BRAMs
void verify_A_FPGALoad(){
int val_int, i;
float val;
float diff;
//Making enable and write_enable 0 for all the BRAMS
for(i=0;i<2;i++){
write_word(base + (10+i), 0); //Making enable 0
delay_FPGALoad_A();
write_word(base + (12+i), 0); //Making write enable 0
delay_FPGALoad_A();
}
//Reading A from BRAM
for(i=0;i<A_size;i++){
write_word(base + (4+A_BRAMInd[i]), A_BRAMAddr[i]); //Writing address,(4+A_BRAMInd[i]) is the offset
delay_FPGALoad_A();
write_word(base + (10+A_BRAMInd[i]), 1); //Making enable 1
delay_FPGALoad_A();
val_int = read_word(base + (8+A_BRAMInd[i])); //Reading from BRAM
delay_FPGALoad_A();
write_word(base + (10+A_BRAMInd[i]), 0); //Making enable 0
delay_FPGALoad_A();
val = int_to_float(val_int);
diff = val - A[i];
if(diff < -0.000001 || diff > 0.000001){
printf("Error in verification, index = %d, correct value = %f, BRAM value = %f\n",i,A[i],val);
}
}
}
