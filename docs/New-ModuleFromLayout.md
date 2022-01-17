---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version: https://bit.ly/3foUOCN
schema: 2.0.0
---

# New-ModuleFromLayout

## SYNOPSIS

Creat a new module based on a layout.

## SYNTAX

```yaml
New-ModuleFromLayout [-NewModuleName] <String> [-ParentPath] <String> -Description <String> -Layout <String> [-FunctionPath <String>] [-WhatIf] [-Confirm] [-InitializeGit] [<CommonParameters>]
```

## DESCRIPTION

This command is very similar to New-ModuleFromFiles. That function builds a module structure from existing files. This function creates a new module but without defining any commands. New-ModuleFromLayout will still create a module structure based on a layout and it will still create module files. Specifically,the module manifest and root module files.

If git.exe is detected, you can use the InitializeGit dynamic parameter to initialize the module as a git repository.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-ModuleFromLayout -NewModuleName PSDataResource -ParentPath c:\scripts -Description "A class-based DSC resource to do something." -Layout .c:\scripts\DSCModuleLayout.json
```

Create a new and empty module under C:\Scripts\PSDataResource using the layout file c:\scripts\dscmodulelayout.json.

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

### -FunctionPath

Specify the relative path where your functions will be created.

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

Initialize the new module as a git repository. This is a dynamic parameter that only exists if git.exe is detected.

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

What is the parent path for the new module?
It must already exist.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: none
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

### System.IO.FileInfo

### System.IO.DirectoryInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[New-ModuleFromFiles](New-ModuleFromFiles.md)

[Import-ModuleLayout](Import-ModuleLayout.md)
