# How to use Jenkins

## Jenkins

Jenkins is a very popular, open-source tool which provides deployment pipeline functionality. It can be used to automate all sorts of tasks related to building, testing, delivering and deploying software.

This is the tool that B&R uses for our automation server, so the rest of this PPT will be focused on Jenkins. You are free to investigate other options as desired.

![](img%5CAutomation%20and%20Build%20Server2.png)

## ATL Jenkins Server

B&R North America has a build/automation server running out of our ATL office that you can utilize as long as B&R engineers are involved in your project and have credentials to your source control repository.
    
* This is convenient because it means you don’t have to build up your own server right away
* To get started with this option, contact your B&R NA representative. Note that this option is not available outside of North America

Once B&R is no longer actively involved in the project, though, you will need to create your own build/automation server setup.
    
* B&R does not manage customer automation servers long-term

Alternatively, you can create your own automation server setup from the get-go.

## Multibranch Pipeline

There are a few different project types within Jenkins, but the one we recommend is the **Multibranch Pipeline**.

* A pipeline is a workflow defined in text-based code within a text file called “Jenkinsfile”
* A Multibranch Pipeline project automatically creates sub-projects for every branch in the source code repository
    * If a new branch is created and pushed to the repository, then a new sub-project in the multibranch pipeline is created and runs for that branch
* The Jenkinsfile is committed to the source control repository, so the pipeline itself is protected by version control
    * This also means that the developers can freely/directly add steps to the pipeline

## Multiple Multibranch Pipelines

* You can configure multiple Jenkins pipelines to run in series.
    * Once the first pipeline completes successfully, the next one automatically starts running, and so on.
    * Alternatively, since the pipelines are separated, you can run the integration tests (which typically take longer) at a lower frequency than the unit tests. The unit tests could run every time code is committed and pushed, but the integration test run only every 4 hours, for example.
* We recommend using at least the following 3 distinct multibranch pipelines for AS project development:
    * Multibranch pipeline 1: Builds the project and runs unit tests
    * Multibranch pipeline 2: Runs integration tests
    * Multibranch pipeline 3: Handles the release deployment
* Note: the template Jenkinsfile in this DevOps package is a starter implementation that corresponds to one single pipeline for building the project, running unit tests, and release deployment. Integration testing is not yet included (this will come in a future update to the DevOps package).

![](img%5CAutomation%20and%20Build%20Server52.png)


