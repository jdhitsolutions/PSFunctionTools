Function Format-FunctionName {
    [cmdletbinding()]
    Param (
        [parameter(Position = 0, HelpMessage = "What is the name of your function? It should follow the Verb-Noun naming convention.")]
        [ValidateScript({
        if ($_ -match "^\w+-\w+$") {
            $true
        }
        else {
            Throw "Your function name should have a Verb-Noun naming convention"
            $False
        }
    })]
    [string]$Name
    )

    $split = $name -split "-"
    "{0}{1}-{2}{3}" -f $split[0][0].ToString().ToUpper(), $split[0].Substring(1).Tolower(),$split[1][0].ToString().ToUpper(), $split[1].Substring(1).ToLower()

}
