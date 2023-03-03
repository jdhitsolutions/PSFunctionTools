#requires -version 7.1
#this demo assumes you have the Platyps module and git installed

[cmdletbinding(SupportsShouldProcess)]
Param()

$splat = @{
    Description   = "Demo exported module"
    Files         = "$PSScriptRoot\tools.psm1"
    Layout        = "$PSScriptRoot\ModuleLayout.json"
    NewModuleName = "PSFooExport"
    ParentPath    = $env:temp
    CreateHelp    = $True
    FunctionPath  = "functions\public"
    InitializeGit = $True
}

Write-Host "Using these parameters"
$splat | Out-String | Write-Host
Write-host "WhatIf = $WhatIfPreference"
pause
New-ModuleFromFiles @splat -whatIf