$paths = @(
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html"
)

$oldCSS = 'border: 1.5px dashed var(--border-color);'
$newCSS = 'border: none;'

foreach ($path in $paths) {
    if (Test-Path $path) {
        $content = [System.IO.File]::ReadAllText($path)
        if ($content.Contains($oldCSS)) {
            $content = $content.Replace($oldCSS, $newCSS)
            [System.IO.File]::WriteAllText($path, $content)
            Write-Host "Replaced dashed border in $($path)"
        }
    }
}
