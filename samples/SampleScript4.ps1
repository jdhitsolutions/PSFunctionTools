#requires -version 4.0
#requires -RunAsAdministrator

#this is a sample script

Param (
    [Parameter(Position = 0, HelpMessage = "How many numbers do you want?")]
    [ValidateRange(1, 100)]
    [Int]$Count = 1
)
DynamicParam {
    #this is a sample dynamic parameter
    If ($True) {

        $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

        # Defining parameter attributes
        $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
        $attributes = New-Object System.Management.Automation.ParameterAttribute
        $attributes.ParameterSetName = '__AllParameterSets'
        $attributeCollection.Add($attributes)

        # Defining the runtime parameter
        $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('Demo', [String], $attributeCollection)
        $paramDictionary.Add('Demo', $dynParam1)

        return $paramDictionary
    } # end if
} #end DynamicParam

Begin {
    Write-Host "this is a sample script that doesn't do anything but write a random number" -ForegroundColor Yellow
}
Process {
    #get numbers
    1..$count | ForEach-Object {
        Get-Random -Minimum 1 -Maximum 1000
    }
}
End {
    Write-Host "Ending script" -ForegroundColor yellow
}
#eof
