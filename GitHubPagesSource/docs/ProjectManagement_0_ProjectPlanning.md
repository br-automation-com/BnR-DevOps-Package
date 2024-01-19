# Project Planning

## Define Personnel Resources

Prior to software development, identify the individuals that will be responsible for various roles. The following list describes the baseline/minimum roles that must be defined. Additional roles may be required depending on the application complexity. Note that one person can hold more than one role.

| Role | Description |
|  |  |
| Project Manager | Responsible for the successful execution the project. Primary decision maker. Handles project version definition.  |
| Application Architect | Responsible for designing the application. Typically, a senior engineer.  |
| Engineer | Responsible for developing the application. Can be any engineer.  |
| Test Manager\* | Defines the tests |
| Test Developer\* | Writes the automated tests |
| Manual Tester\* | Executes the manual tests. Does not analyze the results of any subjective tests (if applicable) |
| Manual Test Approver\* | Analyzes the outcome of the subjective manual tests (if applicable) |

\* Refer to the Testing section 



## Project Overview Diagram

Prior to any software development, create a  **block diagram / class diagram / flow chart** that represents each control element of the machine. This should be created in tandem with the machine specification. 

Once you have this diagram, each block will become an **epic** within your Jira project.

Then the more granular requirements for that control element will become **stories, tasks and bugs** within that epic.

For example: 

![](img%5CProject%20Management31.png)


## Code Design & Testing

As you dive further into the details of the code design, be thinking about how you are going to test the code while you are designing it (and before you start writing it).

The process of writing your unit tests will become easier if you keep them in mind from the get-go.

Refer to the Testing section of this DevOps package for further details.

![](img%5CProject%20Management7.png)


