[System.String[]]$JsonFiles = Get-ChildItem -Path $PSScriptRoot\apps -Recurse -Filter "*.json" -File | Select-Object -ExpandProperty FullName

foreach ($json in $JsonFiles)
{
    $j = Get-Content -Path $json | ConvertFrom-Json

    [System.String]$Publisher = $j.id.publisher
    [System.String]$Name = $j.id.name
    [System.String]$Version = $j.id.version

    Write-Output "$([System.Char]::ConvertFromUTF32("0x1F7E2")) Testing install for: ${Publisher} ${Name} ${Version}"

    [System.String]$Arch = $j.id.arch
    
    $instObj = $j.id.installers.$Arch
    [System.String]$FollowUri = $instObj.followuri
    [System.String]$OutFile = $env:TEMP + '\' + $instObj.filename
    
    $userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("user-agent", $userAgent)
    $wc.DownloadFile($j.meta.xml, "${dls}\nuspec.xml")
    $wc.Dispose()
    
    # switch ($instObj.type)
    # {
    #     'exe'
    #     {
    #         Start-Process -FilePath $env:TEMP\$instObj.filename -ArgumentList $instObj.switches -Wait
    #     }
    #     Default
    #     {
    #         Write-Output "Unknown file type"
    #     }
    # }
}