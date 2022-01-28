# path variables
[System.String]$jsonMaps = Join-Path -Path $env:APPVEYOR_BUILD_FOLDER -ChildPath "data\json-maps"

# source all functions
Get-ChildItem -Path C:\Projects\libsfw\lib\functions | ForEach-Object { . $_.FullName }

# notice
Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E3")) BUILDING JSON LIBRARY FILES"

# build all json maps
Build-JsonFiles -JsonMapDir $jsonMaps
