
## Title
# Author : Wesley Dev Andrew
# Code Name : TimelyFashion
# Version : 1.0

## Description
A desktop application to relieve user from the task of calculating efforts spent on different projects, so that they can focus on things that actually matter.
## Technologies
Powershell

## Prerequisites
# Requirement1 : MS Powershell
# Requirement2 : Output of the command "Get-ExecutionPolicy" should not be "Restricted" in Powershell. If restricted, check for your local process to get enabled.
# Requirement3 : Windows 10 or 11 where "Multiple Desktops" feature is enabled. Please refer Microsoft article for more information on how to use multiple desktops. https://support.microsoft.com/en-us/windows/configure-multiple-desktops-in-windows-36f52e38-5b4a-557b-2ff9-e1a60c976434
# Requirement3 : In powershell if not already available please install the module > Install-Module -Name VirtualDesktop

# Fixed issue1 : This program now takes into account idle time so that any idle time beyond 60 seconds is ignored (Hence total of calculated utilization duration may be less than the program runtime duration).

# Limitation1 : Only MS Windows for now because of powershell.  
# Limitation2 : Not of this tool but some applications like PDF readers dont work well with multiple virtual desktops. With some workarounds, it is possible to create separate windows of same application in multiple desktops. We shall add a tips section later to documentation.

# Planned Improvement1 : Need to scale the program to prepare weekly and monthly reports.
# Planned Improvement2 : Replace some hardcoded values like endtime, outputpath with variables that can be recieved as input parameters during next phase of Testing and optimization
# Planned Improvement3 : More user friendly documentation.
# Planned Improvement4 : Better graph in Excel
# Planned Improvement5 : Need to automate Multiple Desktop Initialization wizard to assist new users.
# Planned Improvement6 : Need to migrate to platform independant coding to accommodate other operating systems like MacOS and Linux.
# Planned Improvement7 : Try to provide a Heads-Up Display on live status of work hours spent to help plan remaining time of day accordingly or to better accomplish time goals.

# Feedbacks : Please feel free to send in your valuable feedbacks to wesley.andrew@dell.com

### REPOSITORY STRUCTURE

### Branches
# At this point TimelyFashion.ps1 is the only file that needs to be executed directly from powershell prompt. No other dependancy project files.
- main/master - Main branch with the latest and greatest release of the automation scripts.

- development - Development and iteration branch to allow the addition of features on and off the branch.

- feature/* - Explicit features built by the community.

- bug/* - Bug squashing should fall underneath the bug branches which will eventually clean up.


### File Structure
# At this point TimelyFashion.ps1 is the only file that needs to be executed directly from powershell prompt. No other dependancy project files.

- The Root: The root should be reserved for configuration files, initial documentation (such as README.md and others). Also, it can contain VS solution files and git files.

- /src: We all know this one. This is where all source files are placed. However, in languages that use headers (or if you have a framework for your application) don't put those files in here.

- /lib: This is the directory where all your dependencies should be stored. Also, if you have your project in multiple files, put your headers and attached source in here.

- /doc: Documentation goes in here with release notes. For example, docs.md.

- /res: A less common one. For all static resources in your project. For example, images and audio.

- /tools: Convenience directory for your use. Should contain scripts to automate tasks in the project, for example, build scripts, rename scripts. Usually contains .sh, .cmd files for example.

- /build: The place where your built files will go. Usually split into two directories, Debug and Release, it can contain binaries, .DLLs and any compiled files. It may also contain build scripts, like makefiles, but they should generally be in the root.

- /test: Contains unit tests... no, in fact, all tests!
