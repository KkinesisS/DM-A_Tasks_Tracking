$paths = @(
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\build\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\build\app.html"
)

$startMarker = "<section class=`"stats-dashboard`">"
$endMarker = "</section>"

foreach ($p in $paths) {
    if (Test-Path $p) {
        $content = Get-Content $p -Raw
        $startIdx = $content.IndexOf($startMarker)
        if ($startIdx -ne -1) {
            $endIdx = $content.IndexOf($endMarker, $startIdx)
            if ($endIdx -ne -1) {
                $endIdx += $endMarker.Length
                # Find if there is any whitespace before the startMarker that should be removed
                $searchStart = $startIdx
                while ($searchStart -gt 0 -and ($content[$searchStart - 1] -eq ' ' -or $content[$searchStart - 1] -eq "`t" -or $content[$searchStart - 1] -eq "`n" -or $content[$searchStart - 1] -eq "`r")) {
                    $searchStart--
                }
                
                $newContent = $content.Substring(0, $searchStart) + "`r`n" + $content.Substring($endIdx)
                $newContent | Set-Content $p -NoNewline
                Write-Host "Removed stats dashboard from $p"
            }
        } else {
            Write-Host "Stats dashboard not found in $p"
        }
    }
}
