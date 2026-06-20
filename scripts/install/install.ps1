# ShibaClaw Automated Installer for Windows
# This script installs Python (via winget), creates a venv, and installs shibaclaw via PyPI.

$ErrorActionPreference = "Stop"

[console]::OutputEncoding = [System.Text.Encoding]::UTF8

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrEmpty($scriptDir)) {
    $scriptDir = (Get-Location).Path
}
$registerScript = Join-Path $scriptDir "register_windows_uninstall.ps1"
$uninstallScript = Join-Path $scriptDir "uninstall.ps1"

$installDir = "$HOME\.shibaclaw"
if (!(Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}
$installLog = Join-Path $installDir "install.log"

function Show-InstallProgress {
    param(
        [Parameter(Mandatory = $true)][string]$Message,
        [Parameter(Mandatory = $true)][int]$Step,
        [Parameter(Mandatory = $true)][int]$Total,
        [string]$Detail = ""
    )

    $percent = [Math]::Min(100, [int](($Step / $Total) * 100))
    $status = if ($Detail) { "$Message - $Detail" } else { $Message }
    Write-Progress -Activity "ShibaClaw installation" -Status $status -PercentComplete $percent
    Write-Host ("[{0}/{1}] {2}" -f $Step, $Total, $status) -ForegroundColor Cyan
}

function Invoke-LoggedStep {
    param(
        [Parameter(Mandatory = $true)][string]$Message,
        [Parameter(Mandatory = $true)][int]$Step,
        [Parameter(Mandatory = $true)][int]$Total,
        [Parameter(Mandatory = $true)][scriptblock]$Action
    )

    Show-InstallProgress -Message $Message -Step $Step -Total $Total

    try {
        & $Action 2>&1 | Out-File -FilePath $installLog -Append -Encoding utf8
        if ($LASTEXITCODE -ne 0) {
            throw "Step failed: $Message"
        }
    }
    catch {
        if (Test-Path $installLog) {
            Write-Host "[!] Installation details were saved to $installLog" -ForegroundColor Yellow
        }
        throw
    }
}

if (Test-Path $installLog) {
    Remove-Item $installLog -Force
}

Write-Host ">> Starting ShibaClaw installation..." -ForegroundColor Cyan

# 1. Check/Install Python
$pyVersion = $null
$pythonCmd = $null

function Test-PythonCommand($cmd) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        $out = & $cmd --version 2>&1
        if ($out -match "Python \d") { return $out }
    }
    return $null
}

Show-InstallProgress -Message "Checking Python runtime..." -Step 1 -Total 7

$pyVersion = Test-PythonCommand "python"
if ($pyVersion) { $pythonCmd = "python" }
else {
    $pyVersion = Test-PythonCommand "py"
    if ($pyVersion) { $pythonCmd = "py" }
}

if ($null -eq $pyVersion) {
    try {
        if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
            Write-Error "winget is not installed. Please install Python 3.12+ manually from python.org"
            exit 1
        }

        Invoke-LoggedStep -Message "Installing Python via winget..." -Step 2 -Total 7 -Action {
            winget install -e --id Python.Python.3.12 --silent --accept-package-agreements --accept-source-agreements
        }
        Write-Host "[OK] Python installed successfully." -ForegroundColor Green

        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

        $pyVersion = Test-PythonCommand "python"
        if ($pyVersion) { $pythonCmd = "python" }
        else {
            $pyVersion = Test-PythonCommand "py"
            if ($pyVersion) { $pythonCmd = "py" }
        }

        if ($null -eq $pythonCmd) {
            Write-Host "[!] Python installed but not yet in PATH. Please restart your terminal and run this script again." -ForegroundColor Yellow
            exit 1
        }
    }
    catch {
        Write-Error "Failed to install Python via winget. Please install Python 3.12+ manually from python.org"
        exit 1
    }
}

Show-InstallProgress -Message "Verifying Python version..." -Step 3 -Total 7 -Detail "$pyVersion"

$installedVersion = & $pythonCmd -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>&1
Write-Host "[OK] Found Python: $pyVersion" -ForegroundColor Green
if ([version]$installedVersion -lt [version]"3.12") {
    Write-Error "Python $installedVersion detected, but ShibaClaw requires Python 3.12+. Please upgrade from python.org"
    exit 1
}

$uninstallScript = Join-Path $installDir "uninstall.ps1"

