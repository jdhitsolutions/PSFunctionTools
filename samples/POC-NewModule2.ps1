#requires -version 7.4
#requires -module Platyps

#this is a proof of concept script file

#Export functions from files and create a new module

[CmdletBinding(SupportsShouldProcess)]
Param(
    [Parameter(position = 0, HelpMessage = 'What is the name of the new module?')]
    [ValidateNotNullOrEmpty()]
    [String]$NewModuleName = 'PSTools',

    [Parameter(Position = 1, HelpMessage = 'What is the parent path for the new module?')]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path $_ })]
    [String]$ParentPath = $env:temp,

    [Parameter(HelpMessage = 'Enter an module description.')]
    [String]$Description = 'A set of PowerShell-based tools.',

    [Parameter(Mandatory, HelpMessage = 'PowerShell script files with functions to export.')]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path $_ })]
    [string[]]$Files
)

Write-Verbose "Starting $($MyInvocation.MyCommand)"

#the new module location
$path = Join-Path -Path $ParentPath -ChildPath $NewModuleName
$export = [System.Collections.Generic.list[object]]::New()
$aliases = @()
#the layout was created using Export-ModuleLayout
$layout = "$PSScriptRoot\ModuleLayout.json"
Write-Verbose 'Creating the module structure'
Import-ModuleLayout -Name $NewModuleName -ParentPath $ParentPath -Layout $layout

#I removed the parameter validation on the target path
$functionFiles = $files | ForEach-Object {
    Write-Verbose "Processing $_"
    Export-FunctionFromFile -Path $_ -OutputPath $Path\functions\public -All -PassThru
    #get aliases
    if ($PSCmdlet.ShouldProcess($_, 'Getting function aliases')) {
        $aliases += Get-FunctionAlias -Path $_ | Select-Object -ExpandProperty alias
    }
}

if ($functionFiles) {
    $export.AddRange($functionFiles.baseName)
}

#create the root module
$psm1 = @"

Get-ChildItem `$PSScriptRoot\functions\*.ps1 -recurse |
ForEach-Object {
. `$_.FullName
}

"@
Write-Verbose "Creating root module $path\$NewModuleName.psm1"
$psm1 | Out-File "$path\$NewModuleName.psm1"

#create the module manifest
$splat = @{
    Path                 = "$path\$NewModuleName.psd1"
    RootModule           = "$NewModuleName.psm1"
    ModuleVersion        = '0.1.0'
    Author               = 'Jeff Hicks'
    CompanyName          = 'JDH Information Technology Solutions, Inc.'
    Copyright            = '(c) 2023 JDH Information Technology Solutions, Inc.'
    Description          = $Description
    CmdletsToExport      = @()
    VariablesToExport    = @()
    FunctionsToExport    = $Export
    AliasesToExport      = $aliases
    PowerShellVersion    = '5.1'
    CompatiblePSEditions = 'Desktop', 'Core'
}
Write-Verbose "Creating module manifest $($splat.path)"
New-ModuleManifest @splat

<#
this requires the Platyps module which you should be using to
create external module help documentation.
    Install-Module Platyps
#>

Write-Verbose 'Creating module help files'
if ($PSCmdlet.ShouldProcess('docs', 'create markdown help files')) {
    Import-Module $splat.path
    New-MarkdownHelp -Module $NewModuleName -OutputFolder $path\docs
    New-ExternalHelp -Path $path\docs -OutputPath $path\en-us
}

Try {
    [void](Get-Command git -ErrorAction stop)
    Write-Verbose 'Initializing git'
    if ($PSCmdlet.ShouldProcess($path, 'git initialize')) {
        Set-Location $path
        git init
        git add .
        git commit -m 'initial files'
        git checkout -b $splat.ModuleVersion
    }
}
Catch {
    Write-Host 'Skipping git init' -ForegroundColor yellow
}
if (-not $WhatIfPreference) {
    Get-ChildItem $path -Recurse
    Try {
        [void](Get-Command -Name code.cmd -ErrorAction stop)
        Write-Verbose 'Opening module in VSCode'
        code $path
    }
    Catch {
        Write-Warning 'VS Code not found.'
    }
}

Write-Verbose "Ending $($MyInvocation.MyCommand)"
