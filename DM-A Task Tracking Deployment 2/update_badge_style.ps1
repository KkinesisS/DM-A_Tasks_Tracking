$paths = @(
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html"
)

$oldStyle = 'style="position: absolute; top: -5px; right: -5px; min-width: 16px; height: 16px; display: flex; align-items: center; justify-content: center; font-size: 10px; font-weight: bold; color: white; background-color: var(--priority-aog); border-radius: 8px; padding: 0 4px; box-sizing: border-box; border: 1.5px solid var(--bg-card);"'
$newStyle = 'style="position: absolute; top: -6px; right: -6px; min-width: 20px; height: 20px; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 600; color: white; background-color: #ef4444; border-radius: 10px; padding: 0 4px; box-sizing: border-box; box-shadow: 0 1px 3px rgba(0,0,0,0.2);"'

foreach ($path in $paths) {
    if (Test-Path $path) {
        $content = [System.IO.File]::ReadAllText($path)
        
        # Replace only if the old style is found
        if ($content.Contains($oldStyle)) {
            $content = $content.Replace($oldStyle, $newStyle)
            [System.IO.File]::WriteAllText($path, $content)
            Write-Host "Replaced successfully in $($path)"
        } else {
            Write-Host "Old style not found in $($path)"
        }
    }
}
