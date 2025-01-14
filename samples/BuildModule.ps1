#requires -version 7.4

#build a new module from files
$files = "$PSScriptRoot\tools.psm1","$PSScriptRoot\Get-ZeroSize.ps1"
& "$PSScriptRoot\POC-NewModule2.ps1" -files $files
