<# PRELOAD - DO NOT EDIT #>
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer

<# APP SPECIFIC CODE - DO NOT EDIT #>
$adr_regex = [System.String]::Empty
$adr_uri = [System.String]::Empty
$adr_version = (Invoke-WebRequest -Uri 'http://omahaproxy.appspot.com/all?os=win&amp;channel=stable' -UseBasicParsing).content | ConvertFrom-Csv | Select-Object -ExpandProperty current_version
$adr_publisher = "Google"
$adr_name = "Chrome"
$adr_copyright = "Copyright $((Get-Date).ToString("yyyy")) Google LLC. All rights reserved."
$adr_nuspec = "https://raw.githubusercontent.com/chocolatey-community/chocolatey-packages/master/automatic/googlechrome/googlechrome.nuspec"
$adr_licenseacceptrequired = $false
$adr_rebootrequired = $false
$adr_category = "Internet"
$adr_xft = "mc"
$adr_locale = "upcloud_au_syd_07"
$adr_arch = "x86"
$adr_lcid = "en_US"
$adr_exectype = "msi"
$adr_followuri = "https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise.msi"
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
$alt_summary = "Chrome is a fast, simple, and secure web browser, built for the modern web."

# <# NOTES #>
# #~ CoreLib, do not edit
# #~ Adobe installs as an EXE, uninstalls as an MSI
# #~ Adobe installs sometimes, othertimes it get stuck