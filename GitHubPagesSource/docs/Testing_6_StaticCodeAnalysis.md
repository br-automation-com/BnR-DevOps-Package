---
llvm_install: https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.0/LLVM-18.1.0-win64.exe
template_url: https://github.com/br-automation-com/BnR-DevOps-Package/raw/main/Testing/Template%20Files/StaticCodeAnalysis
---

# Static Code Analysis

Static code analysis software (aka linter) analyzes the program without actually executing it

Commonly this is preformed in order to:

* Look for common coding mistakes that can lead to bugs or maintenance issues in the future.
* Ensure required coding standards are used

Currently static code analysis available for C/C++ using [clang-tidy](https://clang.llvm.org/extra/clang-tidy/)

## Install Clang-tidy

Clang-tidy is part of the LLVM project.

Download the latest version of [llvm]({{ llvm_install }}) and install it on your machine.

## Included Template files

In our templates directory we have included a [package]({{ template_url }}) that can be added to your Automation Studio project.
This includes the following:

| File | Description |
| | |
| [RunClangTidy.bat]( {{ template_url }}/RunClangTidy.bat) | For running clang-tidy |
| [clang-tidy.opt]( {{ template_url }}/clang-tidy.opt) | Configuration options for clang-tidy |
| [Get-AsContent.ps1]( {{ template_url }}/Get-AsContent.ps1) | powershell script to read the contents of the Automation Studio project |
| [helpermod.psm1]( {{ template_url }}/helpermod.psm1) | powershell helper module |
| [Read-AsBuildOptions.ps1]( {{ template_url }}/Read-AsBuildOptions.ps1) | powershell script to read the current build settings of the Automation Studio project |
| [Set-JsonDatabase.ps1]( {{ template_url }}/Set-JsonDatabase.ps1) | powershell script to create the needed json database for clang-tidy |

## Setup up a Post-Build step in Automation Studio

### Open Change Runtime Versions

In the Automation Studio project goto to the Project->Change Runtime Versions... button

![Change Runtime Versions](img%5CTesting%20-%20Static%20Code%20Analysis%20-%20Change%20Runtime%20Versions.png){: style="border: 1px solid gray;"}

### Edit Build Events

![Navigate to the Build Events tab](img%5CTesting%20-%20Static%20Code%20Analysis%20-%20Build%20Events.png){: style="border: 1px solid gray;"}

### Setup the Post-Build step

![Post-Build](img%5CTesting%20-%20Static%20Code%20Analysis%20-%20Post-Build.png){: style="border: 1px solid gray;"}

```bat
"$(AS_PROJECT_PATH)/Logical/StaticCodeAnalysis/RunClangTidy.bat" "$(AS_PROJECT_PATH)" $(AS_CONFIGURATION)
```
