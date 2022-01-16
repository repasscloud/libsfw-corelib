[System.String[]]$JsonFiles = Get-ChildItem -Path $PSScriptRoot\apps -Recurse -Filter "*.json" -File | Select-Object -ExpandProperty FullName

foreach ($json in $JsonFiles)
{
    

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