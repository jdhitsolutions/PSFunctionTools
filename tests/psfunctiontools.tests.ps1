#requires -version 7.4

#tests for Pester 5.x

BeforeDiscovery {
    $script:ModuleName = (Get-Item $PSScriptRoot\..\ -OutVariable p).Name
    if (Get-Module -Name $script:ModuleName) {
        #Write-Host "Removing module $ModuleName" -ForegroundColor Cyan
        Remove-Module -Name $script:ModuleName
    }
    $script:psd1 = Join-Path $p.FullName -ChildPath "$script:ModuleName.psd1"

    #Write-Host "Importing module $psd1" -ForegroundColor Cyan
    Import-Module $psd1 -Force
}

Describe "$($script:ModuleName)" {
    BeforeAll {
        $dir = Get-ChildItem $PSScriptRoot\.. -Directory
    }
    Context Layout {
        It "$($script:psd1) is a valid manifest" {
            { Test-ModuleManifest $psd1 } | Should -Not -Throw
        } -Tag manifest
        It 'Has a <_> folder' -ForEach @('docs', 'tests', 'functions', 'formats', 'images', 'en-us') {
            $dir.name | Should -Contain $_
        } -Tag layout
        It 'Has a <_> file' -ForEach @('changelog.md', 'license.txt', 'readme.md', "..\en-us\$ModuleName-help.xml") {
            $filepath = Join-Path $PSScriptRoot..\ -ChildPath $_
            $filePath | Should -Exist
        } -Tag Layout
    } -Tag structure
    It 'Has 20 exported functions' {
        #Write-Host "Measuring exported function in ModuleName" -ForegroundColor cyan
        Get-Command -Module $ModuleName -CommandType function | Should -HaveCount 20
    } -Tag demo

    It 'Has a markdown help file for <name>' -ForEach @(
        (Get-Command -Module PSFunctionTools -CommandType function).ForEach({ @{Name = $_.name } })
    ) {
        $mdPath = Join-Path -Path "$PSScriptRoot\..\docs" -ChildPath "$($_.name).md"
        $mdPath | Should -Exist
    } -Tag help, acceptance

} -Tag module, Acceptance

