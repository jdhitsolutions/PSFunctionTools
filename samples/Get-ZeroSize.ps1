#requires -module CIMCmdlets

Function Get-ZeroLengthFiles {
    [CmdletBinding()]
    [alias('gzf', 'zombie')]
    Param(
        [Parameter(Position = 0, HelpMessage = 'Specify a path to search.')]
        [ValidateScript( { Test-Path -Path $_ })]
        [String]$Path = '.',
        [Switch]$Recurse
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        #select a subset of properties which speeds things up
        $get = 'Name', 'CreationDate', 'LastModified', 'FileSize'

        $cimParams = @{
            Classname   = 'CIM_DATAFILE'
            Property    = $get
            ErrorAction = 'Stop'
            Filter      = ''
        }
    } #begin
    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Using specified path $Path"
        #test if folder is using a link or reparse point
        if ( (Get-Item -Path $Path).Target) {
            $target = (Get-Item -Path $Path).Target
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] A reparse point was detected pointing towards $target"
            #re-define $path to use the target
            $Path = $Target
        }
        #convert the path to a file system path
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Converting $Path"
        $cPath = Convert-Path $Path
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Converted to $cPath"

        #trim off any trailing \ if cPath is other than a drive root like C:\
        if ($cPath.Length -gt 3 -AND $cPath -match '\\$') {
            $cPath = $cPath -replace '\\$', ''
        }

        #parse out the drive
        $drive = $cPath.Substring(0, 2)
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Using Drive $drive"

        #get the folder path from the first \
        $folder = $cPath.Substring($cPath.IndexOf('\')).replace('\', '\\')
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Using folder $folder (escaped)"

        if ($folder -match '\w+' -AND $PSBoundParameters.ContainsKey('Recurse')) {
            #create the filter to use the wildcard for recursing
            $filter = "Drive='$drive' AND Path LIKE '$folder\\%' AND FileSize=0"
        }
        elseif ($folder -match '\w+') {
            #create an exact path pattern
            $filter = "Drive='$drive' AND Path='$folder\\' AND FileSize=0"
        }
        else {
            #create a root drive filter for a path like C:\
            $filter = "Drive='$drive' AND Path LIKE '\\%' AND FileSize=0"
        }

        #add the filter to the parameter hashtable
        $cimParams.filter = $filter
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Looking for zero length files with filter $filter"

        #initialize a counter to keep track of the number of files found
        $i = 0
        Try {
            Write-Host "Searching for zero length files in $cPath. This might take a few minutes..." -ForegroundColor magenta
            #find files matching the query and create a custom object for each
            Get-CimInstance @cimParams | ForEach-Object {
                #increment the counter
                $i++

                #create a custom object
                [PSCustomObject]@{
                    PSTypeName   = 'cimZeroLengthFile'
                    Path         = $_.Name
                    Size         = $_.FileSize
                    Created      = $_.CreationDate
                    LastModified = $_.LastModified
                }
            }
        }
        Catch {
            Write-Warning "Failed to run query. $($_.exception.message)"
        }
        if ($i -eq 0) {
            #display a message if no files were found
            Write-Host "No zero length files were found in $cPath." -ForegroundColor yellow
        }
        else {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Found $i matching files"
        }
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}
