Function Export-ModuleLayout {
    [cmdletbinding()]
    [alias("eml")]
    [OutputType("String")]

    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Specify the model module path.")]
        [ValidateScript( { Test-Path $_ })]
        [string]$Path
    )

    $out = [System.Collections.Generic.list[object]]::New()
    $meta = [pscustomobject]@{
        Created      = (Get-Date -Format g)
        CreatedBy    = $env:USERNAME
        Computername = $env:COMPUTERNAME
        Source       = (Convert-Path $path)
        Version      = "0.9"
    }
    $out.Add($meta)
    Push-Location
    Set-Location $Path
    Get-ChildItem $Path -Recurse |
    ForEach-Object {
        $relPath = (Resolve-Path -Path $_ -Relative) -replace "\.\\", ""
        if ($_.Gettype().name -eq 'FileInfo') {
            $f = [pscustomobject]@{
                ItemType = "file"
                Path     = $relPath
                Content  = (Get-Content -Path $_)
            }
            $out.add($f)
        }
        else {
            $d = [pscustomobject]@{
                ItemType = "directory"
                Path     = $relPath
            }
            $out.Add($d)
        }
    }

    $out | ConvertTo-Json
    Pop-Location
}
