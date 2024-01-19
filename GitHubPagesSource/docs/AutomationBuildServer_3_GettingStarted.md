# Getting Started

If you are utilizing the B&R Jenkins server initially, then you can skip the steps shown here. 

## System Requirements

If you are setting up your own build/automation server, note the following system requirements:

* Hardware requirements
    * 12 GB of RAM
    * 10 GB of drive space (>50 GB recommended)
* Software requirements
    * Windows 10
    * Automation Studio 4.7 or above (version must match the project)
        * Plus all required upgrades for the project (manually installed on server)
        * Note: supporting scripts have been tested in AS4.7 and above. Prior versions may work, but have not been checked
    * Python ≥ 3.9
      * Required for automated build scripts
    * Jenkins
    * Java Development Kit

## Downloads and Installation

Build and Automation Server

* [Jenkins Download](https://www.jenkins.io/download/)
* [Java Development Kit Download](https://adoptium.net/temurin/releases/?version=11)
* [Python Download](https://www.python.org/downloads/)
* Installation instructions for Jenkins and the JDK are located [here](https://www.jenkins.io/doc/book/installing/windows/).
    * Please review the video for full instructions on how to install the JDK, Jenkins, and make assorted configuration changes after install.
* We recommend installing Jenkins on a server or dedicated PC
* We recommend installing Jenkins with the “recommended plugins” option
    * And manually add the “Office 365 Connector” plugin
    * Configure Extended E-mail Notification plugin
* Python requirements
    * pip install requests junitparser GitPython

![](img%5CAutomation%20and%20Build%20Server6.png)

