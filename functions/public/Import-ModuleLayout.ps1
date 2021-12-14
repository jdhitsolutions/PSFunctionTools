function Import-ModuleLayout {
    [CmdletBinding(SupportsShouldProcess)]
    [alias("iml")]
    [OutputType("none")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "What is the name of your new module?")]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^\w+$")]
        [string]$Name,
        [Parameter(HelpMessage = "What is the parent path? The default is the current location")]
        [ValidateScript( { Test-Path $_ })]
        [string]$ParentPath = ".",
        [Parameter(Mandatory, HelpMessage = "Specify the path to the module layout json file.")]
        [ValidateScript( { Test-Path $_ })]
        [string]$Layout
    )

    $ParentPath = Convert-Path $ParentPath
    Write-Verbose "Creating module layout for $name under $parentpath using layout from $layout."
    $modpath = New-Item -Path $ParentPath -Name $name -ItemType Directory -Force

    Get-Content $Layout |
    ConvertFrom-Json | Sort-Object -Property ItemType |
    ForEach-Object {
        if ($_.Itemtype -eq 'directory') {
            if ($pscmdlet.ShouldProcess($_.path, "Create directory")) {
                New-Item -Path $modpath -Name $_.path -ItemType Directory -Force
            }
        }
        elseif ($_.itemtype -eq 'file') {
            if ($pscmdlet.ShouldProcess($_.path, "Create file")) {
                Set-Content -Path (Join-Path -Path $modPath -ChildPath $_.path) -Value $_.content
            }
        }
    }
}
