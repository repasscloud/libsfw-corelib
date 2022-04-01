
$headers = @{
    accept = "text/plain"
}
try
{
    Invoke-RestMethod -Uri 'https://engine.api.dev.optechx-data.com/api/application/adobe::acrobatreaderdc::22.001.20085::x64::exe::MU' -Method Get -Headers $headers -ErrorAction Stop
}
catch
{
    "not found"
}