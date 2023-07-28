REM # Set the default branch to 'main' (instead of master)
git config --global init.defaultBranch main
REM REM # Use schannel to use Windows certificate store
REM git config --global http.sslBackend schannel
REM 
REM # credential helper settings
git config --global credential.helperselector manager-core

REM # prevent git from "corrupting" DTM files
git config --global core.autocrlf false

REM # recursively update submodules
git config --global submodule.recurse true

REM # give errors if there are whitespace at the end of line but not for a blank line at end of the file
REM git config --global core.whitespace blank-at-eol,-blank-at-eof

git config --global credential.https://bitbucket-qs.br-automation.com.provider generic
git config --global credential.https://bitbucket.br-automation.com.provider generic

REM # increase the buffer size to accommodate large pushes to the remote
git config --global http.postBuffer 524288000

REM uncomment to use VS Code as your merge and diff tool for sourcetree
REM git config --global difftool.sourcetree.cmd "'C:/Program Files/Microsoft VS Code/Code.exe' --diff --wait $LOCAL $REMOTE"
REM git config --global mergetool.sourcetree.cmd "'C:/Program Files/Microsoft VS Code/Code.exe' -n --wait $MERGED"
REM git config --global mergetool.sourcetree.trustExitCode true
