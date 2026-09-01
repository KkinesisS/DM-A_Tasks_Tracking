Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\KkinesisS\Desktop\THA\DM-A_App\DM-A Task Tracking Deployment\dma_logo_clean_transparent.png"
$outPath = "C:\Users\KkinesisS\Desktop\THA\DM-A_App\DM-A Task Tracking Deployment\dma_logo_dark_purple_transparent.png"

$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)
$width = $bmp.Width
$height = $bmp.Height

$outBmp = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Target Dark Purple shade: #4c1d95 (R: 76, G: 29, B: 149) or #3b0764 (R: 59, G: 7, B: 100)
$targetR = 59
$targetG = 7
$targetB = 100

for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        $a = $pixel.A
        
        if ($a -gt 15) {
            # Convert non-transparent pixels to Dark Purple while retaining opacity
            $newColor = [System.Drawing.Color]::FromArgb($a, $targetR, $targetG, $targetB)
            $outBmp.SetPixel($x, $y, $newColor)
        } else {
            $outBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
    }
}

$outBmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
$outBmp.Dispose()

Write-Host "Dark Purple transparent logo created at: $outPath"
