$path = "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html"
$content = Get-Content $path -Raw
$target = 'id="notificationPanel" class="dropdown-content hidden" style="position: absolute; right: 0; top: 100%; margin-top: 0.5rem; background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 8px;'
$replacement = 'id="notificationPanel" class="dropdown-content hidden" style="position: absolute; right: 0; top: 100%; margin-top: 0.5rem; background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 16px;'

if ($content.Contains($target)) {
    $newContent = $content.Replace($target, $replacement)
    $newContent | Set-Content $path -NoNewline
    Write-Host "Replaced successfully!"
} else {
    Write-Host "Target not found!"
}
