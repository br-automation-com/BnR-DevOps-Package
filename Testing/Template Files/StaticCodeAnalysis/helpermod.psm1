#Commonly used functions as script modules
# ------------------------------------------------------------------------------
# function to check if a library is a source library
function IsSourceLib($LibDirectory){
    Get-ChildItem $LibDirectory | Where-Object {$_.name -match "ANSIC.lby"}
}
# ------------------------------------------------------------------------------
# function to check if a library is a mapp library
function IsMappLib($LibDirectory){
    $LibName = split-path $LibDirectory -Leaf
    if($LibName -match "^Mp|^Mx"){
        if(!($LibName -match $IgnoreLib) -or !$IgnoreLib){
            return 1
        }
    }
}
# ------------------------------------------------------------------------------
# function to check if a library is a dynamic library
function IsDynamicLib($LibDirectory){
    Get-ChildItem $LibDirectory | Where-Object {$_.extension -match "fun"}
}
# ------------------------------------------------------------------------------
# function to create new directory if not present / clean if present
function CreateDir($newDirectory,$cleanOption){
    if(!(Test-Path -Path $newDirectory)){
        $newDirectory = New-Item -ItemType directory -Path $newDirectory
    }
    elseif($cleanOption){
        Remove-Item $newDirectory -recurse -force
    }
    return $newDirectory
}
# ------------------------------------------------------------------------------
# function to get the mapp tools from _mappTools (env:\MAP_TOOLS) with specific version
function GetMappTool($ToolName, $ToolVersion){
    # Check for system path
    try
    {
        $ToolsLocation = (Get-Item env:\MAPP_TOOLS -erroraction 'silentlycontinue')."Value"
        if(!$ToolsLocation){
            throw "MAPP_TOOLS system environment variable wrongly defined"
        }
        # After getting ToolLocation by above method try get the tool
        $Tool = join-path $ToolsLocation $ToolVersion
        if($Tool){
            $Tool = join-path $Tool $ToolName
            if(test-path $Tool){
                return $Tool
            }
        }
        throw "Specified tool $ToolsLocation\$ToolVersion\$ToolName not found"
    }
    # If not defined find relative path
    catch
    {
        write-warning "Did not find system env. variable MAPP_TOOLS attempting relative path..."
        # Get to 02_Projects directory
        $TempDirectory = split-path $SCRIPT:MyInvocation.MyCommand.Path -parent
        do{
            $TempDirectory = split-path -Path $TempDirectory -Parent
        }
        while ((split-path $TempDirectory -leaf) -ne "02_Projects")
        # Get to _mappTools directory
        $ToolsLocation = join-path $TempDirectory "_mappTools"
        if(!$ToolsLocation){
            throw "_mappTools folder cannot be found"
        }
        # After getting ToolLocation by above method try get the tool
        $Tool = join-path $ToolsLocation $ToolVersion
        if($Tool){
            $Tool = join-path $Tool $ToolName
            if(test-path $Tool){
                return $Tool
            }
        }
        throw "Specified tool $ToolsLocation\$ToolVersion\$ToolName not found"
    }
}
# ------------------------------------------------------------------------------
# function to get the mapp installer from _mappInstall (env:\MAP_INSTALL) with specific version
function GetMappInstall($InstallerName, $InstallerVersion){
    # Check for system path
    try
    {
        $InstallLocation = (Get-Item env:\MAPP_INSTALL -erroraction 'silentlycontinue')."Value"
        if(!$InstallLocation){
            throw "MAPP_INSTALL system environment variable wrongly defined"
        }
        # After getting InstallLocation by any of above method try get the Installer
        $Installer = join-path $InstallLocation $InstallerVersion
        if($Installer){
            $Installer = join-path $Installer $InstallerName
            if(test-path $Installer){
                return $Installer
            }
        }
        throw "Specified installer $InstallLocation\$InstallerVersion\$InstallerName not found"
    }
    # If not defined find relative path
    catch
    {
        write-warning "Did not find system env. variable MAPP_INSTALL attempting relative path..."
        # Get to 02_Projects directory
        $TempDirectory = split-path $SCRIPT:MyInvocation.MyCommand.Path -parent
        do{
            $TempDirectory = split-path -Path $TempDirectory -Parent
        }
        while ((split-path $TempDirectory -leaf) -ne "02_Projects")
        # Get to _mappInstall directory
        $InstallLocation = join-path $TempDirectory "_mappInstall"
        if(!$InstallLocation){
            throw "_mappInstall folder cannot be found"
        }
        # After getting InstallLocation by any of above method try get the Installer
        $Installer = join-path $InstallLocation $InstallerVersion
        if($Installer){
            $Installer = join-path $Installer $InstallerName
            if(test-path $Installer){
                return $Installer
            }
        }
        throw "Specified installer $InstallLocation\$InstallerVersion\$InstallerName not found"
    }
}
# ------------------------------------------------------------------------------
# function to get a BR Doc studio location
function GetBRDSLocation () {
    try {
        $BRDSLocation = (Get-Item env:\BR_DS_PATH -erroraction 'silentlycontinue').Value
        if (!(Test-Path $BRDSLocation)) {
            throw "BR_DS_PATH have been specified but does not point to a valid location"
        }
        return $BRDSLocation
        } catch {
            # If the environment variable fails, we try a standard path
            $BRDSLocation = "C:\Program Files (x86)\Documentation Studio"
            if (!(Test-Path $BRDSLocation)) {
                throw "BR_DS_PATH have not been specified and the standard BR location $BRDSLocation does not exist."
            }
            return $BRDSLocation
        }
    }
