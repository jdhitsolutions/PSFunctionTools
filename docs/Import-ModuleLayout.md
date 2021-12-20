---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version:
schema: 2.0.0
---

# Import-ModuleLayout

## SYNOPSIS

Create a module structure from a layout file.

## SYNTAX

```yaml
Import-ModuleLayout [-Name] <String> [-ParentPath <String>] -Layout <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use Import-ModuleLayout to recreate a module structure from a json file created with Export-ModuleLayout. Importing the json file will recreate the folders and files.

## EXAMPLES

### Example 1

```powershell
PS C:\> Import-ModuleLayout -Name PSDemo -ParentPath D:\scripts -Layout C:\work\layout.json

    Directory: C:\scripts\PSDemo

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----          12/16/2021  9:45 AM                types
d----          12/16/2021  9:45 AM                .github
d----          12/16/2021  9:45 AM                .vscode
d----          12/16/2021  9:45 AM                docs
...
    Directory: D:\scripts\PSDemo\functions

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----          12/16/2021  9:45 AM                public
d----          12/16/2021  9:45 AM                private

    Directory: D:\scripts\PSDemo\functions\public

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          12/16/2021  9:49 AM            276 readme.txt
...
```

Create the directory structure from C:\work\layout.json under a new path of D:\scripts\PSDemo. The parent path, D:\scripts, must already exist.

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

### -Layout

Specify the path to the module layout json file.

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

### -Name

What is the name of your new module?

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

What is the parent path?
The default is the current location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: .
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

[Export-ModuleLayout](Export-ModuleLayout.md)