function Register-ShibaClawUninstallEntry {
    param(
        [Parameter(Mandatory = $true)]
        [string]$UninstallScriptPath,

        [Parameter(Mandatory = $true)]
        [string]$InstallDir,

        [string]$DisplayVersion = "unknown",
        [string]$DisplayIcon = $null
    )

    $displayName = "ShibaClaw"
    $publisher = "RikyZ90"
    $urlInfoAbout = "https://github.com/RikyZ90/ShibaClaw"
    $appKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\ShibaClaw"
    $uninstallCommand = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$UninstallScriptPath`" -Force -InstallDir `"$InstallDir`""

    New-Item -Path $appKeyPath -Force | Out-Null
    New-ItemProperty -Path $appKeyPath -Name "DisplayName" -Value $displayName -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $appKeyPath -Name "DisplayVersion" -Value $DisplayVersion -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $appKeyPath -Name "Publisher" -Value $publisher -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $appKeyPath -Name "InstallLocation" -Value $InstallDir -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $appKeyPath -Name "UninstallString" -Value $uninstallCommand -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $appKeyPath -Name "QuietUninstallString" -Value $uninstallCommand -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $appKeyPath -Name "NoModify" -Value 1 -PropertyType DWord -Force | Out-Null
    New-ItemProperty -Path $appKeyPath -Name "NoRepair" -Value 1 -PropertyType DWord -Force | Out-Null
    New-ItemProperty -Path $appKeyPath -Name "EstimatedSize" -Value 1024 -PropertyType DWord -Force | Out-Null
    New-ItemProperty -Path $appKeyPath -Name "URLInfoAbout" -Value $urlInfoAbout -PropertyType String -Force | Out-Null
    if ($DisplayIcon) {
        New-ItemProperty -Path $appKeyPath -Name "DisplayIcon" -Value $DisplayIcon -PropertyType String -Force | Out-Null
    }
}

# 2. Installation Method (Prefer pipx, fallback to venv+pip)
if (Get-Command pipx -ErrorAction SilentlyContinue) {
    Invoke-LoggedStep -Message "Installing ShibaClaw package via pipx..." -Step 4 -Total 7 -Action {
        pipx install "shibaclaw[windows-native]"
    }
    $shibaExec = "shibaclaw"
}
else {
    $venvDir = "$installDir\venv"

    Invoke-LoggedStep -Message "Setting up ShibaClaw virtual environment..." -Step 4 -Total 7 -Action {
        & $pythonCmd -m venv $venvDir
        & "$venvDir\Scripts\python.exe" -m pip install --upgrade pip --disable-pip-version-check
        & "$venvDir\Scripts\python.exe" -m pip install "shibaclaw[windows-native]" --disable-pip-version-check
    }

    $scriptsPath = "$venvDir\Scripts"
    $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$scriptsPath*") {
        Write-Host ">> Adding ShibaClaw to User PATH..." -ForegroundColor Cyan
        [System.Environment]::SetEnvironmentVariable("Path", "$currentPath;$scriptsPath", "User")
        $env:Path += ";$scriptsPath"
    }
    $shibaExec = "$venvDir\Scripts\shibaclaw.exe"
}

$absExec = $shibaExec
if ($absExec -eq "shibaclaw") {
    $cmdPath = Get-Command shibaclaw -ErrorAction SilentlyContinue
    if ($cmdPath) {
        $absExec = $cmdPath.Source
    }
    else {
        $pipxDefault = "$HOME\.local\bin\shibaclaw.exe"
        if (Test-Path $pipxDefault) {
            $absExec = $pipxDefault
        }
    }
}

# Resolve shibaclaw-desktop.exe (gui-script: no console window)
$desktopExec = $null
$desktopArgs = $null
$absExecDir = Split-Path $absExec -Parent
$desktopCandidate = Join-Path $absExecDir "shibaclaw-desktop.exe"
if (Test-Path $desktopCandidate) {
    $desktopExec = $desktopCandidate
}
else {
    $cmdPath = Get-Command shibaclaw-desktop -ErrorAction SilentlyContinue
    if ($cmdPath) { $desktopExec = $cmdPath.Source }
}

if ($null -eq $desktopExec) {
    Write-Host "[!] shibaclaw-desktop.exe not found; shortcuts will use console mode." -ForegroundColor Yellow
    $desktopExec = $absExec
    $desktopArgs = "desktop"
}

