Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\KkinesisS\Desktop\THA\DM-A_App\DM-A Task Tracking Deployment\dma_logo_transparent.png"
$outPath = "C:\Users\KkinesisS\Desktop\THA\DM-A_App\DM-A Task Tracking Deployment\dma_logo_clean_transparent.png"

$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)
$width = $bmp.Width
$height = $bmp.Height

$outBmp = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        $r = $pixel.R
        $g = $pixel.G
        $b = $pixel.B
        $a = $pixel.A
        
        # Check if the pixel is white / near white (logo text)
        # White text has high R, G, B values (e.g. > 180 and low color difference)
        $brightness = ($r + $g + $b) / 3.0
        
        if ($brightness -gt 190) {
            # Logo white text: Keep as crisp white with opacity matching brightness
            $alpha = [int][Math]::Min(255, [Math]::Max(0, ($brightness - 140) * 3.5))
            $newColor = [System.Drawing.Color]::FromArgb($alpha, 255, 255, 255)
            $outBmp.SetPixel($x, $y, $newColor)
        } else {
            # Checkerboard background / dark pixels: Make 100% transparent
            $outBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
    }
}

$outBmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
$outBmp.Dispose()

Write-Host "Clean transparent logo created at: $outPath"
