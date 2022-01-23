# uninstall Google update tool
[System.String]$app_i = "Google Auto Update Tool"
Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) Uninstalling ${app_i}"
try
{
    Start-Process -FilePath MsiExec.exe -ArgumentList "/X","{60EC980A-BDA2-4CB6-A427-B07A5498B4CA}","/qn" -Wait -ErrorAction Stop
    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) ${app_i} removed"
}
catch
{
    Write-Output "$([char]::ConvertFromUTF32("0x1F534")) ${app_i} not removed"
    [System.Array]$otherApps = @("google")
    foreach ($app in $otherApps)
    {
        # print installer information
        [System.Array]$hklmPaths = @(
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
            "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
        )
        foreach ($path in $hklmPaths)
        {
            Get-ChildItem -Path $path | Get-ItemProperty | Where-Object -FilterScript {$null -notlike $_.DisplayName} | Where-Object -FilterScript {$_.DisplayName -like "*${app}*"} | Select-Object -Property *
        }
    }
}


# uninstall Google Chrome
[System.String]$app_i = "Google Chrome"
Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) Uninstalling ${app_i}"
try
{
    #Start-Process -FilePath "C:\Program Files (x86)\Google\Chrome\Application\77.0.3865.120\Installer\setup.exe" -ArgumentList "--uninstall","--system-level","--verbose-logging","--force-uninstall" -Wait -ErrorAction Stop
    Start-process -FilePath msiexec -ArgumentList '/X','{177B605A-B1E1-3197-B5D4-05F00C0174D1}','/q' -Wait
    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) ${app_i} removed"
}
catch
{
    Write-Output "$([char]::ConvertFromUTF32("0x1F534")) ${app_i} not removed"
    [System.Array]$otherApps = @("google")
    foreach ($app in $otherApps)
    {
        # print installer information
        [System.Array]$hklmPaths = @(
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
            "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
        )
        foreach ($path in $hklmPaths)
        {
            Get-ChildItem -Path $path | Get-ItemProperty | Where-Object -FilterScript {$null -notlike $_.DisplayName} | Where-Object -FilterScript {$_.DisplayName -like "*${app}*"} | Select-Object -Property *
        }
    }
}
#ref: https://answers.microsoft.com/en-us/windows/forum/all/uninstall-silently-google-chrome-by-command-line/0b35fde7-3f8a-473d-9a41-ca1946616bbb


# uninstall Mozilla Firefox
[System.String]$app_i = "Mozilla Firefox"
Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) Uninstalling ${app_i}"
try
{
    Start-Process -FilePath "C:\Program Files (x86)\Mozilla Maintenance Service\uninstall.exe" -ArgumentList '/S' -Wait
    Start-Process -FilePath "C:\Program Files\Mozilla Firefox\uninstall\helper.exe" -ArgumentList "-ms" -Wait -ErrorAction Stop
    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) ${app_i} removed"
}
catch
{
    Write-Output "$([char]::ConvertFromUTF32("0x1F534")) ${app_i} not removed"
    [System.Array]$otherApps = @("firefox")
    foreach ($app in $otherApps)
    {
        # print installer information
        [System.Array]$hklmPaths = @(
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
            "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
        )
        foreach ($path in $hklmPaths)
        {
            Get-ChildItem -Path $path | Get-ItemProperty | Where-Object -FilterScript {$null -notlike $_.DisplayName} | Where-Object -FilterScript {$_.DisplayName -like "*${app}*"} | Select-Object -Property *
        }
    }
}


# minio/mc configuration
New-Item -Path C:\mc\bin -ItemType Directory -Force -Confirm:$false
$env:PATH += ';C:\mc\bin'
Invoke-WebRequest -Uri https://dl.min.io/client/mc/release/windows-amd64/mc.exe -OutFile C:\mc\bin\mc.exe -UseBasicParsing
mc alias set au-syd1-07 $env:MC_URI $env:MC_ACCESS_KEY $env:MC_SECRET_KEY
[System.Array]$hklmPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)
Get-ChildItem -Path $hklmPaths | Get-ItemProperty | Where-Object -FilterScript {$null -notlike $_.DisplayName} | Export-Csv -Path $env:TMP\app_list.csv -NoTypeInformation
try {
    Start-Process -FilePath mc -ArgumentList 'mb','au-syd1-07/lib' -Wait -ErrorAction Stop
} catch {
    'Bucket exists'
}
mc cp $env:TMP\app_list.csv au-syd1-07/lib/appveyor/app_list.csv


# clear environment variables
[System.Environment]::SetEnvironmentVariable("[7zip]", $null, 'Machine')


# load functions
