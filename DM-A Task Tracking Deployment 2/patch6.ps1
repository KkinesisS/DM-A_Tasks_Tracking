$paths = @(
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\build\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\build\app.html"
)

$target = @"
                        <div class="notification-footer" style="padding: 1rem 1.25rem; text-align: left; border-top: 1px solid var(--border-color);">
                            <a href="#" style="color: #3b82f6; font-size: 0.9rem; text-decoration: none; font-weight: 500;">View all notifications</a>
                        </div>
"@

$normalizedTarget = $target -replace "`r`n", "`n"

foreach ($p in $paths) {
    if (Test-Path $p) {
        $content = Get-Content $p -Raw
        $normalizedContent = $content -replace "`r`n", "`n"
        
        if ($normalizedContent.Contains($normalizedTarget)) {
            $newContent = $normalizedContent.Replace($normalizedTarget, "")
            $newContent | Set-Content $p -NoNewline
            Write-Host "Removed footer from $p"
        } else {
            Write-Host "Footer not found in $p"
        }
    }
}
