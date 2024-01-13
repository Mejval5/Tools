# Get all unique file extensions in the project
$extensions = Get-ChildItem -Recurse -File | 
              Select-Object -ExpandProperty Extension | 
              Where-Object { $_ -ne '' } | 
              Sort-Object -Unique

# Loop through each extension and commit files of that type
foreach ($ext in $extensions) {
    # Removing the leading dot from extension
    $ext = $ext.TrimStart('.')

    # Display the extension being processed
    Write-Host "Processing extension: $ext"

    # Add files of this extension type
    git add "**/*.$ext"

    # Check if there are changes to commit
    $status = git diff --cached --quiet
    if (-not $status) {
        # Commit the changes
        Write-Host "Committing changes for $ext files"
        git commit -m "Add/update $ext files"
    } else {
        Write-Host "No changes found for $ext files"
    }
}
