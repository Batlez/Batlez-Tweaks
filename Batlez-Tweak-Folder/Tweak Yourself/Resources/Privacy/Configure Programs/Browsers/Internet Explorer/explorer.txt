@echo off
:: Ensure admin privileges
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select "Run as administrator".
        pause & exit 1
    )
    exit 0
)


:: ----------------------------------------------------------
:: ----------Disable Chrome Software Reporter Tool-----------
:: ----------------------------------------------------------
echo --- Disable Chrome Software Reporter Tool
icacls "%localappdata%\Google\Chrome\User Data\SwReporter" /inheritance:r /deny "*S-1-1-0:(OI)(CI)(F)" "*S-1-5-7:(OI)(CI)(F)"
cacls "%localappdata%\Google\Chrome\User Data\SwReporter" /e /c /d %username%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisallowRun" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "1" /t REG_SZ /d "software_reporter_tool.exe" /f
:: ----------------------------------------------------------


:: Disable Chrome metrics reporting (shows "Your browser is managed")
echo --- Disable Chrome metrics reporting (shows "Your browser is managed")
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "MetricsReportingEnabled" /t REG_DWORD /d 0 /f
:: ----------------------------------------------------------


:: Do not share scanned software data to Google (shows "Your browser is managed")
echo --- Do not share scanned software data to Google (shows "Your browser is managed")
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "ChromeCleanupReportingEnabled" /t REG_DWORD /d 0 /f
:: ----------------------------------------------------------


:: Prevent Chrome from scanning the system for cleanup (shows "Your browser is managed")
echo --- Prevent Chrome from scanning the system for cleanup (shows "Your browser is managed")
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "ChromeCleanupEnabled" /t REG_DWORD /d 0 /f
:: ----------------------------------------------------------


pause
exit /b 0