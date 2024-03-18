# Manual Testing

## Template Excel File

For the situations where it is not possible to write an automated test, manual testing must be done. To help keep track of the status of the manual tests, there is a template Excel file provided in this package.

Details for how to use the file are included on the Overview tab of the sheet. 

![](img%5CTesting48.png)

![](img%5CTesting49.png)

## Multiple Asserts

When defining your manual tests, it can be advantageous to combine more than one expected result (assert) into one test. Manual testing is more “expensive” since it takes more time. So, designing your tests in such a way that a couple of things that are naturally related can be checked over the course of a test can make sense (as opposed to one dedicated assert per test).

However, this must be balanced with being able to get useful information out of a failed test. If your test is written in such a way that 10 things are checked all within one test, then if that test fails you will spend additional time trying to figure out exactly where/how it failed.

Keep this in mind as you design your tests. 


### Good Examples

Multiple asserts that are related to minimize testing effort:

![](img%5CTesting55.png)
![](img%5CTesting51.png)



### Bad Examples

Tedious test that should be automated (error prone when executed manually):

![](img%5CTesting52.png)

