#requires -version 7.1

#a proof of concept to convert scripts to a new module

Import-Module PSFunctionTools -Force

$NewModuleName = "PSMagic"
$Description = "A sample PowerShell module"
$ParentPath = $env:TEMP
$path = New-Item -Name $NewModuleName -Path $ParentPath -ItemType Directory -Force

#create the module structure
"docs", "functions", $(Get-Culture).name, "formats" |
ForEach-Object { New-Item -Path $path -Name $_ -ItemType Directory }

#file data
$data = @"
"Path","Name"
"$PSScriptRoot\SampleScript.ps1","Get-Foo"
"$PSScriptRoot\SampleScript2.ps1","Set-Foo"
"$PSScriptRoot\SampleScript3.ps1","Invoke-Foo"
"$PSScriptRoot\SampleScript4.ps1","Remove-Foo"
"$PSScriptRoot\SampleScript5.ps1","Test-Foo"
"@

$csv = $data | ConvertFrom-Csv
foreach ($item in $csv) {
    $out = Join-Path $path\functions "$($item.name).ps1"
    $item | Convert-ScriptToFunction | Out-File -FilePath $out
    Get-Item $out

} #foreach item

#create the root module
$psm1 = @"

Get-ChildItem `$PSScriptRoot\functions\*.ps1 |
Foreach-Object {
. `$_.FullName
}

"@

$psm1 | Out-File "$path\$NewModuleName.psm1"

#create the module manifest
$splat = @{
    Path                 = "$path\$NewModuleName.psd1"
    RootModule           = "$NewModuleName.psm1"
    ModuleVersion        = "0.1.0"
    Author               = $env:USERNAME
    Description          = $Description
    FunctionsToExport    = $csv.name
    PowerShellVersion    = "5.1"
    CompatiblePSEditions = "Desktop"
}
New-ModuleManifest @splat

Get-ChildItem $path

