<#
.SYNOPSIS
    Locates C++ or package files within an AS project folder.

.DESCRIPTION
    This script is able to find all C++ and package files with an AS project by
    locating project content references using package files. The script does
    not perform a file system search but instead locates content using the AS
    package files.

.PARAMETER Directory
    The directory where the search will start. This can be the project
    directory or any folder located within the Logical folder of the AS
    project. If not specified, the search will start at in the current
    directory.

.PARAMETER FileType
    Decides the type of files that should be located. Can be either "File" or
    "Package". Default is "File".

.PARAMETER Recursive
    Decides if the file search should be recursive. If not specified the search
    will not be recursive.

.PARAMETER Include
    A list of patterns that are used to include files and folder in the result.
    The patterns can contain any number of wildcard "*" characters.  Multiple
    patterns are separated using a comma ",". By default, everything is
    included.

.PARAMETER Exclude
    A list of patterns that are used to exclude files and folder from the
    result. The patterns can contain any number of wildcard "*" characters.
    Multiple patterns are separated using a comma ",". By default, noting is
    excluded.

.PARAMETER References
    Decides if referenced files and packages should be included in the output.
    This requires that the specified directory is an AS project directory.

.EXAMPLE
    Get-AsContent -R -Exclude *WsFB.hpp,*CT*

    Description
    -----------
    Locates all C++ files within the project but excludes all files with a
    certain pattern.
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$False, Position=1)]
    [string]$Directory,

    [Parameter(Mandatory=$False)]
    [ValidateSet("Package", "File")]
    [string]$FileType="File",

    [Parameter(Mandatory=$False)]
    [switch]$Recursive,

    [Parameter(Mandatory=$False)]
    [string[]]$Include,

    [Parameter(Mandatory=$False)]
    [string[]]$Exclude,

    [Parameter(Mandatory=$False)]
    [switch]$References
)

# ------------------------------------------------------------------------------

# Used to collect the result
$locatedFiles = @()

# ------------------------------------------------------------------------------

# Decides if a file is relevant
function IsCppLike($fileName) {
    $fileName -like "*.h"`
        -or $fileName -like "*.hpp"`
        -or $fileName -like "*.c"`
        -or $fileName -like "*.cpp"`
        -or $fileName -like "*.cc"
}

# ------------------------------------------------------------------------------

function IncludeInSearch($item) {
    if ($item -eq $null) {
        return $false
    }

    $item = $item.ToString()
    $include = $True

    # We first check if the item is included. If an include pattern is missing
    # we assume everything is included.
    if ($script:Include -ne $null) {
        $Include = $False
        foreach($pattern in $script:Include) {
            if ($item -like $pattern) {
                $include = $True
                break
            }
        }
    }

    if (!$include) {
        return $false
    }

    # Once we know what to include we can check if it should be excluded as
    # well.
    if ($script:Exclude -ne $null) {
        foreach($pattern in $script:Exclude) {
            if ($item -like $pattern) {
                $include = $False
                break
            }
        }
    }

    $include
}

# ------------------------------------------------------------------------------

# Tries to append a new file to the final result
function TryAppendFile($directory, $file) {
    $path = Join-Path $directory $file

    if (!(IncludeInSearch $path)) {
        return
    }

    if ($script:FileType -eq "File") {
        if (IsCppLike $file) {
            $info = Get-Item $path
            $script:locatedFiles += $info
        }
    }
}

# ------------------------------------------------------------------------------

