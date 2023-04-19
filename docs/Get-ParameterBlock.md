---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version: https://bit.ly/3HTXULi
schema: 2.0.0
---

# Get-ParameterBlock

## SYNOPSIS

Get a function's parameter block.

## SYNTAX

```yaml
Get-ParameterBlock [-Name] <String> -Path <String> [-ToString] [<CommonParameters>]
```

## DESCRIPTION

This command is designed to use the PowerShell AST and retrieve a function's parameter block. You might use this to build comment-based help.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ParameterBlock -path c:\scripts\SimpleFunction.ps1 -name Get-FolderData

Attributes Parameters                Extent
---------- ----------                ------
{}         {$Path, $Cutoff, $Filter} Param (…
```

Get the AST parameter block object.

### Example 2

```powershell
PS C:\> Get-ParameterBlock  -path c:\scripts\SimpleFunction.ps1 -name Get-FolderData -ToString
[parameter(HelpMessage = "Specify the folder to analyze")]
[string]$Path="."
[datetime]$Cutoff
[string]$Filter="*.*"
```

Get the parameter block for the given function as a string.

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
Accept pipeline input: False
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
Accept pipeline input: False
Accept wildcard characters: False
```

### -ToString

Display the parameter block as a string.

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

### ParamBlockAst

### String

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[New-CommentHelp](New-CommentHelp.md)

[Get-FunctionAlias](Get-FunctionAlias.md)

[Get-FunctionAttribute](Get-FunctionAttribute.md)
