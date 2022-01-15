# minio/mc config setup
[System.String]$mcconfig = 'C:\Users\appveyor\AppData\Roaming\mc-config.json'
Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/repasscloud/init-files/main/mc/config.json -OutFile $mcconfig
(Get-Content -Path $mcconfig) -replace "MC_ACCESS_KEY", "$env:AU_SYD1_07_AK" | Out-File -FilePath $mcconfig -Force
(Get-Content -Path $mcconfig) -replace "MC_SECRET_KEY", "$env:AU_SYD1_07_SK" | Out-File -FilePath $mcconfig -Force
(Get-Content -Path $mcconfig) -replace "MC_URL", "$env:AU_SYD1_07_URI" | Out-File -FilePath $mcconfig -Force    


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
    Start-Process -FilePath "C:\Program Files (x86)\Google\Chrome\Application\77.0.3865.120\Installer\setup.exe" -ArgumentList "--uninstall","--system-level","--verbose-logging","--force-uninstall" -Wait -ErrorAction Stop
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
Write-Output "$($Env:STRING_OF_TEXT)"
try
{
    Start-Process -FilePath "C:\Program Files (x86)\Mozilla Firefox\uninstall\helper.exe" -ArgumentList "-ms" -Wait -ErrorAction Stop
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
