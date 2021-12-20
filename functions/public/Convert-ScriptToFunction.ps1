Function Convert-ScriptToFunction {
    [cmdletbinding()]
    [Outputtype("System.String")]
    [alias('csf')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the path to your PowerShell script file."
        )]
        [ValidateScript({Test-Path $_ })]
        [ValidatePattern("\.ps1$")]
        [string]$Path,

        [Parameter(
            Position = 1,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = "What is the name of your new function?")]
        [ValidateScript({
            if ($_ -match "^\w+-\w+$") {
                $true
            }
            else {
                Throw "Your function name should have a Verb-Noun naming convention"
                $False
            }
        })]
        [string]$Name,

        [Parameter(ValueFromPipelineByPropertyName,HelpMessage = "Specify an optional alias for your new function. You can define multiple aliases separated by commas.")]
        [ValidateNotNullOrEmpty()]
        [string[]]$Alias
    )
    DynamicParam {
        <#
        If running this function in the PowerShell ISE or VS Code,
        define a ToEditor switch parameter
        #>
        If ($host.name -match "ISE|Code") {

            $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

            # Defining parameter attributes
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = '__AllParameterSets'
            $attributeCollection.Add($attributes)

            # Defining the runtime parameter
            $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('ToEditor', [Switch], $attributeCollection)
            $paramDictionary.Add('ToEditor', $dynParam1)

            return $paramDictionary
        } # end if
    } #end DynamicParam
    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        Write-Verbose "Initializing"
        New-Variable astTokens -Force
        New-Variable astErr -Force
        $new = [System.Collections.Generic.list[string]]::new()
    } #begin
    Process {
        #normalize
        $Path = Convert-Path $path
        $Name = Format-FunctionName $Name

        Write-Verbose "Processing $path"
        $AST = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$astTokens, [ref]$astErr)

        if ($ast.extent) {
            Write-Verbose "Getting any comment based help"
            $ch = $astTokens | Where-Object { $_.kind -eq 'comment' -AND $_.text -match '\.synopsis' }

            if ($ast.ScriptRequirements) {
                Write-Verbose "Adding script requirements"
               if($ast.ScriptRequirements.RequiredPSVersion) {
                   $new.Add("#requires -version $($ast.ScriptRequirements.RequiredPSVersion.ToString())")
               }
               if ($ast.ScriptRequirements.RequiredModules) {
                    Foreach ($m in $ast.ScriptRequirements.RequiredModules) {
                        #test for version requirements
                        $ver = $m.psobject.properties.where({$_.name -match 'version' -AND $_.value})
                        if ($ver) {
                            $new.Add("#requires -module @{ModuleName = '$($m.name)';$($ver.Name) = '$($ver.value)'}")
                        }
                        else {
                            $new.add("#requires -module $($m.Name)")
                        }
                    }
               }
               if ($ast.ScriptRequirements.IsElevationRequired) {
                    $new.Add("#requires -RunAsAdministrator")
               }
               If ($ast.ScriptRequirements.requiredPSEditions) {
                    $new.add("#requires -PSEdition $($ast.ScriptRequirements.requiredPSEditions)")
               }

               $new.Add("`n")
            }
            else {
                Write-Verbose "No script requirements found"
            }


           $head = @"
# Function exported from $Path

Function $Name {

"@
        $new.add($head)

            if ($ch) {
                $new.Add($ch.text)
                $new.Add("`n")
            }
            else {
                Write-Verbose "Generating new comment based help from parameters"
                New-CommentHelp -ParamBlock $ast.ParamBlock | Foreach-Object { $new.Add("$_")}
                $new.Add("`n")
            }

            [regex]$rx = "\[cmdletbinding\(.*\)\]"
            if ($rx.Ismatch($ast.Extent.text)) {
                Write-Verbose "Using existing cmdletbinding"
                #use the first match
                $cb = $rx.match($ast.extent.text).Value
                $new.Add("`t$cb")
            }
            else {
                 Write-Verbose "Adding [cmdletbinding()]"
               $new.Add("`t[cmdletbinding()]")
            }

           if ($alias) {
                Write-Verbose "Adding function alias definition $($alias -join ',')"
                $new.Add("`t[Alias('$($alias -join "','")')]")
           }
            if ($ast.ParamBlock) {
                Write-Verbose "Adding defined Param() block"
                [void]($ast.ParamBlock.tostring().split("`n").Foreach({$new.add("`t$_")}) -join "`n")
                $new.Add("`n")
            }
            else {
                Write-Verbose "Adding Param() block"
                $new.add("`tParam()")
            }
            if ($ast.DynamicParamBlock) {
                #assumes no more than 1 dynamic parameter
                Write-Verbose "Adding dynamic parameters"
                [void]($ast.DynamicParamBlock.tostring().split("`n").Foreach({$new.Add($_)}) -join "`n")
            }

            if ($ast.BeginBlock.Extent.text) {
                Write-Verbose "Adding defined Begin block"
                [void]($ast.BeginBlock.Extent.toString().split("`n").Foreach({$new.Add($_)}) -join "`n")
                $UseBPE = $True
            }

            if ($ast.ProcessBlock.Extent.text) {
                Write-Verbose "Adding defined Process block"
                [void]($ast.ProcessBlock.Extent.ToString().split("`n").Foreach({$new.add($_) }) -join "`n")
            }

            if ($ast.EndBlock.Extent.text) {
                if ($UseBPE) {
                    Write-Verbose "Adding opening End{} block"
                    $new.Add("`tEnd {")
                }
                    Write-Verbose "Adding the remaining code or defined endblock"
                    [void]($ast.Endblock.Statements.foreach({ $_.tostring() }).Foreach({ $new.Add($_)}))
                if ($UseBPE) {
                Write-Verbose "Adding closing End {} block"
                    $new.Add("`t}")
                }
            }
            else {
                $new.Add("End { }")
            }
            Write-Verbose "Closing the function"
           $new.Add( "`n} #close $name")

           if ($PSBoundParameters.ContainsKey("ToEditor")) {
                Write-Verbose "Opening result in editor"
                if ($host.name -match "ISE") {
                    $newfile = $psise.CurrentPowerShellTab.Files.add()
                    $newfile.Editor.InsertText(($new -join "`n"))
                    $newfile.editor.select(1,1,1,1)
                }
                elseif ($host.name -match "Code") {
                    $pseditor.Workspace.NewFile()
                    $ctx = $pseditor.GetEditorContext()
                    $ctx.CurrentFile.InsertText($new -join "`n")
                }
                else {
                    $new -join "`n" | Set-Clipboard
                    Write-Warning "Can't detect the PowerShell ISE or VS Code. Output has been copied to the clipboard."
                }
        }
        else {
            Write-Verbose "Writing output [$($new.count) lines] to the pipeline"
            $new -join "`n"
        }
        } #if ast found
        else {
            Write-Warning "Failed to find a script body to convert to a function."
        }

    } #process
    End {
        Write-Verbose "Ending $($MyInvocation.mycommand)"
    }
}
