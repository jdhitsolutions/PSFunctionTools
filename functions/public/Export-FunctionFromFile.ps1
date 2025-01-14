Function Export-FunctionFromFile {
    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = "All")]
    [alias("eff")]
    [OutputType("None", "System.IO.FileInfo")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Specify the .ps1 or .psm1 file with defined functions.")]
        [ValidateScript({
            If (Test-Path $_ ) {
                $True
                If ($_ -match "\.ps(m)?1$") {
                    $True
                }
                Else {
                    Throw "The path must be to a .ps1 or .psm1 file."
                    $False
                }
            }
            Else {
                Throw "Can't validate that $_ exists. Please verify and try again."
                $False
            }
        })]
        [string]$Path,
        [Parameter(HelpMessage = "Specify the output path. The default is the same directory as the .ps1 file.")]
        [string]$OutputPath,
        [Parameter(HelpMessage = "Specify a function by name", ParameterSetName = "byName")]
        [string[]]$Name,
        [Parameter(HelpMessage = "Export all detected functions.", ParameterSetName = "all")]
        [switch]$All,
        [Parameter(HelpMessage = "Pass the output file to the pipeline.")]
        [switch]$PassThru
    )
    DynamicParam {

        If ( $Host.name -match 'ise|Code') {

            $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

            # Defining parameter attributes
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = '__AllParameterSets'
            $attributes.HelpMessage = 'Delete the function from the source file.'
            $attributeCollection.Add($attributes)

            # Adding a parameter alias
            $dynAlias = New-Object System.Management.Automation.AliasAttribute -ArgumentList 'rm'
            $attributeCollection.Add($dynAlias)

            # Defining the runtime parameter
            $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('Remove', [Switch], $attributeCollection)
            $paramDictionary.Add('Remove', $dynParam1)

            return $paramDictionary
        } # end if
    } #end DynamicParam

    Begin {

        Write-Verbose "[BEGIN  ] Starting $($MyInvocation.MyCommand) [$($PSCmdlet.ParameterSetName)]"
        Write-Verbose ($PSBoundParameters | Out-String)

        if (-Not $OutputPath) {
            #use the parent path of the file unless the user specifies a different path
            $OutputPath = Split-Path -Path $Path -Parent
        }
        if ($Name) {
            Write-Verbose "[BEGIN  ] Looking for functions $($name -join ',')"
        }

        #insert a temporary line for each line of the function
        #this will be deleted at the end. Define this in the Begin block so
        #that it remains static
        $line = "DEL-FUNCTION-$(Get-Date -f 'hhmmss')`n"
    } #begin
    Process {
        #Convert the path to a full file system path
        $path = Convert-Path -Path $path
        Write-Verbose "[PROCESS] Processing $path for functions"
        #the file will always be parsed regardless of WhatIfPreference
        $AST = _getAST $path

        #parse out functions using the AST
        $functions = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)

        if ($functions.count -gt 0) {
            Write-Verbose "[PROCESS] Found $($functions.count) functions"
            Write-Verbose "[PROCESS] Creating files in $OutputPath"
            Foreach ($item in $functions) {
                Write-Verbose "[PROCESS] Detected function $($item.name)"

                Switch ($PSCmdlet.ParameterSetName) {

                    "byName" {
                        if ($Name -contains $item.Name) {
                            #export named function
                            Write-Verbose "[PROCESS] $($item.name) matches by name"
                            $export = $True
                        }
                        else {
                            $export = $False
                        }
                    }

                    "All" {
                        if ($All -OR (Test-FunctionName -name $item.name)) {
                            #only export functions with standard names or if -All is detected.
                            $export = $True
                        }
                        else {
                            $export = $False
                        }
                    }

                } #switch

                If ($export) {
                    $NewFile = Join-Path -Path $OutputPath -ChildPath "$($item.name).ps1"
                    Write-Verbose "[PROCESS] Creating new file $NewFile"
                    Set-Content -Path $NewFile -Value $item.ToString() -Force

                    if ($PSBoundParameters.ContainsKey("Remove")) {
                        $f = $item.extent
                        $span = $f.EndLineNumber - $f.StartLineNumber

                        Switch -Regex ($host.name) {
                            "PowerShell ISE" {
                                Write-Verbose "[PROCESS] Removing from the PowerShell ISE"
                                psedit $path
                                $source = ($psISE.CurrentPowerShellTab.Files).where({ $_.fullpath -eq $path })
                                Write-Verbose "[PROCESS] Selecting a span of $span lines"
                                $source.Editor.Select($f.StartLineNumber, $f.StartColumnNumber, $f.EndLineNumber, $f.EndColumnNumber)
                                if ($PSCmdlet.ShouldProcess($item.name, "Deleting from $Path at $($f.StartLineNumber),$($f.StartColumnNumber),$($f.EndLineNumber),$($f.EndColumnNumber)")) {
                                    $source.Editor.InsertText($line * $span)
                                    #set a flag to save the file at the end
                                    $SaveISE = $True
                                }
                            }
                            "Visual Studio Code" {
                                Write-Verbose "[PROCESS] Removing from VS Code"
                                Open-EditorFile $Path
                                $ctx = $psEditor.getEditorContext()
                                if ($PSCmdlet.ShouldProcess($item.name, "Deleting from $Path at $($f.StartLineNumber),$($f.StartColumnNumber),$($f.EndLineNumber),$($f.EndColumnNumber)")) {
                                    $psEditor.Window.SetStatusBarMessage("Removing lines $($f.StartLineNumber) to $($f.EndLineNumber) from $path", 1000)
                                    $ctx.CurrentFile.InsertText(($line * $span), $f.StartLineNumber, $f.StartColumnNumber, $f.EndLineNumber, $f.EndColumnNumber)
                                    Start-Sleep -Milliseconds 250
                                    #set a flag to save the file at the end
                                    $SaveVSCode = $True
                                }
                            }
                        }
                    }
                    if ($PassThru -AND (-Not $WhatIfPreference)) {
                        Get-Item -Path $NewFile
                    }
                }
                else {
                    Write-Verbose "[PROCESS] Skipping $($item.name)"
                }
            } #foreach item
        }
        else {
            Write-Warning "No PowerShell functions detected in $Path."
        }
    } #process
    End {
        if ($SaveISE) {
            Write-Verbose "[END    ] Removing temporary lines $line"
            $rev = $source.editor.Text -replace $line, ''
            $source.editor.text = $rev
            Write-Verbose "[END    ] Saving $path in the PowerShell ISE"
            Start-Sleep -Milliseconds 500
            $source.Save()
            #keep the file open in the ISE in case you need to do anything
            #else with it.
            $source.Editor.SetCaretPosition(1, 1)
        }
        elseif ($SaveVSCode) {
            Write-Verbose "[END    ] Saving and re-opening $path"
            $ctx.CurrentFile.Save()
            #need to give the file time to close
            Start-Sleep -Seconds 2
            Write-Verbose "[END    ] Getting file contents"
            $txt = Get-Content $path -Raw

            # $txt | Out-File d:\temp\t.txt -force
            Write-Verbose "[END    ] Filtering for line $($line.TrimEnd())"

            $rev = ([System.Text.RegularExpressions.Regex]::Matches($txt, "^((?!$($line.trimend())).)*$", "multiline")).value.replace("`r", "")

            Write-Verbose "[END    ] Saving $path in VS Code"
            $rev | Out-File -FilePath $Path -Force
            #set cursor selection to top of file.
            #not sure how to force scrolling to the top
            $ctx.SetSelection(1, 1, 1, 1)
        }
        Write-Verbose "[END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}
