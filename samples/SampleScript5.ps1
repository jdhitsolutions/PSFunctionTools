#requires -version 5.1
#requires -RunAsAdministrator

#This function can be used for analysis and testing. It
#isn't something that will run without error or make any sense.
#The use of aliases is intentional for testing purposes.

Function Get-Result {
<#
.Synopsis
Sample function
.Description
This is a sample
.Parameter Count
How many numbers do you want?
#>
    [CmdletBinding()]
    [alias('grx')]
    Param (
        [Parameter(Position=0)]
        [ValidateRange(1,100)]
        [Int]$Count = 1,
        [ValidateNotNullOrEmpty]
        [String]$Name = "Foo"
        )

    Begin {
        Write-Host "this is a sample script that doesn't do anything but write a random number" -ForegroundColor Yellow
        #this is an undefined alias
        w -msg "Processing $Name"
        $a = [System.DateTime]::Now
        Write-Host $a
        $os = gcim Win32_OperatingSystem
        Write-Verbose "Running in $($PSVersionTable.PSVersion) on $($os.caption)"
        $f = Join-Path $([system.environment]::GetEnvironmentVariable("TEMP") "r.txt"
    }
    Process {
        #get numbers
        1..$count | ForEach {
            Get-Random -Minimum 1 -Maximum 1000
        } | tee -FilePath $f
    }
    End {
        Write-Host "Ending script" -ForegroundColor yellow
        $b = [System.DateTime]::now
        $c = New-TimeSpan $a $b
        Write-Verbose "Runtime: $c"
        notepad.exe $f
        #run a clean batch file
        c:\scripts\cleanup.bat
    }
} #close function
