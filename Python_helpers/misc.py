test = "\\begin{figure}[htbp]] \n\
    \centering\n\
    \includegraphics[width=1\\textwidth]{Images/0_ff.png} \n\
    \caption{Showing the inputs and outputs of the 0 degress ff process corner.} \n\
    \label{fig:0ff} \n\
\end{figure}\n"

temps = [0, 27, 70]
corners = ["ff", "fs", "sf", "ss", "tt"]
#Itterate through the corners and the temperatures and generate the figures
for corner in corners:
    for temp in temps:
        #Generate the figure
        test = test.replace("0", str(temp))
        test = test.replace("ff", corner)
        print(test)

        #Reset the test string
        test = "\\begin{figure}[htbp] \n\
    \centering\n\
    \includegraphics[width=1\\textwidth]{Images/Plots/Baseline/0/ff0.png} \n\
    \caption{Showing the inputs and outputs of the 0 degress ff process corner.} \n\
    \label{fig:aimplots-0ff} \n\
\end{figure}\n"
print(test)