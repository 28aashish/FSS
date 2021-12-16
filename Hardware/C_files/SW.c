
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include <xil_types.h>
#include "xparameters.h"
#include "xil_io.h"
#include "FPGALoad_INST.h"
#include "FPGALoad_A.h"
#define BRAMs 10
#define BRAMs_Size 1024
    
int main()
{
    init_platform();
    printf("\n\n\r");
    printf("/*\r\n");
    xil_printf("-------------------Start of a new program  ------------------------------\n\r");
    xil_printf("%d\r\n",Xil_In32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*3) );

    //verify_ind_cycle();
    Xil_Out32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*2, 0); //Start = 0
    Xil_Out32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*0, 0); //Locked = 0
    Xil_Out32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*1, 1); //Reset = 1 i.e. Active Reset
    Xil_Out32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*1, 0); //Reset = 0

    clearINSTBram();
    verifyClearINSTBram();
    FPGALoadINST();
    verify_INST_FPGALoad();

    clearDataBRAM();
    verifyClearDataBRAM();
    FPGALoadA();
    verify_A_FPGALoad();
    //xil_printf("%d\r\n",Xil_In32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*3) );


    Xil_Out32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*0, 1); //Locked = 1
    Xil_Out32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*2, 1);

    //xil_printf("%d\r\n",Xil_In32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*3) );

    while(Xil_In32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*3) != 1);
    //xil_printf("LU decomposition completed\n\r");
    Xil_Out32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*2, 0);
    printf("*/\r\n");
    //printall();
    printf("/*\r\n");
    xil_printf("-----------------------------------Finish Run--------------------------------------\n\n\n\r");
    printf("*/\r\n");

    cleanup_platform();

    return 0;
}
void printall()
{
	int i,j;
	unsigned int val;
    float val_float;
    printf("float bram_dump[%d][%d]={0};\r\n",BRAMs,BRAMs_Size);
	for(j = 0; j < BRAMs_Size;j++){
		for(i=0;i<BRAMs;i++){
    
	        Xil_Out32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*(4+i), j); //Writing address
	        //delay();
	        Xil_Out32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*(34+i), 1); //Making enable 1
	        //delay();
	        Xil_Out32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*(44+i), 0); //Making write enable 0
	        //delay();
	        val = Xil_In32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*(24+i)); //Reading from dout
	        val_float = int_to_float(val);
	        //delay();
	        Xil_Out32(XPAR_MYIP_AXI_LUD_WRAPPER_0_BASEADDR + 4*(34+i), 0); //Making enable 0

	        //delay();
	        //printf("Value(%d,%d) = %7.4e,(%d)\n",i,j,val_float,val);
	        //printf("Value(%d,%d) = %7.4e\n",i,j,val_float);
	        //printf("(%d)\n",val);
	        printf("bram_dump[%d][%d] =%7.4e;\r\n",i,j,val_float);
		}
	}
}
