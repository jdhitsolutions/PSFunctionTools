#
# Module manifest for module PSFunctionTools
#

@{
    RootModule           = 'PSFunctionTools.psm1'
    ModuleVersion        = '1.0.0'
    CompatiblePSEditions = 'Core'
    GUID                 = '151466e0-a952-4b6a-ad81-40dafc9ef9bb'
    Author               = 'Jeff Hicks'
    CompanyName          = 'JDH Information Technology Solutions, Inc.'
    Copyright            = '(c) 2021-2022 JDH Information Technology Solutions, Inc.'
    Description          = 'A set of PowerShell commands for managing and automating PowerShell scripts, functions, and modules.'
    PowerShellVersion    = '7.1'
    # TypesToProcess = @()
    FormatsToProcess     = @('formats\modulelayout.format.ps1xml',
        'formats\psscriptrequirements.format.ps1xml',
        'formats\psfunctionname.format.ps1xml',
        'formats\psfunctiontool.format.ps1xml'
    )
    FunctionsToExport    = @(
        'Test-FunctionName', 'Get-FunctionName', 'Get-FunctionAlias',
        'Export-FunctionFromFile', 'Export-ModuleLayout',
        'Import-ModuleLayout', 'Convert-ScriptToFunction',
        'Get-PSRequirements', 'New-CommentHelp', 'Format-FunctionName',
        'Get-ModuleLayout', 'Get-ParameterBlock', 'Get-FunctionAttribute',
        'Get-FunctionProfile', 'New-ModuleFromFiles', 'New-ModuleFromLayout',
        'Get-PSFunctionTools','Export-FunctionToFile')
    CmdletsToExport      = @()
    # VariablesToExport = @()
    AliasesToExport      = @('gfal', 'ga', 'eff', 'eml', 'iml', 'csf', 'gpb',
        'gfa', 'nch', 'ffn', 'gfn', 'tfn', 'gfp','etf')
    PrivateData          = @{

        PSData = @{
            Tags       = @('AST', 'scripting', 'module', 'function', 'script')
            LicenseUri = 'https://github.com/jdhitsolutions/PSFunctionTools/blob/main/License.txt'
            ProjectUri = 'https://github.com/jdhitsolutions/PSFunctionTools'
            IconUri    = 'https://raw.githubusercontent.com/jdhitsolutions/PSFunctionTools/main/images/psrobot.png'
            # ReleaseNotes = ''
            # Prerelease = ''
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable
    } # End of PrivateData hashtable
}

