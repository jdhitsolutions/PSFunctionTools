Function New-CommentHelp {
    [cmdletbinding()]
    [OutputType("string")]
    Param([System.Management.Automation.Language.ParamBlockAst]$ParamBlock)

    $h = [System.Collections.Generic.List[string]]::new()
    $h.Add("<#")
    $h.Add("`t.Synopsis")
    $h.Add("`t  <short description>")
    $h.add("`t.Description")
    $h.add("`t  <long description>")

    foreach ($p in $ParamBlock.Parameters) {
        $paramName = $p.name.variablepath.userpath
        $h.Add("`t.Parameter $paramName")
        $paramHelp = $p.Attributes.namedArguments.where({ $_.argumentname -eq 'helpmessage' })
        if ($paramHelp) {
            $h.add("`t  $($paramHelp.argument.value)")
        }
        else {
            $h.Add("`t  <enter a parameter description>")
        }
    }
    $h.add("`t.Example")
    $h.Add("`t  PS C:\> $Name")
    $h.Add("`t  <output and explanation>")
    $h.Add("`t.Link")
    $h.Add("`t  <enter a link reference>")
    $h.Add("#>")

    $h
}
