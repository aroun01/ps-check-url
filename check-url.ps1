$url="google.com"






func WebRequest {

$validation = Invoke-WebRequest -Uri $url -UseDefaultCredentials -UseBasicParsing -Method Head -TimeoutSec 5 -ErrorAction Stop
$status = [int]$validation.StatusCode
Write-Output $status

}

WebRequest