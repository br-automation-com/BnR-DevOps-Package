# Jira

## Issues

### Terminology

Every work item within Jira is generically referred to as an "Issue". 
This applies to things like bugs / tasks, as well as projects as a whole.
Therefore, don’t be concerned if you attempt to create a Project, for example, but the dialog says "Create Issue".

![](img%5CProject%20Management8.png)


### Jira Issue Hierarchy

The following graphic summarizes the hierarchy of issues within Jira.

At the top level you have either a Project or a Service Project.

![](img%5CProject%20Management9.png)



### Jira Issue Types

The following five issue types are used to define all work within a project:

| 					| Epic | Story | Task | Sub-Task | Bug | 
|  					|  	|  |  |  |  |
| **Symbol**		|![](img%5CProject%20Management10.png)|![](img%5CProject%20Management12.png)|![](img%5CProject%20Management32.png)|![](img%5CProject%20Management11.png) |![](img%5CProject%20Management14.png)|
| **Description** 	|&bull; Feature / module, or high-level requirement <br> &bull; Large chunk of work <br> &bull; Can broken down into smaller pieces |&bull; Piece of work within an epic <br> &bull; Has a clear, defined value to the end user  |&bull; Piece of work within an epic <br> &bull; Does not directly bring value to the end user <br> &bull; Does not require specification or review  |&bull; Piece of work within a story, task or bug <br> &bull; Used to divide a story into specific chunks  |&bull; Problem that impacts or prevents the function of a feature <br> &bull; Unwanted or unexpected behavior  |
| **Examples** 		|&bull; HMI <br> &bull; Module <br> &bull; Station	|&bull; Communication program <br> &bull; Alarms page <br> &bull; Trak process point code |&bull; Set up Hypervisor <br> &bull; Set up an SQL database |&bull;  Add alarms to task |&bull;  Page fault <br> &bull; mapp View button not working  |


### Create an Issue


To create a story, task, bug, or epic, do the following:

1. Open the project in Jira
2. Click the “Create” button at the top
3. Select the proper issue type from the “Issue Type” dropdown
4. Fill out the rest of the form accordingly

The newly created issue will then be sent to your backlog.

![](img%5CProject%20Management15.png)


To create a sub-task, the workflow is slightly different. In this case: 

1. Open up the issue that you want to create a sub-task under
2. Go to "More" &rarr; "Create sub-task"
3. Fill out the fields accordingly

![](img%5CProject%20Management16.png)

### Changing the Issue Type

If you created a new Jira issue but accidentally created it with the wrong type, you can adjust it after the fact as follows:

1. Navigate to the Jira issue
2. Go to "More" &rarr; "Move"
3. Change the "Current Issue Type" dropdown to the intended issue type
4. Click Next and follow the subsequent prompts (which vary depending on the new issue type)

![](img%5CProject%20Management18.png)

---

## Project Topics


### Jira Project Pages

The following pages are available in every Jira project:

| Page | Description |
|  |  |
| Backlog | Displays all open issues which are currently being worked on, as well as all issues that are waiting to be assigned in the future |
| Active sprints / Kanban board | Displays the current sprint or the Kanban board, depending on which board is currently selected via the dropdown right above the Backlog page |
| Releases | Allows you to define release versions, which can then be assigned to each Jira issue. Big-picture deadlines for development. Allows you to see a progress bar for how far along you are in a particular release.  |
| Reports | Allows you to view the status and progress of the whole project.  |
| Issues | Lists out all issues within the project. Can be filtered.  |
| Components | Similar to releases, but for topics rather than a point in time / due date. Useful for collecting all issues related to one topic, even if they span multiple epics (e.g. all motion issues).  |
| Timesheets | Allows you to see time logged to the project by the various contributors  |
| Structure | Allows you to create customizable filters for project analysis |
| Objects | Currently unused at B&R |

![](img%5CProject%20Management19.png)


### Components vs Epics

Comparison

Components and Epics are quite similar in that they are higher level containers for Jira issues. However, there are some key differences:

|  | Components | Epics |
|  |  |  |
| **Duration** | Exists for the duration of the project | Intended to be completed and closed out within a shorter time frame than the project as a whole. (Can also remain open for the whole project, but generally intended to be completed at some point) |
| **Intended use** | Topic related. Issues that belong to one component can be spread out across multiple epics | Intended for a specific feature or module of the machine |
| **Quantity** | Multiple components can be assigned to each issue | Only one epic can be assigned to each issue |
| **Time tracking** | No requirement | Every Jira issue must be assigned to an Epic for time tracking to function properly |
| **Filter capability** | Has a dedicated page within the Jira project sidebar which makes it easy to select a component and view all corresponding issues. You can also see all issues assigned to a component by using the “Component” filter option in the issue filter | See all issues assigned to an epic by using the “Epic Link” filter option in the issue filter |



### Releases

Release versions allow you to define a software version and then assign Jira issues to that version (via the "Fix Version" field in the issue details).

![](img%5CProject%20Management21.png)

While the release is in progress, you get a progress bar showing how far along you are in completing all of the things assigned to that release.

![](img%5CProject%20Management20.png)

Once you complete a release, you can view all issues related to the release as well as a full list of built-in release notes.

![](img%5CProject%20Management22.png)

---

## Boards

### Kanban and Sprint

There are two types of boards in a Jira project:

1. Kanban
    * Define different workflow stages (e.g. To Do, In Progress, Done) as columns (aka swimlanes) and move each Jira issue through the process as it’s being worked on
    * Issues are organized by epic
2. Scrum/Sprint
    * Similar to Kanban, but limits your scope of work to only the tasks within the active sprint
    * Sprints are short periods of time (typically about 2 weeks) that are essentially short-term goals for progress on the overall project
	* Assign/plan work that is achievable to complete in that time frame, and then focus exclusively on those tasks. Planning out the work in short intervals like this helps you to make continual progress on a project, rather than inadvertently waiting until close to the deadline to try to cram everything in
	* We highly recommend the use of sprints, as they are an invaluable time management tool



### How to Create Boards

Create a new board via the dropdown at the top of the sidebar:

![](img%5CProject%20Management23.png)

You will then have the option to create either a scrum board or Kanban board:

![](img%5CProject%20Management24.png)





### How to Configure Boards

Configure the board via the "Board" dropdown on the right side. 

![](img%5CProject%20Management25.png)

This is where you define your columns and what issue statuses belong in each column. The column definition is up to your personal preference. If you have no strong preference, then we recommend the following setup:

![](img%5CProject%20Management26.png)

