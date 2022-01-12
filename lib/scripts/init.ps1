Start-process -FilePath msiexec -ArgumentList '/X','{177B605A-B1E1-3197-B5D4-05F00C0174D1}','/q' -Wait
Start-Process -FilePath "C:\Program Files (x86)\Mozilla Maintenance Service\uninstall.exe" -ArgumentList '/S' -Wait
