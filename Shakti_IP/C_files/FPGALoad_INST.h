
#define XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR 0x00050000
#include "uart.h"
#include "utils.h" 
int Inst[161][2] = {{1610612736, 0},{537154560, 15728704},{303104, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 2097152},{74448912, 14680080},{74448912, 6291536},{91226112, 12623936},{118489088, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 32},{32768, 0},{0, 144},{0, 9437184},{0, 13631488},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 10485920},{73401344, 5242880},{0, 8405088},{147849216, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 176},{0, 128},{262144, 9437184},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{16, 144},{-2147483648, 12583072},{156237824, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 0},{0, 13631488},{0, 0},{1, 0}};
int total_instructions = 161;
int sub_instructions = 2;


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
write_word(base + 15, 0); //Making enable 0
delay_FPGALoad_INST();
write_word(base + 16, 0); //Making write enable 0
delay_FPGALoad_INST();
//Writing 0 into BRAM
for(i=0;i<1024;i++){
write_word(base + 14, i); //Writing address
delay_FPGALoad_INST();
for(j=0;j<sub_instructions;j++){
write_word(base + (17+j), 0); //Writing data in din
delay_FPGALoad_INST();
}
write_word(base + 15, 1); //Making enable 1
delay_FPGALoad_INST();
write_word(base + 16, 1); //Making write enable 1
delay_FPGALoad_INST();
write_word(base + 15, 0); //Making enable 0
delay_FPGALoad_INST();
write_word(base + 16, 0); //Making write enable 0
delay_FPGALoad_INST();
}
}


//Function to verify if the data BRAMs is properly cleared
void verifyClearINSTBram(){
int i,j;
int val,error_count;
error_count = 0;
//Making enable and write enable zero for Instruction BRAM
write_word(base + 15, 0); //Making enable 0
delay_FPGALoad_INST();
write_word(base + 16, 0); //Making write enable 0
delay_FPGALoad_INST();
//Reading Instructions from BRAM
for(i=0;i<1024;i++){
write_word(base + 14, i); //Writing address,i is the offset
delay_FPGALoad_INST();
write_word(base + 15, 1); //Making enable 1
delay_FPGALoad_INST();
for(j=0;j<sub_instructions;j++){
val = read_word(base + (19+j)); //Reading from BRAM
delay_FPGALoad_INST();
if(val != 0){
error_count = error_count + 1;
}
}
write_word(base + 15, 0); //Making enable 0
delay_FPGALoad_INST();
}
printf("Initialization errors in INST BRAMs = %d\n",error_count);
}


//Function to write data into BRAM
void FPGALoadINST(){
int i,j;
//The base address of the LUD accelerator may needed to be changed. The base address assumed is 'base'
//Making enable and write_enable 0 for Instruction BRAMS
write_word(base + 15, 0); //Making enable 0
delay_FPGALoad_INST();
write_word(base + 16, 0); //Making write enable 0
delay_FPGALoad_INST();
//Writing Instructions into BRAM
for(i=0;i<total_instructions;i++){
write_word(base + 14, i); //Writing address,i is the offset
delay_FPGALoad_INST();
for(j=0;j<sub_instructions;j++){
write_word(base + (17+j), Inst[i][j]); //Writing data in din
delay_FPGALoad_INST();
}
write_word(base + 15, 1); //Making enable 1
delay_FPGALoad_INST();
write_word(base + 16, 1); //Making write enable 1
delay_FPGALoad_INST();
write_word(base + 15, 0); //Making enable 0
delay_FPGALoad_INST();
write_word(base + 16, 0); //Making write enable 0
delay_FPGALoad_INST();
}
}


//Function to verify if Instructions is properly loaded into BRAMs
void verify_INST_FPGALoad(){
int i,j,val_int;
//Making enable and write enable zero for Instruction BRAM
write_word(base + 15, 0); //Making enable 0
delay_FPGALoad_INST();
write_word(base + 16, 0); //Making write enable 0
delay_FPGALoad_INST();
//Reading Instructions from BRAM
for(i=0;i<total_instructions;i++){
write_word(base + 14, i); //Writing address,i is the offset
delay_FPGALoad_INST();
write_word(base + 15, 1); //Making enable 1
delay_FPGALoad_INST();
for(j=0;j<sub_instructions;j++){
val_int = read_word(base + (19+j)); //Reading from BRAM
delay_FPGALoad_INST();
if(val_int != Inst[i][j]){
printf("Error in verification, i = %d, j = %d, Correct value = %d, BRAM value = %d\n",i,j,Inst[i][j],val_int);
}
}
write_word(base + 15, 0); //Making enable 0
delay_FPGALoad_INST();
}
}


