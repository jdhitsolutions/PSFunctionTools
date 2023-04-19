---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version: https://bit.ly/3FnnVkP
schema: 2.0.0
---

# Get-ModuleLayout

## SYNOPSIS

Get information about a module layout file.

## SYNTAX

```yaml
Get-ModuleLayout [-Path] <String> [-AsTree] [<CommonParameters>]
```

## DESCRIPTION

This command will provide information about a module layout folder which was created using Export-ModuleLayout. The default output is custom object. You can elect to view the layout as a tree. This parameter requires the tree command-line utility which should be available on Windows systems by default. On non-Windows platforms, you may need to install the utility.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ModuleLayout C:\scripts\ModuleLayout.json

   Path: C:\scripts\ModuleLayout.json

Created             CreatedBy    Version Folders Files
-------             ---------    ------- ------- -----
12/16/2021 11:42 AM THINKP1\Jeff   1.0        13    10
```

The default output is a custom object.

### Example 2

```powershell
PS C:\> Get-ModuleLayout C:\scripts\ModuleLayout.json | Format-List

Path           : C:\scripts\ModuleLayout.json
Created        : 12/16/2021 11:42 AM
CreatedBy      : THINKP1\Jeff
SourcePath     : C:\work\sample
LayoutVersion  : 1.0
SourceComputer : THINKP1
Folders        : {.github, .vscode, docs, en-us…}
Files          : {changelog.md, License.txt, README.md, scratch-changelog.md…}
```

The default output is a rich object.

### Example 3

```powershell
PS C:\> Get-ModuleLayout C:\scripts\simplelayout.json -AsTree
C:\<PathTo>\<MYMODULE>
|   changelog.md
|   README.md
|
+---.vscode
+---docs
+---en-us
+---formats
|       readme.txt
|
+---functions
|
+---tests
|       readme.txt
|
\---types
        readme.txt
```

Display the layout as a tree.

## PARAMETERS

### -AsTree

Show the module layout as a tree. This will create a temporary folder structure in %TEMP% or its equivalent on non-Windows platforms.This parameter relies on tree command line utility which should be installed by default on Windows systems. You may need to install a tree utility on non-Windows platforms.

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

### -Path

Specify the path to the module layout json file.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### ModuleLayout

### String

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Export-ModuleLayout](Export-ModuleLayout.md)
