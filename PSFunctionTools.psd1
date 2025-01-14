#
# Module manifest for module PSFunctionTools
#

@{
    RootModule           = 'PSFunctionTools.psm1'
    ModuleVersion        = '1.3.0'
    CompatiblePSEditions = 'Core'
    GUID                 = '151466e0-a952-4b6a-ad81-40dafc9ef9bb'
    Author               = 'Jeff Hicks'
    CompanyName          = 'JDH Information Technology Solutions, Inc.'
    Copyright            = '(c) 2021-2025 JDH Information Technology Solutions, Inc.'
    Description          = 'A set of PowerShell 7 commands for managing and automating PowerShell scripts, functions, and modules. You can use these tools to accelerate PowerShell script development.'
    PowerShellVersion    = '7.4'
    # TypesToProcess = @()
    FormatsToProcess     = @(
        'formats\modulelayout.format.ps1xml',
        'formats\psscriptrequirements.format.ps1xml',
        'formats\psfunctionname.format.ps1xml',
        'formats\psfunctiontool.format.ps1xml'
    )
    FunctionsToExport    = @(
        'Convert-ScriptToFunction',
        'Export-FunctionFromFile',
        'Export-FunctionToFile',
        'Export-ModuleLayout',
        'Format-FunctionName',
        'Get-FunctionAlias',
        'Get-FunctionAttribute',
        'Get-FunctionName',
        'Get-FunctionProfile',
        'Get-ModuleLayout',
        'Get-ParameterBlock',
        'Get-PSFunctionTools',
        'Get-PSRequirements',
        'Import-ModuleLayout',
        'New-CommentHelp',
        'New-ModuleFromFiles',
        'New-ModuleFromLayout',
        'Open-PSFunctionToolsHelp',
        'Open-PSFunctionToolsSamples',
        'Test-FunctionName'
    )
    CmdletsToExport      = @()
    # VariablesToExport = @()
    AliasesToExport      = @(
        'csf',
        'eff',
        'eml',
        'etf',
        'ffn',
        'ga',
        'gfa',
        'gfal',
        'gfn',
        'gfp',
        'gpb',
        'iml',
        'nch',
        'tfn'
    )
    PrivateData          = @{
        PSData = @{
            Tags         = @('AST', 'scripting', 'module', 'function', 'script', 'toolmaking')
            LicenseUri   = 'https://github.com/jdhitsolutions/PSFunctionTools/blob/main/License.txt'
            ProjectUri   = 'https://github.com/jdhitsolutions/PSFunctionTools'
            IconUri      = 'https://raw.githubusercontent.com/jdhitsolutions/PSFunctionTools/main/images/psrobot.png'
            ReleaseNotes = @'
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
'@
        } # End of PSData hashtable
    } # End of PrivateData hashtable
}
