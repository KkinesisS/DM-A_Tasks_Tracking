$old = 'Engineering Support System'
$new = 'Production Engineer Support System'

foreach ($file in @(".\index.html", ".\index2.html")) {
    if (Test-Path $file) {
        $content = [System.IO.File]::ReadAllText($file)
        $content = $content.Replace($old, $new)
        [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Updated: $file"
    }
}
Write-Host "Done."
