# Changelog for PSFunctionTools

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