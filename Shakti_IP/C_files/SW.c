
#define XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR 0x00050000
#include "uart.h"
#include "utils.h" 
#include "int_to_float.h" //Already included in the main file in xilinx sdk **new** 2018.+ version
#include "float_to_int.h" //Already included in the main file in xilinx sdk **new** 2018.+ version
uint32_t *base=(uint32_t *)XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR;
#include "FPGALoad_INST.h"
#include "FPGALoad_A.h" 


#define BRAMs 2
#define BRAMs_Size 128
    
int main()
{
    printf("\n\n\r");
    printf("/*\r\n");
    printf("-------------------Start of a new program  ------------------------------\n\r");
    printf("%d\r\n",read_word(base + 3) );

    //verify_ind_cycle();
    write_word(base + 2, 0); //Start = 0
    write_word(base + 0, 0); //Locked = 0
    write_word(base + 1, 1); //Reset = 1 i.e. Active Reset
    write_word(base + 1, 0); //Reset = 0

    clearINSTBram();
    verifyClearINSTBram();
    FPGALoadINST();
    verify_INST_FPGALoad();

    clearDataBRAM();
    verifyClearDataBRAM();
    FPGALoadA();
    verify_A_FPGALoad();
    //printf("%d\r\n",read_word(base + 3) );


    write_word(base + 0, 1); //Locked = 1
    write_word(base + 2, 1);

    //printf("%d\r\n",read_word(base + 3) );

    while(read_word(base + 3) != 1);
    //printf("LU decomposition completed\n\r");
    write_word(base + 2, 0);
    printf("*/\r\n");
    //printall();
    printf("/*\r\n");
    printf("-----------------------------------Finish Run--------------------------------------\n\n\n\r");
    printf("*/\r\n");


    return 0;
}
void printall()
{
	int i,j;
	unsigned int val;
    float val_float;
    printf("float bram_dump[%d][%d]=base;\r\n",BRAMs,BRAMs_Size);
	for(j = 0; j < BRAMs_Size;j++){
		for(i=0;i<BRAMs;i++){
    
	        write_word(base + (4+i), j); //Writing address
	        //delay();
	        write_word(base + (10+i), 1); //Making enable 1
	        //delay();
	        write_word(base + (12+i), 0); //Making write enable 0
	        //delay();
	        val = read_word(base + (8+i)); //Reading from dout
	        val_float = int_to_float(val);
	        //delay();
	        write_word(base + (10+i), 0); //Making enable 0

	        //delay();
	        //printf("Value(%d,%d) = 0x%x,(%d)\n",i,j,val_float,val);
	        //printf("Value(%d,%d) = 0x%x\n",i,j,val_float);
	        //printf("(%d)\n",val);
	        printf("bram_dump[%d][%d] =0x%x;\r\n",i,j,val_float);
		}
	}
}
