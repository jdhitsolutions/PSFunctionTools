Function Get-PSRequirements {
    [cmdletbinding()]
    [OutputType("object")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateScript({
            If (Test-Path $_ ) {
                $True
            }
            Else {
                Throw "Can't validate that $_ exists. Please verify and try again."
                $False
            }
        })]
        [ValidateScript({
            If ($_ -match "\.ps(m)?1$") {
                $True
            }
            Else {
                Throw "The path must be to a .ps1 or .psm1 file."
                $False
            }
        })]
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
            $out = $ast.ScriptRequirements |
            Add-Member -MemberType NoteProperty -Name "Path" -Value $Path -Force -PassThru
            #insert a custom type name for formtting purposes
            $out.psobject.typenames.insert(0,'PSScriptRequirements')
            #write the object to the pipeline
            $out
        }
        else {
            Write-Verbose "No requirements detected in $Path."
        }
    }
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }
}
