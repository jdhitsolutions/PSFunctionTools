Function New-CommentHelp {
    [cmdletbinding()]
    [alias('nch')]
    [OutputType("string")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            HelpMessage = "Specify ParamBlockAST object."
        )]
        [System.Management.Automation.Language.ParamBlockAst]$ParamBlock,
        [Parameter(HelpMessage = "Provide a short description. You can always edit this later.")]
        [string]$Synopsis = "<short description>",
        [Parameter(HelpMessage = "Provide a longer description. You can always edit this later.")]
        [string]$Description = "<long description>"
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        Write-Verbose "Defining help opening"
        $h = [System.Collections.Generic.List[string]]::new()
        $h.Add("<#")
        $h.Add("`t.Synopsis")
        $h.Add("`t  $Synopsis")
        $h.add("`t.Description")
        $h.add("`t  $Description")
    }

    Process {
        Write-Verbose "Processing a paramblock AST object"
        foreach ($p in $ParamBlock.Parameters) {
            $paramName = $p.name.variablepath.userpath
            Write-Verbose "Adding parameter help for $paramname"
            $h.Add("`t.Parameter $paramName")
            $paramHelp = $p.Attributes.namedArguments.where({ $_.argumentname -eq 'helpmessage' })
            if ($paramHelp) {
                $h.add("`t  $($paramHelp.argument.value)")
            }
            else {
                $h.Add("`t  <enter a parameter description>")
            }
        }
    } #process
    End {
        Write-Verbose "Adding closing help content"
        $h.add("`t.Example")
        $h.Add("`t  PS C:\> $Name")
        $h.Add("`t  <output and explanation>")
        $h.Add("`t.Inputs")
        $h.add("`t  <Inputs to this function (if any)>")
        $h.Add("`t.Outputs")
        $h.add("`t  <Output from this function (if any)>")
        $h.Add("`t.Notes")
        $h.Add("`t  <General notes>")
        $h.Add("`t.Link")
        $h.Add("`t  <enter a link reference>")
        $h.Add("#>")
        $h
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #end
}
