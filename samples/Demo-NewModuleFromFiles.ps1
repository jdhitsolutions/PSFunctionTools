#requires -version 7.4
#this demo assumes you have the Platyps module and git installed

[CmdletBinding(SupportsShouldProcess)]
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
Clear-Host
Write-Host "Using these parameters" -ForegroundColor yellow
$splat | Out-String | Write-Host -ForegroundColor yellow
Write-Host "WhatIf = $WhatIfPreference" -ForegroundColor yellow
pause
Write-Host "Creating new module from files" -ForegroundColor Green
New-ModuleFromFiles @splat
$newModulePath = Join-Path -Path $splat.ParentPath -ChildPath $splat.NewModuleName
Write-Host "New module created in newModulePath" -ForegroundColor Green
if (-Not $WhatIfPreference) {
    Get-ChildItem -Path $newModulePath -Recurse
}
