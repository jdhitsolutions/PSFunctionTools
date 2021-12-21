
#build a new module from files
$files = "$PSScriptRoot\tools.psm1","$PSScriptRoot\Get-ZeroSize.ps1"
& "$PSScriptRoot\POC-Newmodule2.ps1" -files $files
