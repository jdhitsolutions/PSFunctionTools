Function Get-FunctionProfile {
    [cmdletbinding()]
    [alias("gfp")]
    [OutputType("PSFunctionProfile")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specify the name of the PowerShell function."
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specify the path to the .ps1 or .psm1 file."
        )]
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
        [string]$Path
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"

        New-Variable astTokens -Force
        New-Variable astErr -Force
    } #begin

    Process {
        $Name = Format-FunctionName $Name
        $Path = Convert-Path -Path $path
        $cmds = [System.Collections.Generic.list[string]]::new()
        $aliasList = [System.Collections.Generic.list[string]]::new()
        $Unresolved = [System.Collections.Generic.list[string]]::new()
        $dotnet = [System.Collections.Generic.list[string]]::new()
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Profiling function $name in $path"

        $fa = Get-FunctionAttribute @PSBoundParameters
        $pb = Get-ParameterBlock @PSBoundParameters
        $attrib = ($pb.parameters.attributes).where({ $_.NamedArguments.ArgumentName -eq "ParameterSetName" }).NamedArguments | Where-Object { $_.ArgumentName -eq 'parameterSetName' }
        $req = Get-PSRequirements -Path $Path

        $AST = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$astTokens, [ref]$astErr)

        $fd = $AST.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] -AND $args[0].name -eq $Name }, $True)
        $content = $fd.Extent.Text
        $funAST = [System.Management.Automation.Language.Parser]::ParseInput($content, [ref]$astTokens, [ref]$astErr)

        #find .NET expressions
        $t = $funAST.findAll({ $args[0] -is [System.Management.Automation.Language.TypeExpressionAst] }, $true)
        if ($t) {
            foreach ($item in $t) {
                $value = $item.parent.Extent.text.ToLower()
                if (-Not $dotnet.Contains($value)) {
                    $dotnet.add($value)
                }
            }
        }
        #get commands
        $RawList = ($astTokens).where({ ($_.TokenFlags -contains 'CommandName') -AND ($_.kind -eq 'generic') }).Text.ToLower() |
        Select-Object -Unique
        foreach ($item in $RawList) {
            if ($item -match "^\w+-\w+$") {
                $item = Format-FunctionName -Name $item
            }
            if (-Not $cmds.Contains($item)) {
                Write-Verbose "found command $item"
                $cmds.Add($item)
            }
        }

        #get aliases
        $aliases = ($astTokens).where({ ($_.TokenFlags -contains 'CommandName') -AND ($_.kind -eq 'identifier') })
        if ($aliases) {
            Write-Verbose "Detected $($aliases.count) aliases"
            $filteredAliases = $aliases.Text.toLower() | Select-Object -Unique
            foreach ($alias in $filteredAliases) {
                Try {
                    $a = Get-Alias -Name $alias -ErrorAction stop
                    if (-Not $cmds.Contains($a.Definition)) {
                        Write-Verbose "Adding resolved command $($a.definition)"
                        $cmds.Add($a.Definition)
                    }
                    if (-Not $aliasList.Contains($alias)) {
                        Write-Verbose "Saving alias ($alias)"
                        $aliasList.Add($alias)
                    }
                }
                Catch {
                    Write-Verbose "Could not resolve potential alias $alias"
                    $Unresolved.Add($alias)
                }
            }
        }
        #separate PowerShell cmdlets from external commands
        $cmdlets, $external = $cmds.Where({ $_ -notmatch ".*(exe|bat|sh|cmd|vbs|wsf)$" }, "Split")
        [PSCustomObject]@{
            PSTypeName            = "PSFunctionProfile"
            Name                  = $Name
            FunctionAlias         = $fa.where({ $_.type -eq 'alias' }).PositionalArguments.Value
            SupportsShouldProcess = $fa.where({ $_.type -eq 'cmdletbinding' }).NamedArguments.ArgumentName -contains "SupportsShouldProcess"
            ParameterSets         = $attrib.argument.value | Select-Object -Unique
            DynamicParameters     = (Get-Content $path | Select-String '^(\s+)?DynamicParam\s+{') ?  $True : $False
            RequiredVersion       = $req.RequiredPSVersion
            RequiredModules       = $req.RequiredModules
            RequiresElevation     = $req.IsElevationRequired
            Commands              = $cmdlets | Sort-Object
            ExternalCommands      = $external | Sort-Object
            DotNet                = $dotnet
            Aliases               = $aliasList
            Unresolved            = $Unresolved
            Path                  = $Path
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($MyInvocation.MyCommand)"

    } #end

} #close Get-FunctionProfile