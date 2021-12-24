#
# Module manifest for module PSFunctionTools
#

@{

    RootModule           = 'PSFunctionTools.psm1'
    ModuleVersion        = '0.4.0'
    CompatiblePSEditions = 'Desktop', 'Core'
    GUID                 = '151466e0-a952-4b6a-ad81-40dafc9ef9bb'
    Author               = 'Jeff Hicks'
    CompanyName          = 'JDH Information Technology Solutions, Inc.'
    Copyright            = '(c) 2021 JDH Information Technology Solutions, Inc.'
    Description          = 'A set of PowerShell commands for working with PowerShell scripts and functions.'
    PowerShellVersion    = '5.1'
    # TypesToProcess = @()
    FormatsToProcess     = @('formats\modulelayout.format.ps1xml',
        'formats\psscriptrequirements.format.ps1xml',
        'formats\psfunctionname.format.ps1xml')
    FunctionsToExport    = @(
        'Test-FunctionName', 'Get-FunctionName', 'Get-FunctionAlias',
        'Export-FunctionFromFile', 'Export-ModuleLayout',
        'Import-ModuleLayout', 'Convert-ScriptToFunction',
        'Get-PSRequirements', 'New-CommentHelp', 'Format-FunctionName',
        'Get-ModuleLayout', 'Get-ParameterBlock', 'Get-FunctionAttribute',
        'New-ModuleFromFiles','New-ModuleFromLayout')
    CmdletsToExport      = @()
    # VariablesToExport = @()
    AliasesToExport      = @('gfal', 'ga', 'eff', 'eml', 'iml', 'csf', 'gpb',
        'gfa')
    PrivateData          = @{

        PSData = @{
            Tags = @('AST', 'scripting', 'module', 'function')
            LicenseUri = 'https://github.com/jdhitsolutions/PSFunctionTools/blob/main/License.txt'
            ProjectUri = 'https://github.com/jdhitsolutions/PSFunctionTools'
            # IconUri = ''
            # ReleaseNotes = ''
            # Prerelease = ''
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
}

