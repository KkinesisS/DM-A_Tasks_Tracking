Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\KkinesisS\Desktop\THA\DM-A_App\DM-A Task Tracking Deployment\dma_logo_clean_transparent.png"
$outPath = "C:\Users\KkinesisS\Desktop\THA\DM-A_App\DM-A Task Tracking Deployment\dma_logo_dark_blue_transparent.png"

$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)
$width = $bmp.Width
$height = $bmp.Height

$outBmp = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Target Dark Blue color: #002060 (R: 0, G: 32, B: 96) or #0b1957 (R: 11, G: 25, B: 87)
$targetR = 11
$targetG = 25
$targetB = 87

for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        $a = $pixel.A
        
        if ($a -gt 15) {
            # Convert non-transparent pixels to Dark Blue while retaining opacity
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

Write-Host "Dark Blue transparent logo created at: $outPath"
