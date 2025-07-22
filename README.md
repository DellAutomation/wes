# psas-template
This is sample template for PS Automation Suite.
***
### README EXAMPLE
 The readme should contain some of the following:

## Title
TODO: Give the automation name.
## Description
TODO: Short description of the automation.
## Technologies
TODO: Give a list of technologies used within the automation code:
* [Technology name](https://example.com): Version 0.1

## Prerequisites
TODO: This section lists frameworks/libraries needed before installing the automation and how to install the frameworks/libraries.
* npm
  ```sh
  npm install npm@latest -g
  ```
## Idempotency
TODO: Give Idempotency details.
## Installation Instructions
TODO: This section describes a step by step guide that will tell user how to get the development environment up and running.

1. Clone the repo
   ```sh
   git clone https://github.com/your_username_/Project-Name.git
   ```
2. And so on.
    ```sh
   ```

## Functions
TODO: Give description regarding the functions in the code. Can elaborate further on:
- Parameters
## FAQs
TODO: Give a list of questions and answers related to automation.

&nbsp;
&nbsp;
&nbsp;
***
### REPOSITORY STRUCTURE

### Branches

- main/master - Main branch with the latest and greatest release of the automation scripts.

- development - Development and iteration branch to allow the addition of features on and off the branch.

- feature/* - Explicit features built by the community.

- bug/* - Bug squashing should fall underneath the bug branches which will eventually clean up.


### File Structure

- The Root: The root should be reserved for configuration files, initial documentation (such as README.md and others). Also, it can contain VS solution files and git files.

- /src: We all know this one. This is where all source files are placed. However, in languages that use headers (or if you have a framework for your application) don't put those files in here.

- /lib: This is the directory where all your dependencies should be stored. Also, if you have your project in multiple files, put your headers and attached source in here.

- /doc: Documentation goes in here with release notes. For example, docs.md.

- /res: A less common one. For all static resources in your project. For example, images and audio.

- /tools: Convenience directory for your use. Should contain scripts to automate tasks in the project, for example, build scripts, rename scripts. Usually contains .sh, .cmd files for example.

- /build: The place where your built files will go. Usually split into two directories, Debug and Release, it can contain binaries, .DLLs and any compiled files. It may also contain build scripts, like makefiles, but they should generally be in the root.

- /test: Contains unit tests... no, in fact, all tests!
