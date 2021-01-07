$here = Split-Path -Parent $MyInvocation.MyCommand.Path 
. "$here\Sync-Storage.ps1"
. "$here\Set-MockFiles.ps1"

BeforeAll {
    $srcDir = ".\mnt\M\DCIM\"
    $dstDir = ".\mnt\C\Users\me\"
}

Describe -Tags "Njajal" "Sync-Storage" {
    
    It "yagitudeh" {
        $filesBefore = Set-MockFiles -Stop 5 -Start 0 -Path $srcDir -TrailDecimal 3
        Sync-Storage -Source $srcDir -Destination $dstDir
        Start-Sleep 5
        $filesAfter = Set-MockFiles -Stop 19 -Start 5 -Path $srcDir -TrailDecimal 3
        Sync-Storage -Source $srcDir -Destination $dstDir

        $a = Join-Path -Path $dstDir -ChildPath "004.txt" | Get-ChildItem
        $b = Join-Path -Path $dstDir -ChildPath "005.txt" | Get-ChildItem
        $c = Join-Path -Path $dstDir -ChildPath "006.txt" | Get-ChildItem

        ($b.CreationTime-$a.CreationTime) -lt [timespan]::FromSeconds(6) | Should -BeTrue 
        ($c.CreationTime-$b.CreationTime) -lt [timespan]::FromSeconds(1) | Should -BeTrue 

        Remove-MockFiles $filesBefore
        Remove-MockFiles $filesAfter
        Remove-Item $(Split-Path -Parent $srcDir) -Force -Recurse 
        Remove-Item $(Split-Path -Parent $dstDir) -Force -Recurse
        Remove-Item "$HOME\storage-backup\.reflist.csv"
    }
    
    
}

AfterAll {
    
}
