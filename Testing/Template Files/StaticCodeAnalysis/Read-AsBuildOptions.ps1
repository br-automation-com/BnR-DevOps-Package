<#
.SYNOPSIS
    Reads GCC build options for a specific configuration in an AS project.

.DESCRIPTION
    This script will based on the specified project and configuration extract
    the GCC build options that are used when building the project.

.PARAMETER Project
    The AS project directory.

.PARAMETER Configuration
    The AS configuration that will be used.

.OUTPUT
    An PS object with the following properties:
      - Includes: A list with additional include directories.
      - GccVersion: The specified GCC version to use.
      - Options: Additional GCC command line options.
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)]
    [string]$Project,

    [Parameter(Mandatory=$True)]
    [string]$Configuration
)

$configPath = Join-Path $Project "Physical\$Configuration"
if (!(Test-Path $configPath)) {
    throw "The specified configuration $Configuration does not exists for project $Project"
}

$cpuFilePatter = Join-Path $configPath "\*\Cpu.pkg"
$cpuFile = Get-ChildItem -Path $cpuFilePatter
if (($cpuFile | measure).Count -ne 1) {
    throw "Configuration $Configuration is not a valid AS software configuration"
}

[xml]$cpuContent = Get-Content -Path $cpuFile
$ns = @{e = "http://br-automation.co.at/AS/Cpu"}

# Default build options
$options = ""
$includes = @()
$gccVersion = ""

# Get the GCC command line
$optionQuery = "//e:Build/@AdditionalBuildOptions"
$res = Select-Xml -Xml $cpuContent -XPath $optionQuery -Namespace $ns
if ($res -ne $null) {
    $options = $res.ToString()
}

# Get the GCC version
$versionQuery = "//e:Build/@GccVersion"
$res = Select-Xml -Xml $cpuContent -XPath $versionQuery -Namespace $ns
if ($res -ne $null) {
    $gccVersion = $res.ToString()
}

# Get additional include search paths
$includeQuery = "//e:Build/@AnsicIncludeDirectories"
$res = Select-Xml -Xml $cpuContent -XPath $includeQuery -Namespace $ns
if ($res -ne $null) {
    $includes = $res.ToString() -Split ","
}

# Combine the results into a usable object
$properties = @{
    Options = $options;
    Includes = $includes;
    GccVersion = $gccVersion
}
new-object psobject -Property $properties
