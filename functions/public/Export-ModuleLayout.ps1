Function Export-ModuleLayout {
    [cmdletbinding()]
    [alias("eml")]
    [OutputType("None","System.IO.FileInfo")]

    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Specify the model module path.")]
        [ValidateScript( { Test-Path $_ })]
        [string]$SourcePath,
        [Parameter(HelpMessage = "Define a version number for this layout.")]
        [string]$Version = "1.0",
        [Parameter(HelpMessage = "Specify the name of the Json file to store the result.")]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("\.json$")]
        [string]$FilePath = ".\modulelayout.json",
        [Parameter(HelpMessage = "Show the file result.")]
        [switch]$PassThru
    )
    Write-Verbose "Starting $($MyInvocation.MyCommand)"

    $out = [System.Collections.Generic.list[object]]::New()
    #making the metadata work cross-platform
    $meta = [PSCustomObject]@{
        ItemType     = "ModuleLayoutMetadata"
        Created      = (Get-Date -Format g)
        CreatedBy    = "$([System.Environment]::UserDomainName)\$([System.Environment]::UserName)"
        Computername = [System.Environment]::MachineName
        Source       = (Convert-Path $SourcePath)
        Version      = $version
    }
    $out.Add($meta)
    Push-Location
    #change location to the folder so that the relative path structure can be used.
    Set-Location -path $SourcePath
    Write-Verbose "Exporting directory structure from $SourcePath"

    Get-ChildItem -Recurse |
    ForEach-Object {
        $relPath = (Resolve-Path -Path $_.FullName -Relative) -replace "\.\\", ""
        Write-Verbose "Processing $relPath"
        if ($_.GetType().name -eq 'FileInfo') {
            $f = [PSCustomObject]@{
                ItemType = "file"
                Path     = $relPath
                #Windows PowerShell adds PS environment data to json conversions
                #this is a work around
                Content  = (Get-Content -Path $_.FullName | Out-String)
            }
            $out.add($f)
        }
        else {
            $d = [PSCustomObject]@{
                ItemType = "directory"
                Path     = $relPath
            }
            $out.Add($d)
        }
    } #foreach-object

    Write-Verbose "Exporting module layout to $FilePath"
    $out | ConvertTo-Json | Out-File -FilePath $FilePath
    Pop-Location
    if ($PassThru) {
        Get-Item $Filepath
    }
    Write-Verbose "Ending $($MyInvocation.MyCommand)"
}
