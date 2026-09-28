Add-Type -AssemblyName System.Drawing

$icoFiles = @(
    "flutter\windows\runner\resources\app_icon.ico",
    "res\icon.ico",
    "res\tray-icon.ico"
)

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
    $bw.Write([int16]0) 
    $bw.Write([int16]1) 
    $bw.Write([int16]1) 
    
    $bw.Write([byte]0) 
    $bw.Write([byte]0) 
    $bw.Write([byte]0) 
    $bw.Write([byte]0) 
    $bw.Write([int16]1) 
    $bw.Write([int16]32) 
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
Write-Host "ICO update finished."
