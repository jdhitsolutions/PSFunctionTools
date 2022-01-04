Function Get-ModuleLayout {
    [cmdletbinding()]
    [OutputType("ModuleLayout", "String")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Specify the path to the module layout json file.",
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("\.json$")]
        [ValidateScript({ Test-Path $_ })]
        [string]$Path,
        [Parameter(HelpMessage = "show the module layout as a tree. This will create a temporary folder structure in %TEMP%.")]
        [switch]$AsTree
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting module layout from $Path "

        if ($AsTree) {
            Try {
                [void](Get-Command -Name tree -CommandType Application -ErrorAction stop)

                #create a random name
                $name = [system.io.path]::GetRandomFileName().Substring(0, 8)
                $parent = [system.io.path]::GetTempPath()

                $tmpModPath = Join-Path -Path $parent -ChildPath $name
                Write-Verbose "Using temporary path $tmpModPath"
                Try {
                    [void](Import-ModuleLayout -Layout $Path -parentpath $parent -name $name -ErrorAction Stop)
                    if ($iswindows) {
                      (tree $tmpModPath /f /a | Select-Object -Skip 2) -replace ($tmpModPath.replace("\", "\\")), "C:\<PathTo>\<MYMODULE>"
                    }
                    else {
                      #assume Linux and hoping MacOS is the same
                      (tree $tmpModPath) -replace "$tmpModPath", "/path/to/module"
                    }
                }
                catch {
                    Write-Warning "This option isn't supported on this platform at this time."
                }
                if (Test-Path $tmpModPath) {
                    Write-Verbose "Removing temporary folder"
                    Remove-Item $tmpModPath -Recurse -Force
                }
            }
            Catch {
                Write-Warning "This parameter requires a tree command-line utility."
            }
        } #AsTree
        else {

            $in = Get-Content -Path $path | ConvertFrom-Json

            [PSCustomObject]@{
                PSTypeName     = "ModuleLayout"
                Path           = (Convert-Path $Path)
                Created        = $in[0].Created
                CreatedBy      = $in[0].CreatedBy
                SourcePath     = $in[0].Source
                LayoutVersion  = $in[0].Version
                SourceComputer = $in[0].computername
                Folders        = $in.where( { $_.itemtype -eq 'directory' }).Path
                Files          = $in.where( { $_.itemtype -eq 'file' }).Path
            }
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Get-ModuleLayout