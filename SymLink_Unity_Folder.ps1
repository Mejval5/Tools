<#
    PowerShell Script: Create Symbolic Links for Unity Project

    This PowerShell script automates the creation of symbolic links between a Unity project folder and the current folder. 
    It ensures the script runs with administrative privileges and asks for user confirmation before proceeding with the file operations.

    How It Works:

    1. Administrative Check:
        - The script first checks if it is being run with administrator rights. If not, it will attempt to restart itself 
          with elevated permissions. If it is relaunched with admin rights, the script proceeds; otherwise, it exits.
    
    2. Project Folder Path:
        - The path to the Unity project folder is predefined in the script. The default is set to `D:\UnityProjects\[PROJECT]`.
          You can modify this path according to your project location.

    3. Files and Folders:
        - The script attempts to create symbolic links for predefined folders and files within the Unity project, such as `Assets`, `Packages`, 
          `README.md`, etc. You can customize the list of files and folders in the `$items` array.
    
    4. Confirmation:
        - Before performing any actions, the script will display the source and destination paths and ask for confirmation. 
          If the user responds with 'y' or 'Y', the symbolic links will be created.

    5. Skipping Existing Links:
        - If a symbolic link for an item already exists in the destination folder, the script will skip that item.

    6. Operation Feedback:
        - After each operation, the script provides feedback indicating whether a symlink was created or skipped. 
          It finishes with a message to press any key to exit.

    Note:
    - Ensure you run the script in PowerShell with administrative privileges.
#>

param(
    [switch]$RelaunchedForAdmin
)

$has_admin_rights = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

# Check if running as Administrator
if (-NOT $has_admin_rights -and $RelaunchedForAdmin) {
    Exit
}

if (-NOT $has_admin_rights) {
    Write-Host "Attempting to restart with Administrator rights..."
    Start-Process powershell.exe -ArgumentList "-File", ("""$PSCommandPath"""), "-RelaunchedForAdmin" -Verb RunAs
    Exit
}

# Define the path to the Unity project folder
$path_to_stuff = "D:\UnityProjects\[PROJECT]"

# Define the items to create symlinks for
$items = @("Assets", "CI", "Doc", "Documentation", "Packages", "Plugins", "ProjectSettings", "Tools", ".editorconfig", ".gitattributes", ".gitignore", "README.md")

# Get the current folder path
$this_folder = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Inform user of the action to be taken and ask for confirmation
Write-Host "Hey, you are about to copy files from $path_to_stuff to $this_folder, are you sure about that? (y/N)"
$confirmation = Read-Host

# Check if the user confirmed with 'y' or 'Y'
if ($confirmation -ne 'y' -and $confirmation -ne 'Y') {
    # Exit early if the user does not confirm
    Write-Host "Operation cancelled by user. Press any key to exit....."
    $confirmation = Read-Host
    Exit
}

# Loop through each item and create a symlink
foreach ($item in $items) {
    $path_to_link = Join-Path -Path $path_to_stuff -ChildPath $item
    $path_to_link_to = Join-Path -Path $this_folder -ChildPath $item

    # Check if target already exists, if so skip
    if (Test-Path $path_to_link_to) {
        Write-Output "Skipping, target already exists: $path_to_link_to"
        continue
    }

    # Create the symbolic link
    New-Item -ItemType SymbolicLink -Path $path_to_link_to -Target $path_to_link
    Write-Output "Created symlink: $path_to_link_to -> $path_to_link"
}

Write-Host "Operation finished. Press any key to exit....."
$confirmation = Read-Host