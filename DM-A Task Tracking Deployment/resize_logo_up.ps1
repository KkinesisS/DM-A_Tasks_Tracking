$paths = @(
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html"
)

$oldCSS = @"
.logo-section .app-logo {
    height: 2.5rem;
    width: auto;
    object-fit: contain;
}

.logo-section .logo-divider {
    width: 1px;
    height: 2.5rem;
    background-color: var(--border-color);
}
"@
$oldCSS = $oldCSS.Replace("`r`n", "`n")

$newCSS = @"
.logo-section .app-logo {
    height: 4rem;
    width: auto;
    object-fit: contain;
}

.logo-section .logo-divider {
    width: 1px;
    height: 4rem;
    background-color: var(--border-color);
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
            Write-Host "Replaced logo size in $($path)"
        }
    }
}
