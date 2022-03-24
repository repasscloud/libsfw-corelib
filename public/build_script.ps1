[System.String[]]$SourceFiles = Get-ChildItem -Path .\data\corelib\ -Filter "*.ps1" -File -Recurse | Select-Object -ExpandProperty FullName
foreach ($sf in $SourceFiles)
{
    # dot source file
    . $sf

    <# GENERATE JSON MANIFEST #>
    Export-JsonManifest -Category $adr_category `
    -Publisher $adr_publisher `
    -Name $adr_name `
    -Version $adr_version `
    -Copyright $adr_copyright `
    -LicenseAcceptRequired $adr_licenseacceptrequired `
    -Arch $adr_arch `
    -ExecType $adr_exectype `
    -FollowUri $adr_followuri `
    -InstallSwitches $adr_installswitches `
    -DisplayName $adr_displayname `
    -UninstallArgs $adr_uninstallargs `
    -LCID $adr_lcid `
    -RebootRequired $adr_rebootrequired `
    -XFT $adr_xft `
    -Locale $adr_locale `
    -RepoGeo $adr_geo `
    -OutPath $PSScriptRoot `
    -NuspecUri $adr_nuspec

    Get-Content -Path $PSScriptRoot\*.json
}