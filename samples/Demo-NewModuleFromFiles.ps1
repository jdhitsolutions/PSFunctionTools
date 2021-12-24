#this demo assumes you have the Platyps module and git installed

$splat = @{
    Description   = "Demo exported module"
    Files         = "$PSScriptRoot\tools.psm1"
    Layout        = "$PSScriptRoot\ModuleLayout.json"
    NewModuleName = "PSFooExport"
    ParentPath    = $env:temp
    Verbose       = $True
    CreateHelp    = $True
    FunctionPath  = "functions\public"
    InitializeGit = $True
}

New-ModuleFromFiles @splat