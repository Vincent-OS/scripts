<#PSScriptInfo

.VERSION 1.0

.GUID f94c1103-ca75-4a86-b358-26e77e454b51

.AUTHOR v38armageddon

.COMPANYNAME

.COPYRIGHT

.TAGS

.LICENSEURI https://interoperable-europe.ec.europa.eu/collection/eupl/eupl-text-eupl-12

.PROJECTURI https://github.com/Vincent-OS/scripts

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

.DESCRIPTION
 Script that updates the Vincent OS system.

#>
Param()
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
$currentID = & id -u 2>$null
$loggedInUser = & logname 2>$null
try {
	if ($currentID -ne 0) {
		Write-Error -Category PermissionDenied -ErrorId "ERR_NOT_ROOT" -Message "This script must be run as root. Please run it with 'sudo'."
		exit 13
	}
	Write-Host "Updating Vincent OS System..."

	# Update core system
	pacman -Syu

	# Update AUR packages if yay is installed
	try {
		if (Get-Command yay) {
			sudo -u $loggedInUser yay -Syu
		}
	}
	catch {
		Write-Warning "'yay' is not installed. Skipping AUR packages update."
	}

	# Update user software
	sudo -u $loggedInUser flatpak update

	# Update Core LivePatch database and apply newest patches
	clpctl update
}
catch {
	Write-Error -Category NotSpecified -ErrorId "ERR_UPDATE_FAILED" -Message "An error occurred while updating the system: $_"
}
