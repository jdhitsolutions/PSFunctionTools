Function Get-FunctionAlias {
    [cmdletbinding()]
    [alias("gfal","ga")]
    [outputType("string")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Specify the .ps1 or .psm1 file with defined functions.")]
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

    New-Variable astTokens -Force
    New-Variable astErr -Force
    $Path = Convert-Path -Path $path
    [regex]$rx = "(?<=alias\().*(?=\)\])"
    Write-Verbose "Parsing $path for functions."
    $AST = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$astTokens, [ref]$astErr)

    #parse out functions using the AST
    $functions = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
    if ($functions.count -gt 0) {
        foreach ($f in $functions) {
            if ($rx.IsMatch($f.body)) {
                [pscustomobject]@{
                    Name = $f.name
                    Alias = ($rx.matches($f.body).value -replace """|'","") -split ","
                }
            }
        }
    }
}
