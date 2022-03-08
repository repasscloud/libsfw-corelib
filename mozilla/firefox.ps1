<#
.SYNOPSIS
  Mozilla Firefox corelib.
.DESCRIPTION
  This script will execute summary activity for Mozilla Firefox. This is protected in the corelib branch.
.PARAMETER RegexUri
  Specifies URI to determine Mozilla Firefox version info.
.INPUTS
  n/a
.OUTPUTS
  A log file in the temp directory of the user running the script
.NOTES
  Version:        0.1
  Author:         RePass Cloud Pty Ltd
  Creation Date:  2022-02-14
  Purpose/Change: Initial script development
.EXAMPLE
  n/a
#>

#requires -version 3.0

#-----------------------------------------------------------[Parameters]-----------------------------------------------------------

param(
    [CmdletBinding()]
        [Parameter(Mandatory = $false)]
        [System.String]$RegexUri = 'https://www.mozilla.org/en-US/firefox/notes/',
        
        [Parameter(Mandatory = $false)]
        [System.String]$NuSpecXml = 'https://raw.githubusercontent.com/chocolatey-community/chocolatey-coreteampackages/master/automatic/firefox/firefox.nuspec'
)
#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Set-StrictMode -Version Latest

# Set Error Action to Silently Continue
$ErrorActionPreference = "Stop"

# Dot Source required Function Libraries
#. "C:\Scripts\Functions\Logging_Functions.ps1"

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$UserAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer

#----------------------------------------------------------[Declarations]----------------------------------------------------------

$LogNumber = Get-Date -UFormat "%Y-%m-%d@%H-%M-%S"
$Log = "$($env:TEMP)\$($MyInvocation.MyCommand.Name) $($LogNumber).log"
$ScriptVersion = "0.1"

#-----------------------------------------------------------[Functions]------------------------------------------------------------

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Start-Transcript -Path $Log -NoClobber
$StopWatch = New-Object System.Diagnostics.Stopwatch
$StopWatch.Start()
Write-Output "Start script - version $($ScriptVersion)"

<# ID #>
[System.String]$Publisher = ''
[System.String]$Name = ''
[System.Array]$Archs = @('x64','x86')
[System.Array]$LCID = @('en-US')

<# META #>
[System.String]$Version = ''
[System.String]$Category = 'browser'
[System.String]$CopyrightNotice = "Copyright © 1998-$((Get-Date).ToString('yyyy')) Mozilla Foundation"
[System.String]$License = ''

[System.String]$RebootRequired = 'no'
[System.String]$Depends = 'none'

[System.String]$Homepage = ''
[System.String]$IconURI = ''
[System.String]$Docs = ''
[System.String]$Tags = ''
[System.String]$Summary = ''

[System.String]$XFT = ''
[System.String]$Locale = ''


<# INSTALLER #>
[System.String]$App = ''
[System.Array]$Types = @('msi','exe')
[System.String]$FileName = ''
[System.String]$SHA256 = ''
[System.String]$
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



#-----------------------------------------------------------[Finish up]------------------------------------------------------------
Write-Output $StopWatch.Elapsed
$StopWatch.Stop()
Write-Output "Finished script - $($MyInvocation.MyCommand.Name)"
Stop-Transcript
