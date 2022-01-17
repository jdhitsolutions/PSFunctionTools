#requires -version 7.1

#export functions from a single file to separate files
Import-Module PSFunctionTools

Export-FunctionFromFile -Path $PSScriptRoot\tools.psm1 -OutputPath $env:temp -Passthru
