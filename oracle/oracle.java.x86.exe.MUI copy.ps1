<# PRELOAD - DO NOT EDIT #>
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer

<# APP SPECIFIC CODE - DO NOT EDIT #>
$adr_regex = [System.String]::Empty
$adr_uri = [System.String]::Empty
(Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/proudcanadianeh/ChocoPackages/master/jre8/master/tools/chocolateyInstall.ps1).Content | Out-File -FilePath $env:TMP\java64.txt -Force -Confirm:$false
foreach ($lin in (Get-Content $env:TMP\java64.txt)){if ($lin -match '^.*\$url....https.*'){$j = $lin} }
$adr_version = $j.Trim(" `$url64 = '").Trim("'")
$adr_publisher = "Oracle"
$adr_name = "Java 8 Runtime Environment"
$adr_copyright = "Copyright © 1998-$((Get-Date).ToString('yyyy')) Mozilla Foundation"
$adr_nuspec = "https://raw.githubusercontent.com/proudcanadianeh/ChocoPackages/master/jre8/master/jre8.nuspec"
$adr_licenseacceptrequired = $false
$adr_rebootrequired = $false
$adr_category = "Internet"
$adr_xft = "mc"
$adr_locale = "au-syd1-07"
$adr_arch = "x86"
$adr_lcid = "MUI"
$adr_exectype = "exe"
$adr_followuri = 'https://javadl.oracle.com/webapps/download/AutoDL?BundleId=243737_61ae65e088624f5aaa0b1d2d801acb16'
$adr_absoluteuri = $null  # $null if not known
$adr_installswitches = "/s REBOOT=0 SPONSORS=0 AUTO_UPDATE=0"  # used for backwards compatability
$adr_displayname = $null  # OPTIONAL
$adr_geo = "au-syd1-07"
$adr_uninstallargs = "-ms"
