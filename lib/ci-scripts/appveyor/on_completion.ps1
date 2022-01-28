# variables
[System.String]$RepoUri = 'https://github.com/repasscloud/libsfw'
[System.String]$IssueTitle = "AppVeyor CI Pipeline Complete $((Get-Date).ToString('yyyyMMddHHmm'))"
[System.String]$IssueBody = 'AppVeyor CI pipeline has completed successfully. No action required.'
[System.String]$IssueTag = 'ci-appveyor-complete'


# install PowerShellForGitHub (PSFGH)
Install-Module -Name PowerShellForGitHub

# configure PSFGH
$secureString = ($env:GH_POST_API_ATKN | ConvertTo-SecureString -AsPlainText -Force)
$cred = New-Object System.Management.Automation.PSCredential "username is ignored", $secureString
Set-GitHubAuthentication -Credential $cred -SessionOnly
Set-GitHubConfiguration -DisableTelemetry
$secureString = $null # clear this out now that it's no longer needed
$cred = $null # clear this out now that it's no longer needed

# Get your repo
$repo = Get-GitHubRepository -Uri $RepoUri

# Create an issue
$issue = $repo | New-GitHubIssue -Title $IssueTitle -Body $IssueBody -Label $IssueTag

# Close issue
$issue | Set-GitHubIssue -State Closed
