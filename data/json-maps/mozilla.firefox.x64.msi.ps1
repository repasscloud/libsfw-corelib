<# PRELOAD - DO NOT EDIT #>
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer

<# APP SPECIFIC CODE - DO NOT EDIT #>
# no code

<# JSON DATA STRUCTURE - DO NOT EDIT #>
$d = [System.Collections.Specialized.OrderedDictionary]@{}
$d.meta = [System.Collections.Specialized.OrderedDictionary]@{}
$d.id = [System.Collections.Specialized.OrderedDictionary]@{}
$d.installer = [System.Collections.Specialized.OrderedDictionary]@{}
$d.uninstaller = [System.Collections.Specialized.OrderedDictionary]@{}
$d.sysinfo = [System.Collections.Specialized.OrderedDictionary]@{}

<# NUSPEC FILE - URI ONLY #>
$d.meta.xml = "https://raw.githubusercontent.com/chocolatey-community/chocolatey-coreteampackages/master/automatic/firefox/firefox.nuspec"

<# REGEX - ONLY IF REQUIRED ELSE DELETE #>
if (Test-Path -Path "$($env:TMP)\nuspec.xml") { Remove-Item -Path "$($env:TMP)\nuspec.xml" -Confirm:$false -Force }
$wc = New-Object System.Net.WebClient
$wc.Headers.Add("user-agent", $userAgent)
try
{
    $wc.DownloadFile($d.meta.xml, "$($env:TMP)\nuspec.xml")
    $wc.Dispose()
    [xml]$x = Get-Content -Path "$($env:TMP)\nuspec.xml"
    $version_regex = $x.package.metadata.version
    if (Test-Path -Path "$($env:TMP)\nuspec.xml") { Remove-Item -Path "$($env:TMP)\nuspec.xml" -Confirm:$false -Force }
}
catch
{
    Write-Output "Version info cannot be confirmed"
}
switch($version_regex -match ([System.Net.HttpWebRequest]::Create('https://www.mozilla.org/en-US/firefox/notes/').GetResponse().ResponseUri.AbsoluteUri).Split('/')[5])
{
    $true {
        $x.package.metadata.version = ([System.Net.HttpWebRequest]::Create('https://www.mozilla.org/en-US/firefox/notes/').GetResponse().ResponseUri.AbsoluteUri).Split('/')[5]
        $d.id.version = $x.package.metadata.version
    }
    default {
        $x.package.metadata.version = $version_regex
        $d.id.version = $version_regex
        "default value"
    }
}

<# NUSPEC PLACEHOLDER - DO NOT EDIT #>


$d.id.name = "Firefox"
$d.id.publisher = "Mozilla"
$d.id.arch = "x64"
$d.id.lcid = "en-US"

$d.installer.app = $d.id.publisher.ToLower().Replace(' ','') + "." + $d.id.name.ToLower().Replace(' ','')
$d.installer.type = "msi"
$d.installer.filename = "Firefox Setup " + $d.id.version + ".msi"
$d.installer.sha256 = ""
$d.installer.followuri = 'https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win64&lang=en-US'
$d.installer.switches = "/qn"       # used for backwards compatability
$d.installer.displayname = "Mozilla Firefox (x64 en-US)"  # OPTIONAL
$d.installer.displayversion = ""    # OPTIONAL
$d.installer.displaypublisher = ""  # OPTIONAL
$d.installer.path = "apps/" + $d.id.publisher + "/" + $d.id.name + "/" + $d.id.version + "/" + $d.id.arch + "/" + $d.installer.filename
$d.installer.geo = "au-syd1-07"

$d.uninstaller.string = ""
$d.uninstaller.args = "-ms"

<# UID ISO:1005 #>
$d.id.uid = $d.id.publisher.ToLower().Replace(' ','') + "." + $d.id.name.ToLower().Replace(' ','') + '-' + $d.id.version + '-' + $d.id.arch + '-' + $d.installer.type

<# DO NOT EDIT BELOW THIS LINE #>
$d.sysinfo = "4.4.0.1"
[System.String]$app_name = $d.id.publisher.ToLower().Replace(' ','') + "." + $d.id.name.ToLower().Replace(' ','')
[System.String]$app_version = $d.id.version
[System.String]$app_arch = $d.id.arch
[System.String]$app_exectype = $d.installer.type
[System.String]$data_path = Join-Path -Path $(Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'json'
$d | ConvertTo-Json -Depth 4 | Out-File -FilePath "${data_path}\${app_name}-${app_version}-${app_arch}-${app_exectype}.json" -Encoding utf8 -Force -Confirm:$false
<# DO NOT EDIT ABOVE THIS LINE #>

<# SPACE FOR NOTES#>
# Should not be installed with any other Firefox version.
# Requires a timeout between activities because it's Firefox :(
Start-Sleep -Seconds 10
