#!/bin/bash
pwd
sed -i "s/.BRAM_PORTA_/.BRAM_PORTA_0_/g" ./$1/*ware*.v
sed -i "s/.BRAM_PORTB_/.BRAM_PORTB_0_/g" ./$1/*ware*.v
sed -i "s/.M_AXIS_RESULT_/.M_AXIS_RESULT_0_/g" ./$1/*ware*.v
sed -i "s/.S_AXIS_A_/.S_AXIS_A_0_/g" ./$1/*ware*.v
sed -i "s/.S_AXIS_B_/.S_AXIS_B_0_/g" ./$1/*ware*.v
sed -i "s/.S_AXIS_C_/.S_AXIS_C_0_/g" ./$1/*ware*.v
sed -i "s/.S_AXIS_OPERATION_/.S_AXIS_OPERATION_0_/g" ./$1/*ware*.v
sed -i "s/.aclk/.aclk_0/g" ./$1/*ware*.v