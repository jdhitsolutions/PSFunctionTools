
#helper functions

Function _mkHelp {
    [cmdletbinding()]
    Param(
        #the path to the psd1 file
        [string]$ModulePath,
        #where to put the md files
        [string]$Markdownpath,
        #where to put the xml output
        [string]$OutputPath
    )

    Write-Verbose "Invoking Import-Module on $modulepath"
    Import-Module -Name $ModulePath -Scope global
    $ModuleName = (Get-Item $ModulePath).BaseName
    Get-Command -Module $NewModuleName -OutVariable modcmds | Out-String | Write-Verbose
    Write-Verbose "Invoking New-MarkdownHelp for module $modulename"
    Try {
        New-MarkdownHelp -Module $modulename -OutputFolder $Markdownpath -Force -ErrorAction Stop
        Write-Verbose "Invoking New-Externalhelp to $outputPath"
        New-ExternalHelp -Path $Markdownpath -OutputPath $OutputPath -Force -ErrorAction Stop
    }
    Catch {
        Write-Warning "Failed to generate help content. $($_.exception.message)"
    }
}

Function _getAST {
    [cmdletbinding()]
    Param([string]$Path)

    New-Variable astTokens -Force -WhatIf:$false
    New-Variable astErr -Force -WhatIf:$false
    Write-Verbose "Parsing file $path for AST tokens"
    $AST = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$astTokens, [ref]$astErr)
    $AST
}