Write-Host "[OK] Installation complete!" -ForegroundColor Green

# ---------------------------------------------------------------------------

$uninstallContent = @'
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$Force,
    [string]$InstallDir
)

$ErrorActionPreference = "Stop"

$logPath = Join-Path $env:TEMP 'ShibaClaw-uninstall.log'
function Log-Message {
    param([string]$Message)
    $entry = "$(Get-Date -Format o) $Message"
    Add-Content -Path $logPath -Value $entry -Encoding utf8
}

function Resolve-ShibaClawInstallDir {
    param([string]$Override)

    if ($Override) {
        return [System.IO.Path]::GetFullPath($Override)
    }

    $candidates = @(
        $env:SHIBACLAW_INSTALL_DIR,
        $env:SHIBACLAW_HOME,
        $env:USERPROFILE,
        $env:HOME,
        $HOME
    ) | Where-Object { $_ -and $_.Trim() }

    foreach ($candidate in $candidates) {
        $candidatePath = [System.IO.Path]::GetFullPath($candidate)
        if ($candidatePath) {
            if ($candidatePath -match '[\\/]\.shibaclaw$') {
                return $candidatePath
            }
            return (Join-Path $candidatePath ".shibaclaw")
        }
    }

    return [System.IO.Path]::GetFullPath((Join-Path ([Environment]::GetFolderPath("UserProfile")) ".shibaclaw"))
}

function Write-Step([string]$Message) {
    Write-Host ">> $Message" -ForegroundColor Cyan
}

