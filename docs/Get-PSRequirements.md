---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version:
schema: 2.0.0
---

# Get-PSRequirements

## SYNOPSIS

List PowerShell command requirements.

## SYNTAX

```yaml
Get-PSRequirements [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION

As part of your scripting automation, you may want to capture requirements defined in a script file such as '# requires -version 5.1'. Get-PSRequirements will process a PowerShell script file for these type of requirements.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSRequirements -Path C:\scripts\SQLBackup.psm1

Path                  : C:\scripts\SQLBackup.psm1
RequiredApplicationId :
RequiredPSVersion     : 5.1
RequiredPSEditions    : {}
RequiredModules       : {}
RequiresPSSnapIns     : {}
RequiredAssemblies    : {}
IsElevationRequired   : True
```

If you run this command in the PowerShell console or VS Code, and elevation is required, the 'True' value will be displayed in green.

## PARAMETERS

### -Path

The path to your PowerShell script file. It must be a .ps1 or .psm1 file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### PSScriptRequirements

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
