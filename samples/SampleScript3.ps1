#requires -version 3.0

#this is a sample script

Param (
    [Parameter(Position = 0, HelpMessage = "How many numbers do you want?")]
    [int]$Count = 1,
    [string]$Name,
    [switch]$Demo
)

Write-Host "this is a sample script that doesn't do anything but write a random number" -ForegroundColor Yellow

#get numbers
1..$count | ForEach-Object {
    Get-Random -Minimum 1 -Maximum 1000
}

Write-Host "Ending script" -ForegroundColor yellow

#eof