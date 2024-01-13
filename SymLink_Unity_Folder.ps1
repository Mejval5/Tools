param(
    [switch]$RelaunchedForAdmin
)

$has_admin_rights = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

# Check if running as Administrator
if (-NOT $has_admin_rights -and $RelaunchedForAdmin)
{
    Exit
}

if (-NOT $has_admin_rights)
{
    Write-Host "Attempting to restart with Administrator rights..."
    Start-Process powershell.exe -ArgumentList "-File",("""$PSCommandPath"""),"-RelaunchedForAdmin" -Verb RunAs
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
if($confirmation -ne 'y' -and $confirmation -ne 'Y'){
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
    if(Test-Path $path_to_link_to){
        Write-Output "Skipping, target already exists: $path_to_link_to"
        continue
    }

    # Create the symbolic link
    New-Item -ItemType SymbolicLink -Path $path_to_link_to -Target $path_to_link
    Write-Output "Created symlink: $path_to_link_to -> $path_to_link"
}

Write-Host "Operation finished. Press any key to exit....."
$confirmation = Read-Host