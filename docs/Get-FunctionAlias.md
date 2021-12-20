---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version:
schema: 2.0.0
---

# Get-FunctionAlias

## SYNOPSIS

Get a defined function alias.

## SYNTAX

```yaml
Get-FunctionAlias [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION

Get-FunctionAlias is tool you can use in your scripting automation. It will extract function names and aliases from a PowerShell script file. The source must be a .ps1 or .psm1 file. The command will only idenfity aliases defined as part of the function using code like [alias('foo')].

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-FunctionAlias -Path C:\scripts\SQLBackup.psm1

Name                Alias
----                 -----
Backup-SQLDatabase  Backup-SQL
Restore-SQLdatabase rsql
```

Get functions and aliases from the specified file.

## PARAMETERS

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSFunctionAlias

## NOTES

## RELATED LINKS

[Get-FunctionName](Get-FunctionName.md)
