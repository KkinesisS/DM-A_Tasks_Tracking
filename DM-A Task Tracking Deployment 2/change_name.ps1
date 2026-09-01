$paths = @(
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index.html",
    "c:\Users\tg50700\OneDrive - THAI AIRWAYS INTERNATIONAL PUBLIC CO.,LTD\Desktop\DM-A Task Tracking Deployment\index2.html"
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        $content = [System.IO.File]::ReadAllText($path)
        
        $oldText = '<span class="wingspan">Wingspan Services</span>'
        $newText = '<span class="wingspan">DM-A</span>'
        
        if ($content.Contains($oldText)) {
            $content = $content.Replace($oldText, $newText)
            [System.IO.File]::WriteAllText($path, $content)
            Write-Host "Replaced text in $($path)"
        }
    }
}
