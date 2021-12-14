Function Get-PSRequirements {
    [cmdletbinding()]
    [OutputType("object")]
    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Path
    )
    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        New-Variable astTokens -Force
        New-Variable astErr -Force
    }
    Process {
        $Path = Convert-Path $path
        Write-Verbose "Processing $path"

        $AST = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$astTokens, [ref]$astErr)
        #add the Path as a property
        if ($ast.ScriptRequirements) {
            $ast.ScriptRequirements | Add-Member -MemberType NoteProperty -Name "Path" -Value $Path-Force -PassThru
        }
        else {
            Write-Verbose "No requirements detected in $Path."
        }
    }
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }
}
