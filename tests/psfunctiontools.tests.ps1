#tests for Pester 5.x

$global:ModuleName = (Get-Item $PSScriptRoot\..\ -OutVariable p).Name
if (Get-Module -Name $global:ModuleName) {
    Remove-Module -Name $global:ModuleName
}
$global:psd1 = Join-Path $p.fullname -ChildPath "$global:ModuleName.psd1"

Import-Module $global:psd1 -Force

#Write-Host "in module scope $($global:modulename)" -ForegroundColor yellow
Describe "$global:ModuleName" {
    BeforeAll {
        $dir = Get-ChildItem $PSScriptRoot\.. -Directory
    }
    Context "Module Layout" {
        It "Has a valid manifest" {
            { Test-ModuleManifest $global:psd1 } | Should -Not -Throw
        }
        It "Has a <folder> folder" -Foreach @(
            @{folder = "docs" },
            @{folder = "tests" },
            @{folder = "functions" },
            @{folder = "formats" },
            @{folder = "images" }
            @{folder = "en-us" }
        ) {
            $dir.name | Should -Contain $folder
        }
        It "Has a <file> file" -Foreach @(
            @{file = "changelog.md"},
            @{file = "license.txt"},
            @{file = "readme.md"}
            @{file = "..\en-us\$global:ModuleName-help.xml" }
        ) {
            $filepath = Join-Path $PSScriptRoot..\ -ChildPath $file
            $filePath | Should -Exist
        }
        It "Has 15 exported functions" {
            Get-Command -Module $moduleName -CommandType function | Should -HaveCount 15
        }

    } #module context

    Context "<name>" -Foreach @(
    (Get-Command -Module PSFunctiontools -CommandType function).ForEach({ @{Name = $_.name } })
    ) {
        It "Has a markdown help file" {
            $mdPath = Join-Path -Path "..\docs" -ChildPath "$($_.name).md"
            $mdPath | Should -Exist
        }

    } -Tag function,help

} -Tag module,acceptance

Describe Convert-ScriptToFunction {
    BeforeAll {
        "function get-foo { 1 }" | out-file "TestDrive:\test.ps1"
        Mock Test-Path {return $False} -ParameterFilter {$Path -eq 'q:\foo\bar\a.ps1'}
        Mock Test-Path {return $True}  -ParameterFilter {$Path -match 'c.txt|b.ps1'}
    } #beforeall

    It "Should have help documentation" {
        (Get-Help Convert-ScriptToFunction).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Convert-ScriptToFunction).OutputType | Should -not -BeNullOrEmpty
    }
    It "Should have a defined alias of 'csf'" {
        (get-alias 'csf').ResolvedCommand.name | Should -be "Convert-ScriptToFunction"
    }
    It "Should run without error" {
        {Convert-ScriptToFunction -path 'Testdrive:\test.ps1' -name get-foo | Out-File testdrive:\get-foo.ps1} | Should -Not -Throw
        Get-Item Testdrive:\get-foo.ps1 | Should -Exist
    }

    It "Should fail on an invalid path" {
        Try {
            Convert-ScriptToFunction -path q:\foo\bar\a.ps1 -name get-foo -ErrorAction Stop
        }
        Catch {
            $_.exception.message | Should -match "cannot validate argument on parameter 'Path'"
        }
    }
    It "Should fail on an invalid filename." {
        Try {
            Convert-ScriptToFunction -path q:\foo\bar\c.txt -name get-foo -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -match "cannot validate argument on parameter 'Path'"
    }
    It "Should fail on an invalid function name" {
        Try {
            Convert-ScriptToFunction -path 'Testdrive:test.ps1' -name 'barfoo'  -ErrorAction Stop
        }
        Catch {
            $e = $_
        }
        $e.exception.message | Should -match "cannot validate argument on parameter 'Name'"
    }
    #insert additional command-specific tests

} -tag function

Describe Export-FunctionFromFile {
    It "Should have help documentation" {
        (Get-Help Export-FunctionFromFile).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Export-FunctionFromFile).OutputType | Should -not -BeNullOrEmpty
    }
    It "Should run without error" {
        #mock and set mandatory parameters as needed
        {Export-FunctionFromFile} | Should -Not -Throw
    } -pending
    #insert additional command-specific tests

} -tag function

Describe Export-ModuleLayout {
    It "Should have help documentation" {
        (Get-Help Export-ModuleLayout).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Export-ModuleLayout).OutputType | Should -not -BeNullOrEmpty
    }
    It "Should run without error" {
        #mock and set mandatory parameters as needed
        {Export-ModuleLayout} | Should -Not -Throw
    } -Pending
    #insert additional command-specific tests

} -tag function

