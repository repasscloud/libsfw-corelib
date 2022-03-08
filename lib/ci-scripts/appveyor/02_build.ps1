# path variables
[System.String]$JsonMapsDir = Join-Path -Path $env:APPVEYOR_BUILD_FOLDER -ChildPath "data\json-maps"

# source all functions
Get-ChildItem -Path (Join-Path -Path $env:APPVEYOR_BUILD_FOLDER -ChildPath 'lib\functions') -Filter "*.ps1" -File | ForEach-Object { . $_.FullName }

# notice
Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E3")) BUILDING JSON LIBRARY FILES"

# build all json maps
Build-JsonFiles -JsonMapDir $JsonMapsDir
