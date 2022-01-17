---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version: https://bit.ly/3GopWyo
schema: 2.0.0
---

# Export-FunctionFromFile

## SYNOPSIS

Export a PowerShell function from a script file.

## SYNTAX

### All (Default)

```yaml
Export-FunctionFromFile [-Path] <String> [-OutputPath <String>] [-Passthru]
[-Remove] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### byName

```yaml
Export-FunctionFromFile [-Path] <String> [-OutputPath <String>]
[-Name <String[]>] [-Passthru] [-Remove] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### all

```yaml
Export-FunctionFromFile [-Path] <String> [-OutputPath <String>] [-All] [-Remove] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

You should use Export-FunctionFromFile when you want to export PowerShell functions defined in in a single script file, placing each function in its own file. You might want to do this to build or restructure a PowerShell module.

You can export all functions from a file or specific functions. The default behavior is to only export functions that follow a standard verb-noun naming convention. The source must be a .ps1 or .psm1 script file.

If you run this command in the PowerShell ISE or the VS Code integrated PowerShell Terminal, you can use the dynamic parameter Remove to delete the function from the source file.

## EXAMPLES

### Example 1

```powershell
PS C:\> Export-FunctionFromFile C:\scripts\MyInternetTools.psm1 -Name get-zipinfo -OutputPath c:\scripts\psinternettools\functions
```

Export the Get-ZipInfo function from C:\scripts\MyInternetTools.psm1 to its own file. The original file remains unchanged.

### Example 2

```powershell
PS C:\> Export-FunctionFromFile C:\scripts\MyInternetTools.psm1 -OutputPath c:\scripts\psinternettools\functions
```

Export all functions that follow the verb-noun naming convention to separate files under C:\Scripts\PSInternetTools\Functions.

## PARAMETERS

### -All

Export all detected functions regardless of name.

```yaml
Type: SwitchParameter
Parameter Sets: all
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -Name

Specify a function by name.

```yaml
Type: String[]
Parameter Sets: byName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath

Specify the output path. The default is the same directory as the .ps1 file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passthru

Pass the output file to the pipeline.

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

Specify the .ps1 or .psm1 file with defined functions.

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

### -Remove

This is a dynamic parameter that is only available if you are running this command in the PowerShell ISE of the VS Code integrated PowerShell terminal. The function will be deleted from the source file after it has been exported.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

### System.IO.FileInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-FunctionName](Get-FunctionName.md)
