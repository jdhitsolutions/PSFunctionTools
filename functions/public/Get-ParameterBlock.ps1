Function Get-ParameterBlock {
    [cmdletbinding()]
    [alias("gpb")]
    [OutputType("ParamBlockAst","String")]
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
                }
                Else {
                    Throw "Can't validate that $_ exists. Please verify and try again."
                    $False
                }
            })]
            [ValidateScript({
                If ($_ -match "\.ps(m)?1$") {
                    $True
                }
                Else {
                    Throw "The path must be to a .ps1 or .psm1 file."
                    $False
                }
            })]
        [string]$Path,
        [Parameter(HelpMessage = "Display the parameter block as a string.")]
        [switch]$ToString
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        New-Variable astTokens -Force
        New-Variable astErr -Force
    } #begin
    Process {
        $Path = Convert-Path -Path $path
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing function $(Format-FunctionName $name) from $Path "
        $AST = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$astTokens, [ref]$astErr)

        #parse out functions using the AST
        $function = $ast.Find({
            $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] -AND
            $args[0].name -eq $Name}, $true)

        if ($function) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Found function $(Format-FunctionName $function.name)"
            $pb = $function.find({$args[0] -is [System.Management.Automation.Language.ParamBlockAst]},$True)

            if ($pb.parameters.extent.text -AND $ToString) {
                $pb.parameters.extent.text
            }
            elseif ($pb.parameters.extent.text) {
                $pb
            }
            else {
                Write-Warning "No defined parameters detected."
            }
        }
        else {
            Write-Warning "Failed to find a function called $name in $path."
        }
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Get-ParameterBlock