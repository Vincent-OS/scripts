<#
    .SYNOPSIS
    This script will update the Vincent OS system.

    .DESCRIPTION
    This script will update the Vincent OS system by running the following packages managers:
    - pacman (core system)
    - yay (AUR packages, only if installed)
    - flatpak (user applications)
    - clpctl (Core LivePatch packages)

    .EXAMPLE
    Update-System.ps1
#>

Write-Host "Updating Vincent OS System..."

# Update core system
sudo pacman -Syu

# Update AUR packages if yay is installed
try {
    if (Test-Path /usr/bin/yay -eq $true) {
        yay -Syu
    }
}
catch {
    Write-Warning "'yay' is not installed. Skipping AUR packages update."
}

# Update user software
flatpak update

# Update Core LivePatch database and apply newest patches
sudo clpctl update
