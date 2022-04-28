<# PRELOAD - DO NOT EDIT #>
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer

<# APP SPECIFIC CODE - DO NOT EDIT #>
$adr_regex = '^.*-x64.msi$'
$adr_uri = "https://www.7-zip.org/download.html"
$adr_version = (((((Invoke-WebRequest -Uri $adr_uri -UserAgent $userAgent -UseBasicParsing).Links | Where-Object -FilterScript {$_.href -match $adr_regex} | Select-Object -First 1).outerHTML -replace '<A href="a/7z','') -replace '\-x64\.msi.*$','')/100).ToString()
$adr_publisher = "Igor Pavlov"
$adr_name = "7-Zip"
$adr_copyright = "Copyright © $((Get-Date).ToString("yyyy")) Igor Pavlov"
$adr_nuspec = "https://raw.githubusercontent.com/chocolatey-community/chocolatey-packages/master/automatic/7zip/7zip.nuspec"
$adr_licenseacceptrequired = $false
$adr_rebootrequired = $false
$adr_category = "Utility"
$adr_xft = "mc"
$adr_locale = "upcloud_au_syd_07"
$adr_arch = "x64"
$adr_lcid = "en-US"
$adr_exectype = "msi"
$adr_followuri = "https://www.7-zip.org/a/7z" + $adr_version.Replace('.','') + "-x64.msi"
$adr_absoluteuri = $adr_followuri  # $null if not known
# $adr_installcmd = "AcroRdrDCx64" + $adr_version.Replace('.','') + "_MUI.exe"
# $adr_installargs = "/sAll /msi /qn ALLUSERS=1 EULA_ACCEPT=YES DISABLEDESKTOPSHORTCUT=1"  # used for backwards compatability
# $adr_displayname = "Adobe Acrobat DC (64-bit)"  # OPTIONAL
# $adr_displaypublisher = "Adobe"
# $adr_displayversion = $adr_version
# $adr_detectmethod = "FileVersion"
# $adr_detectvalue = "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe::${adr_version}" + ".0"
# $adr_uninstallprocess = "msi"  # "void_uninstall","msi","exe","exe2","inno","script"
# $adr_uninstallcmd = "MsiExec.exe /I{AC76BA86-1033-FF00-7760-BC15014EA700}"
# $adr_uninstallargs = "msi-void"


# <# NOTES #>
# #~ CoreLib, do not edit
# #~ Adobe installs as an EXE, uninstalls as an MSI
# #~ Adobe installs sometimes, othertimes it get stuck