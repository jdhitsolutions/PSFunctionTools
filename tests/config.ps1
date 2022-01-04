#requires -module @{ModuleName = 'Pester';ModuleVersion='5.2'}

$config = New-PesterConfiguration
$config.Output.Verbosity = "Detailed"

Invoke-Pester -Configuration $config