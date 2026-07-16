$paths = @(
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html"
)

$oldCSS = @"
.logo-section {
    display: flex;
    align-items: center;
    gap: 0.75rem;
}

.logo-section .app-logo {
    height: 3.5rem;
    width: auto;
    object-fit: contain;
}

.logo-section h1 {
    font-size: 1.3rem;
    font-weight: 700;
    color: var(--text-primary);
}

.logo-section p {
    font-size: 0.75rem;
    color: var(--text-secondary);
    letter-spacing: 0.05em;
    text-transform: uppercase;
}
"@
$oldCSS = $oldCSS.Replace("`r`n", "`n")

$newCSS = @"
.logo-section {
    display: flex;
    align-items: center;
    gap: 1.25rem;
}

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

.logo-section h1 {
    font-size: 2.25rem;
    font-weight: 800;
    color: #0f172a;
    line-height: 1.1;
    margin: 0;
    letter-spacing: -0.01em;
}

.logo-section p {
    font-size: 0.95rem;
    color: #4b5563;
    margin: 4px 0 0 0;
    font-weight: 500;
}

.logo-section p .wingspan {
    color: #6d28d9;
    font-weight: 700;
}

html.dark-mode .logo-section h1 {
    color: #f8fafc;
}
html.dark-mode .logo-section p {
    color: #cbd5e1;
}
html.dark-mode .logo-section p .wingspan {
    color: #c084fc;
}
"@
$newCSS = $newCSS.Replace("`r`n", "`n")


$oldHTML = @"
            <div class="logo-section">
                <img src="Thai_Airways_International_logo_PNG1.png" alt="Thai Airways International Logo" class="app-logo" />
                <div>
                    <h1>DM-A Task Tracking</h1>
                    <p>Engineering Maintenance Control Board</p>
                </div>
            </div>
"@
$oldHTML = $oldHTML.Replace("`r`n", "`n")

$newHTML = @"
            <div class="logo-section">
                <img src="Thai_Airways_International_logo_PNG1.png" alt="Thai Airways International Logo" class="app-logo" />
                <div class="logo-divider"></div>
                <div>
                    <h1>Task Tracking</h1>
                    <p><span class="wingspan">Wingspan Services</span> &nbsp;|&nbsp; Engineering Support System</p>
                </div>
            </div>
"@
$newHTML = $newHTML.Replace("`r`n", "`n")

foreach ($path in $paths) {
    if (Test-Path $path) {
        $content = [System.IO.File]::ReadAllText($path)
        $content = $content.Replace("`r`n", "`n")
        
        $cssChanged = $false
        $htmlChanged = $false
        
        if ($content.Contains($oldCSS)) {
            $content = $content.Replace($oldCSS, $newCSS)
            $cssChanged = $true
        }
        
        if ($content.Contains($oldHTML)) {
            $content = $content.Replace($oldHTML, $newHTML)
            $htmlChanged = $true
        }
        
        if ($cssChanged -or $htmlChanged) {
            [System.IO.File]::WriteAllText($path, $content)
            Write-Host "Replaced logo section in $($path) (CSS: $cssChanged, HTML: $htmlChanged)"
        } else {
            Write-Host "Could not find targets in $($path)"
        }
    }
}
