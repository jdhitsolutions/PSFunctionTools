#requires -version 3.0

#this is a sample script
<#
.Synopsis
Sample script
.Description
This is a sample
.Parameter Count
How many numbers do you want?
#>

Param ([Int]$Count = 1,[String]$Name = "Foo")

Begin {
    Write-Host "this is a sample script that doesn't do anything but write a random number" -ForegroundColor Yellow
    Write-Host $Foo -ForegroundColor Green
}
Process {
    #get numbers
    1..$count | ForEach-Object {
    Get-Random -Minimum 1 -Maximum 1000
    }
}
End {
    Write-Host "Ending script" -ForegroundColor yellow
}
#eof
