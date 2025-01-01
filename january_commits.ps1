# January 2025 GitHub Commits Script
# Makes 5-10 commits per day between 5 AM and 10 AM

# Use the directory where the script is located to ensure flexibility
$repoPath = $PSScriptRoot
if ([string]::IsNullOrEmpty($repoPath)) {
    $repoPath = (Get-Location).Path
}
Set-Location $repoPath

# Initialize git repo if not already done
if (-not (Test-Path ".git")) {
    git init
    git branch -M main
}

# Set Git credentials explicitly to map commits to the correct account
git config user.email "jamariusfortson.work@gmail.com"
git config user.name "Jamarius Fortson"

# All days in January 2025
$days = 1..31

foreach ($day in $days) {
    $date = Get-Date -Year 2025 -Month 1 -Day $day
    $dateStr = $date.ToString("yyyy-MM-dd")

    # Random number of commits between 5 and 10
    $numCommits = Get-Random -Minimum 5 -Maximum 11

    Write-Host "Processing $dateStr with $numCommits commits..."

    for ($i = 1; $i -le $numCommits; $i++) {
        # Random hour between 5 and 9 (so commits fall in 5 AM - 10 AM window)
        $hour   = Get-Random -Minimum 5 -Maximum 10
        $minute = Get-Random -Minimum 0 -Maximum 60
        $second = Get-Random -Minimum 0 -Maximum 60

        $commitTime = "{0:D4}-{1:D2}-{2:D2}T{3:D2}:{4:D2}:{5:D2}" -f 2025, 1, $day, $hour, $minute, $second

        # Write content to the file
        $content = "January 2025 - Day $day - Commit $i`nTimestamp: $commitTime`nProgress update for January $day, 2025"
        Set-Content -Path "code" -Value $content

        git add .

        $env:GIT_AUTHOR_DATE    = $commitTime
        $env:GIT_COMMITTER_DATE = $commitTime

        git commit -m "chore: daily progress update - Jan $day 2025 [$i/$numCommits]"

        Write-Host "  Committed: $commitTime"
    }
}

# Clean up environment variables to prevent leakage into the current session
$env:GIT_AUTHOR_DATE = $null
$env:GIT_COMMITTER_DATE = $null

Write-Host ""
Write-Host "All January 2025 commits created successfully!"

# Check if origin is configured before pushing
$remote = git remote
if ($remote -contains "origin") {
    Write-Host "Now pushing to GitHub..."
    git push -f origin main
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Done! Check your GitHub profile for the green squares in January 2025."
    } else {
        Write-Host "Push failed. Please check your network or git credentials." -ForegroundColor Red
    }
} else {
    Write-Host "No 'origin' remote found. Skipping push. Please configure 'origin' and push manually." -ForegroundColor Yellow
    Write-Host "Done creating local commits."
}
