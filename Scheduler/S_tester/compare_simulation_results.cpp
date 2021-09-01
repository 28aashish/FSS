#include <iostream>
using namespace std;
#define f_type float

int main(){
    /*int no;
    float **L = (float **)malloc(8*sizeof(float*));
    for(no=0;no<8;no++){
        L[no] = (float *)malloc(1024*sizeof(float));
    }

    float **U = (float **)malloc(8*sizeof(float*));
    for(no=0;no<8;no++){
        U[no] = (float *)malloc(1024*sizeof(float));
    }*/

const int BRAM_COUNT = 8;
const int BRAM_DEPTH = 1024;
float L[8][1024];
float U[8][1024];
int row_ind[8][1024];
int col_ind[8][1024];
for(int i=0;i<8;i++){
for(int j=0;j<1024;j++){
L[i][j] = -11110000; U[i][j] = -11110000; 
row_ind[i][j] = -1; col_ind[i][j] = -1; 
}
}
L[2][0] = -0.25;   row_ind[2][0] = 2;   col_ind[2][0] = 1;   // L(2,1)
L[5][0] = 1;   row_ind[5][0] = 4;   col_ind[5][0] = 2;   // L(4,2)
L[7][0] = 0.71428573;   row_ind[7][0] = 4;   col_ind[7][0] = 3;   // L(4,3)
U[0][0] = 4;   row_ind[0][0] = 0;   col_ind[0][0] = 0;   // U(0,0)
U[1][0] = 4;   row_ind[1][0] = 1;   col_ind[1][0] = 1;   // U(1,1)
U[3][0] = 8;   row_ind[3][0] = 1;   col_ind[3][0] = 2;   // U(1,2)
U[4][0] = 2;   row_ind[4][0] = 2;   col_ind[4][0] = 2;   // U(2,2)
U[6][0] = 7;   row_ind[6][0] = 3;   col_ind[6][0] = 3;   // U(3,3)
U[0][1] = 3;   row_ind[0][1] = 0;   col_ind[0][1] = 4;   // U(0,4)
U[1][1] = 5;   row_ind[1][1] = 3;   col_ind[1][1] = 4;   // U(3,4)
U[2][1] = -0.57142878;   row_ind[2][1] = 4;   col_ind[2][1] = 4;   // U(4,4)

float bram_dump[          8][       1024]={0};
bram_dump[0][          0] = 4.000000e+00;
bram_dump[1][          0] = 4.000000e+00;
bram_dump[2][          0] = -2.500000e-01;
bram_dump[3][          0] = 8.000000e+00;
bram_dump[4][          0] = 2.000000e+00;
bram_dump[5][          0] = 1.000000e+00;
bram_dump[6][          0] = 7.000000e+00;
bram_dump[7][          0] = 7.142857e-01;
bram_dump[0][          1] = 3.000000e+00;
bram_dump[1][          1] = 5.000000e+00;
bram_dump[2][          1] = -5.714287e-01;

    int i,j,invalid_values;
    float delta,percent_error;

    //Verification for L
    cout<<"Verifying L values:-\n";
    invalid_values = 0;
    for(int i=0;i<BRAM_COUNT;i++){
        for(int j=0;j<BRAM_DEPTH;j++){
            if(L[i][j] != -11110000){//It indicates that, that value of L does not exist
                delta = L[i][j]-bram_dump[i][j];
                if(L[i][j] != 0){
                    percent_error = (delta/L[i][j])*100;
                    if(percent_error>5 || percent_error<-5){
                        invalid_values = invalid_values + 1;
                        //cout<<"i = "<<i<<", j = "<<j<<", percent_error = "<<percent_error<<"%, L["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"] = "<<L[i][j]<<"\n";
                        cout<<"L["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"], percent_error = "<<percent_error<<"%, correct value = "<<L[i][j]<<", calculated value = "<<bram_dump[i][j]<<"\n";
                    }
                }
                else if(delta<-0.0001 || delta>0.0001){
                    invalid_values = invalid_values + 1;
                    //cout<<"i = "<<i<<", j = "<<j<<", delta = "<<delta<<", L["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"] = "<<L[i][j]<<"--------------------------------------\n";
                    cout<< "L["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"], delta = " << delta <<", correct value = "<<L[i][j]<<", calculated value = "<<bram_dump[i][j]<<"\n";
                }
            }
        }
    }

    cout<<"Invalid Values = "<<invalid_values<<"\n\n";

    //Verification for U
    cout<<"Verifying U values:-\n";
    invalid_values = 0;
    for(int i=0;i<BRAM_COUNT;i++){
        for(int j=0;j<BRAM_DEPTH;j++){
            if(U[i][j] != -11110000){//It indicates that, that value of L does not exist
                delta = U[i][j]-bram_dump[i][j];
                if(U[i][j] != 0){
                    percent_error = (delta/U[i][j])*100;
                    if(percent_error>5 || percent_error<-5){
                        invalid_values = invalid_values + 1;
                        //cout<<"i = "<<i<<", j = "<<j<<", percent_error = "<<percent_error<<"%, U["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"] = "<<U[i][j]<<"\n";
                        cout<<"U["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"], percent_error = "<<percent_error<<"%, correct value = "<<U[i][j]<<", calculated value = "<<bram_dump[i][j]<<"\n";
                    }
                }
                else if(delta<-0.0001 || delta>0.0001){
                    invalid_values = invalid_values + 1;
                    //cout<<"i = "<<i<<", j = "<<j<<", delta = "<<delta<<", U["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"] = "<<U[i][j]<<"--------------------------------------\n";
                    cout<< "U["<<row_ind[i][j]<<"]"<<"["<<col_ind[i][j]<<"], delta = " << delta <<", correct value = "<<U[i][j]<<", calculated value = "<<bram_dump[i][j]<<"\n";
                }
            }
        }
    }

    cout<<"Invalid Values = "<<invalid_values<<"\n";

    return 0;
}
