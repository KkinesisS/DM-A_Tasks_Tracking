# build.ps1 - Compile MRO Task Tracking assets for Google Apps Script

Write-Host "Compiling assets for Google Apps Script using PowerShell..."

# Ensure build directory exists
if (-not (Test-Path -Path "build")) {
    New-Item -ItemType Directory -Path "build" | Out-Null
}

# 1. Compile index.html from template (check index2.html first, fallback to index.html)
$templatePath = "index2.html"
if (-not (Test-Path -Path $templatePath)) {
    $templatePath = "index.html"
}

if (Test-Path -Path $templatePath) {
    Write-Host "Using $templatePath as template source..."
    $indexHtml = Get-Content -Raw -Path $templatePath -Encoding utf8
    
    # Inline stylesheet contents
    $stylesContent = Get-Content -Raw -Path "styles.css" -Encoding utf8
    $darkModeContent = Get-Content -Raw -Path "dark-mode.css" -Encoding utf8
    
    # Base64 inline the THAI787 Background JPEG
    if (Test-Path -Path "THAI787.jpeg") {
        $bgBytes = [System.IO.File]::ReadAllBytes("THAI787.jpeg")
        $bgBase64 = [System.Convert]::ToBase64String($bgBytes)
        $stylesContent = $stylesContent.Replace('<!-- THAI787_BG_BASE64 -->', "data:image/jpeg;base64,$bgBase64")
    }
    
    # Inline script contents
    $tabsContent = Get-Content -Raw -Path "tabs.js" -Encoding utf8
    $manualIssuesContent = Get-Content -Raw -Path "manualIssues.js" -Encoding utf8
    $appContent = Get-Content -Raw -Path "app.js" -Encoding utf8
    
    # Replace stylesheet links with inline style tags
    $indexHtml = $indexHtml.Replace('<link rel="stylesheet" href="styles.css">', "<style>`n$stylesContent`n</style>")
    $indexHtml = $indexHtml.Replace('<link rel="stylesheet" href="dark-mode.css">', "<style>`n$darkModeContent`n</style>")
    
    # Replace script tags with inline script tags
    $indexHtml = $indexHtml.Replace('<script src="tabs.js"></script>', "<script>`n$tabsContent`n</script>")
    $indexHtml = $indexHtml.Replace('<script src="manualIssues.js"></script>', "<script>`n$manualIssuesContent`n</script>")
    $indexHtml = $indexHtml.Replace('<script src="app.js"></script>', "<script>`n$appContent`n</script>")
    
    # Base64 inline the Thai Airways Logo PNG (replace file path references with data URI)
    if (Test-Path -Path "Thai_Airways_International_logo_PNG1.png") {
        $logoBytes = [System.IO.File]::ReadAllBytes("Thai_Airways_International_logo_PNG1.png")
        $logoBase64 = [System.Convert]::ToBase64String($logoBytes)
        $indexHtml = $indexHtml.Replace('<!-- THAI_AIRWAYS_LOGO_BASE64 -->', "data:image/png;base64,$logoBase64")
        $indexHtml = $indexHtml.Replace('Thai_Airways_International_logo_PNG1.png', "data:image/png;base64,$logoBase64")
    }

    # Save index.html
    [System.IO.File]::WriteAllText("build/index.html", $indexHtml, [System.Text.Encoding]::UTF8)
    [System.IO.File]::WriteAllText("index.html", $indexHtml, [System.Text.Encoding]::UTF8)
    Write-Host "$templatePath -> build/index.html and index.html compiled (fully inlined)."
} else {
    Write-Warning "Neither index2.html nor index.html was found!"
}

# Helper to wrap files
function Wrap-File {
    param (
        [string]$File,
        [string]$Type,
        [string]$TargetName,
        [string]$PreloadedContent = $null
    )
    if ($PreloadedContent) {
        $content = $PreloadedContent
    } elseif (Test-Path -Path $File) {
        $content = Get-Content -Raw -Path $File -Encoding utf8
    } else {
        Write-Warning "$File not found!"
        return
    }

    if ($Type -eq "css") {
        $wrapped = "<style>`n$content`n</style>"
    } else {
        $wrapped = "<script>`n$content`n</script>"
    }
    [System.IO.File]::WriteAllText("build/$TargetName.html", $wrapped, [System.Text.Encoding]::UTF8)
    Write-Host "$File wrapped -> build/$TargetName.html"
}

# 2. Wrap CSS files
Wrap-File -File "styles.css" -Type "css" -TargetName "styles" -PreloadedContent $stylesContent
Wrap-File -File "dark-mode.css" -Type "css" -TargetName "dark-mode"

# 3. Wrap JS files
Wrap-File -File "tabs.js" -Type "js" -TargetName "tabs"
Wrap-File -File "manualIssues.js" -Type "js" -TargetName "manualIssues"
Wrap-File -File "app.js" -Type "js" -TargetName "app"

# 4. Copy backend files
$extraFiles = @("Code.gs", "appsscript.json")
foreach ($file in $extraFiles) {
    if (Test-Path -Path $file) {
        Copy-Item -Path $file -Destination "build/$file" -Force
        Write-Host "$file copied -> build/$file"
    } else {
        Write-Warning "$file not found!"
    }
}

Write-Host "Build completed successfully! Deploy the contents of the 'build' directory to Apps Script."
