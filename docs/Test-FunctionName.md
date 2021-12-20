---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version:
schema: 2.0.0
---

# Test-FunctionName

## SYNOPSIS

Test the validity of a PowerShell function name.

## SYNTAX

```yaml
Test-FunctionName [-Name] <String> [-Quiet] [<CommonParameters>]
```

## DESCRIPTION

PowerShell function names should follow naming convention of Verb-Noun. The verb should be a standard verb that you see with Get-Verb. Use this command in your scripting automation to validate a PowerShell function name.

If the name passes validation it will be written to the pipeline. Or you can use the -Quiet parameter to return a traditional boolean result.

## EXAMPLES

### Example 1

```powershell
PS C:\> Test-FunctionName Test-Widget
Test-Widget
```

Because the name passes validation, it is written to the pipeline.

### Example 2

```powershell
PS C:\> Test-FunctionName -Name stop-foo | Format-FunctionName
Stop-Foo
```

Test the function name and format the result.

### Example 3

```powershell
PS C:\> Test-FunctionName kill-system -Quiet
False
```

Test with boolean result.

## PARAMETERS

### -Name

Specify a function name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Quiet

Get a boolean test result.

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

### System.String

## OUTPUTS

### boolean

### string

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Format-FunctionName](Format-FunctionName.md)
