# path variables
[System.String]$rootPath = $env:APPVEYOR_BUILD_FOLDER
[System.String]$jsonMaps = Join-Path -Path $rootPath -ChildPath "data\json-maps"
$env:PATH += ';C:\mc\bin'

# notice
Write-output ">>> Building JSON Library Files"

# build all json maps
Get-ChildItem -Path $jsonMaps -Filter "*.ps1" | ForEach-Object {
    [System.String]$jsonFile = $_.Name
    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) Building JSON file for ingest: ${jsonFile}"
    & $_.FullName
}
