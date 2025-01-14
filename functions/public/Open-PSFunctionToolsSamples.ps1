Function Open-PSFunctionToolsSamples {
    [cmdletbinding()]
    [OutputType('System.IO.FileInfo')]

    Param( )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        $SamplePath = "$PSScriptRoot\..\..\samples"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Changing location to $SamplePath"
        Set-Location -Path $SamplePath
        Get-ChildItem
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Open-PSFunctionToolsSamples