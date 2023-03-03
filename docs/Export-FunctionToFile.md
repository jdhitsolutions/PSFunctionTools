---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version:
schema: 2.0.0
---

# Export-FunctionToFile

## SYNOPSIS

Export a PowerShell function to a file.

## SYNTAX

```yaml
Export-FunctionToFile [-Name] <String> [-Path <String>] [-PassThru] [-Requires <String[]>] [-WhatIf] [-Confirm]  [<CommonParameters>]
```

## DESCRIPTION

You can use this command to export a function which is loaded into your PowerShell session. You might need to do this when you create an ad-hoc function and want to save it to a file. This command will take the content of the function and export it to a ps1 file. The function name will be used for the file name. Although, characters like the colon will be stripped to create a filesystem-compatibale filename.

## EXAMPLES

### Example 1

```powershell
PS C:\> Export-FunctionToFile -Name prompt -Path c:\scripts
```

Get the prompt function from your PowerShell session and export it to C:\Scripts. The filename will be prompt.ps1

### Example 2

```powershell
PS C:\> Export-FunctionToFile -Name New-FileLink -Path c:\work -Requires "#requires -version 5.1","#requires -RunAsAdministrator" -PassThru

    Directory: C:\work

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           2/28/2022  1:28 PM           1987 New-FileLink.ps1
```

Export the New-FileLInk function to a file and specify runtime requirements.

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

### -Name

Specify the name of a function loaded in your PowerShell session.

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

### -Path

Specify the location for the new file. The function name will be used for the file name, stripping off any characters that invalid filename characters.

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

### -Requires

Specify #Requires statements, including the #

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

### System.String

## OUTPUTS

### None

### System.IO.FileInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Export-FunctionFromFile](Export-FunctionFromFile.md)
