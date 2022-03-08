# additional paths
[System.String]$jsonFiles= Join-Path -Path  $env:APPVEYOR_BUILD_FOLDER -ChildPath 'data\json'

# update env:PATH
$env:PATH += ";C:\projects\uidl\bin\Release\netcoreapp3.1"

# check if UID for each app exists, those that do, remove the JSON file
foreach ($i in (Get-ChildItem -Path $jsonFiles -Filter "*.json" | Select-Object -ExpandProperty FullName))
{
    [System.String]$uid = (Get-Content -Path $i | ConvertFrom-Json).id.uid
    [System.String]$lup = uidlookup.exe --cshost $env:DB_HOST --csport $env:DB_PORT --csdb $env:DB_DB --csuserid $env:DB_USERID --cspass $env:DB_PASS --uid $uid
    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E1")) LUP CODE: ${lup}"
    if ($lup -eq "0")
    {
        Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E3")) FILE TO PROCESS: ${i}"
    }
    else
    {
        Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E0")) LUP CODE: ${i}"
        Remove-Item -Path $i -Confirm:$false -Force
    }
}