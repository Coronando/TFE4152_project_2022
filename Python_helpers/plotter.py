# Simple python program that plots the data from a given file

import matplotlib.pyplot as plt
import numpy as np

target_file = "t2.txt"

# Read the data from the file
# data = np.loadtxt(target_file, skiprows=1)
try:
    data = np.loadtxt(target_file, skiprows=1)
except:
    Exception("Could not read the data from the file")

# Get the x and y data
x = data[:,0]
y = data[:,1]
y_2 = data[:,2]
y_3 = data[:,3]


# Plot the data in subplots
fig, (ax1, ax2, ax3) = plt.subplots(3, 1, sharex=True)
ax1.plot(x, y)
ax2.plot(x, y_2)
ax3.plot(x, y_3)

plt.show()

