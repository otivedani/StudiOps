# Mock Files Creation
function Set-MockFiles {
    [CmdletBinding()]
    param (
        [int]$Stop=10,
        [int]$Start=0,
        [string]$Path=".\tmp"
    )
    $range = ($Stop-$Start)
    
    # reserve new path for generating file if not exists
    New-Item -ItemType Directory -Force -Path $Path
    
    # create files
    $files = [string[]]::new($range)
    
    for ($i = 0; $i -lt $range; $i++) {
        $files[$i] = "{1}\{0:d$(([string]$Stop).length)}.txt" -f ($i+$Start), $Path
        "File No. {0}" -f ($i+$Start) | Out-File -FilePath $files[$i]
    }
    
    return $files
}

function Remove-MockFiles([string[]]$files){
    $files | ForEach-Object {
        if(Test-Path $_) { Remove-Item -Recurse -Path $_ }
    }
}