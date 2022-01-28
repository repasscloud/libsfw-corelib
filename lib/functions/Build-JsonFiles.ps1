function Build-JsonFiles {
    [CmdletBinding()]
    param (
        [System.String]$JsonMapDir
    )
    
    [System.Array]$PS1SrcFiles = Get-ChildItem -Path $JsonMapDir -Filter "*.ps1" | Select-Object FullName,Name
    
    foreach ($ps1 in $PS1SrcFiles)
    {
        # set name and full name
        [System.String]$jsonFileSrc = $ps1.Name
        [System.String]$jsonPathSrc = $ps1.FullName

        # advise the file is being built
        Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E1")) BUILDING JSON FILE FOR INGEST: ${jsonFileSrc}"

        # execute the generation of the JSON library file
        & $jsonPathSrc
    }
}