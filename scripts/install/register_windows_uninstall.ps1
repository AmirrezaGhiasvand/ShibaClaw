function Register-ShibaClawUninstallEntry {
    param(
        [Parameter(Mandatory = $true)]
        [string]$UninstallScriptPath,

        [Parameter(Mandatory = $true)]
        [string]$InstallDir,

        [string]$DisplayVersion = "unknown"
    )

    $displayName = "ShibaClaw"
    $publisher = "RikyZ90"
    $urlInfoAbout = "https://github.com/RikyZ90/ShibaClaw"
    $appKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\ShibaClaw"
    $uninstallCommand = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$UninstallScriptPath`" -Force -InstallDir `"$InstallDir`""

    try {
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

        Write-Host "[OK] Registered Windows uninstall entry in Apps & Features." -ForegroundColor Green
    }
    catch {
        Write-Warning "Could not register Windows uninstall entry: $($_.Exception.Message)"
    }
}
