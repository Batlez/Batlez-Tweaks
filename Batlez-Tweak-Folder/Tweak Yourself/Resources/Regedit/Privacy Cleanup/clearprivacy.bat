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
:: ----Clear credentials from Windows Credential Manager-----
:: ----------------------------------------------------------
echo --- Clear credentials from Windows Credential Manager
cmdkey.exe /list > "%TEMP%\List.txt"
findstr.exe Target "%TEMP%\List.txt" > "%TEMP%\tokensonly.txt"
FOR /F "tokens=1,2 delims= " %%G IN (%TEMP%\tokensonly.txt) DO cmdkey.exe /delete:%%H
del "%TEMP%\List.txt" /s /f /q
del "%TEMP%\tokensonly.txt" /s /f /q
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------Delete controversial default0 user------------
:: ----------------------------------------------------------
echo --- Delete controversial default0 user
net user defaultuser0 /delete 2>nul
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---------------------Empty trash bin----------------------
:: ----------------------------------------------------------
echo --- Empty trash bin
PowerShell -ExecutionPolicy Unrestricted -Command "$bin = (New-Object -ComObject Shell.Application).NameSpace(10); $bin.items() | ForEach {; Write-Host "^""Deleting $($_.Name) from Recycle Bin"^""; Remove-Item $_.Path -Recurse -Force; }"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------Enable Reset Base in Dism Component Store---------
:: ----------------------------------------------------------
echo --- Enable Reset Base in Dism Component Store
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "DisableResetbase" /t "REG_DWORD" /d "0" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---------Clear Windows Product Key from Registry----------
:: ----------------------------------------------------------
echo --- Clear Windows Product Key from Registry
cscript.exe //nologo "%SystemRoot%\system32\slmgr.vbs" /cpky
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------Clear volume backups (shadow copies)-----------
:: ----------------------------------------------------------
echo --- Clear volume backups (shadow copies)
vssadmin delete shadows /all /quiet
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------Remove Default Apps Associations-------------
:: ----------------------------------------------------------
echo --- Remove Default Apps Associations
dism /online /Remove-DefaultAppAssociations
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------Clear (Reset) Network Data Usage-------------
:: ----------------------------------------------------------
echo --- Clear (Reset) Network Data Usage
setlocal EnableDelayedExpansion 
    SET /A dps_service_running=0
    SC queryex "DPS"|Find "STATE"|Find /v "RUNNING">Nul||(
        SET /A dps_service_running=1
        net stop DPS
    )
    del /F /S /Q /A "%windir%\System32\sru*"
    IF !dps_service_running! == 1 (
        net start DPS
    )
