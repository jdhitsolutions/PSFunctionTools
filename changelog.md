# Changelog for PSFunctionTools

## v0.5.0

+ Module will be written to support PowerShell 7.1 and later. Commands may run in Windows PowerShell but I am __not__ marking the module as `Desktop` compatible.
+ Added a parameter called `AsTree` to `Get-ModuleLayout` to show module layout as a tree.
+ Moved code to parse path for `AST` data to a private helper function.
+ Help documentation updates.
+ Initial Pester 5 tests for the module and functions.
+ Module manifest updates.
+ Updated `README.md`.
+ First public preview release.

## v0.4.0

+ Moved helper functions in `New-ModuleFromFiles` to `functions\private\helpers.ps1'`.
+ Updated `New-ModuleFromFiles` to use `Functionpath` parameter when creating the root psm1 file.
+ Added function `New-ModuleFromLayout`.
+ Help updates.

## v0.3.0

+ Added sample scripts.
+ Modified `New-CommentHelp` with a `-TemplateOnly` parameter to generate help without any parameter definitions.
+ Modified `Get-FunctionName` to accept `Path` parameter values from pipeline input.
+ Modified `Get-ParameterBlock` to accept `Path` and `Name` values from pipeline input by property name.
+ Added function `New-ModuleFromFiles`. This should be considered experimental.

## v0.2.0

+ Updated help documentation.
+ Modified `Format-FunctionName` to accept pipeline input by value.
+ Added function `Get-ParameterBlock` with an alias of `gpb`.
+ Added function `Get-FunctionAttribute` with an alias of `gfa`.
+ Added a parameter called `Detailed` to `Get-FunctionName` to write a custom object to the pipeline which includes the path to the file. Added a custom format file `psfunctionname.format.ps1xml`.

## v0.1.0

+ Initial files.
+ Added `Get-ModuleLayout` with format file `modulelayout.format.ps1xml`.
+ Modified `Get-PSScriptRequirements` to write a `PSScriptRequirements` object to the pipeline. Added the format file `psscriptrequirements.format.ps1xml`.
+ Updated help documentation.