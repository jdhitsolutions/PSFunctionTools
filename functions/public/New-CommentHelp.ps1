Function New-CommentHelp {
    [cmdletbinding(DefaultParameterSetName="ast")]
    [alias('nch')]
    [OutputType("string")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            HelpMessage = "Specify ParamBlockAST object.",
            ParameterSetName = "ast"
        )]
        [System.Management.Automation.Language.ParamBlockAst]$ParamBlock,
        [Parameter(HelpMessage = "Provide a short description. You can always edit this later.")]
        [string]$Synopsis = "<short description>",
        [Parameter(HelpMessage = "Provide a longer description. You can always edit this later.")]
        [string]$Description = "<long description>",
        [Parameter(HelpMessage = "Insert help template",ParameterSetName = "template")]
        [switch]$TemplateOnly
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        Write-Verbose "Defining help opening"
        $h = [System.Collections.Generic.List[string]]::new()
        $h.Add("<#")
        $h.Add("  .Synopsis")
        $h.Add("    $Synopsis")
        $h.Add("  .Description")
        $h.Add("    $Description")
    }

    Process {
        if ($PSCmdlet.ParameterSetName -eq 'ast') {
            Write-Verbose "Processing a paramblock AST object"
            foreach ($p in $ParamBlock.Parameters) {
                $paramName = $p.name.variablepath.userpath
                Write-Verbose "Adding parameter help for $paramname"
                $h.Add("  .Parameter $paramName")
                $paramHelp = $p.Attributes.namedArguments.where({ $_.argumentname -eq 'helpmessage' })
                if ($paramHelp) {
                    $h.Add("    $($paramHelp.argument.value)")
                }
                else {
                    $h.Add("    <enter a parameter description>")
                }
            }
        } #if paramblock

    } #process
    End {
        Write-Verbose "Adding closing help content"
        $h.Add("  .Example")
        $h.Add("    PS C:\> $Name")
        $h.Add("    <output and explanation>")
        $h.Add("  .Inputs")
        $h.Add("    <Inputs to this function (if any)>")
        $h.Add("  .Outputs")
        $h.Add("    <Output from this function (if any)>")
        $h.Add("  .Notes")
        $h.Add("    <General notes>")
        $h.Add("  .Link")
        $h.Add("    <enter a link reference>")
        $h.Add("#>")
        $h
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #end
}