Describe Convert-ScriptToFunction {
    BeforeAll {
        'function get-foo { 1 }' | Out-File 'TestDrive:\test.ps1'
        Mock Test-Path { return $False } -ParameterFilter { $Path -eq 'q:\foo\bar\a.ps1' }
        Mock Test-Path { return $True } -ParameterFilter { $Path -match 'c.txt|b.ps1' }
    } #BeforeAll

    It 'Should have help documentation' {
        (Get-Help Convert-ScriptToFunction).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name Convert-ScriptToFunction).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It "Should have a defined alias of 'csf'" {
        (Get-Alias 'csf').ResolvedCommand.name | Should -Be 'Convert-ScriptToFunction'
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(
        @{Name = 'Path' }, @{Name = 'Name' }
    ) {
        Get-Command Convert-ScriptToFunction | Should -HaveParameter $Name -Mandatory
    } -Tag acceptance
    It 'Should run without error' {
        { Convert-ScriptToFunction -Path 'TestDrive:\test.ps1' -Name get-foo | Out-File TestDrive:\get-foo.ps1 } | Should -Not -Throw
        Get-Item TestDrive:\get-foo.ps1 | Should -Exist
    } -Tag acceptance
    #only run this test under VS Code
    if ($host.name -eq 'Visual Studio Code Host') {
        It 'Should have a dynamic parameter of ToEditor when run in VS Code' {
            $params = (Get-Command Convert-ScriptToFunction).parameters
            $params['ToEditor'].IsDynamic | Should -BeTrue
        } -Tag unit, vscode
    }

    It 'Should fail on an invalid path' {
        Try {
            Convert-ScriptToFunction -Path q:\foo\bar\a.ps1 -Name get-foo -ErrorAction Stop
        }
        Catch {
            $_.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
        }
    } -Tag acceptance
    It 'Should fail on an invalid filename.' {
        Try {
            Convert-ScriptToFunction -Path q:\foo\bar\c.txt -Name get-foo -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
    } -Tag acceptance
    It 'Should fail on an invalid function name' {
        Try {
            Convert-ScriptToFunction -Path 'TestDrive:test.ps1' -Name 'barfoo' -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Name'"
    } -Tag acceptance

} -Tag function

Describe Export-FunctionFromFile {
    BeforeAll {
        $f = @'
Function Get-Foo {
    [cmdletbinding()]
    Param([string]$Name)

    $name.ToUpper()}
'@
        $f | Out-File 'TestDrive:\test.ps1'
        Mock Test-Path { return $False } -ParameterFilter { $Path -eq 'q:\foo\bar\a.ps1' }
        Mock Test-Path { return $True } -ParameterFilter { $Path -match 'c.txt|b.ps1' }

    } #BeforeAll
    It 'Should have help documentation' {
        (Get-Help Export-FunctionFromFile).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name Export-FunctionFromFile).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(
        @{Name = 'Path' }
    ) {
        Get-Command Export-FunctionFromFile | Should -HaveParameter $Name -Mandatory
    } -Tag acceptance

    #only run this test under VS Code
    if ($host.name -eq 'Visual Studio Code Host') {
        It 'Should have a dynamic parameter of Remove when run in VS Code' {
            $params = (Get-Command Export-FunctionFromFile).parameters
            $params['Remove'].IsDynamic | Should -BeTrue
        } -Tag unit
    }
    It 'Should run without error' {
        { Export-FunctionFromFile -Path TestDrive:\test.ps1 -All } | Should -Not -Throw
        Get-Item TestDrive:\get-foo.ps1 | Should -Exist
    } -Tag acceptance
    It 'Should fail on an invalid path' {
        Try {
            Export-FunctionFromFile -Path q:\foo\bar\a.ps1 -All -ErrorAction Stop
        }
        Catch {
            $_.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
        }
    } -Tag acceptance
    It 'Should fail on an invalid filename.' {
        Try {
            Export-FunctionFromFile -Path q:\foo\bar\c.txt -All -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
    } -Tag acceptance

} -Tag function

Describe Export-ModuleLayout {
    BeforeAll {
        Mock Test-Path { return $False } -ParameterFilter { $Path -eq 'q:\foo' }
    } #BeforeAll
    It 'Should have help documentation' {
        (Get-Help Export-ModuleLayout).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name Export-ModuleLayout).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It "Should have a defined alias of 'eml'" {
        (Get-Alias 'eml').ResolvedCommand.name | Should -Be 'Export-ModuleLayout'
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(
        @{Name = 'SourcePath' }
    ) {
        Get-Command Export-ModuleLayout | Should -HaveParameter $Name -Mandatory
    } -Tag unit
    It 'Should run without error' {
        #mock and set mandatory parameters as needed
        { Export-ModuleLayout -SourcePath TestDrive:\ } | Should -Not -Throw
        Get-Item TestDrive:modulelayout.json | Should -Exist
    } -Tag acceptance
    It 'Should fail on an invalid path' {
        Try {
            Export-ModuleLayout -SourcePath q:\foo -all -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'SourcePath'"
    } -Tag acceptance
    It 'Should fail on an invalid filepath' {
        Try {
            Export-ModuleLayout -SourcePath TestDrive:\ -FilePath foo.txt -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'filepath'"
    } -Tag acceptance

} -Tag function

Describe Format-FunctionName {

    It 'Should have help documentation' {
        (Get-Help Format-FunctionName).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name Format-FunctionName).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(
        @{Name = 'Name' }
    ) {
        Get-Command Format-FunctionName | Should -HaveParameter $Name -Mandatory
    } -Tag unit
    It 'Should run without error' {
        { Format-FunctionName get-foo } | Should -Not -Throw
        Format-FunctionName get-foo | Should -BeExactly 'Get-Foo'
    } -Tag acceptance

    It 'Should fail on a non-standard function name' {
        { Format-FunctionName Foobar } | Should -Throw
    } -Tag acceptance

} -Tag function

Describe Get-FunctionAlias {
    BeforeAll {
        $f = @'
Function Get-Foo {
    [cmdletbinding()]
    [alias('gf')]
    Param([string]$Name)

    $name.ToUpper()
}
'@
        $f | Out-File 'TestDrive:\test.ps1'
        Mock Test-Path { return $False } -ParameterFilter { $Path -eq 'q:\foo\bar\a.ps1' }
        Mock Test-Path { return $True } -ParameterFilter { $Path -match 'c.txt|b.ps1' }

    } #BeforeAll
    It 'Should have help documentation' {
        (Get-Help Get-FunctionAlias).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name Get-FunctionAlias).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(
        @{Name = 'Path' }
    ) {
        Get-Command Get-FunctionAlias | Should -HaveParameter $Name -Mandatory
    } -Tag unit
    It 'Should have a defined alias of <alias>' -ForEach @(
        @{Alias = 'gfal'; Name = 'Get-FunctionAlias' },
        @{Alias = 'ga'; Name = 'Get-FunctionAlias' }
    ) {
        (Get-Alias $alias).ResolvedCommand.name | Should -Be $name
    } -Tag acceptance
    It 'Should fail on an invalid path' {
        Try {
            Get-FunctionAlias -Path q:\foo\bar\a.ps1 -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
    } -Tag acceptance
    It 'Should fail on an invalid filename.' {
        Try {
            Get-FunctionAlias -Path q:\foo\bar\c.txt -Name get-foo -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
    } -Tag acceptance
    It 'Should run without error' {
        $a = Get-FunctionAlias -Path TestDrive:test.ps1
        $a.Name | Should -Be 'Get-Foo'
        $a.alias | Should -Contain 'gf'
        $a.PSObject.TypeNames[0] | Should -Be 'PSFunctionAlias'
    } -Tag acceptance

} -Tag function

Describe Get-FunctionAttribute {
    BeforeAll {
        $f = @'
Function Get-Foo {
[cmdletbinding()]
[alias('gf')]
Param(
[Parameter(Position = 0)]
[string]$Name
    )

$name.ToUpper()
}
'@
        $f | Out-File 'TestDrive:\test.ps1'
        Mock Test-Path { return $False } -ParameterFilter { $Path -eq 'q:\foo\bar\a.ps1' }
        Mock Test-Path { return $True } -ParameterFilter { $Path -match 'c.txt|b.ps1' }
    } #BeforeAll
    It 'Should have help documentation' {
        (Get-Help Get-FunctionAttribute).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name Get-FunctionAttribute).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(
        @{Name = 'Path' }, @{Name = 'Name' }
    ) {
        Get-Command Get-FunctionAttribute | Should -HaveParameter $Name -Mandatory
    } -Tag unit

    It 'Should have a defined alias of <alias>' -ForEach @(
        @{Alias = 'gfa'; Name = 'Get-FunctionAttribute' }
    ) {
        (Get-Alias $alias).ResolvedCommand.name | Should -Be $name
    } -Tag acceptance
    It 'Should fail on an invalid path' {
        Try {
            Get-FunctionAttribute -Path q:\foo\bar\a.ps1 -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
    } -Tag acceptance
    It 'Should fail on an invalid filename.' {
        Try {
            Get-FunctionAttribute -Path q:\foo\bar\c.txt -Name get-foo -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
    } -Tag acceptance
    It 'Should run without error' {
        $rt = Get-FunctionAttribute -Path TestDrive:\test.ps1 -Name get-foo
        $rt.Count | Should -Be 2
        $rt[0].type | Should -Be 'cmdletbinding'
        $rt[1].type | Should -Be 'alias'
    } -Tag acceptance

} -Tag function

Describe Get-FunctionName {
    BeforeAll {
        $f = @'
Function Get-Foo {
[cmdletbinding()]
[alias('gf')]
Param(
[Parameter(Position = 0)]
[string]$Name
    )

$name.ToUpper()
}
function private {1}
'@
        $f | Out-File 'TestDrive:\test.ps1'
        Mock Test-Path { return $False } -ParameterFilter { $Path -eq 'q:\foo\bar\a.ps1' }
        Mock Test-Path { return $True } -ParameterFilter { $Path -match 'c.txt|b.ps1' }
    } #BeforeAll

    It 'Should have help documentation' {
        (Get-Help Get-FunctionName).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name Get-FunctionName).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(
        @{Name = 'Path' }, @{Name = 'Name' }
    ) {
        Get-Command Get-FunctionAttribute | Should -HaveParameter $Name -Mandatory
    } -Tag unit
    It 'Should fail on an invalid path' {
        Try {
            Get-FunctionName -Path q:\foo\bar\a.ps1 -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
    } -Tag acceptance
    It 'Should fail on an invalid filename.' {
        Try {
            Get-FunctionName -Path q:\foo\bar\c.txt -Name get-foo -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
    } -Tag acceptance
    It 'Should run without error' {
        $r = Get-FunctionName -Path TestDrive:\test.ps1
        $r | Should -Be 'Get-Foo'
    } -Tag acceptance

    It 'Should write a detailed object to the pipeline' {
        $r = Get-FunctionName -Path TestDrive:\test.ps1 -Detailed
        $r.name | Should -Be 'Get-Foo'
        $r.path | Should -Be $(Convert-Path TestDrive:\test.ps1)
    } -Tag acceptance
    It 'Should detect all functions' {
        $r = Get-FunctionName -Path TestDrive:\test.ps1 -All
        $r | Should -HaveCount 2
        $r[1] | Should -Be 'private'
    } -Tag acceptance

} -Tag function

Describe Get-ModuleLayout {
    BeforeAll {
        $f = @'
Function Get-Foo {
[cmdletbinding()]
[alias('gf')]
Param(
[Parameter(Position = 0)]
[string]$Name
    )

$name.ToUpper()
}
'@
        $f | Out-File 'TestDrive:\test.ps1'

        $json = @'
[
    {
        "ItemType":  "ModuleLayoutMetadata",
        "Created":  "12/16/2024 11:42 AM",
        "CreatedBy":  "DESK11\\Jeff",
        "Computername":  "DESK11",
        "Source":  "C:\\work\\sample",
        "Version":  "1.1"
    },
    {
        "ItemType":  "directory",
        "Path":  ".vscode"
    },
    {
        "ItemType":  "directory",
        "Path":  "docs"
    },
    {
        "ItemType":  "directory",
        "Path":  "en-us"
    },
    {
        "ItemType":  "directory",
        "Path":  "formats"
    },
    {
        "ItemType":  "directory",
        "Path":  "functions"
    },
    {
        "ItemType":  "directory",
        "Path":  "tests"
    },
    {
        "ItemType":  "directory",
        "Path":  "types"
    },
    {
        "ItemType":  "file",
        "Path":  "changelog.md",
        "Content":  "# Changelog\r\n"
    },
    {
        "ItemType":  "file",
        "Path":  "README.md",
        "Content":  "# README\r\n"
    },
    {
        "ItemType":  "file",
        "Path":  "formats\\readme.txt",
        "Content":  "These are formatting files for the module. This file can be deleted.\r\n"
    },
    {
        "ItemType":  "directory",
        "Path":  "functions\\private"
    },
    {
        "ItemType":  "directory",
        "Path":  "functions\\public"
    },
    {
        "ItemType":  "file",
        "Path":  "functions\\private\\readme.txt",
        "Content":  "This folder contains private module functions. This file can be deleted.\r\n"
    },
    {
        "ItemType":  "file",
        "Path":  "functions\\public\\readme.txt",
        "Content":  "This folder contains public module functions. This file can be deleted.\r\n"
    },
    {
        "ItemType":  "file",
        "Path":  "tests\\readme.txt",
        "Content":  "Module Pester tests for the module. This file can be deleted.\r\n"
    },
    {
        "ItemType":  "file",
        "Path":  "types\\readme.txt",
        "Content":  "These are custom type extension files for the module. This file can be deleted.\r\n"
    }
]
'@
        $json | Out-File TestDrive:\test.json
    } #BeforeAll

    It 'Should have help documentation' {
        (Get-Help Get-ModuleLayout).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name Get-ModuleLayout).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(
        @{Name = 'Path' }
    ) {
        Get-Command Get-FunctionAttribute | Should -HaveParameter $Name -Mandatory
    } -Tag unit
    It 'Should fail on an invalid path' {
        Try {
            Get-ModuleLayout -Path q:\foo\bar.json -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
    } -Tag acceptance
    It 'Should fail on an invalid filename' {
        Try {
            Get-ModuleLayout -Path TestDrive:\test.ps1 ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
    } -Tag acceptance

    It 'Should run without error' {
        #mock and set mandatory parameters as needed
        $r = Get-ModuleLayout -Path TestDrive:\test.json
        $r.folders | Should -HaveCount 9
        $r.Files | Should -HaveCount 7
        $r.sourceComputer | Should -Be 'DESK11'
        $r.LayoutVersion | Should -Be '1.1'
    } -Tag acceptance

    It 'Should display a tree' {
        $r = Get-ModuleLayout -Path TestDrive:test.json -AsTree
        $r | Should -HaveCount 23
        $r | Out-String | Should -Match '\+|\|'
    } -Tag acceptance

} -Tag function

Describe Get-ParameterBlock {
    BeforeAll {
        $f = @'
Function Get-Foo {
[cmdletbinding()]
[alias('gf')]
Param(
[Parameter(Position = 0)]
[string]$Name
    )

$name.ToUpper()
}
'@
        $f | Out-File TestDrive:\test.ps1
        'foo' | Out-File TestDrive:test.txt
    }
    It 'Should have help documentation' {
        (Get-Help Get-ParameterBlock).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name Get-ParameterBlock).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(
        @{Name = 'Path' }, @{Name = 'Name' }
    ) {
        Get-Command Get-ParameterBlock | Should -HaveParameter $Name -Mandatory
    } -Tag unit
    It 'Should fail on an invalid path' {
        Try {
            Get-ParameterBlock -Path q:\foo\bar.json -Name get-foo -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
    } -Tag acceptance
    It 'Should fail on an invalid filename' {
        Try {
            Get-ParameterBlock -Path TestDrive:\test.txt -Name get-foo -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
    } -Tag acceptance
    It 'Should run without error' {
        $pb = Get-ParameterBlock -Path TestDrive:\test.ps1 -Name Get-Foo
        $pb.GetType().Name | Should -Be 'ParamBlockAst'
        $pb.parameters.count | Should -Be 1
        $pb.attributes.count | Should -Be 2
    } -Tag acceptance

} -Tag function

Describe Get-PSRequirements {
    BeforeAll {
        $cmd = 'Get-PSRequirements'
        $f = @'
#requires -version 5.1
#requires -RunAsAdministrator

Get-Date
}
'@
        $f | Out-File TestDrive:\test.ps1
        'foo' | Out-File TestDrive:test.txt
    }
    It 'Should have help documentation' {
        (Get-Help $cmd).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name $cmd).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(
        @{Name = 'Path' }
    ) {
        Get-Command $cmd | Should -HaveParameter $Name -Mandatory
    } -Tag unit
    It 'Should fail on an invalid path' {
        Try {
            &$cmd -path q:\foo\bar.ps1 -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
    } -Tag acceptance
    It 'Should fail on an invalid filename' {
        Try {
            &$cmd -path TestDrive:\test.txt -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
    } -Tag acceptance

    It 'Should run without error' {
        $r = &$cmd -path TestDrive:\test.ps1
        $r.GetType().Name | Should -Be ScriptRequirements
        $r.RequiredPSVersion | Should -Be '5.1'
        $r.IsElevationRequired | Should -Be $True
    } -Tag acceptance

} -Tag function

Describe Import-ModuleLayout {
    BeforeAll {
        $cmd = 'Import-ModuleLayout'

        New-Item TestDrive:\test.txt -ItemType File
        @'
    [
        {
            "ItemType":  "ModuleLayoutMetadata",
            "Created":  "12/16/2024 11:42 AM",
            "CreatedBy":  "DESK11\\Jeff",
            "Computername":  "DESK11",
            "Source":  "C:\\work\\sample",
            "Version":  "1.1"
        },
        {
            "ItemType":  "directory",
            "Path":  "docs"
        },
        {
            "ItemType":  "directory",
            "Path":  "en-us"
        },
        {
            "ItemType":  "directory",
            "Path":  "functions"
        },
        {
            "ItemType":  "file",
            "Path":  "changelog.md",
            "Content":  "# Changelog\r\n"
        },
        {
            "ItemType":  "file",
            "Path":  "README.md",
            "Content":  "# README\r\n"
        }
    ]
'@ | Out-File TestDrive:\layout.json
    }
    It 'Should have help documentation' {
        (Get-Help $cmd).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name $cmd).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(
        @{Name = 'Name' }, @{Name = 'Layout' }
    ) {
        Get-Command $cmd | Should -HaveParameter $Name -Mandatory
    } -Tag unit
    It 'Should support ShouldProcess' {
        Get-Command $cmd | Should -HaveParameter WhatIf
    } -Tag acceptance
    It 'Should fail on an invalid path' {
        Try {
            & $cmd -Name foo -ParentPath q:\foo\ -layout TestDrive:\layout.json -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'ParentPath'"
    } -Tag acceptance
    It 'Should fail on an invalid filename' {
        Try {
            & $cmd -Name foo -ParentPath TestDrive:\ -layout TestDrive:\test.txt -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Layout'"
    } -Tag acceptance

    It 'Should run without error' {
        { & $cmd -Name Foo -ParentPath TestDrive:\ -layout TestDrive:\layout.json } | Should -Not -Throw
        Get-Item TestDrive:\foo\readme.md | Should -Exist
        Get-ChildItem TestDrive:\foo -Directory | Should -HaveCount 3
        Get-ChildItem TestDrive:\foo -File -Recurse | Should -HaveCount 2
    } -Tag acceptance

    #insert additional command-specific tests

} -Tag function

Describe New-CommentHelp {
    BeforeAll {
        $cmd = 'New-CommentHelp'
        @'
#requires -version 3.0

Function Get-FolderData {
[cmdletbinding()]
Param (
[parameter(HelpMessage = "Specify the folder to analyze")]
[string]$Path=".",
[datetime]$Cutoff,
[string]$Filter="*.*"
)

#the path might be a . or a PSDrive shortcut so get the complete path
Get-Item -Path $path
}
'@ | Out-File TestDrive:\sample.ps1
    }

    It 'Should have help documentation' {
        (Get-Help $cmd).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name $cmd).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(
        @{Name = 'ParamBlock' }
    ) {
        Get-Command $cmd | Should -HaveParameter $Name -Mandatory
    } -Tag unit
    It "Should have a defined alias of 'nch'" {
        (Get-Alias 'nch').ResolvedCommand.name | Should -Be $cmd
    } -Tag acceptance
    It 'Should take a parameterblock as input' {
        Get-ParameterBlock -Path TestDrive:\sample.ps1 -Name 'Get-FolderData' |
        New-CommentHelp | Out-File TestDrive:\help.txt
        Get-Item TestDrive:\help.txt | Should -Exist
    } -Tag acceptance
    It 'Should run without error' {
        { & $cmd -synopsis 'Foo' -description 'Foo' -templateOnly } | Should -Not -Throw
    } -Tag acceptance

} -Tag function

Describe New-ModuleFromFiles {
    #this is an experimental command so the Pester test is limited
    BeforeAll {
        $cmd = 'New-ModuleFromFiles'
        Mock Get-Command { return $True } -ParameterFilter { $name -match 'NewMarkdownHelp|git' }
        @'
[
    {
        "ItemType":  "ModuleLayoutMetadata",
        "Created":  "12/16/2024 11:42 AM",
        "CreatedBy":  "DESK11\\Jeff",
        "Computername":  "DESK11",
        "Source":  "C:\\work\\sample",
        "Version":  "1.1"
    },
    {
        "ItemType":  "directory",
        "Path":  "docs"
    },
    {
        "ItemType":  "directory",
        "Path":  "en-us"
    },
    {
        "ItemType":  "directory",
        "Path":  "functions"
    },
    {
        "ItemType":  "file",
        "Path":  "changelog.md",
        "Content":  "# Changelog\r\n"
    },
    {
        "ItemType":  "file",
        "Path":  "README.md",
        "Content":  "# README\r\n"
    }
]
'@ | Out-File 'TestDrive:\layout.json'
        @'
#requires -version 3.0

Function Get-FolderData {
    [cmdletbinding()]
    [alias('gfd')]
    Param (
    [parameter(HelpMessage = "Specify the folder to analyze")]
    [string]$Path=".",
    [datetime]$Cutoff,
    [string]$Filter="*.*"
)

$path = Convert-Path $path
Get-Item -Path $path
}
'@ | Out-File TestDrive:\sample.ps1

        New-Item TestDrive:\test.txt -ItemType file
        #dir TestDrive: | Out-String | Write-Host
        #. TestDrive:\sample.ps1
        #Get-Folderdata | out-string | write-host
    }
    It 'Should have help documentation' {
        (Get-Help $cmd).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name $cmd).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(
        @{Name = 'NewModuleName' }, @{Name = 'ParentPath' }, @{Name = 'Description' },
        @{Name = 'Files' }, @{Name = 'Layout' }
    ) {
        Get-Command $cmd | Should -HaveParameter $Name -Mandatory
    } -Tag unit
    It 'Contains a dynamic parameter of <name>' -ForEach @( @{Name = 'CreateHelp' },
        @{Name = 'MarkdownPath' }, @{Name = 'InitializeGit' }) {
        Get-Command $cmd | Should -HaveParameter $Name
    } -Tag unit

    It 'Should fail on an invalid path' {
        Try {
            $splat = @{
                ErrorAction   = 'Stop'
                NewModuleName = 'PSFoo'
                ParentPath    = 'Q:\Foo\Bar'
                Description   = 'Testing Foo'
                Layout        = 'TestDrive:\layout.json'
                Files         = 'TestDrive:\sample.ps1'
            }
            & $cmd @splat
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'ParentPath'"
    } -Tag acceptance

    It 'Should fail on an invalid layout filepath' {
        Try {
            $splat = @{
                ErrorAction   = 'Stop'
                NewModuleName = 'PSFoo'
                ParentPath    = 'TestDrive:\'
                Description   = 'Testing Foo'
                Layout        = 'TestDrive:\test.txt'
                Files         = 'TestDrive:\sample.ps1'
            }
            & $cmd @splat
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Layout'"
    } -Tag acceptance
    It 'Should run without error' {
        $splat = @{
            ErrorAction   = 'Stop'
            NewModuleName = 'PSFoo'
            ParentPath    = 'TestDrive:\'
            Description   = 'Testing Foo'
            Layout        = 'TestDrive:\layout.json'
            Files         = 'TestDrive:\sample.ps1'
            CreateHelp    = $True
        }
        & $cmd @splat | Out-Null
        Get-Item TestDrive:\PSFoo | Should -Exist
        Test-ModuleManifest TestDrive:\psfoo\psfoo.psd1 | Should -Be $True
        (Test-ModuleManifest TestDrive:\psfoo\psfoo.psd1).ExportedFunctions.count | Should -Be 1
        (Get-ChildItem TestDrive:\PSFoo -Directory -Recurse).count | Should -Be 3
        (Get-ChildItem TestDrive:\PSFoo -File -Recurse).count | Should -Be 7

    } -Tag acceptance

} -Tag function

Describe New-ModuleFromLayout {
    BeforeAll {
        $cmd = 'New-ModuleFromLayout'
        New-Item TestDrive:\test.txt -ItemType file
        Mock Get-Command { return $True } -ParameterFilter { $name -match 'git' }
        @'
[
    {
        "ItemType":  "ModuleLayoutMetadata",
        "Created":  "12/16/2024 11:42 AM",
        "CreatedBy":  "DESK11\\Jeff",
        "Computername":  "DESK11",
        "Source":  "C:\\work\\sample",
        "Version":  "1.1"
    },
    {
        "ItemType":  "directory",
        "Path":  "docs"
    },
    {
        "ItemType":  "directory",
        "Path":  "en-us"
    },
    {
        "ItemType":  "directory",
        "Path":  "functions"
    },
    {
        "ItemType":  "file",
        "Path":  "changelog.md",
        "Content":  "# Changelog\r\n"
    },
    {
        "ItemType":  "file",
        "Path":  "README.md",
        "Content":  "# README\r\n"
    }
]
'@ | Out-File 'TestDrive:\layout.json'
    }
    It 'Should have help documentation' {
        (Get-Help $cmd).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name $cmd).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(
        @{Name = 'NewModuleName' }, @{Name = 'ParentPath' }, @{Name = 'Description' },
        @{Name = 'Layout' }
    ) {
        Get-Command $cmd | Should -HaveParameter $Name -Mandatory
    } -Tag unit

    It 'Contains a dynamic parameter of <name>' -ForEach @(@{Name = 'InitializeGit' }) {
        Get-Command $cmd | Should -HaveParameter $Name
    } -Tag unit
    It 'Should fail on an invalid path' {
        Try {
            $splat = @{
                ErrorAction   = 'Stop'
                NewModuleName = 'PSFoo'
                ParentPath    = 'Q:\Foo\Bar'
                Description   = 'Testing Foo'
                Layout        = 'TestDrive:\layout.json'
            }
            & $cmd @splat
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'ParentPath'"
    } -Tag acceptance

    It 'Should fail on an invalid layout filepath' {
        Try {
            $splat = @{
                ErrorAction   = 'Stop'
                NewModuleName = 'PSFoo'
                ParentPath    = 'TestDrive:\'
                Description   = 'Testing Foo'
                Layout        = 'TestDrive:\test.txt'
            }
            & $cmd @splat
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Layout'"
    } -Tag acceptance

    It 'Should run without error' {
        $splat = @{
            ErrorAction   = 'Stop'
            NewModuleName = 'PSFooBar'
            ParentPath    = 'TestDrive:\'
            Description   = 'Testing Foo'
            Layout        = 'TestDrive:\layout.json'
        }
        & $cmd @splat
        Get-Item TestDrive:\PSFooBar | Should -Exist
        (Get-ChildItem TestDrive:\PSFooBar -Directory -Recurse).count | Should -Be 3
        (Get-ChildItem TestDrive:\PSFooBar -File -Recurse).count | Should -Be 4

    } -Tag acceptance

} -Tag function

Describe Test-FunctionName {
    BeforeAll {
        $cmd = 'Test-FunctionName'
    }
    It 'Should have help documentation' {
        (Get-Help $cmd).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name $cmd).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(@{Name = 'Name' }
    ) {
        Get-Command $cmd | Should -HaveParameter $Name -Mandatory
    } -Tag unit

    It 'Should run return boolean results' {
        Test-FunctionName -Name Get-Foo -Quiet | Should -Be $True
        Test-FunctionName -Name BadVerb-Foo -Quiet | Should -Be $False
    } -Tag Acceptance

    It 'Should run return string results' {
        Test-FunctionName -Name Get-Foo | Should -Be 'Get-Foo'
        Test-FunctionName -Name BadVerb-Foo | Should -Be $null
    } -Tag Acceptance
} -Tag function

Describe Get-FunctionProfile {
    BeforeAll {
        $cmd = 'Get-FunctionProfile'
        New-Item TestDrive:\foo.ps1
        $out = @'
#requires -version 5.1
Function Get-Foo {
    [cmdletbinding()]
    [alias('xyz')]
    Param([string]$Name)
    DynamicParam {
        #code here
    }
    Begin { [datetime]::now}
    Process { write-host $name }
    End {}
}
'@

        $out | Out-File TestDrive:\get-foo.ps1
    }
    It "Should have a defined alias of 'gfp'" {
        (Get-Alias 'gfp').ResolvedCommand.name | Should -Be $cmd
    } -Tag acceptance
    It 'Should have help documentation' {
        (Get-Help $cmd).Description | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name $cmd).OutputType | Should -Not -BeNullOrEmpty
    } -Tag acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(@{Name = 'Name' }, @{Name = 'Path' }
    ) {
        Get-Command $cmd | Should -HaveParameter $Name -Mandatory
    } -Tag unit
    It 'Should fail on an invalid path' {
        Try {
            $splat = @{
                ErrorAction = 'Stop'
                Path        = 'Q:\Foo\Bar'
                Name        = 'Get-Foo'
            }
            & $cmd @splat
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Path'"
    } -Tag acceptance

    It 'Should fail on an invalid function name' {
        Try {
            $splat = @{
                ErrorAction = 'Stop'
                Path        = 'TestDrive:\foo.ps1'
                Name        = 'BadName'
            }
            & $cmd @splat
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -Match "cannot validate argument on parameter 'Name'"
    } -Tag acceptance

    It 'Should run without error' {
        $r = & $cmd -Name Get-Foo -path TestDrive:\get-foo.ps1
        ($r | Get-Member name).typename | Should -Be 'PSFunctionProfile'
        $r.DynamicParameters | Should -Be $True
        $r.FunctionAlias | Should -Be 'xyz'
        $r.dotNet | Should -Not -BeNullOrEmpty
        $r.RequiredVersion | Should -Be '5.1'
        $r.externalCommands | Should -BeNullOrEmpty
        $r.name | Should -Be 'Get-Foo'
    } -Tag Acceptance

    It 'Should accept pipeline input' {
        { Get-ChildItem TestDrive:\get-foo.ps1 | Get-FunctionName -Detailed | Get-FunctionProfile } | Should -Not -Throw
    } -Tag acceptance
} -Tag function

Describe Export-FunctionToFile {
    BeforeAll {
        $cmd = 'Export-FunctionToFile'
    }

    It 'Should have help documentation' {
        (Get-Help Export-FunctionToFile).Description | Should -Not -BeNullOrEmpty
    } -Tag Acceptance
    It 'Should have a defined output type' {
        (Get-Command -CommandType function -Name Export-FunctionToFile).OutputType | Should -Not -BeNullOrEmpty
    } -Tag Acceptance
    It 'Should have a mandatory parameter of <name>' -ForEach @(@{Name = 'Name' }) {
        Get-Command $cmd | Should -HaveParameter $Name -Mandatory
    } -Tag unit
    It 'Should support -WhatIf' {
        Get-Command $cmd | Should -HaveParameter 'WhatIf'
    } -Tag unit
    It 'Should run without error' {
        { Export-FunctionToFile -Name prompt -Path TestDrive: } | Should -Not -Throw
    } -Tag Acceptance
    It 'Should fail on an invalid function name error' {
        { Export-FunctionToFile -Name foozzz -Path TestDrive: } | Should -Throw
    } -Tag Acceptance
    It 'Should fail on an invalid path name error' {
        { Export-FunctionToFile -Name foozzz -Path TestDrive: } | Should -Throw
    } -Tag Acceptance

} -Tag function
Describe Open-PSFunctionToolsHelp {

    It "Should have help documentation" {
        (Get-Help Open-PSFunctionToolsHelp).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Open-PSFunctionToolsHelp).OutputType | Should -Not -BeNullOrEmpty
    }

    InModuleScope PSFunctionTools {
        BeforeAll {
            Mock Show-Markdown { } -Parameter {$Path -match "README"}
            Mock Invoke-Item { } -Parameter {$Path -match "pdf"}
            Mock Test-Path { return $True} -Parameter {$Path -match "pdf"}
            Mock Test-Path { return $False} -Parameter {$Path -match "README"}
        }
        It "Should fail to run with missing file" {
            {Open-PSFunctionToolsHelp -AsMarkdown} | Should -Throw
        }

        It "Should call Invoke-Item" {
            Open-PSFunctionToolsHelp
            Should -Invoke Invoke-Item -Times 1 -Exactly
        }

        It "Should call Show-Markdown for markdown output" {
            #override the BeforeAll mock
            Mock Test-Path { return $True} -Parameter {$Path -match "README"}
            Open-PSFunctionToolsHelp -AsMarkdown
            Should -Invoke Show-Markdown -Times 1 -Exactly
        }
        It "Should run without error" {
            {Open-PSFunctionToolsHelp} | Should -Not -Throw
        }
    } #end InModuleScope

} -tag function
Describe Open-PSFunctionToolsSamples {

    It "Should have help documentation" {
        (Get-Help Open-PSFunctionToolsSamples).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Open-PSFunctionToolsSamples).OutputType | Should -Not -BeNullOrEmpty
    }
    InModuleScope PSFunctionTools {
        BeforeAll {
            Mock Set-Location { return $True } -Verifiable
            Mock Get-ChildItem { } -Verifiable
        }
        It "Should call Set-Location" {
            Open-PSFunctionToolsSamples | Should -InvokeVerifiable
        }
        It "Should call Get-ChildItem" {
            Open-PSFunctionToolsSamples | Should -InvokeVerifiable
        }
        It "Should run without error" {
            {Open-PSFunctionToolsSamples} | Should -Not -Throw
        }
    } #end InModuleScope

} -tag function