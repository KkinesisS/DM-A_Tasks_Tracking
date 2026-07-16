$paths = @(
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\build\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\build\app.html"
)

$target = @"
    document.getElementById('statAogCount').textContent = aogCount;
    document.getElementById('statActiveCount').textContent = activeCount;
    document.getElementById('statCompletedCount').textContent = completedCount;
"@

$replacement = @"
    const aogEl = document.getElementById('statAogCount');
    if (aogEl) aogEl.textContent = aogCount;
    
    const activeEl = document.getElementById('statActiveCount');
    if (activeEl) activeEl.textContent = activeCount;
    
    const completedEl = document.getElementById('statCompletedCount');
    if (completedEl) completedEl.textContent = completedCount;
"@

$normalizedTarget = $target -replace "`r`n", "`n"
$normalizedReplacement = $replacement -replace "`r`n", "`n"

foreach ($p in $paths) {
    if (Test-Path $p) {
        $content = Get-Content $p -Raw
        $normalizedContent = $content -replace "`r`n", "`n"
        
        if ($normalizedContent.Contains($normalizedTarget)) {
            $newContent = $normalizedContent.Replace($normalizedTarget, $normalizedReplacement)
            $newContent | Set-Content $p -NoNewline
            Write-Host "Updated script in $p"
        } else {
            Write-Host "Script block not found in $p"
        }
    }
}
