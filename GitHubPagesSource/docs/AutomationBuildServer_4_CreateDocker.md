# Creating Jenkins Agent Docker Container

## Jenkins Agent

Create a new node to run the Jenkins agent.

Goto "Manage Jenkins":

![](img%5CAutomation%20and%20Build%20Server7.png)

<br>

Select "Nodes" under the System Configuration

![](img%5CAutomation%20and%20Build%20Server8.png)

Click the "New Node" button:

![](img%5CAutomation%20and%20Build%20Server9.png)

<br>

Define the name of your node and select "Permanent Agent". Click "Create". 

![](img%5CAutomation%20and%20Build%20Server10.png)

<br>

Define “Remote root directory”:

![](img%5CAutomation%20and%20Build%20Server11.png)

<br>

Define labels based on Automation Studio Version:

![](img%5CAutomation%20and%20Build%20Server12.png)

<br>

Change “Usage” to “Only build jobs with label expressions matching this mode”:

![](img%5CAutomation%20and%20Build%20Server13.png)

<br>

Change “Launch method” to “Launch agent by connecting it to the controller”, check “Use WebSocket”, and click "Save":

![](img%5CAutomation%20and%20Build%20Server15.png)

<br>

Copy the secret provided:

![](img%5CAutomation%20and%20Build%20Server16.png)

<br>


## Docker Build

Create a Docker container for the agent.

Open the Dockerfile in a text editor:

![](img%5CAutomation%20and%20Build%20Server17.png)

<br>

Adjust the JENKINS\_URL for your configuration:

![](img%5CAutomation%20and%20Build%20Server18.png)

<br>

Add the Jenkins secret from the node creation to JENKINS\_SECRET, and adjust the JENKINS\_AGENT\_NAME with the name of the node:

![](img%5CAutomation%20and%20Build%20Server19.png)

<br>

Copy any required Automation Studio upgrade files to the AS_Upgrades directory

For any 3rd party hardware files copy them to the AS_3rd_Party_Files.  These can be copied from you local installation folder (e.g. C:\ProgramData\BR\AS412\Hardware)

Create the Docker image:

```
C:\>docker build -t as_412 -f .\Dockerfile .
```

Deploy the Docker container

```
C:\>docker create --name AS_412 --restart unless-stopped -v "C:\Program Files\Jenkins\jobs:C:\Program Files\jenkins\jobs" -v "C:\workspace:C:\jenkins\workspace" -v "C:\Jenkins Setup\docker\upgrades\additional_upgrades:C:\additional_upgrades" as_412 
```
