yourfilenames=`ls ./test_mat/*.mat | cut -d / -f 3 | cut -d . -f 1`
for eachfile in $yourfilenames
do
   	F=`fgrep -c "Total Cycles" ${eachfile}_log`
#	echo $F
   	if [ $F -eq 1 ]; 
	then
		F=`fgrep -c "0 ❌" ${eachfile}_log`
		if [ $F -eq 0  ];
		then
		echo "${eachfile} OK"
		fi
	fi	
   #make all_mat TEST_MATRIX=$eachfile
done
echo "#############################################"
echo "############# LU Mismatch ###################"
echo "#############################################"
for eachfile in $yourfilenames
do
   	F=`fgrep -c "Total Cycles" ${eachfile}_log`
#	echo $F
   	if [ $F -eq 1 ]; 
	then
		UF=`fgrep -c "Numbers of NNZ doesn't match for U" ${eachfile}_log`
		LF=`fgrep -c "Numbers of NNZ doesn't match for L" ${eachfile}_log`
		if ((( ${UF} == 1)) || (( ${LF} == 1 )));
		then
			if (( ${LF} != 1 ));
			then
				echo "${eachfile} L not Matching"
			elif (( ${UF} != 1));
			then
				echo "${eachfile} U not Matching"
			else
				echo "${eachfile} L & U Matching"
			fi
		fi
	fi	
   #make all_mat TEST_MATRIX=$eachfile
done
echo "########################################"
echo "########### Memory Requirement #########"
echo "########################################"
#
for eachfile in $yourfilenames
do
   	F=`fgrep -c "Total Cycles" ${eachfile}_log`
#	echo $F
   	if [ $F -eq 0 ]; 
	then


		F=`fgrep -c "🚧 LIMIT : Insufficient memory space" ${eachfile}_log`
		if [ $F -eq 1  ];
		then
		echo "${eachfile} Insufficient memory space"
		fi
	fi	
   #make all_mat TEST_MATRIX=$eachfile
done
echo "########################################"
echo "############## RAM Consumer ############"
echo "########################################"
#
for eachfile in $yourfilenames
do
   	F=`fgrep -c "Total Cycles" ${eachfile}_log`
#	echo $F
   	if [ $F -eq 0 ]; 
	then


		F=`fgrep -c "Comparing U Matrix" ${eachfile}_log`
		if [ $F -eq 0  ];
		then
		echo "${eachfile} RAM Eater"
		fi
	fi	
   #make all_mat TEST_MATRIX=$eachfile
done
echo "########################################"
echo "########################################"
echo "########################################"


#
#shutdown +0
