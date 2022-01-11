---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version:
schema: 2.0.0
---

# New-CommentHelp

## SYNOPSIS

Create comment based help.

## SYNTAX

### ast (Default)

```yaml
New-CommentHelp [-ParamBlock] <ParamBlockAst> [-Synopsis <String>] [-Description <String>] [<CommonParameters>]
```

### template

```yaml
New-CommentHelp [-Synopsis <String>] [-Description <String>] [-TemplateOnly] [<CommonParameters>]
```

## DESCRIPTION

You can use this command in your scripting automation to generate a comment-based help block for a function. The function will use the parameter block which you can get with Get-ParameterBlock to define help parameters. If your parameter has a HelpMessage defined, the value will be used in the parameter description.

You can also specify a synopsis and/or description. Otherwise, you can edit the placeholders later.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-Parameterblock  -path c:\scripts\SimpleFunction.ps1 -name Get-FolderData | New-CommentHelp -Synopsis "Get folder details"
<#
    .Synopsis
      Get folder details
    .Description
      <long description>
    .Parameter Path
      Specify the folder to analyze
    .Parameter Cutoff
      <enter a parameter description>
    .Parameter Filter
      <enter a parameter description>
    .Example
      PS C:\>
      <output and explanation>
    .Inputs
      <Inputs to this function (if any)>
    .Outputs
      <Output from this function (if any)>
    .Notes
      <General notes>
    .Link
      <enter a link reference>
#>
```

This example is getting the parameter block for the specified function and creating comment-base help. The Path parameter has a HelpMessage defined so that value is used in the help. You would need to fill in your own descriptions for the other parameters.

### EXAMPLE 2

```powershell
PS C:\> New-CommentHelp -Synopsis "Get something" -Description "This is the beginning" -TemplateOnly
<#
  .Synopsis
    Get something
  .Description
    This is the beginning
  .Example
    PS C:\>
    <output and explanation>
  .Inputs
    <Inputs to this function (if any)>
  .Outputs
    <Output from this function (if any)>
  .Notes
    <General notes>
  .Link
    <enter a link reference>
#>
```

Create a comment help block template without relying on a parameter block.

## PARAMETERS

### -ParamBlock

A parameter block AST object. Use Get-ParameterBlock.

```yaml
Type: ParamBlockAst
Parameter Sets: ast
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Description

Provide a longer description. You can always edit this later.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: "<long description>"
Accept pipeline input: False
Accept wildcard characters: False
```

### -Synopsis

Provide a short description. You can always edit this later.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: "<short description>"
Accept pipeline input: False
Accept wildcard characters: False
```

### -TemplateOnly

Insert a standard help template without any parameter definitions.

```yaml
Type: SwitchParameter
Parameter Sets: template
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

### ParamBlockAST

## OUTPUTS

### string

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-ParameterBlock](Get-ParameterBlock.md)
