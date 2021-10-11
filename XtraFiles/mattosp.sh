yourfilenames=`ls ./test_mat/*.mat | cut -d / -f 3 | cut -d . -f 1`
for eachfile in $yourfilenames
do
   echo $eachfile
   make all_mat TEST_MATRIX=$eachfile
done
shutdown +0
