Function Get-FunctionName {
    [cmdletbinding()]
    [outputType("string","PSFunctionName")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            HelpMessage = "Specify the .ps1 or .psm1 file with defined functions."
        )]
        [ValidateScript({
            If (Test-Path $_ ) {
                $True
                If ($_ -match "\.ps(m)?1$") {
                    $True
                }
                Else {
                    Throw "The path must be to a .ps1 or .psm1 file."
                    $False
                }
            }
            Else {
                Throw "Can't validate that $_ exists. Please verify and try again."
                $False
            }
        })]
        [string]$Path,
        [Parameter(HelpMessage = "List all detected function names.")]
        [switch]$All,
        [Parameter(HelpMessage = "Write a rich detailed object to the pipeline.")]
        [switch]$Detailed
    )

    $Path = Convert-Path -Path $path
    Write-Verbose "Parsing $path for functions."
    $AST = _getAst $path

    #parse out functions using the AST
    $functions = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
    if ($functions.count -gt 0) {
        if ($All) {
            $out = $Functions.Name
        }
        Else {
            $out = $functions.Name | Test-FunctionName
        }
        if ($Detailed) {
            foreach ($item in $($out |Sort-object)) {
                [pscustomobject]@{
                    PSTypeName = "PSFunctionName"
                    Name = $item
                    Path = $Path
                }
            }
        }
        else {
            $out
        }
    }
    else {
        Write-Warning "No PowerShell functions detected in $path."
    }
}