# ------------------------------------------------------------------------------
# function to get a BR home location
function GetBRLocation () {
    try {
        $BRLocation = (Get-Item env:\BR_HOME -erroraction 'silentlycontinue').Value
        if (!(Test-Path $BRLocation)) {
            throw "BR_HOME have been specified but does not point to a valid location"
        }
        return $BRLocation
        } catch {
            # If the environment variable fails, we try a standard path
            $BRLocation = "C:\BrAutomation"
            if (!(Test-Path $BRLocation)) {
                throw "BR_HOME have not been specified and the standard BR location $BRLocation does not exist."
            }
            return $BRLocation
        }
    }

# ------------------------------------------------------------------------------ 
# function to get a AS home location
function GetASLocation($Project) {
try {
    $ASLocation = (Get-Item env:\AS_HOME -erroraction 'silentlycontinue').Value
    if (!(Test-Path $ASLocation)) {
        throw "AS_HOME have been specified but does not point to a valid location"
    }
    return $ASLocation
    } catch {
        # If the environment variable fails, we try a standard path
        $info = GetBRLocation
        $ASVersion = GetApjASInfo($Project)

        $Version = $ASVersion.Split('.')[0..1] -join ""
        $Version = "AS" + $Version
        $ASLocation = Join-Path $info $Version
        if (!(Test-Path $ASLocation)) {
            $Version = $ASVersion.Split('.')[0..2] -join ""
            $Version = "AS" + $Version
            $ASLocation = Join-Path $info $Version
            if (!(Test-Path $ASLocation)) {
                throw "AS folder not found: $ASLocation"
            }
        }

        return $ASLocation
    }
}
# ------------------------------------------------------------------------------
# function to get a AS bin location
function GetASBinLocation() {
try {
    $ASBinLocation = (Get-Item env:\AS_BIN -erroraction 'silentlycontinue').Value
    if (!(Test-Path $ASBinLocation)) {
        throw "AS_BIN have been specified but does not point to a valid location"
    }
    return $ASBinLocation
    } catch {
        # If the environment variable fails, we try a standard path
        $info = GetASLocation
        $ASBinLocation = join-path $info "\Bin-en"
        if (!(Test-Path $ASBinLocation)) {
            throw "AS_BIN have not been specified and the standard AS location $ASBinLocation does not exist."
        }
        return $ASBinLocation
    }
}
# ------------------------------------------------------------------------------
# function to get a PVI home location
function GetPVILocation() {
try {
    $PVILocation = (Get-Item env:\PVI_HOME -erroraction 'silentlycontinue').Value
    if (!(Test-Path $PVILocation)) {
        throw "PVI_HOME have been specified but does not point to a valid location"
    }
    return $PVILocation
    } catch {
        # If the environment variable fails, we try a standard path
        $Version = GetApjASInfo
        $Version = $Version.Split('.')[0..1] -join ""
        $Version = "AS" + $Version
        $info = GetBRLocation
        $ASLocation = Join-Path $info $Version

        $info = GetBRLocation
        $info = $info + "\PVI"

        $Version = GetApjASInfo
        $Version = $Version.Split('.')[0..1] -join "."
        $Version = "V" + $Version
        $PVILocation = join-path $info $Version

        if (!(Test-Path $PVILocation)) {
            throw "PVI_HOME have not been specified and the standard PVI Location $PVILocation does not exist."
        }
        return $PVILocation
    }
}
# ------------------------------------------------------------------------------
# function to get a PVI bin location
function GetPVIBinLocation() {
try {
    $PVIBinLocation = (Get-Item env:\PVI_BIN -erroraction 'silentlycontinue').Value
    if (!(Test-Path $PVIBinLocation)) {
        throw "PVI_BIN have been specified but does not point to a valid location"
    }
    return $PVIBinLocation
    } catch {
        # If the environment variable fails, we try a standard path
        $info = GetPVILocation
        $PVIBinLocation = join-path $info "\PVI\Tools\PVITransfer"
        if (!(Test-Path $PVIBinLocation)) {
            throw "PVI_BIN have not been specified and the standard AS location $PVIBinLocation does not exist."
        }
        return $PVIBinLocation
    }
}
# ------------------------------------------------------------------------------
# function to get a specific AS exe from AS Bin-en (env:\AS_BIN)
function GetASBinExe($ExeName){
    $info = GetASBinLocation
    $ASExe = join-path $info $ExeName
    if(!(Test-Path $ASExe)){
        throw "Specified exe $ASBinLocation\$ExeName not found"
    }
    return $ASExe
}
# ------------------------------------------------------------------------------
# function to get a specific PVI exe from PVITransfer directory (env:\PVI_BIN)
function GetPVIBinExe($ExeName){
    $info = GetPVIBinLocation
    $PVIExe = join-path $info $ExeName
    if(!(Test-Path $PVIExe)){
        throw "Specified exe $PVIBinLocation\$ExeName not found"
    }
    return $PVIExe
}
# ------------------------------------------------------------------------------
# function to get version information from *.apj file
function GetApjASInfo($Project){
    # Get to *.apj file
    $projectFile = Get-ChildItem $Project -recurse -include *.apj | Select-Object -First 1
    if(!(Test-Path $projectFile)){
        throw "AS project file $projectFile not found"
    }
    #load xml
    $apjXml = [xml](get-content -path $projectFile)
    $version = $apjXml.AutomationStudio.split('Version=,SP, ,"',[System.StringSplitOptions]::RemoveEmptyEntries)
    $version
}
# ------------------------------------------------------------------------------
# function to get a documenation studio CL tool from DocStudio directory (env:\BR_DS_PATH)
function GetDocStudioExe($ExeName){
    $info = GetBRDSLocation
    $DocStudioExe = join-path $info $ExeName
    if(!(Test-Path $DocStudioExe)){
        throw "Specified exe $DocStudioExe\$ExeName not found"
    }
    return $DocStudioExe
}
# ------------------------------------------------------------------------------
# function to get particular directory from 01_GenericDocuments
function GetMappDocDir($DirName){
    # Check for system path
    try {
        $DocLocation = (Get-Item env:\MAPP_DOCS)."Value"
        $DocLocation = join-path $DocLocation $DirName
    }
    # If not defined return empty string
    catch [Exception] {
        $DocLocation = ""
    }
    return $DocLocation
}
# ------------------------------------------------------------------------------
# function to get a specific exe from NSIS(env:\NSIS)
function GetNSISExe($ExeName){
    # Check for system path
    try
    {
        $NSISLocation = (Get-Item env:\NSIS -erroraction 'silentlycontinue')."Value"
        if(!$NSISLocation){
            throw "NSIS system environment variable wrongly defined"
        }
        $NSISExe = join-path $NSISLocation $ExeName
        if(test-path $NSISExe){
            return $NSISExe
        }
        throw "Specified exe $NSISLocation\$ExeName not found"
    }
    # If not defined try the standard path
    catch
    {
        write-warning "Did not find system env. variable NSIS attempting standard path..."
        $NSISLocation = "C:\Program Files (x86)\NSIS\"
        $NSISExe = join-path $NSISLocation $ExeName
        if(test-path $NSISExe){
            return $NSISExe
        }
        throw "Specified exe $NSISLocation\$ExeName not found"
    }
}
# ------------------------------------------------------------------------------
# function to check if a configuration is CI - hardware (not CI_Master)
function IsCIHardware($Configuration){
    if($Configuration -match "^CI"){
        if(!($Configuration -match "CI_Master")){
            return 1
        }
    }
}
# ------------------------------------------------------------------------------
# function to check if harsdware is in simulation
function IsARSim($HostNameWithPort){
    $portNo = $HostNameWithPort -split (":") | Select-Object -First 2
    if($portNo -eq 11160){
        return 1
    }
}
# ------------------------------------------------------------------------------
# function to clean the build artifacts of the AS project
function CleanBuildArtifacts($projectFolder){
    get-childitem $projectFolder |
    Where-Object { $_.Name -match 'Temp|Diagnosis|Binaries|.set' } |
    remove-item -force -recurse
}
# ------------------------------------------------------------------------------
# function to check if a library is a acp10 motion library
function IsAcp10Lib($LibDirectory){
    $LibName = split-path $LibDirectory -Leaf
    if($LibName -match "^Acp10|^Nc"){
        if(!($LibName -match $IgnoreLib) -or !$IgnoreLib){
            return IsBinaryLib $LibDirectory
        }
    }
}
# ------------------------------------------------------------------------------
# function to check if a library is a arnc0 motion library
function IsArnc0Lib($LibDirectory){
    $LibName = split-path $LibDirectory -Leaf
    if($LibName -match "^Arnc0"){
        if(!($LibName -match $IgnoreLib) -or !$IgnoreLib){
            return IsBinaryLib $LibDirectory
        }
    }
}
# ------------------------------------------------------------------------------
# function to check if a library is a gmc motion library
function IsGmcLib($LibDirectory){
    $LibName = split-path $LibDirectory -Leaf
    if($LibName -match "^Gmc"){
        if(!($LibName -match $IgnoreLib) -or !$IgnoreLib){
           return IsBinaryLib $LibDirectory
        }
    }
}
# ------------------------------------------------------------------------------
# function to check if a library is a binary library
function IsBinaryLib($LibDirectory){
    Get-ChildItem $LibDirectory | Where-Object {$_.name -match "Binary.lby"}
}
# ------------------------------------------------------------------------------
# function to get AS base library location
function GetBaseLibraryDir () {
    try {
        $BRLocation = (Get-Item env:\BR_HOME -erroraction 'silentlycontinue').Value
        if (!(Test-Path $BRLocation)) {
            throw "BR_HOME have been specified but does not point to a valid location"
        }
        return join-path $BRLocation "AS\Library"
        } catch {
            # If the environment variable fails, we try a standard path
            $BRLocation = "C:\BrAutomation"
            if (!(Test-Path $BRLocation)) {
                throw "BR_HOME have not been specified and the standard BR location $BRLocation does not exist."
            }
            return join-path $BRLocation "AS\Library"
    }
}
# ------------------------------------------------------------------------------
# function to get TP location
function GetTPDir () {
    try {
        $ASLocation = (Get-Item env:\AS_HOME -erroraction 'silentlycontinue').Value
        if (!(Test-Path $ASLocation)) {
            throw "AS_HOME have been specified but does not point to a valid location"
        }
        return join-path $ASLocation "AS\TechnologyPackages"
        } catch {
            # If the environment variable fails, we try a standard path
            $Version = GetApjASInfo
            $Version = $Version.Split('.')[0..1] -join ""
            $Version = "AS" + $Version
            $info = GetBRLocation
            $ASLocation = Join-Path $info $Version
            if (!(Test-Path $ASLocation)) {
                throw "AS_HOME have not been specified and the standard AS location $ASLocation does not exist."
            }
            return join-path $ASLocation "AS\TechnologyPackages"
    }
}

