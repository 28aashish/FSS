
#define XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR 0x00050000
#include "uart.h"
#include "utils.h" 
int Inst[54][3] = {{0, 0, 0},{212992, 524288, 0},{281600, 536870912, 1},{0, 1073741824, 0},{172032, 0, 0},{0, 0, 0},{0, 0, 0},{0, 0, 0},{0, 0, 0},{0, 0, 0},{0, 0, 1},{1148190848, 262144, 0},{1248854032, 128, 0},{183500800, 1049088, 0},{106955776, 1611137024, 0},{120586240, 0, 0},{0, 0, 0},{0, 0, 0},{0, 0, 0},{0, 0, 0},{0, 0, 0},{0, -2147483648, 0},{131072, 384, 0},{0, 1835008, 0},{1879048192, -536870912, 0},{0, 640, 0},{805306368, 0, 0},{536870912, 256, 0},{360448, 0, 0},{0, 0, 0},{0, 0, 0},{1610612736, 768, 0},{174064640, -1610612736, 0},{0, 0, 0},{0, 0, 0},{0, 0, 0},{0, 0, 0},{0, 0, 0},{805306370, 0, 0},{536870912, -1072168960, 0},{89653248, 0, 0},{0, 0, 0},{0, 0, 0},{0, 896, 0},{0, 0, 0},{0, 0, 0},{0, 0, 0},{0, 0, 0},{0, 0, 0},{0, 0, 0},{0, 0, 0},{0, 1835008, 0},{0, 0, 0},{1, 0, 0}};
int total_instructions = 54;
int sub_instructions = 3;


void delay_FPGALoad_INST(){
int count = 100;
for(int i=0;i<count;){
i = i + 1;
}
}


//Function to initialize/clear the Inst BRAM
void clearINSTBram(){
int i,j;
//Making enable and write_enable 0 for Instruction BRAMS
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*25, 0); //Making enable 0
delay_FPGALoad_INST();
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*26, 0); //Making write enable 0
delay_FPGALoad_INST();
//Writing 0 into BRAM
for(i=0;i<4096;i++){
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*24, i); //Writing address
delay_FPGALoad_INST();
for(j=0;j<sub_instructions;j++){
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*(27+j), 0); //Writing data in din
delay_FPGALoad_INST();
}
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*25, 1); //Making enable 1
delay_FPGALoad_INST();
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*26, 1); //Making write enable 1
delay_FPGALoad_INST();
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*25, 0); //Making enable 0
delay_FPGALoad_INST();
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*26, 0); //Making write enable 0
delay_FPGALoad_INST();
}
}


//Function to verify if the data BRAMs is properly cleared
void verifyClearINSTBram(){
int i,j;
int val,error_count;
error_count = 0;
//Making enable and write enable zero for Instruction BRAM
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*25, 0); //Making enable 0
delay_FPGALoad_INST();
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*26, 0); //Making write enable 0
delay_FPGALoad_INST();
//Reading Instructions from BRAM
for(i=0;i<4096;i++){
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*24, i); //Writing address,i is the offset
delay_FPGALoad_INST();
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*25, 1); //Making enable 1
delay_FPGALoad_INST();
for(j=0;j<sub_instructions;j++){
val = (int *)(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*(30+j)); //Reading from BRAM
delay_FPGALoad_INST();
if(val != 0){
error_count = error_count + 1;
}
}
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*25, 0); //Making enable 0
delay_FPGALoad_INST();
}
printf("Initialization errors in INST BRAMs = %d\n",error_count);
}


//Function to write data into BRAM
void FPGALoadINST(){
int i,j;
//The base address of the LUD accelerator may needed to be changed. The base address assumed is 'XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR'
//Making enable and write_enable 0 for Instruction BRAMS
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*25, 0); //Making enable 0
delay_FPGALoad_INST();
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*26, 0); //Making write enable 0
delay_FPGALoad_INST();
//Writing Instructions into BRAM
for(i=0;i<total_instructions;i++){
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*24, i); //Writing address,i is the offset
delay_FPGALoad_INST();
for(j=0;j<sub_instructions;j++){
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*(27+j), Inst[i][j]); //Writing data in din
delay_FPGALoad_INST();
}
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*25, 1); //Making enable 1
delay_FPGALoad_INST();
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*26, 1); //Making write enable 1
delay_FPGALoad_INST();
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*25, 0); //Making enable 0
delay_FPGALoad_INST();
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*26, 0); //Making write enable 0
delay_FPGALoad_INST();
}
}


//Function to verify if Instructions is properly loaded into BRAMs
void verify_INST_FPGALoad(){
int i,j,val_int;
//Making enable and write enable zero for Instruction BRAM
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*25, 0); //Making enable 0
delay_FPGALoad_INST();
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*26, 0); //Making write enable 0
delay_FPGALoad_INST();
//Reading Instructions from BRAM
for(i=0;i<total_instructions;i++){
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*24, i); //Writing address,i is the offset
delay_FPGALoad_INST();
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*25, 1); //Making enable 1
delay_FPGALoad_INST();
for(j=0;j<sub_instructions;j++){
val_int = (int *)(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*(30+j)); //Reading from BRAM
delay_FPGALoad_INST();
if(val_int != Inst[i][j]){
printf("Error in verification, i = %d, j = %d, Correct value = %d, BRAM value = %d\n",i,j,Inst[i][j],val_int);
}
}
write_word(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*25, 0); //Making enable 0
delay_FPGALoad_INST();
}
}


