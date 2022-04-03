<# PRELOAD - DO NOT EDIT #>
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer

<# APP SPECIFIC CODE - DO NOT EDIT #>
$adr_regex = '^.*https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/continuous.*'
$adr_uri = "https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html"
$adr_version = ((Invoke-WebRequest -Uri $adr_uri -UserAgent $userAgent -UseBasicParsing).Links | Where-Object {$_.href -match $adr_regex} | Where-Object -FilterScript {$_.outerHTML -match '^.*DC.*\(22.*'} | Select-Object -First 1).outerHTML -replace '.*([0-9]{2}\.[0-9]{3}\.[0-9]{5}).*','$1'
$adr_publisher = "Adobe"
$adr_name = "Acrobat Reader DC"
$adr_copyright = "Copyright $([System.Char]::ConvertFromUTF32("0xA9")) 1984-2018 Adobe Systems Incorporated and its licensors"
$adr_nuspec = "https://raw.githubusercontent.com/open-circle-ltd/chocolatey.adobe-acrobat-reader-dc/master/package/adobereader.nuspec"
$adr_licenseacceptrequired = $true
$adr_rebootrequired = $false
$adr_category = "Productivity"
$adr_xft = "mc"
$adr_locale = "upcloud_au_syd_07"
$adr_arch = "x64"
$adr_lcid = "MUI"
$adr_exectype = "exe"
$adr_followuri = "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/" + $adr_version.Replace('.','') + "/AcroRdrDCx64" + $adr_version.Replace('.','') + "_MUI.exe"
$adr_absoluteuri = $null  # $null if not known
$adr_installcmd = "AcroRdrDCx64" + $adr_version.Replace('.','') + "_MUI.exe"
$adr_installargs = "/sAll /msi /qn ALLUSERS=1 EULA_ACCEPT=YES DISABLEDESKTOPSHORTCUT=1"  # used for backwards compatability
$adr_displayname = "Adobe Acrobat DC (64-bit)"  # OPTIONAL
$adr_displaypublisher = "Adobe"
$adr_displayversion = $adr_version
$adr_detectmethod = "Registry"
$adr_uninstallprocess = "msi"  # "void_uninstall","msi","exe","exe2","inno","script"
$adr_uninstallcmd = "MsiExec.exe /I{AC76BA86-1033-FF00-7760-BC15014EA700}"
$adr_uninstallargs = "msi-void"


<# NOTES #>
#~ CoreLib, do not edit
#~ Adobe installs as an EXE, uninstalls as an MSI
#~ Adobe installs sometimes, othertimes it get stuck
