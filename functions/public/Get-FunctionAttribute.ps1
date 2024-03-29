Function Get-FunctionAttribute {
    [cmdletbinding()]
    [alias("gfa")]
    [OutputType("PSFunctionAttribute", "String")]
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
        [ValidateScript( {
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
        [Parameter(HelpMessage = "Display the attribute block as a string.")]
        [switch]$ToString
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
    } #begin
    Process {
        $Path = Convert-Path -Path $path
        $Name = Format-FunctionName $Name
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing function $name from $Path "
        $AST = _getAST $path
        #parse out functions using the AST
        $function = $ast.Find( {
                $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] -AND
                $args[0].name -eq $Name }, $true)

        if ($function) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Found function $($function.name)"
            $pb = $function.find( { $args[0] -is [System.Management.Automation.Language.ParamBlockAst] }, $True)

            if ($pb.attributes.extent.text -AND $ToString) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Showing as string"
                $pb.attributes.extent.text
            }
            elseif ($pb.attributes.extent.text) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing extent text"
                foreach ($item in $pb.attributes) {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($item.typename.name)"
                    [PSCustomObject]@{
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
                Write-Warning "No defined function attributes detected for $name in $path."
            }
        }
        else {
            Write-Warning "Failed to find a function called $name in $path."
        }
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Get-FunctionAttribute