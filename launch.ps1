# ==============================================================
#  Batlez Tweaks - PowerShell Launcher
#  Usage: irm https://raw.githubusercontent.com/Batlez/Batlez-Tweaks/main/launch.ps1 | iex
# ==============================================================

Set-ExecutionPolicy Unrestricted -Scope Process -Force -ErrorAction SilentlyContinue

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Requesting administrator privileges..." -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm 'https://raw.githubusercontent.com/Batlez/Batlez-Tweaks/main/launch.ps1' | iex`"" -Verb RunAs
    exit
}

$build = [System.Environment]::OSVersion.Version.Build
if ($build -lt 17763) {
    Write-Host ""
    Write-Host "  [!] Batlez Tweaks requires Windows 10 1809 or later." -ForegroundColor Red
    Write-Host "      Detected build: $build" -ForegroundColor Red
    Write-Host ""
    pause
    exit 1
}

Clear-Host
Write-Host ""
Write-Host "  +==========================================================+" -ForegroundColor Cyan
Write-Host "  |              BATLEZ TWEAKS - Launcher                    |" -ForegroundColor Cyan
Write-Host "  |           github.com/Batlez/Batlez-Tweaks                |" -ForegroundColor Cyan
Write-Host "  +==========================================================+" -ForegroundColor Cyan
Write-Host ""

$url  = "https://raw.githubusercontent.com/Batlez/Batlez-Tweaks/main/Batlez%20Tweaks.bat"
$path = "$env:TEMP\Batlez-Tweaks.bat"

Write-Host "  Downloading latest version..." -ForegroundColor Gray

try {
    Invoke-WebRequest -Uri $url -OutFile $path -UseBasicParsing -ErrorAction Stop
} catch {
    Write-Host ""
    Write-Host "  [!] Download failed. Check your connection and try again." -ForegroundColor Red
    Write-Host "      Error: $_" -ForegroundColor DarkGray
    Write-Host ""
    pause
    exit 1
}

Write-Host "  Launching Batlez Tweaks..." -ForegroundColor Green
Write-Host ""

Start-Process cmd.exe -ArgumentList "/c `"$path`"" -Wait

Remove-Item $path -Force -ErrorAction SilentlyContinue