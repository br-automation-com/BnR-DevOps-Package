# Sourcetree 

## Installation

[Download](https://sourcetreeapp.com/)

[Installation Guide](https://confluence.atlassian.com/get-started-with-sourcetree/install-sourcetree-847359094.html)

## Add a Remote Account

After installation\, click on the Remote tab and "Add an account…".

![](img%5CVersion%20Control16.png)

In the resulting pop-up, change the hosting service dropdown to "GitHub" or "Bitbucket Server" accordingly, and then click the button to either "Refresh OAuth Token" or "Refresh Password"

![](img%5CVersion%20Control17.png)

Follow the prompts to login on GitHub/Bitbucket and approve the authorization.


## Identify External Merge Tool
The tool we use at B&R to resolving merge conflicts is Visual Studio Code. You can download it [here](https://code.visualstudio.com/).

This tool must be identified in the Sourcetree options. Therefore, after installing Sourcetree and Visual Studio Code, go to Tools &rarr; Options. Select the “Diff” tab.

Within the “External Diff / Merge” section:

  * Set the External Diff Tool dropdown to “Custom”
  * Set the Diff Command to:C:\\Users\\%USERNAME%\\AppData\\Local\\Programs\\Microsoft VS Code\\Code\.exe
  * Set the Diff Command Arguments to: \-\-diff \-\-wait "$LOCAL" "$REMOTE"
  * Set the Merge Tool dropdown to “Custom”
  * Set the Merge Tool to: C:\\Users\\%USERNAME%\\AppData\\Local\\Programs\\Microsoft VS Code\\Code\.exe
  * Set the Merge Tool Arguments to: \-n \-\-wait "$MERGED"

![](img%5CVersion%20Control18.png)

## Authentication Issue - Mistyped Password

If you mistype your password while authorizing your Bitbucket/GitHub account, follow the instructions in [this post](https://stackoverflow.com/questions/45690641/sourcetree-wont-let-me-delete-password) to fully delete the incorrect password and try again.

![](img%5CVersion%20Control19.png)

## Clone Repo

Once your account is activated and working, you can clone a repository from any organization that your account has access to. Select the organization from the dropdown on the right.

If you don’t see any organizations in your dropdown, contact your project leader so that they can grant you access.

The list will then refresh with all available repositories. Click "Clone" next to the one you want to clone.

![](img%5CVersion%20Control20.png)

## Checkout Branch

After you clone a repo, take care to check out the branch that you intend to work on.

The branches that are available on the remote repository are located on the left beneath "REMOTES".

Your local repository branches are listed under "BRANCHES".

The branch that is bolded is the one that you are currently checked out to.

![](img%5CVersion%20Control21.png)

To check out a branch, either double click it or use the right click menu. If you’re checking out a branch for the first time from the remote, make sure to keep the box checked so that the "Local branch should track remote branch".

![](img%5CVersion%20Control22.png)

## Standardized .gitignore File

There are a handful of standardized .gitignore files floating around the B&R universe. For example:

  * [Example 1](https://www.toptal.com/developers/gitignore/api/automationstudio)
  * [Example 2](https://confluence.br-automation.com/display/RDGO/adapt+.gitignore+in+the+repository)
  * [Example 3](https://confluence.br-automation.com/pages/viewpageattachments.action?pageId=140411692)

If you are unsure where to start, the recommended standardized .gitignore file is included within the template files of this DevOps package (which closely matches Example 1 listed above). Note that this .gitignore file should be placed in the root directory of the project (the same directory as the .apj file).

Make sure to add  _and push_  the .gitignore file to the repo **BEFORE** you add any files that should be ignored. If the .gitignore is not ignoring your files as expected, see [here](https://stackoverflow.com/a/53431148)\.

## Tips for Using Git with Safety

If your project includes safety, then there are some additional considerations regarding the .gitignore file:

* You do NOT have to exclude the DLFiles folder when using Git (despite the fact that this is shown at GUID b8c69e5e\-7579\-4e41\-b853\-13cf9ccbef53\). This is only required if you are using Subversion (not Git).
* You MUST INCLUDE all .set files within the safety project
  * Our template .gitignore file contains this exception for you already
* Merging changes in a SafeDESIGNER project is not possible. Only one person can work on the SafeDESIGNER project at a time.
* Even if you don’t make any changes but you simply open the SafeDESIGNER project or compile, several files within the project structure will indeed be updated. This is expected – please always commit and push these changes to keep everything in line and up to date.
  * If it is frustrating for your workflow that many safety files will change each time you compile, then another option to consider is to completely exclude the SafeDESIGNER project from source control and instead include the SD project as a .zip file. Note that you will have to manually include this .zip file within the .gitignore file, since the template is configured to ignore all contained .zip files by default.
* Do not work in parallel!

## Tips for Using Git with VC4

If your project includes a VC4 visualization, do not work in parallel and try to merge changes via source control. Only one person should open or make changes to a VC4 visualization at a time.

The reason is because Git compares XML line by line, but VC4 moves XML around liberally. Therefore, it is very easy to create many merge conflicts that are tedious to solve. It is better to avoid this situation entirely.