endlocal
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------Clear previous Windows installations-----------
:: ----------------------------------------------------------
echo --- Clear previous Windows installations
if exist "%SystemDrive%\Windows.old" (
    takeown /f "%SystemDrive%\Windows.old" /a /r /d y
    icacls "%SystemDrive%\Windows.old" /grant administrators:F /t
    rd /s /q "%SystemDrive%\Windows.old"
    echo Deleted previous installation from "%SystemDrive%\Windows.old\"
)  else (
    echo No previous Windows installation has been found
)
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------------Clear Listary indexes-------------------
:: ----------------------------------------------------------
echo --- Clear Listary indexes
del /f /s /q %appdata%\Listary\UserData > nul
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---------------------Clear Java cache---------------------
:: ----------------------------------------------------------
echo --- Clear Java cache
rd /s /q "%APPDATA%\Sun\Java\Deployment\cache"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------------------Clear Flash traces--------------------
:: ----------------------------------------------------------
echo --- Clear Flash traces
rd /s /q "%APPDATA%\Macromedia\Flash Player"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------Clear Steam dumps, logs, and traces------------
:: ----------------------------------------------------------
echo --- Clear Steam dumps, logs, and traces
del /f /q %ProgramFiles(x86)%\Steam\Dumps
del /f /q %ProgramFiles(x86)%\Steam\Traces
del /f /q %ProgramFiles(x86)%\Steam\appcache\*.log
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----Clear Visual Studio telemetry and feedback data------
:: ----------------------------------------------------------
echo --- Clear Visual Studio telemetry and feedback data
rmdir /s /q "%AppData%\vstelemetry" 2>nul
rmdir /s /q "%LocalAppData%\Microsoft\VSApplicationInsights" 2>nul
rmdir /s /q "%ProgramData%\Microsoft\VSApplicationInsights" 2>nul
rmdir /s /q "%Temp%\Microsoft\VSApplicationInsights" 2>nul
rmdir /s /q "%Temp%\VSFaultInfo" 2>nul
rmdir /s /q "%Temp%\VSFeedbackPerfWatsonData" 2>nul
rmdir /s /q "%Temp%\VSFeedbackVSRTCLogs" 2>nul
rmdir /s /q "%Temp%\VSRemoteControl" 2>nul
rmdir /s /q "%Temp%\VSTelem" 2>nul
rmdir /s /q "%Temp%\VSTelem.Out" 2>nul
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------------Clear Dotnet CLI telemetry----------------
:: ----------------------------------------------------------
echo --- Clear Dotnet CLI telemetry
rmdir /s /q "%USERPROFILE%\.dotnet\TelemetryStorageService" 2>nul
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------------Clear regedit last key------------------
:: ----------------------------------------------------------
echo --- Clear regedit last key
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit" /va /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------------Clear regedit favorites------------------
:: ----------------------------------------------------------
echo --- Clear regedit favorites
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit\Favorites" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit\Favorites" /va /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------Clear list of recent programs opened-----------
:: ----------------------------------------------------------
echo --- Clear list of recent programs opened
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU" /va /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRULegacy" /va /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------------Clear Adobe Media Browser MRU---------------
:: ----------------------------------------------------------
echo --- Clear Adobe Media Browser MRU
reg delete "HKCU\Software\Adobe\MediaBrowser\MRU" /va /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------------------Clear MSPaint MRU---------------------
:: ----------------------------------------------------------
echo --- Clear MSPaint MRU
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" /va /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------------------Clear Wordpad MRU---------------------
:: ----------------------------------------------------------
echo --- Clear Wordpad MRU
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Wordpad\Recent File List" /va /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------Clear Map Network Drive MRU MRU--------------
:: ----------------------------------------------------------
echo --- Clear Map Network Drive MRU MRU
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU" /va /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------Clear Windows Search Assistant history----------
:: ----------------------------------------------------------
echo --- Clear Windows Search Assistant history
reg delete "HKCU\Software\Microsoft\Search Assistant\ACMru" /va /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------Clear list of Recent Files Opened, by Filetype------
:: ----------------------------------------------------------
echo --- Clear list of Recent Files Opened, by Filetype
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /va /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /va /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSaveMRU" /va /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----Clear windows media player recent files and URLs-----
:: ----------------------------------------------------------
echo --- Clear windows media player recent files and URLs
reg delete "HKCU\Software\Microsoft\MediaPlayer\Player\RecentFileList" /va /f
reg delete "HKCU\Software\Microsoft\MediaPlayer\Player\RecentURLList" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\MediaPlayer\Player\RecentFileList" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\MediaPlayer\Player\RecentURLList" /va /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------Clear Most Recent Application's Use of DirectX------
:: ----------------------------------------------------------
echo --- Clear Most Recent Application's Use of DirectX
reg delete "HKCU\Software\Microsoft\Direct3D\MostRecentApplication" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Direct3D\MostRecentApplication" /va /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------Clear Windows Run MRU & typedpaths------------
:: ----------------------------------------------------------
echo --- Clear Windows Run MRU ^& typedpaths
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /va /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------------Clear recently accessed files---------------
:: ----------------------------------------------------------
echo --- Clear recently accessed files
del /f /q "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---------------------Clear user pins----------------------
:: ----------------------------------------------------------
echo --- Clear user pins
del /f /q "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -Clear all Opera data (user profiles, settings, and data)-
:: ----------------------------------------------------------
echo --- Clear all Opera data (user profiles, settings, and data)
:: Windows XP
rd /s /q "%USERPROFILE%\Local Settings\Application Data\Opera\Opera"
:: Windows Vista and later
rd /s /q "%localappdata%\Opera\Opera"
rd /s /q "%APPDATA%\Opera\Opera"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------------Clear Internet Explorer caches--------------
:: ----------------------------------------------------------
echo --- Clear Internet Explorer caches
del /f /q "%localappdata%\Microsoft\Windows\INetCache\IE\*"
rd /s /q "%localappdata%\Microsoft\Windows\WebCache"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------Clear Internet Explorer recent URLs------------
:: ----------------------------------------------------------
echo --- Clear Internet Explorer recent URLs
reg delete "HKCU\SOFTWARE\Microsoft\Internet Explorer\TypedURLs" /va /f
reg delete "HKCU\SOFTWARE\Microsoft\Internet Explorer\TypedURLsTime" /va /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------Clear Temporary Internet Files (browser cache)------
:: ----------------------------------------------------------
echo --- Clear Temporary Internet Files (browser cache)
:: Windows XP
rd /s /q %userprofile%\Local Settings\Temporary Internet Files
:: Windows 7
rd /s /q "%localappdata%\Microsoft\Windows\Temporary Internet Files"
takeown /f "%localappdata%\Temporary Internet Files" /r /d y
icacls "%localappdata%\Temporary Internet Files" /grant administrators:F /t
rd /s /q "%localappdata%\Temporary Internet Files"
:: Windows 8 and above
rd /s /q "%localappdata%\Microsoft\Windows\INetCache"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------Clear Internet Explorer Feeds Cache------------
:: ----------------------------------------------------------
echo --- Clear Internet Explorer Feeds Cache
rd /s /q "%localappdata%\Microsoft\Feeds Cache"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------Clear Internet Explorer cookies--------------
:: ----------------------------------------------------------
echo --- Clear Internet Explorer cookies
:: Windows 7 browsers
rd /s /q "%APPDATA%\Microsoft\Windows\Cookies"
:: Windows 8 and higher
rd /s /q "%localappdata%\Microsoft\Windows\INetCookies"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------Clear Internet Explorer DOMStore-------------
:: ----------------------------------------------------------
echo --- Clear Internet Explorer DOMStore
rd /s /q "%localappdata%\Microsoft\InternetExplorer\DOMStore"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------Clear all Internet Explorer user data-----------
:: ----------------------------------------------------------
echo --- Clear all Internet Explorer user data
rd /s /q "%localappdata%\Microsoft\Internet Explorer"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------Clear Google Chrome crash reports-------------
:: ----------------------------------------------------------
echo --- Clear Google Chrome crash reports
rd /s /q "%localappdata%\Google\Chrome\User Data\Crashpad\reports\"
rd /s /q "%localappdata%\Google\CrashReports\"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------Clear Software Reporter Tool logs-------------
:: ----------------------------------------------------------
echo --- Clear Software Reporter Tool logs
del /f /q "%localappdata%\Google\Software Reporter Tool\*.log"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------------Clear all Chrome user data----------------
:: ----------------------------------------------------------
echo --- Clear all Chrome user data
:: Windows XP
rd /s /q "%USERPROFILE%\Local Settings\Application Data\Google\Chrome\User Data"
:: Windows Vista and later
rd /s /q "%localappdata%\Google\Chrome\User Data"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------Clear browsing history and caches-------------
:: ----------------------------------------------------------
echo --- Clear browsing history and caches
set ignoreFiles="content-prefs.sqlite" "permissions.sqlite" "favicons.sqlite"
for %%d in ("%APPDATA%\Mozilla\Firefox\Profiles\"
            "%USERPROFILE%\Local Settings\Application Data\Mozilla\Firefox\Profiles\"
        ) do (
    IF EXIST %%d (
        FOR /d %%p IN (%%d*) DO (
            for /f "delims=" %%f in ('dir /b /s "%%p\*.sqlite" 2^>nul') do (
                set "continue="
                for %%i in (%ignoreFiles%) do ( 
                    if %%i == "%%~nxf" (
                        set continue=1
                    )
                )
                if not defined continue (
                    del /q /s /f %%f
                )
            )
        )
    )
)
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---Clear all Firefox user profiles, settings, and data----
:: ----------------------------------------------------------
echo --- Clear all Firefox user profiles, settings, and data
rd /s /q "%localappdata%\Mozilla\Firefox\Profiles"
rd /s /q "%APPDATA%\Mozilla\Firefox\Profiles"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------------Clear Webpage Icons--------------------
:: ----------------------------------------------------------
echo --- Clear Webpage Icons
:: Windows XP
del /q /s /f "%USERPROFILE%\Local Settings\Application Data\Safari\WebpageIcons.db"
:: Windows Vista and later
del /q /s /f "%localappdata%\Apple Computer\Safari\WebpageIcons.db"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------------------Clear Safari cache--------------------
:: ----------------------------------------------------------
echo --- Clear Safari cache
:: Windows XP
del /q /s /f "%USERPROFILE%\Local Settings\Application Data\Apple Computer\Safari\Cache.db"
:: Windows Vista and later
del /q /s /f "%localappdata%\Apple Computer\Safari\Cache.db"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------------Clear Safari cookies-------------------
:: ----------------------------------------------------------
echo --- Clear Safari cookies
:: Windows XP
del /q /s /f "%USERPROFILE%\Local Settings\Application Data\Apple Computer\Safari\Cookies.db"
:: Windows Vista and later
del /q /s /f "%localappdata%\Apple Computer\Safari\Cookies.db"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: Clear all Safari data (user profiles, settings, and data)-
:: ----------------------------------------------------------
echo --- Clear all Safari data (user profiles, settings, and data)
:: Windows XP
rd /s /q "%USERPROFILE%\Local Settings\Application Data\Apple Computer\Safari"
:: Windows Vista and later
rd /s /q "%AppData%\Apple Computer\Safari"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------------Clear thumbnail cache-------------------
:: ----------------------------------------------------------
echo --- Clear thumbnail cache
del /f /s /q /a %LocalAppData%\Microsoft\Windows\Explorer\*.db
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------------Clear Windows temp files-----------------
:: ----------------------------------------------------------
echo --- Clear Windows temp files
del /f /q %localappdata%\Temp\*
rd /s /q "%WINDIR%\Temp"
rd /s /q "%TEMP%"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------------Clear main telemetry file-----------------
:: ----------------------------------------------------------
echo --- Clear main telemetry file
if exist "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" (
    takeown /f "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" /r /d y
    icacls "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" /grant administrators:F /t
    echo "" > "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
    echo Clear successful: "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
) else (
    echo "Main telemetry file does not exist. Good!"
)
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------Clear Event Logs in Event Viewer-------------
:: ----------------------------------------------------------
echo --- Clear Event Logs in Event Viewer
REM https://social.technet.microsoft.com/Forums/en-US/f6788f7d-7d04-41f1-a64e-3af9f700e4bd/failed-to-clear-log-microsoftwindowsliveidoperational-access-is-denied?forum=win10itprogeneral
wevtutil sl Microsoft-Windows-LiveId/Operational /ca:O:BAG:SYD:(A;;0x1;;;SY)(A;;0x5;;;BA)(A;;0x1;;;LA)
for /f "tokens=*" %%i in ('wevtutil.exe el') DO (
    echo Deleting event log: "%%i"
    wevtutil.exe cl %1 "%%i"
)
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------Clean Windows Defender scan history------------
:: ----------------------------------------------------------
echo --- Clean Windows Defender scan history
del "%ProgramData%\Microsoft\Windows Defender\Scans\History\" /s /f /q
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: Clear Optional Component Manager and COM+ components logs-
:: ----------------------------------------------------------
echo --- Clear Optional Component Manager and COM+ components logs
del /f /q %SystemRoot%\comsetup.log
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------Clear Distributed Transaction Coordinator logs------
:: ----------------------------------------------------------
echo --- Clear Distributed Transaction Coordinator logs
del /f /q %SystemRoot%\DtcInstall.log
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------Clear Pending File Rename Operations logs---------
:: ----------------------------------------------------------
echo --- Clear Pending File Rename Operations logs
del /f /q %SystemRoot%\PFRO.log
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------Clear Windows Deployment Upgrade Process Logs-------
:: ----------------------------------------------------------
echo --- Clear Windows Deployment Upgrade Process Logs
del /f /q %SystemRoot%\setupact.log
del /f /q %SystemRoot%\setuperr.log
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------------Clear Windows Setup Logs-----------------
:: ----------------------------------------------------------
echo --- Clear Windows Setup Logs
del /f /q %SystemRoot%\setupapi.log
del /f /q %SystemRoot%\Panther\*
del /f /q %SystemRoot%\inf\setupapi.app.log
del /f /q %SystemRoot%\inf\setupapi.dev.log
del /f /q %SystemRoot%\inf\setupapi.offline.log
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------Clear Windows System Assessment Tool logs---------
:: ----------------------------------------------------------
echo --- Clear Windows System Assessment Tool logs
del /f /q %SystemRoot%\Performance\WinSAT\winsat.log
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---------------Clear Password change events---------------
:: ----------------------------------------------------------
echo --- Clear Password change events
del /f /q %SystemRoot%\debug\PASSWD.LOG
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------------Clear user web cache database---------------
:: ----------------------------------------------------------
echo --- Clear user web cache database
del /f /q %localappdata%\Microsoft\Windows\WebCache\*.*
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----Clear system temp folder when no one is logged in-----
:: ----------------------------------------------------------
echo --- Clear system temp folder when no one is logged in
del /f /q %SystemRoot%\ServiceProfiles\LocalService\AppData\Local\Temp\*.*
:: ----------------------------------------------------------


