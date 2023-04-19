---
external help file: PSFunctionTools-help.xml
Module Name: PSFunctionTools
online version: https://bit.ly/3I3PdhR
schema: 2.0.0
---

# Get-FunctionName

## SYNOPSIS

Identify the names of PowerShell functions in a PowerShell script file.

## SYNTAX

```yaml
Get-FunctionName [-Path] <String> [-All] [-Detailed] [<CommonParameters>]
```

## DESCRIPTION

When exporting functions from files, you may only want to export specific functions. Which you can do if you know the name. Use Get-FunctionName to identify the names of functions. The default behavior is to get names of functions that follow the Verb-Noun naming convention.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-FunctionName C:\scripts\MyInternetTools.psm1
Get-MyWhoIs
Get-GeoIP
Get-MyPublicIP
Get-MyWeather
Get-WeatherByProxy
Get-WeatherLocation
Get-QOTD
Get-ZipInfo
Get-RSSFeed
Open-URL
```

Get the names of all standard functions in the specified file.

### Example 2

```powershell
PS C:\> Get-FunctionName C:\scripts\MyInternetTools.psm1 -All
_log
_parseOutput
Get-MyWhoIs
Get-GeoIP
Get-MyPublicIP
Get-MyWeather
Get-WeatherByProxy
Get-WeatherLocation
Get-QOTD
Get-ZipInfo
Get-RSSFeed
Open-URL
```

Get the names of all functions in the specified file regardless of naming convention.

### Example 3

```powershell
PS C:\>  Get-FunctionName C:\scripts\Convert-FunctionToFile.ps1 -Detailed

   Path: C:\scripts\Convert-FunctionToFile.ps1

Name
----
Export-FunctionFromFile
Get-FunctionAlias
Get-FunctionName
Test-FunctionName
```

Get detailed output from the command which includes the path to source file.

## PARAMETERS

### -All

List all detected function names regardless of naming convention.

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
Aliases: pspath

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Detailed

Write a rich detailed object to the pipeline.

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

### string

### PSFunctionName

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-FunctionAlias](Get-FunctionAlias.md)

[Get-FunctionAttribute](Get-FunctionAttribute.md)

[Get-ParameterBlock](Get-Parameterblock.md)

[Get-FunctionProfile](Get-FunctionProfile.md)
