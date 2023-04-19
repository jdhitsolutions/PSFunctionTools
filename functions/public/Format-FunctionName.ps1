Function Format-FunctionName {
    [cmdletbinding()]
    [alias("ffn")]
    [OutputType("String")]
    Param (
        [parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            HelpMessage = "What is the name of your function? It should follow the Verb-Noun naming convention."
        )]
        [ValidateScript( {
            if ($_ -match "^\w+-\w+$") {
                $true
            }
            else {
                Throw "Your function name should have a Verb-Noun naming convention"
                $False
            }
            })]
        [string]$Name,
        [Parameter(HelpMessage = "Capitalize the first N number of characters in the Noun.")]
        [ValidateScript({$_ -gt 0})]
        [int]$NounCapitals
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN] Starting $($MyInvocation.MyCommand)"
    } #begin
    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing $name"
        $split = $name -split "-"
        $verb = $split[0]
        $noun = $split[1]
        #"{0}{1}-{2}{3}" -f $split[0][0].ToString().ToUpper(), $split[0].Substring(1).ToLower(), $split[1][0].ToString().ToUpper(), $split[1].Substring(1).ToLower()
        If ($NounCapitals -gt 0) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Using custom noun formatting"
            "{0}{1}-{2}{3}" -f $verb[0].ToString().ToUpper(), $verb.Substring(1).ToLower(), $n.Substring(0,$NounCapitals).ToUpper(), $noun.Substring($NounCapitals).ToLower()
        }
        Else {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Using standard formatting"
            "{0}{1}-{2}{3}" -f $verb[0].ToString().ToUpper(), $verb.Substring(1).ToLower(), $noun[0].ToString().ToUpper(), $noun.Substring(1).ToLower()
        }

    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}
