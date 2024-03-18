# Branching

## The Basics

[Branch Management](https://confluence.atlassian.com/sourcetreekb/branch-management-785325799.html)

[Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)

[Creating and Merging Branches (YouTube video)](https://www.youtube.com/watch?v=S2TUommS3O0)

## Gitflow Branching

At B&R we follow the Gitflow branch strategy:

* Two long-living branches:
    * main
	    * Officially released code
		* As bug-free as possible
        * Each merge into main must be tagged with a version number
        * There is only 1 instance of the main branch, and it is never deleted
    * develop
	    * Integration branch for new features
        * Latest development version ready for testing (may contain bugs)
        * Should compile and run on real hardware
        * There is only 1 instance of the develop branch, and it is never deleted
        * Create a  __release__  branch from the develop branch once you are ready to prep for release
* Supporting branches (temporary):
    * feature
	    * Used for developing new features
        * Several feature branches can exist simultaneously
        * Can be both local and remote
        * Useful anytime you expect to commit multiple times for one particular feature, even if the feature is completed within a short period of time
        * Merged back into  __develop__  after the feature has been reviewed and it is ready for integration testing. Then the branch is deleted.
    * release
	    * branched from  __develop__  once all planned bugs/features are merged for the next release
        * Only used for bug fixes, documentation, and other release oriented tasks (no new features)
        * Merged back into  __main__ and __develop__ once testing is complete and discovered bugs are fixed. Then the branch is deleted.
    * hotfix
	    * Branched from  __main__  when critical bug found in production that must be solved immediately
        * Used to develop critical bugfixes
        * Merged back into  __main__ and __develop__. Then the branch is deleted.
	
![](img%5CVersion%20Control71.png)


## Manual vs Git-flow

You can use the icons at the top of Sourcetree to manually branch and merge according to the strategy previously described.

![](img%5CVersion%20Control34.png)

Alternatively, you can use the Git-flow icon in the top right. Git-flow guides you to follow the branching strategy with a simple GUI. This is the recommended method.

![](img%5CVersion%20Control35.png)

## Git-flow

When you first launch Git-flow, you must initialize the repo for Git-flow. Remember to change the production branch name to "main" ("master" is the default value).

![](img%5CVersion%20Control36.png)

After initialization, click the "Git-flow" icon again to start a new action.

As application engineers, you will typically select the "Start New Feature" action. The project lead will start the release or hotfixes.

![](img%5CVersion%20Control37.png)

## Git-flow Feature

When you start a new feature, give it a name and then confirm that it starts at the "develop" branch.

![](img%5CVersion%20Control38.png)

Commit and push to your feature branch as needed during development.

Execute a code review (more on this later).

Once complete and reviewed, click the "Git-flow" icon again and select "Finish Feature". This will merge the feature branch back into develop for you and delete the feature branch.

![](img%5CVersion%20Control39.png)