function Write-Success([string]$Message) {
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Warn([string]$Message) {
    Write-Host "[!] $Message" -ForegroundColor Yellow
}

function Confirm-Uninstall {
    if ($Force) { return $true }
    try {
        $answer = Read-Host "This will remove ShibaClaw installation and shortcuts. Continue? [y/N]"
        return $answer -match '^(y|yes)$'
    }
    catch {
        Log-Message "Confirm-Uninstall failed: $($_.Exception.Message)"
        return $false
    }
}

Write-Step "Starting ShibaClaw uninstall..."
Log-Message "Starting uninstall from $PWD"

if (-not (Confirm-Uninstall)) {
    Write-Warn "Uninstall cancelled."
    Log-Message "Uninstall cancelled by user or no prompt available."
    return
}

$installDir = Resolve-ShibaClawInstallDir -Override $InstallDir
Log-Message "Resolved install dir: $installDir"
$desktopShortcut = Join-Path ([Environment]::GetFolderPath('Desktop')) "ShibaClaw.lnk"
$startMenuShortcut = Join-Path ([Environment]::GetFolderPath('Programs')) "ShibaClaw.lnk"

if (Get-Command pipx -ErrorAction SilentlyContinue) {
    Write-Step "Removing pipx installation..."
    Log-Message "Attempting pipx uninstall"
    try {
        pipx uninstall shibaclaw -q
        Log-Message "pipx uninstall completed"
    }
    catch {
        Log-Message "pipx uninstall failed: $($_.Exception.Message)"
    }
}

foreach ($target in @($desktopShortcut, $startMenuShortcut, $installDir)) {
    if (Test-Path $target) {
        try {
            Remove-Item -Path $target -Recurse -Force -ErrorAction Stop
            Log-Message "Removed target: ${target}"
        }
        catch {
            Log-Message "Failed to remove ${target}: $($_.Exception.Message)"
        }
    }
    else {
        Log-Message "Target not found: ${target}"
    }
}

$commandsToRemove = @()
$shibaclawCommand = Get-Command shibaclaw -ErrorAction SilentlyContinue
if ($shibaclawCommand) { $commandsToRemove += $shibaclawCommand.Source }
$desktopCommand = Get-Command shibaclaw-desktop -ErrorAction SilentlyContinue
if ($desktopCommand) { $commandsToRemove += $desktopCommand.Source }

foreach ($commandPath in $commandsToRemove | Select-Object -Unique) {
    $userBinPattern = "${HOME}\.local\bin*"
    $installPattern = "${HOME}\.shibaclaw*"
    $venvPattern = "*\venv\Scripts\*"
    if ($commandPath -and ($commandPath -like $userBinPattern -or $commandPath -like $installPattern -or $commandPath -like $venvPattern)) {
        try {
            Remove-Item -Path $commandPath -Force -ErrorAction Stop
            Log-Message "Removed executable: ${commandPath}"
        }
        catch {
            Log-Message "Failed to remove executable ${commandPath}: $($_.Exception.Message)"
        }
    }
}

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath) {
    $entries = $userPath -split ';' | Where-Object { $_ -and $_ -ne (Join-Path $installDir "venv\Scripts") }
    $newPath = $entries -join ';'
    if ($newPath -ne $userPath) {
        try {
            [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
            Log-Message "Updated user PATH to remove venv entry"
        }
        catch {
            Log-Message "Failed to update user PATH: $($_.Exception.Message)"
        }
    }
}

$registryKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\ShibaClaw'
if (Test-Path $registryKey) {
    try {
        Remove-Item -Path $registryKey -Recurse -Force -ErrorAction Stop
        Log-Message "Removed uninstall registry entry"
    }
    catch {
        Log-Message "Failed to remove uninstall registry entry: $($_.Exception.Message)"
    }
}

Write-Success "ShibaClaw has been removed. Please close and reopen your terminal to refresh PATH."
Log-Message "Uninstall completed."
'@

$uninstallContent | Set-Content -Path $uninstallScript -Encoding UTF8 -Force

Show-InstallProgress -Message "Registering uninstall entry..." -Step 5 -Total 7
if (Test-Path $registerScript) {
    try {
        $displayIcon = Join-Path $installDir "assets\shibaclaw.ico"
        Register-ShibaClawUninstallEntry -UninstallScriptPath $uninstallScript -InstallDir $installDir -DisplayVersion "0.6.6" -DisplayIcon $displayIcon
    }
    catch {
        Write-Warning "Could not register uninstall entry: $($_.Exception.Message)"
    }
}

Show-InstallProgress -Message "Creating shortcuts..." -Step 6 -Total 7
try {
    $assetsDir = "$installDir\assets"
    if (!(Test-Path $assetsDir)) {
        New-Item -ItemType Directory -Path $assetsDir | Out-Null
    }
    $icoPath = "$assetsDir\shibaclaw.ico"
    if (!(Test-Path $icoPath)) {
        Write-Host ">> Fetching ShibaClaw icon..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/RikyZ90/ShibaClaw/main/assets/shibaclaw.ico" `
            -OutFile $icoPath -UseBasicParsing -ErrorAction SilentlyContinue
    }

    $WshShell = New-Object -ComObject WScript.Shell

    # Desktop shortcut
    $DesktopPath = [System.Environment]::GetFolderPath('Desktop')
    $lnkDesktop = "$DesktopPath\ShibaClaw.lnk"
    $Shortcut = $WshShell.CreateShortcut($lnkDesktop)
    $Shortcut.TargetPath = $desktopExec
    $Shortcut.WorkingDirectory = Split-Path $desktopExec -Parent
    if ($desktopArgs) { $Shortcut.Arguments = $desktopArgs }
    if (Test-Path $icoPath) { $Shortcut.IconLocation = "$icoPath,0" }
    $Shortcut.Save()

    # Start Menu shortcut
    $StartMenuPath = [System.Environment]::GetFolderPath('Programs')
    $lnkStartMenu = "$StartMenuPath\ShibaClaw.lnk"
    $Shortcut2 = $WshShell.CreateShortcut($lnkStartMenu)
    $Shortcut2.TargetPath = $desktopExec
    $Shortcut2.WorkingDirectory = Split-Path $desktopExec -Parent
    if ($desktopArgs) { $Shortcut2.Arguments = $desktopArgs }
    if (Test-Path $icoPath) { $Shortcut2.IconLocation = "$icoPath,0" }
    $Shortcut2.Save()

    Write-Host "[OK] Shortcuts created with ShibaClaw icon." -ForegroundColor Green
}
catch {
    Write-Host "[!] Failed to create shortcuts. You can still run 'shibaclaw' from your terminal." -ForegroundColor Yellow
}

$env:PYTHONIOENCODING = "utf-8"
if ($desktopArgs) {
    Start-Process $desktopExec -ArgumentList $desktopArgs
}
else {
    Start-Process $desktopExec
}

Show-InstallProgress -Message "ShibaClaw is opening..." -Step 7 -Total 7
Write-Progress -Activity "ShibaClaw installation" -Completed
