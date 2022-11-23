
def print_aim_plots():
    test = "\\begin{figure}[h] \n\
        \centering\n\
        \includegraphics{Images/Plots/AIM_Baseline/0/ff0.png} \n\
        \caption{Showing the inputs and outputs of the 0 degress ff process corner of the Baseline design.} \n\
        \label{fig:0ffbaseline} \n\
    \end{figure}\n"

    temps = [0, 27, 70]
    corners = ["ff", "fs", "sf", "ss", "tt"]
    versions = ["Baseline", "ImprovedWL", "Reducetransistors", "Best"]
    #Itterate through the versions, corners and the temperatures and generate the figures
    # add a "\newline" every other figure
    i = 1
    for version in versions:
        for corner in corners:
            for temp in temps:
                fig = "\\begin{figure}[htb] \n\
        \centering\n\
        \includegraphics[width=1\\textwidth]{Images/Plots/AIM_" + version + "/" + str(temp) + "/" + corner + str(temp) + ".png} \n\
        \caption{Showing the inputs and outputs of the " + str(temp) + " degress " + corner + " process corner of the " + version + " design.} \n\
        \label{fig:" + str(temp) + corner + version + "} \n\
    \end{figure}\n"
                i += 1
                if i % 2 == 0:
                    fig += "\\newline\n"




                #Append the figure to the file
                with open("Python_helpers/Latex/aim_figures.tex", "a") as f:
                    f.write(fig)
                

#Equivalent function for plotting the python plots in latex
def plot_python(file_name, folder):
    versions = ["baseline", "improvedwl", "reducetrans", "Best"]
    temps = [0, 27, 70]
    for version in versions:
        for temp in temps:
            fig = "\\begin{figure}[htb] \n\
    \centering\n\
    \includegraphics[width=1\\textwidth]{Images/Plots/" + folder + "/" + version + str(temp) + ".png} \n\
    \caption{Showing the inputs and outputs of the " + str(temp) + " degress " + version + " design.} \n\
    \label{fig:python" + str(temp) + version + "} \n\
\end{figure}\n"
            with open("Python_helpers/Latex/" + file_name + ".tex", "a") as f:
                f.write(fig)

def plot_python_scaled(file_name, folder):
    versions = ["baseline", "improvedwl", "reducetrans", "Best"]
    temps = [0]
    for version in versions:
        for temp in temps:
            fig = "\\begin{figure}[htb] \n\
    \centering\n\
    \includegraphics[width=1\\textwidth]{Images/Plots/" + folder + "/" + version + str(temp) + ".png} \n\
    \caption{Showing the inputs and outputs of the " + str(temp) + " degress " + version + " design.} \n\
    \label{fig:pythonscaled" + str(temp) + version + "} \n\
\end{figure}\n"
            with open("Python_helpers/Latex/" + file_name + ".tex", "a") as f:
                f.write(fig)


if __name__ == "__main__":
    #print_aim_plots()
    plot_python("python_figures", "Python")
    plot_python_scaled("python_figures_scaled", "Python_scaled")