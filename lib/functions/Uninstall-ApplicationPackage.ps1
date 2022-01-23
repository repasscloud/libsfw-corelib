function Uninstall-ApplicationPackage {
    [CmdletBinding()]
    param (
        [System.String]$UninstallClass,
        [System.String]$UninstallString
    )
    
    switch ($uninstaller_class)
    {
        'msi' {
            if ($uninstallstring -match 'MsiExec.exe /I.*') {$uarg = $uninstallstring.Replace('MsiExec.exe /I', '') }
            if ($uninstallstring -match 'MsiExec.exe /X.*') {$uarg = $uninstallstring.Replace('MsiExec.exe /X', '') }
            try {
                Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E1")) START UNINSTALL: ${displayname}"
                "Start-Process -FilePath msiexec -ArgumentList '/X','${uarg}','/passive' -Wait -ErrorAction Stop"
                Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) UNINSTALLED: ${displayname}"
            }
            catch {
                Write-Output "$([System.Char]::ConvertFromUTF32("0x1F534")) DID NOT UNINSTALL: ${displayname}"
            }
        }
        'exe' {
            try {
                Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E1")) START UNINSTALL: ${displayname}"
                Start-Process -FilePath $uninstallstring -ArgumentList "${switches}" -Wait -ErrorAction Stop
                Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) UNINSTALLED: ${displayname}"
            }
            catch {
                Write-Output "$([System.Char]::ConvertFromUTF32("0x1F534")) DID NOT UNINSTALL: ${displayname}"
            }
        }
    }
}