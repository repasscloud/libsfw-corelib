<# PRELOAD - DO NOT EDIT #>
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer

<# APP SPECIFIC CODE - DO NOT EDIT #>
$adr_regex = "https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/continuous*"
$adr_uri = "https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html"
$adr_userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer

<# JSON DATA STRUCTURE - DO NOT EDIT #>
$d = [System.Collections.Specialized.OrderedDictionary]@{}
$d.meta = [System.Collections.Specialized.OrderedDictionary]@{}
$d.id = [System.Collections.Specialized.OrderedDictionary]@{}
$d.installer = [System.Collections.Specialized.OrderedDictionary]@{}
$d.sysinfo = [System.Collections.Specialized.OrderedDictionary]@{}

<# NUSPEC FILE - URI ONLY #>
$d.meta.xml = "https://raw.githubusercontent.com/open-circle-ltd/chocolatey.adobe-acrobat-reader-dc/master/package/adobereader.nuspec"

<# REGEX - ONLY IF REQUIRED ELSE DELETE #>
$wc = New-Object System.Net.WebClient
$wc.Headers.Add("user-agent", $userAgent)
try
{
    $wc.DownloadFile($d.meta.xml, "$($env:TMP)\nuspec.xml")
    $wc.Dispose()
    [xml]$x = Get-Content -Path "$($env:TMP)\nuspec.xml"
    $version_regex = $x.package.metadata.version
    Remove-Item -Path "$($env:TMP)\nuspec.xml" -Confirm:$false -Force
}
catch
{
    Write-Output "Version info cannot be confirmed"
}
if (-not($version_regex -match (((Invoke-WebRequest -Uri $adr_uri -UserAgent $adr_userAgent -UseBasicParsing).Links | Where-Object {$_.href -like $adr_regex} | Where-Object -FilterScript {$_.outerHTML -match '^.*DC.*\(21.*'} | Select-Object -First 1).outerHTML -replace '.*([0-9]{2}\.[0-9]{3}\.[0-9]{5}).*','$1')))
{
    $x.package.metadata.version = ((Invoke-WebRequest -Uri $adr_uri -UserAgent $adr_userAgent -UseBasicParsing).Links | Where-Object {$_.href -like $adr_regex} | Where-Object -FilterScript {$_.outerHTML -match '^.*DC.*\(21.*'} | Select-Object -First 1).outerHTML -replace '.*([0-9]{2}\.[0-9]{3}\.[0-9]{5}).*','$1'
    $d.id.version = $x.package.metadata.version
}
else
{
    $x.package.metadata.version = $version_regex
    $d.id.version = $version_regex
}

<# NUSPEC PLACEHOLDER - DO NOT EDIT #>
$d.meta.homepage = ""
$d.meta.iconuri = ""
$d.meta.copyright = ""
$d.meta.license = ""
$d.meta.docs = ""
$d.meta.tags = ""
$d.meta.summary = ""
$d.meta.version = ""

<# META EDITS - UPDATE AS REQUIRED #>
$d.meta.rebootrequired = "No"        # 'YES' or 'NO' only
$d.meta.depends = "None"             # Any depedencies
$d.meta.category = "productivity"         # Category name in lower case only
$d.meta.xft = 'mc'
$d.meta.locale = 'au-syd1-07'

$d.id.name = "Reader DC"
$d.id.publisher = "Adobe"
$d.id.arch = "x86"
$d.id.lcid = "MUI"

$d.installer.app = $d.id.publisher.ToLower().Replace(' ','') + "." + $d.id.name.ToLower().Replace(' ','')
$d.installer.type = "exe"
$d.installer.filename = "AcroRdrDC" + $d.id.version.Replace('.','') + "_MUI.exe"
$d.installer.sha256 = ""
$d.installer.followuri = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/" + $d.id.version.Replace('.','') + "/AcroRdrDC" + $d.id.version.Replace('.','') + "_MUI.exe"
$d.installer.switches = "/sAll /msi /qn ALLUSERS=1 EULA_ACCEPT=YES DISABLEDESKTOPSHORTCUT=1"       # used for backwards compatability
$d.installer.displayname = ""       # OPTIONAL
$d.installer.displayversion = ""    # OPTIONAL
$d.installer.displaypublisher = ""  # OPTIONAL
$d.installer.uninstallstring = ""
$d.installer.path = $d.id.publisher + '/' + $d.id.name + '/' + $d.id.version + '/' + $d.id.arch + '/' + $d.installer.filename

<# UID ISO:1005 #>
$d.id.uid = $d.id.publisher.ToLower().Replace(' ','') + "." + $d.id.name.ToLower().Replace(' ','') + '-' + $d.id.version + '-' + $d.id.arch + '-' + $d.installer.type

<# DO NOT EDIT BELOW THIS LINE #>
$d.sysinfo = "4.3.8.10C"
[System.String]$app_name = $d.id.publisher.ToLower().Replace(' ','') + "." + $d.id.name.ToLower().Replace(' ','')
[System.String]$app_version = $d.id.version
[System.String]$app_arch = $d.id.arch
[System.String]$app_exectype = $d.installer.type
[System.String]$data_path = Join-Path -Path $(Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'json'
$d | ConvertTo-Json -Depth 4 | Out-File -FilePath "${data_path}\${app_name}-${app_version}-${app_arch}-${app_exectype}.json" -Encoding utf8 -Force -Confirm:$false
<# DO NOT EDIT ABOVE THIS LINE #>

<# SPACE FOR NOTES#>
# Converted from 3.x