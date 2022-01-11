Function New-ModuleFromFiles {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("System.IO.FileInfo","System.IO.DirectoryInfo")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "What is the name of the new module?"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$NewModuleName,

        [Parameter(
            Position = 1,
            Mandatory,
            HelpMessage = "What is the parent path for the new module? It must already exist."
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_ })]
        [string]$ParentPath,

        [Parameter(
            Mandatory,
            HelpMessage = "Enter an module description."
        )]
        [string]$Description,

        [Parameter(
            Mandatory,
            HelpMessage = "Enter the paths to PowerShell script files with functions to export."
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_ })]
        [string[]]$Files,

        [Parameter(
            Mandatory,
            HelpMessage = "Specify the module layout json file created with Export-ModuleLayout."
        )]
        [ValidateScript({Test-Path $_ })]
        [ValidatePattern("\.json$")]
        [string]$Layout,

        [Parameter(HelpMessage = "Specify the relative path for the exported functions.")]
        [ValidateNotNullOrEmpty()]
        [string]$FunctionPath = "functions"
    )
    DynamicParam {
        $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
        If (Get-Command -name New-MarkdownHelp) {
            #CreateHelp
            if (-not $paramDictionary.ContainsKey("CreateHelp")) {

                $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
                $attributes = New-Object System.Management.Automation.ParameterAttribute
                $attributes.ParameterSetName = '__AllParameterSets'
                $attributes.HelpMessage = 'Create help documentation using the Platyps module'
                $attributeCollection.Add($attributes)

                $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('CreateHelp', [Switch], $attributeCollection)
                $paramDictionary.Add('CreateHelp', $dynParam1)
             }

            #MarkdownPath
            if (-not $paramDictionary.ContainsKey("MarkdownPath")) {

                $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
                $attributes = New-Object System.Management.Automation.ParameterAttribute
                $attributes.ParameterSetName = '__AllParameterSets'
                $attributes.HelpMessage = 'Specify the path for the markdown help files.'

                $v = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute
                $AttributeCollection.Add($v)
                $attributeCollection.Add($attributes)

                $dynParam2 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('MarkdownPath', [String], $attributeCollection)
                $dynParam2.value = "docs"
                $paramDictionary.Add('MarkdownPath', $dynParam2)

            }
        } # end if
        If (Get-Command git -ErrorAction SilentlyContinue) {

            if (-not $paramDictionary.ContainsKey("InitializeGit")) {
                #InitializeGit
                $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
                $attributes = New-Object System.Management.Automation.ParameterAttribute
                $attributes.ParameterSetName = '__AllParameterSets'
                $attributes.HelpMessage = 'Initialize the new module as a git repository'
                $attributeCollection.Add($attributes)

                $dynParam3 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('InitializeGit', [Switch], $attributeCollection)
                $paramDictionary.Add('InitializeGit', $dynParam3)

            }
        }
        return $paramDictionary
    } #end DynamicParam

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $export = [System.Collections.Generic.list[object]]::New()
        $aliases = @()
    }
    Process {
        Write-Verbose "Processing dynamic parameters"
        $dp = $PSCmdlet.GetDynamicParameters()
        if ( $PSBoundParameters.ContainsKey("CreateHelp") -AND (-Not ($PSBoundParameters.ContainsKey("MarkdownPath")))) {
            #add the default value to bound parameters if CreateHelp is detected
            $PSBoundParameters.Add("MarkdownPath", $dp["MarkdownPath"].value)
        }
        Write-Verbose "Using these bound parameters"
        $PSBoundParameters | Out-String | Write-Verbose

        #the new module location
        $path = Join-Path -Path $ParentPath -ChildPath $NewModuleName
        Write-Verbose "Creating the module structure"
        Import-ModuleLayout -Name $NewModuleName -ParentPath $ParentPath -Layout $layout
        $functionFiles = $files | ForEach-Object {
            Write-Verbose "Processing $_"
            #Export standard functions only.
            Export-FunctionFromFile -Path $_ -OutputPath (Join-Path -Path $Path -ChildPath $FunctionPath) -Passthru
            #get aliases
            if ($pscmdlet.ShouldProcess($_, "Getting function aliases")) {
                $aliases += Get-FunctionAlias -path $_ | Select-Object -ExpandProperty alias
            }
        }

        if ($functionFiles) {
            Write-Verbose "Adding file(s) $($functionFiles.basename -join ',')"
            if ($functionFiles.count -gt 1) {
                $export.AddRange($functionFiles.baseName)
            }
            else {
                $export.Add($functionFiles.baseName)
            }
        }

        #create the root module
        Write-Verbose "Creating root module $path\$newmodulename.psm1"
        $psm1 = @"

Get-Childitem `$psscriptroot\$functionPath\*.ps1 -recurse |
Foreach-Object {
. `$_.FullName
}

"@
        $psm1 | Out-File "$path\$newmodulename.psm1"

        #create the module manifest
        $splat = @{
            Path                 = "$path\$newmodulename.psd1"
            RootModule           = "$newmodulename.psm1"
            ModuleVersion        = "0.1.0"
            Description          = $Description
            CmdletsToExport      = @()
            VariablesToExport    = @()
            FunctionsToExport    = $Export
            AliasesToExport      = $aliases
            PowerShellVersion    = "5.1"
            CompatiblePSEditions = "Desktop"
        }
        Write-Verbose "Creating module manifest $($splat.path)"
        New-ModuleManifest @splat

        if ($PSBoundParameters.ContainsKey("CreateHelp")) {
            $mdPath = Join-Path -Path $path -ChildPath $PSBoundParameters["MarkdownPath"]
            $xmlPath = Join-Path -Path $path -ChildPath $(Get-Culture).name
            Write-Verbose "Creating module help files"
            if ($PSCmdlet.ShouldProcess($mdPath, "create markdown help files")) {
                if (Test-Path $mdPath) {
                    Write-Verbose "Creating markdown files in $mdpath"
                    _mkHelp -ModulePath $splat.path -Markdownpath $mdpath -OutputPath $xmlpath
                }
                else {
                    Write-Warning "Could not find $mdpath."
                }
            }
        } #if create help

        if ($PSBoundParameters.ContainsKey("InitializeGit")) {
            Write-Verbose "Initializing git"
            if ($PSCmdlet.ShouldProcess($path, "git initialize")) {
                Push-Location
                Set-Location $path
                git init
                git add .
                git commit -m "initial files"
                git checkout -b $splat.ModuleVersion
                Pop-Location
            }
        }
    } #process
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }
} #end function

