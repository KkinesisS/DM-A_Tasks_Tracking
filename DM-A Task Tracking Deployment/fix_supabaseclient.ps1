$path = "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html"
$content = [System.IO.File]::ReadAllText($path)
$content = $content -replace '\} else if \(supabaseClient\) \{', '} else if (window.supabaseClient) {'
[System.IO.File]::WriteAllText($path, $content)
Write-Host "Replaced supabaseClient in index.html"

$path2 = "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html"
if (Test-Path $path2) {
    $content2 = [System.IO.File]::ReadAllText($path2)
    $content2 = $content2 -replace '\} else if \(supabaseClient\) \{', '} else if (window.supabaseClient) {'
    [System.IO.File]::WriteAllText($path2, $content2)
    Write-Host "Replaced supabaseClient in index2.html"
}
