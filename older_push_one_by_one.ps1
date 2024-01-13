# PowerShell Script to Push Commits One at a Time

# Set your remote and branch
$remote = "origin"
$branch = "main"

# Fetch the list of commits that are not in the remote yet
$commits = git log $remote/$branch..HEAD --format="%H"

# Convert the output to an array (each commit hash as an element)
$commitArray = $commits -split "`n"

# Reverse the array to start from the oldest commit
[Array]::Reverse($commitArray)

# Loop through each commit and push
foreach ($commit in $commitArray) {
    if ($commit -ne "") {
        Write-Host "Pushing commit $commit..."
        git push $remote ${commit}:$branch

        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error pushing commit $commit. Stopping script."
            break
        }
    }
}

Write-Host "All commits have been pushed."
