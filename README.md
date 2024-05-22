# TFE4152_project_2022
An honest attemt at passing with a decent grade in TFE4152. Don't forget the guide I made, it should help you get running.

- [TFE4152_project_2022](#tfe4152_project_2022)
  - [File structure:](#file-structure)
  - [How do I even use this code?](#how-do-i-even-use-this-code)
  - [What the fuck is Git and why is Sindre forcing me to use it?](#what-the-fuck-is-git-and-why-is-sindre-forcing-me-to-use-it)
    - [Make and account](#make-and-account)
    - [Clone the repository](#clone-the-repository)
    - [Make a branch](#make-a-branch)
    - [Make changes](#make-changes)
    - [Commit changes](#commit-changes)
    - [Push changes](#push-changes)
    - [Make a pull request](#make-a-pull-request)
    - [Pull changes](#pull-changes)
    - [Done!](#done)
  - [Todo:](#todo)
  - [AIM-Spice:](#aim-spice)
  - [HDL:](#hdl)

## How do I even use this code?
All of the code lives in the GitHub repo: [TFE4152_project_2022](https://github.com/Coronando/TFE4152_project_2022). You can choose to clone it to your own machine, but I would rather you put it on your *Hjemmeområde*. In addition, to simplyfy further, I've made a *Personlig Gruppe* called "stud_tfe4152gr60". If you want to access either, the instructions should be clear on [Insidas aricle on "koble til nettverksområde med Mac OS X"](https://i.ntnu.no/wiki/-/wiki/Norsk/Koble+til+nettverksomr%C3%A5de+med+Mac+OS+X). Alternative operating systems have their own guide, just use Google or ask me.
 
Both theese network areas should be accesible from the remote desktop machines that you connect to on NTNU's servers. That is what makes it so smoth.

If you want to work with all this stuff after cloning, it's important that you know some basic Git. Take a look at the basic git commands in the [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf). If you want to learn more, I recommend [this](https://www.youtube.com/watch?v=SWYqp7iY_Tc) video series. For this project Ive made a simple Git section in the document [What the fuck is Git and why is Sindre forcing me to use it?](#What the fuck is Git and why is Sindre forcing me to use it?)

## What the fuck is Git and why is Sindre forcing me to use it?
Git is a version control system. It is a tool that allows you to keep track of changes to your code. It also allows you to work on the same code at the same time, without having to worry about overwriting each other's work. It is also a tool that allows you to easily share your code with others. It is a very powerful tool, and I highly recommend that you learn how to use it.

### Make and account
This you should have or you need to take a look in the mirror Bjønnes. If not, just make one over at [GitHub](https://github.com/join). It's free.

### Clone the repository
'Cloning' is the process of downloading the repository to your computer. You can do this by opening a terminal and typing the following command:
```bash
bash:~$ git clone https://github.com/Coronando/TFE4152_project_2022.git
```
### Make a branch
A branch is a copy of the master branch. It is a copy of the code that you can work on without affecting the master branch. This is important because it allows you to work on your own code without having to worry about overwriting someone else's code. To make a branch, type the following command:
```bash
bash:~$ git checkout -b <branch_name>
```
A good name would be a descibing name for the feature you are working on. "feature/adding_a_new_component" would be a good name for a branch that you are working on a new component.

### Make changes
Now you can make changes to the code. You can do this in any text editor. I recommend [Visual Studio Code](https://code.visualstudio.com/). It is a very powerful text editor that is free and open source. It is also very easy to use. You can also use any other text editor you want, but I recommend VS Code.

### Commit changes
When you are done making changes, you need to commit them. This means that you are telling Git that you are done making changes to the code. To commit your changes, type the following command:
```bash
bash:~$ git add .
bash:~$ git commit -m "A short message describing the changes you made"
```
### Push changes
When you are done making changes, you need to push them. This means that you are telling Git that you want to upload your changes to the GitHub repository. To push your changes, type the following command:
```bash
bash:~$ git push origin <branch_name>
```
### Make a pull request
When you are done making changes, you need to make a pull request. This means that you are telling Git that you want to merge your changes with the master branch. To make a pull request, go to the GitHub repository and click the "Pull requests" tab. Then click the "New pull request" button. Then click the "Create pull request" button. Then click the "Create pull request" button again. Then click the "Merge pull request" button. Then click the "Confirm merge" button. Then click the "Delete branch" button.

### Pull changes
When you are done making changes, you need to pull them. This means that you are telling Git that you want to download the changes that other people have made to the code. To pull your changes, type the following command:
```bash
bash:~$ git pull origin <branch_name>
```
This also has to be done evbery time you start working on the code. This is because other people might have made changes to the code while you were working on it. If you don't pull the changes, you will overwrite the changes that other people have made.

*Note: I did not write this section. I found it on [this](https://www.youtube.com/watch?v=SWYqp7iY_Tc) video. I just thought it was a good explanation. Most of it was made by utilizing the GitHub Autopilot suggestions*

### Done!
Now you know how to use Git. You can now use it to work on the code. If you have any questions, feel free to ask me.

## Todo:
- [x] Make the basic nand gate.
- [ ] Test the main nand gate, see its leakage and power drain at different process corners and transistor sizes.
  - Maybe test an alternate nand gate topologi instead of the basic pull-up pull-down network version.  
  - ...
- [ ] Make Overleaf project for the report
- [ ] TBD
- [ ] ...
  


## AIM-Spice:
So far in AIM-spice I've done some testing of the basic nand gate. First and foremost I've tried to understand how AIM-Spice works and how we should proceed to work with it.

Please read the AIM-Spice files to see the different ways I've implemented things. 


## HDL:
I have not made the nand gate or latch in HDL yet. I will do this as soon as I have a better understanding of how to use Active HDL and System Verilog.
