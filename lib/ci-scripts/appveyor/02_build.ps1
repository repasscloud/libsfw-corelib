# path variables
[System.String]$rootPath = $env:APPVEYOR_BUILD_FOLDER
[System.String]$jsonMaps = Join-Path -Path $rootPath -ChildPath "data\json-maps"
$env:PATH += ';C:\mc\bin'

# notice
Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E3")) Building JSON Library Files"

# build all json maps
Build-JsonFiles -JsonMapDir $jsonMaps
