from io import StringIO
import os
import math
import json
import re
import shutil
import tempfile
import numpy as np
from math import ceil
from math import floor


NUM_BRAM = 8
ADDR_WIDTH = 12
ADDR_WIDTH_DATA_BRAM = 10
CTRL_WIDTH = 357
NS = 32
WE = 32

def find_nearest(array, value):
    array = np.asarray(array)
    idx = (np.abs(array - value)).argmin()
    return array[idx]

def namer(i):
    if (i < NS):
        return """N"""
    if (i < NS+WE):
        return """E"""
    if (i < 2*NS+WE):
        return """S"""
    return """W"""


if __name__ == "__main__":
    # Opening JSON file
    f = open('IO.json')

    # returns JSON object as
    # a dictionary
    data = json.load(f)
    NUM_BRAM = data['NUM_BRAM']
    ADDR_WIDTH = data['ADDR_WIDTH']
    ADDR_WIDTH_DATA_BRAM = data['ADDR_WIDTH_DATA_BRAM']
    CTRL_WIDTH = data['CTRL_WIDTH']
    # Iterating through the json
    # list
    # Closing file
    f.close()
    X = input("Value of X ")
    Y = input("Value of Y ")
    XY = float(X)/float(Y)
    XY_ceil = ceil(XY)
    XY_floor = floor(XY)
    XY_mid = (XY_ceil + XY_floor)/2
    array = np.array([XY_ceil, XY_floor, XY_mid])
    k = find_nearest(array, XY)
    TotalPins = 5 + 2 + (2*ceil(CTRL_WIDTH/32.0) + ADDR_WIDTH+2) + \
                         NUM_BRAM * (ADDR_WIDTH_DATA_BRAM + 32*2 + 1 + 4)
    NS = ceil(k * ceil(TotalPins/(2+2*k))) if(X > Y) else ceil(TotalPins/(2+2*k))
    WE = ceil((TotalPins - 2*NS) / 2)
    print(TotalPins)
    print(k)
    print(XY)
    print(NS)
    print(WE)
    iomapper = open("./place.io", 'w')
    iomapper.write("""Pin: CLK_100 N
Pin: locked N
Pin: RST_IN N
Pin: START N
Pin: COMPLETED N
Pin: debug_state[0] N
Pin: debug_state[1] N
""")
    i = 7
    iomapper.write("""
""")
    stringer = """Pin: bram_ZYNQ_INST_addr[{0}] {1}
"""
    for bram_ZYNQ_INST_addr in range(ADDR_WIDTH):
        iomapper.write(stringer.format(bram_ZYNQ_INST_addr, namer(i)))
        i = i + 1
    stringer = """Pin: bram_ZYNQ_INST_en {0}
Pin: bram_ZYNQ_INST_we {1}
"""
    iomapper.write(stringer.format(namer(i), namer(i+1)))
    i = i+2

    stringer = """Pin: bram_ZYNQ_INST_din_part_{0}[{1}] {2}
"""
    iomapper.write("""
""")
    for bram_ZYNQ_INST_din_part in range(ceil(CTRL_WIDTH/32.0)):
        for num32 in range(32):
            iomapper.write(stringer.format(
                bram_ZYNQ_INST_din_part, num32, namer(i)))
            i = i+1
        iomapper.write("""
""")

    stringer ="""Pin: bram_ZYNQ_INST_dout_part_{0}[{1}] {2}
"""
    iomapper.write("""
""")
    for bram_ZYNQ_INST_din_part in range(ceil(CTRL_WIDTH/32.0)):
        for num32 in range(32):
            iomapper.write(stringer.format(bram_ZYNQ_INST_din_part, num32,namer(i)))
            i = i+1			
        iomapper.write("""
""")

    for BRAM_NAME in range(NUM_BRAM):
        iomapper.write("""
""")
        for bram_ZYNQ_block in range(ADDR_WIDTH_DATA_BRAM+2):
            stringer ="""Pin: bram_ZYNQ_block_{0}_addr[{1}] {2}
"""
            if(bram_ZYNQ_block <ADDR_WIDTH_DATA_BRAM):
                iomapper.write(stringer.format(chr(BRAM_NAME+65), bram_ZYNQ_block,namer(i)))				
                i = i+1
            if(bram_ZYNQ_block==ADDR_WIDTH_DATA_BRAM):
                stringer ="""Pin: bram_ZYNQ_block_{0}_en {1}
"""
                iomapper.write(stringer.format(chr(BRAM_NAME+65), namer(i)))
                i = i+1
            if(bram_ZYNQ_block >ADDR_WIDTH_DATA_BRAM):
                stringer ="""Pin: bram_ZYNQ_block_{0}_we {1}
"""
                iomapper.write(stringer.format(chr(BRAM_NAME+65),namer(i)))
                i = i+1

    for BRAM_NAME in range(2*NUM_BRAM):
        stringer ="""Pin: bram_ZYNQ_block_{0}_din[{1}] {2}
"""
        if(BRAM_NAME %2):
            stringer ="""Pin: bram_ZYNQ_block_{0}_dout[{1}] {2}
"""
        iomapper.write("""
""")
        for bram_ZYNQ_block in range(32):
                iomapper.write(stringer.format(chr(floor(BRAM_NAME/2)  + 65),bram_ZYNQ_block,namer(i)))
                i = i+1
    iomapper.close()