Describe Format-FunctionName {
    It "Should have help documentation" {
        (Get-Help Format-FunctionName).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Format-FunctionName).OutputType | Should -not -BeNullOrEmpty
    }
    It "Should run without error" {
        {Format-FunctionName get-foo} | Should -Not -Throw
        Format-FunctionName get-foo | Should -BeExactly "Get-Foo"
    }

    It "Should fail on a non-standard function name" {
        {Format-FunctionName Foobar} | Should -Throw
    }

} -tag function

Describe Get-FunctionAlias {
    It "Should have help documentation" {
        (Get-Help Get-FunctionAlias).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Get-FunctionAlias).OutputType | Should -not -BeNullOrEmpty
    }
    It "Should run without error" {
        #mock and set mandatory parameters as needed
        {Get-FunctionAlias} | Should -Not -Throw
    } -pending
    #insert additional command-specific tests

} -tag function

Describe Get-FunctionAttribute {
    It "Should have help documentation" {
        (Get-Help Get-FunctionAttribute).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Get-FunctionAttribute).OutputType | Should -not -BeNullOrEmpty
    }
    It "Should run without error" {
        #mock and set mandatory parameters as needed
        {Get-FunctionAttribute} | Should -Not -Throw
    } -Pending
    #insert additional command-specific tests

} -tag function

Describe Get-FunctionName {
    It "Should have help documentation" {
        (Get-Help Get-FunctionName).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Get-FunctionName).OutputType | Should -not -BeNullOrEmpty
    }
    It "Should run without error" {
        #mock and set mandatory parameters as needed
        {Get-FunctionName} | Should -Not -Throw
    } -skip
    #insert additional command-specific tests

} -tag function

Describe Get-ModuleLayout {
    It "Should have help documentation" {
        (Get-Help Get-ModuleLayout).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Get-ModuleLayout).OutputType | Should -not -BeNullOrEmpty
    }
    It "Should run without error" {
        #mock and set mandatory parameters as needed
        {Get-ModuleLayout} | Should -Not -Throw
    } -skip
    #insert additional command-specific tests

} -tag function

Describe Get-ParameterBlock {
    It "Should have help documentation" {
        (Get-Help Get-ParameterBlock).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Get-ParameterBlock).OutputType | Should -not -BeNullOrEmpty
    }
    It "Should run without error" {
        #mock and set mandatory parameters as needed
        {Get-ParameterBlock} | Should -Not -Throw
    } -skip
    #insert additional command-specific tests

} -tag function

Describe Get-PSRequirements {
    It "Should have help documentation" {
        (Get-Help Get-PSRequirements).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Get-PSRequirements).OutputType | Should -not -BeNullOrEmpty
    }
    It "Should run without error" {
        #mock and set mandatory parameters as needed
        {Get-PSRequirements} | Should -Not -Throw
    } -skip
    #insert additional command-specific tests

} -tag function

Describe Import-ModuleLayout {
    It "Should have help documentation" {
        (Get-Help Import-ModuleLayout).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Import-ModuleLayout).OutputType | Should -not -BeNullOrEmpty
    }
    It "Should run without error" {
        #mock and set mandatory parameters as needed
        {Import-ModuleLayout} | Should -Not -Throw
    } -skip
    #insert additional command-specific tests

} -tag function

Describe New-CommentHelp {
    It "Should have help documentation" {
        (Get-Help New-CommentHelp).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name New-CommentHelp).OutputType | Should -not -BeNullOrEmpty
    }
    It "Should run without error" {
        #mock and set mandatory parameters as needed
        {New-CommentHelp} | Should -Not -Throw
    } -skip
    #insert additional command-specific tests

} -tag function

Describe New-ModuleFromFiles {
    It "Should have help documentation" {
        (Get-Help New-ModuleFromFiles).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name New-ModuleFromFiles).OutputType | Should -not -BeNullOrEmpty
    }
    It "Should run without error" {
        #mock and set mandatory parameters as needed
        {New-ModuleFromFiles} | Should -Not -Throw
    } -skip
    #insert additional command-specific tests

} -tag function

Describe New-ModuleFromLayout {
    It "Should have help documentation" {
        (Get-Help New-ModuleFromLayout).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name New-ModuleFromLayout).OutputType | Should -not -BeNullOrEmpty
    }
    It "Should run without error" {
        #mock and set mandatory parameters as needed
        {New-ModuleFromLayout} | Should -Not -Throw
    } -skip
    #insert additional command-specific tests

} -tag function

Describe Test-FunctionName {
    It "Should have help documentation" {
        (Get-Help Test-FunctionName).Description | Should -Not -BeNullOrEmpty
    }
    It "Should have a defined output type" {
        (Get-Command -CommandType function -name Test-FunctionName).OutputType | Should -not -BeNullOrEmpty
    }
    It "Should run without error" {
        #mock and set mandatory parameters as needed
        {Test-FunctionName} | Should -Not -Throw
    } -skip
    #insert additional command-specific tests

} -tag function