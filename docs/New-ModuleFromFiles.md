---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version:
schema: 2.0.0
---

# New-ModuleFromFiles

## SYNOPSIS

Create a PowerShell module from a set of files.

## SYNTAX

```yaml
New-ModuleFromFiles [-NewModuleName] <String> [-ParentPath] <String> -Description <String> -Files <String[]> -Layout <String> [-FunctionPath <String>] [-WhatIf] [-Confirm] [-CreateHelp] [-MarkdownPath <String>] [-InitializeGit] [<CommonParameters>]
```

## DESCRIPTION

New-ModuleFromFiles is an experimental function. It is not guaranteed to run without error and may change significantly between module versions. The command is designed to process a collection of PowerShell script files which contain PowerShell functions. Each function will be exported to an individual file to a location you specify.

The function relies on a module layout file to scaffold the module directory.

If you have the Platyps module installed, you can also choose to create help documentation. If you have git installed, you can initialize the module as a git repository. This process will also checkout a new branch.

## EXAMPLES

### Example 1

```powershell
PS C:\> $splat = @{
    Description   = "Demo exported module"
    Files         = "c:\scripts\pstools.psm1","c:\scripts\servertools.ps1"
    Layout        = "c:\scripts\ModuleLayout.json"
    NewModuleName = "PSTools"
    ParentPath    = "c:\scripts"
    CreateHelp    = $True
    FunctionPath  = "functions\public"
    InitializeGit = $true
}
PS C:\> New-ModuleFromFiles @splat
```

Using the parameter values defined in the hashtable, create a new module called PSTools using the functions from pstools.psm1 and servertools.ps1. Only functions with valid verb-noun names will be exported. This example will also create initial help documentation and initialize a git repository.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateHelp

Create help documentation using the Platyps module. This is a dynamic parameter that only exists if the Platyps module is detected.

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

### -Description

Enter a module description.

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

### -Files

Enter the paths to PowerShell script files with functions to export. These should be files with a .ps1 or .psm1 extension. Only functions with valid verb-noun names will be exported. Each function be exported to an individual file.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FunctionPath

Specify the relative path for the exported functions. This should be in your module layout.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: functions
Accept pipeline input: False
Accept wildcard characters: False
```

### -InitializeGit

Initialize the new module as a git repository. This is a dynamic parameter that only exists if git is detected. This process will also checkout a new branch.

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

### -Layout

Specify the module layout json file created with Export-ModuleLayout.

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

### -MarkdownPath

Specify the path for the markdown help files. This is a dynamic parameter that only exists if the Platyps module is detected. You can specify location that is in your module layout.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: docs
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewModuleName

What is the name of the new module?

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

### -ParentPath

What is the parent path for the new module? It must already exist.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

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

### System.Object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Export-ModuleLayout](Export-ModuleLayout.md)

[Import-ModuleLayout](Import-ModuleLayout.md)

[Export-FunctionFromFile](Export-FunctionFromFile.md)
