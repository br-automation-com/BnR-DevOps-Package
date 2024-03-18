# Versioning

## Tagging

Each merge into the main branch should be [tagged](https://confluence.atlassian.com/sourcetreekb/adding-moving-and-removing-tags-in-sourcetree-785327501.html#:~:text=Solution%201%20Access%20the%20Tag%20Menu%20To%20access,a%20tag%20...%204%20Moving%20a%20tag%20) with a version number.

When you close a release via Git-flow, you can add the version number tag directly in the dialog box:

![](img%5CVersion%20Control51.png)

Git-flow will merge the release branch into main and develop. Afterwards, make sure to checkout and push both branches.

## Version Number Scheme

The version number scheme we use at B&R is:  <span style="color:#C00000"> __XX__ </span>  __.__  <span style="color:#007A33"> __YY__ </span>  __.__  <span style="color:#2684FF"> __ZZ__ </span>

  * <span style="color:#C00000"> __XX = Major Revision__ </span>
    * Incompatible with previous major revisions
  * <span style="color:#007A33"> __YY = Minor Revision __ </span>
    * New features added
  * <span style="color:#2684FF"> __ZZ = Bug Fixes__ </span>
    * No new features, just small changes / bugfixes

