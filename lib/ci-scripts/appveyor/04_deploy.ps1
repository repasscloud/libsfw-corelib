# global variables
[System.String]$dataPath = Join-Path -Path $env:APPVEYOR_BUILD_FOLDER -ChildPath 'data'
[System.String]$dls = Join-Path -Path  $env:APPVEYOR_BUILD_FOLDER -ChildPath 'data\downloads'
[System.String]$jsd = Join-Path -Path  $env:APPVEYOR_BUILD_FOLDER -ChildPath 'data\json'
[System.String]$dll = Join-Path -Path $env:APPVEYOR_BUILD_FOLDER -ChildPath 'utils\DBUtils\DBUtils.UpdateAppsDB.exe'
[System.String]$cni = Join-Path -Path $env:APPVEYOR_BUILD_FOLDER -ChildPath 'utils\CreateNewIssue.exe'
[System.String]$copyrightSymbol = [System.Char]::convertfromutf32("0x00A9")
[System.String]$pattern = '[^a-zA-Z0-9\-\ ]'
[System.Array]$hklmPaths = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
    'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
)
$env:PATH += ';C:\mc\bin'

# which output encoding is being used
$OutputEncoding = New-Object -TypeName System.Text.UTF8Encoding
if ($OutputEncoding.EncodingName -eq "Unicode (UTF-8)")
{
    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) ENCODING: $($OutputEncoding.EncodingName)"
}
else
{
    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E0")) ENCODING: $($OutputEncoding.EncodingName)"
}

# internet user agent string
$userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer
Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) USER AGENT: ${userAgent}"

# Tls 1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) TLS VERSION: $([System.Net.SecurityProtocolType]::Tls12)"

# list of json files
[System.Array]$jsonFiles = Get-ChildItem -Path $jsd -Filter "*.json" -Recurse | Select-Object -ExpandProperty FullName

# main tasks
foreach ($jsonFile in $jsonFiles)
{
    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) USING JSON FILE: ${jsonFile}"

    # convert all data to object $j
    $j = Get-Content -Path $jsonFile | ConvertFrom-Json

    #region xml data ingest
    if ($j.meta.xml -ne '')
    {
        [System.Array]$returnedXmlMetaData = Read-XmlMetaFile -XmlURI $j.meta.xml
    }
    else
    {
        # meta data
        if ($null -ne $j.meta.projectUrl) { [System.String]$homepage = $j.meta.projectUrl } else { [System.String]$homepage = '' }
        if ($null -ne $j.meta.iconUrl) { [System.String]$icon = $j.meta.iconUrl } else { [System.String]$icon = '' }
        if ($null -ne $j.meta.copyright) { [System.String]$copyright = $j.meta.copyright } else { [System.String]$copyright = '' }
        if ($null -ne $j.meta.licenseUrl) { [System.String]$license = $j.meta.licenseUrl } else { [System.String]$license = '' }
        if ($null -ne $j.meta.docsUrl) { [System.String]$docs = $j.meta.docsUrl } else { [System.String]$docs = '' }
        if ($null -ne $j.meta.tags) { [System.String]$tags = $j.meta.tags } else { [System.String]$tags = '' }
        if ($null -ne $j.meta.summary) { [System.String]$summary = $j.meta.summary } else { [System.String]$summary = '' }

        [System.Array]$returnedXmlMetaData = @($homepage, $icon, $copyright, $license, $docs, $tags, $summary)
    }
    #endregion xml data ingest

    # meta data without prejudice
    [System.String]$category = $j.meta.category
    [System.Char]$rebootrequired = [System.Char]$rebootrequired = ([System.String]$j.meta.rebootrequired).SubString(0,1)
    [System.String]$depends = $j.meta.depends
    [System.String]$copyright = $returnedData[2] -replace $pattern, ''
    [System.String]$copyright = $copyright -replace 'Copyright', "Copyright ${copyrightSymbol}"
    [System.String]$copyright = $copyright -replace '  ', ' '

    # identity data
    [System.String]$name = $j.id.name
    [System.String]$version = $j.id.version
    [System.String]$publisher = $j.id.publisher
    [System.String]$arch = $j.id.arch
    [System.String]$uid = $j.id.uid
    [System.String]$lcid = $j.id.lcid

    # installer data
    [System.String]$app = $j.installer.app
    [System.String]$type = $j.installer.type
    [System.String]$filename = $j.installer.filename
    [System.String]$jsha256 = $j.installer.sha256
    [System.String]$followuri = $j.installer.followuri
    [System.String]$switches = $j.installer.switches
    [System.String]$displayname = $j.installer.displayname
    [System.String]$displayversion = $j.installer.displayversion
    [System.String]$displaypublisher = $j.installer.publisher
    [System.String]$uninstallstring = $j.installer.uninstallstring
    # [System.String]$uninstallStringVerbose = $j.installer.uninstallstring
    # 
    [System.String]$path = $j.installer.path
    [System.String]$s3repo = $j.installer.s3repo

    # web client and config, download, dispose, voila !@danijeljw-RPC
    Get-InstallerPackage -DLUri $followuri -DLFile $filename 

    # what is the file hash?
    [System.String]$sha256 = Read-FileHash -DLFile $filename

    # install application
    Install-ApplicationPackage -PackageName $app -InstallerType $type -FileName $filename -InstallSwitches $switches

    # set reg_src to datamatch, but only if a displayname was provided, else break loop
    if ($displayname -eq '' -or $null -eq $displayname)
    {
        Write-Output "Display name was not provided"
        exit 1
    }
    $reg_src = Get-RegistrySource -RegDisplayName $displayname 

    # set the uninstallstring values
    $uninstaller_class = Set-UninstallerClass -UninstallString $reg_src.UninstallString
    Write-Output "Uninstaller Type: $($uninstaller_class.ToUpper())"

    
    # set display version if not passed in
    if ($displayversion.Length -eq 0)
    {
        $displayversion = $reg_src.DisplayVersion
    }
    # set display publisher if not passed in
    if ($displaypublisher.length -eq 0)
    {
        $displaypublisher = $reg_src.Publisher
    }
    # set uninstall string if not passed in
    if ($uninstallstring.Length -eq 0)
    {
        $uninstallstring = $reg_src.UninstallString
    }

    # set detection method
    [System.String]$detect_method = "registry"

    # set detect value
    [System.String]$detect_value = $reg_src.PSPath.Replace("Microsoft.PowerShell.Core\Registry::","")

    # uninstall application (also verifies)
    Uninstall-ApplicationPackage -UninstallClass $uninstaller_class -UninstallString $uninstallstring -DisplayName $displayname -RebootRequired $rebootrequired


}
