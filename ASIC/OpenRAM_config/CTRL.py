# Data word size
word_size = 72

# Number of words in the memory
num_words = 4096

# Technology to use in $OPENRAM_TECH
tech_name = "sky130A"

# You can use the technology nominal corner only
# nominal_corner_only = True

process_corners = ["SS", "TT", "FF"]
# process_corners = ["TT"]

# Voltage corners to characterize
supply_voltages = [ 1.8 ]
# supply_voltages = [ 3.0, 3.3, 3.5 ]
num_rw_ports=1
# Temperature corners to characterize
# temperatures = [ 0, 25 100]

# Output directory for the results
output_path = "CTRL"
# Output file base name
output_name = "CTRL_{0}_{1}_{2}".format(word_size,num_words,tech_name)

# Disable analytical models for full characterization (WARNING: slow!)
# analytical_delay = False