function throwAppException($info){
    $stderr = $info | ?{ $_ -is [System.Management.Automation.ErrorRecord] }
    if($stderr){throw $stderr}
    else{throw $info}
}

function ProcessAppOutput($info,$logFile){
    if($logFile){$info | out-file $logFile}
    $errInfo = $info | ?{ $_ -is [System.Management.Automation.ErrorRecord] }
    if(!$errInfo){
       $errInfo = $info -split '[\r\n]' | Where {$_ -Match "error :|error:|error\(s\)|warning :|warning:|warning\(s\)"}
    }
    $errInfo
}
# ------------------------------------------------------------------------------
# function to get a specific TFS exe from TF folder
function GetTFSExe($ExeName){
    $ExpectedPaths = @()
    $ExpectedPaths += "C:\Program Files (x86)\Microsoft Visual Studio\2017\TeamExplorer\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer"
    $ExpectedPaths += "C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\IDE"
    $ExpectedPaths += "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE"
    $ExpectedPaths += "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE"
    foreach($IdePath in $ExpectedPaths){
        if(Test-Path (Join-Path $IdePath $ExeName)){
            $TFExe = join-path $IdePath $ExeName
            break
        }
    }
    if(!$TFExe){
        throw "Specified exe $IdePath\$ExeName not found"
    }
    return $TFExe
}

