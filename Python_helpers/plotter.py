# Simple python program that plots the data from a given file

import matplotlib.pyplot as plt
import numpy as np

target_file = "exported_data.txt"

# Read the data from the file
try:
    data = np.loadtxt(target_file, skiprows=1)
except:
    Exception("Could not read the data from the file")

# Get the x and y data
x = data[:,0]
y = data[:,1]

plt.plot(x, y)
# Add x and y labels and a title
plt.ylabel("Voltage (V)")
plt.xlabel("Time (ns)")
plt.title("Exported data from AIM-Spice")

plt.show()

