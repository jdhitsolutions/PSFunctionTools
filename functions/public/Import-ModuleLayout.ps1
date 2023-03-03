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
        [ValidateScript({Test-Path $_ })]
        [ValidatePattern("\.json$")]
        [string]$Layout
    )

    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    $ParentPath = Convert-Path $ParentPath
    Write-Verbose "Creating module layout for $name under $ParentPath using layout from $layout."
    $ModPath = New-Item -Path $ParentPath -Name $name -ItemType Directory -Force

    <#
     ConvertFrom-Json has a bug in Windows PowerShell so
     piping the converted content to ForEach-Object and
     passing each object back to the pipeline works around it
    #>
    Get-Content -path $Layout |
    ConvertFrom-Json | ForEach-Object {$_} |
    Sort-Object -Property ItemType |
    ForEach-Object {
        #create all the directories first
        if ($_.ItemType -eq 'directory') {
            if ($PSCmdlet.ShouldProcess($_.path, "Create directory")) {
                New-Item -Path $ModPath -Name $_.path -ItemType Directory -Force
            }
        } #directory item
        elseif ($_.ItemType -eq 'file') {
            if ($PSCmdlet.ShouldProcess($_.path, "Create file")) {
                $NewFile = (Join-Path -Path $ModPath -ChildPath $_.path)
                Set-Content -Path $NewFile -Value $_.content
                Get-Item -path $NewFile
            }
        } #file item
    } #foreach-object

    Write-Verbose "Ending $($MyInvocation.MyCommand)"
}
