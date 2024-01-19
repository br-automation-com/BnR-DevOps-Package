# Integration with Bitbucket

To integrate Jenkins with Bitbucket, follow these steps. 

From the Bitbucket project, click on your user icon and select “Manage account”:

![](img%5CAutomation%20and%20Build%20Server39.png)

Select “HTTP access token” in the menu on the left. Then click "Create token":

![](img%5CAutomation%20and%20Build%20Server40.png)

Add a token name. Set the Permissions to “Repository read”. Click “Create”:

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

