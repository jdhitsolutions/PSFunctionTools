---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version: https://bit.ly/3nlhmJd
schema: 2.0.0
---

# Export-ModuleLayout

## SYNOPSIS

Export a model module layout.

## SYNTAX

```yaml
Export-ModuleLayout -SourcePath <String> [-Version <String>]
[-FilePath <String>] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION

Use Export-ModuleLayout to export a model module directory structure to a json file. You can use Import-ModuleLayout to recreate the layout from the json file. The export process will include not only directories, but also text files like a readme or license file.

## EXAMPLES

### Example 1

```powershell
PS C:\> Export-ModuleLayout c:\work\sample -FilePath c:\work\layout.json -Verbose
VERBOSE: Starting Export-ModuleLayout
VERBOSE: Exporting directory structure from c:\work\sample
VERBOSE: Processing .github
VERBOSE: Processing .vscode
VERBOSE: Processing docs
VERBOSE: Processing en-us
VERBOSE: Processing formats
VERBOSE: Processing functions
VERBOSE: Processing icons
VERBOSE: Processing images
VERBOSE: Processing samples
VERBOSE: Processing tests
VERBOSE: Processing types
VERBOSE: Processing changelog.md
VERBOSE: Processing License.txt
VERBOSE: Processing README.md
VERBOSE: Processing scratch-changelog.md
VERBOSE: Processing .vscode\tasks.json
VERBOSE: Processing formats\readme.txt
VERBOSE: Processing functions\private
VERBOSE: Processing functions\public
VERBOSE: Processing functions\private\readme.txt
VERBOSE: Processing functions\public\readme.txt
VERBOSE: Processing tests\readme.txt
VERBOSE: Processing types\readme.txt
VERBOSE: Exporting module layout to c:\work\layout.json.
PS C:\>
```

Export the directory layout defined under C:\Work\sample to a c:\work\layout.json.

## PARAMETERS

### -FilePath

Specify the name of the Json file to store the result.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: modulelayout.json
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru

Show the file result.

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

### -SourcePath

Specify the model module path.

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

### -Version

Define a version number for this layout.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1.0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

### System.IO.FileInfo

## NOTES

## RELATED LINKS

[Import-ModuleLayout](Import-ModuleLayout.md)

[Get-ModuleLayout](Get-ModuleLayout.md)
