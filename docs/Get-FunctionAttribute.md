---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version: https://bit.ly/3KhHkY7
schema: 2.0.0
---

# Get-FunctionAttribute

## SYNOPSIS

Get function attributes like cmdletbinding.

## SYNTAX

```yaml
Get-FunctionAttribute [-Name] <String> -Path <String> [-ToString] [<CommonParameters>]
```

## DESCRIPTION

This command can be used to get function attributes such as cmdletbinding or alias settings.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-FunctionAttribute -path c:\scripts\Get-ParameterBlock.ps1 -Name Get-ParameterBlock


Type                : cmdletbinding
NamedArguments      : {}
PositionalArguments : {}
String              : [cmdletbinding()]
Function            : Get-ParameterBlock
Path                : C:\scripts\Get-ParameterBlock.ps1

Type                : alias
NamedArguments      : {}
PositionalArguments : {"gpb"}
String              : [alias("gpb")]
Function            : Get-ParameterBlock
Path                : C:\scripts\Get-ParameterBlock.ps1

Type                : OutputType
NamedArguments      : {}
PositionalArguments : {"ParamBlockAst", "String"}
String              : [OutputType("ParamBlockAst","String")]
Function            : Get-ParameterBlock
Path                : C:\scripts\PSFunctionTools\functions\public\Get-ParameterB
                      lock.ps1
```

Get detailed function attributes.

### Example 2

```powershell
PS C:\> Get-FunctionName C:\scripts\New-OneDriveLink.ps1 -Detailed | Get-FunctionAttribute -ToString
[cmdletbinding(SupportsShouldProcess)]
[alias("odl")]
```

Get function attributes as a string.

## PARAMETERS

### -Name

Specify the name of the PowerShell function.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path

Specify the path to the .ps1 or .psm1 file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ToString

Display the attribute block as a string.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSFunctionAttribute

### String

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-ParameterBlock](Get-ParameterBlock.md)

[Get-FunctionAlias](Get-FunctionAlias.md)
