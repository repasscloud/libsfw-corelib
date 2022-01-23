function Read-FileHash {
    [CmdletBinding()]
    param (
        [System.String]$DLFile
    )
    
    [System.String]$OutputPath = Join-Path -Path $env:TEMP -ChildPath $DLFile
    [System.String]$returned_hash = (Get-FileHash -Path $OutputPath -Algorithm SHA256).Hash

    return $returned_hash
}