# Submodules

## Definition & Use Cases

* A [submodule](https://confluence.atlassian.com/sourcetreekb/adding-a-submodule-subtree-with-sourcetree-785332086.html) is a reference to another git repository within your repository
    * The submodule repo (child repo) is managed completely independently
    * The parent repo references a specific commit within the submodule that it is currently using
* Uses Cases within an AS project:
    * Separating out project components (custom libraries, application modules)
    * Same use case as a feature branch, but isolated to its own repository
    * Delegating a part of the project to a third party

## Use Case Highlight: Separating Out Project Components

### Situation

* A project/repo is used for a series machine. There is a specific feature that is only needed for 1 machine. What is the best way to manage this?

### Submodule Implementation

* Use a submodule for the one-off feature.
* The submodule points to a package in the Logical View containing all of the files needed for the one-off feature.
* If Configuration View files are needed as well for the feature, they would still be placed in this folder so that one single submodule can manage the files. Then after you add the submodule to your project, you would have to manually add referenced files in the Configuration View to the appropriate files from that package.
  * If you don’t do it this way then you’d have to manage 2 or more submodules for one feature, since a submodule can only point to one specific directory, which would be quite difficult to manage.

### Example

* One example where this submodule method works quite nicely is if the one-off feature could be contained completely in a library.
* There would be one version of the library that is used for the series of the machines, and another version of the library that is adjusted as needed for the one-off.
* In this case, the submodule would contain just that library. The project repo points to a submodule for that library:
  * The main branch (for the series machines) points to a submodule with the commonly used library implementation
  * Then there would be a separate branch for the one-off machine, which would point to a different submodule containing the modified version of the library
* In this situation, the code itself remains unchanged since we are just swapping out which library is being utilized. The inputs/outputs are consistent.

### Caveat

* If, however, the one-off feature is too tangled/embedded in the application to where it’s not perfectly modular (e.g. you have to modify existing files, not just add new files), then this submodule method may not make the most sense.
* In this case, the alternate suggestion is to have a branch for the one-off machine and make the necessary changes in that branch.
* As updates are made to the main branch, merge main into the one-off branch. If ever there is an incompatibility between main and the one-off feature, then the feature would be adjusted within the one-off branch.



## Submodule Workflow

* Commit/push changes to the submodule repo as usual
* Commit/push changes to parent repo to update the commit reference ("pointer") to the submodule
    * The parent repo keeps records what commit hash it is currently using of the submodule. So, if you push a change to the submodule without committing the new reference commit value in the parent repo, then the parent repo will still be referencing the previous commit in the submodule.
* This is how a submodule reference looks within Sourcetree, prior to staging the change. In this example, "BaseProject" is the submodule (child) repo.
    * Once this change is pushed to the parent repo, the parent repo is now using the commit starting with "08fb" on the submodule

![](img%5CVersion%20Control57.png)

![](img%5CVersion%20Control58.png)

## Detached Head

* When you use submodules, you have a higher risk if ending up on a detachd head. 
* Make sure if you commit to the top-level project that you also commit any submodules that have changes to them.
* If you don’t, then you’ll end up on a detached head on the submodule repository
    * This means your latest changes within that repo will be reverted to the last commit to the top-level repository, which can be confusing. It also means that any new commits to the sub repository are not associated with any branch, which is not good!
* To recover from a detached head: ([Source](https://community.atlassian.com/t5/Sourcetree-questions/Fix-a-detached-head-lost-master-branch/qaq-p/165563#:~:text=Right-click%20on%20your%20most%20recent%20commit%20in%20the,master%2C%20then%20merge%20your%20new%20branch%20into%20it.))
    * Do NOT check out any other branch (stay on the detached head)
    * Right click on your most recent commit in the detached head and select "Branch"
    * Give the branch a name. Leave "Specified commit:" selected. Uncheck the "Checkout New Branch".
    * Afterwards, confirm in SourceTree that the new branch is on your latest commit.
    * Now you can checkout the develop branch and merge the branch you just created into it. Afterwards, delete that branch.