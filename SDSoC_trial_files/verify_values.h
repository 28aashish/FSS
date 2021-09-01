int tmp=5;
float L[4][5];
float U[4][5];
float bram_dump[4][5];
int row_ind[4][5];
int col_ind[4][5];


void delay(){
	int count = 10;
	for(int i=0;i<count;){
		i = i+1;
	}
}

void verify(){

int i,j;
int val;
float val_float;
for(i=0;i<4;i++){
for(j=0;j<tmp;j++){
L[i][j] = -11110000; U[i][j] = -11110000;
row_ind[i][j] = -1; col_ind[i][j] = -1;
}
}

L[2][0] = -0.25;   row_ind[2][0] = 2;   col_ind[2][0] = 1;   // L(2,1)
L[1][1] = 1;   row_ind[1][1] = 4;   col_ind[1][1] = 2;   // L(4,2)
L[3][1] = 0.71428573;   row_ind[3][1] = 4;   col_ind[3][1] = 3;   // L(4,3)
U[0][0] = 4;   row_ind[0][0] = 0;   col_ind[0][0] = 0;   // U(0,0)
U[1][0] = 4;   row_ind[1][0] = 1;   col_ind[1][0] = 1;   // U(1,1)
U[3][0] = 8;   row_ind[3][0] = 1;   col_ind[3][0] = 2;   // U(1,2)
U[0][1] = 2;   row_ind[0][1] = 2;   col_ind[0][1] = 2;   // U(2,2)
U[2][1] = 7;   row_ind[2][1] = 3;   col_ind[2][1] = 3;   // U(3,3)
U[0][2] = 3;   row_ind[0][2] = 0;   col_ind[0][2] = 4;   // U(0,4)
U[1][2] = 5;   row_ind[1][2] = 3;   col_ind[1][2] = 4;   // U(3,4)
U[2][2] = -0.57142878;   row_ind[2][2] = 4;   col_ind[2][2] = 4;   // U(4,4)


//making we 0 for all the BRAMS
for(i=0;i<4;i++){
	Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*(16+i), 0); //Making enable 0
    //delay();
    Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*(20+i), 0); //Making write enable 0
    //delay();
}


    //BRAM dump
    for(i=0;i<4;i++){
    	for(j = 0; j < tmp;j++){

	        Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*(4+i), j); //Writing address
	        //delay();
	        Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*(16+i), 1); //Making enable 1
	        //delay();
	        val = Xil_In32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*(12+i)); //Reading from dout
	        //delay();
	        Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*(16+i), 0); //Making write enable 0
	        //delay();

	        val_float = int_to_float(val);
	        bram_dump[i][j] = val_float;
		}
	}

    int invalid_values;
    float delta,percent_error;

    //Verification for L
    printf("Verification L :-\n");
    invalid_values = 0;
    for(i=0;i<4;i++){
        for(j=0;j<tmp;j++){
            if(L[i][j] != -11110000){//It indicates that, that value of L does not exist
                delta = L[i][j]-bram_dump[i][j];
                if(L[i][j] != 0){
                    percent_error = (delta/L[i][j])*100;
                    if(percent_error>5 || percent_error<-5){
                        invalid_values = invalid_values + 1;
                        printf("i = %d, j = %d, percent_error = %f %%, L[%d][%d] = %f, BRAM_dump = %f\n",i,j,percent_error,row_ind[i][j],col_ind[i][j],L[i][j],bram_dump[i][j]);
                    }
                }
                else if(delta<-0.0001 || delta>0.0001){
                    invalid_values = invalid_values + 1;
                    printf("i = %d, j = %d, delta = %f, L[%d][%d] = %f, BRAM_dump = %f \n",i,j,delta,row_ind[i][j],col_ind[i][j],L[i][j],bram_dump[i][j]);
                }
            }
        }
    }

    printf("Invalid = %d \n",invalid_values);

    //Verification for U
    printf("Verification U :-\n");
    invalid_values = 0;
    for(i=0;i<4;i++){
        for(j=0;j<tmp;j++){
            if(U[i][j] != -11110000){//It indicates that, that value of L does not exist
                delta = U[i][j]-bram_dump[i][j];
                if(U[i][j] != 0){
                    percent_error = (delta/U[i][j])*100;
                    if(percent_error>5 || percent_error<-5){
                        invalid_values = invalid_values + 1;
                        printf("i = %d, j = %d, percent_error = %f %%, U[%d][%d] = %f, BRAM_dump = %f\n\r",i,j,percent_error,row_ind[i][j],col_ind[i][j],U[i][j],bram_dump[i][j]);

                    }
                }
                else if(delta<-0.0001 || delta>0.0001){
                    invalid_values = invalid_values + 1;
                    printf("i = %d, j = %d, delta = %f, U[%d][%d] = %f, BRAM_dump = %f \n",i,j,delta,row_ind[i][j],col_ind[i][j],U[i][j],bram_dump[i][j]);
                }
            }
        }
    }

    printf("Invalid = %d \n",invalid_values);
}

void print_BRAM_values(int starting_address, int ending_address){
	int i,j;
	int val;
    float val_float;

	for(j = starting_address; j <= ending_address;j++){
		for(i=0;i<4;i++){

	        Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*(4+i), j); //Writing address
	        delay();
	        Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*(16+i), 1); //Making enable 1
	        delay();
	        Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*(20+i), 0); //Making write enable 0
	        delay();
	        val = Xil_In32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*(12+i)); //Reading from dout
	        val_float = int_to_float(val);
	        delay();
	        Xil_Out32(XPAR_MYIP_LUDECOMPOSITION_0_BASEADDR + 4*(16+i), 0); //Making enable 0
	        delay();
	        printf("Value(%d,%d) = %7.4e,(%d)\n",i,j,val_float,val);
		}
	}
}

