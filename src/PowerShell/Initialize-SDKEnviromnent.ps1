<#
    .SYNOPSIS
    Initialize the Vincent OS SDK environment.

    .DESCRIPTION
    This scripts sets up a Vincent OS SDK environment located in /src/SDK, it will download the following repositories:
    - Vincent OS Calamares settings (Vincent-OS/calamares-settings)
    - Vincent OS Core LivePatch CLI (Vincent-OS/clpctl)
    - Vincent OS Scripts (Vincent-OS/scripts)
    - Vincent OS Themes, this includes SDDM (Vincent-OS/Space-kde) and Global Theme (Vincent-OS/global-theme)
    - Vincent OS Wallpapers (Vincent-OS/wallpaper)

    .PARAMETER Development
    If specified, the script will clone all the repositories using the dev branch instead of the master branch.
    This is useful if you want the latest commits but it may be more unstable.

    .NOTES
    The following tools are required to run this script:
    - git
    - .NET SDK 8.0 or higher
    - PowerShell 7.2 or higher
#>
param (
    [switch]$Development
)
$sdkDir = "/src/SDK"
$repos = @(
    @{
        Name = "calamares-settings"
        Url = "https://github.com/Vincent-OS/calamares-settings.git"
        Branch = if ($Development) { "dev" } else { "master" }
    },
    @{
        Name = "clpctl"
        Url = "https://github.com/Vincent-OS/clpctl.git"
        Branch = if ($Development) { "dev" } else { "master" }
    },
    @{
        Name = "scripts"
        Url = "https://github.com/Vincent-OS/scripts.git"
        Branch = if ($Development) { "dev" } else { "master" }
    },
    @{
        Name = "Space-kde"
        Url = "https://github.com/Vincent-OS/Space-kde.git"
        Branch = if ($Development) { "dev" } else { "master" }
    },
    @{
        Name = "global-theme"
        Url = "https://github.com/Vincent-OS/global-theme.git"
        Branch = if ($Development) { "dev" } else { "master" }
    },
    @{
        Name = "wallpaper"
        Url = "https://github.com/Vincent-OS/wallpaper.git"
        Branch = if ($Development) { "dev" } else { "master" }
    }
)
$requiredTools = @("git", "dotnet", "pwsh")

Start-Transcript -Path "$env:HOME/Initialize-SDKEnvironment.log" -Append
Write-Host "Vincent OS SDK 1.0 (origin). By v38armageddon"

# Check for required tools
foreach ($tool in $requiredTools) {
    if (-Not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        Write-Error -Category NotInstalled -ErrorId "ERR_TOOL_NOTINSTALLED" -Message "Required tool '$tool' is not installed or not in PATH. Please install it and try again."
        Stop-Transcript
        exit 255
    }
}

Write-Host "Initializing SDK environment in $sdkDir"

# Ensure the SDK directory exists
if (-Not (Test-Path -Path $sdkDir)) {
    New-Item -ItemType Directory -Path $sdkDir | Out-Null
    Write-Host "Created SDK directory at $sdkDir"
}

Write-Progress -Activity "Cloning repositories" -Status "Starting..." -PercentComplete 0
$progress = 0
foreach ($repo in $repos) {
    Write-Progress -Activity "Cloning repositories" -Status "Cloning $($repo.Name)..." -PercentComplete $progress
    $repoPath = Join-Path -Path $sdkDir -ChildPath $repo.Name
    if (Test-Path -Path $repoPath) {
        Write-Host "Repository $($repo.Name) already exists. Pulling latest changes..."
        Set-Location -Path $repoPath
        git fetch
        git pull
    }
    else {
        git clone --branch $repo.Branch $repo.Url $repoPath
    }
    $progress += (100 / $repos.Count)
    Start-Sleep -Seconds 1
}
Write-Progress -Activity "Cloning repositories" -Status "Completed." -PercentComplete 100
