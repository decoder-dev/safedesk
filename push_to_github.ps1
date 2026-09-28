$ErrorActionPreference = "Stop"

$token = "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"
$headers = @{
    Authorization = "token $token"
    Accept = "application/vnd.github.v3+json"
}

Write-Host "Authenticating with GitHub..."
try {
    $userResponse = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers $headers -Method Get
    $username = $userResponse.login
    Write-Host "Authenticated as: $username"
} catch {
    Write-Host "Failed to authenticate with GitHub. Check your token."
    exit 1
}

Write-Host "Creating repository 'safedesk'..."
$repoName = "safedesk"
$body = @{
    name = $repoName
    private = $false
    description = "SafeDesk - Remote Desktop Software"
} | ConvertTo-Json

try {
    $repoResponse = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Headers $headers -Method Post -Body $body -ContentType "application/json"
    Write-Host "Created repository: $($repoResponse.html_url)"
} catch {
    Write-Host "Repository might already exist or creation failed. Proceeding anyway."
}

Write-Host "Committing changes..."
git config user.email "dec@safedesk.local"
git config user.name "dec"

git add -A
git commit -m "Renamed to SafeDesk and updated icons"
git branch -M main

Write-Host "Pushing to GitHub..."
$remoteUrl = "https://${username}:${token}@github.com/${username}/${repoName}.git"
git remote set-url origin $remoteUrl
git push -u origin main

Write-Host "Done! Successfully pushed to GitHub."
