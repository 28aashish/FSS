/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include <xil_types.h>
#include "xparameters.h"
#include "xil_io.h"
#include "FPGALoad_INST.h"
#include "FPGALoad_A.h"
//#include "float_to_int.h"
#include "verify_values.h"

int main()
{
    init_platform();
    print("Start0\n\n");
    Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*2, 0); //Start = 0
    Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*0, 0); //Locked = 0
    Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*1, 1); //Reset = 1
    xil_printf("Reset\n");
    Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*1, 0); //Reset = 0

    print("Load_INST\n\n");
    clearINSTBram();
    verifyClearINSTBram();
    FPGALoadINST();
    verify_INST_FPGALoad();
    print("Complete_INST\n\n");
    clearDataBRAM();
    verifyClearDataBRAM();
    FPGALoadA();
    verify_A_FPGALoad();
    print("Complete_Data\n\n");
    Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*2, 1);
    xil_printf("Start1\n\n");
    Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*2, 0);
    while(Xil_In32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*3) != 1);
    xil_printf("LU D completed\n\n");
    print_BRAM_values(0,4);
    verify();
    return 0;
}
