function New-VirusTotalScan {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)][System.String]$SHA256,
        [Parameter(Mandatory=$false)][System.String]$FileName
    )
    begin {
        $VTHeaders = [System.Collections.Specialized.OrderedDictionary]@{}
        $VTHeaders.Authorization = "Basic dXNlck5hbWU6cGFzc3dvcmQ="
        $VTHeaders.Add("Accept", "application/json")
        $VTHeaders.Add("x-apikey", "30f77c3ea3d5f9d5037d17930dee009bd634f8387485655e8901bbfa9fe27bc4")
    }
    process {
        if ($FileName)
        {
            $SHA256 = Get-FileHash -Path $FileName -Algorithm SHA256 | Select-Object -ExpandProperty Hash
        }
        else
        {
            $FileName = "NOT PROVIDED"
        }
        $VTResponse = Invoke-RestMethod -Uri "https://www.virustotal.com/api/v3/files/${SHA256}" -Headers $VTHeaders
        $aly_sts = $VTResponse.data.attributes.last_analysis_stats
        $aly_ttl = $aly_sts.'harmless' + $aly_sts.'type-unsupported' + $aly_sts.'suspicious' + $aly_sts.'confirmed-timeout' + $aly_sts.'timeout' + $aly_sts.'failure' + $aly_sts.'malicious' + $aly_sts.'undetected'
        $aly_safety_percentage = [System.Int32]((($aly_sts.'harmless' + $aly_sts.'undetected')/$aly_ttl) * 100)
        $Payload = [System.Collections.Specialized.OrderedDictionary]@{}
        $Payload.id = 0
        $Payload.uuid = [System.Guid]::NewGuid()
        $Payload.hash_Scanned = $SHA256
        $Payload.filename = $FileName
        $Payload.tlsh = $VTResponse.data.attributes.tlsh
        $Payload.vhash = $VTResponse.data.attributes.vhash
        $Payload.statsHarmless = $aly_sts.'harmless'
        $Payload.statsTypeUnsupported = $aly_sts.'type-unsupported'
        $Payload.statsSuspicious = $aly_sts.'suspicious'
        $Payload.statsConfirmedTimeout = $aly_sts.'confirmed-timeout'
        $Payload.statsTimeout = $aly_sts.'timeout'
        $Payload.statsFailure = $aly_sts.'failure'
        $Payload.statsMalicious = $aly_sts.'malicious'
        $Payload.statsUndetected = $aly_sts.'undetected'
        $Payload.statsTotal_Count = $aly_ttl
        $Payload.statsSafetyPercentage = [System.Int32]((($aly_sts.'harmless' + $aly_sts.'undetected')/$aly_ttl) * 100)
        $Payload.isSafe = if ($aly_safety_percentage -gt 70){ $true } else { $false }
        $JSON = $Payload | ConvertTo-Json -Depth 4
        $JSON
    }
    end {
        [System.Gc]::Collect()
    }
}