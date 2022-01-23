#region preload
# global variables
[System.String]$dataPath = Join-Path -Path $env:APPVEYOR_BUILD_FOLDER -ChildPath 'data'
[System.String]$dls = Join-Path -Path $env:APPVEYOR_BUILD_FOLDER -ChildPath 'data\downloads'
[System.String]$jdp = Join-Path -Path $env:APPVEYOR_BUILD_FOLDER -ChildPath 'data\json'
[System.String]$dll = Join-Path -Path $env:APPVEYOR_BUILD_FOLDER -ChildPath 'utils\DBUtils\DBUtils.UpdateAppsDB.exe'
[System.String]$cni = Join-Path -Path $env:APPVEYOR_BUILD_FOLDER -ChildPath 'utils\CreateNewIssue.exe'
[System.String]$copyrightSymbol = [System.Char]::ConvertFromUtf32("0x00A9")
[System.String]$pattern = '[^a-zA-Z0-9\-\ ]'
[System.Array]$hklmPaths = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
    'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
)
[System.String]$env:PATH += ';C:\mc\bin'

# which output encoding is being used
$OutputEncoding = New-Object -TypeName System.Text.UTF8Encoding
if ($OutputEncoding.EncodingName -eq "Unicode (UTF-8)")
{
    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) ENCODING: $($OutputEncoding.EncodingName)"
}
else
{
    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E0")) ENCODING: $($OutputEncoding.EncodingName)"
}

# internet user agent string
$userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer
Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) USER AGENT: ${userAgent}"

# Tls 1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) TLS VERSION: $([System.Net.SecurityProtocolType]::Tls12)"
#endregion preload

#region prepare data stacks
# list of all json library files to investigate
[System.Array]$jsonFiles = Get-ChildItem -Path $jdp -Filter "*.json" -File -Recurse | Select-Object -ExpandProperty FullName
#endregion prepare data stacks

#region verify apps to build
foreach ($jsonFile in $jsonFiles)
{
    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) TESTING JSON FILE: ${jsonFile}"

    # load json file to $j
    $j = Get-Content -Path $jsonFile | ConvertFrom-Json

    # isolate the UID
    $UID = $j.id.uid

    # check if the UID is present in the catalogue and remove if found, else ignore and move on
    Search-UID -UID $UID
}
#endregion verify apps to build