Add-Type -AssemblyName System.Drawing

$svgContent = @"
<svg xmlns=""http://www.w3.org/2000/svg"" viewBox=""0 0 512 512"">
  <rect width=""512"" height=""512"" rx=""112"" fill=""#0d6efd""/>
  <text x=""50%"" y=""50%"" font-family=""Arial"" font-size=""250"" font-weight=""bold"" fill=""white"" dominant-baseline=""central"" text-anchor=""middle"">SD</text>
</svg>
"@

$pngFiles = @(
    "fastlane\metadata\android\en-US\images\icon.png",
    "flutter\android\app\src\main\res\mipmap-hdpi\ic_stat_logo.png",
    "flutter\android\app\src\main\res\mipmap-mdpi\ic_stat_logo.png",
    "flutter\android\app\src\main\res\mipmap-xhdpi\ic_stat_logo.png",
    "flutter\android\app\src\main\res\mipmap-xxhdpi\ic_stat_logo.png",
    "flutter\android\app\src\main\res\mipmap-xxxhdpi\ic_stat_logo.png",
    "flutter\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-1024x1024@1x.png",
    "flutter\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-20x20@1x.png",
    "flutter\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-20x20@2x.png",
    "flutter\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-20x20@3x.png",
    "flutter\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-29x29@1x.png",
    "flutter\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-29x29@2x.png",
    "flutter\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-29x29@3x.png",
    "flutter\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-40x40@1x.png",
    "flutter\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-40x40@2x.png",
    "flutter\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-40x40@3x.png",
    "flutter\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-60x60@2x.png",
    "flutter\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-60x60@3x.png",
    "flutter\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-76x76@1x.png",
    "flutter\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-76x76@2x.png",
    "flutter\ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-83.5x83.5@2x.png",
    "res\icon.png",
    "res\mac-icon.png"
)

$svgFiles = @(
    "flutter\assets\icon.svg",
    "res\logo-header.svg",
    "res\logo.svg"
)

$icoFiles = @(
    "flutter\windows\runner\resources\app_icon.ico",
    "res\icon.ico",
    "res\tray-icon.ico"
)

# Overwrite SVGs
foreach ($svg in $svgFiles) {
    if (Test-Path $svg) {
        [System.IO.File]::WriteAllText($svg, $svgContent, [System.Text.Encoding]::UTF8)
        Write-Host "Updated SVG: $svg"
    }
}

# Generate Base PNG
function Create-Png {
    param([int]$Size, [string]$Path)
    $bitmap = New-Object System.Drawing.Bitmap($Size, $Size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.Clear([System.Drawing.Color]::FromArgb(13, 110, 253))
    $font = New-Object System.Drawing.Font("Arial", ($Size * 0.4), [System.Drawing.FontStyle]::Bold)
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Center
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rect = New-Object System.Drawing.RectangleF(0, 0, $Size, $Size)
    $graphics.DrawString("SD", $font, $brush, $rect, $format)
    $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
    $font.Dispose()
    $brush.Dispose()
    $format.Dispose()
}

foreach ($png in $pngFiles) {
    if (Test-Path $png) {
        $size = 256
        if ($png -match '(\d+)x\d+') {
            $size = [int]$matches[1]
        } elseif ($png -match 'hdpi') { $size = 72 }
        elseif ($png -match 'mdpi') { $size = 48 }
        elseif ($png -match 'xhdpi') { $size = 96 }
        elseif ($png -match 'xxhdpi') { $size = 144 }
        elseif ($png -match 'xxxhdpi') { $size = 192 }
        
        Create-Png -Size $size -Path $png
        Write-Host "Updated PNG: $png"
    }
}

function Create-Ico {
    param([string]$Path)
    $Size = 256
    $bitmap = New-Object System.Drawing.Bitmap($Size, $Size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.Clear([System.Drawing.Color]::FromArgb(13, 110, 253))
    $font = New-Object System.Drawing.Font("Arial", ($Size * 0.4), [System.Drawing.FontStyle]::Bold)
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Center
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rect = New-Object System.Drawing.RectangleF(0, 0, $Size, $Size)
    $graphics.DrawString("SD", $font, $brush, $rect, $format)
    
    $iconStream = New-Object System.IO.MemoryStream
    $bitmap.Save($iconStream, [System.Drawing.Imaging.ImageFormat]::Png)
    
    $fs = New-Object System.IO.FileStream($Path, [System.IO.FileMode]::Create)
    $bw = New-Object System.IO.BinaryWriter($fs)
    $bw.Write([short]0) 
    $bw.Write([short]1) 
    $bw.Write([short]1) 
    
    $bw.Write([byte]0) 
    $bw.Write([byte]0) 
    $bw.Write([byte]0) 
    $bw.Write([byte]0) 
    $bw.Write([short]1) 
    $bw.Write([short]32) 
    $bw.Write([int]$iconStream.Length) 
    $bw.Write([int]22) 
    
    $bw.Write($iconStream.ToArray())
    
    $bw.Close()
    $fs.Close()
    $iconStream.Close()
    $graphics.Dispose()
    $bitmap.Dispose()
}

foreach ($ico in $icoFiles) {
    if (Test-Path $ico) {
        Create-Ico -Path $ico
        Write-Host "Updated ICO: $ico"
    }
}

Write-Host "Icons replacement completed."
