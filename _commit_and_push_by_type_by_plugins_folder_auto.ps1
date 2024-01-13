git reset --soft origin/main
git reset

# Define the root directory for the folders to process
$rootDirectory = "Assets/Plugins"

# Get all directories in the specified root directory
$directories = Get-ChildItem -Path $rootDirectory -Directory

# Loop through each directory
foreach ($dir in $directories) {
    # Get all unique file extensions in the current directory
    $extensions = Get-ChildItem -Path $dir.FullName -Recurse -File | 
                  Select-Object -ExpandProperty Extension | 
                  Where-Object { $_ -ne '' } | 
                  Sort-Object -Unique

    Write-Host "Found these [$($extensions)] inside '$($dir)'"

    # Loop through each extension and commit files of that type in the current directory
    foreach ($ext in $extensions) {
        # Removing the leading dot from extension
        $ext = $ext.TrimStart('.')

        # Display the directory and extension being processed
        Write-Host "Processing directory: $($dir.FullName), extension: $ext"

        # Add files of this extension type in the current directory
        git add "$($dir.FullName)/*.$ext"

        # Check if there are changes to commit
        $status = git diff --cached --quiet
        if (-not $status) {
            # Commit the changes
            Write-Host "Committing changes for $ext files in $($dir.Name)"
            git commit -m "Add/update $ext files in $($dir.Name)"
        } else {
            Write-Host "No changes found for $ext files in $($dir.Name)"
        }
    }
}

git partial-push origin main