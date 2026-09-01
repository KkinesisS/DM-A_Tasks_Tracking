$paths = @(
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html"
)

$oldCSS1 = '    height: 3.5rem;'
$newCSS1 = '    height: 2.25rem;'

# The above string will match both .app-logo height and .logo-divider height
# Let's be more precise and just replace the whole block

$oldCSS = @"
.logo-section .app-logo {
    height: 3.5rem;
    width: auto;
    object-fit: contain;
}

.logo-section .logo-divider {
    width: 1px;
    height: 3.5rem;
    background-color: var(--border-color);
}
"@
$oldCSS = $oldCSS.Replace("`r`n", "`n")

$newCSS = @"
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
