$paths = @(
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html"
)

$oldHtml = 'style="width: 36px; height: 36px; border-radius: 50%; background: #3b82f6; color: white; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; font-weight: 600; font-family: var(--font-body); cursor: default; flex-shrink: 0; margin-left: 0.75rem; text-transform: uppercase;"'
$newHtml = 'style="min-width: 36px; min-height: 36px; max-width: 36px; max-height: 36px; width: 36px; height: 36px; border-radius: 50%; background: #3b82f6; color: white; display: flex; align-items: center; justify-content: center; font-size: 16px; font-weight: 700; font-family: var(--font-body); cursor: default; flex-shrink: 0; margin-left: 0.75rem; text-transform: uppercase; box-sizing: border-box; padding: 0; line-height: 1;"'

foreach ($path in $paths) {
    if (Test-Path $path) {
        $content = [System.IO.File]::ReadAllText($path)
        if ($content.Contains($oldHtml)) {
            $content = $content.Replace($oldHtml, $newHtml)
            [System.IO.File]::WriteAllText($path, $content)
            Write-Host "Replaced successfully in $($path)"
        } else {
            Write-Host "Not found in $($path)"
        }
    }
}
