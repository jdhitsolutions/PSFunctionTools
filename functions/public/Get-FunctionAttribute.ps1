Function Get-FunctionAttribute {
    [cmdletbinding()]
    [alias("gfa")]
    [OutputType("PSFunctionAttribute", "String")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Specify the name of the PowerShell function."
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [Parameter(
            Mandatory,
            HelpMessage = "Specify the path to the .ps1 or .psm1 file."
        )]
        [ValidateScript( {
            If (Test-Path $_ ) {
                $True
            }
            Else {
                Throw "Can't validate that $_ exists. Please verify and try again."
                $False
            }
        })]
        [ValidateScript( {
            If ($_ -match "\.ps(m)?1$") {
                $True
            }
            Else {
                Throw "The path must be to a .ps1 or .psm1 file."
                $False
            }
            })]
        [string]$Path,
        [Parameter(HelpMessage = "Display the attribute block as a string.")]
        [switch]$ToString
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        New-Variable astTokens -Force
        New-Variable astErr -Force
        $Path = Convert-Path -Path $path
        $Name = Format-FunctionName $Name
    } #begin
    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing function $name from $Path "
        $AST = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$astTokens, [ref]$astErr)

        #parse out functions using the AST
        $function = $ast.Find( {
                $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] -AND
                $args[0].name -eq $Name }, $true)

        if ($function) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Found function $($function.name)"
            $pb = $function.find( { $args[0] -is [System.Management.Automation.Language.ParamBlockAst] }, $True)

            if ($pb.attributes.extent.text -AND $ToString) {
                $pb.attributes.extent.text
            }
            elseif ($pb.attributes.extent.text) {
                foreach ($item in $pb.attributes) {
                    [pscustomobject]@{
                        PSTypeName          = "PSFunctionAttribute"
                        Type                = $item.TypeName.name
                        NamedArguments      = $item.NamedArguments
                        PositionalArguments = $item.PositionalArguments
                        String              = $item.extent.text
                        Function            = $Name
                        Path                = $Path
                    }
                }
            }
            else {
                Write-Warning "No defined function attributes detected."
            }
        }
        else {
            Write-Warning "Failed to find a function called $name in $path."
        }
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Get-FunctionAttribute