$ErrorActionPreference = "Stop"

function Rename-InFiles {
    param([string]$Path)
    Get-ChildItem -Path $Path -File -Recurse | Where-Object { $_.FullName -notmatch '\\\.git\\' -and $_.Name -ne 'rename.ps1' } | ForEach-Object {
        try {
            $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
            $newContent = $content -cReplace 'rustdesk', 'safedesk'
            $newContent = $newContent -cReplace 'RustDesk', 'SafeDesk'
            $newContent = $newContent -cReplace 'RUSTDESK', 'SAFEDESK'
            if ($content -cne $newContent) {
                [System.IO.File]::WriteAllText($_.FullName, $newContent, [System.Text.Encoding]::UTF8)
            }
        } catch {
            # Ignore errors
        }
    }
}

function Rename-Items {
    param([string]$Path)
    $items = Get-ChildItem -Path $Path -Recurse | Where-Object { $_.FullName -notmatch '\\\.git\\' } | Sort-Object -Property @{Expression={$_.FullName.Length};Descending=$true}
    foreach ($item in $items) {
        if ($item.Name -cmatch 'rustdesk' -or $item.Name -cmatch 'RustDesk' -or $item.Name -cmatch 'RUSTDESK') {
            $newName = $item.Name -cReplace 'rustdesk', 'safedesk' -cReplace 'RustDesk', 'SafeDesk' -cReplace 'RUSTDESK', 'SAFEDESK'
            Rename-Item -Path $item.FullName -NewName $newName -Force
        }
    }
}

$rootDir = (Get-Item .).FullName
Write-Host "Renaming contents in files..."
Rename-InFiles -Path $rootDir
Write-Host "Renaming files and directories..."
Rename-Items -Path $rootDir
Write-Host "Done."
