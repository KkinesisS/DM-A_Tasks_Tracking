# Ensure build directory exists
if (-not (Test-Path "build")) {
    New-Item -ItemType Directory -Path "build" | Out-Null
}

Write-Host "Compiling assets for Google Apps Script..."

# Read template HTML file
$templatePath = "index2.html"
if (-not (Test-Path $templatePath)) {
    $templatePath = "index.html"
}
if (-not (Test-Path $templatePath)) {
    Write-Error "Error: Neither index.html nor index2.html was found."
    Exit 1
}

Write-Host "Using $templatePath as template source..."
$indexHtml = Get-Content -Path $templatePath -Raw -Encoding UTF8

# Read stylesheet contents
$stylesContent = Get-Content -Path "styles.css" -Raw -Encoding UTF8
$darkModeContent = Get-Content -Path "dark-mode.css" -Raw -Encoding UTF8

if (Test-Path "THAI787.jpeg") {
    $bytes = [System.IO.File]::ReadAllBytes("THAI787.jpeg")
    $base64 = [System.Convert]::ToBase64String($bytes)
    $bgImageUrl = "data:image/jpeg;base64,$base64"
    $stylesContent = $stylesContent -replace "url\(['`"]?THAI787\.jpeg['`"]?\)", "url('$bgImageUrl')"
    $stylesContent = $stylesContent -replace "url\(['`"]?<!-- THAI787_BG_BASE64 -->['`"]?\)", "url('$bgImageUrl')"
}

# Read script contents
$tabsContent = Get-Content -Path "tabs.js" -Raw -Encoding UTF8
$manualIssuesContent = Get-Content -Path "manualIssues.js" -Raw -Encoding UTF8
$appContent = Get-Content -Path "app.js" -Raw -Encoding UTF8

# Replace stylesheet links with styles
$indexHtml = $indexHtml.Replace('<link rel="stylesheet" href="styles.css">', "<style>`n$stylesContent`n</style>")
$indexHtml = $indexHtml.Replace('<link rel="stylesheet" href="dark-mode.css">', "<style>`n$darkModeContent`n</style>")

# Replace script tags with scripts
$indexHtml = $indexHtml.Replace('<script src="tabs.js"></script>', "<script>`n$tabsContent`n</script>")
$indexHtml = $indexHtml.Replace('<script src="manualIssues.js"></script>', "<script>`n$manualIssuesContent`n</script>")
$indexHtml = $indexHtml.Replace('<script src="app.js"></script>', "<script>`n$appContent`n</script>")

# Write index.html to build folder and root folder
$indexHtml | Set-Content -Path "build/index.html" -Encoding UTF8
$indexHtml | Set-Content -Path "index.html" -Encoding UTF8
Write-Host "$templatePath -> build/index.html and index.html compiled (fully inlined)."

# Wrap and write CSS files as HTML
$cssFiles = @('styles.css', 'dark-mode.css')
foreach ($file in $cssFiles) {
    if (Test-Path $file) {
        $content = Get-Content -Path $file -Raw -Encoding UTF8
        if ($file -eq "styles.css") {
            $content = $stylesContent
        }
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file)
        "<style>`n$content`n</style>" | Set-Content -Path "build/$baseName.html" -Encoding UTF8
        Write-Host "$file wrapped -> build/$baseName.html"
    }
}

# Wrap and write JS files as HTML
$jsFiles = @('tabs.js', 'manualIssues.js', 'app.js')
foreach ($file in $jsFiles) {
    if (Test-Path $file) {
        $content = Get-Content -Path $file -Raw -Encoding UTF8
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file)
        "<script>`n$content`n</script>" | Set-Content -Path "build/$baseName.html" -Encoding UTF8
        Write-Host "$file wrapped -> build/$baseName.html"
    }
}

# Copy Code.gs and appsscript.json if they exist
$extraFiles = @('Code.gs', 'appsscript.json')
foreach ($file in $extraFiles) {
    if (Test-Path $file) {
        Copy-Item -Path $file -Destination "build/$file" -Force
        Write-Host "$file copied -> build/$file"
    }
}

Write-Host "Build completed successfully!"
