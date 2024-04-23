---
llvm_install: https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.0/LLVM-18.1.0-win64.exe
template_url: https://github.com/br-automation-com/BnR-DevOps-Package/raw/develop/Testing/Template%20Files/StaticCodeAnalysis
---

# Static Code Analysis

Static code analysis software (aka linter) analyzes the program without actually executing it.

Commonly this is preformed in order to:

* Look for common coding mistakes that can lead to bugs or maintenance issues in the future
* Ensure required coding standards are used

Static code analysis available for **C/C++** using [clang-tidy](https://clang.llvm.org/extra/clang-tidy/)

Structured Text is planned but not currently available.

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

## Build Project

Now on successful builds of the Automation Studio project clang-tidy will automatically be run.  Any warnings from clang-tidy will show up as warnings in Output Results window.

![Results](img%5CTesting%20-%20Static%20Code%20Analysis%20-%20Clang-warnings.png)

Double clicking on the warning Automation Studio will open the file and highlight the line with the potential problem

![potential problem](img%5CTesting%20-%20Static%20Code%20Analysis%20-%20Opened%20Warning.png)

## Customization

By default we have enabled all checks except llvmlibc-restrict-system-libc-headers.  If you need to disable any additional checks edit the clang-tidy.opt file.

See [here](https://clang.llvm.org/extra/clang-tidy/checks/list.html) for a full list of available checks

Any checks that you **do not** want add a line to the Checks: section of the file with a - infront of the check name (Note that wildcards are supported)

For example if you want to use our recommended checklist below:

```text
Checks: "*,
        -llvmlibc-restrict-system-libc-headers*,
        -abseil-*,
        -altera-*,
        -android-*
        -darwin-*,
        -fuchsia-*,
        -google-*,
        -llvm-*,
        -objc-*,
        -zircon-*
        "
```

## Recommended Checks

| Check prefix | Description | Recommended |
| | | |
| abseil-* | Google abseil project specific checks | No |
| altera-* | OpenCL programming for FPGAs specific checks | No |
| android-* | Android specific checks | No |
| bugprone-* | Common coding bugs | Yes |
| cert-* | Known vulnerabilities in specific language features | Yes |
| clang-analyzer-* | Clang static analyzer checks | Yes |
| cppcoreguidelines-* | Well vetted guidelines from across the C++ community | Yes |
| darwin-* | Darwin project specific checks | No |
| fuchsia-*| Google fuchsia project specific checks | No |
| google-* | Google specific checks | No |
| hicpp-* | high performance features, identifies conversions that you may not be aware of | Yes |
| llvm-* | | No |
| misc-* | miscellaneous checks, that didn't fit anywhere else |  Yes |
| modernize-* | Update older style code to new standards | Yes |
| objc-* | Objective C specific checks | No |
| performance-* | Performance related checks | Maybe |
| readability-* | various readability checks | Depends (some checks are very opinionated) |
| zircon-* | Zircon kernel project specific checks | No |
