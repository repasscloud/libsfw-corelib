# path variables
[System.String]$rootPath = $env:APPVEYOR_BUILD_FOLDER
[System.String]$jsonMaps = Join-Path -Path $rootPath -ChildPath "data\json-maps"
$env:PATH += ';C:\mc\bin'

