# PSFunctionTools

[![PSGallery Version](https://img.shields.io/powershellgallery/v/PSFunctionTools.png?style=for-the-badge&label=PowerShell%20Gallery)](https://www.powershellgallery.com/packages/PSFunctionTools/) [![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/PSFunctionTools.png?style=for-the-badge&label=Downloads)](https://www.powershellgallery.com/packages/PSFunctionTools/)

The commands in this module have been developed to make it easier to automate the PowerShell scripting and module development. These tools were first described in a series of blog posts.

+ [Exporting PowerShell Functions to Files](https://jdhitsolutions.com/blog/powershell/8693/exporting-powershell-functions-to-files/)
+ [Converting PowerShell Scripts to Functions](https://jdhitsolutions.com/blog/powershell/8709/converting-powershell-scripts-to-functions/)
+ [Discovering Aliases with the PowerShell AST](https://jdhitsolutions.com/blog/powershell/8724/discovering-aliases-with-the-powershell-ast/)
+ [Fun with PowerShell Module Layout](https://jdhitsolutions.com/blog/powershell/8731/fun-with-powershell-module-layout/)
+ [Building a PowerShell Module Inception-Style](https://jdhitsolutions.com/blog/powershell/8741/building-a-powershell-module-inception-style/)

This module has been written for PowerShell 7.1 and later. It is most likely that the the commands will work in Windows PowerShell, but you will need to fork this module and revise as necessary. Otherwise, install this module from the PowerShell Gallery.

```powershell
Install-Module PSFunctionTools
```

## Commands

To see a summary of these commands at any time, run [Get-PSFunctionTools](docs/Get-PSFunctionTools.md)

```dos
PS C:\> Get-PSFunctionTools

   Module: PSFunctionTools [v0.6.0]

Name                       Alias    Synopsis
----                       -----    --------
Convert-ScriptToFunction    csf     Convert a script file to a PowerShell funct…
Export-FunctionFromFile     eff     Export a PowerShell function from a script …
Export-ModuleLayout         eml     Export a model module layout.
Format-FunctionName                 Format a function name to proper case.
Get-FunctionAlias        {ga, gfal} Get a defined function alias.
Get-FunctionAttribute       gfa     Get function attributes like cmdletbinding.
Get-FunctionName                    Identify the names of PowerShell functions …
Get-ModuleLayout                    Get information about a module layout file.
Get-ParameterBlock          gpb     Get a function's parameter block.
Get-PSFunctionTools                 Get a summary of PSFunctionTools commands.
Get-PSRequirements                  List PowerShell command requirements.
Import-ModuleLayout         iml     Create a module structure from a layout fil…
New-CommentHelp             nch     Create comment based help.
New-ModuleFromFiles                 Create a PowerShell module from a set of fi…
New-ModuleFromLayout                Creat a new module based on a layout.
Test-FunctionName                   Test the validity of a PowerShell function …
```

### [Convert-ScriptToFunction](docs/Convert-ScriptToFunction.md)

This command takes the body of a script file and wraps it in a function declaration. The command will insert missing elements like `cmdletbinding()` and comment-based help. You will most likely need to edit and clean up the result in your scripting editor. If you run this command in the PowerShell ISE or the VS Code PowerShell integrated terminal, you can use the dynamic parameter `ToEditor` to open a new file with with the output. You can edit and save the file manually.

```powershell
Convert-ScriptToFunction c:\scripts\systemreport.ps1 -name New-SystemReport | Out-File c:\scripts\New-SystemReport.ps1
```

It is assumed that your script file is complete and without syntax errors.

### [Export-FunctionFromFile](docs/Export-FunctionFromFile.md)

You should use `Export-FunctionFromFile` when you want to export PowerShell functions defined in in a single script file, placing each function in its own file. You might want to do this to build or restructure a PowerShell module.

You can export all functions from a file or specific functions. The default behavior is to only export functions that follow a standard verb-noun naming convention. The source must be a .ps1 or .psm1 script file.

```powershell
Export-FunctionFromFile C:\scripts\MyInternetTools.psm1 -Name get-zipinfo -OutputPath c:\scripts\psinternettools\functions
```

If you run this command in the PowerShell ISE or the VS Code integrated PowerShell Terminal, you can use the dynamic parameter `Remove` to delete the function from the source file.

### [Export-ModuleLayout](docs/Export-ModuleLayout.md)

Use `Export-ModuleLayout` to export a model module directory structure to a json file. You can use `Import-ModuleLayout` to recreate the layout from the json file. The export process will include not only directories, but also text files like a readme or license file.

```dos
PS C:\> Export-ModuleLayout c:\work\sample -FilePath c:\work\layout.json -Verbose
VERBOSE: Starting Export-ModuleLayout
VERBOSE: Exporting directory structure from c:\work\sample
VERBOSE: Processing .github
VERBOSE: Processing .vscode
VERBOSE: Processing docs
VERBOSE: Processing en-us
VERBOSE: Processing formats
VERBOSE: Processing functions
VERBOSE: Processing icons
VERBOSE: Processing images
VERBOSE: Processing samples
VERBOSE: Processing tests
VERBOSE: Processing types
VERBOSE: Processing changelog.md
VERBOSE: Processing License.txt
VERBOSE: Processing README.md
VERBOSE: Processing scratch-changelog.md
VERBOSE: Processing .vscode\tasks.json
VERBOSE: Processing formats\readme.txt
VERBOSE: Processing functions\private
VERBOSE: Processing functions\public
VERBOSE: Processing functions\private\readme.txt
VERBOSE: Processing functions\public\readme.txt
VERBOSE: Processing tests\readme.txt
VERBOSE: Processing types\readme.txt
VERBOSE: Exporting module layout to c:\work\layout.json.
```

### [Format-FunctionName](docs/Format-FunctionName.md)

`Format-FunctionName` is intended to be used as a helper function in your scripting automation. This is a simple function that will format a verb-noun function name into proper case. It will take an input such as test-data and format it as Test-Data. It will not format as PascalCase. The command also will not verify that the verb component is acceptable. Use `Test-FunctionName` for that process.

```dos
PS C:\> Format-FunctionName test-data
Test-Data
```

### [Get-FunctionAlias](docs/Get-FunctionAlias.md)

`Get-FunctionAlias` is a tool you can use in your scripting automation. It will extract function names and aliases from a PowerShell script file. The source must be a .ps1 or .psm1 file. The command will only idenfity aliases defined as part of the function using code like `[alias('foo')]`.

```dos
PS C:\> Get-FunctionAlias -Path C:\scripts\SQLBackup.psm1

Name                Alias
----                 -----
Backup-SQLDatabase  Backup-SQL
Restore-SQLdatabase rsql
```

### [Get-FunctionAttribute](docs/Get-FunctionAttribute.md)

This command can be used to get function attributes such as cmdletbinding or alias settings.

```dos
Get-Functionattribute -path c:\scripts\PSFunctionTools\functions\public\Get-ParameterBlock.ps1 -Name get-parameterblock

Type                : cmdletbinding
NamedArguments      : {}
PositionalArguments : {}
String              : [cmdletbinding()]
Function            : Get-Parameterblock
Path                : C:\scripts\PSFunctionTools\functions\public\Get-ParameterB
                      lock.ps1

Type                : alias
NamedArguments      : {}
PositionalArguments : {"gpb"}
String              : [alias("gpb")]
Function            : Get-Parameterblock
Path                : C:\scripts\PSFunctionTools\functions\public\Get-ParameterB
                      lock.ps1

Type                : OutputType
NamedArguments      : {}
PositionalArguments : {"ParamBlockAst", "String"}
String              : [OutputType("ParamBlockAst","String")]
Function            : Get-Parameterblock
Path                : C:\scripts\PSFunctionTools\functions\public\Get-ParameterB
                      lock.ps1
```

### [Get-FunctionName](docs/Get-FunctionName.md)

When exporting functions from files, you may only want to export specific functions. Which you can do if you know the name. Use `Get-FunctionName` to identify the names of functions. The default behavior is to get names of functions that follow the verb-noun naming convention.

```dos
PS C:\> Get-FunctionName C:\scripts\MyInternetTools.psm1
Get-MyWhoIs
Get-GeoIP
Get-MyPublicIP
Get-MyWeather
Get-WeatherByProxy
Get-WeatherLocation
Get-QOTD
Get-ZipInfo
Get-RSSFeed
Open-URL
```

### [Get-ModuleLayout](docs/Get-ModuleLayout.md)

This command will provide information about a module layout folder which was created using `Export-ModuleLayout`. The default output is custom object. You can elect to view the layout as a tree. This parameter requires the tree commandline utility which should be available on Windows systems by default. On non-Windows platforms, you may need to install the utility.

```dos
PS C:\> Get-ModuleLayout C:\scripts\simplelayout.json -AsTree
C:\<PathTo>\<MYMODULE>
|   changelog.md
|   README.md
|
+---.vscode
+---docs
+---en-us
+---formats
|       readme.txt
|
+---functions
|
+---tests
|       readme.txt
|
\---types
        readme.txt
```

### [Get-ParameterBlock](docs/Get-ParameterBlock.md)

This command is designed to use the PowerShell AST and retrieve a function's parameter block. You might use this to build comment-based help.

```dos
PS C:\> Get-ParameterBlock -path c:\scripts\SimpleFunction.ps1 -name Get-FolderData

Attributes Parameters                Extent
---------- ----------                ------
{}         {$Path, $Cutoff, $Filter} Param (…

PS C:\> Get-Parameterblock  -path c:\scripts\SimpleFunction.ps1 -name Get-FolderData -ToString
[parameter(HelpMessage = "Specify the folder to analyze")]
[string]$Path="."
[datetime]$Cutoff
[string]$Filter="*.*"
```

### [Get-PSRequirements](docs/Get-PSRequirements.md)

As part of your scripting automation, you may want to capture requirements defined in a script file such as `# requires -version 5.1`. The command `Get-PSRequirements` will process a PowerShell script file for these type of requirements.

```dos
PS C:\> Get-PSRequirements -Path C:\scripts\SQLBackup.psm1

Path                  : C:\scripts\SQLBackup.psm1
RequiredApplicationId :
RequiredPSVersion     : 5.1
RequiredPSEditions    : {}
RequiredModules       : {}
RequiresPSSnapIns     : {}
RequiredAssemblies    : {}
IsElevationRequired   : True
```

### [Import-ModuleLayout](docs/Import-ModuleLayout.md)

Use `Import-ModuleLayout` to recreate a module structure from a json file created with `Export-ModuleLayout`. Importing the json file will recreate the folders and files.

```dos
PS C:\> Import-ModuleLayout -Name PSDemo -ParentPath D:\scripts -Layout C:\work\layout.json

    Directory: C:\scripts\PSDemo

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----          12/16/2021  9:45 AM                types
d----          12/16/2021  9:45 AM                .github
d----          12/16/2021  9:45 AM                .vscode
d----          12/16/2021  9:45 AM                docs
...
    Directory: D:\scripts\PSDemo\functions

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----          12/16/2021  9:45 AM                public
d----          12/16/2021  9:45 AM                private

    Directory: D:\scripts\PSDemo\functions\public

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          12/16/2021  9:49 AM            276 readme.txt
...
```

### [New-CommentHelp](docs/New-CommentHelp.md)

You can use this command in your scripting automation to generate a comment-based help block for a function. The function will use the parameter block which you can get with `Get-ParameterBlock` to define help parameters. If your parameter has a HelpMessage defined, the value will be used in the parameter description. You can also specify a synopsis and/or description. Otherwise, you can edit the placeholders later.

```dos
PS C:\> Get-Parameterblock  -path c:\scripts\SimpleFunction.ps1 -name Get-FolderData | New-CommentHelp -Synopsis "Get folder details"
<
    .Synopsis
      Get folder details
    .Description
      <long description>
    .Parameter Path
      Specify the folder to analyze
    .Parameter Cutoff
      <enter a parameter description>
    .Parameter Filter
      <enter a parameter description>
    .Example

      <output and explanation>
    .Inputs
      <Inputs to this function (if any)>
    .Outputs
      <Output from this function (if any)>
    .Notes
      <General notes>
    .Link
      <enter a link reference>
```

### [New-ModuleFromFiles](docs/New-ModuleFromFiles.md)

`New-ModuleFromFiles` is an __*experimental*__ command. It is *not* guaranteed to run without error and may change significantly between module versions. The command is designed to process a collection of PowerShell script files which contain PowerShell functions. Each function will be exported to an individual file to a location you specify.

The function relies on a module layout file to scaffold the module directory.

```powershell
$splat = @{
    Description   = "Demo exported module"
    Files         = "c:\scripts\pstools.psm1","c:\scripts\servertools.ps1"
    Layout        = "c:\scripts\ModuleLayout.json"
    NewModuleName = "PSTools"
    ParentPath    = "c:\scripts"
    CreateHelp    = $True
    FunctionPath  = "functions\public"
    InitializeGit = $true
}
 New-ModuleFromFiles @splat
 ```

If you have the [Platyps](https://github.com/powershell/platyps) module installed, you can also choose to create help documentation. If you have `git` installed, you can initialize the module as a git repository. This process will also checkout a new branch.

### [New-ModuleFromLayout](docs/New-ModuleFromLayout.md)

This command is very similar to `New-ModuleFromFiles`. That function builds a module structure from existing files. This function creates a new module but without defining any commands. `New-ModuleFromLayout` will still create a module structure based on a layout and it will still create module files. Specifically,the module manifest and root module files.

```powershell
New-ModuleFromLayout -NewModuleName PSDataResource -ParentPath c:\scripts -Description "A class-based DSC resource to do something." -Layout c:\scripts\DSCModuleLayout.json -initializegit
```

If `git.exe` is detected, you can use the `InitializeGit` dynamic parameter to initialize the module as a git repository.

### [Test-FunctionName](docs/Test-FunctionName.md)

PowerShell function names should follow naming convention of `Verb-Noun`. The verb should be a standard verb that you see with `Get-Verb`. Use this command in your scripting automation to validate a PowerShell function name.

```dos
PS C:\> Test-FunctionName Test-Widget
Test-Widget
```

If the name passes validation it will be written to the pipeline. Or you can use the `-Quiet` parameter to return a traditional boolean result.

```dos
PS C:\> Test-FunctionName kill-system -Quiet
False
```

### [Get-FunctionProfile](docs/Get-FunctionProfile.md)

`Get-FunctionProfile` is designed to give you a technical summary of a PowerShell function. You might use this to preview what commands a function might execute or if it supports `-Whatif`. The function might be something someone else wrote, or perhaps you want to double-check your code.

Note that the analysis may not be 100% accurate. For example, it is difficult to distinguish between the alias `foreach` and the `foreach` enumerator.

```dos
PS C:\...\samples> Get-FunctionProfile -path .\SampleScript5.ps1 -name Get-Result

Name                  : Get-Result
FunctionAlias         : grx
SupportsShouldProcess : False
ParameterSets         :
DynamicParameters     : False
RequiredVersion       : 5.1
RequiredModules       : {}
RequiresElevation     : True
Commands              : {Get-CimInstance, Get-Random, Join-Path, New-Timespan…}
ExternalCommands      : {c:\scripts\cleanup.bat, notepad.exe}
DotNet                : {[system.datetime]::now,
                        [system.environment]::getenvironmentvariable("temp")}
Aliases               : {gcim, tee}
Unresolved            : {w}
Path                  : C:\Scripts\PSFunctionTools\samples\SampleScript5.ps1
```

Here is a sample analysis. Commands should be PowerShell cmdlets, including resolved aliases. Detected command aliases will also be retrieved. Unresolved commands might be undefined aliases or some other command that PowerShell could not resolve.

## Code Samples

This module includes a [Samples](samples) folder. Here, you can find sample PowerShell scripts and functions that you can use with the commands in this module.

```dos
PS C:\...\PSFunctionTools\samples> Get-FunctionName .\Tools.psm1
Get-WindowsVersion
Get-WindowsVersionString
Get-OSInfo

PS C:\...\PSFunctionTools\samples>Get-ModuleLayout .\ModuleLayout.json -AsTree

C:\<PathTo>\<MYMODULE>
|   changelog.md
|   README.md
|
+---.vscode
+---docs
+---en-us
+---formats
|       readme.txt
|
+---functions
|   +---private
|   |       readme.txt
|   |
|   \---public
|           readme.txt
|
+---tests
|       readme.txt
|
\---types
        readme.txt

PS C:\Scripts\PSFunctionTools\samples> dir .\SampleScript* | Get-PSRequirements | Format-Table

   Path: C:\Scripts\PSFunctionTools\samples\SampleScript.ps1

ApplicationId PSVersion PSEditions PSSnapIns Assemblies IsElevationRequired
------------- --------- ---------- --------- ---------- -------------------
                    4.0 {}         {}        {}                False

   Path: C:\Scripts\PSFunctionTools\samples\SampleScript2.ps1

ApplicationId PSVersion PSEditions PSSnapIns Assemblies IsElevationRequired
------------- --------- ---------- --------- ---------- -------------------
                    3.0 {}         {}        {}                False

   Path: C:\Scripts\PSFunctionTools\samples\SampleScript3.ps1

ApplicationId PSVersion PSEditions PSSnapIns Assemblies IsElevationRequired
------------- --------- ---------- --------- ---------- -------------------
                    5.0 {}         {}        {}                True

   Path: C:\Scripts\PSFunctionTools\samples\SampleScript4.ps1
...
```

You are welcome to copy, paste, and edit these samples as much as you would like.

## Bugs and Enhancements

Please use the repository's Issues section for reporting bugs and requesting new features. Remember, the commands in this module are designed for PowerShell 7.1 and later.
