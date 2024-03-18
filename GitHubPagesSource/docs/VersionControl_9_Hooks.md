# Hooks

## Overview

Hooks are scripts that automatically run at certain git repository events. 

* [Basic definition](https://git-scm.com/docs/githooks)
* [Customization](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)
* [Summary](https://www.atlassian.com/git/tutorials/git-hooks)

There are two types of hooks:

1. Local Hooks: for events related to committing or checking-out to your local repo
2. Server Hooks: for events related to pushing changes to the remote server
    * Note that tasks accomplished via server hooks can (and arguably should) be accomplished by the build/automation server instead

## Location and Samples

All hooks are located in the .git/hooks folder.
  
  * The .git folder is located in the root directory of the repo
  * Note that this is a hidden folder, so make sure those are shown in your file explorer

Many sample hooks are pre-populated within the .git/hooks folder to use as a starting point.
  
  * They are all of the ".sample" file extension
  * To activate a pre-made hook for your repo, simply remove the ".sample" file extension

![](img%5CVersion%20Control62.png)

## Local Hooks

Overview of commonly used local hooks:

* pre-commit
    * Runs before you attempt to commit to the repository
    * Useful for code quality checks (whitespace errors, modules OK not monitored, etc)
* prepare-commit-msg
    * Runs after pre-commit
    * Useful for prepopulating commit messages
* commit-msg
    * Runs after the commit message
    * Useful for checking commit message standards (reference JIRA issue)
* post-commit
    * Runs after a commit
    * Trigger local integration tests
* post-checkout
    * Runs after a checkout
    * Useful for cleaning workspace (clean AS project)

## Server Hooks

Overview of commonly used server hooks:

* pre-receive
    * Runs when someone attempts to push commits to the repository
    * Enforce any development policy (code quality/standard checks, commit message checks, etc)
    * Called once per push
* update
    * Runs after pre-receive
    * Called separately for each ref (branch) that was pushed
    * Reject single ref’s in a push instead of the entire push
* post-receive
    * Runs after a successful push
    * Useful for triggering continuous integration system (e.g., could automatically trigger the Jenkins build)
    * Useful for notifications