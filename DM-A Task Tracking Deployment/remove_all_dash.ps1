$paths = @(
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html"
)

$oldCSS1 = 'border-top: 1px dashed rgba(0,0,0,0.05);'
$newCSS1 = 'border-top: 1px solid rgba(0,0,0,0.05);'

$oldCSS2 = 'border-bottom: 1px dashed rgba(0,0,0,0.05);'
$newCSS2 = 'border-bottom: 1px solid rgba(0,0,0,0.05);'

$oldCSS3 = 'border-top: 1px dashed rgba(0, 0, 0, 0.05);'
$newCSS3 = 'border-top: 1px solid rgba(0, 0, 0, 0.05);'

$oldCSS4 = 'border-bottom: 1px dashed rgba(0, 0, 0, 0.05);'
$newCSS4 = 'border-bottom: 1px solid rgba(0, 0, 0, 0.05);'

foreach ($path in $paths) {
    if (Test-Path $path) {
        $content = [System.IO.File]::ReadAllText($path)
        $changed = $false
        
        if ($content.Contains($oldCSS1)) { $content = $content.Replace($oldCSS1, $newCSS1); $changed = $true }
        if ($content.Contains($oldCSS2)) { $content = $content.Replace($oldCSS2, $newCSS2); $changed = $true }
        if ($content.Contains($oldCSS3)) { $content = $content.Replace($oldCSS3, $newCSS3); $changed = $true }
        if ($content.Contains($oldCSS4)) { $content = $content.Replace($oldCSS4, $newCSS4); $changed = $true }
        
        if ($changed) {
            [System.IO.File]::WriteAllText($path, $content)
            Write-Host "Replaced inner dashed borders in $($path)"
        }
    }
}
