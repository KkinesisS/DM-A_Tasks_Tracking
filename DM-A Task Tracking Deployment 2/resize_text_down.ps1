$paths = @(
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html"
)

$oldCSS = @"
.logo-section h1 {
    font-size: 3.5rem;
    font-weight: 800;
    color: #0f172a;
    line-height: 1;
    margin: 0;
    letter-spacing: -0.02em;
}
"@
$oldCSS = $oldCSS.Replace("`r`n", "`n")

$newCSS = @"
.logo-section h1 {
    font-size: 18px;
    font-weight: 800;
    color: #0f172a;
    line-height: 1.2;
    margin: 0;
    letter-spacing: -0.01em;
}
"@
$newCSS = $newCSS.Replace("`r`n", "`n")

foreach ($path in $paths) {
    if (Test-Path $path) {
        $content = [System.IO.File]::ReadAllText($path)
        $content = $content.Replace("`r`n", "`n")
        
        if ($content.Contains($oldCSS)) {
            $content = $content.Replace($oldCSS, $newCSS)
            [System.IO.File]::WriteAllText($path, $content)
            Write-Host "Replaced text size in $($path)"
        }
    }
}
