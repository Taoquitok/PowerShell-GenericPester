<#
.SYNOPSIS
    Generic pester tests to look for major show-stoppers
.DESCRIPTION
    Generic tests used to provide a consistent approache to high level tests needed across all PowerShell projects.
    Initial thoughts are to suggest including this repository as a submodule within git projects
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
$ProjectRoot = If ((Split-Path (Resolve-Path .\).path -Leaf) -match 'Test'){
    Resolve-Path $PSScriptRoot\..
} else {
    # Allows test project to validate itself
    Resolve-Path $PSScriptRoot
}
$FileSearch = @{
    Path    = $ProjectRoot
    Include = '*.ps1', '*.psm1', '*.psd1'
    Recurse = $true
}

# TestCases are splatted to the script so we need them in a hashtable format
# Due to how Get-ChildItem defaults to displaying text depending on if the results are multi-folder or not, FileName is declared to clean up the "IT" statement
$FileTestCases = @(Get-ChildItem @FileSearch) | ForEach-Object {
    @{
        FileName = $_.Name
        File = $_
    }
}
$ModuleTestCases = @($FileTestCases | Where-Object { $_.File.Fullname -match "\.psd1"})

$ValidationDescription = 'Generic project validation of {0} files and {1} modules' -f $FileTestCases.count, $ModuleTestCases.count

Describe  $ValidationDescription {

    Context 'All PowerShell files should be valid' {
        It '<FileName> should be valid powershell' -TestCases $FileTestCases {
            param($File)

            $File.FullName | Should -Exist

            $FileContents = Get-Content -Path $File.FullName -ErrorAction Stop
            $Errors = $null
            [System.Management.Automation.PSParser]::Tokenize($FileContents, [ref]$Errors) > $null
            $Errors.Count | Should -Be 0
        }
    }

    If ($ModuleTestCases) {
        Context 'All Modules should be able to import without error' {
            It '<FileName> module passes Test-ModuleManifest' -TestCases $ModuleTestCases {
                param($File)
                Test-ModuleManifest -Path $File.FullName | Should Not BeNullOrEmpty
                $? | Should Be $true
            }

            It '<FileName> module can import cleanly' -TestCases $ModuleTestCases {
                param($File)

                {Import-Module $File.FullName -Force -ErrorAction Stop} | Should -Not -Throw
            }
        }
    }

    # TODO: Better param name
    # TODO: better way to include secondary tests as necessary
    # $Files = Get-ChildItem @FileSearch
    # $FileTestTestCases = $Files.where{$_.Name -match ".*(.test)\.ps1$" -and $_.Name -notmatch 'ModuleValidation.Tests.ps1'} | ForEach-Object {
    #     @{
    #         FileName = $_.Name
    #         File = $_
    #     }
    # }

    # Context 'For functions with personal tests, tests should succeed' {
    #     It '<FileName> should run' -TestCases $FileTestTestCases {
    #         param($File)

    #         # NOTE: This does weird stuff... Presumably there's a more appropriate way to include more test files
    #         Invoke-Pester $File.FullName -PassThru
    #     }

    # }
}
