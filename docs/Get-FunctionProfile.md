---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version: https://bit.ly/325JY1E
schema: 2.0.0
---

# Get-FunctionProfile

## SYNOPSIS

Get a technical summary of a PowerShell function.

## SYNTAX

```yaml
Get-FunctionProfile [-Name] <String> -Path <String> [<CommonParameters>]
```

## DESCRIPTION

Get-FunctionProfile is designed to give you a technical summary of a PowerShell function. You might use this to preview what commands a function might execute or if it supports -Whatif. The function might be something someone else wrote, or perhaps you want to double-check your code. The command writes an object to the pipeline with properties that indicate the following:

+ Name : The function name

+ FunctionAlias : Defined aliases for the function

+ SupportsShouldProcess : Does the function support -WhatIf

+ ParameterSets : A list of any detected parameter sets

+ DynamicParameters : Does the function have dynamic parameters

+ RequiredVersion : Show a required PowerShell version

+ RequiredModules : List any required modules

+ RequiresElevation : Must the command be run as administrator

+ Commands : A list of detected PowerShell commands

+ ExternalCommands : A list of external commands that PowerShell can resolve

+ DotNet : A list of .NET detected classes and methods

+ Aliases : A list of detected PowerShell aliases

+ Unresolved : A list of unrecognized items detected as commands

+ Path : The path to the script file

Note that the analysis may not be 100% complete. For example, it is difficult to distinguish between the alias 'foreach' and the 'foreach' enumerator.

## EXAMPLES

### Example 1

```powershell
PS C:\...\samples> Get-FunctionProfile -path .\SampleScript5.ps1 -name Get-Result

Name                  : Get-Result
FunctionAlias         : grx
SupportsShouldProcess : False
ParameterSets         :
DynamicParameters     : False
RequiredVersion       : 5.1
RequiredModules       : {}
RequiresElevation     : True
Commands              : {Get-CimInstance, Get-Random, Join-Path, New-Timespan…}
ExternalCommands      : {c:\scripts\cleanup.bat, notepad.exe}
DotNet                : {[system.datetime]::now,
                        [system.environment]::getenvironmentvariable("temp")}
Aliases               : {gcim, tee}
Unresolved            : {w}
Path                  : C:\Scripts\PSFunctionTools\samples\SampleScript5.ps1
```

A sample analysis. Commands should be PowerShell cmdlets, including resolved aliases. Detected command aliases will also be retrieved. Unresolved commands might be undefined aliases or some other command that PowerShell could not resolve.

### Example 2

```powershell
PS C:\Scripts\mymodule\functions> dir *.ps1 | Get-FunctionName -Detailed | Get-FunctionProfile | Where-Object aliases
```

Profile all function files in a module looking for those that still have command aliases defined.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### PSFunctionProfile

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-ParameterBlock](Get-ParameterBlock.md)

[Get-FunctionAlias](Get-FunctionAlias.md)

[Get-FunctionAttribute](Get-FunctionAttribute.md)
