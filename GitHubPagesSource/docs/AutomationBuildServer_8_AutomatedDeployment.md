# Automated Deployment

Recommendations on automated deployment will be added in a future revision of the B&R DevOps package.

For an immediate solution, consider [Shuv](https://loupe.team/story/introducing-shuv/)\. Shuv handles many aspects of the CI/CD process for you, in addition to automated deployment.

![](img%5CAutomation%20and%20Build%20Server49.png)

Shuv handles the following processes: 

* Manages CI/CD pipelines for your Automation Studio projects and B&R PLCs
* Automated pipelines trigger on Git events
* Builds simulator and physical PIPs
* Runs unit tests and integration tests against the simulator
* Integrates with Git to keep track of code versions
* Delivers OTA software updates to PLCs that are connected to Shuv via MQTTS

![](img%5CAutomation%20and%20Build%20Server55.png)

Note that there is a cost to use Shuv (it is not free). 


