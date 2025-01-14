---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version: https://bit.ly/3Kipd3Y
schema: 2.0.0
---

# Get-PSFunctionTools

## SYNOPSIS

Get a summary of PSFunctionTools commands.

## SYNTAX

```yaml
Get-PSFunctionTools [<CommonParameters>]
```

## DESCRIPTION

This command will give you a brief summary of all commands, including aliases, in the PSFunctionTools module.

## EXAMPLES

### Example 1

```text
PS C:\> Get-PSFunctionTools

   Module: PSFunctionTools [v1.2.0]

Name                       Alias    Synopsis
----                       -----    --------
Convert-ScriptToFunction    csf     Convert a script file to a PowerShell funct…
Export-FunctionFromFile     eff     Export a PowerShell function from a script …
Export-FunctionToFile       etf     Export a PowerShell function to a file.
Export-ModuleLayout         eml     Export a model module layout.
Format-FunctionName         ffn     Format a function name to proper case.
Get-FunctionAlias        {ga, gfal} Get a defined function alias.
Get-FunctionAttribute       gfa     Get function attributes like cmdletbinding.
Get-FunctionName            gfn     Identify the names of PowerShell functions …
Get-FunctionProfile         gfp     Get a technical summary of a PowerShell fun…
Get-ModuleLayout                    Get information about a module layout file.
Get-ParameterBlock          gpb     Get a function's parameter block.
Get-PSFunctionTools                 Get a summary of PSFunctionTools commands.
Get-PSRequirements                  List PowerShell command requirements.
Import-ModuleLayout         iml     Create a module structure from a layout fil…
New-CommentHelp             nch     Create comment based help.
New-ModuleFromFiles                 Create a PowerShell module from a set of fi…
New-ModuleFromLayout                Create a new module based on a layout.
Test-FunctionName           tfn     Test the validity of a PowerShell function …
```

The default output is formatted as a table.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSFunctionTool

## NOTES

## RELATED LINKS

[Get-Command]()
