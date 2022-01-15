[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$regex = "https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/continuous*"
$uri = "https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html"
$userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer

$d = [System.Collections.Specialized.OrderedDictionary]@{}
$d.id = [System.Collections.Specialized.OrderedDictionary]@{}
$d.id.installers = [System.Collections.Specialized.OrderedDictionary]@{}
$d.id.installers.x64 = [System.Collections.Specialized.OrderedDictionary]@{}
$d.id.installers.x86 = [System.Collections.Specialized.OrderedDictionary]@{}

$d.manifest = "4.3.8.10c"
$d.category = "productivity"
$d.id.name = "Reader DC"
$d.id.version = ((Invoke-WebRequest -Uri $uri -UserAgent $userAgent -UseBasicParsing).Links | Where-Object {$_.href -like $regex} | Where-Object -FilterScript {$_.outerHTML -match '^.*DC.*\(21.*'} | Select-Object -First 1).outerHTML -replace '.*([0-9]{2}\.[0-9]{3}\.[0-9]{5}).*','$1'
$d.id.publisher = "Adobe"
$d.id.arch = @("x86")
$d.id.uid = $d.id.publisher.ToLower().Replace(' ','') + "." + $d.id.name.ToLower().Replace(' ','') + '-' + $d.id.version
$d.id.xft = 'mc'
$d.id.locale = 'au-syd1-07'

$d.id.installers.x86.app = $d.id.publisher.ToLower().Replace(' ','') + "." + $d.id.name.ToLower().Replace(' ','')
$d.id.installers.x86.type = "exe"
$d.id.installers.x86.filename = "AcroRdrDC" + $d.id.version.Replace('.','') + "_MUI.exe"
$d.id.installers.x86.sha256 = ""
$d.id.installers.x86.followuri = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/" + $d.id.version.Replace('.','') + "/AcroRdrDC" + $d.id.version.Replace('.','') + "_MUI.exe"
$d.id.installers.x86.switches = "/sAll /msi /qn ALLUSERS=1 EULA_ACCEPT=YES DISABLEDESKTOPSHORTCUT=1"
$d.id.installers.x86.displayname = ""
$d.id.installers.x86.displayversion = ""
$d.id.installers.x86.publisher = ""
$d.id.installers.x86.uninstallstring = ""
$d.id.installers.x86.path =  $d.id.locale.ToLower() + '/' + $d.id.publisher.ToLower() + '/' + $d.id.name.ToLower() + '/' + $d.id.version + '/' + $d.id.arch + '/' + $d.id.installers.x86.filename

[System.String]$app_name = $d.id.publisher.ToLower().Replace(' ','') + "." + $d.id.name.ToLower().Replace(' ','')

$d | ConvertTo-Json -Depth 4 | Out-File -FilePath "${PSScriptRoot}\${app_name}.latest.json" -Encoding utf8 -Force -Confirm:$false
