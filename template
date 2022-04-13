<#
.SYNOPSIS
  Script to <what will the script do>
.DESCRIPTION
  This script will <Elaborate on what the script does>
.PARAMETER Param1
  Specifies <What? Is the parameter required?>
.INPUTS
  <Does the script accept an input>
.OUTPUTS
  A log file in the temp directory of the user running the script
.NOTES
  Version:        0.1
  Author:         Sven de Windt
  Creation Date:  <Date>
  Purpose/Change: Initial script development
.EXAMPLE
  <Give multiple examples of the script if possible>
#>

#requires -version 3.0

#-----------------------------------------------------------[Parameters]-----------------------------------------------------------

param(
    [CmdletBinding()]
        [parameter(mandatory = $false)][String]$Param1
)
#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Set-StrictMode -Version Latest

# Set Error Action to Silently Continue
$ErrorActionPreference = "Stop"

# Dot Source required Function Libraries
#. "C:\Scripts\Functions\Logging_Functions.ps1"

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

#-----------------------------------------------------------[Finish up]------------------------------------------------------------
Write-Output $StopWatch.Elapsed
$StopWatch.Stop()
Write-Output "Finished script - $($MyInvocation.MyCommand.Name)"
Stop-Transcript
