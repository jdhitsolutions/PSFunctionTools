Function Open-PSFunctionToolsHelp {
    [CmdletBinding()]
    [OutputType('None','String')]
    Param(
        [Parameter(HelpMessage = 'Open the help file as markdown.')]
        [Alias('md')]
        [switch]$AsMarkdown
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"

        if ($AsMarkdown) {
            $docPath = "$PSScriptRoot\..\..\README.md"
        }
        else {
            $docPath = "$PSScriptRoot\..\..\PSFunctionTools-Help.pdf"
        }

    } #begin
    Process {
        Write-Verbose "Testing for $docPath"
        If (Test-Path -Path $docPath) {
            if ($AsMarkdown) {
                Write-Verbose "Opening $docPath as markdown."
                Show-Markdown -Path $docPath
            }
            else {
                Try {
                    Write-Verbose "Opening $docPath as a PDF file"
                    Invoke-Item -Path $docPath -ErrorAction Stop
                }
                Catch {
                    Write-Warning "Failed to open $docPath"
                }
            }
        } #if Test-Path
        else {
            Throw "Cannot find the file $docPath"
        }
    } #process
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #end
}