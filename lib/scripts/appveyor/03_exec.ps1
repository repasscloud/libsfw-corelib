# global variables
[System.String]$rootPath = 'C:\Projects\libsfw'
[System.String]$dataPath = Join-Path -Path $rootPath -ChildPath 'data'
[System.String]$dls = Join-Path -Path $dataPath -ChildPath 'downloads'
[System.String]$dll = Join-Path -Path $rootPath -ChildPath 'DBUtils\UpdateAppsDB.exe'
[System.String]$cni = Join-Path -Path $rootPath -ChildPath 'GHUtils\NewIssues\CreateNewIssue.exe'
[System.String]$copyrightSymbol = [System.Char]::convertfromutf32("0x00A9")
[System.String]$pattern = '[^a-zA-Z0-9\-\ ]'
[System.Array]$hklmPaths = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
    'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
)

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
[System.Array]$jsonFiles = Get-ChildItem -Path $env:APPVEYOR_BUILD_FOLDER -Filter "*.json" -Recurse | Select-Object -ExpandProperty FullName

foreach ($jsonFile in $jsonFiles)
{
    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) USING JSON FILE: ${jsonFile}"

    # convert all data to object $j
    $j = Get-Content -Path $jsonFile | ConvertFrom-Json

    #region xml data ingest
    if ($j.meta.xml -ne '')
    {
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("user-agent", $userAgent)
        if (Test-Path -Path "${dls}\nuspec.xml") { Remove-Item -Path "${dls}\nuspec.xml" -Confirm:$false -Force }

        try {
            $wc.DownloadFile($j.meta.xml, "${dls}\nuspec.xml")
            $wc.Dispose()

            [xml]$x = Get-Content -Path "${dls}\nuspec.xml"

            # meta data
            [System.String]$homepage = $x.package.metadata.projectUrl
            [System.String]$icon = $x.package.metadata.iconUrl
            [System.String]$copyright = $x.package.metadata.copyright
            [System.String]$license = $x.package.metadata.licenseUrl
            [System.String]$docs = $x.package.metadata.docsUrl
            [System.String]$tags = $x.package.metadata.tags
            [System.String]$summary = $x.package.metadata.summary

            Remove-Item -Path "${dls}\nuspec.xml" -Confirm:$false -Force
        }
        catch {
            $wc.Dispose()

            # meta data
            [System.String]$homepage = $j.meta.homepage
            [System.String]$icon = $j.meta.iconuri
            [System.String]$copyright = $x.package.metadata.copyright
            [System.String]$license = $j.meta.license
            [System.String]$docs = $j.meta.docs
            [System.String]$tags = $j.meta.tags
            [System.String]$summary = $j.meta.summary
        }
    }
    else
    {
        # meta data
        [System.String]$homepage = $j.meta.homepage
        [System.String]$icon = $j.meta.iconuri
        [System.String]$copyright = $x.package.metadata.copyright
        [System.String]$license = $j.meta.license
        [System.String]$docs = $j.meta.docs
        [System.String]$tags = $j.meta.tags
        [System.String]$summary = $j.meta.summary
    }
    #endregion xml data ingest

    # meta data without prejudice
    [System.String]$category = $j.meta.category
    [System.String]$rebootrequired = $j.meta.rebootrequired
    [System.String]$depends = $j.meta.depends
    [System.String]$copyright = $copyright -replace $pattern, ''
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

    # locale to download the installer to
    [System.String]$download_path = Join-Path -Path $dls -ChildPath $filename

    # web client and config, download, dispose, voila !@danijeljw-RPC
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("user-agent", $userAgent)
    [System.Console]::WriteLine("Downloading file: {0}", $followuri)
    try
    {
        $wc.DownloadFile($followuri, $download_path)
        Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) FILE DOWNLOADED TO: ${download_path}"
        $wc.Dispose()
    }
    catch
    {
        $wc.Dispose()
        Write-Output "$([char]::ConvertFromUTF32("0x1F534")) DOWNLOAD FAILED FOR FILE: ${followuri}"
        Write-Output "$([char]::ConvertFromUTF32("0x1F7E0")) APPLICATION NAME: ${app}"
        continue   #ref: https://stackoverflow.com/a/654126/15157918
    }

    # what is the file hash?
    [System.String]$shahash = (Get-FileHash -Path $download_path -Algorithm SHA256).Hash
    if ($sha256 -ne ""-and $shahash -eq $sha256)
    {
        Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) VERIFIED SHA256 PROVIDED: ${shahash}"
    }
    elseif ($sha256 -ne "" -and $shahash -ne $sha256)
    {
        Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E0")) SHA256 PROVIDED NOT MATCHED"
        Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) SHA256 UPDATED: ${shahash}"
    }
    else
    {
        Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) VERIFIED SHA256: ${shahash}"
    }

    # install application
    switch ($type)
    {
        "exe"
        {
            Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) INSTALLER TYPE: ${type}"
            Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) INSTALLING APPLICATION: ${app}"
            try
            {
                Start-Process -FilePath $download_path -ArgumentList $switches -Wait -ErrorAction Stop
                Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) INSTALLED ${app} SUCCESSFULLY"
            }
            catch
            {
                Write-Output "$([char]::ConvertFromUTF32("0x1F534")) ${app} NOT INSTALLED"
                exit 1
            }
        }
        "msi"
        {
            Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) INSTALLER TYPE: ${type}"
            Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) INSTALLING APPLICATION: ${app}"
            try
            {
                Start-Process -FilePath msiexec -ArgumentList "/i ${download_path} ${switches}" -Wait -ErrorAction Stop
                Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) ${app} INSTALLED SUCCESSFULLY"
            }
            catch
            {
                Write-Output "$([char]::ConvertFromUTF32("0x1F534")) ${app} NOT INSTALLED"
                exit 1
            }
        }
        Default
        {
            Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E0")) INSTALLER TYPE: $UNKNOWN"
            Write-Output "$([char]::ConvertFromUTF32("0x1F534")) ${app} NOT INSTALLED"
            exit 1
        }
    }

    # generate installed app comparisons
    [System.Array]$hklmPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    )
    $old = Import-Csv -Path $env:TMP\app_list.csv | Select-Object -ExpandProperty DisplayName
    $current = Get-ChildItem -Path $hklmPaths | Get-ItemProperty | Where-Object -FilterScript {$null -notlike $_.DisplayName -and $_.DisplayName -notlike 'Microsoft Azure Libraries for .NET – v2.9'} | Select-Object -ExpandProperty DisplayName

    # find newly installed app
    foreach ($i in $current)
    {
        if ($old -notcontains $i)
        {
            $reg_src = Get-ChildItem -Path $hklmPaths | Get-ItemProperty | Where-Object -FilterScript {$_.DisplayName -like $i} | Select-Object -Property *
        }
    }

    #$reg_src  #this prints the registry information to the screen
    if ($reg_src)
    {
        # set installer class (this doesn't represent the file type for installing!)
        switch ($reg_src.UninstallString)
        {
            # msi/msix
            {$_ -match 'MsiExec.exe /[IX]{[0-9A-Z]{8}-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{12}}'}
            {
                [System.String]$installer_class = "msi"
            }
            # inno installer
            {$_ -match '^".*unins[0-9]{3}\.exe"$'}
            {
                [System.String]$installer_class = "inno"
            }
            # inno installer 2
            {$_ -match '^.*unins[0-9]{3}\.exe$'}
            {
                [System.String]$installer_class = "inno"
            }
            # std installer
            {$_ -match '^.*\.exe$'}
            {
                [System.String]$installer_class = "exe"
            }
            # unknown installer
            Default
            {
                [System.String]$installer_class = "other"
                # have not found what 'ClickOnce' is represented by yet, may need to move this to the json file
            }
        }
    }

    # set display name if not passed in
    if ($displayname.Length -eq 0)
    {
        $displayname = $reg_src.DisplayName
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

    <# VERBOSE TEST #>
    "--uid $uid --key $app --latest --publisher $publisher --name $name --version $version " +
            "--category $category --arch $arch --exec-type $type --filename $filename --sha256 $shahash --follow-uri $followuri " +
            "--install-switches $switches --display-name $displayname --display-version $displayversion " +
            "--display-publisher $displaypublisher --uninstall-string $uninstallstring " +
            "--detect-method $detect_method --detect-value $detect_value --installer-class $installer_class --path $path " +
            "--homepage $homepage --icon $icon --copyright $copyright --license $license --docs $docs --tags $tags " +
            "--summary $summary --rebootrequired $rebootrequired --depends $depends --lcid $lcid"
    <# END VERBOSE TEST #>

    # uninstall application
    # switch ($installer_class)
    # {
    #     'msi' {
    #         $uarg =  $uninstallstring.Replace('MsiExec.exe /I','').Replace('MsiExec.exe /X','') 
    #         try {
    #             Start-Process -FilePath msiexec -ArgumentList '/X',$uarg,'/qn' -Wait -ErrorAction Stop
    #             Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) UNINSTALLED: ${displayname}"
    #         }
    #         catch {
    #             Write-Output "$([System.Char]::ConvertFromUTF32("0x1F534")) DID NOT UNINSTALL: ${displayname}"
    #         }
    #     }
    # }

    # # verify uninstalled
    # if ($null -like (Get-ChildItem -Path $hklmPaths | Get-ItemProperty | Where-Object -FilterScript {$_.DisplayName -like $displayname}))
    # {
    #     Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) UNINSTALLED: ${displayname}"
    # } else {
    #     Get-ChildItem -Path $hklmPaths | Get-ItemProperty | Where-Object -FilterScript {$_.DisplayName -like $displayname}
    # }
}
