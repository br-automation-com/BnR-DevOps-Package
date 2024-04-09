# Testing

## Setting the Stage

Testing can either be  __automated__  or  __manual__.

In DevOps, the goal is that you have as much automated testing as possible. Therefore, the primary focus of this package is automated testing.

Nonetheless, some manual testing will inevitably be necessary. Therefore, manual testing strategies are provided at the end.

## Definition

Automated testing begins with a defined test plan, comprised of required features and previously discovered bugs.  The test plan is the contract of what the software is expected to deliver.

A consistent set of inputs is used for each test. This allows multiple programmers to execute the tests in the exact same way.

The tests are run automatically - not by hand (manually) by each engineer. 

If a bug is discovered, a new test is written to catch the bug so that once it is fixed, you will always be checking to confirm it does not return in the future.

## Types of Tests

![](img%5CTesting6.png)

## Benefits of Automated Testing

|Benefit | |Details  |
| | | |
|Save time |![](img%5CTesting9.png) |&bull; Running automated tests is MUCH faster than manual testing. <br> &bull; Bugs that are found later in development are more difficult and take longer to fix. |
|Save money |![](img%5CTesting7.png) |&bull; Saving engineering time saves you money! |
|Quality |![](img%5CTesting8.png) |&bull; End up with fewer bugs in production code (studies have shown between 40%-90% less bugs[[source]](https://www.microsoft.com/en-us/research/wp-content/uploads/2009/10/Realizing-Quality-Improvement-Through-Test-Driven-Development-Results-and-Experiences-of-Four-Industrial-Teams-nagappan_tdd.pdf)!)<br>&bull; New tests are written for each new bug that is found. This ensures that future features/bugfixes don’t break existing functionality.<br>&bull; Existing tests are repeatably executed with every release.<br>&bull; Encourages the design of more modular / testable code.<br> |
|Maintainability |![](img%5CTesting10.png) |Increase the testability, readability, and adaptability of the code:<br>&bull; Testability: create thorough and reproducible tests<br>&bull; Readability: tests become a record of bugs and features. Makes it easier for other engineers to understand the code<br>&bull; Adaptability: promotes the creation of modular code<br> |

## Addressing the Arguments Against Automated Testing

| Argument | | Counterargument |
| | | |
|Creating unit tests is too time consuming |![](img%5CTesting11.png) |The result is higher quality software and less bugs in the field. The time you spend writing automated tests would end up being spent (and then some!) during manual testing anyway |
|You can’t write the test until you know the design |![](img%5CTesting12.png) |If you don’t know enough about the requirements to write a test, then you don’t have enough information to write quality code. We must avoid the tendency to start coding before a proper plan is in place |
|Unit testing is hard! |![](img%5CTesting13.png) |It can be difficult at first, but like most things it gets easier the more you do it <br> &emsp;&bull; It is definitely difficult if you wait to add unit tests at the end (don’t do that!) <br>&emsp;&bull; This could also be an indication that your design is not easily testable (too much functionality in a single function / function block / task, etc) <br>&emsp;&bull; Not everything is able to be unit tested. But in those cases, you will rely on manual testing |
|I don’t know how! |![](img%5CTesting14.png) |Hence why this DevOps package exists! |
