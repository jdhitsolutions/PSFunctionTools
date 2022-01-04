Function New-ModuleFromLayout {
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
            HelpMessage = "Specify the module layout json file created with Export-ModuleLayout."
        )]
        [ValidateScript( { Test-Path $_ })]
        [ValidatePattern("\.json$")]
        [string]$Layout,

        [Parameter(HelpMessage = "Specify the relative path where your functions will be created.")]
        [ValidateNotNullOrEmpty()]
        [string]$FunctionPath = "functions"

    )
    DynamicParam {
        # Add parameter if git.exe is detected
        If (Get-Command git -ErrorAction SilentlyContinue) {
            $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

            #InitializeGit
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = '__AllParameterSets'
            $attributes.HelpMessage = 'Initialize the new module as a git repository'
            $attributeCollection.Add($attributes)

            $dynParam = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('InitializeGit', [Switch], $attributeCollection)
            $paramDictionary.Add('InitializeGit', $dynParam)

            return $paramDictionary
        }

    } #end DynamicParam

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }
    Process {

        Write-Verbose "Using these bound parameters"
        $PSBoundParameters | Out-String | Write-Verbose

        #the new module location
        $path = Join-Path -Path $ParentPath -ChildPath $NewModuleName
        Write-Verbose "Creating the module structure"
        Import-ModuleLayout -Name $NewModuleName -ParentPath $ParentPath -Layout $layout

        #create the root module
        $psm1 = @"

Get-Childitem `$psscriptroot\$functionpath\*.ps1 -recurse |
Foreach-Object {
. `$_.FullName
}

"@
        Write-Verbose "Creating root module $path\$newmodulename.psm1"
        $psm1 | Out-File "$path\$newmodulename.psm1"

        #create the module manifest
        $splat = @{
            Path                 = "$path\$newmodulename.psd1"
            RootModule           = "$newmodulename.psm1"
            ModuleVersion        = "0.1.0"
            Description          = $Description
            PowerShellVersion    = "5.1"
            CompatiblePSEditions = "Desktop"
        }
        Write-Verbose "Creating module manifest $($splat.path)"
        New-ModuleManifest @splat

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