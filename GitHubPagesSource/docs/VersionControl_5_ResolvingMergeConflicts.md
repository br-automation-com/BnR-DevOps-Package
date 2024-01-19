# Resolving Merge Conflicts

## Definition

* A merge conflict means there are incompatible changes in the files you are trying to merge together
* This can happen, for example, when you are trying to merge two branches together
* This can also happen if you and a teammate are editing the same lines in the same file. For example:
    * Your teammate commits and pushes changes to the server
    * You make changes to the same lines of code and commit the same file to your local server
    * Prior to pushing your changes, you must pull. However, upon trying to pull, you will be notified of the conflict between your local file and the change recently pushed by your teammate
* This section will guide you through how to resolve such merge conflicts
* As mentioned previously, we at B&R use Visual Studio Code to resolve merge conflicts

![](img%5CVersion%20Control40.png)

## How to Resolve Merge Conflicts

Within Sourctree, conflicted files appear with an exclamation mark next to them after you’ve committed and tried to pull changes from the server.

![](img%5CVersion%20Control41.png)

To resolve, right click on the conflicted file and select "Resolve Conflicts &rarr; Launch External Merge Tool".

![](img%5CVersion%20Control72.png)

Visual Studio Code will open. There are 3 options in Visual Studio Code to resolve a conflict:

* Accept Current Change
* Accept Incoming Change
* Accept Both Changes

The Compare Changes option allows you to view the differences side-by-side.

These actions are integrated directly within Visual Studio Code as button selections above each conflict:

![](img%5CVersion%20Control73.png)

The following example will be used to show the result of each of the 3 merge conflict options. In this example:

* <span style="color:#2F7366">"x := x / 3;" is the change to the line made locally. </span>
* <span style="color:#2F628F">"x := x \* 3;" is the change to the line that a teammate has already pushed to the server, which you have not successfully pulled yet. </span>

![](img%5CVersion%20Control43.png)

### Accept Current Change

Apply your local changes and disregard the changes from the server.

Therefore, in this example, we keep the line  <span style="color:#2F7366">"x := x / 3;"</span>

![](img%5CVersion Control_accept.png)

### Accept Incoming Change

Apply the server’s changes and disregard your local changes.

Therefore, in this example, we use the line  <span style="color:#2F628F">"x := x \* 3;"</span>

![](img%5CVersion Control_accept2.png)



### Accept Both Changes

Apply your local changes _and_  the server’s changes.

Therefore, in this example, we now have both lines  <span style="color:#2F7366">"x := x / 3;" </span> and <span style="color:#2F7366"> </span>  <span style="color:#2F628F">"x := x \* 3;"</span>

![](img%5CVersion Control_accept3.png)

### Compare Changes

The Compare Changes option shows a side-by-side view of the conflicting differences.

![](img%5CVersion%20Control46.png)