:: Clear DISM (Deployment Image Servicing and Management) Logs
echo --- Clear DISM (Deployment Image Servicing and Management) Logs
del /f /q  %SystemRoot%\Logs\CBS\CBS.log
del /f /q  %SystemRoot%\Logs\DISM\DISM.log
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------Clear WUAgent (Windows Update History) logs--------
:: ----------------------------------------------------------
echo --- Clear WUAgent (Windows Update History) logs
setlocal EnableDelayedExpansion 
    SET /A wuau_service_running=0
    SC queryex "wuauserv"|Find "STATE"|Find /v "RUNNING">Nul||(
        SET /A wuau_service_running=1
        net stop wuauserv
    )
    del /q /s /f "%SystemRoot%\SoftwareDistribution"
    IF !wuau_service_running! == 1 (
        net start wuauserv
    )
endlocal
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------Clear Server-initiated Healing Events Logs--------
:: ----------------------------------------------------------
echo --- Clear Server-initiated Healing Events Logs
del /f /q "%SystemRoot%\Logs\SIH\*"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---------------Common Language Runtime Logs---------------
:: ----------------------------------------------------------
echo --- Common Language Runtime Logs
del /f /q "%LocalAppData%\Microsoft\CLR_v4.0\UsageTraces\*"
del /f /q "%LocalAppData%\Microsoft\CLR_v4.0_32\UsageTraces\*"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------Network Setup Service Events Logs-------------
:: ----------------------------------------------------------
echo --- Network Setup Service Events Logs
del /f /q "%SystemRoot%\Logs\NetSetup\*"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------Disk Cleanup tool (Cleanmgr.exe) Logs-----------
:: ----------------------------------------------------------
echo --- Disk Cleanup tool (Cleanmgr.exe) Logs
del /f /q "%SystemRoot%\System32\LogFiles\setupcln\*"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------Clear Windows update and SFC scan logs----------
:: ----------------------------------------------------------
echo --- Clear Windows update and SFC scan logs
del /f /q %SystemRoot%\Temp\CBS\*
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---------Clear Windows Update Medic Service logs----------
:: ----------------------------------------------------------
echo --- Clear Windows Update Medic Service logs
takeown /f %SystemRoot%\Logs\waasmedic /r /d y
icacls %SystemRoot%\Logs\waasmedic /grant administrators:F /t
rd /s /q %SystemRoot%\Logs\waasmedic
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------Clear Cryptographic Services Traces------------
:: ----------------------------------------------------------
echo --- Clear Cryptographic Services Traces
del /f /q %SystemRoot%\System32\catroot2\dberr.txt
del /f /q %SystemRoot%\System32\catroot2.log
del /f /q %SystemRoot%\System32\catroot2.jrs
del /f /q %SystemRoot%\System32\catroot2.edb
del /f /q %SystemRoot%\System32\catroot2.chk
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------------Windows Update Events Logs----------------
:: ----------------------------------------------------------
echo --- Windows Update Events Logs
del /f /q "%SystemRoot%\Logs\SIH\*"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------------Windows Update Logs--------------------
:: ----------------------------------------------------------
echo --- Windows Update Logs
del /f /q "%SystemRoot%\Traces\WindowsUpdate\*"
:: ----------------------------------------------------------


pause
exit /b 0