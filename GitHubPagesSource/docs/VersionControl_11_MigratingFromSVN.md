# Migrating from SVN

![](img%5CVersion%20Control64.png)

## Create Authors File

The authors files will translate svn usernames to email addresses for git.

* PowerShell command to extract all authors from SVN:
    * Must have svn command line tools installed
      * This is an option when installing TortoiseSVN
      * If you are unsure whether you installed it or you know that you didn’t, you can just run the TortoiseSVN installer again and take care to include this option
    * Run the  __authors-export.ps1__ script from within your svn directory
* Edit authors.txt file to match the following format:
```
buchananw = Wesley Buchanan <wesley.buchanan@br-automation.com>
www-data = system <noreply@br-automation.com>
```


## Clone Repository

For standard layout of trunk, branchs, tags:
  
``` bash
git svn clone \[SVN repo URL\] --prefix=svn/ --no-metadata --authors-file "authors.txt" --stdlayout
```

For non-standard layout (B&R’s svn repository):
  
``` bash
git svn init \[SVN repo URL\] --no-metadata
git svn fetch –authors-file "authors.txt"
```

## Convert SVN ignore

``` bash
git svn show-ignore > .gitignore
git add .gitignore
git commit --m ‘convert svn:ignore to .gitignore’
```

## Push to New Git Repository

``` bash
git remote add origin \[my new git repo\].git
git add .
git commit --m ‘migrating svn to git’
git push --u origin main
```

## Sync New SVN Commits

``` bash
git svn rebase
git push
```
