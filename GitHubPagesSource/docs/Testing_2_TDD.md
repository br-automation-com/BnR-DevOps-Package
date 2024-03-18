# Test Driven Development

## Overview 

We will not only be focusing simply on automated unit tests themselves, but also on the **Test Driven Development (TDD)** workflow, which provides guidelines for when/how to write your tests.

![](img%5CTesting20.png)

The process is as follows: 

1. Write the test
    * In TDD, the test is written BEFORE the feature itself
  
2. Run the test
    * The test must fail because the feature has not been implemented yet
    * If the test succeeds, re-work the test until it fails
  
3. Write the code for the feature
    * Afterwards, run the test. If the feature was implemented correctly, the test should pass
    * If the test fails, re-work the feature until the test passes

4. Run all tests, check if they succeed

5. If all tests succeed, consider refactoring
    * Now that you have identified what needs to be done in order to pass each test, you may realize a better way to accomplish a feature. Refactor accordingly.
    * If some tests fail, correct the features and/or the tests themselves
 
Once this whole process is complete, return to the “Test First” development phase by writing the tests for the next features to be implemented (step 1).

## What to Test

* Test the common / baseline functionality
    * This will tell you when the code breaks after you made a change (new feature / bugfix)
* Test the edge cases of unusually complex code that you think could have potential errors
    * This is code that is likely to break when changes are made
* Whenever you find a bug, write a new test case to cover it **before** fixing it
    * This ensures that you have correctly identified how to reproduce the bug and that your fix is correct
    * It also ensures that you will catch it if the bug returns due to a code change in the future
* Add edge case tests to less critical code whenever you have extra time
    * Increases code quality when time permits

![](img%5CTesting21.png)

## What/When NOT to Test

Automated Testing

* <span style="color:#FF0000"> __Do__ </span>   <span style="color:#FF0000"> __not__ </span>  write tests for trivial code
* <span style="color:#FF0000"> __Do__ </span>   <span style="color:#FF0000"> __not__ </span>  write trivial tests that don’t add benefit to your process
* <span style="color:#FF0000"> __Do__ </span>   <span style="color:#FF0000"> __not__ </span>  use unit testing to test system level functions
    * Better covered by integration tests or manual testing, as opposed to unit testing
    * Integration test recommendations coming soon
* <span style="color:#FF0000"> __Do__ </span>   <span style="color:#FF0000"> __not__ </span>  write tests while the application requirements are still rapidly changing
    * Remember, the requirements must be clearly defined up front in order to write meaningful tests and quality code
* <span style="color:#FF0000"> __Do__ </span>   <span style="color:#FF0000"> __not__ </span>  wait until the end of the application development to write all your tests
    * It is quite easy to end up with a lot of code that is difficult to test because it is not written in a modular way

![](img%5CTesting22.png)

## Backfilling Unit Tests into Existing Projects

Although Test Driven Development is indeed the best way to work, there will be some instances where you will be forced to backfill unit tests rather than integrate them as you go.

Most commonly, this will occur if you are working on an established / existing project that does not yet have any unit tests implemented.

The unit tests that you should definitely and immediately implement (even if no other tests exist yet) are tests for new bugs that you encounter and fix.

**Without a doubt, it is valuable to backfill unit tests!**

However, there are some additional considerations / tips to keep in mind for this situation. Therefore, here are some tips for backfilling unit tests: 

![](img%5CTesting24.png)

  * Understand the existing code. Define or find the spec for this code, because those are the “rules” that you will be testing for.
  * Review your existing manual test plan and identify the tests that you can automate
  * Wait until the end of development for features that are already in progress
      * If you are refactoring existing code or the application is in flux, do not write the unit tests yet
      * Since the tests were not the very first thing you did (aka TDD), they should be the very last thing you do
      * Brand new features should be implemented with TDD
  * You may want/need to refactor existing code to make it more testable
  * Do not test trivial things
      * This is especially a risk when you are backfilling
      * Focus on things that are in the project specification. If you are writing tests for things that are not in the spec, this is a hint that they might be trivial / unhelpful / meaningless
      * Test things that you actually expect might break in the future
  * Make sure you are adding value
      * Don’t backfill just for the sake of backfilling. Make the tests count.
      * Put in enough effort so that you trust the results of the test even though they were an afterthought.
      * If no value is added, you will not convince others (or yourself) to write unit tests for projects in the future

