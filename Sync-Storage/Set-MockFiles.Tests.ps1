$here = Split-Path -Parent $MyInvocation.MyCommand.Path 
. "$here\Set-MockFiles.ps1"

Describe -Tags "Example" "Set-Mockfiles" {
    It "should create 10 files - from 0 to 9 - at .\tmp\ - with default parameter" {
        $files = Set-MockFiles
        0..9 | ForEach-Object {
            Test-Path $(".\tmp\{0:d2}.txt" -f $_) | Should -BeTrue
        }
        Remove-Mockfiles $files
    }

    It "should create 10 files - from 990 to 999 - at $env:TEMP\tmp" {
        $files = Set-MockFiles 1000 -Start 990 -Path $env:TEMP\tmp
        990..999 | ForEach-Object {
            Test-Path $("$env:TEMP\tmp\{0:d4}.txt" -f $_) | Should -BeTrue
        }
        Remove-Mockfiles $files
    }

    It "should create 12 files - from 0 to 11 - at $env:TEMP\path\to\tests (deep level 3)" {
        $files = Set-MockFiles 12 -Path "$env:TEMP\path\to\tests\"
        0..11 | ForEach-Object {
            Test-Path $("$env:TEMP\path\to\tests\{0:d2}.txt" -f $_) | Should -BeTrue
        }
        Remove-Mockfiles $files
    }
}
