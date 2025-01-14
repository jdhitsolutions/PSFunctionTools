# Changelog for PSFunctionTools

## [Unreleased]

## [1.3.0] - 2025-01-14

### Added

- Added command `Open-PSFunctionToolsSamples` to change to the Samples folder and list the sample files.
- Added command `Open-PSFunctionToolsHelp`.

### Changed

- Updated demo file `Demo-NewModuleFromFiles.ps1`.
- Help documentation updates.
- Minor code cleanup.
- Bumped minimum PowerShell version to 7.4. __This is a potential breaking change.__
- Converted changelog to new format.

## [v1.2.0] - 2023-04-18

### Changed

- Pester test revisions.
- Modified `Format-FunctionName` to let you capitalize N number of characters in the Noun portion of the command name.
- Help updates.
- Updated `README.md`.

### Added

- Added missing online help links.

### Removed

- Deleted unused `Types` folder.

## [v1.1.0] - 2023-03-03

### Changed

- Code clean up and reformatting.
- Image resizing.

## [v1.0.0] - 2022-02-28

- Added online help links for previously published commands.
- Bumped version number to reflect feature-complete release.
- Added `Export-FunctionToFile` to export a loaded function from your session to a script file.
- Help updates.
- Updated `README.md`.

## [v0.6.0] - 2022-01-17

- Added online help links for previously published commands.
- Modified `Get-FunctionAttribute` to accept pipeline input for `Name` and `Path` parameters.
- Modified `Get-FunctionAlias` to accept pipeline input for `Path`.
- Added command `Get-PSFunctionTools` and a related custom format file. This command makes it easy to see all module commands.
- Added alias `ffn` for `Format-FunctionName`.
- Added alias `gfn` for `Get-FunctionName`.
- Added alias `tfn` for `Test-FunctionName`.
- Added command `Get-FunctionProfile` and alias `gfp`.
- Revised warning message in `Get-FunctionAttribute` and `Get-ParameterBlock` to include function name and path.
- Updated `README.md`.
- Help updates.
- Initial public release to the PowerShell Gallery.

## v0.5.0 - 2022-01-11

- Module will be written to support PowerShell 7.1 and later. Commands may run in Windows PowerShell but I am __not__ marking the module as `Desktop` compatible.
- Added a parameter called `AsTree` to `Get-ModuleLayout` to show module layout as a tree.
- Moved code to parse path for `AST` data to a private helper function.
- Help documentation updates.
- Initial Pester 5 tests for the module and functions.
- Module manifest updates.
- Updated `README.md`.
- First public preview release.

## v0.4.0 - 2021-12-24

- Moved helper functions in `New-ModuleFromFiles` to `functions\private\helpers.ps1'`.
- Updated `New-ModuleFromFiles` to use `FunctionPath` parameter when creating the root psm1 file.
- Added function `New-ModuleFromLayout`.
- Help updates.

## v0.3.0 - 2021-12-21

- Added sample scripts.
- Modified `New-CommentHelp` with a `-TemplateOnly` parameter to generate help without any parameter definitions.
- Modified `Get-FunctionName` to accept `Path` parameter values from pipeline input.
- Modified `Get-ParameterBlock` to accept `Path` and `Name` values from pipeline input by property name.
- Added function `New-ModuleFromFiles`. This should be considered experimental.

## v0.2.0 - 2021-12-20

- Updated help documentation.
- Modified `Format-FunctionName` to accept pipeline input by value.
- Added function `Get-ParameterBlock` with an alias of `gpb`.
- Added function `Get-FunctionAttribute` with an alias of `gfa`.
- Added a parameter called `Detailed` to `Get-FunctionName` to write a custom object to the pipeline which includes the path to the file. Added a custom format file `psfunctionname.format.ps1xml`.

## v0.1.0 - 2021-12-20

- Initial files.
- Added `Get-ModuleLayout` with format file `modulelayout.format.ps1xml`.
- Modified `Get-PSScriptRequirements` to write a `PSScriptRequirements` object to the pipeline. Added the format file `psscriptrequirements.format.ps1xml`.
- Updated help documentation.

[Unreleased]: https://github.com/jdhitsolutions/PSFunctionTools/compare/v1.3.0..HEAD
[1.3.0]: https://github.com/jdhitsolutions/PSFunctionTools/compare/vv1.2.0..v1.3.0
[v1.2.0]: https://github.com/jdhitsolutions/PSFunctionTools/compare/v1.1.0..v1.2.0
[v1.1.0]: https://github.com/jdhitsolutions/PSFunctionTools/compare/v1.0.0..v1.1.0
[v1.0.0]: https://github.com/jdhitsolutions/PSFunctionTools/compare/v0.6.0..v1.0.0
[v0.6.0]: https://github.com/jdhitsolutions/PSFunctionTools/compare/v0.5.0..v0.6.0
[v0.5.0]:
[v0.4.0]:
[v0.3.0]:
[v0.2.0]: