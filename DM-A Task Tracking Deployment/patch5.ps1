$appJsPath = "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\app.js"
$appJsContent = Get-Content $appJsPath -Raw

$startMarker = "listEl.innerHTML = topActivities.map(act => {"
$endMarker = "    }).join('');"

$startIdx = $appJsContent.IndexOf($startMarker)
$endIdx = $appJsContent.IndexOf($endMarker, $startIdx) + $endMarker.Length

$goodBlock = $appJsContent.Substring($startIdx, $endIdx - $startIdx)

$paths = @(
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\build\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\build\app.html"
)

foreach ($p in $paths) {
    if (Test-Path $p) {
        $content = Get-Content $p -Raw
        $pStartIdx = $content.IndexOf($startMarker)
        
        if ($pStartIdx -ne -1) {
            $pEndIdx = $content.IndexOf($endMarker, $pStartIdx) + $endMarker.Length
            if ($pEndIdx -gt $pStartIdx) {
                $newContent = $content.Substring(0, $pStartIdx) + $goodBlock + $content.Substring($pEndIdx)
                $newContent | Set-Content $p -NoNewline
                Write-Host "Fixed $p"
            }
        } else {
            Write-Host "Could not find block in $p"
        }
    }
}
