

Function Export-FunctionToFile {
    [cmdletbinding(SupportsShouldProcess)]
    [alias("etf")]
    [OutputType("none", "System.IO.FileInfo")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            HelpMessage = "Specify the name of a function loaded in your PowerShell session."
        )]
        [string]$Name,
        [Parameter(HelpMessage = "Specify the location for the new file.")]
        [ValidateScript({ Test-Path $_ })]
        [string]$Path = ".",
        [Parameter(HelpMessage = "Show the file result.")]
        [switch]$Passthru,
        [Parameter(HelpMessage = "Specify #Requires statements, including the #")]
        [ValidatePattern("^#[rR]equires")]
        [string[]]$Requires
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {

        Try {
            $fun = Get-Item function:\$name -ErrorAction Stop

        }
        Catch {
            Throw "Can't find a loaded function called $Name."
        }

        if ($fun) {

            $value = @"
$($requires -join "`n")

<#
$(Get-Date)
This function was exported from $env:computername by $env:username.
Feel free to delete this comment.
#>

Function $($fun.Name) {
$($fun.Definition.Trim())
} #Close $($fun.name)
"@

            #parse out illegal filesystem characters from the name
            $Name = $Name -replace "[:\\\/\.]", ""
            $export = Join-Path -Path (Convert-Path $path) -ChildPath "$Name.ps1"
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Exporting $Name to $Export"
            Set-Content -Path $export -Value $value
            if ($Passthru -AND (-Not $WhatIfPreference)) {
                Get-Item -Path $export
            }
        }

    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Export-FunctionToFile