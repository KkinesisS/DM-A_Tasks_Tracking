$bytes = [System.IO.File]::ReadAllBytes("C:\Users\KkinesisS\Desktop\THA\DM-A_App\DM-A Task Tracking Deployment\dma_logo_clean_transparent.png")
$b64 = [System.Convert]::ToBase64String($bytes)
$dataUri = "data:image/png;base64," + $b64
[System.IO.File]::WriteAllText("C:\Users\KkinesisS\Desktop\THA\DM-A_App\DM-A Task Tracking Deployment\dma_logo_clean_b64.txt", $dataUri)
Write-Host "Base64 transparent logo saved! Length: $($dataUri.Length)"
