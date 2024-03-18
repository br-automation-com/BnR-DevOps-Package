# How to Build a Test Plan

## Overview 

The testing process begins with a solid and complete test plan that is closely linked to the project spec.

The test plan must be thoughtfully written before testing and development begin. The requirements \+ project specification \+ test plan all go together. These should be completed before you write any code.

In this section, we will identify recommendations for building such a test plan. The overall  steps are as follows:

![](img%5CTesting53.png)

## Analyze the Application

The first step in building a test plan is to fully understand the application under test. **Therefore, the specification must be written before you can create your test plan**.

* For new projects, the base functionality must be defined
* For new features in an existing project, the details for that feature must be defined

Remember: If the project has not been defined yet, then you cannot write reliable or quality code (not to mention, quality tests!)

## Design the Test Strategy

There are several things that must be defined in the overall test strategy:

1. Testing Scope
2. Testing Type
3. Resource Planning
4. Testing Schedule


### Testing Scope

Based on the project specification, define what will and will not be tested.

### Testing Type

This DevOps package provides direct recommendations on unit testing, mapp View integration testing, and manual testing. 

Additional integration testing strategies will be added in the future.

### Resource Planning

Define at least one personnel resource for the following 4 testing roles. Note that one single person can hold multiple roles:

| Role | Description |
| | |
| Test manager  | Defines the tests |
| Test developer  | Writes the automated tests |
| Manual tester  | Executes the manual tests. Does not analyze the results of any subjective tests (if applicable)<br />Note: This should not be the programmer. Ideally should be an experience user of the machine under test |
| Manual test approver  | Analyzes the outcome of the subjective manual tests (if applicable) |

Then, define the test environments: 

| Test Environment | Description / Action Items |
| | |
| Automated test environment  | Refer to the Build Server section of this DevOps package |
| On-machine testing | &bull; Identify the point of contact for scheduling machine time<br />&bull; Identify any materials and prerequisites needed for on-machine testing  <br />&bull; Estimate the time expected to complete the manual tests<br />&bull; Identify the testing location (OEM or end user)<br />&bull; Remember: manual testing is a distinct step from commissioning!  |

### Testing Schedule

Identify how often you will run the automated tests. Refer to the Build Server section of this DevOps package. 

Identify when and how often you will run the manual tests, first in simulation and then on machine.

Plan a time to review all test results and define the next steps. 

## Define the Test Module and Test Cases

Definitions:

* A test module describes an overall functionality on the machine. This is used for organizing all of the test cases.
* A test case is a specific, granular test condition. Several test cases are used to fully test a test module.

Examples:

* Test Module: Alarm System
    * Test Case 1: Confirm that the alarm history successfully exports
    * Test Case 2: Confirm that the AlarmList widget on the HMI properly displays the alarms
    * …
  * Test Module: Recipe System
    * Test Case 1: Confirm you are warned / prompted if the default recipe is missing
    * Test Case 2: Confirm that you can edit the active recipe and the changes are applied immediately
    * …

Directives:

  * All test modules and corresponding test cases must be defined. This should be done within the testing template excel sheet that is provided in this DevOps package
  * Identify whether each test case will be implemented with unit testing or manual testing
  * Identify who has ownership of each test case 

<br>

Below is a list of generic tests that should be applied to every machine. This list will continue to be expanded to over time.

HMI

* All inputs should have proper limits (>max and <min are not permitted)
* Language changes accordingly as well as all the text fits in the given spaces in all languages
* Unit conversion functions
* Confirm that inputs are locked out for users that don't have access. Part of the manual tests.
* Confirm the alarm list is visible / working properly, and that alarms are acknowledgeable
* If HMI gets disconnected from the PLC (in hardware topologies where this is possible), test that recovery is possible, but also that commands don't happen unintendedly after disconnect (i.e. if you are manually jogging, disconnect, don't keep jogging indefinitely) (i.e. if you are in automatic mode, HMI disconnects, is it ok to continue?)
* Manually test for system responsiveness, if it is "good enough“

Basic Motion

* E-stop, confirm it works
* Homing, confirm it works and it's repeatable
* Software limits (confirm the axis stops after reaching the limit)
* Hardware limits (confirm the axis stops after reaching the limit and before the hard stop)
* Jog, confirm it works
* Error conditions and recovery - examples: lag error, loss of comm from the PLC to the drive, etc. Will depend on the app, but think about these error conditions and confirm that you can successfully recover.

IO

* Check that the ModuleOKs are monitored and that the response is as intended (just an alarm, stop the machine, service mode, etc)
* For any IO points that have a status feedback, make sure you're monitoring them and doing something with that information. The test here is regarding what you actually do with that status information. Confirm that the next step works.
* Fieldbuses- if disconnected, check you can recover, and that the machine responds in the way that you need it to.

Data management

* Wear level monitoring info that came in AR4.9, make sure you are using that information and that the response is as intended.
* If your file device storage medium gets full, check that upon trying to save new data you are appropriately warned and that you don't lose any data

## Test Execution and Reporting

Automated Tests

* The automation server executes the tests in ARsim and provides a report on the automated tests
* Refer to the Automation Server section of this DevOps package

Manual Tests

* Manual tests are manually executed and reported
* Manual testing should be done only after the Automated Tests are in a good state (mostly or fully all passing)
* To help keep track of the status of the manual tests, there is a template Excel file provided in this package
* Details for how to use the file are included on the first tab (“Overview”)
* Be sure to identify the software version you are testing in the sheet, so that it is clear exactly what version you have tested

At this step you must also define the overall test criteria for what constitutes pass/fail. At what point do you consider a feature or the machine as a whole "done"?

It is indeed possible that a machine can ship with certain defects (failed tests). It is up to the project manager discretion whether a specific test is a show-stopper or not. Ask yourself: Is the cost of delaying shipment worth the defect?

Execute all tests at least once. For each failed test, identify if the test case is a showstopper or not. This saves you from having to make this decision for every single test. In practice you only need to decide for tests that fail at any point. Alternatively, you can define a priority for each failed test. Then pick a cutoff point where the machine can ship despite defects.
