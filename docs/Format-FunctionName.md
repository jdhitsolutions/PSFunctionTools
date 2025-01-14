---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version: https://bit.ly/3nnpKYy
schema: 2.0.0
---

# Format-FunctionName

## SYNOPSIS

Format a function name to proper case.

## SYNTAX

```yaml
Format-FunctionName [-Name] <String> [-NounCapitals <Int32>] [<CommonParameters>]
```

## DESCRIPTION

Format-FunctionName is intended to be used as a helper function in your scripting automation. This is a simple function that will format a verb-noun function name into proper case. It will take an input such as test-data and format it as Test-Data. It will not format as Pascal case, although you can capitalize N number of characters in the Noun portion of your command name. The command also will not verify that the verb component is acceptable. Use Test-FunctionName for that process.

## EXAMPLES

### Example 1

```powershell
PS C:\> Format-FunctionName test-data
Test-Data
```

Format the lower-case command name to proper case.

### Example 2

```powershell
PS C:\> Format-FunctionName try-pssystem
Try-Pssystem
```

The command does not validate the verb nor can it produce a Pascal Case result like Try-PsSystem.

### Example 3

```powershell
PS C:\> Format-FunctionName test-pssystem -NounCapitals 3
Test-PSSystem
```

Even though you can't format in Pascal case, you can specify how many characters of the Noun portion of your command that you want to capitalize.

## PARAMETERS

### -Name

What is the name of your function? It should follow the Verb-Noun naming convention. Although the verb will not be validated.

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

### -NounCapitals

Capitalize the first N number of characters in the Noun.

```yaml
Type: Int32
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

### System.String

## NOTES

## RELATED LINKS

[Test-FunctionName](Test-FunctionName.md)