# ------------------------------------------------------------------------------
# function to get resource path
function GetResourcePath($path) {
    $absolute = Join-Path (Get-Location) $path
    [System.IO.Path]::GetFullPath($absolute)
}

# ------------------------------------------------------------------------------
# functions used to update sql server data
function CreateSqlParameterSet {
    param(
        [Parameter(Mandatory = $True)]
        [string] $Name,
        [Parameter(Mandatory = $False)]
        [string] $Value,
        [Parameter(Mandatory = $False)]
        $DataType = [Data.SqlDbType]::varchar,
        [Parameter(Mandatory = $False)]
        $Direction = [Data.ParameterDirection]::Input
    )
    $props = @{
        Name = $Name;
        Value = $Value;
        DataType = $DataType;
        Direction = $Direction;
    }

    New-Object psobject -Property $props
}

function InvokeSqlStoredProcedure {
    param(
        [Parameter(Mandatory = $True)]
        [string] $ServerName,
        [Parameter(Mandatory = $True)]
        [string] $Uid,
        [Parameter(Mandatory = $True)]
        [string] $Pwd,
        [Parameter(Mandatory = $True)]
        [string] $DatabaseName,
        [Parameter(Mandatory = $True)]
        [string] $StoredProcName,
        [Parameter(Mandatory = $False)]
        $SqlParObjList = $null
    )

    # Define connection
    $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $SqlConnection.ConnectionString = "Server=$ServerName;Database=$DatabaseName;Integrated Security=False;User ID=$Uid;Password=$Pwd"
    # Define command
    $SqlCommand = New-Object System.Data.SqlClient.SqlCommand
    $SqlCommand.CommandText = $StoredProcName
    $SqlCommand.CommandType = [System.Data.CommandType]::StoredProcedure
    $SqlCommand.Connection = $SqlConnection
    # Define parameter if present
    if($SqlParObjList -ne $null){
        foreach ($SqlParObj in $SqlParObjList) {
            $SqlPar = $SqlCommand.Parameters.Add("@" + $SqlParObj.Name, $SqlParObj.DataType)
            $SqlPar.Direction = $SqlParObj.Direction
            $SqlPar.Value = $SqlParObj.Value
        }
    }
    # Define adapter
    $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $SqlAdapter.SelectCommand = $SqlCommand
    # Define dataset
    $DataSet = New-Object System.Data.DataSet
    # Execute query
    $count = $SqlAdapter.Fill($DataSet)
    $SqlConnection.Close()
    return $DataSet
}
# ------------------------------------------------------------------------------
function GetGCCLocation($gccVersion) {
    $asLocation = GetASLocation
    $subFolder = "AS\gnuinst\V"
    $subFolder += $gccVersion;
    $gccLocation = Join-Path $asLocation $subFolder
    if (!(Test-path $gccLocation)) {
        throw "AS GCC installation could not be located at $gccLocation"
    }
    return $gccLocation
}
# ------------------------------------------------------------------------------
function GetProductName($componentName) {
    $productTable = Get-Content -Path "ProductPlacement.json" | ConvertFrom-Json
    $product = $productTable.PSObject.Properties | where-object {$_.Value -contains $componentName}
    if($product){
      $mappTPName = $product.Name
    }
    else{
        $mappTPName = $null
    }
    return $mappTPName
}
Export-ModuleMember -Function IsSourceLib,
IsMappLib,
IsDynamicLib,
GetMappTool,
GetASBinExe,
GetPVIBinExe,
GetDocStudioExe,
GetMappDocDir,
CreateDir,
GetNSISExe,
GetMappInstall,
GetASLocation,
IsCIHardware,
IsARSim,
CleanBuildArtifacts,
IsAcp10Lib,
IsArnc0Lib,
IsGmcLib,
IsBinaryLib,
GetBaseLibraryDir,
GetTPDir,
throwAppException,
ProcessAppOutput,
GetTFSExe,
GetResourcePath,
CreateSqlParameterSet,
InvokeSqlStoredProcedure,
GetGCCLocation,
GetBRLocation,
GetProductName
