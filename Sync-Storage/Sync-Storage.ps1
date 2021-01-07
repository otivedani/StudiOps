function Sync-Storage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [string]$Source,

        [string]$Destination=(Join-Path -Path "$HOME" -ChildPath "storage-backup/"),

        [string]$ReferTo=".reflist.csv"
    )    
    
    $currentScan = {} | Select-Object Path,Hash;
    $ReferencePath = Join-Path -Path $Destination -ChildPath $ReferTo

    # Load file, or create file
    if (Test-Path $ReferencePath) {
        $currentScan = Import-Csv $ReferencePath -Delimiter "`t"
    } else {
        New-Item -Path $ReferencePath -Force
        $currentScan | Export-Csv $ReferencePath -Delimiter "`t" -NoTypeinformation
    }

    # scan directory
    $afterScan = Get-ChildItem $Source -Recurse | Get-FileHash -Algorithm MD5 
    
    # differences is \drumroll
    $tobeCopied = Compare-Object -ReferenceObject $($currentScan | Select-Object Hash) -DifferenceObject $afterScan | Where-Object { $_.SideIndicator -eq "=>" } | ForEach-Object { $_.InputObject }
    
    # populate
    # $destTable = @{}
    # $tobeCopied | Select-Object Path | ForEach-Object { $destTable[$_.Path] = (Join-Path -Path $Destination -ChildPath (Split-Path -Leaf $_.Path)) }
    
    # copy deh
    New-Item -ItemType Directory -Force $Destination
    $tobeCopied | Select-Object Path | Copy-Item -Destination $Destination #-PassThru | Where-Object { $_ -is [system.io.fileinfo] }
    # $destTable | ForEach-Object { Copy-Item -Source $_.Key -Destination $_.Value } #-PassThru | Where-Object { $_ -is [system.io.fileinfo] }
    
    # update list
    $tobeCopied | Export-Csv $ReferencePath -Delimiter "`t" -NoTypeinformation -Append

    # return $destTable
}