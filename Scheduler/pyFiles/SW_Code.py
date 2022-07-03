from io import StringIO
import json


if __name__ == "__main__":
    f = open('./Scheduler/cppFiles/IO.json',)
    
    # returns JSON object as
    # a dictionary
    data = json.load(f)
    Xpara_Name=str(data["Xpara_Name"])
    print(Xpara_Name)
    NUM_PORT=data['NUM_PORT']
    NUM_BRAM=data['NUM_BRAM']
    NUM_MAC_DIV_S=data['NUM_MAC_DIV_S']
    ADDR_WIDTH=data['ADDR_WIDTH']
    ADDR_WIDTH_DATA_BRAM=data['ADDR_WIDTH_DATA_BRAM']
    CTRL_WIDTH=data['CTRL_WIDTH']
    AU_SEL_WIDTH=data['AU_SEL_WIDTH']
    BRAM_SEL_WIDTH=data['BRAM_SEL_WIDTH']
    s_addr = 4
    s_din  = s_addr+NUM_BRAM
    s_dout = s_din+NUM_BRAM
    s_en   = s_dout+NUM_BRAM
    s_we   = s_en+NUM_BRAM
    # Iterating through the json
    # list 
    # Closing file
    f.close()
    SW = open('./FPGA/C_files/SW.c','w')
    SW.write("""
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include <xil_types.h>
#include "xparameters.h"
#include "xil_io.h"
#include "FPGALoad_INST.h"
#include "FPGALoad_A.h"
""")
    stringer="""#define BRAMs {0}
#define BRAMs_Size {1}
    """
    SW.write(stringer.format(NUM_BRAM,2**ADDR_WIDTH_DATA_BRAM))
    stringer="""
int main()
{{
    init_platform();
    printf("\\n\\n\\r");
    printf("/*\\r\\n");
    xil_printf("-------------------Start of a new program  ------------------------------\\n\\r");
    xil_printf("%d\\r\\n",Xil_In32({0} + 4*3) );

    //verify_ind_cycle();
    Xil_Out32({0} + 4*2, 0); //Start = 0
    Xil_Out32({0} + 4*0, 0); //Locked = 0
    Xil_Out32({0} + 4*1, 1); //Reset = 1 i.e. Active Reset
    Xil_Out32({0} + 4*1, 0); //Reset = 0

    clearINSTBram();
    verifyClearINSTBram();
    FPGALoadINST();
    verify_INST_FPGALoad();

    clearDataBRAM();
    verifyClearDataBRAM();
    FPGALoadA();
    verify_A_FPGALoad();
    //xil_printf("%d\\r\\n",Xil_In32({0} + 4*3) );


    Xil_Out32({0} + 4*0, 1); //Locked = 1
    Xil_Out32({0} + 4*2, 1);

    //xil_printf("%d\\r\\n",Xil_In32({0} + 4*3) );

    while(Xil_In32({0} + 4*3) != 1);
    //xil_printf("LU decomposition completed\\n\\r");
    Xil_Out32({0} + 4*2, 0);
    printf("*/\\r\\n");
    //printall();
    printf("/*\\r\\n");
    xil_printf("-----------------------------------Finish Run--------------------------------------\\n\\n\\n\\r");
    printf("*/\\r\\n");

    cleanup_platform();

    return 0;
}}
void printall()
{{
	int i,j;
	unsigned int val;
    float val_float;
    printf("float bram_dump[%d][%d]={0};\\r\\n",BRAMs,BRAMs_Size);
	for(j = 0; j < BRAMs_Size;j++){{
		for(i=0;i<BRAMs;i++){{
    """
    SW.write(stringer.format(Xpara_Name))
    stringer="""
	        Xil_Out32({3} + 4*(4+i), j); //Writing address
	        //delay();
	        Xil_Out32({3} + 4*({0}+i), 1); //Making enable 1
	        //delay();
	        Xil_Out32({3} + 4*({1}+i), 0); //Making write enable 0
	        //delay();
	        val = Xil_In32({3} + 4*({2}+i)); //Reading from dout
	        val_float = int_to_float(val);
	        //delay();
	        Xil_Out32({3} + 4*({0}+i), 0); //Making enable 0
"""
    SW.write(stringer.format(s_en,s_we,s_dout,Xpara_Name))
    SW.write("""
	        //delay();
	        //printf("Value(%d,%d) = %7.4e,(%d)\\n",i,j,val_float,val);
	        //printf("Value(%d,%d) = %7.4e\\n",i,j,val_float);
	        //printf("(%d)\\n",val);
	        printf("bram_dump[%d][%d] =%7.4e;\\r\\n",i,j,val_float);
		}
	}
}
""")