
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include "platform.h"
#include "xil_printf.h"
#include "psu_init.h"
#include "xparameters.h"
#include "xil_io.h"

int float_to_int(float number);
float int_to_float(int number);
void FPGALoadINST();
void FPGALoadA();
void verify();
void print_BRAM_values(int starting_address, int ending_address);

int main(){
	init_platform();
    xil_printf("Start of a new program  ------------------------------\n\r");

    //verify_ind_cycle();
    printf("\n\n\r");

    int pr_state,complete;

        Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*2, 0); //Start = 0
        delay();
        Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*0, 0); //Locked = 0
        delay();
        Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*1, 1); //Reset = 1
        delay();
        Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*1, 0); //Reset = 0
        delay();

        clearINSTBram();
        verifyClearINSTBram();
        FPGALoadINST();
        verify_INST_FPGALoad();

        clearDataBRAM();
        verifyClearDataBRAM();
        FPGALoadA();
        verify_A_FPGALoad();


        Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*0, 1); //Locked = 1
        delay();

        //Reading the state
        pr_state = Xil_In32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*51);
        delay();
        xil_printf("State = %d\n\r",pr_state);

        //Making start = 1
        Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*2, 1);
        delay();

        //Waiting for completion
        complete = 0;
        while(complete != 1){
            complete = Xil_In32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*3);
            delay();
        }
        xil_printf("LU decomposition completed\n\r");

        //Reading the state
        pr_state = Xil_In32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*51);
        delay();
        xil_printf("State = %d\n\r",pr_state);

        //Making start = 0
        Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*2, 0);
        delay();

        //Reading the state
        pr_state = Xil_In32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*51);
        delay();
        xil_printf("State = %d\n\r",pr_state);

        /*Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*1, 1); //Reset = 1
        delay();

        Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*0, 0); //Locked = 0
        delay();*/


       verify();
       //print_BRAM_values(0,2);

    cleanup_platform();
}
