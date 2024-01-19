# Code Review Strategy

## When to Review

__Prior__  to closing out a feature via Git-flow (and therefore merging the feature into the develop branch), we recommend that the feature gets  __reviewed__  by a peer engineer or the project lead

If any changes are required per the review, they would then be implemented on the same feature branch before it is closed

## Why to Review

There are 2 purposes of a code review:

1. Increase the code quality
    * Confirm that the feature indeed works
    * Brainstorm if the implementation is optimal or if it should be adjusted
2. Increase the number of people that are familiar with the code
    * By executing a review, this guarantees that at least one other person is familiar with the feature and how it is implemented in case the original developer becomes unavailable

## Scheduling Code Reviews

* The best way to trigger a code review is via a pull request
      * This can be triggered from Sourcetree: right click on the branch and select "pull request"
* Then the status of the pull requests will be visible to everyone who has access to the repository, and there will be a paper trail for all code reviews
* You can also choose to lock the develop/main branches so that a pull request is absolutely required before anything can be merged to it

