---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version: https://bit.ly/3Fgi4gY
schema: 2.0.0
---

# Convert-ScriptToFunction

## SYNOPSIS

Convert a script file to a PowerShell function.

## SYNTAX

```yaml
Convert-ScriptToFunction [-Path] <String> [-Name] <String> [-Alias <String[]>] [<CommonParameters>]
```

## DESCRIPTION

This command takes the body of a script file and wraps it in a function declaration. The command will insert missing elements like cmdletbinding() and comment-based help. You will most likely need to edit and clean up the
result in your scripting editor.

If you run this command in the PowerShell ISE or the VS Code PowerShell
integrated terminal, you can use the dynamic parameter ToEditor to open a
new file with with the output. You can edit and save the file manually.

It is assumed that your script file is complete and without syntax errors.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Convert-ScriptToFunction c:\scripts\Daily.ps1 -name Invoke-DailyTask | Set-Clipboard
```

Convert Daily.ps1 to a function called Invoke-DailyTask and copy the
results to the Windows clipboard. You can then paste the results into
scripting editor.

### EXAMPLE 2

```powershell
PS C:\> Convert-ScriptToFunction c:\scripts\systemreport.ps1 -name New-SystemReport | Out-File c:\scripts\New-SystemReport.ps1
```

Convert the SystemReport.ps1 script file to a function called
New-SystemReport and save the results to a file.

### EXAMPLE 3

```powershell
PS C:\> Convert-ScriptToFunction c:\scripts\systemreport.ps1 -name New-System -alias nsr | Tee-Object -variable f
```

Convert the script to a function called New-System and tee the output to $f.
This will also define an function alias of nsr.

## PARAMETERS

### -Path

Enter the path to your PowerShell script file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name

What is the name of your new function? It should have a standard Verb-Noun name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Alias

Define an optional alias for your new function.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
