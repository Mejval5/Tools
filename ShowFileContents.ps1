# Define the folder path
$folderPath = "."

# Define a list of file and folder names or patterns to exclude
$excludePatterns = @("*.meta", "Untracked", "External")

# Get the folder contents recursively, excluding specific files and folders
$files = Get-ChildItem -Path $folderPath -Recurse | Where-Object { 
    $exclude = $false
    foreach ($pattern in $excludePatterns) {
        # Check if the file or folder name matches the exclusion patterns
        if ($_.Name -like $pattern -or $_.FullName -like "*\$pattern*") {
            $exclude = $true
            break
        }
    }
    -not $exclude
}

# Optional: If you want to display the output in the console as well
$files | Format-Table
