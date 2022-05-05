<# PRELOAD - DO NOT EDIT #>
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer

<# APP SPECIFIC CODE - DO NOT EDIT #>
$adr_regex = [System.String]::Empty
$adr_uri = [System.String]::Empty
$adr_version = (((Invoke-WebRequest -Uri https://www.mozilla.org/en-US/firefox/notes/ -UseBasicParsing).Links | Where-Object -FilterScript {$_.href -match '^/firefox/.*/releasenotes/'} | Select-Object -ExpandProperty href) -replace '/firefox/','') -replace '/releasenotes/',''
$adr_publisher = "Mozilla"
$adr_name = "Firefox"
$adr_copyright = "Copyright 1998-$((Get-Date).ToString("yyyy")) Mozilla Foundation."
$adr_nuspec = "https://raw.githubusercontent.com/chocolatey-community/chocolatey-packages/master/automatic/firefox/firefox.nuspec"
$adr_licenseacceptrequired = $false
$adr_rebootrequired = $false
$adr_category = "Internet"
$adr_xft = "mc"
$adr_locale = "upcloud_au_syd_07"
$adr_arch = "x86"
$adr_lcid = "en_US"
$adr_exectype = "msi"
$adr_followuri = "https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US"
$adr_absoluteuri = $null  # $null if not known
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
$alt_summary = "Bringing together all kinds of awesomeness to make browsing better for you."

# <# NOTES #>
# #~ CoreLib, do not edit
# #~ Adobe installs as an EXE, uninstalls as an MSI
# #~ Adobe installs sometimes, othertimes it get stuck