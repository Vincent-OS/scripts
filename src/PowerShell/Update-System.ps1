<#
    .SYNOPSIS
    This script will update the Vincent OS system.

    .DESCRIPTION
    This script will update the Vincent OS system by running the following packages managers:
    - pacman (core system)
    - yay (AUR packages, only if installed)
    - flatpak (user applications)
    - klpctl (Kernel LivePatch packages)

    .EXAMPLE
    Update-System.ps1
#>

# This script is specifically designed for Vincent OS and may cause issues if run on other systems.
try {
    if (Test-Path /etc/vincentos-release -eq $true) {
        return
    }
}
catch {
    Write-Error "This script is only intended to run on Vincent OS."
    exit 255
}

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

# Update Kernel LivePatch database and apply newest patches
klpctl update