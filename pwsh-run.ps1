# PowerShell Runner for Batlez Tweaks
# Usage: iwr -useb https://raw.githubusercontent.com/Batlez/Batlez-Tweaks/main/pwsh-run.ps1 | iex

# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Requesting administrator privileges..." -ForegroundColor Yellow
    
    # Create temporary elevated script in Documents folder (safer than temp)
    $elevatedScript = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "batlez-tweaks-runner.ps1"
    
    @'
$batchFile = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "Batlez-Tweaks.bat"
$url = "https://raw.githubusercontent.com/Batlez/Batlez-Tweaks/main/Batlez%20Tweaks.bat"

try {
    Invoke-WebRequest -Uri $url -OutFile $batchFile -ErrorAction Stop
    Start-Process -FilePath $batchFile -Wait
    Remove-Item $batchFile -Force -ErrorAction SilentlyContinue
    Remove-Item $PSCommandPath -Force -ErrorAction SilentlyContinue
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Press Enter to exit"
}
'@ | Out-File -FilePath $elevatedScript -Encoding UTF8 -Force
    
    Start-Process powershell "-NoProfile -ExecutionPolicy Bypass -File `"$elevatedScript`"" -Verb RunAs
    
    # Clean up after 10 seconds
    Start-Job { Start-Sleep 10; Remove-Item $args[0] -Force -ErrorAction SilentlyContinue } -ArgumentList $elevatedScript | Out-Null
    exit
}

# If already admin, run directly
try {
    $batchFile = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "Batlez-Tweaks.bat"
    $url = "https://raw.githubusercontent.com/Batlez/Batlez-Tweaks/main/Batlez%20Tweaks.bat"
    
    Invoke-WebRequest -Uri $url -OutFile $batchFile -ErrorAction Stop
    Start-Process -FilePath $batchFile -Wait
    Remove-Item $batchFile -Force -ErrorAction SilentlyContinue
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
