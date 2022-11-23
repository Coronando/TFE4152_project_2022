#Python script tha plots the data from the aim-spice simulation

import matplotlib.pyplot as plt
import numpy as np


# Read the data from the file
#The format is "id" : value
#The data is separated by a new line
#The data is separated by a :
#Skipt the last line

def read_data(file_name):
    with open(file_name, 'r') as f:
        data = f.read()
    
    data = data.split("\n")
    # Remove the last line as it is empty
    data = data[:-1]
    data = [x.split(':') for x in data]
    # Convert the data to a dictionary, appening to the value if the 
    # key already exists
    data_dict = {}
    for key, value in data:
        if key in data_dict:
            data_dict[key].append(abs(float(value)))
        else:
            data_dict[key] = [abs(float(value))]
    
    return data_dict

# #Plot the data from the file
# data = read_data(file_name)
# #print(data)
# names = list(data.keys())
# values = list(data.values())
# print(values)
# #print(values[2][1]]
# #print(values[3][1]

# corners = ["ff", "ss", "sf", "fs", "tt"]
# marker = ["o", "s", "v", "x", "D"]
# #print([len(item) for item in values])
# #Plot one each corner (every 8 values) in a different color and marker in the same plot
# fig, ax = plt.subplots()
# for i in range(5):
#     ax.plot(names, [item[i] for item in values], label=corners[i], marker=marker[i])
# ax.legend()

# plt.ylabel('Current (nA)')
# plt.xlabel('Combinations')

# # Set range of y axis from 0 to 4 nano amps
# plt.ylim(0, 4*10**-9)

# # Show the plot
# plt.show()

# Function to plot the data from the file and save it to the Plots folder
def plot_and_save_data(file_name):
    data = read_data(file_name)
    names = list(data.keys())
    values = list(data.values())
    corners = ["ff", "ss", "sf", "fs", "tt"]
    marker = ["o", "s", "v", "x", "D"]
    fig, ax = plt.subplots()
    for i in range(5):
        ax.plot(names, [item[i] for item in values], label=corners[i], marker=marker[i])
    ax.legend(mode = "expand", ncol = 3)
    plt.ylabel('Current (nA)')
    plt.xlabel('Combinations')
    plt.ylim(0, 52*10**-9)
    # Change the y ticks to be in nano amps
    ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, loc: "{:,}".format(int(x*10**9))))
    plt.savefig('Python_helpers/Plots2/' + file_name.split('/')[-1].split('.')[0] + '.png')
    #plt.show()

if __name__ == "__main__":
    path_to_data = "AIM_spice/Data/"
    file_start = ['baseline', 'improvedwl', 'reducetrans', 'best']
    file_end = ['0.txt', '27.txt', '70.txt']

    for start in file_start:
        for end in file_end:
            file_name = path_to_data + start + end
            plot_and_save_data(file_name)