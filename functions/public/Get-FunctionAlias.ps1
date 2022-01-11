Function Get-FunctionAlias {
    [cmdletbinding()]
    [alias("gfal", "ga")]
    [outputType("string")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Specify the .ps1 or .psm1 file with defined functions.")]
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
        [string]$Path
    )

    $Path = Convert-Path -Path $path
    Write-Verbose "Processing $path for AST data."
    $AST = _getAST $path

    #parse out functions using the AST
    Write-Verbose "Parsing AST data for functions."
    $functions = $ast.FindAll( { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
    if ($functions.count -gt 0) {
        foreach ($f in $functions) {
            #thanks to https://twitter.com/PrzemyslawKlys for this suggestion
            $aliasAST = $f.FindAll( {
                    $args[0] -is [System.Management.Automation.Language.AttributeAst] -and
                    $args[0].TypeName.Name -eq 'Alias' -and
                    $args[0].Parent -is [System.Management.Automation.Language.ParamBlockAst]
                }, $true)

            if ($aliasAST.positionalArguments) {
                [pscustomobject]@{
                    PSTypeName = "PSFunctionAlias"
                    Name       = $f.name
                    Alias      = $aliasAST.PositionalArguments.Value
                }
            }
        }
    }
}