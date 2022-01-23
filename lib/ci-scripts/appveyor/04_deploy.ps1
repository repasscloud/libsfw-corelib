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
        [System.Array]$returnedData = Read-XmlMetaFile -XmlURI $j.meta.xml
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

        [System.Array]$returnedData = @($homepage, $icon, $copyright, $license, $docs, $tags, $summary)
    }
    #endregion xml data ingest

    # meta data without prejudice
    [System.String]$category = $j.meta.category
    [System.String]$rebootrequired = $j.meta.rebootrequired
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
    [System.String]$sha256 = $j.installer.sha256
    [System.String]$followuri = $j.installer.followuri
    [System.String]$switches = $j.installer.switches
    [System.String]$displayname = $j.installer.displayname
    [System.String]$displayversion = $j.installer.displayversion
    [System.String]$displaypublisher = $j.installer.publisher
    [System.String]$uninstallstring = $j.installer.uninstallstring
    [System.String]$uninstallStringVerbose = $j.installer.uninstallstring
    [System.String]$path = $j.installer.path
    [System.String]$s3repo = $j.installer.s3repo

    # locale to download the installer to
    [System.String]$download_path = Join-Path -Path $dls -ChildPath $filename

    # web client and config, download, dispose, voila !@danijeljw-RPC
    Get-InstallerPackage -DLUri $followuri -DLFile $filename 

    # what is the file hash?
    [System.String]$shahash = Read-FileHash -DLFile $filename

    # install application
    Install-ApplicationPackage -PackageName $app -InstallerType $type -FileName $filename -InstallSwitches $switches
    

    # does the displayname already exist from JSON?
    if ($displayname.Length -eq 0)
    {
        # generate installed app comparisons
        $old = Import-Csv -Path $env:TMP\app_list.csv | Select-Object -ExpandProperty DisplayName
        $current = Get-ChildItem -Path $hklmPaths | Get-ItemProperty | Where-Object -FilterScript {$null -notlike $_.DisplayName -and $_.DisplayName -notlike 'Microsoft Azure Libraries for .NET – v2.9'} | Select-Object -ExpandProperty DisplayName

        # find newly installed app
        foreach ($i in $current)
        {
            if ($old -notcontains $i)
            {
                # grab the info
                $reg_src_lookup = Get-ChildItem -Path $hklmPaths | Get-ItemProperty | Where-Object -FilterScript {$_.DisplayName -like $i} | Select-Object -Property *
                
                # output the data for verbosity and manual checking
                $reg_src_lookup
            }
        }

        # return to start of loop, needs to be manually added
        return
    }

    # set reg_src to datamatch
    $reg_src = Get-ChildItem -Path $hklmPaths | Get-ItemProperty | Where-Object -FilterScript {$_.DisplayName -like $displayname} | Select-Object -Property *

    #$reg_src  #this prints the registry information to the screen
    if ($reg_src)
    {
        # set installer class (this doesn't represent the file type for installing!)
        switch ($reg_src.UninstallString)
        {
            # msi/msix
            {$_ -match 'MsiExec.exe /[IX]{[0-9A-Z]{8}-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{12}}'}
            {
                [System.String]$uninstaller_class = "msi"
                Write-Output "Uninstaller Type: MSI"
            }
            # inno installer
            {$_ -match '^".*unins[0-9]{3}\.exe"$'}
            {
                [System.String]$uninstaller_class = "inno"
                Write-Output "Uninstaller Type: INNO"
            }
            # inno installer 2
            {$_ -match '^.*unins[0-9]{3}\.exe$'}
            {
                [System.String]$uninstaller_class = "inno"
                Write-Output "Uninstaller Type: INNO"
            }
            # std installer
            {$_ -match '^.*\.exe$'}
            {
                [System.String]$uninstaller_class = "exe"
                Write-Output "Uninstaller Type: EXE"
            }
            # exe installer 2
            {$_ -match '^.*\.exe"$'}
            {
                [System.String]$uninstaller_class = "exe"
                Write-Output "Uninstaller Type: EXE"
            }
            # unknown installer
            Default
            {
                [System.String]$uninstaller_class = "other"
                Write-Output "Uninstaller Type: OTHER"
                # have not found what 'ClickOnce' is represented by yet, may need to move this to the json file
            }
        }
    }

    
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

    # uninstall application
    switch ($uninstaller_class)
    {
        'msi' {
            if ($uninstallstring -match 'MsiExec.exe /I.*') {$uarg = $uninstallstring.Replace('MsiExec.exe /I', '') }
            if ($uninstallstring -match 'MsiExec.exe /X.*') {$uarg = $uninstallstring.Replace('MsiExec.exe /X', '') }
            try {
                Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E1")) START UNINSTALL: ${displayname}"
                Start-Process -FilePath msiexec -ArgumentList "/X ${uarg} /q" -Wait -ErrorAction Stop
                Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) UNINSTALLED: ${displayname}"
            }
            catch {
                Write-Output "$([System.Char]::ConvertFromUTF32("0x1F534")) DID NOT UNINSTALL: ${displayname}"
            }
        }
        'exe' {
            try {
                Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E1")) START UNINSTALL: ${displayname}"
                Start-Process -FilePath $uninstallstring -ArgumentList "${switches}" -Wait -ErrorAction Stop
                Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) UNINSTALLED: ${displayname}"
            }
            catch {
                Write-Output "$([System.Char]::ConvertFromUTF32("0x1F534")) DID NOT UNINSTALL: ${displayname}"
            }
        }
    } 


    # verify uninstalled
    if ($null -notlike (Get-ChildItem -Path $hklmPaths | Get-ItemProperty | Where-Object -FilterScript {$_.DisplayName -like $displayname}))
    {
        Get-ChildItem -Path $hklmPaths | Get-ItemProperty | Where-Object -FilterScript {$_.DisplayName -like $displayname}        
    }
    else
    {
        Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) UNINSTALLED: ${displayname}"
    }

    # write data to sql library
    try
    {
        $UpdateAppsDBOutput = & $dll --uid $uid --key $app --latest --publisher $publisher --name $name --version $version `
            --category $category --arch $arch --exec-type $type --filename $filename --sha256 $shahash --follow-uri $followuri `
            --install-switches $switches --display-name $displayname --display-version $displayversion `
            --display-publisher $displaypublisher --uninstall-string $uninstallstring `
            --detect-method $detect_method --detect-value $detect_value --installer-class $installer_class --path $path `
            --homepage $homepage --icon $icon --copyright $copyright --license $license --docs $docs --tags $tags `
            --summary $summary --rebootrequired $rebootrequired --depends $depends --lcid $lcid `
            --csHost $env:APPS_CS_HOST --csDB apps_db --csUsr $env:APPS_CS_USR --csPK $env:APPS_CS_PK
        
        switch ($UpdateAppsDBOutput)
        {
            0
            {
                Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) RECORD CREATED: ${uid}"
                if (Test-Path -Path $download_path) { Remove-Item -Path $download_path -Confirm:$false -Force }
            }
            1
            {
                Write-Output "$([char]::ConvertFromUTF32("0x1F7E0")) RECORD EXISTS: ${uid}"
                #& $cni $env:GH_API $env:GH_USER $env:GH_REPO "record exists999" "this was created by api"
                if (Test-Path -Path $download_path) { Remove-Item -Path $download_path -Confirm:$false -Force }
            }
            Default
            {
                Write-Output "$([char]::ConvertFromUTF32("0x1F534")) UNHANDLED EXCEPTION: ${uid}"
                if (Test-Path -Path $download_path) { Remove-Item -Path $download_path -Confirm:$false -Force }
                [System.String]$timeStamp = (Get-Date).ToString("yyyy-MM-dd HH:mm")
                [System.String]$errorBodyText = @"
Payload:
``````powershell
--uid $uid --key $app --latest --publisher $publisher --name $name --version $version
--category $category --arch $arch --exec-type $type --filename $filename --sha256 $shahash --follow-uri $followuri
--install-switches $switches --display-name $displayname --display-version $displayversion
--display-publisher $displaypublisher --uninstall-string $uninstallstring
--detect-method $detect_method --detect-value $detect_value --installer-class $installer_class --path $path
--homepage $homepage --icon $icon --copyright $copyright --license $license --docs $docs --tags $tags
--summary $summary --rebootrequired $rebootrequired --depends $depends --lcid $lcid
``````
TimeStamp: ${timeStamp}
"@
                #& $cni $env:GH_API $env:GH_USER $env:GH_REPO "tbl_appdata ingest error: ${uid}" $errorBodyText
                break  # break the loop on this item and move to the next one
            }
        }
    }
    catch
    {
        Write-Output "$([System.Char]::ConvertFromUtf32("0x1F534")) UNABLE TO CREATE SQL RECORD: ${app}"
        if (Test-Path -Path $download_path) { Remove-Item -Path $download_path -Confirm:$false -Force }
    }

    <# VERBOSE TEST #>
    "--uid $uid --key $app --latest --publisher $publisher --name $name --version $version " +
    "--category $category --arch $arch --exec-type $type --filename $filename --sha256 $shahash --follow-uri $followuri " +
    "--install-switches $switches --display-name $displayname --display-version $displayversion " +
    "--display-publisher $displaypublisher --uninstall-string $uninstallstring " +
    "--detect-method $detect_method --detect-value $detect_value --installer-class $uninstaller_class --path $path " +
    "--homepage $homepage --icon $icon --copyright $copyright --license $license --docs $docs --tags $tags " +
    "--summary $summary --rebootrequired $rebootrequired --depends $depends --lcid $lcid " +
    " --csHost $env:APPS_CS_HOST --csDB apps_db --csUsr $env:APPS_CS_USR --csPK $env:APPS_CS_PK"
    <# END VERBOSE TEST #>

    # upload to S3
    try
    {
        Start-Process -FilePath mc -ArgumentList "mb","${s3repo}/apps" -Wait -ErrorAction Stop
        Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) BUCKET CREATED: ${s3repo}/apps"
    }
    catch
    {
        Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E1")) BUCKET EXISTS: ${s3repo}/apps"
    }
    mc cp "${download_path}" "${s3repo}/${path}"
}
