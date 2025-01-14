---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version:
schema: 2.0.0
---

# Open-PSFunctionToolsHelp

## SYNOPSIS

Open the PSFunctionTools help document.

## SYNTAX

```yaml
Open-PSFunctionToolsHelp [-AsMarkdown] [<CommonParameters>]
```

## DESCRIPTION

Use this command to open the PDF help document for the PSFunctionTools module with the associated application for PDF files. As an alternative you can view the documentation as a markdown document.

## EXAMPLES

### Example 1

```powershell
PS C:\> Open-PSFunctionToolsHelp
```

The file should open in the default application for PDF files.

### Example 2

```powershell
PS C:\> Open-PSFunctionToolsHelp -AsMarkdown
```

View the help file a markdown document.

## PARAMETERS

### -AsMarkdown

Open the help file as markdown.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: md

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

### None

### System.String

## NOTES

## RELATED LINKS

[Get-PSFunctionTools](Get-PSFunctionTools.md)

[PSFunctionTools GitHub Repository:](https://github.com/jdhitsolutions/PSFunctionTools)