# Locates all files in the specified AS content description
function ParseContent($directory, $contentFile) {
    [xml]$xml = Get-Content -Path $contentFile
    $namespace = @{ns=$xml.DocumentElement.NamespaceURI}

    if ($script:FileType -eq "Package") {
        if (IncludeInSearch $contentFile) {
            $info = Get-Item $contentFile
            $script:locatedFiles += $info
        }
    }

    # XPath queries used to match the AS lib, pkg and prg files
    $fileQuery = "//ns:File"
    $objectQuery = "//ns:Object[@Type='File']"
    $libQuery = "//ns:Object[(@Type='Library' or @Type='Program')]"
    $pkgQuery = "//ns:Object[@Type='Package']"

    # First try locating files
    if ($script:FileType -eq "File") {
        foreach($file in Select-Xml -Xml $xml -XPath $fileQuery -Namespace $namespace) {
            if ($file.Node.Reference) {
                if ($script:References) {
                    $path = Join-Path $script:projectDirectory $file
                    TryAppendFile (Split-Path $path -Parent) (Split-Path $path -Leaf)
                }
            } else {
                TryAppendFile $directory $file
            }
        }

        # Then try locating object. Required if the library contains a package
        foreach($object in Select-Xml -Xml $xml -XPath $objectQuery -Namespace $namespace) {
            if ($object.Node.Reference) {
                if ($script:References) {
                    $path = Join-Path $script:projectDirectory $object
                    TryAppendFile (Split-Path $path -Parent) (Split-Path $path -Leaf)
                }
            } else {
                TryAppendFile $directory $object
            }
        }
    }

    # Locate ANSIC libraries and Programs
    foreach($library in Select-Xml -Xml $xml -XPath $libQuery -Namespace $namespace) {
        if ($script:Recursive) {
            if ($library.Node.Reference) {
                if ($script:References) {
                    $contentFile = Join-Path $script:projectDirectory $library
                    ParseContent (Split-Path -Path $contentFile -Parent) $contentFile
                }
            } else {
                SearchDirectory $directory $library
            }
        }
    }

    # Locate packages
    foreach($package in Select-Xml -Xml $xml -XPath $pkgQuery -Namespace $namespace) {
        if ($script:Recursive) {
            if ($package.Node.Reference) {
                if ($script:References) {
                    $contentFile = Join-Path $script:projectDirectory $package
                    ParseContent (Split-Path -Path $contentFile -Parent) $contentFile
                }
            } else {
                SearchDirectory $directory $package
            }
        }
    }
}

# ------------------------------------------------------------------------------

# Locates an AS content description in the specified directory
function FindContentFile($directory) {
    $pattern = Join-Path $directory "*.*"
    Get-ChildItem $pattern -include *.lby, *.pkg, *.prg
}

# ------------------------------------------------------------------------------

# Verifies if the specified directory is an AS project directory
function IsProjectDirectory($directory) {
    $pattern = Join-Path $directory "*.apj"
    (Get-ChildItem $pattern | measure).Count -gt 0
}

# ------------------------------------------------------------------------------

# Locates all AS content in the specified directory
function SearchDirectory($parent, $child) {
    $directory = Join-Path $parent $child
    $content = FindContentFile $directory

    if ($content -ne $null) {
        if ($fileCount -ne 1) {
            throw "Directory: $directory contains more than one *.pkg, *.lby or *.prg file"
        } else {
            ParseContent $directory $content
        }
    }
}

# ------------------------------------------------------------------------------

function FindProjectRoot($dir) {
    while ($dir) {
        $pattern = Join-Path $dir "*.apj"
        if ((Get-Childitem $pattern) -ne $null) {
            return $dir
        } else {
            $dir = Split-Path $dir
        }
    }
    $dir
}

# ------------------------------------------------------------------------------
# Script starts here

if (!$Directory) {
    # If no directory is specified, use the current
    $Directory = Get-Location
}

if ($References) {
    $projectDirectory = FindProjectRoot $Directory
    if (!$projectDirectory) {
        throw "Referenced files can only be resolved if invoked inside an AS project directory"
    }
}

# If the folder is the project folder, we must switch to the Logical folder
if (IsProjectDirectory $Directory) {
    $Directory = Join-Path $Directory "Logical"
}

$content = FindContentFile $Directory
$fileCount = ($content | measure).Count
if ($fileCount -eq 0) {
    throw "Could not find a *.apj, *.lby, *.pkg or *.prg file in the specified directory: $Directory"
}
if ($fileCount -ne 1) {
    throw "Directory contains more than one *.pkg, *.lby or *.prg file"
}

# Start the recursive search
ParseContent $Directory $content

# Return the script result
$locatedFiles | Select -Unique
