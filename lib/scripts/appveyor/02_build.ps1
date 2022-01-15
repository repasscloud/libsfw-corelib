# path variables
[System.String]$rootPath = $env:APPVEYOR_BUILD_FOLDER
[System.String]$jsonMaps = Join-Path -Path $rootPath -ChildPath "data\json-maps"

# notice
Write-output "-> Building JSON Library Files"

# build all json maps
Get-ChildItem -Path $jsonMaps -Filter "*.ps1" | ForEach-Object {
    [System.String]$jsonFile = $_.Name
    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) Building JSON file for ingest: ${jsonFile}"
    & $_.FullName
}

# notepad++ for testing
Invoke-WebRequest -Uri https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.2/npp.8.2.Installer.x64.exe -OutFile $env:TMP\npp.exe
#Start-Process -FilePath $env:TMP\npp.exe -ArgumentList '/S' -Wait
