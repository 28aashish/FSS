import os
import subprocess
import sys

# get list of exported matrices
#exportedDir = "../test/exported"
exportedDir = "../../test_mat/exported"
dirLists = os.listdir(exportedDir)

argList = ['../cppFiles/preprocessTest']

#for mat in dirLists:
mat = str(sys.argv[1])
fileName = exportedDir + '/' +  mat + '/' + mat
#argList.append(fileName + "_A.sp")
#argList.append(fileName + "_U.sp")
#argList.append(fileName + "_L.sp")
#argList.append(fileName + "_ALU.sp")
argList.append(fileName + "_amd_A.sp")
argList.append(fileName + "_amd_U.sp")
argList.append(fileName + "_amd_L.sp")
argList.append(fileName + "_amd_ALU.sp")

print(argList)
proc = subprocess.Popen(argList,stdout=subprocess.PIPE)
while True:
    line = proc.stdout.readline().rstrip()
    if not line:
        break
    print(line)

