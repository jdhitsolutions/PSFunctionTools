

Function Get-ModuleLayout {
    [cmdletbinding()]
    [OutputType("ModuleLayout")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Specify the path to the module layout json file.",
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("\.json$")]
        [ValidateScript({ Test-Path $_ })]
        [string]$Path
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting module layout from $Path "
        $in = Get-Content -Path $path | ConvertFrom-Json

        [PSCustomObject]@{
            PSTypeName         = "ModuleLayout"
            Path               = (Convert-Path $Path)
            Created            = $in[0].Created
            CreatedBy          = $in[0].CreatedBy
            SourcePath         = $in[0].Source
            LayoutVersion      = $in[0].Version
            SourceComputer     = $in[0].computername
            Folders            = $in.where( { $_.itemtype -eq 'directory' }).Path
            Files              = $in.where( { $_.itemtype -eq 'file' }).Path
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Get-ModuleLayout