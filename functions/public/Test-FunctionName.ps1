Function Test-FunctionName {
    [CmdletBinding()]
    [alias('tfn')]
    [OutputType("boolean", "string")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            HelpMessage = "Specify a function name."
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [Parameter(HelpMessage = "Get a boolean test result.")]
        [switch]$Quiet
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $VerbList = (Get-Verb).Verb
    } #begin
    Process {
        Write-Verbose "Validating function name $Name"
        #Function name must first follow Verb-Noun pattern
        if ($Name -match "^\w+-\w+$") {
            #validate the standard verb
            $verb = ($Name -split "-")[0]
            Write-Verbose "Validating detected verb $verb"
            if ($VerbList -contains $verb ) {
                if ($Quiet) {
                    $True
                }
                else {
                    $Name
                }
            }
            else {
                Write-Verbose "$name contains a non-standard verb."
                if ($Quiet) {
                    $false
                }
            }
        } #if name matches word-word
        elseif ($quiet) {
            $False
        }
    } #process
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #end
}
