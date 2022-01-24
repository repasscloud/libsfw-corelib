    # write data to sql library
#     try
#     {
#         $UpdateAppsDBOutput = & $dll --uid $uid --key $app --latest --publisher $publisher --name $name --version $version `
#             --category $category --arch $arch --exec-type $type --filename $filename --sha256 $shahash --follow-uri $followuri `
#             --install-switches $switches --display-name $displayname --display-version $displayversion `
#             --display-publisher $displaypublisher --uninstall-string $uninstallstring `
#             --detect-method $detect_method --detect-value $detect_value --installer-class $installer_class --path $path `
#             --homepage $homepage --icon $icon --copyright $copyright --license $license --docs $docs --tags $tags `
#             --summary $summary --rebootrequired $rebootrequired --depends $depends --lcid $lcid `
#             --csHost $env:APPS_CS_HOST --csDB apps_db --csUsr $env:APPS_CS_USR --csPK $env:APPS_CS_PK
        
#         switch ($UpdateAppsDBOutput)
#         {
#             0
#             {
#                 Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) RECORD CREATED: ${uid}"
#                 if (Test-Path -Path $download_path) { Remove-Item -Path $download_path -Confirm:$false -Force }
#             }
#             1
#             {
#                 Write-Output "$([char]::ConvertFromUTF32("0x1F7E0")) RECORD EXISTS: ${uid}"
#                 #& $cni $env:GH_API $env:GH_USER $env:GH_REPO "record exists999" "this was created by api"
#                 if (Test-Path -Path $download_path) { Remove-Item -Path $download_path -Confirm:$false -Force }
#             }
#             Default
#             {
#                 Write-Output "$([char]::ConvertFromUTF32("0x1F534")) UNHANDLED EXCEPTION: ${uid}"
#                 if (Test-Path -Path $download_path) { Remove-Item -Path $download_path -Confirm:$false -Force }
#                 [System.String]$timeStamp = (Get-Date).ToString("yyyy-MM-dd HH:mm")
#                 [System.String]$errorBodyText = @"
# Payload:
# ``````powershell
# --uid $uid --key $app --latest --publisher $publisher --name $name --version $version
# --category $category --arch $arch --exec-type $type --filename $filename --sha256 $shahash --follow-uri $followuri
# --install-switches $switches --display-name $displayname --display-version $displayversion
# --display-publisher $displaypublisher --uninstall-string $uninstallstring
# --detect-method $detect_method --detect-value $detect_value --installer-class $installer_class --path $path
# --homepage $homepage --icon $icon --copyright $copyright --license $license --docs $docs --tags $tags
# --summary $summary --rebootrequired $rebootrequired --depends $depends --lcid $lcid
# ``````
# TimeStamp: ${timeStamp}
# "@
#                 #& $cni $env:GH_API $env:GH_USER $env:GH_REPO "tbl_appdata ingest error: ${uid}" $errorBodyText
#                 break  # break the loop on this item and move to the next one
#             }
#         }
#     }
#     catch
#     {
#         Write-Output "$([System.Char]::ConvertFromUtf32("0x1F534")) UNABLE TO CREATE SQL RECORD: ${app}"
#         if (Test-Path -Path $download_path) { Remove-Item -Path $download_path -Confirm:$false -Force }
#     }

#     <# VERBOSE TEST #>
#     "--uid $uid --key $app --latest --publisher $publisher --name $name --version $version " +
#     "--category $category --arch $arch --exec-type $type --filename $filename --sha256 $shahash --follow-uri $followuri " +
#     "--install-switches $switches --display-name $displayname --display-version $displayversion " +
#     "--display-publisher $displaypublisher --uninstall-string $uninstallstring " +
#     "--detect-method $detect_method --detect-value $detect_value --installer-class $uninstaller_class --path $path " +
#     "--homepage $homepage --icon $icon --copyright $copyright --license $license --docs $docs --tags $tags " +
#     "--summary $summary --rebootrequired $rebootrequired --depends $depends --lcid $lcid " +
#     " --csHost $env:APPS_CS_HOST --csDB apps_db --csUsr $env:APPS_CS_USR --csPK $env:APPS_CS_PK"
#     <# END VERBOSE TEST #>

#     # upload to S3
#     try
#     {
#         Start-Process -FilePath mc -ArgumentList "mb","${s3repo}/apps" -Wait -ErrorAction Stop
#         Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) BUCKET CREATED: ${s3repo}/apps"
#     }
#     catch
#     {
#         Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E1")) BUCKET EXISTS: ${s3repo}/apps"
#     }
#     mc cp "${download_path}" "${s3repo}/${path}"