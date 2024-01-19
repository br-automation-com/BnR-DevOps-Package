# Automation & Build Server
## Definitions

### Build Server

* A build server is an isolated production environment where software projects are compiled and built.
* The code is pulled directly from a source control repository prior to build.

### Automation Server
* An automation server is used to automate tasks and processes.
* The automation server monitors the source control repo. As soon as a code change is checked into the repo (or at a specific time interval), the automation server will automatically trigger the following:
    * Check out the latest version of the code from the source control repo
    * Compile the code on the build server
    * Initiate the automated unit/integration tests
    * Communicate the results (pass/fail) to the interested parties via email, Teams, Confluence, etc
    * Initiate automated deployment
    * … and so on
* The automation server is essentially the “puppet master” of the automations within the DevOps process

## Benefits

* By building the project and running tests in an isolated production environment, you will be testing against a collection of known dependencies. In other words, you avoid the “it fails for you, but it works on my PC” situation
* By automating the deployment pipeline with a build server, developers quickly receive feedback about whether their changes introduced a problem into the system
    * The sooner a problem is identified, the easier/cheaper it is to fix
    * The build server provides a clear paper trail for what change introduced a problem
* When used in combination with proper version control practices, the latest version of code will always be in a releasable state
* Since the releases are automated and not manual, release steps are consistent and no steps are forgotten

## Target Applications

* __Any and all__ applications can benefit from the incorporation of a build and automation server
  * Any steps that are triggered automatically are inherently more efficient and reliable than executing the step manually
* These are general software development tools that will give us a strategic advantage over our competitors
* A build and automation server is particularly useful if:
    * You are managing multiple projects
        * The automation server will update all interested parties via email / Teams
        * The build server will automatically generate the PIP in a consistent environment, which makes machine updates easier because only the changes will get transferred to the target
    * The application has unit tests
        * The automation server will run them automatically and more frequently
        * The build/automation server will allow for a clean slate testing environment
        * The build server triggers all tests, so you have confidence that your code changes don’t impact other aspects of the code








