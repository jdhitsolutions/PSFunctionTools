
Get-Childitem $psscriptroot\functions\*.ps1 -recurse |
Foreach-Object {
. $_.FullName
}

