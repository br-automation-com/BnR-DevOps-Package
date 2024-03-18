# Customizing the Jenkinsfile

## Overview of the Jenkinsfile Template

The provided Jenkinsfile template accomplishes the following tasks:

1. Builds the AS project
2. Runs the unit tests
3. Creates an ARsim structure and PIP
4. Uploads the ARsim structure and PIP to GitHub, and sends them to an MS Teams channel via a chat message
5. Sends an email with the results of the build

This template is a starting point for your pipeline definition. There are a few things in this file that must be adjusted for it to run properly for your system.

The following information identifies the purpose of each section in the Jenkinsfile and any changes you must make. 

There are 6 main sections in the Jenkinsfile pipeline:

  * _Variable Definitions_  – Defines global variables
  * _Agent_  – Defines where the pipeline will run within the Jenkins environment
  * _Environment_  – Defines global environment variables
  * _Options_  – Configures options
  * _Stages_  – Defines the steps in the pipeline. If a stage fails, subsequent stages don’t run
  * _Post_  – Always runs at the end of the pipeline, even if a stage fails

## Difference between Variables and Environment Variables

Variables:

* Defined outside the pipeline, at the top of the file
* All variables are global

Environment Variables:

* Defined within an environment{} section, either at the top level of the pipeline (for pipeline global environment variable declarations) or within a stage of the pipeline (for stage local declarations)
* Global environment variables can also be defined in the configuration of Jenkins. In this case, the variables are accessible to all pipelines
* There are also some built-in environment variables that can be used throughout any Jenkinsfile (analogous to System Variables in mapp View). A full list of predefined and readily available environment variables in Jenkins is available [here](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#using-environment-variables).
* The built-in workspace environment variable (${WORKSPACE}) is not available until the pipeline starts running. Therefore, if the variable you are creating needs to reference the workspace, you must declare it as an environment variable. In our template file, this is why PROJECT\_DIR and RELEASE\_VERSION are declared as environment variables.

## Customization

### Variables

Starting at the top of the Jenkinsfile, we will begin by adjusting the global variables. The following table describes each variable. Adjust the values accordingly:

| Variable Name | Description |
| |  |
| TEAMS_CHANNEL_URL | Teams channel webhook URL where messages about the pipeline status will automatically be sent. For more details on how to define this, refer to the “Options” section.  |
| CONFIG_NAME | Name of the configuration in the AS project that you are running through the pipeline |
| UNIT_TEST_CONFIG_NAME | Name of the unit test configuration in the AS project |
| REPO_NAME | Name of the GitHub repository. Only required if you plan to upload files to GitHub.  |
| REPO_ORGANIZATION | Name of the GitHub organization. Only required if you plan to upload files to GitHub.  |
| EMAIL_LIST | List of email addresses that you want to send the results to, each separated by a semicolon |

### Agent

Edit the “agent” line:

  * If you are utilizing the B&R Jenkins server to start, then identify the docker container your pipeline will run in. This simply depends on the AS version of your project
    * Example: AS\_412
  * If you have built your own Jenkins server, then specify the [agent](https://www.jenkins.io/doc/book/using/using-agents/) accordingly.

![](img%5CAutomation%20and%20Build%20Server22.png)

### Environment

The following table describes each environment variable. Adjust the values accordingly:

| Variable Name | Description |
|| |
| PROJECT_DIR | Specify the path within the repository to the AS project (the folder containing the .apj file). <br />Use \\\ for folder separation.<br />Example: PROJECT_DIR = "$WORKSPACE\\\TestProject“<br />If the project is stored in the root directory, then leave it defined as PROJECT_DIR = "$WORKSPACE" |
| RELEASE_VERSION | Holds the version number of the code in the repo. No changes required.  |

### Options

The “options” section sets up a webhook to an MS Teams channel so that you can automatically send information to that channel. This includes:
* Updates on when the pipeline has started / stopped
* Whether the pipeline succeeded
* The output files of the pipeline (by default in our template, the output files are the zipped up ARsim structure and PIP)

To establish this connection, you need to obtain your Teams channel webhook URL (see next section) and paste it in the value for the TEAMS_CHANNEL_URL variable

![](img%5CAutomation%20and%20Build%20Server23.png)


#### Obtaining the Webhook URL

To obtain the webhook URL for a Microsoft Teams Connection, follow these steps: 

* Navigate to the channel in the Team that you want to establish the connection to

* Click the “…” button, then click "Connectors"

![](img%5CAutomation%20and%20Build%20Server24.png)

* Click “Configure” for “Incoming Webhook”

![](img%5CAutomation%20and%20Build%20Server25.png)

* Give your webhook a name and click “Create”

![](img%5CAutomation%20and%20Build%20Server26.png)

* Afterwards, the URL you need will be populated in the field at the bottom. Copy this link and paste it at the top of the Jenkinsfile as the value of the TEAMS\_CHANNEL\_URL variable

![](img%5CAutomation%20and%20Build%20Server27.png)

### Stages

The next section in the pipeline is the stages. This is where you define the actions that the build server will perform. This is the “meat and potatoes” of the pipeline.

There are 4 stages set up in the template Jenkinsfile, which we will now go through one by one:

1. Update Tags
2. Build AS Project
3. Unit Tests
4. Deploy

#### Stage: Update Tags

* This stage force-pulls the tags in the repository
  * Note that therefore, at least one tag must exist in the repo
* This information will be used later to create a version number
* No changes necessary

![](img%5CAutomation%20and%20Build%20Server28.png)

#### Stage: Build AS Project

* This stage builds the AS project
* A value of -1 for “max\_warnings” means you can have infinite warnings. If you optionally specify a positive value here, the stage will fail if the number of build warnings exceeds this value.

![](img%5CAutomation%20and%20Build%20Server29.png)

#### Stage: Unit Tests

* This stage runs the automated unit tests

* If the pipeline gets stuck on a unit test for longer than 15 minutes, the tests will fail. Optionally adjust this timeout value as desired.

![](img%5CAutomation%20and%20Build%20Server30.png)

#### Stage: Deploy

* The template separates the deploy stage between release branches and feature/develop branches

* Therefore, you can trigger different actions depending on what branch you pushed to

* By default, both stages create the ARsim structure and Project Installation Package

* If you want to perform another action in either stage, add it accordingly

![](img%5CAutomation%20and%20Build%20Server31.png)

### Post

The code within Post will always run, even if a stage in the pipeline fails.

Within Post, there are 3 subsections:

1. __Always__  – runs in every single post processing
2. __Success__  – runs if all unit tests pass
3. __Unstable__  – runs if any of the unit tests fail. This is classified as “unstable” rather than a failure because the pipeline itself completed, but the tests did not pass.



#### Post: Always

The “Always” post script converts the B&R Unit test results into a data format that Jenkins can understand what passed/failed.

It archives the ARsim structure and PIP so that they can be used in subsequent pipelines or uploaded to GitHub/Teams.

It als osends an email with the build status to the EMAIL\_LIST recipients.

The PIP that gets automatically generated uses the following installation settings:

* Consistent installation
* Allow updates without data loss
* Keep PV values
* Ignore version
* Always install

##### Example of a Successful Build Email Notification

All Tests Passed

![](img%5CAutomation%20and%20Build%20Server32.png)
![](img%5CAutomation%20and%20Build%20Server33.png)


##### Example of an Unstable Build Email Notification

Some Tests Failed

![](img%5CAutomation%20and%20Build%20Server34.png)
![](img%5CAutomation%20and%20Build%20Server35.png)

#### Post: Success, Unstable

Both the “Success” and “Unstable” post scripts do the following:
    
* Upload the artifacts to GitHub
* Send a message to the Teams channel with the status and artifact download links

The only differences between these post scripts are:

* The color scheme (green for success, yellow for unstable)
* The text that gets used for the Teams message (“Build Success” vs “Build Unstable”).

##### Example of MS Teams Messages

Success: 

![](img%5CAutomation%20and%20Build%20Server36.png)

Unstable:

![](img%5CAutomation%20and%20Build%20Server37.png)

#### Post: Success, Unstable

Required steps:

* Comment/uncomment the upload lines depending on whether you want to upload the artifacts to GitHub
* If you do choose to upload, make sure you have edited the REPO\_NAME and REPO\_ORGANIZATION variables at the top of the Jenkinsfile accordingly

![](img%5CAutomation%20and%20Build%20Server38.png)

## Verifying your Jenkinsfile

One common complaint when working with a Jenkinsfile is how to verify that the Jenkinsfile is syntactically correct without running it on Jenkins.  This can result in build failures simply due to syntax errors in your Jenkinsfile.

There is a [Jenkins Pipeline Linter Connector](https://marketplace.visualstudio.com/items?itemName=janjoerke.jenkins-pipeline-linter-connector) extension to VS Code that allows you to verify you Jenkinsfile without running it on Jenkins.

* First install the extension in VS Code

* Create a token in Jenkins to use for authorization

![](img%5CAutomation%20and%20Build%20Server%20-%20Jenkins%20User%20Configure.png)

* Add new API token

![](img%5CAutomation%20and%20Build%20Server%20-%20Jenkins%20New%20API%20Token.png)

![](img%5CAutomation%20and%20Build%20Server%20-%20Jenkins%20Generate%20API%20token.png)

* Be sure to copy the token

![](img%5CAutomation%20and%20Build%20Server%20-%20Jenkins%20API%20Token.png)

* Setup extension 
Automation and Build Server - VS Code Settings.png


* Add token and Jenkins URL to extension settings, URL = http://&lt;jenkins_url&gt;:8080/pipeline-model-converter/validate

![](img%5CAutomation%20and%20Build%20Server%20-%20VS%20Code%20linter%20connector.png)

* Run command to verify your Jenkinsfile using the Command Pallete (Ctrl + Shift + P)

![](img%5CAutomation%20and%20Build%20Server%20-%20VS%20Code%20Validate%20Jenkinsfile.png)

* Errors in your Jenkinsfile will be shown in the output window of VS Code

![](img%5CAutomation%20and%20Build%20Server%20-%20VS%20Code%20Jenkinsfile%20error.png)