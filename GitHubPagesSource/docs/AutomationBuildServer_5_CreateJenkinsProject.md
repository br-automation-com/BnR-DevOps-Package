# Create Jenkins project

Note: If you are utilizing the B&R Jenkins server initially, then you can skip the steps in this section.

## Create a Multibranch Pipeline

1. Open the Jenkins server web browser
2. From the Dashboard, click “New Item” in the top left and select “Multibranch Pipeline”
3. Fill out the configuration for this new pipeline. Required changes:
    * Add a Branch Source
        * Fill out the corresponding fields, which vary depending on the source type
    * Set the Build Configuration Mode to “by Jenkinsfile” and update the script path to where you want this file to live in your repo
        * This file is where you will define your pipeline
    * Add the “Clean before checkout” option to the repository
4. Paste the provided template “Jenkinsfile” to the location you specified in step 3b
5. Open the “Jenkinsfile” in a text editor

![](img%5CAutomation%20and%20Build%20Server21.png)

