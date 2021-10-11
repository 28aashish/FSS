yourfilenames=`ls ./test_mat/*.mat | cut -d / -f 3 | cut -d . -f 1`
for eachfile in $yourfilenames
do
#eachfile=test
   echo $eachfile
   make all_no TEST_MATRIX=$eachfile | tee -a ${eachfile}_log
done
#shutdown +0
