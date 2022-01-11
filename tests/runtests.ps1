#requires -module @{ModuleName = 'Pester';ModuleVersion='5.2'}

$config = New-PesterConfiguration
#$config.Run.SkipRun = $true
#$config.run.PassThru = $True
$config.Output.Verbosity = "Detailed"

Invoke-Pester -Configuration $config -WarningAction SilentlyContinue