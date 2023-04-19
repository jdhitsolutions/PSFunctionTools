
Get-ChildItem $PSScriptRoot\functions\*.ps1 -recurse |
Foreach-Object {
. $_.FullName
}
