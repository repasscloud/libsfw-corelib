function Uninstall-ApplicationPackage {
    [CmdletBinding()]
    param (
        [System.String]$UninstallClass,
        [System.String]$UninstallString,
        [System.String]$DisplayName
    )
    
    begin {
        [System.Array]$hklmPaths = @(
            'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
            'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
        )
    }

    process {
        switch ($uninstaller_class)
        {
            'msi' {
                if ($uninstallstring -match 'MsiExec.exe /I.*') {$uarg = $uninstallstring.Replace('MsiExec.exe /I', '') }
                if ($uninstallstring -match 'MsiExec.exe /X.*') {$uarg = $uninstallstring.Replace('MsiExec.exe /X', '') }
                try {
                    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E1")) START UNINSTALL: ${DisplayName}"
                    Start-Process -FilePath msiexec -ArgumentList "/X","${uarg}","/passive" -Wait -ErrorAction Stop
                    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) UNINSTALLED: ${DisplayName}"
                }
                catch {
                    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F534")) DID NOT UNINSTALL: ${DisplayName}"
                }
            }
            'exe' {
                try {
                    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E1")) START UNINSTALL: ${DisplayName}"
                    Start-Process -FilePath $uninstallstring -ArgumentList "${switches}" -Wait -ErrorAction Stop
                    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) UNINSTALLED: ${DisplayName}"
                }
                catch {
                    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F534")) DID NOT UNINSTALL: ${DisplayName}"
                }
            }
        }
    
        # verify app uninstalled
        if ($null -notlike (Get-ChildItem -Path $hklmPaths | Get-ItemProperty | Where-Object -FilterScript {$_.DisplayName -like $DisplayName}))
        {
            Get-ChildItem -Path $hklmPaths | Get-ItemProperty | Where-Object -FilterScript {$_.DisplayName -like $DisplayName}
            exit 1
        }
        else
        {
            Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) UNINSTALLED: ${DisplayName}"
        }
    }
    
    end {
        [System.GC]::Collect()
    }
}