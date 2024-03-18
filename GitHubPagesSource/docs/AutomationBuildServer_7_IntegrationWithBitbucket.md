# Integration with Bitbucket

To integrate Jenkins with Bitbucket, follow these steps. 

From the Bitbucket project, click on your user icon and select “Manage account”:

![](img%5CAutomation%20and%20Build%20Server39.png)

Select “HTTP access token” in the menu on the left. Then click "Create token":

![](img%5CAutomation%20and%20Build%20Server40.png)

Add a token name. Set the Permissions to “Repository read”. Click “Create”:

_Note: see below if using Jenkins to setup the webhook for additional options_

![](img%5CAutomation%20and%20Build%20Server41.png)

Make sure to copy the generated token as you will not be able view this again.

![](img%5CAutomation%20and%20Build%20Server42.png)

Create new project in Jenkins. Enter name of project. Select multibranch pipeline:

![](img%5CAutomation%20and%20Build%20Server53.png)

Add source - select Bitbucket: 

![](img%5CAutomation%20and%20Build%20Server44.png)

Add Credential - select project name:

![](img%5CAutomation%20and%20Build%20Server43.png)

Change “Kind” to “Username with password”. Paste the HTTP access token created from Bitbucket. Give unique ID:

![](img%5CAutomation%20and%20Build%20Server45.png)

Select new Credential. Set the “Owner” to the Bitbucket project key (4 letter identifier). Once the Owner is entered, the Repository Name should show up in list:

![](img%5CAutomation%20and%20Build%20Server54.png)

Then Add “Advanced clone behaviors”, and ensure that “Fetch tags” is checked:

![](img%5CAutomation%20and%20Build%20Server46.png)

![](img%5CAutomation%20and%20Build%20Server47.png)

After saving, the repositories will be scanned:

![](img%5CAutomation%20and%20Build%20Server48.png)

To automatically start a build when a commit is pushed to the repository you have 2 options.

**Allow Jenkins to automatically setup the webhook on Bitbucket**

When creating the access token in Bitbucket give the permission 

![](img%5CAutomation%20and%20Build%20Server%20-%20Project%20Admin%20Rights.png){: style="border: 1px solid gray;"}

Then configure your project in Jenkins

![](img%5CAutomation%20and%20Build%20Server%20-%20Configure%20Jenkins.png)

- Add the option "Override hook management" to the repository settings

![](img%5CAutomation%20and%20Build%20Server%20-%20Override%20Hook%20Management.png){: style="border: 1px solid gray;"}

- Select the "Use item credentials for hook management" option

![](img%5CAutomation%20and%20Build%20Server%20-%20item%20credentials%20for%20hook%20management.png){: style="border: 1px solid gray;"}

- Once saved Jenkins will automatically add the required webhook to the Bitbucket repository

**To manually setup the webhook in Bitbucket**

- First goto the settings on the Bitbucket project

![](img%5CAutomation%20and%20Build%20Server%20-%20Bitbucket%20repository%20setttings.png){: style="border: 1px solid gray;"}

- Goto the webhooks section

![](img%5CAutomation%20and%20Build%20Server%20-%20Bitbucket%20webhooks.png){: style="border: 1px solid gray;"}

- Give your new webhook a name and change the url to http://&lt;jenkins_url&gt;:8080/bitbucket-scmsource-hook/notify?server_url=https%3A%2F%2F&lt;bitbucket_url&gt;
- Select the following options for the webhook

![](img%5CAutomation%20and%20Build%20Server%20-%20Bitbucket%20webhook%20settings.png){: style="border: 1px solid gray;"}

- And then save the webhook
