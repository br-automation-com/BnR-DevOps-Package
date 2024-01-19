# B&R-Jenkins Helper Library

## Readymade Groovy Scripts

* B&R North America has written a helper library that includes a lot of useful functions for interacting with AS projects
* The library contains Groovy scripts, which are wrappers around Python scripts and general commands
* You don’t need to edit this library at all, but you will be using it in your Jenkinsfile
    * The functions are described on the next slides as an FYI
* [Public link to the library on GitHub](https://github.com/br-automation-com/BnR-Jenkins-Helper-Library)
    * The Groovy scripts are located within the “vars” folder on the repo
    * The Python scripts that the Groovy scripts utilize are located within the “resources\\scripts” folder on the repo
* These scripts have been tested in AS4.7 and above. Prior AS versions may work, but they are currently untested.

## Add to Jenkins Server

To utilize this helper library on your Jenkins server, do the following:

1. Go to “Manage Jenkins”
2. Select “System”
3. Scroll down to the “Global Pipeline Libraries” section. Click “Add”. Then:
    * Fill out a Name for the library (whatever you prefer)
    * In the “Default Version” field, type “main”
    * Check the boxes for “Load implicitly”, “Allow default version to be overridden”, and “Include @Library changes in job recent changes”
    * Set the Retrieval method to “Modern SCM”
    * Set “Source Code Management” to “GitHub”
    * Fill out the credentials accordingly (or add new credentials if needed)
    * In the “Repository HTTPS URL” field, paste this URL: [https://github.com/br-automation-com/BnR-Jenkins-Helper-Library.git](https://github.com/br-automation-com/BnR-Jenkins-Helper-Library.git)
    * In the “Library Path” field, paste the following: ./

## Workspace

The workspace is where Jenkins checks out the project from the repo and runs the pipeline.

To reference the workspace in the Jenkinsfile, use the readymade environment variable "$\{WORKSPACE\}"

## Version Info Functions

| Function | Description | Arguments |
|  |  |  |
| Version | Returns full version number based on tag (e.g. 1.2.3.9004)<br /> | workspace |
| ReleaseVersion | Returns Major.Minor.Bugfix style version number<br /> | workspace |
| MajorVersionNumber | Returns just the Major version number | workspace |
| MinorVersionNumber | Returns just the Minor version number | workspace |
| BugFixVersionNumber | Returns just the bug version number | workspace |

## Git Info Functions

| Function | Description | Arguments |
|  |  |  |
| BranchName | Returns the name of the git branch | workspace |
| Tag | Returns the last tag in the branch | workspace |
| IsReleaseCandidate | Returns true if the branch is in the release/* branch | workspace |
| IsReleaseBranch | Returns true if branch is master or main | workspace |

## AR Helper Functions

| Function | Description | Arguments |
|  |  |  |
| BuildASProject | Builds an Automation Studio Project | **project** – path within the workspace to the project (the folder containing the .apj file). For example: "$WORKSPACE\\TestProject"<br />**configuration** – configuration name in the AS project<br />**max_warnings** – the maximum number or build warnings that are allowed in order to consider the build a success. Set this to -1 to accept infinite warnings<br />**buildpip** – whether to build the PIP or not |
| BuildARsimStructure | Creates the ARsim structure | **project** – path within the workspace to the project (the folder containing the .apj file). For example: "$WORKSPACE\\TestProject"<br />**configuration** – configuration name in the AS project |

## Unit Test Functions

| Function | Description | Arguments |
|  |  |  |
| RunArUnitTests | Runs unit test configuration in ArSim | **tests** – the name of the unit tests to run. Use “all” to run all tests<br />**configuration** – configuration name in the AS project that contains the unit tests<br />**project** – path within the workspace to the project (the folder containing the .apj file). For example: "$WORKSPACE\\TestProject“ |
| ProcessArTestResults | Process test results xml files | N/A |

## Information Sharing Functions

| Function | Description | Arguments |
|  |  |  |
| UploadToGitHub | Uploads build artifacts to a GitHub repository | **version** – version number of the artifact<br />**organization** – repo organization name<br />name – repo name<br />**file** – filename of the artifact to upload |
| SendNotifications | Sends an email to team members | **buildStatus** – the status/result of the most recent build of the pipeline<br />**recipients** – list of email addresses to send the email to |

