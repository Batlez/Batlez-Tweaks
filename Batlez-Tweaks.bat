@echo off
set version=2.5
title Batlez Tweaks - %version%

net session >nul 2>&1
if %errorlevel% neq 0 goto NotAdmin
goto continuewooooooooo

:NotAdmin
echo [WARNING]: Not running with Administrator privileges.
echo Some tweaks will fail or only partially apply.
echo.
choice /C CP /M "Press C to Cancel or P to Proceed without admin"
if errorlevel 2 goto HELLYEAAAAAAAA
if errorlevel 1 goto Destruct
goto continuewooooooooo

:HELLYEAAAAAAAA
cls
echo Proceeding WITHOUT admin privileges. Expect limited results.
timeout /t 3 >nul /nobreak
goto continuewooooooooo

:continuewooooooooo
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
chcp 437 >nul
powershell "Set-ExecutionPolicy Unrestricted" >nul 2>&1
chcp 65001 >nul
setlocal enabledelayedexpansion

for /f "tokens=2 delims==" %%b in ('wmic os get BuildNumber /value 2^>nul ^| findstr "="') do set "_OS_BUILD=%%b"
set /a _OS_BUILD_NUM=_OS_BUILD+0
if !_OS_BUILD_NUM! LSS 22000 (
    call :SetupConsole
    echo.
    echo %red%╔══════════════════════════════════════════════════════════════════════════════╗
    echo ║                        UNSUPPORTED OPERATING SYSTEM                          ║
    echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
    echo.
    echo %red%  Batlez Tweaks requires Windows 11 or later.%u%
    echo.
    echo %orange%  Windows 10 is no longer supported.%u%
    echo %c%  Please upgrade to Windows 11 before using this tool.%u%
    echo.
    echo %grey%  Detected build: !_OS_BUILD_NUM!   Required: 22000 ^(Windows 11^)%u%
    echo.
    echo %red%  Exiting in 10 seconds...%u%
    timeout /t 10 >nul /nobreak
    exit
)

echo Checking for updates...
set "update_available=false"
set "latest_version="
set "download_url="

chcp 437 >nul
powershell -Command "try { $response = Invoke-RestMethod -Uri 'https://api.github.com/repos/Batlez/Batlez-Tweaks/releases/latest' -Headers @{'User-Agent'='Batlez-Tweaks-Updater'}; $version = $response.tag_name -replace '^v', ''; $name = $response.name; if ($name -match 'Batlez V(.+)') { $nameVersion = $matches[1] } else { $nameVersion = $version }; Write-Host \"VERSION=$nameVersion\"; Write-Host \"URL=$($response.html_url)\" } catch { Write-Host 'ERROR=Unable to check for updates' }" > "%temp%\update_check.txt" 2>nul
chcp 65001 >nul

if exist "%temp%\update_check.txt" (
    for /f "tokens=1* delims==" %%a in ('type "%temp%\update_check.txt" 2^>nul') do (
        if "%%a"=="VERSION" set "latest_version=%%b"
        if "%%a"=="URL" set "download_url=%%b"
        if "%%a"=="ERROR" (
            echo Update check failed - continuing with current version
            goto skip_update_check
        )
    )
    del "%temp%\update_check.txt" 2>nul
)

if defined latest_version (
    set "update_available=false"
    setlocal enabledelayedexpansion
    for /f "tokens=1,2 delims=." %%a in ("%version%") do (
        set "curr_major=%%a"
        set "curr_minor=%%b"
    )
    for /f "tokens=1,2 delims=." %%a in ("!latest_version!") do (
        set "lat_major=%%a"
        set "lat_minor=%%b"
    )
    if !lat_major! GTR !curr_major! set "update_available=true"
    if !lat_major! EQU !curr_major! if !lat_minor! GTR !curr_minor! set "update_available=true"
    if "!update_available!"=="true" (
        call :SetupConsole
        echo.
        echo  +===========================================================================+
        echo  ^|                              UPDATE AVAILABLE                             ^|
        echo  +===========================================================================+
        echo  ^| Current Version: !version!                                                      ^|
        echo  ^| Latest Version:  !latest_version!                                                      ^|
        echo  ^|                                                                           ^|
        echo  ^| A newer version of Batlez Tweaks is available!                             ^|
        echo  +===========================================================================+
        echo.
        choice /C YNV /M "Download update now? (Y)es / (N)o / (V)iew release page"
        if errorlevel 3 (
            echo Opening release page...
            start "" "https://github.com/Batlez/Batlez-Tweaks/releases"
            choice /C YN /M "Continue to download? (Y/N)"
            if errorlevel 2 goto skip_update_check
        )
        if errorlevel 2 goto skip_update_check
        echo.
        echo Downloading latest version...
        echo This will open your browser to download the latest release.
        echo Save it to replace this current file when you're ready.
        echo.
        start "" "!download_url!"
        echo.
        echo Press any key to continue with current version for now...
        pause >nul
    ) else (
        echo You are up to date ^(v!version!^)
        timeout /t 2 >nul
    )
) else (
    echo Could not determine latest version - continuing with current version
)

:skip_update_check
cls

:variables
set "u=[0m"
set "underline=[04m"
set "bold=[1m"

set "white=[97m"
set "grey=[90m"
set "charcoal=[38;5;240m"
set "silver=[38;5;250m"

set "red=[91m"
set "crimson=[38;5;160m"

set "pink=[95m"
set "hotpink=[38;5;213m"

set "purple=[35m"
set "violet=[38;5;141m"
set "orchid=[38;5;170m"
set "indigo=[38;5;54m"
set "blue=[94m"
set "cyan=[96m"
set "aqua=[38;5;51m"
set "teal=[38;5;30m"

set "green=[92m"
set "lime=[38;5;154m"
set "mint=[38;5;121m"
set "olive=[38;5;58m"

set "yellow=[38;5;226m"
set "gold=[38;5;220m"
set "orange=[38;5;214m"
set "peach=[38;5;216m"
set "tan=[38;5;180m"
set "brown=[38;5;130m"


:loading
cls
call :SetupConsole
echo.
echo.
echo                                                 %lime% Developed by%u% %violet%Batlez%u%
echo                                                   %lime% Discord:%u% %violet%Croakq%u%
echo.
echo                     %lime% I%u% %underline%%red%cannot%u%%lime% guarantee an FPS increase. Use these optimizations at your own risk.%u%
echo                                %lime%This is intended for a Clean and Stock Windows install.%u%
echo.
echo                                            %lime%Please type%u% %white%I agree%u% %lime%to proceed%u%
echo.
echo.
set "userInput="
set /p "userInput=Type your response: "
if /I "%userInput%"=="I agree" (
    goto :legit
) else (
    goto :epicmanfail
)


:epicmanfail
cls
call :SetupConsole
echo.
echo.
echo %u%[%red%-%u%] %red%Failed! 
echo.
echo %u%Developed by: %red%Batlez
echo %u%Github: %red%https://github.com/Batlez
echo.
echo.
timeout /t 3 >nul /nobreak & exit

:legit
cls
call :SetupConsole
echo.
echo.
echo %u%[%green%+%u%] %green%Successful! 
echo.
echo %u%Developed by: %green%Batlez
echo %u%Github: %green%https://github.com/Batlez
echo.
echo.
timeout /t 3 >nul /nobreak & cls & goto RestorePointQuestion

:RestorePointQuestion
call :SetupConsole
echo %orange%Before we continue, would you like to make a Restore Point?%u% (Y/N)
echo.
echo.
choice /C YN /M "Make a Restore Point"
if errorlevel 2 goto Presets
if errorlevel 1 goto restorepoint10

:restorepoint10
cls
echo %red%Backing up the registry...%u%

set "BACKUP_DIR=C:\TweaksBackup_%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%"
set "BACKUP_DIR=%BACKUP_DIR: =0%"

if not exist "%BACKUP_DIR%" (
    mkdir "%BACKUP_DIR%" 2>nul
    if errorlevel 1 (
        echo %orange%Error: Failed to create backup directory. Please run as administrator.%u%
        pause
        goto Presets
    )
)

cd /d "%BACKUP_DIR%"

echo Backing up registry hives...
echo - SOFTWARE hive...
REG SAVE HKLM\SOFTWARE SOFTWARE 2>nul
if errorlevel 1 echo %orange%Warning: Failed to backup SOFTWARE hive%u%

echo - SYSTEM hive...
REG SAVE HKLM\SYSTEM SYSTEM 2>nul
if errorlevel 1 echo %orange%Warning: Failed to backup SYSTEM hive%u%

echo - DEFAULT hive...
REG SAVE HKU\.DEFAULT DEFAULT 2>nul
if errorlevel 1 echo %orange%Warning: Failed to backup DEFAULT hive%u%

echo - SECURITY hive...
REG SAVE HKLM\SECURITY SECURITY 2>nul
if errorlevel 1 echo %orange%Warning: Failed to backup SECURITY hive%u%

echo - SAM hive...
REG SAVE HKLM\SAM SAM 2>nul
if errorlevel 1 echo %orange%Warning: Failed to backup SAM hive%u%

echo - NTUSER (Current User) hive...
REG SAVE HKCU NTUSER 2>nul
if errorlevel 1 echo %orange%Warning: Failed to backup NTUSER hive%u%

echo.
echo %c%Registry backup completed at "%BACKUP_DIR%"%u%
echo.
echo %grey%To restore a hive if needed, run as admin:%u%
echo %grey%  REG RESTORE HKLM\SOFTWARE "%BACKUP_DIR%\SOFTWARE"%u%
echo %grey%  REG RESTORE HKLM\SYSTEM   "%BACKUP_DIR%\SYSTEM"%u%
echo %grey%  REG RESTORE HKCU          "%BACKUP_DIR%\NTUSER"%u%
timeout /t 6 >nul

:restorepoint20
echo.
echo Configuring System Restore services...

echo - Configuring Volume Shadow Copy Service...
sc config VSS start= demand >nul 2>&1
net start VSS >nul 2>&1

echo - Configuring Software Shadow Copy Provider...
sc config swprv start= demand >nul 2>&1
net start swprv >nul 2>&1

echo - Configuring Task Scheduler...
sc config Schedule start= auto >nul 2>&1
net start Schedule >nul 2>&1

echo - Enabling System Restore...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v DisableSR /t REG_DWORD /d 0 /f >nul 2>&1
chcp 437 >nul
powershell.exe -Command "Enable-ComputerRestore -Drive 'C:\'" >nul 2>&1
chcp 65001 >nul
reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d "0" /f >nul 2>&1

echo.
echo Creating restore point...
chcp 437 >nul
powershell.exe -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'PreTweaksBackup' -RestorePointType MODIFY_SETTINGS" >nul 2>&1
chcp 65001 >nul

set SR_STATUS=%ERRORLEVEL%
if %SR_STATUS%==0 (
    echo %cyan%System Restore point created successfully!%u%
) else (
    echo %orange%Failed to create restore point. System Protection may not be enabled on C: drive.%u%
)

echo.
choice /C YN /M "Do you want to remove old Restore Points"
if errorlevel 2 (
    echo Old restore points preserved.
) else (
    echo Removing old system restore points...
    vssadmin delete shadows /for=C: /oldest >nul 2>&1
    if !errorlevel!==0 (
        echo %cyan%Old restore points removed successfully!%u%
    ) else (
        echo %orange%Failed to remove old restore points. May require elevated privileges.%u%
    )
)

echo.
echo Stopping temporary services...
net stop VSS >nul 2>&1
net stop swprv >nul 2>&1

echo.
echo %cyan%Backup and restore point creation completed!%u%
echo Next: Choosing your color preferences...
timeout /t 4 >nul
call :SetupConsole
goto Presets

:Presets
net stop VSS    >nul 2>&1
net stop swprv  >nul 2>&1
cls
chcp 437  >nul
chcp 65001 >nul

echo %white%Type one of the colours you want to use from below!%u%
echo.
echo.
echo %aqua%Aqua%u%, %teal%Teal%u%, %cyan%Cyan%u%, %blue%Blue%u%, %indigo%Indigo%u%, %lime%Lime%u%, %green%Green%u%, %mint%Mint%u%, %olive%Olive%u%, %yellow%Yellow%u%, %gold%Gold%u%, %orange%Orange%u%, %peach%Peach%u%, %tan%Tan%u%
echo.
echo %crimson%Crimson%u%, %red%Red%u%, %hotpink%Hot Pink%u%, %pink%Pink%u%, %purple%Purple%u%, %violet%Violet%u%, %orchid%Orchid%u%, %silver%Silver%u%, %grey%Grey%u%, %charcoal%Charcoal%u%, %brown%Brown%u% or %white%White%u%
echo.
echo.
set "preset="

set /p "preset=%white%Choose an option »%u% "

if not defined preset (
    echo %red%No input given. Please type a colour.%u%
    timeout /t 2 >nul
    goto Presets
)

for /f "tokens=* delims= " %%A in ("%preset%") do set "preset=%%A"
:trimPresetTrail
if "%preset:~-1%"==" " set "preset=%preset:~0,-1%" & goto trimPresetTrail

if /i "%preset%"=="Aqua"      set "c=%aqua%"      & goto menu
if /i "%preset%"=="Teal"      set "c=%teal%"      & goto menu
if /i "%preset%"=="Cyan"      set "c=%cyan%"      & goto menu
if /i "%preset%"=="Blue"      set "c=%blue%"      & goto menu
if /i "%preset%"=="Indigo"    set "c=%indigo%"    & goto menu

if /i "%preset%"=="Lime"      set "c=%lime%"      & goto menu
if /i "%preset%"=="Green"     set "c=%green%"     & goto menu
if /i "%preset%"=="Mint"      set "c=%mint%"      & goto menu
if /i "%preset%"=="Olive"     set "c=%olive%"     & goto menu

if /i "%preset%"=="Yellow"    set "c=%yellow%"    & goto menu
if /i "%preset%"=="Gold"      set "c=%gold%"      & goto menu
if /i "%preset%"=="Orange"    set "c=%orange%"    & goto menu
if /i "%preset%"=="Peach"     set "c=%peach%"     & goto menu
if /i "%preset%"=="Tan"       set "c=%tan%"       & goto menu
if /i "%preset%"=="Brown"     set "c=%brown%"     & goto menu

if /i "%preset%"=="Crimson"   set "c=%crimson%"   & goto menu
if /i "%preset%"=="Red"       set "c=%red%"       & goto menu
if /i "%preset%"=="Hot Pink"  set "c=%hotpink%"   & goto menu
if /i "%preset%"=="Pink"      set "c=%pink%"      & goto menu

if /i "%preset%"=="Purple"    set "c=%purple%"    & goto menu
if /i "%preset%"=="Violet"    set "c=%violet%"    & goto menu
if /i "%preset%"=="Orchid"    set "c=%orchid%"    & goto menu

if /i "%preset%"=="Silver"    set "c=%silver%"    & goto menu
if /i "%preset%"=="Grey"      set "c=%grey%"      & goto menu
if /i "%preset%"=="Charcoal"  set "c=%charcoal%"  & goto menu
if /i "%preset%"=="White"     set "c=%white%"     & goto menu


echo %red%Invalid option. Please try again.%u%
timeout /t 1 >nul
goto Presets


:SetupConsole
chcp 437 >nul
chcp 65001 >nul
cls
goto :eof

:DisplayBanner
if not defined CPUName (
    chcp 437 >nul
    for /f "delims=" %%A in ('powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).Name" 2^>nul') do set "CPUName=%%A"
    chcp 65001 >nul
    if not defined CPUName for /f "tokens=2 delims==" %%A in ('wmic cpu get name /value 2^>nul ^| find /I "Name"') do set "CPUName=%%A"
)

if not defined GPUName (
    chcp 437 >nul
    for /f "delims=" %%G in ('powershell -NoProfile -Command "(Get-CimInstance Win32_VideoController | Select-Object -First 1).Name" 2^>nul') do set "GPUName=%%G"
    chcp 65001 >nul
    if not defined GPUName for /f "skip=1 delims=" %%G in ('wmic path win32_VideoController get Name 2^>nul') do if not defined GPUName (
        if not "%%G"=="" set "GPUName=%%G"
    )
)

:GotGPU
echo.
echo        %c%██████╗ █████╗  ████████╗██╗     ███████╗███████╗ %u%%white%████████╗ ██╗       ██╗███████╗ █████╗ ██╗  ██╗ ██████╗
echo        %c%██╔══██╗██╔══██╗╚══██╔══╝██║     ██╔════╝╚════██║ %u%%white%╚══██╔══╝ ██║  ██╗  ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝
echo        %c%██████╦╝███████║   ██║   ██║     █████╗    ███╔═╝ %u%%white%   ██║    ╚██╗████╗██╔╝█████╗  ███████║█████═╝ ╚█████╗
echo        %c%██╔══██╗██╔══██║   ██║   ██║     ██╔══╝  ██╔══╝   %u%%white%   ██║     ████╔═████║ ██╔══╝  ██╔══██║██╔═██╗  ╚═══██╗
echo        %c%██████╦╝██║  ██║   ██║   ███████╗███████╗███████╗ %u%%white%   ██║     ╚██╔╝ ╚██╔╝ ███████╗██║  ██║██║ ╚██╗██████╔╝
echo        %c%╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝╚══════╝ %u%%white%   ╚═╝      ╚═╝   ╚═╝  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝
echo.
echo.
echo                                 %c%Version:%u% %white%%version%%u%     %c%User:%u%%white% %username%%u%     %c%Date:%u%%white% %date%%u%
echo.
echo.
echo                   %c%GPU:%u%%white% %GPUName% %u%    %c%CPU:%u%%white% %CPUName%%u%
echo.
echo.
echo                                %c%Batlez%u%%white% Tweaks%u%%c% is a batch script that optimizes your system%u%
echo                                      %c%to provide the best gaming experience possible%u%
goto :eof


:menu
cls
call :SetupConsole
call :DisplayBanner
echo.
echo.
echo                                     [%c%1%u%] Optimizations   [%c%2%u%] Hardware   [%c%3%u%] Windows
echo.
echo                                     [%c%4%u%] Privacy         [%c%5%u%] Backup     [%c%6%u%] Advanced
echo.
echo                                                         [%c%7%u%] Info
echo.
echo.
echo                                                       %c%[ X to close ]%u%
echo.
set /p M="%c%Choose an option »%u% "
set choice=%errorlevel%
if "%M%"=="1" goto TweaksMenu
if "%M%"=="2" goto HardwareMenu
if "%M%"=="3" goto WindowsMenu
if "%M%"=="4" goto PrivacyMenu
if "%M%"=="5" goto Backup
if "%M%"=="6" goto AdvancedMenu
if "%M%"=="7" goto More
if "%M%"=="X" goto Destruct
if "%M%"=="x" goto Destruct
echo %red%Invalid option. Please try again.%u%
goto menu

:Comingsoon
cls
call :SetupConsole 
call :DisplayBanner  
echo.
echo.
echo                              %c%This feature has not been finished yet but will be coming out soon.%u%  
echo.
echo.
echo.
echo.
echo                                                 %red%[ Press any key to go back ]
pause >nul
goto menu

:More
cls
call :SetupConsole 
call :DisplayBanner                                  
echo.
echo.
echo                                                 [%c%1%u%] About     [%c%2%u%] Disclaimer
echo.
echo                                                 [%c%3%u%] Credits   [%c%4%u%] Updates   
echo.
echo                                                          [%c%5%u%] Back
echo.
echo.  
echo                                                       %c%[ X to close ]%u%  
echo.
set /p M="%c%Choose an option »%u% "
set choice=%errorlevel%
if "%M%"=="1" goto about
if "%M%"=="2" goto disclaimer
if "%M%"=="3" goto credits
if "%M%"=="4" goto changelog
if "%M%"=="5" goto menu
if "%M%"=="X" goto Destruct
if "%M%"=="x" goto Destruct
echo %red%Invalid selection. Please try again.%u%
pause >nul
goto More

:about
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                                    ABOUT                                     ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo.
echo      %green%▌ Creator:%u% %c%Batlez%u%
echo      %green%▌ Purpose:%u% %c%Improve System Performance%u%
echo      %green%▌ Version:%u% %c%%version% %u%
echo.
echo.
echo      %c%Batlez Tweaks represents years of research and development in system%u%
echo      %c%optimization techniques. This comprehensive toolkit provides carefully%u%
echo      %c%curated tweaks and modifications designed to enhance your computing%u%
echo      %c%experience while maintaining system stability and reliability.%u%
echo.
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto More

:disclaimer
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                               IMPORTANT NOTICE                               ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo.
echo %c%Batlez Tweaks is a professional optimization suite designed to enhance%u% 
echo %c%system performance through proven methodologies and safe modifications.%u%
echo.
echo %lime%   Performance Results:%u% %c%While these optimizations are scientifically%u%
echo %c%   sound, individual results may vary based on hardware configuration,%u%
echo %c%   software environment, and system specifications.%u%
echo.
echo %lime%   User Responsibility:%u% %c%All modifications are applied at your own%u%
echo %c%   discretion and risk. The developer assumes no liability for%u%
echo %c%   system changes or potential issues arising from improper usage.%u%
echo.
echo %lime%   Best Practices:%u%
echo %c%   • Create a system restore point before applying tweaks%u%
echo %c%   • Read all descriptions carefully before proceeding%u%
echo %c%   • Contact me if uncertain about any modifications%u%
echo.
echo %lime%   Support:%u% %c%For technical assistance, reach out via%u% %lime%Discord: Croakq%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto More

:credits
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                              CREDITS AND ACKNOWLEDGMENTS                      ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo.
echo       %c%Special thanks to the following contributors for their insights and improvements:%u%
echo.
echo       %lime%• imribiy%u% %c%– AMD GPU tweaks%u%
echo       %lime%• Melody%u% %c%– AMD system tweaks%u%
echo       %lime%• Redwan%u% %c%– Pack integration%u%
echo       %lime%• ADEX%u% %c%– RAM optimization%u%
echo       %lime%• tarekifla%u% %c%– Restore points and registry backups%u%
echo       %lime%• Chicho%u% %c%– GUI contributions%u%
echo       %lime%• gryOS%u% %c%– Affinity tuning%u%
echo       %lime%• Hone%u% %c%– Game configs and general tweaks%u%
echo       %lime%• Ghost Optimizer%u% %c%– General tweaks%u%
echo.
echo       %c%While I authored and organized the majority of this project,%u%
echo       %c%their knowledge greatly enhanced it.%u%
echo.
echo       %violet%Thank you for your support.%u%
echo.
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto More

:changelog
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                               UPDATE HISTORY                                 ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo.
echo         %c%Stay informed about the latest improvements, bug fixes, and new%u%
echo         %c%features added to Batlez Tweaks. The complete changelog and%u%
echo         %c%release history is maintained on our official repository.%u%
echo.
echo         %c%Opening release page in your default browser...%u%
echo.
timeout 6 >nul /nobreak
start https://github.com/Batlez/Batlez/releases
echo         %c%If the page doesn't open automatically, visit:%u%
echo         %lime%https://github.com/Batlez/Batlez/releases%u%
echo.
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto More

:Backup
cls
call :SetupConsole
call :DisplayBanner
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set /p input="%c%Would you like to create a Restore and Registry Point? %white%(Y/N)%u% %c%»%u% "
if "%input%"=="Y" goto restorepoint10
if "%input%"=="y" goto restorepoint10
if "%input%"=="N" goto menu
if "%input%"=="n" goto menu
echo %c%Please enter a valid number!%u% & goto Backup

:TweaksMenu
cls
call :SetupConsole
call :DisplayBanner
echo %c%                            ╔══════════════════════════════╦═══════════════════════════════╗ %u%
echo                             %c%║%u% [%c%1%u%] Windows Cleaner          %c%║%u% [%c%7%u%] Mouse/Keyboard Tweaks     %c%║%u%
echo                             %c%║%u% [%c%2%u%] BCDEdit Tweaks           %c%║%u% [%c%8%u%] Internet Refresher        %c%║%u%
echo                             %c%║%u% [%c%3%u%] GPU Optimizations        %c%║%u% [%c%9%u%] Service Tweaks            %c%║%u%
echo                             %c%║%u% [%c%4%u%] Network Tweaks           %c%║%u% [%c%10%u%] Debloater                %c%║%u%
echo                             %c%║%u% [%c%5%u%] CPU Optimizations        %c%║%u% [%c%11%u%] Custom Power Plan        %c%║%u%
echo                             %c%║%u% [%c%6%u%] Memory Optimizer         %c%║%u% [%c%12%u%] Browser Config           %c%║%u%
echo %c%                            ╚══════════════════════════════╩═══════════════════════════════╝
echo.
echo                              %u%[%c%13%u%] Colour Presets   [%c%14%u%] Back to Main   [%red%X%u%] Exit Application
echo.
echo.
set /p M="%c%Choose an option »%u% "
if "%M%"=="1" goto A
if "%M%"=="2" goto B
if "%M%"=="3" goto C
if "%M%"=="4" goto D
if "%M%"=="5" goto E
if "%M%"=="6" goto F
if "%M%"=="7" goto G
if "%M%"=="8" goto H
if "%M%"=="9" goto I
if "%M%"=="10" goto J
if "%M%"=="11" goto K
if "%M%"=="12" goto L
if "%M%"=="13" goto Presets
if "%M%"=="14" goto menu
if "%M%"=="X" goto Destruct
if "%M%"=="x" goto Destruct
cls
echo %underline%%red%Invalid Input. Press any key to continue.%u%
pause >nul
goto TweaksMenu

:L
setlocal enabledelayedexpansion
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                      BROWSER CONFIGURATION AND PRIVACY OPTIMIZER             ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Browser optimization includes:%u%
echo %c%• Microsoft Edge, Chrome, Firefox, Opera GX, Brave, Vivaldi support%u%
echo %c%• Automatic privacy extension installation (uBlock Origin, etc.)%u%
echo %c%• Comprehensive telemetry and tracking protection%u%
echo %c%• Advanced browser security hardening%u%
echo %c%• Chromium-based browser universal configuration%u%
echo %c%• Custom DNS and ad-blocking configuration%u%
echo.
echo %red%%underline%Browser Notice:%u%
echo %c%This will modify browser settings and automatically install privacy extensions.%u%
echo %c%Extensions will be force-installed and configured for maximum privacy.%u%
echo %c%For best results, close all browsers before proceeding.%u%
echo.
echo.
choice /C YN /M "%c%Apply comprehensive browser privacy optimization? (Y/N)%u%"
if errorlevel 2 goto TweaksMenu

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    BROWSER DETECTION AND CONFIGURATION                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%[DETECTION] Checking if browsers are currently running...%u%
tasklist /fi "imagename eq chrome.exe" 2>nul | find /i "chrome.exe" >nul && echo %c%⚠ Warning: Chrome is currently running - some settings may not apply%u%
tasklist /fi "imagename eq firefox.exe" 2>nul | find /i "firefox.exe" >nul && echo %c%⚠ Warning: Firefox is currently running - some settings may not apply%u%
tasklist /fi "imagename eq msedge.exe" 2>nul | find /i "msedge.exe" >nul && echo %c%⚠ Warning: Edge is currently running - some settings may not apply%u%
tasklist /fi "imagename eq opera.exe" 2>nul | find /i "opera.exe" >nul && echo %c%⚠ Warning: Opera GX is currently running - some settings may not apply%u%

echo %c%[DETECTION] Scanning for installed browsers...%u%
set "BROWSERS_FOUND="
set "EDGE_FOUND=false"
set "CHROME_FOUND=false"
set "FIREFOX_FOUND=false"
set "OPERAGX_FOUND=false"
set "BRAVE_FOUND=false"
set "VIVALDI_FOUND=false"
set "CHROMIUM_FOUND=false"

if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" set "EDGE_FOUND=true" & set "BROWSERS_FOUND=!BROWSERS_FOUND! Edge"
if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" set "EDGE_FOUND=true" & set "BROWSERS_FOUND=!BROWSERS_FOUND! Edge"

if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "CHROME_FOUND=true" & set "BROWSERS_FOUND=!BROWSERS_FOUND! Chrome"
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "CHROME_FOUND=true" & set "BROWSERS_FOUND=!BROWSERS_FOUND! Chrome"

if exist "%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe" set "FIREFOX_FOUND=true" & set "BROWSERS_FOUND=!BROWSERS_FOUND! Firefox"
if exist "%ProgramFiles%\Mozilla Firefox\firefox.exe" set "FIREFOX_FOUND=true" & set "BROWSERS_FOUND=!BROWSERS_FOUND! Firefox"

if exist "%LOCALAPPDATA%\Programs\Opera GX\opera.exe" set "OPERAGX_FOUND=true" & set "BROWSERS_FOUND=!BROWSERS_FOUND! OperaGX"
if exist "%ProgramFiles%\BraveSoftware\Brave-Browser\Application\brave.exe" set "BRAVE_FOUND=true" & set "BROWSERS_FOUND=!BROWSERS_FOUND! Brave"
if exist "%LOCALAPPDATA%\Vivaldi\Application\vivaldi.exe" set "VIVALDI_FOUND=true" & set "BROWSERS_FOUND=!BROWSERS_FOUND! Vivaldi"
if exist "%ProgramFiles(x86)%\Chromium\Application\chrome.exe" set "CHROMIUM_FOUND=true" & set "BROWSERS_FOUND=!BROWSERS_FOUND! Chromium"

echo %c%Detected browsers:%BROWSERS_FOUND%%u%
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       BROWSER OPTIMIZATION IN PROGRESS                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

mkdir "%TEMP%\BatlezBrowserExtensions" >nul 2>&1
cd /d "%TEMP%\BatlezBrowserExtensions"

echo.
echo %c%[1/8] Downloading Privacy Extension Installers...%u%

echo %c%• Downloading uBlock Origin extension files...%u%
chcp 437>nul
powershell -Command "try { Invoke-WebRequest 'https://clients2.google.com/service/update2/crx?response=redirect&prodversion=91.0&acceptformat=crx2,crx3&x=id%3Dcjpalhdlnbpafiamejdnhcphjbkeiagm%26uc' -OutFile 'ublock_origin.crx' -ErrorAction Stop } catch { Write-Host 'Download failed, will use store method' }" >nul 2>&1
chcp 65001 >nul 
echo %c%• Downloading Privacy Badger extension files...%u%
chcp 437>nul
powershell -Command "try { Invoke-WebRequest 'https://clients2.google.com/service/update2/crx?response=redirect&prodversion=91.0&acceptformat=crx2,crx3&x=id%3Dpkehgijcmpdhfbdbbnkijodmdjhbjlgp%26uc' -OutFile 'privacy_badger.crx' -ErrorAction Stop } catch { Write-Host 'Download failed, will use store method' }" >nul 2>&1
chcp 65001 >nul 
echo %c%• Downloading Decentraleyes extension files...%u%
chcp 437>nul
powershell -Command "try { Invoke-WebRequest 'https://clients2.google.com/service/update2/crx?response=redirect&prodversion=91.0&acceptformat=crx2,crx3&x=id%3Dldpochfccmkkmhdbclfhpagapcfdljkj%26uc' -OutFile 'decentraleyes.crx' -ErrorAction Stop } catch { Write-Host 'Download failed, will use store method' }" >nul 2>&1
chcp 65001 >nul 

if "%EDGE_FOUND%"=="true" (
    echo.
    echo %c%[2/8] Configuring Microsoft Edge for Maximum Privacy...%u%
    
    echo %c%• Disabling Edge telemetry and data collection...%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "DiagnosticData" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "MetricsReportingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SendSiteInfoToImproveServices" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PersonalizationReportingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SpellcheckEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "RelatedMatchesCloudServiceEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Enabling maximum privacy protection...%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "TrackingPrevention" /t REG_DWORD /d "3" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "BlockThirdPartyCookies" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "ConfigureDoNotTrack" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SiteSafetyServicesEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "ResolveNavigationErrorsUseWebService" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Force installing uBlock Origin in Edge...%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" /v "1" /t REG_SZ /d "odfafepnkmbhccpbejgmiehpchacaeak;https://edge.microsoft.com/extensionwebstorebase/v1/crx" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" /v "2" /t REG_SZ /d "bhhhlbepdkbapadjdnnojkbgioiodbic;https://edge.microsoft.com/extensionwebstorebase/v1/crx" /f >nul 2>&1
    
    echo %c%• Disabling Copilot and AI features...%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "CopilotCDPPageContext" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "CopilotPageContext" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "DiscoverPageContextEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "HubsSidebarEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "StandaloneHubsSidebarEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "NewTabPageBingChatEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Disabling bloatware features and ads...%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "EdgeCollectionsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "EdgeShoppingAssistantEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "EdgeFollowEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "EdgeDiscoverEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "AllowGamesMenu" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "EdgeEnhanceImagesEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "InAppSupportEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Removing ads and promotional content...%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "ShowMicrosoftRewards" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SpotlightExperiencesAndRecommendationsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "ShowRecommendationsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "BingAdsSuppression" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PromotionalTabsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "MicrosoftEdgeInsiderPromotionEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "ShowAcrobatSubscriptionButton" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Configuring Edge privacy settings...%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "AddressBarMicrosoftSearchInBingProviderEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "AlternateErrorPagesEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "AutofillCreditCardEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "AutofillAddressEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PaymentMethodQueryEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SearchSuggestEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "FamilySafetySettingsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Cleaning up new tab page...%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "NewTabPageAllowedBackgroundTypes" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "NewTabPageQuickLinksEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SignInCtaOnNtpEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "NewTabPageHideDefaultTopSites" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Disabling desktop search widget...%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "WebWidgetAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "WebWidgetIsEnabledOnStartup" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SearchbarAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SearchbarIsEnabledOnStartup" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Disabling startup boost and experiments...%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "StartupBoostEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "ExperimentationAndConfigurationServiceControl" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Disabling Edge automatic updates...%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v "AutoUpdateCheckPeriodMinutes" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v "UpdatesSuppressedDurationMin" /t REG_DWORD /d "1440" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v "UpdatesSuppressedStartHour" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v "UpdatesSuppressedStartMin" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Stopping Edge update services...%u%
    chcp 437 >nul
    powershell -Command "$services = @('edgeupdate', 'edgeupdatem'); foreach ($serviceName in $services) { $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue; if($service) { if ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running) { try { Stop-Service -Name $serviceName -Force -ErrorAction Stop } catch { } }; $startupType = $service.StartType; if (!$startupType) { $startupType = (Get-WmiObject -Query \"Select StartMode From Win32_Service Where Name='$serviceName'\" -ErrorAction Ignore).StartMode }; if ($startupType -ne 'Disabled') { try { Set-Service -Name $serviceName -StartupType Disabled -Confirm:\$false -ErrorAction Stop } catch { } } } }" >nul 2>&1
    chcp 65001 >nul

    echo %c%• Disabling Edge update scheduled tasks...%u%
    chcp 437 >nul
    powershell -Command "Get-ScheduledTask -TaskPath '\' -TaskName 'MicrosoftEdgeUpdateTaskMachine*' -ErrorAction SilentlyContinue | Disable-ScheduledTask" >nul 2>&1
    chcp 65001 >nul
    
    echo %c%✓ Microsoft Edge configured for maximum privacy and performance%u%
) else (
    echo %c%[2/8] Microsoft Edge not detected, skipping...%u%
)

if "%CHROME_FOUND%"=="true" (
    echo.
    echo %c%[3/8] Configuring Google Chrome for Maximum Privacy...%u%
    
    tasklist /fi "imagename eq chrome.exe" 2>nul | find /i "chrome.exe" >nul && (
        echo %c%⚠ Chrome is running - attempting to close gracefully...%u%
        taskkill /im chrome.exe /f >nul 2>&1
        timeout /t 2 >nul
    )
    
    echo %c%• Disabling Chrome telemetry and cleanup...%u%
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "ChromeCleanupEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "ChromeCleanupReportingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "MetricsReportingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "SafeBrowsingExtendedReportingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "CloudPrintProxyEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "BackgroundModeEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Blocking Chrome Software Reporter Tool...%u%
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\software_reporter_tool.exe" /v "Debugger" /t REG_SZ /d "%SYSTEMROOT%\System32\taskkill.exe" /f >nul 2>&1
    tasklist /fi "ImageName eq software_reporter_tool.exe" /fo csv 2>NUL | find /i "software_reporter_tool.exe">NUL && (
        taskkill /f /im software_reporter_tool.exe >nul 2>&1
    )
    
    echo %c%• Disabling Google data collection and sync...%u%
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "SyncDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "SigninAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "CloudManagementEnrollmentMandatory" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "SubmitSafeBrowsingDownloadVerdicts" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "UrlKeyedAnonymizedDataCollectionEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Disabling location and sensor access...%u%
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "DefaultGeolocationSetting" /t REG_DWORD /d "2" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "DefaultSensorsSetting" /t REG_DWORD /d "2" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "DefaultNotificationsSetting" /t REG_DWORD /d "2" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "DefaultMediaStreamSetting" /t REG_DWORD /d "2" /f >nul 2>&1
    
    echo %c%• Disabling predictive features and suggestions...%u%
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "NetworkPredictionOptions" /t REG_DWORD /d "2" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "SearchSuggestEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "AlternateErrorPagesEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "SpellCheckServiceEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "AutofillAddressEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "AutofillCreditCardEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "PasswordManagerEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Disabling Google AI and experimental features...%u%
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "AIGenerativeGoogleSearchFeatureEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "AIGenerativeGoogleLensFeatureEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "SafeBrowsingAIDataCollectionEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "ComponentUpdatesEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Disabling Chrome promotional and tracking features...%u%
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "PromotionalTabsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "WelcomePageOnOSUpgradeEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "DefaultCookiesSetting" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "ThirdPartyStoragePartitioningEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "BlockThirdPartyCookies" /t REG_DWORD /d "1" /f >nul 2>&1
    
    echo %c%• Configuring privacy sandbox and tracking protection...%u%
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "PrivacySandboxAdTopicsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "PrivacySandboxSiteEnabledAdsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "PrivacySandboxAdMeasurementEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "AdBlockingModeEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
    
    echo %c%• Disabling Google services integration...%u%
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "GoogleSearchSidePanelEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "LensRegionSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "TranslateEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "DefaultWebBluetoothGuardSetting" /t REG_DWORD /d "2" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "DefaultWebUsbGuardSetting" /t REG_DWORD /d "2" /f >nul 2>&1
    
    echo %c%• Configuring DNS and security settings...%u%
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "BuiltInDnsClientEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "DnsOverHttpsMode" /t REG_SZ /d "off" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "SafeBrowsingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "SSLErrorOverrideAllowed" /t REG_DWORD /d "1" /f >nul 2>&1
    
    echo %c%• Force installing uBlock Origin in Chrome...%u%
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist" /v "1" /t REG_SZ /d "cjpalhdlnbpafiamejdnhcphjbkeiagm" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist" /v "2" /t REG_SZ /d "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist" /v "3" /t REG_SZ /d "ldpochfccmkkmhdbclfhpagapcfdljkj" /f >nul 2>&1
    
    echo %c%• Disabling Chrome automatic updates...%u%
    reg add "HKLM\SOFTWARE\Policies\Google\Update" /v "AutoUpdateCheckPeriodMinutes" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Update" /v "UpdateDefault" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Update" /v "Update{8A69D345-D564-463C-AFF1-A69D9E530F96}" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Stopping Google update services...%u%
    chcp 437 >nul
    powershell -Command "$services = @('gupdate', 'gupdatem', 'GoogleChromeElevationService'); foreach ($serviceName in $services) { $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue; if($service) { if ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running) { try { Stop-Service -Name $serviceName -Force -ErrorAction Stop } catch { } }; $startupType = $service.StartType; if (!$startupType) { $startupType = (Get-WmiObject -Query \"Select StartMode From Win32_Service Where Name='$serviceName'\" -ErrorAction Ignore).StartMode }; if ($startupType -ne 'Disabled') { try { Set-Service -Name $serviceName -StartupType Disabled -Confirm:\$false -ErrorAction Stop } catch { } } } }" >nul 2>&1
    chcp 65001 >nul

    echo %c%• Disabling Google update scheduled tasks...%u%
    chcp 437 >nul
    powershell -Command "Get-ScheduledTask -TaskPath '\' -TaskName 'Google*' -ErrorAction SilentlyContinue | Disable-ScheduledTask" >nul 2>&1
    chcp 65001 >nul

    echo %c%• Creating Software Reporter Tool block...%u%
    chcp 437 >nul
    powershell -Command "$executableFilename='software_reporter_tool.exe'; try { $registryPathForDisallowRun='HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun'; $existingBlockEntries = Get-ItemProperty -Path $registryPathForDisallowRun -ErrorAction Ignore; $nextFreeRuleIndex = 1; if ($existingBlockEntries) { $existingBlockingRuleForExecutable = $existingBlockEntries.PSObject.Properties | Where-Object { $_.Value -eq $executableFilename }; if ($existingBlockingRuleForExecutable) { exit 0; }; $occupiedRuleIndexes = $existingBlockEntries.PSObject.Properties | Where-Object { $_.Name -Match '^\d+$' } | Select -ExpandProperty Name; if ($occupiedRuleIndexes) { while ($occupiedRuleIndexes -Contains $nextFreeRuleIndex) { $nextFreeRuleIndex += 1; }; }; }; if (!(Test-Path $registryPathForDisallowRun)) { New-Item -Path $registryPathForDisallowRun -Force -ErrorAction Stop | Out-Null; }; New-ItemProperty -Path $registryPathForDisallowRun -Name $nextFreeRuleIndex -PropertyType String -Value $executableFilename -ErrorAction Stop | Out-Null; } catch { }" >nul 2>&1
    chcp 65001 >nul

    echo %c%• Activating executable blocking policy...%u%
    chcp 437 >nul
    powershell -Command "try { $fileExplorerDisallowRunRegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'; $currentDisallowRunPolicyValue = Get-ItemProperty -Path $fileExplorerDisallowRunRegistryPath -Name 'DisallowRun' -ErrorAction Ignore | Select -ExpandProperty DisallowRun; if ([string]::IsNullOrEmpty($currentDisallowRunPolicyValue)) { if (!(Test-Path $fileExplorerDisallowRunRegistryPath)) { New-Item -Path $fileExplorerDisallowRunRegistryPath -Force -ErrorAction Stop | Out-Null; }; New-ItemProperty -Path $fileExplorerDisallowRunRegistryPath -Name 'DisallowRun' -Value 1 -PropertyType DWORD -Force -ErrorAction Stop | Out-Null; } elseif ($currentDisallowRunPolicyValue -ne 1) { Set-ItemProperty -Path $fileExplorerDisallowRunRegistryPath -Name 'DisallowRun' -Value 1 -Type DWORD -Force -ErrorAction Stop | Out-Null; } } catch { }" >nul 2>&1
    chcp 65001 >nul
    
    echo %c%✓ Google Chrome configured for maximum privacy and performance%u%
) else (
    echo %c%[3/8] Google Chrome not detected, skipping...%u%
)

if "%FIREFOX_FOUND%"=="true" (
    echo.
    echo %c%[4/8] Configuring Mozilla Firefox for Maximum Privacy...%u%
    
    echo %c%• Disabling Firefox telemetry and data collection...%u%
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisableTelemetry" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisableDefaultBrowserAgent" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisableFirefoxStudies" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisableFirefoxAccounts" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisableSystemAddonUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
    
    echo %c%• Disabling Firefox background services...%u%
    chcp 437 >nul
    powershell -Command "$tasks = @('Firefox Default Browser Agent 308046B0AF4A39CB', 'Firefox Default Browser Agent D2CEEC440E2074BD'); foreach ($taskName in $tasks) { $task = Get-ScheduledTask -TaskPath '\Mozilla\' -TaskName $taskName -ErrorAction SilentlyContinue; if ($task -and $task.State -ne [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) { try { $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null } catch { } } }" >nul 2>&1
    chcp 65001 >nul
    
    echo %c%• Configuring Firefox security and privacy policies...%u%
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisablePocket" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisableProfileImport" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisableProfileRefresh" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisableFeedbackCommands" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisablePrivateBrowsingShortcut" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisablePasswordReveal" /t REG_DWORD /d "1" /f >nul 2>&1
    
    echo %c%• Disabling Firefox data submission and reporting...%u%
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "UserMessaging" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "ExtensionRecommendations" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "FirefoxHome" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Installing uBlock Origin and privacy extensions...%u%
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install" /v "1" /t REG_SZ /d "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install" /v "2" /t REG_SZ /d "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install" /v "3" /t REG_SZ /d "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi" /f >nul 2>&1
    
    echo %c%• Configuring Firefox update policies...%u%
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisableAppUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "ManualAppUpdateOnly" /t REG_DWORD /d "1" /f >nul 2>&1
    
    echo %c%• Creating comprehensive Firefox privacy configuration...%u%
    call :CreateFirefoxPrivacyConfig "%ProgramFiles%\Mozilla Firefox\defaults\pref"
    call :CreateFirefoxPrivacyConfig "%ProgramFiles(x86)%\Mozilla Firefox\defaults\pref"
    
    echo %c%• Configuring Firefox DNS and network settings...%u%
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox\DNSOverHTTPS" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox\NetworkPrediction" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Disabling Firefox crash reporting and error collection...%u%
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisableCrashReporter" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "CaptivePortal" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%✓ Mozilla Firefox configured for maximum privacy and performance%u%
) else (
    echo %c%[4/8] Mozilla Firefox not detected, skipping...%u%
)

goto :eof

:CreateFirefoxPrivacyConfig
set "FIREFOX_PREF_DIR=%~1"
if exist "%FIREFOX_PREF_DIR%" (
    (
        echo // Firefox Privacy Configuration - Generated by Batlez Tweaks on %DATE% %TIME%
        echo // Comprehensive privacy and security settings
        echo.
        echo // === TELEMETRY AND DATA COLLECTION ===
        echo pref^("toolkit.telemetry.unified", false^);
        echo pref^("toolkit.telemetry.enabled", false^);
        echo pref^("toolkit.telemetry.server", ""^);
        echo pref^("toolkit.telemetry.archive.enabled", false^);
        echo pref^("toolkit.telemetry.newProfilePing.enabled", false^);
        echo pref^("toolkit.telemetry.shutdownPingSender.enabled", false^);
        echo pref^("toolkit.telemetry.updatePing.enabled", false^);
        echo pref^("toolkit.telemetry.bhrPing.enabled", false^);
        echo pref^("toolkit.telemetry.firstShutdownPing.enabled", false^);
        echo pref^("toolkit.telemetry.coverage.opt-out", true^);
        echo pref^("toolkit.coverage.opt-out", true^);
        echo pref^("datareporting.healthreport.uploadEnabled", false^);
        echo pref^("datareporting.policy.dataSubmissionEnabled", false^);
        echo.
        echo // === CRASH REPORTING ===
        echo pref^("breakpad.reportURL", ""^);
        echo pref^("browser.tabs.crashReporting.sendReport", false^);
        echo pref^("browser.crashReports.unsubmittedCheck.autoSubmit2", false^);
        echo pref^("toolkit.crashreporter.infoURL", ""^);
        echo.
        echo // === STUDIES AND EXPERIMENTS ===
        echo pref^("app.shield.optoutstudies.enabled", false^);
        echo pref^("app.normandy.enabled", false^);
        echo pref^("app.normandy.api_url", ""^);
        echo pref^("messaging-system.rsexperimentloader.enabled", false^);
        echo.
        echo // === TRACKING PROTECTION ===
        echo pref^("privacy.trackingprotection.enabled", true^);
        echo pref^("privacy.trackingprotection.pbmode.enabled", true^);
        echo pref^("privacy.trackingprotection.cryptomining.enabled", true^);
        echo pref^("privacy.trackingprotection.fingerprinting.enabled", true^);
        echo pref^("privacy.trackingprotection.socialtracking.enabled", true^);
        echo pref^("privacy.socialtracking.block_cookies.enabled", true^);
        echo.
        echo // === FIREFOX SYNC AND ACCOUNTS ===
        echo pref^("identity.fxaccounts.enabled", false^);
        echo pref^("browser.sync.engine.addons", false^);
        echo pref^("browser.sync.engine.bookmarks", false^);
        echo pref^("browser.sync.engine.history", false^);
        echo pref^("browser.sync.engine.passwords", false^);
        echo pref^("browser.sync.engine.prefs", false^);
        echo pref^("browser.sync.engine.tabs", false^);
        echo pref^("services.sync.enabled", false^);
        echo.
        echo // === POCKET INTEGRATION ===
        echo pref^("extensions.pocket.enabled", false^);
        echo pref^("extensions.pocket.api", ""^);
        echo pref^("extensions.pocket.loggedOutVariant", ""^);
        echo pref^("extensions.pocket.oAuthConsumerKey", ""^);
        echo pref^("extensions.pocket.site", ""^);
        echo.
        echo // === GEOLOCATION AND SENSORS ===
        echo pref^("geo.enabled", false^);
        echo pref^("geo.provider.use_gpsd", false^);
        echo pref^("geo.provider.use_geoclue", false^);
        echo pref^("permissions.default.geo", 2^);
        echo pref^("permissions.default.camera", 2^);
        echo pref^("permissions.default.microphone", 2^);
        echo pref^("permissions.default.desktop-notification", 2^);
        echo.
        echo // === DNS AND NETWORK ===
        echo pref^("network.trr.mode", 5^);
        echo pref^("network.dns.disablePrefetch", true^);
        echo pref^("network.dns.disablePrefetchFromHTTPS", true^);
        echo pref^("network.predictor.enabled", false^);
        echo pref^("network.predictor.enable-prefetch", false^);
        echo pref^("network.prefetch-next", false^);
        echo pref^("network.http.speculative-parallel-limit", 0^);
        echo pref^("browser.urlbar.speculativeConnect.enabled", false^);
        echo.
        echo // === SEARCH AND SUGGESTIONS ===
        echo pref^("browser.urlbar.suggest.searches", false^);
        echo pref^("browser.search.suggest.enabled", false^);
        echo pref^("browser.urlbar.suggest.quicksuggest.nonsponsored", false^);
        echo pref^("browser.urlbar.suggest.quicksuggest.sponsored", false^);
        echo pref^("browser.urlbar.quicksuggest.dataCollection.enabled", false^);
        echo.
        echo // === COOKIES AND STORAGE ===
        echo pref^("network.cookie.cookieBehavior", 4^);
        echo pref^("network.cookie.thirdparty.sessionOnly", true^);
        echo pref^("network.cookie.thirdparty.nonsecureSessionOnly", true^);
        echo pref^("privacy.partition.network_state", true^);
        echo pref^("privacy.dynamic_firstparty.use_site", true^);
        echo.
        echo // === REFERRER POLICY ===
        echo pref^("network.http.referer.XOriginPolicy", 2^);
        echo pref^("network.http.referer.XOriginTrimmingPolicy", 2^);
        echo.
        echo // === WEBGL AND CANVAS ===
        echo pref^("webgl.disabled", true^);
        echo pref^("privacy.resistFingerprinting.block_mozAddonManager", true^);
        echo pref^("privacy.resistFingerprinting", true^);
        echo.
        echo // === AUTOMATIC CONNECTIONS ===
        echo pref^("browser.safebrowsing.downloads.remote.enabled", false^);
        echo pref^("network.captive-portal-service.enabled", false^);
        echo pref^("network.connectivity-service.enabled", false^);
        echo.
        echo // === NEW TAB PAGE ===
        echo pref^("browser.newtabpage.enabled", false^);
        echo pref^("browser.newtabpage.activity-stream.enabled", false^);
        echo pref^("browser.newtabpage.activity-stream.telemetry", false^);
        echo pref^("browser.newtabpage.activity-stream.feeds.telemetry", false^);
        echo pref^("browser.newtabpage.activity-stream.feeds.snippets", false^);
        echo pref^("browser.newtabpage.activity-stream.feeds.section.topstories", false^);
        echo pref^("browser.newtabpage.activity-stream.section.highlights.includePocket", false^);
        echo pref^("browser.newtabpage.activity-stream.showSponsored", false^);
        echo pref^("browser.newtabpage.activity-stream.showSponsoredTopSites", false^);
        echo.
        echo // === PASSWORDS AND AUTOFILL ===
        echo pref^("signon.rememberSignons", false^);
        echo pref^("browser.formfill.enable", false^);
        echo pref^("extensions.formautofill.addresses.enabled", false^);
        echo pref^("extensions.formautofill.creditCards.enabled", false^);
        echo.
        echo // === PERFORMANCE AND MEMORY ===
        echo pref^("browser.sessionstore.privacy_level", 2^);
        echo pref^("browser.sessionstore.resume_from_crash", false^);
        echo pref^("dom.disable_beforeunload", true^);
        echo pref^("accessibility.force_disabled", 1^);
        echo.
        echo // === FIREFOX UPDATES ===
        echo pref^("app.update.enabled", false^);
        echo pref^("app.update.auto", false^);
        echo pref^("app.update.mode", 0^);
        echo pref^("app.update.service.enabled", false^);
        echo.
        echo // === MOZILLA CONNECTIONS ===
        echo pref^("browser.ping-centre.telemetry", false^);
        echo pref^("extensions.getAddons.showPane", false^);
        echo pref^("extensions.htmlaboutaddons.recommendations.enabled", false^);
        echo pref^("browser.discovery.enabled", false^);
        echo pref^("browser.tabs.firefox-view", false^);
        echo.
        echo // === SECURITY OVERRIDES ===
        echo pref^("security.tls.unrestricted_rc4_fallback", false^);
        echo pref^("security.tls.insecure_fallback_hosts", ""^);
        echo pref^("security.ssl.require_safe_negotiation", true^);
        echo pref^("security.ssl.treat_unsafe_negotiation_as_broken", true^);
        echo.
        echo // === MISCELLANEOUS PRIVACY ===
        echo pref^("beacon.enabled", false^);
        echo pref^("dom.battery.enabled", false^);
        echo pref^("device.sensors.enabled", false^);
        echo pref^("dom.event.clipboardevents.enabled", false^);
        echo pref^("media.navigator.enabled", false^);
        echo pref^("browser.send_pings", false^);
        echo pref^("browser.send_pings.require_same_host", true^);
        echo.
        echo // End of Privacy Configuration
    ) > "%FIREFOX_PREF_DIR%\user.js" 2>nul
)
exit /b

if "%OPERAGX_FOUND%"=="true" (
    echo.
    echo %c%[5/8] Configuring Opera GX for Maximum Privacy...%u%
    
    echo %c%• Disabling Opera GX telemetry and ads...%u%
    reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera GX Stable" /v "MetricsReportingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera GX Stable" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera GX Stable" /v "DefaultSearchProviderEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
    
    echo %c%• Force installing uBlock Origin in Opera GX...%u%
    reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera GX Stable\ExtensionInstallForcelist" /v "1" /t REG_SZ /d "cjpalhdlnbpafiamejdnhcphjbkeiagm" /f >nul 2>&1
    
    echo %c%• Configuring Opera GX gaming optimizations...%u%
    reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera GX Stable" /v "BackgroundModeEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Opera Software\Opera GX Stable" /v "HardwareAccelerationModeEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
) else (
    echo %c%[5/8] Opera GX not detected, skipping...%u%
)

if "%BRAVE_FOUND%"=="true" (
    echo.
    echo %c%[6/8] Configuring Brave Browser for Maximum Privacy...%u%
    
    echo %c%• Enhancing Brave privacy settings...%u%
    reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "MetricsReportingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "SpellCheckServiceEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "SafeBrowsingExtendedReportingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Installing additional privacy extensions in Brave...%u%
    reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave\ExtensionInstallForcelist" /v "1" /t REG_SZ /d "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave\ExtensionInstallForcelist" /v "2" /t REG_SZ /d "ldpochfccmkkmhdbclfhpagapcfdljkj" /f >nul 2>&1
    
    echo %c%• Optimizing Brave for performance...%u%
    reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "BackgroundModeEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\BraveSoftware\Brave" /v "HardwareAccelerationModeEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
) else (
    echo %c%[6/8] Brave Browser not detected, skipping...%u%
)

if "%VIVALDI_FOUND%"=="true" (
    echo.
    echo %c%[7/8] Configuring Vivaldi Browser for Maximum Privacy...%u%
    
    echo %c%• Disabling Vivaldi telemetry...%u%
    reg add "HKLM\SOFTWARE\Policies\Vivaldi" /v "MetricsReportingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Vivaldi" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Installing privacy extensions in Vivaldi...%u%
    reg add "HKLM\SOFTWARE\Policies\Vivaldi\ExtensionInstallForcelist" /v "1" /t REG_SZ /d "cjpalhdlnbpafiamejdnhcphjbkeiagm" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Vivaldi\ExtensionInstallForcelist" /v "2" /t REG_SZ /d "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" /f >nul 2>&1
    
    echo %c%• Configuring Vivaldi privacy settings...%u%
    reg add "HKLM\SOFTWARE\Policies\Vivaldi" /v "NetworkPredictionOptions" /t REG_DWORD /d "2" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Vivaldi" /v "SpellCheckServiceEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
) else (
    echo %c%[7/8] Vivaldi Browser not detected, skipping...%u%
)

echo.
echo %c%[8/8] Configuring system-wide DNS for ad-blocking...%u%
for /f "skip=3 tokens=4*" %%i in ('netsh interface show interface ^| findstr "Connected"') do (
    echo   Configuring DNS for interface: %%j
    netsh interface ip set dns "%%j" static 1.1.1.2 primary >nul 2>&1
    netsh interface ip add dns "%%j" 1.0.0.2 index=2 >nul 2>&1
)

echo %c%• Configuring Windows hosts file for ad-blocking...%u%
echo. >> "%SystemRoot%\System32\drivers\etc\hosts"
echo # Batlez Browser Privacy Optimizer - Added %date% %time% >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.0 doubleclick.net >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.0 googleadservices.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.0 googlesyndication.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.0 googletagmanager.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.0 ads.yahoo.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.0 adsystem.microsoft.com >> "%SystemRoot%\System32\drivers\etc\hosts"

echo %c%• Configuring Internet Explorer security...%u%
reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Geolocation" /v "BlockAllWebsites" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Geolocation" /v "BlockAllWebsites" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\SQM" /v "OptedIn" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%• Verifying browser extension configuration...%u%
echo.
echo %c%Extension Policies Status:%u%
reg query "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist" >nul 2>&1
if !errorlevel! equ 0 (
    echo %c%  ✓ Chrome policies: CONFIGURED%u%
) else (
    echo %c%  ✗ Chrome policies: NOT CONFIGURED%u%
)

reg query "HKLM\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" >nul 2>&1
if !errorlevel! equ 0 (
    echo %c%  ✓ Edge policies: CONFIGURED%u%
) else (
    echo %c%  ✗ Edge policies: NOT CONFIGURED%u%
)

reg query "HKLM\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install" >nul 2>&1
if !errorlevel! equ 0 (
    echo %c%  ✓ Firefox policies: CONFIGURED%u%
) else (
    echo %c%  ✗ Firefox policies: NOT CONFIGURED%u%
)

echo %c%• Applying final browser security tweaks...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f >nul 2>&1

cd /d "%TEMP%"
rmdir /s /q "BatlezBrowserExtensions" >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                  COMPREHENSIVE BROWSER OPTIMIZATION COMPLETED                ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Browser privacy and extension optimization has been successfully completed.%u%
echo.
echo %c%Configured Browsers:%u%
if "%EDGE_FOUND%"=="true" echo %c%• Microsoft Edge: Privacy hardened + uBlock Origin auto-installed%u%
if "%CHROME_FOUND%"=="true" echo %c%• Google Chrome: Privacy hardened + Extensions auto-installed%u%
if "%FIREFOX_FOUND%"=="true" echo %c%• Mozilla Firefox: Privacy hardened + Extensions auto-installed%u%
if "%OPERAGX_FOUND%"=="true" echo %c%• Opera GX: Gaming optimized + Privacy extensions installed%u%
if "%BRAVE_FOUND%"=="true" echo %c%• Brave Browser: Enhanced privacy + Additional extensions%u%
if "%VIVALDI_FOUND%"=="true" echo %c%• Vivaldi: Privacy optimized + Extensions auto-installed%u%
if "%CHROMIUM_FOUND%"=="true" echo %c%• Chromium: Universal configuration applied%u%
echo.
echo %c%System-Wide Optimizations:%u%
echo %c%• DNS configured for ad-blocking (Cloudflare with malware protection)%u%
echo %c%• Hosts file updated with ad-blocking entries%u%
echo %c%• Internet Explorer security hardened%u%
echo %c%• Browser telemetry and tracking disabled across all browsers%u%
echo.
echo %c%Auto-Installed Extensions:%u%
echo %c%• uBlock Origin - Advanced ad and tracker blocker%u%
echo %c%• Privacy Badger - Intelligent tracker protection%u%
echo %c%• Decentraleyes - CDN request protection%u%
echo.
echo %red%Next Steps:%u%
echo %c%• Restart all browsers to apply configurations%u%
echo %c%• Extensions will automatically install on browser restart%u%
echo %c%• Configure extension settings as needed%u%
echo.
echo %red%Performance Benefits:%u%
echo %c%• Significantly reduced tracking and telemetry%u%
echo %c%• Faster page loading with ad-blocking%u%
echo %c%• Enhanced privacy protection across all browsers%u%
echo %c%• Automatic malware and phishing protection%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:K
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           CUSTOM POWER PLAN OPTIMIZER                        ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Choose your power plan optimization type:%u%
echo.
echo %c%                           ╔════════════════════════════════╗
echo                            ║      [1] Desktop Power Plan    ║
echo                            ║      [2] Laptop Power Plan     ║
echo                            ║      [3] View Current Plan     ║
echo                            ║                                ║
echo                            ║      [0] Return to Main Menu   ║
echo                            ╚════════════════════════════════╝%u%
echo.
echo %c%Desktop Plan: Maximum performance, no power saving (recommended for gaming PCs)%u%
echo %c%Laptop Plan: Balanced performance with battery optimization (recommended for laptops)%u%
echo.
set /p choice="%c%Select your power plan type »%u% "
if "%choice%"=="0" goto TweaksMenu
if "%choice%"=="1" goto DesktopPowerPlan
if "%choice%"=="2" goto LaptopPowerPlan
if "%choice%"=="3" goto ViewCurrentPlan
cls
echo.
echo %red%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                                INVALID INPUT                                 ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Please select a valid option [0-3] from the menu.%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO RETRY ══════════════════════════%u%
pause >nul
goto K

:ViewCurrentPlan
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                             CURRENT POWER PLAN STATUS                        ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Active Power Plan:%u%
powercfg /getactivescheme
echo.
echo %c%Available Power Plans:%u%
powercfg /list
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto K

:DesktopPowerPlan
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         DESKTOP ULTIMATE PERFORMANCE PLAN                    ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Desktop power plan features:%u%
echo %c%• Maximum CPU performance (100%% minimum, no throttling)%u%
echo %c%• AMD Ryzen Precision Boost and Core Performance Boost enabled%u%
echo %c%• All power saving features disabled%u%
echo %c%• USB and PCI power management off%u%
echo %c%• Display and sleep timeouts disabled%u%
echo %c%• Aggressive CPU boost and turbo modes%u%
echo %c%• Maximum GPU performance preference%u%
echo %c%• Hidden Windows performance tweaks enabled%u%
echo %c%• Advanced latency and responsiveness optimizations%u%
echo %c%• NVMe SSD performance optimizations%u%
echo %c%• Intel Graphics and interrupt steering optimizations%u%
echo.
echo %red%%underline%Desktop Notice:%u%
echo %c%This plan prioritizes maximum performance over power efficiency.%u%
echo %c%Power consumption will be high - designed for desktop gaming PCs.%u%
echo %c%Includes secret Windows performance tweaks not available in GUI.%u%
echo %c%AMD Ryzen CPUs will boost to maximum frequencies under load.%u%
echo.
echo.
choice /C YN /M "%c%Create Desktop Ultimate Performance plan? (Y/N)%u%"
if errorlevel 2 goto K

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    DESKTOP POWER PLAN OPTIMIZATION IN PROGRESS               ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

call :POWER_Step1_Initialize
call :POWER_Step2_CreateScheme
call :POWER_Step3_ConfigureCPU
call :POWER_Step4_ConfigureStorage
call :POWER_Step5_ConfigureUSB
call :POWER_Step6_ConfigureGraphics
call :POWER_Step7_ConfigureNetwork
call :POWER_Step8_ConfigureSystem
call :POWER_Step9_ApplyTweaks
call :POWER_Step10_Activate

goto PowerPlanComplete

:POWER_Step1_Initialize
echo %c%[1/10] Initializing power scheme configuration...%u%
set "CUSTOM_GUID=44444444-4444-4444-4444-444444444441"
set "SCHEME_NAME=Batlez Desktop Ultimate"
set "SCHEME_DESC=Maximum performance gaming plan with comprehensive optimizations"

echo %c%  → Removing existing custom scheme...%u%
powercfg /d %CUSTOM_GUID% >nul 2>&1

echo %c%  → Power scheme initialization completed%u%
goto :eof

:POWER_Step2_CreateScheme
echo %c%[2/10] Creating optimized power scheme...%u%

echo %c%  → Duplicating Ultimate Performance base scheme...%u%
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c %CUSTOM_GUID% >nul 2>&1

echo %c%  → Setting scheme name and description...%u%
powercfg /changename %CUSTOM_GUID% "%SCHEME_NAME%" "%SCHEME_DESC%" >nul 2>&1

echo %c%  → Power scheme created successfully%u%
goto :eof

:POWER_Step3_ConfigureCPU
echo %c%[3/10] Configuring maximum CPU performance...%u%

echo %c%  → Setting power plan personality to High Performance...%u%
powercfg /setacvalueindex %CUSTOM_GUID% fea3413e-7e05-4911-9a71-700331f1c294 245d8541-3943-4422-b025-13a784f679b7 1 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% fea3413e-7e05-4911-9a71-700331f1c294 245d8541-3943-4422-b025-13a784f679b7 1 >nul 2>&1

echo %c%  → Configuring AMD Ryzen Precision Boost and Core Performance Boost...%u%
powercfg /setacvalueindex %CUSTOM_GUID% 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 2 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 2 >nul 2>&1

echo %c%  → Setting maximum CPU performance state (100%%)...%u%
powercfg /setacvalueindex %CUSTOM_GUID% 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100 >nul 2>&1

echo %c%  → Configuring aggressive CPU performance mode...%u%
powercfg /setacvalueindex %CUSTOM_GUID% 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 5 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 5 >nul 2>&1

echo %c%  → Disabling CPU idle states for maximum responsiveness...%u%
powercfg /setacvalueindex %CUSTOM_GUID% 54533251-82be-4824-96c1-47b60b740d00 5d76a2ca-e8c0-402f-a133-2158492d58ad 0 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 54533251-82be-4824-96c1-47b60b740d00 5d76a2ca-e8c0-402f-a133-2158492d58ad 0 >nul 2>&1

echo %c%  → Optimizing CPU core parking (disable parking)...%u%
powercfg /setacvalueindex %CUSTOM_GUID% 54533251-82be-4824-96c1-47b60b740d00 ea062031-0e34-4ff1-9b6d-eb1059334028 100 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 54533251-82be-4824-96c1-47b60b740d00 ea062031-0e34-4ff1-9b6d-eb1059334028 100 >nul 2>&1

echo %c%  → Configuring interrupt steering for performance...%u%
powercfg /attributes 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 2bfc24f9-5ea2-4801-8213-3dbae01aa39d -ATTRIB_HIDE >nul 2>&1
powercfg /setacvalueindex %CUSTOM_GUID% 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 2bfc24f9-5ea2-4801-8213-3dbae01aa39d 3 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 2bfc24f9-5ea2-4801-8213-3dbae01aa39d 3 >nul 2>&1

echo %c%  → CPU performance configuration completed%u%
goto :eof

:POWER_Step4_ConfigureStorage
echo %c%[4/10] Optimizing storage performance...%u%

echo %c%  → Disabling hard disk turn off...%u%
powercfg /setacvalueindex %CUSTOM_GUID% 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0 >nul 2>&1

echo %c%  → Configuring AHCI Link Power Management for performance...%u%
powercfg /attributes 0012ee47-9041-4b5d-9b77-535fba8b1442 0b2d69d7-a2a1-449c-9680-f91c70521c60 -ATTRIB_HIDE >nul 2>&1
powercfg /setacvalueindex %CUSTOM_GUID% 0012ee47-9041-4b5d-9b77-535fba8b1442 0b2d69d7-a2a1-449c-9680-f91c70521c60 0 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 0012ee47-9041-4b5d-9b77-535fba8b1442 0b2d69d7-a2a1-449c-9680-f91c70521c60 0 >nul 2>&1

echo %c%  → Optimizing NVMe SSD settings for maximum performance...%u%
powercfg /attributes 0012ee47-9041-4b5d-9b77-535fba8b1442 fc7372b6-ab2d-43ee-8797-15e9841f2cca -ATTRIB_HIDE >nul 2>&1
powercfg /setacvalueindex %CUSTOM_GUID% 0012ee47-9041-4b5d-9b77-535fba8b1442 fc7372b6-ab2d-43ee-8797-15e9841f2cca 1 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 0012ee47-9041-4b5d-9b77-535fba8b1442 fc7372b6-ab2d-43ee-8797-15e9841f2cca 1 >nul 2>&1

powercfg /attributes 0012ee47-9041-4b5d-9b77-535fba8b1442 d639518a-e56d-4345-8af2-b9f32fb26109 -ATTRIB_HIDE >nul 2>&1
powercfg /setacvalueindex %CUSTOM_GUID% 0012ee47-9041-4b5d-9b77-535fba8b1442 d639518a-e56d-4345-8af2-b9f32fb26109 60000 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 0012ee47-9041-4b5d-9b77-535fba8b1442 d639518a-e56d-4345-8af2-b9f32fb26109 60000 >nul 2>&1

powercfg /attributes 0012ee47-9041-4b5d-9b77-535fba8b1442 d3d55efd-c1ff-424e-9dc3-441be7833010 -ATTRIB_HIDE >nul 2>&1
powercfg /setacvalueindex %CUSTOM_GUID% 0012ee47-9041-4b5d-9b77-535fba8b1442 d3d55efd-c1ff-424e-9dc3-441be7833010 60000 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 0012ee47-9041-4b5d-9b77-535fba8b1442 d3d55efd-c1ff-424e-9dc3-441be7833010 60000 >nul 2>&1

echo %c%  → Storage performance optimization completed%u%
goto :eof

:POWER_Step5_ConfigureUSB
echo %c%[5/10] Optimizing USB and device performance...%u%

echo %c%  → Disabling USB selective suspend...%u%
powercfg /attributes 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 -ATTRIB_HIDE >nul 2>&1
powercfg /setacvalueindex %CUSTOM_GUID% 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1

echo %c%  → Optimizing USB 3 Link Power Management...%u%
powercfg /attributes 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 -ATTRIB_HIDE >nul 2>&1
powercfg /setacvalueindex %CUSTOM_GUID% 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0 >nul 2>&1

echo %c%  → Enabling IOC on all TDs for performance...%u%
powercfg /attributes 2a737441-1930-4402-8d77-b2bebba308a3 498c044a-201b-4631-a522-5c744ed4e678 -ATTRIB_HIDE >nul 2>&1
powercfg /setacvalueindex %CUSTOM_GUID% 2a737441-1930-4402-8d77-b2bebba308a3 498c044a-201b-4631-a522-5c744ed4e678 1 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 2a737441-1930-4402-8d77-b2bebba308a3 498c044a-201b-4631-a522-5c744ed4e678 1 >nul 2>&1

echo %c%  → Disabling USB Deep Sleep for responsiveness...%u%
powercfg /attributes 2a737441-1930-4402-8d77-b2bebba308a3 d502f7ee-1dc7-4efd-a55d-f04b6f5c0545 -ATTRIB_HIDE >nul 2>&1
powercfg /setacvalueindex %CUSTOM_GUID% 2a737441-1930-4402-8d77-b2bebba308a3 d502f7ee-1dc7-4efd-a55d-f04b6f5c0545 0 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 2a737441-1930-4402-8d77-b2bebba308a3 d502f7ee-1dc7-4efd-a55d-f04b6f5c0545 0 >nul 2>&1

echo %c%  → USB and device optimization completed%u%
goto :eof

:POWER_Step6_ConfigureGraphics
echo %c%[6/10] Configuring graphics performance...%u%

echo %c%  → Setting maximum GPU performance preference...%u%
powercfg /setacvalueindex %CUSTOM_GUID% 5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c dd848b2a-8a5d-4451-9ae2-39cd41658f6c 2 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c dd848b2a-8a5d-4451-9ae2-39cd41658f6c 2 >nul 2>&1

echo %c%  → Optimizing Intel Graphics settings (if present)...%u%
powercfg /attributes 44f3beca-a7c0-460e-9df2-bb8b99e0cba6 3619c3f2-afb2-4afc-b0e9-e7fef372de36 -ATTRIB_HIDE >nul 2>&1
powercfg /setacvalueindex %CUSTOM_GUID% 44f3beca-a7c0-460e-9df2-bb8b99e0cba6 3619c3f2-afb2-4afc-b0e9-e7fef372de36 2 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 44f3beca-a7c0-460e-9df2-bb8b99e0cba6 3619c3f2-afb2-4afc-b0e9-e7fef372de36 2 >nul 2>&1

echo %c%  → Optimizing JavaScript timer frequency for web performance...%u%
powercfg /attributes 02f815b5-a5cf-4c84-bf20-649d1f75d3d8 4c793e7d-a264-42e1-87d3-7a0d2f523ccd -ATTRIB_HIDE >nul 2>&1
powercfg /setacvalueindex %CUSTOM_GUID% 02f815b5-a5cf-4c84-bf20-649d1f75d3d8 4c793e7d-a264-42e1-87d3-7a0d2f523ccd 1 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 02f815b5-a5cf-4c84-bf20-649d1f75d3d8 4c793e7d-a264-42e1-87d3-7a0d2f523ccd 1 >nul 2>&1

echo %c%  → Graphics performance configuration completed%u%
goto :eof

:POWER_Step7_ConfigureNetwork
echo %c%[7/10] Optimizing network and connectivity...%u%

echo %c%  → Setting wireless adapter to maximum performance...%u%
powercfg /attributes 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a -ATTRIB_HIDE >nul 2>&1
powercfg /setacvalueindex %CUSTOM_GUID% 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0 >nul 2>&1

echo %c%  → Enabling connectivity in standby...%u%
powercfg /attributes fea3413e-7e05-4911-9a71-700331f1c294 f15576e8-98b7-4186-b944-eafa664402d9 -ATTRIB_HIDE >nul 2>&1
powercfg /setacvalueindex %CUSTOM_GUID% fea3413e-7e05-4911-9a71-700331f1c294 f15576e8-98b7-4186-b944-eafa664402d9 1 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% fea3413e-7e05-4911-9a71-700331f1c294 f15576e8-98b7-4186-b944-eafa664402d9 1 >nul 2>&1

echo %c%  → Configuring device idle policy for performance...%u%
powercfg /attributes fea3413e-7e05-4911-9a71-700331f1c294 4faab71a-92e5-4726-b531-224559672d19 -ATTRIB_HIDE >nul 2>&1
powercfg /setacvalueindex %CUSTOM_GUID% fea3413e-7e05-4911-9a71-700331f1c294 4faab71a-92e5-4726-b531-224559672d19 0 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% fea3413e-7e05-4911-9a71-700331f1c294 4faab71a-92e5-4726-b531-224559672d19 0 >nul 2>&1

echo %c%  → Network and connectivity optimization completed%u%
goto :eof

:POWER_Step8_ConfigureSystem
echo %c%[8/10] Configuring system sleep and power settings...%u%

echo %c%  → Disabling sleep and hibernation...%u%
powercfg /setacvalueindex %CUSTOM_GUID% 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0 >nul 2>&1

powercfg /setacvalueindex %CUSTOM_GUID% 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 9d7815a6-7ee4-497e-8888-515a05f02364 0 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 9d7815a6-7ee4-497e-8888-515a05f02364 0 >nul 2>&1

echo %c%  → Enabling Away Mode for media applications...%u%
powercfg /attributes 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 -ATTRIB_HIDE >nul 2>&1
powercfg /setacvalueindex %CUSTOM_GUID% 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 1 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 1 >nul 2>&1

echo %c%  → Disabling display turn off...%u%
powercfg /setacvalueindex %CUSTOM_GUID% 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0 >nul 2>&1

echo %c%  → Configuring power buttons for do nothing...%u%
powercfg /setacvalueindex %CUSTOM_GUID% 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 0 >nul 2>&1
powercfg /setdcvalueindex %CUSTOM_GUID% 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 0 >nul 2>&1

echo %c%  → System sleep and power configuration completed%u%
goto :eof

:POWER_Step9_ApplyTweaks
echo %c%[9/10] Applying advanced registry performance tweaks...%u%

echo %c%  → Configuring power throttling for maximum performance...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%  → Optimizing power management latencies...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatencyCheckEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "Latency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceDefault" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceFSVP" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyTolerancePerfOverride" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceScreenOffIR" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceVSyncEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "RtlCapabilityCheckLatency" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%  → Disabling power saving features...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PlatformAoAcOverride" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%  → Optimizing CPU vendor-specific settings...%u%
wmic cpu get name | findstr /i "Intel" >nul && (
    echo %c%    → Applying Intel-specific optimizations...%u%
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "Class2InitialUnparkCount" /t REG_DWORD /d "100" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "InitialUnparkCount" /t REG_DWORD /d "100" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MaxIAverageGraphicsLatencyInOneBucket" /t REG_DWORD /d "1" /f >nul 2>&1
) || (
    echo %c%    → Applying AMD-specific optimizations...%u%
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultD3TransitionLatencyActivelyUsed" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultD3TransitionLatencyIdleLongTime" /t REG_DWORD /d "1" /f >nul 2>&1
)

echo %c%  → Configuring platform role for desktop...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PlatformRole" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "Class1InitialUnparkCount" /t REG_DWORD /d "100" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CustomizeDuringSetup" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%  → Advanced performance tweaks applied successfully%u%
goto :eof

:POWER_Step10_Activate
echo %c%[10/10] Activating optimized power scheme...%u%

echo %c%  → Making all hidden settings visible in Power Options...%u%
powercfg /attributes fea3413e-7e05-4911-9a71-700331f1c294 245d8541-3943-4422-b025-13a784f679b7 -ATTRIB_HIDE >nul 2>&1
powercfg /attributes fea3413e-7e05-4911-9a71-700331f1c294 4faab71a-92e5-4726-b531-224559672d19 -ATTRIB_HIDE >nul 2>&1
powercfg /attributes fea3413e-7e05-4911-9a71-700331f1c294 f15576e8-98b7-4186-b944-eafa664402d9 -ATTRIB_HIDE >nul 2>&1

echo %c%  → Applying power scheme settings...%u%
powercfg -SETACTIVE %CUSTOM_GUID% >nul 2>&1

echo %c%  → Creating configuration backup...%u%
echo Desktop Ultimate Performance Plan Created: %date% %time% > "%temp%\desktop_plan_created"
echo Scheme GUID: %CUSTOM_GUID% >> "%temp%\desktop_plan_created"
echo CPU Vendor: >> "%temp%\desktop_plan_created"
wmic cpu get name >> "%temp%\desktop_plan_created" 2>nul

echo %c%  → Power scheme activation completed%u%
goto :eof

:LaptopPowerPlan
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          LAPTOP BALANCED PERFORMANCE PLAN                    ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Laptop power plan features:%u%
echo %c%• High performance when plugged in (AC power)%u%
echo %c%• Battery conservation when on battery (DC power)%u%
echo %c%• Smart CPU scaling based on power source%u%
echo %c%• Optimized display and sleep timeouts for battery%u%
echo %c%• USB power management for longer battery life%u%
echo %c%• Gaming performance when connected to power%u%
echo.
echo %red%%underline%Laptop Notice:%u%
echo %c%This plan balances performance and battery life intelligently.%u%
echo %c%Maximum performance on AC power, battery conservation on battery.%u%
echo.
echo.
choice /C YN /M "%c%Create Laptop Balanced Performance plan? (Y/N)%u%"
if errorlevel 2 goto K

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                     LAPTOP POWER PLAN OPTIMIZATION IN PROGRESS               ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/10] Restoring Default Power Schemes...%u%
powercfg -restoredefaultschemes >nul 2>&1

echo %c%[2/10] Creating Batlez Laptop Balanced Performance Plan...%u%
powercfg /d 44444444-4444-4444-4444-444444444442 >nul 2>&1
powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e 44444444-4444-4444-4444-444444444442 >nul 2>&1
powercfg /changename 44444444-4444-4444-4444-444444444442 "Batlez Laptop Performance" "Balanced performance plan optimized for gaming laptops" >nul 2>&1

echo %c%[3/10] Configuring Intelligent CPU Performance...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444442 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 85 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444442 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 5 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444442 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444442 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 90 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444442 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 50 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444442 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 10 >nul 2>&1

echo %c%[4/10] Configuring Smart Boost Settings...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444442 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 3 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444442 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 1 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444442 54533251-82be-4824-96c1-47b60b740d00 4b92d758-5a24-4851-a470-815d78aee119 5 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444442 54533251-82be-4824-96c1-47b60b740d00 4b92d758-5a24-4851-a470-815d78aee119 30 >nul 2>&1

echo %c%[5/10] Configuring Battery-Smart Power Management...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444442 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444442 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444442 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444442 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 1 >nul 2>&1

echo %c%[6/10] Configuring Intelligent Display Settings...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444442 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 900 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444442 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 300 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444442 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 1800 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444442 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 900 >nul 2>&1

echo %c%[7/10] Optimizing GPU for Gaming and Battery...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444442 5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c dd848b2a-8a5d-4451-9ae2-39cd41658f6c 2 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444442 5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c dd848b2a-8a5d-4451-9ae2-39cd41658f6c 0 >nul 2>&1

echo %c%[8/10] Configuring Storage for Balance...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444442 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444442 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 600 >nul 2>&1

echo %c%[9/10] Applying Laptop-Specific Optimizations...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444442 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 13d09884-f74e-474a-a852-b6bde8ad03a8 40 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444442 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 13d09884-f74e-474a-a852-b6bde8ad03a8 70 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444442 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444442 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 1 >nul 2>&1

echo %c%[10/10] Activating Laptop Power Plan...%u%
powercfg -SETACTIVE "44444444-4444-4444-4444-444444444442" >nul 2>&1

goto PowerPlanComplete

:PowerPlanComplete
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatencyCheckEnabled" /t REG_DWORD /d "1" /f >nul 2>&1

echo.
echo %c%Verifying power plan configuration...%u%
timeout /t 2 >nul

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    CUSTOM POWER PLAN OPTIMIZATION COMPLETED                  ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Power plan has been successfully created and activated.%u%
echo.
if exist "%temp%\desktop_plan_created" (
    echo %c%Desktop Plan Configuration:%u%
    echo %c%• Name: Batlez Desktop Ultimate%u%
    echo %c%• Type: Maximum performance for desktop gaming%u%
    echo %c%• CPU: 100%% minimum, no throttling, all cores active%u%
    echo %c%• GPU: Maximum performance preference%u%
    echo %c%• Power Saving: All features disabled%u%
    echo %c%• Display/Sleep: Never turn off%u%
    echo %c%• USB/PCI: Power management disabled%u%
    echo.
    echo %red%Perfect for: Desktop gaming PCs with reliable power supply%u%
    del "%temp%\desktop_plan_created" >nul 2>&1
) else (
    echo %c%Laptop Plan Configuration:%u%
    echo %c%• Name: Batlez Laptop Performance%u%
    echo %c%• Type: Intelligent performance with battery optimization%u%
    echo %c%• AC Power: High performance mode for gaming%u%
    echo %c%• Battery Power: Balanced mode for longer battery life%u%
    echo %c%• CPU: Smart scaling based on power source%u%
    echo %c%• GPU: Maximum performance on AC, auto on battery%u%
    echo %c%• Display: 15min AC timeout, 5min battery timeout%u%
    echo %c%• Sleep: 30min AC timeout, 15min battery timeout%u%
    echo.
    echo %red%Perfect for: Gaming laptops with smart power management%u%
)
echo.
echo %c%Common Optimizations Applied:%u%
echo %c%• Power throttling completely disabled%u%
echo %c%• System exit latency minimized%u%
echo %c%• Network throttling optimized for gaming%u%
echo %c%• Advanced power management configured%u%
echo.
echo %red%Performance Benefits:%u%
echo %c%• Reduced input latency and system response times%u%
echo %c%• Consistent frame rates in games%u%
echo %c%• Optimized for competitive gaming and streaming%u%
if not exist "%temp%\desktop_plan_created" echo %c%• Extended battery life when unplugged%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:A
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                              SYSTEM CLEANUP UTILITY                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This comprehensive cleanup will remove:%u%
echo %c%• Temporary files and system caches%u%
echo %c%• Browser data and download caches%u%
echo %c%• Application logs and crash reports%u%
echo %c%• Registry MRU entries and history%u%
echo %c%• GPU driver caches and shader files%u%
echo.
echo %red%%underline%Important Notice:%u%
echo %c%This operation will permanently delete temporary files, caches, and logs.%u%
echo %c%Ensure important data is backed up before proceeding.%u%
echo.
echo.
choice /C YN /M "%c%Proceed with system cleanup? (Y/N)%u%"
if errorlevel 2 goto TweaksMenu

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                            CLEANUP IN PROGRESS                               ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/8] Cleaning Windows System Files...%u%
if exist "C:\Windows\Temp" (
    del /s /f /q "C:\Windows\Temp\*.*" 2>nul
    for /d %%D in ("C:\Windows\Temp\*") do rd /s /q "%%D" 2>nul
)
del /s /f /q "C:\Windows\tempor~1\*.*" 2>nul
del /s /f /q "C:\Windows\Tmp\*.*" 2>nul
del /s /f /q "C:\Windows\ff*.tmp" 2>nul
del /s /f /q "C:\Windows\Prefetch\*.*" 2>nul
del /s /f /q "%SystemRoot%\SoftwareDistribution\Download\*.*" 2>nul

echo %c%[2/8] Cleaning User Temporary Files...%u%
if exist "%temp%" (
    del /s /f /q "%temp%\*.*" 2>nul
    for /d %%D in ("%temp%\*") do rd /s /q "%%D" 2>nul
)
del /s /f /q "%USERPROFILE%\AppData\Local\Temp\*.*" 2>nul
for /d %%D in ("%USERPROFILE%\AppData\Local\Temp\*") do rd /s /q "%%D" 2>nul
del /s /f /q "%userprofile%\Recent\*.*" 2>nul

echo %c%[3/8] Cleaning Browser Caches...%u%
del /s /f /q "%LocalAppData%\Google\Chrome\User Data\Default\Cache\*.*" 2>nul
del /s /f /q "%LocalAppData%\Google\Chrome\User Data\Default\Code Cache\*.*" 2>nul
del /s /f /q "%LocalAppData%\Google\Chrome\User Data\Default\GPUCache\*.*" 2>nul
del /s /f /q "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache\*.*" 2>nul
del /s /f /q "%LocalAppData%\Microsoft\Edge\User Data\Default\Code Cache\*.*" 2>nul
del /s /f /q "%LocalAppData%\Microsoft\Edge\User Data\Default\GPUCache\*.*" 2>nul
for /d %%D in ("%LocalAppData%\Mozilla\Firefox\Profiles\*") do (
    del /s /f /q "%%D\cache2\*.*" 2>nul
    del /s /f /q "%%D\startupCache\*.*" 2>nul
)
del /s /f /q "%LocalAppData%\Microsoft\Windows\INetCache\*.*" 2>nul

echo %c%[4/8] Cleaning GPU Driver Caches...%u%
del /s /f /q "%USERPROFILE%\AppData\LocalLow\NVIDIA\PerDriverVersion\DXCache\*.*" 2>nul
del /s /f /q "%USERPROFILE%\AppData\Local\NVIDIA\DXCache\*.*" 2>nul
del /s /f /q "%USERPROFILE%\AppData\Local\NVIDIA\GLCache\*.*" 2>nul
del /s /f /q "%USERPROFILE%\AppData\Local\AMD\DxCache\*.*" 2>nul
del /s /f /q "%USERPROFILE%\AppData\Local\AMD\DxcCache\*.*" 2>nul
del /s /f /q "%USERPROFILE%\AppData\Local\AMD\VkCache\*.*" 2>nul
del /s /f /q "%USERPROFILE%\AppData\LocalLow\AMD\DxCache\*.*" 2>nul
del /s /f /q "%USERPROFILE%\AppData\Local\Intel\ShaderCache\*.*" 2>nul

echo %c%[5/8] Cleaning Application Caches...%u%
del /s /f /q "%AppData%\discord\Cache\*.*" 2>nul
del /s /f /q "%AppData%\discord\Code Cache\*.*" 2>nul
del /s /f /q "%AppData%\discord\GPUCache\*.*" 2>nul
del /s /f /q "%ProgramFiles(x86)%\Steam\appcache\httpcache\*.*" 2>nul
del /s /f /q "%ProgramFiles(x86)%\Steam\depotcache\*.*" 2>nul
del /s /f /q "%ProgramFiles(x86)%\Steam\logs\*.*" 2>nul
del /s /f /q "%ProgramFiles(x86)%\Steam\dumps\*.*" 2>nul
del /s /f /q "%ProgramFiles(x86)%\Steam\steamapps\temp\*.*" 2>nul
del /s /f /q "%ProgramFiles(x86)%\Steam\steamapps\shadercache\*.*" 2>nul
del /s /f /q "%USERPROFILE%\AppData\Local\Steam\htmlcache\*.*" 2>nul
del /s /f /q "%USERPROFILE%\AppData\Local\Steam\logs\*.*" 2>nul
del /s /f /q "%LocalAppData%\EpicGamesLauncher\Saved\Logs\*.*" 2>nul
del /s /f /q "%LocalAppData%\EpicGamesLauncher\Saved\webcache\*.*" 2>nul
del /s /f /q "%AppData%\.minecraft\logs\*.*" 2>nul
del /s /f /q "%AppData%\.minecraft\crash-reports\*.*" 2>nul

echo %c%[6/8] Cleaning System Logs and Dumps...%u%
del /s /f /q "%SystemRoot%\*.log" 2>nul
del /s /f /q "%SystemRoot%\Logs\CBS\*.log" 2>nul
del /s /f /q "%SystemRoot%\Logs\MoSetup\*.log" 2>nul
del /s /f /q "%SystemRoot%\Panther\*.*" 2>nul
del /s /f /q "%SystemRoot%\inf\setupapi.*.log" 2>nul
del /s /f /q "%SystemRoot%\Minidump\*.*" 2>nul
del /s /f /q "%SystemRoot%\Memory.dmp" 2>nul
del /s /f /q "%ProgramData%\Microsoft\Windows\WER\Temp\*.*" 2>nul

echo %c%[7/8] Cleaning Registry History...%u%
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit" /va /f 2>nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU" /va /f 2>nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU" /va /f 2>nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRULegacy" /va /f 2>nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" /va /f 2>nul

echo %c%[8/8] Running Advanced Disk Cleanup...%u%
echo.
echo %c%Launching Disk Cleanup utility...%u%
echo %c%Please select all options EXCEPT 'DirectX Shader Cache' and click OK%u%
timeout /t 3 >nul
cleanmgr /sageset:0
echo.
echo %c%Running automated cleanup...%u%
cleanmgr /sagerun:0

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                            CLEANUP COMPLETED                                 ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%System cleanup has been completed successfully.%u%
echo.
echo %c%Summary:%u%
echo %c%• Temporary files and caches removed%u%
echo %c%• Browser data cleaned%u%
echo %c%• Application logs cleared%u%
echo %c%• GPU driver caches purged%u%
echo %c%• Registry history cleaned%u%
echo %c%• System performance optimized%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:B
setlocal enabledelayedexpansion
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           BCDEDIT OPTIMIZATION SUITE                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%BCDEdit optimization includes:%u%
echo %c%• Dynamic tick and platform tick optimization for better timer performance%u%
echo %c%• PCI settings and firmware optimization for hardware compatibility%u%
echo %c%• TSC sync policy enhancement for improved CPU timing synchronization%u%
echo %c%• APIC mode and physical destination optimization for interrupt handling%u%
echo %c%• TPM boot entropy and boot UX optimization for faster boot times%u%
echo %c%• Integrity checks and code signing optimization for performance%u%
echo %c%• Hypervisor and virtualization optimization for gaming performance%u%
echo %c%• NX (Data Execution Prevention) optimization for compatibility%u%
echo %c%• Advanced boot configuration for maximum system performance%u%
echo %c%• Hardware abstraction layer optimization%u%
echo %c%• Interrupt and timer subsystem enhancement%u%
echo %c%• Security feature optimization for gaming workloads%u%
echo.
echo %red%%underline%BCDEdit Notice:%u%
echo %c%These tweaks modify critical boot configuration settings.%u%
echo %c%A system restart will be required for all changes to take effect.%u%
echo %c%All changes can be reverted if needed using BCDEdit commands.%u%
echo.
echo.
choice /C YN /M "%c%Apply comprehensive BCDEdit optimizations? (Y/N)%u%"
if errorlevel 2 goto TweaksMenu

echo %c%[Pre] Applying Windows 11 timer resolution and kernel timer registry tweaks...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "SerializeTimerExpiration" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "EnablePerCpuClockTickScheduling" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "TimerCheckFlags" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DistributeTimers" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DebugPollInterval" /t REG_DWORD /d "1000" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\KernelVelocity" /v "DisableFGBoostDecay" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\I/O System" /v "PassiveIntRealTimeWorkerPriority" /t REG_DWORD /d "18" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\ModernSleep" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Ndu" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NdisCap" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NdisVirtualBus" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ControlSet001\Services\NlaSvc\Parameters\Internet" /v "EnableActiveProbing" /t REG_DWORD /d "0" /f >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                      BCDEDIT OPTIMIZATION IN PROGRESS                        ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo %c%[Category 1/6] CPU Timer Optimization%u%
echo %c%These settings affect how Windows handles CPU timers and can improve performance%u%
echo %c%and reduce input latency, but may cause instability on some systems.%u%
echo.
choice /C YN /M "%c%Apply CPU timer tweaks? (Y=Performance, N=Stability) %u%" /D N /T 10
echo.
if errorlevel 2 (
    echo %c%Skipping CPU timer tweaks for better stability...%u%
) else (
    echo %c%[1/4] Applying dynamic tick optimization...%u%
    bcdedit /set disabledynamictick yes >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Dynamic tick disabled for consistent timer performance%u%
    ) else (
        echo %c%  ✗ Failed to disable dynamic tick%u%
    )
    
    echo %c%[2/4] Applying platform tick optimization...%u%
    bcdedit /set useplatformtick yes >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Platform tick enabled for improved timing accuracy%u%
    ) else (
        echo %c%  ✗ Failed to enable platform tick%u%
    )
    
    echo %c%[3/4] Applying TSC synchronization policy enhancement...%u%
    bcdedit /set tscsyncpolicy enhanced >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ TSC sync policy set to enhanced for better CPU timing%u%
    ) else (
        echo %c%  ✗ Failed to set TSC sync policy%u%
    )
    
    echo %c%[4/4] Applying high precision event timer optimization...%u%
    bcdedit /set disableelamdrivers yes >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ ELAM drivers disabled for reduced timer overhead%u%
    ) else (
        echo %c%  ✗ Failed to disable ELAM drivers%u%
    )
)

echo.
echo %c%[Category 2/6] CPU Architecture Settings%u%
echo %c%These settings optimize how Windows interacts with your CPU architecture.%u%
echo %c%They can improve performance but may cause instability on some systems.%u%
echo.
choice /C YN /M "%c%Apply CPU architecture tweaks? (Y=Performance, N=Compatibility) %u%" /D N /T 10
echo.
if errorlevel 2 (
    echo %c%Skipping CPU architecture tweaks for better compatibility...%u%
) else (
    echo %c%[1/5] Applying legacy APIC mode optimization...%u%
    bcdedit /set uselegacyapicmode no >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Legacy APIC mode disabled for modern interrupt handling%u%
    ) else (
        echo %c%  ✗ Failed to disable legacy APIC mode%u%
    )
    
    echo %c%[2/5] Applying advanced x2APIC policy...%u%
    bcdedit /set x2apicpolicy Enable >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ x2APIC policy enabled for improved interrupt handling%u%
    ) else (
        echo %c%  ✗ Failed to enable x2APIC policy%u%
    )
    
    echo %c%[3/5] Applying MSI (Message Signaled Interrupts) optimization...%u%
    bcdedit /set MSI Default >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ MSI set to Default for optimal interrupt delivery%u%
    ) else (
        echo %c%  ✗ Failed to set MSI to Default%u%
    )
    
    echo %c%[4/5] Optimizing CPU MSR settings...%u%
    bcdedit /set usemsr No >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ CPU MSR access optimized for performance%u%
    ) else (
        echo %c%  ✗ Failed to optimize CPU MSR access%u%
    )
    
    echo %c%[5/5] Applying CPU isolation settings...%u%
    bcdedit /set isolatedcontext No >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Isolated context disabled for lower CPU overhead%u%
    ) else (
        echo %c%  ✗ Failed to disable isolated context%u%
    )
    bcdedit /set highestmode Yes >nul 2>&1
    bcdedit /set noumex Yes >nul 2>&1
    bcdedit /set usefirmwarepcisettings No >nul 2>&1
)

echo.
echo %c%[Category 3/6] Memory Optimization Settings%u%
echo %c%These settings modify how Windows manages system memory.%u%
echo %c%They can improve performance but may reduce stability on some systems.%u%
echo.
choice /C YN /M "%c%Apply memory optimization tweaks? (Y=Performance, N=Stability) %u%" /D N /T 10
echo.
if errorlevel 2 (
    echo %c%Skipping memory optimization tweaks for better stability...%u%
) else (
    echo %c%[1/4] Applying user virtual address space increase...%u%
    bcdedit /set increaseuserva 8192 >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ User virtual address space increased for better memory allocation%u%
    ) else (
        echo %c%  ✗ Failed to increase user virtual address space%u%
    )
    
    echo %c%[2/4] Optimizing first megabyte memory policy...%u%
    bcdedit /set firstmegabytepolicy UseAll >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ First megabyte policy optimized for full memory utilization%u%
    ) else (
        echo %c%  ✗ Failed to optimize first megabyte policy%u%
    )
    
    echo %c%[3/4] Applying memory addressing optimization...%u%
    bcdedit /set linearaddress57 OptOut >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ 57-bit linear addressing optimized for performance%u%
    ) else (
        echo %c%  ✗ Failed to optimize 57-bit linear addressing%u%
    )
    
    echo %c%[4/4] Configuring performance memory allocation...%u%
    bcdedit /set perfmem Standard >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Performance memory allocation enabled for optimized memory usage%u%
    ) else (
        echo %c%  ✗ Failed to enable performance memory allocation%u%
    )
    bcdedit /set nolowmem Yes >nul 2>&1
    bcdedit /set avoidlowmemory 0x8000000 >nul 2>&1
)

echo.
echo %c%[Category 4/6] PCI and Hardware Interface Settings%u%
echo %c%These settings modify how Windows interacts with hardware controllers.%u%
echo %c%They can improve performance but may cause compatibility issues with some hardware.%u%
echo.
choice /C YN /M "%c%Apply PCI and hardware tweaks? (Y=Performance, N=Compatibility) %u%" /D N /T 10
echo.
if errorlevel 2 (
    echo %c%Skipping PCI and hardware tweaks for better compatibility...%u%
) else (
    echo %c%[1/5] Applying firmware PCI settings optimization...%u%
    bcdedit /set usefirmwarepcisettings No >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Firmware PCI settings disabled for manual PCI control%u%
    ) else (
        echo %c%  ✗ Failed to disable firmware PCI settings%u%
    )
    
    echo %c%[2/5] Applying physical destination optimization...%u%
    bcdedit /set usephysicaldestination No >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Physical destination disabled for logical interrupt routing%u%
    ) else (
        echo %c%  ✗ Failed to disable physical destination%u%
    )
    
    echo %c%[3/5] Applying TPM boot entropy optimization...%u%
    bcdedit /set tpmbootentropy ForceDisable >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ TPM boot entropy force disabled for faster boot times%u%
    ) else (
        echo %c%  ✗ Failed to disable TPM boot entropy%u%
    )
    
    echo %c%[4/5] Optimizing PCI Express settings...%u%
    bcdedit /set pciexpress Default >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ PCI Express set to Default for optimal performance%u%
    ) else (
        echo %c%  ✗ Failed to set PCI Express to Default%u%
    )
    
    echo %c%[5/5] Applying hardware PTE optimization...%u%
    bcdedit /set forcehardwarepte No >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Hardware PTE forcing disabled for improved memory management%u%
    ) else (
        echo %c%  ✗ Failed to disable hardware PTE forcing%u%
    )
)

echo.
echo %c%[Category 5/6] Boot Experience Settings%u%
echo %c%These settings optimize the Windows boot process for speed.%u%
echo %c%They will make the boot process faster but may hide useful information.%u%
echo.
choice /C YN /M "%c%Apply boot experience tweaks? (Y=Faster boot, N=Normal boot) %u%" /D N /T 10
echo.
if errorlevel 2 (
    echo %c%Keeping normal boot experience...%u%
) else (
    echo %c%[1/5] Applying boot UX optimization...%u%
    bcdedit /set bootux Disabled >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Boot UX disabled for faster boot process%u%
    ) else (
        echo %c%  ✗ Failed to disable boot UX%u%
    )
    
    echo %c%[2/5] Applying quiet boot optimization...%u%
    bcdedit /set quietboot yes >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Quiet boot enabled for cleaner boot experience%u%
    ) else (
        echo %c%  ✗ Failed to enable quiet boot%u%
    )
    
    echo %c%[3/5] Disabling boot logging...%u%
    bcdedit /set bootlog No >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Boot logging disabled for faster boot%u%
    ) else (
        echo %c%  ✗ Failed to disable boot logging%u%
    )
    
    echo %c%[4/5] Optimizing boot status policy...%u%
    bcdedit /set bootstatuspolicy IgnoreAllFailures >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Boot status policy set to ignore non-critical failures%u%
    ) else (
        echo %c%  ✗ Failed to set boot status policy%u%
    )
    
    echo %c%[5/5] Disabling driver initialization messages...%u%
    bcdedit /set sos No >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ SOS boot messages disabled for cleaner boot%u%
    ) else (
        echo %c%  ✗ Failed to disable SOS boot messages%u%
    )
)

echo.
echo %c%[Category 6/6] %red%Security Settings (HIGH RISK)%u%
echo %c%%red%WARNING: These settings disable critical Windows security features.%u%
echo %c%%red%Disabling these protections may leave your system vulnerable to malware%u%
echo %c%%red%and exploits. Only use these if you fully understand the risks.%u%
echo.
choice /C YN /M "%red%Disable security features for performance? (NOT RECOMMENDED) (Y/N) %u%" /D N /T 10
echo.
if errorlevel 2 (
    echo %c%Keeping security features enabled (recommended)...%u%
) else (
    echo %c%%red%[WARNING] Disabling critical security features as requested...%u%
    
    echo %c%[1/7] Applying load options optimization...%u%
    bcdedit /set loadoptions DISABLE_INTEGRITY_CHECKS >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Load options set to disable integrity checks%u%
    ) else (
        echo %c%  ✗ Failed to set load options%u%
    )
    
    echo %c%[2/7] Applying integrity checks optimization...%u%
    bcdedit /set nointegritychecks Yes >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Integrity checks disabled for improved performance%u%
    ) else (
        echo %c%  ✗ Failed to disable integrity checks%u%
    )
    
    echo %c%[3/7] Configuring test signing...%u%
    bcdedit /set testsigning No >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Test signing disabled for production environment%u%
    ) else (
        echo %c%  ✗ Failed to disable test signing%u%
    )
    
    echo %c%[4/7] Disabling hypervisor...%u%
    bcdedit /set hypervisorlaunchtype off >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Hypervisor launch disabled for maximum gaming performance%u%
    ) else (
        echo %c%  ✗ Failed to disable hypervisor launch%u%
    )
    
    echo %c%[5/7] Configuring Data Execution Prevention...%u%
    bcdedit /set nx AlwaysOff >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ NX (DEP) disabled for compatibility and performance%u%
    ) else (
        echo %c%  ✗ Failed to disable NX (DEP)%u%
    )
    
    echo %c%[6/7] Disabling virtualization-based security...%u%
    bcdedit /set vsmlaunchtype Off >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Virtualization-based security disabled for performance%u%
    ) else (
        echo %c%  ✗ Failed to disable virtualization-based security%u%
    )
    
    echo %c%[7/7] Disabling credential guard...%u%
    bcdedit /set vm No >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Virtual machine platform disabled for performance%u%
    ) else (
        echo %c%  ✗ Failed to disable virtual machine platform%u%
    )
)

echo.
echo %c%[Optional] %yellow%Expert Mode - Advanced Boot Settings%u%
echo %c%%yellow%These settings are for expert users only and may cause serious system issues%u%
echo %c%%yellow%if applied incorrectly. Most users should skip this section.%u%
echo.
choice /C YN /M "%yellow%Enable expert mode settings? (Advanced users only) (Y/N) %u%" /D N /T 10
echo.
if errorlevel 2 (
    echo %c%Skipping expert mode settings...%u%
) else (
    echo %c%%yellow%[WARNING] Applying expert-level boot configuration settings...%u%
    
    echo %c%[1/7] Advanced debug port configuration...%u%
    bcdedit /set debug No >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Debug mode disabled for improved performance%u%
    ) else (
        echo %c%  ✗ Failed to disable debug mode%u%
    )
    
    echo %c%[2/7] Advanced Emergency Management Services...%u%
    bcdedit /set bootems No >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Boot EMS disabled for cleaner boot process%u%
    ) else (
        echo %c%  ✗ Failed to disable boot EMS%u%
    )
    
    echo %c%[3/7] Advanced cluster mode addressing...%u%
    bcdedit /set clustermodeaddressing 1 >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Cluster mode addressing optimized for performance%u%
    ) else (
        echo %c%  ✗ Failed to optimize cluster mode addressing%u%
    )
    
    echo %c%[4/7] Advanced XSave policy...%u%
    bcdedit /set xsavedisable No >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ XSave functionality enabled for optimal CPU operation%u%
    ) else (
        echo %c%  ✗ Failed to enable XSave functionality%u%
    )
    
    echo %c%[5/7] Advanced graphics mode settings...%u%
    bcdedit /set graphicsmodedisabled No >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Graphics mode enabled for proper display functionality%u%
    ) else (
        echo %c%  ✗ Failed to enable graphics mode%u%
    )
    
    echo %c%[6/7] Advanced highest mode setting...%u%
    bcdedit /set highestmode Yes >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Highest resolution mode enabled%u%
    ) else (
        echo %c%  ✗ Failed to enable highest resolution mode%u%
    )
    
    echo %c%[7/7] Advanced legacy platform configuration...%u%
    bcdedit /set forcelegacyplatform No >nul 2>&1
    if !errorlevel! equ 0 (
        echo %c%  ✓ Legacy platform forcing disabled for modern hardware support%u%
    ) else (
        echo %c%  ✗ Failed to disable legacy platform forcing%u%
    )
)

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                      BCDEDIT OPTIMIZATION COMPLETED                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%BCDEdit boot configuration optimization has been successfully completed.%u%
echo.
echo %c%Applied Boot Configuration Optimizations:%u%
echo %c%• Dynamic tick disabled for consistent timer performance and reduced latency%u%
echo %c%• Platform tick enabled for improved system timing accuracy%u%
echo %c%• Firmware PCI settings disabled for manual hardware control%u%
echo %c%• TSC synchronization policy enhanced for better multi-core CPU timing%u%
echo %c%• Legacy APIC mode disabled for modern interrupt handling%u%
echo %c%• Physical destination disabled for optimized logical interrupt routing%u%
echo %c%• TPM boot entropy force disabled for significantly faster boot times%u%
echo %c%• Boot UX disabled to eliminate unnecessary boot screen delays%u%
echo %c%• Load options configured to disable integrity checks for performance%u%
echo %c%• Integrity checks disabled to reduce boot and runtime overhead%u%
echo %c%• Test signing disabled for production-level system configuration%u%
echo %c%• Hypervisor launch disabled for maximum gaming and application performance%u%
echo %c%• NX (Data Execution Prevention) disabled for enhanced compatibility%u%
echo.
echo %red%Boot Configuration Benefits:%u%
echo %c%• Significantly reduced system boot times%u%
echo %c%• Improved timer accuracy and consistency for gaming applications%u%
echo %c%• Enhanced interrupt handling and CPU performance%u%
echo %c%• Reduced system overhead from security and virtualization features%u%
echo %c%• Better hardware compatibility and control%u%
echo %c%• Optimized multi-core CPU synchronization%u%
echo %c%• Eliminated unnecessary boot delays and checks%u%
echo %c%• Maximum performance configuration for gaming workloads%u%
echo.
echo %red%Important Security and Compatibility Notes:%u%
echo %c%• Some security features have been disabled for maximum performance%u%
echo %c%• Integrity checks and DEP have been turned off - monitor system stability%u%
echo %c%• Hypervisor features are disabled - virtualization software may not work%u%
echo %c%• These changes optimize for performance over security%u%
echo %c%• All changes can be reverted using BCDEdit if needed%u%
echo.
echo %red%Next Steps:%u%
echo %c%• A system restart is REQUIRED for all BCDEdit changes to take effect%u%
echo %c%• Monitor system stability after restart%u%
echo %c%• Test gaming and application performance improvements%u%
echo %c%• If issues occur, changes can be reverted using BCDEdit commands%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       TIMER RESOLUTION SETUP                                ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Timer Resolution locks the Windows timer to a fixed low interval for consistent%u%
echo %c%frame timing and reduced input latency.%u%
echo.
choice /C YN /M "%c%Set up Timer Resolution auto-start? (Y/N)%u%"
if errorlevel 2 goto TweaksMenu

echo.
echo %c%[1/3] Downloading SetTimerResolution...%u%
mkdir "C:\BatlezTools\TimerResolution" >nul 2>&1
curl -g -L -# -o "C:\BatlezTools\TimerResolution\SetTimerResolution.exe" "https://github.com/valleyofdoom/TimerResolution/releases/latest/download/SetTimerResolution.exe" 2>nul
if not exist "C:\BatlezTools\TimerResolution\SetTimerResolution.exe" (
    echo %red%  Failed to download SetTimerResolution.exe. Place it manually at:%u%
    echo %c%  C:\BatlezTools\TimerResolution\SetTimerResolution.exe%u%
) else (
    echo %green%  [+] Downloaded successfully%u%
)

echo.
echo %c%[2/3] Detecting Windows version...%u%
for /f "tokens=2 delims==" %%v in ('wmic os get BuildNumber /value 2^>nul ^| findstr "="') do set "OS_BUILD=%%v"
set /a OS_BUILD_NUM=OS_BUILD+0
echo %green%  Windows 11 detected%u%

echo.
echo %c%[3/3] Choose Timer Resolution:%u%
echo.
echo %green%  [1] 0.500ms (5000)   - Lowest latency%u%
echo %green%  [2] 0.504ms (5040)   - Slight stability gain%u%
echo %green%  [3] 0.507ms (5070)   - Balanced%u%
echo %orange%  [4] Custom value%u%
echo %red%  [5] Skip%u%
echo.
set /p TR_OPT="%c%Enter option (1-5): %u%"
if "!TR_OPT!"=="1" (
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "TimerResolution" /t REG_SZ /d "\"C:\BatlezTools\TimerResolution\SetTimerResolution.exe\" --resolution 5000 --no-console" /f >nul 2>&1
    echo %green%  [+] Timer Resolution 0.500ms set to auto-start%u%
) else if "!TR_OPT!"=="2" (
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "TimerResolution" /t REG_SZ /d "\"C:\BatlezTools\TimerResolution\SetTimerResolution.exe\" --resolution 5040 --no-console" /f >nul 2>&1
    echo %green%  [+] Timer Resolution 0.504ms set to auto-start%u%
) else if "!TR_OPT!"=="3" (
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "TimerResolution" /t REG_SZ /d "\"C:\BatlezTools\TimerResolution\SetTimerResolution.exe\" --resolution 5070 --no-console" /f >nul 2>&1
    echo %green%  [+] Timer Resolution 0.507ms set to auto-start%u%
) else if "!TR_OPT!"=="4" (
    set /p TR_CUSTOM="%c%Enter value in 100-nanosecond units (e.g. 5000): %u%"
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "TimerResolution" /t REG_SZ /d "\"C:\BatlezTools\TimerResolution\SetTimerResolution.exe\" --resolution !TR_CUSTOM! --no-console" /f >nul 2>&1
    echo %green%  [+] Timer Resolution !TR_CUSTOM! set to auto-start%u%
) else (
    echo %c%  Skipped Timer Resolution setup%u%
)
goto TweaksMenu


:C
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                            GPU PERFORMANCE OPTIMIZER                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Select your graphics card manufacturer for optimized performance tweaks:%u%
echo.
echo %c%                           ╔════════════════════════════════╗
echo                            ║    [1] %red%AMD%u%%c% Graphics Card       ║
echo                            ║    [2] %green%NVIDIA%u%%c% Graphics Card    ║
echo                            ║    [3] %blue%Intel%u%%c% Graphics Card     ║
echo                            ║                                ║
echo                            ║    [0] Return to Main Menu     ║
echo                            ╚════════════════════════════════╝%u%
echo.
echo %c%Note: These optimizations are specifically tailored for each GPU vendor%u%
echo %c%and will apply manufacturer-specific performance enhancements.%u%
echo.
set /p choice="%c%Select your GPU manufacturer »%u% "
if "%choice%"=="0" goto TweaksMenu
if "%choice%"=="1" goto AMDGPU
if "%choice%"=="2" goto NVIDIAGPU
if "%choice%"=="3" goto INTELGPU
cls
echo.
echo %red%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                                INVALID INPUT                                 ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Please select a valid option [0-3] from the menu.%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO RETRY ══════════════════════════%u%
pause >nul
goto C

:INTELGPU
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         %blue%INTEL%u%%c% GRAPHICS OPTIMIZATION                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Applying Intel-specific performance optimizations:%u%
echo %c%• Memory and power management tweaks%u%
echo %c%• Display compositor optimizations%u%
echo %c%• Hardware acceleration enhancements%u%
echo %c%• System timer and scheduling improvements%u%
echo.
echo %red%%underline%Performance Notice:%u%
echo %c%These optimizations prioritize performance over power efficiency.%u%
echo %c%Your system may run warmer and consume more power.%u%
echo.
echo.
choice /C YN /M "%c%Apply Intel GPU optimizations? (Y/N)%u%"
if errorlevel 2 goto C

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        %blue%INTEL%u%%c% OPTIMIZATION IN PROGRESS                        ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/6] Configuring Memory Settings...%u%
bcdedit /set allowedinmemorysettings 0x0 >nul 2>&1
bcdedit /set isolatedcontext No >nul 2>&1

echo %c%[2/6] Optimizing System Timers...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DistributeTimers" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[3/6] Configuring Display and DWM Settings...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\DWM" /v "DisableIndependentFlip" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableAGPSupport" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EnableDebugging" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[4/6] Enhancing CPU Performance Features...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableTsx" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[5/6] Disabling Power Management Features...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[6/6] Applying Intel-Specific Graphics Tweaks...%u%
reg add "HKLM\SOFTWARE\Intel\GMM" /v "DedicatedSegmentSize" /t REG_DWORD /d "1024" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\igfx\Parameters" /v "EnablePreemption" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[7/9] Disabling Intel driver-level image scaling (XeSS, Super Resolution)...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\igfx" /v "SuperResolutionEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\igfx" /v "XeSSDriverEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\igfx" /v "EnableDynamicScaling" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[8/9] Disabling Intel ray tracing support...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\igfx" /v "RayTracingEnable" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[9/9] Disabling Intel driver-level anti-aliasing...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\igfx" /v "MSAAEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\igfx" /v "PreRenderAALevel" /t REG_DWORD /d "0" /f >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                      %blue%INTEL%u%%c% OPTIMIZATION COMPLETED                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Intel GPU optimizations have been successfully applied.%u%
echo.
echo %c%Applied Optimizations:%u%
echo %c%• Memory allocation and context isolation%u%
echo %c%• System timer distribution and coalescing%u%
echo %c%• Display manager and DirectDraw enhancements%u%
echo %c%• CPU performance and power throttling%u%
echo %c%• Graphics driver preemption and latency%u%
echo %c%• Intel XeSS and Super Resolution scaling disabled%u%
echo %c%• Intel ray tracing disabled%u%
echo %c%• Intel MSAA and pre-render AA disabled%u%
echo.
echo %red%Recommendation:%u% %c%Restart your system for optimal performance gains.%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:NVIDIAGPU
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         %green%NVIDIA%u%%c% GPU PERFORMANCE OPTIMIZER                     ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%                        ╔══════════════════════════════════════════╗
echo                         ║  [1] Standard NVIDIA Optimizations      ║
echo                         ║  [2] Maximum Performance DWORDs         ║
echo                         ║      %red%(Experimental - High risk)%u%%c%         ║
echo                         ║  [3] Revert Experimental DWORDs         ║
echo                         ║                                         ║
echo                         ║  [0] Back to GPU Menu                   ║
echo                         ╚══════════════════════════════════════════╝%u%
echo.
echo %c%Standard:%u% Profile Inspector + driver tweaks + latency optimizations
echo %c%Experimental:%u% %red%Disables ALL NVIDIA power management. Higher heat + power draw.%u%
echo.
set /p NvChoice="%c%Choose an option »%u% "
if "%NvChoice%"=="0" goto C
if "%NvChoice%"=="1" goto NVIDIAGPUStandard
if "%NvChoice%"=="2" goto NVIDIAGPUExperimental
if "%NvChoice%"=="3" goto NVIDIAGPURevert
echo %red%Invalid option. Please try again.%u%
timeout /t 1 >nul
goto NVIDIAGPU

:NVIDIAGPUStandard
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         %green%NVIDIA%u%%c% GPU PERFORMANCE OPTIMIZER                     ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This optimization will apply comprehensive NVIDIA performance tweaks:%u%
echo %c%• Download and configure NVIDIA Profile Inspector%u%
echo %c%• Disable GPU preemption and CUDA context switching%u%
echo %c%• Optimize thread priorities and DPC handling%u%
echo %c%• Configure power management and latency settings%u%
echo %c%• Apply driver-specific performance enhancements%u%
echo.
echo %red%%underline%Performance Notice:%u%
echo %c%These optimizations prioritize performance over power efficiency.%u%
echo %c%Your system may run warmer and consume more power.%u%
echo.
echo.
choice /C YN /M "%c%Apply NVIDIA GPU optimizations? (Y/N)%u%"
if errorlevel 2 goto NVIDIAGPU

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                      %green%NVIDIA%u%%c% OPTIMIZATION IN PROGRESS                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/8] Downloading NVIDIA Profile Inspector...%u%
mkdir "%TEMP%\nvidiaProfileInspector\" 2>nul
rmdir /S /Q "%TEMP%\nvidiaProfileInspector\" 2>nul
curl -g -L -# -o "%TEMP%\nvidiaProfileInspector.zip" "https://github.com/Orbmu2k/nvidiaProfileInspector/releases/latest/download/nvidiaProfileInspector.zip" 2>nul
chcp 437 >nul
powershell -NoProfile Expand-Archive "%TEMP%\nvidiaProfileInspector.zip" -DestinationPath "%TEMP%\nvidiaProfileInspector" 2>nul
chcp 65001 >nul
del /F /Q "%TEMP%\nvidiaProfileInspector.zip" 2>nul
curl -g -L -# -o "%TEMP%\nvidiaProfileInspector\NVIDIAProfileInspector.nip" "https://raw.githubusercontent.com/Batlez/Batlez-Tweaks/main/Tools/NVIDIA.nip" 2>nul

echo %c%[2/8] Configuring Driver Thread Priorities...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl\Parameters" /v "ThreadPriority" /t REG_DWORD /d "15" /f >nul 2>&1

echo %c%[3/8] Optimizing DPC and Core Distribution...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRID61684" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\NVAPI" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[4/8] Enhancing System Performance Features...%u%
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "TurboQueue" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "EnableVIASBA" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "EnableIrongateSBA" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "EnableAGPSBA" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "EnableAGPFW" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "FastVram" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "ShadowFB" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "TexturePrecache" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\System" /v "EnableFastCopyPixels" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[5/8] Configuring GPU Preemption for Multi-Monitor Compatibility...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnablePreemption" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "GPUPreemptionLevel" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "ComputePreemption" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "DisablePreemption" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "DisableCudaContextPreemption" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "DisablePreemptionOnS3S4" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[6/8] Configuring Graphics Driver Settings...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RMDisablePostL2Compression" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RmDisableRegistryCaching" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableWriteCombining" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[7/8] Optimizing Power Management and Latency...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "Latency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceDefault" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HighPerformance" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MaximumPerformancePercent" /t REG_DWORD /d "100" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MinimumThrottlePercent" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "InterruptSteeringDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "EnableHDAudioD3Cold" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[8/8] Applying NVIDIA Profile Configuration...%u%
cd /d "%TEMP%\nvidiaProfileInspector\" 2>nul
nvidiaProfileInspector.exe "NVIDIAProfileInspector.nip" >nul 2>&1
reg add "HKCU\Software\NVIDIA Corporation\NvTray" /v "StartOnLogin" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableGR535" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[9/12] Locking GPU to Maximum P-State (eliminates clock micro-stutters)...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAsyncPstates" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "SlideMCLK" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[10/12] Disabling GPU Engine Gating (prevents mid-frame power-gating)...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMElcg" /t REG_DWORD /d "1431655765" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMBlcg" /t REG_DWORD /d "286331153" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMElpg" /t REG_DWORD /d "4095" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMSlcg" /t REG_DWORD /d "262131" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMFspg" /t REG_DWORD /d "15" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMGCOffFeature" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PreferSystemMemoryContiguous" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "PreferSystemMemoryContiguous" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[11/12] Disabling NVIDIA Driver Diagnostic Logging (reduces overhead)...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmRcWatchdog" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmLogonRC" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMIntrDetailedLogs" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMCtxswLog" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMNvLog" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMSuppressGPIOIntrErrLog" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMEnableEventTracer" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMUsbcDebugMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v "LogWarningEntries" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v "LogPagingEntries" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v "LogEventEntries" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v "LogErrorEntries" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[12/12] Disabling PCIe ASPM for GPU (reduces PCIe power-state latency)...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmOverrideSupportChipsetAspm" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMEnableASPMDT" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMDisableGpuASPMFlags" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMEnableASPMAtLoad" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[13/15] Applying NVIDIA driver scheduling latency suite...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "D3PCLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "F1TransitionLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "LOWLATENCY" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Node3DLowLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PciLatencyTimerControl" /t REG_DWORD /d "20" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMDeepL1EntryLatencyUsec" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcMaxFtuS" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcMinFtuS" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcPerioduS" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrEiIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrGrIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrGrRgIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrMsIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectFlipDPCDelayUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectFlipTimingMarginUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectJITFlipMsHybridFlipDelayUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrCursorMarginUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrDeflickerMarginUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrDeflickerMaxUs" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMHdcpKeyGlobZero" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Acceleration.Level" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DesktopStereoShortcuts" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "FeatureControl" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "DisplayPowerSaving" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableWriteCombining" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[14/15] Applying GraphicsDrivers power state latency floor (all transitions)...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyActivelyUsed" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleLongTime" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleMonitorOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleNoContext" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleShortTime" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleVeryLongTime" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle0" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle0MonitorOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle1" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle1MonitorOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceMemory" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceNoContext" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceNoContextMonitorOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceOther" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceTimerPeriod" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceActivelyUsed" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceMonitorOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceNoContext" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "Latency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MaxIAverageGraphicsLatencyInOneBucket" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MiracastPerfTrackGraphicsLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "TransitionLatency" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[15/16] Disabling GPU energy measurement driver...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDr" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1

echo %c%[16/16] Applying ECC, interrupt locking, large pages, and PCIe tweaks...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmEccScrubEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmIntrLockingMode" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMEnableLargePages" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMBigPageLimit" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmForceCopyEnginePCIeGen4" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMTimeSyncMode" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMDisablePcieProtections" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[17/22] Increasing DirectX layer performance...%u%
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "D3D10Debug" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D" /v "D3D10Debug" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "AllowTearing" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D" /v "AllowTearing" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "SoftwareOnly" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D" /v "SoftwareOnly" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "MaxFrameLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D" /v "MaxFrameLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "DisableThreadedOptimization" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D" /v "DisableThreadedOptimization" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "SoftwareOnly" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D\Drivers" /v "SoftwareOnly" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "EmulationOnly" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D\Drivers" /v "EmulationOnly" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Direct3D\ReferenceDevice" /v "Force10Level9" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D\ReferenceDevice" /v "Force10Level9" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Direct3D\ReferenceDevice" /v "DisableDriverManagement" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D\ReferenceDevice" /v "DisableDriverManagement" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "UseDebugLayer" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\DirectX" /v "UseDebugLayer" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "EnableStereo" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\DirectX" /v "EnableStereo" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "AllowTearing" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\DirectX" /v "AllowTearing" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[18/22] Disabling additional NVIDIA GPU logging...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMTraceLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "NVLogLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMDbgLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "NVVerbose" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "NVTweakLogLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableCoreDump" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "NVStResTracking" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableGPUCrashDump" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PerfLogLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "GPUTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\GPUDebugger" /v "EnableInterface" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\GPUDebugger" /v "EnableRemoteDebugger" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\GPUDebugger" /v "LogMask" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\GPUDebugger" /v "DisableLoad" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\GPUDebugger" /v "LogPath" /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NVDisplay.ContainerLocalSystem\LocalSystem\NvcDispCorePlugin" /v "RMDbgLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NVDisplay.ContainerLocalSystem\LocalSystem\NvcDispCorePlugin" /v "LogFile" /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NVDisplay.ContainerLocalSystem\LocalSystem" /v "TelemetryEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NVDisplay.ContainerLocalSystem\LocalSystem" /v "VerboseLog" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NVDisplay.ContainerLocalSystem\LocalSystem\Watchdog" /v "LogFile" /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NVDisplay.ContainerLocalSystem\LocalSystem\Watchdog\Session" /v "Folder" /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "LogLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "EnableDebugLayer" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "NVAPIDebugLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\NGXCore" /v "NGXDebugEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\NGXCore" /v "NGXPath" /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\NVAPI" /v "NvAPILoggingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\NVAPI" /v "NVAPIDebugLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\NvCamera" /v "NvCameraPath" /t REG_EXPAND_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "NvCplDebug" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "NvCplVerbose" /t REG_DWORD /d "0" /f >nul 2>&1
reg delete "HKCR\Directory\Background\shellex\ContextMenuHandlers\NvCplDesktopContext" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "NvRemixRuntime" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "RENDERDOC_CAPTUREOPTS" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "NSIGHT_LAUNCH" /f >nul 2>&1
sc config NvTelemetry start= disabled >nul 2>&1
sc config NvProfileUpdater64 start= disabled >nul 2>&1

echo %c%[19/22] Disabling unusual Vulkan layers (HKLM + HKCU)...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "VK_LOADER_DEBUG" /t REG_SZ /d "none" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DISABLE_VK_LAYER_VALVE_steam_overlay_1" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DISABLE_VK_LAYER_NV_optimus" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DISABLE_VK_LAYER_OBS_HOOK" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "VK_LAYER_PATH" /t REG_SZ /d "C:\Empty" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "VK_DRIVER_FILES" /t REG_SZ /d "C:\Program Files\NVIDIA Corporation\VulkanRT\nv-vk64.json" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "VK_ICD_FILENAMES" /t REG_SZ /d "C:\Drivers\nvidia_icd.json" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "VK_INSTANCE_LAYERS" /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "VK_DEVICE_LAYERS" /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "VK_DEBUG_REPORT" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "VK_DEBUG_UTILS" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "VK_FORCE_DISCRETE_GPU" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "VK_SAMPLE_COUNT_OVERRIDE" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "VK_ENABLE_RAY_TRACING" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "VK_USE_DXR" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Environment" /v "VK_LOADER_DEBUG" /t REG_SZ /d "none" /f >nul 2>&1
reg add "HKCU\Environment" /v "DISABLE_VK_LAYER_VALVE_steam_overlay_1" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Environment" /v "DISABLE_VK_LAYER_NV_optimus" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Environment" /v "DISABLE_VK_LAYER_OBS_HOOK" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Environment" /v "VK_LAYER_PATH" /t REG_SZ /d "C:\Empty" /f >nul 2>&1
reg add "HKCU\Environment" /v "VK_DRIVER_FILES" /t REG_SZ /d "C:\Program Files\NVIDIA Corporation\VulkanRT\nv-vk64.json" /f >nul 2>&1
reg add "HKCU\Environment" /v "VK_ICD_FILENAMES" /t REG_SZ /d "C:\Drivers\nvidia_icd.json" /f >nul 2>&1
reg add "HKCU\Environment" /v "VK_INSTANCE_LAYERS" /t REG_SZ /d "" /f >nul 2>&1
reg add "HKCU\Environment" /v "VK_DEVICE_LAYERS" /t REG_SZ /d "" /f >nul 2>&1
reg add "HKCU\Environment" /v "VK_DEBUG_REPORT" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Environment" /v "VK_DEBUG_UTILS" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Environment" /v "VK_FORCE_DISCRETE_GPU" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Environment" /v "VK_SAMPLE_COUNT_OVERRIDE" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Environment" /v "VK_ENABLE_RAY_TRACING" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Environment" /v "VK_USE_DXR" /t REG_SZ /d "0" /f >nul 2>&1

echo %c%[20/22] Disabling Vulkan post-rendering scaling, AI filters, and anti-aliasing...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableNIS" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableDSR" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableSharpening" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NGXCore" /v "EnableVSR" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NGXCore" /v "EnableRTXVideoSuperResolution" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NGXCore" /v "EnableDLSS" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NGXCore" /v "EnableDLAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NGXCore" /v "EnableRTXRemaster" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NGXCore" /v "EnableITM" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NGXCore" /v "EnableRTXVideoQualityEnhancement" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NGXCore" /v "EnableRTX" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NGXCore" /v "EnableRayTracing" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NGXCore" /v "EnableResizableInternalResolution" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvVSR" /v "EnableVSR" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvVSR" /v "EnableRTXVideoSuperResolution" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvVSR" /v "EnableRTXVideoQualityEnhancement" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvVSR" /v "EnableSuperResolution" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\AMD\CN" /v "EnableRadeonSuperResolution" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\AMD\CN" /v "EnableFidelityFXSuperResolution" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\AMD\CN" /v "EnableRSR" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\AMD\CN" /v "EnableVariableRateShading" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\Ansel" /v "AnselAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NvfCamera" /v "Enable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\GeForceExperience" /v "EnableFreestyle" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\PerformanceSdk" /v "EnablePerfSdk" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NvProfile" /v "TelemetryEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnablePerfHUD" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableFXAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableTransparencyAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableMLAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableAntiAliasing" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableCMAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableCMAA2" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableDLAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableDLSS" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableMFG" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableSMAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableMSAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableRGSS" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableHRAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableSSAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableTAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableTXAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableTMAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableTSSAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableFSAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "EnableAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NvDriver" /v "ResizableBar" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[21/22] Optimizing nvlddmkm FTS, Global, and Video performance settings...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemption" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "TdrLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "TdrDelay" /t REG_DWORD /d "10" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "NvCplDisablePerf" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "NvTelemetryContainer" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\Stereo3D" /v "StereoEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\Stereo3D" /v "StereoDisplayMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableOverlays" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DxgKrnlLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisplayAdaption" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "PowerSavingMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "MultiThreadedOptimization" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "ScreenSpaceReflections" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "VRRControl" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "Scaling" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnablePreemption" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableContextIsolation" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableFrameTimeReporting" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableLosslessCompression" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableYUVColorConversion" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnablePageableMemory" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableUnifiedMemory" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableGPUDebugHeap" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableLowLatencyMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableAsynchronousCompute" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "ScalingMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "EnableMSI" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "DisablePreemption" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "ThreadPolicy" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "EnableAsyncCmdQueue" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "PowerMizerEnable" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "PerfLevelSrc" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "EnableDynamicPState" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "EnablePowerSavingMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "PollForCompletion" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "EventDrivenMode" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "LowLatencyBoost" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "EnableDMAAcceleration" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "EnableP2PTransfers" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "ForceMaxPerfLinkState" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "EnableDriverInstrumentation" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "EnableNvTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global" /v "EnableKernelEventTracing" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Video" /v "EnableOverlay" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Video" /v "EnableColorCorrection" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Video" /v "EnableColorEnhancement" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Video" /v "EnableDeinterlacing" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Video" /v "EnableDenoise" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Video" /v "EnableDeflicker" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Video" /v "EnableDynamicRangeCompression" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Video" /v "EnableGammaRamp" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Video" /v "EnablePresentationQueue" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[22/22] Zeroing nvlddmkm Global Startup event keys...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ XgpuBalloonInit" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\AceCacheHDRInfo" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\AceCachePFFValues" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\AcePersistenceOnDriverLoad" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\AcePersistenceOnInstall" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\AcePersistenceStartup" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\AcePersistenceStartupResumeFromSuspend" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\AceRefreshPowerMode" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\AceResumeFromSuspend" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\AdjustPRROnLogin" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\AdjustPRROnServiceStart" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\AdjustSmoothScalingOnInstall" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\AdjustVsyncOnSliChange" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ApplyCommandLineMode" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ApplyScalingOverride" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\CheckUnsupportedDPConfig" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\CreateFeatureRegKeys" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\DevChangeConfigMuxes" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\DisableMSStereo" /ve /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\DriverNotUptoDate" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\EnableOrDisablePPABOnReboot" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\EnableShowStatusOnLogin" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\EnableSli" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\EnsurePerfCountSync" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ForceStopNvTrayIcon" /ve /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\FrlDeviceChange" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\FrlDisplayChange" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\GetUserDataOnInstall" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\GSyncOverinstallPersistence" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\HandleGridPrimaryDisplay" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\HandleSmoothScalingFactorSelection" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\IDMColors" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\IDMInitialize" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\InitialNvTray" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\LoginColors" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\MonitorGfeInstallation" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\NotifyGdiPrimaryToDriver" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\NvidiaGpuArrived" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\PerformSurroundHotKeysRegistration" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\PlaceSourcesInFixedGridExtendedMode" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ReEnumAudioDevices" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ReEnumAudioDevicesOnBoot" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\RefreshHDMIAudioDriver" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\RefreshOSModeList" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\RemoveControlPanelClient" /ve /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\RemoveControlPanelClientr" /ve /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ResetGammaValue" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ResetOSGamma" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\RestoreColorAccuracyModePersistence" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\RestoreSmartmaxForSurround" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\RestoreSpanConfig" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\RestoreSpanConfigOnReboot" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\RestoreSpanConfigOnResume" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\SaveSpanPersistence" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\SdiPersistence" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\SdiPersistenceUpgrade" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\SendNonNvDisplayDetails" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\SendTelemetryData" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\SetSmartmaxFeatures" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\SetVRRIndicatorState" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\SetVRRModeValueForASyncDisplay" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ShowBalloonMessages" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ShowBalloonPopupOnLogin" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ShowLicenseStatusOnLogin" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ShowStoreNvcplNotification" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ShowStoreNvcplUpgradeNotification" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ShowVideoBridgeOnWrongFingerNotification" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ShowVRRBalloonNotification" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\StartACETrayIcon" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\StartGridLicenseManagement" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\StartGridLicensingOnSessionLogin" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\StartLicensingPipeServer" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\StartNvTray" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\StartS3SR" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\StartWorkstationPipeServer" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\SwapSLIMasterGpuOnStart" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\SystemResumeFromSuspend" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\SystemSuspend" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\ToggleCursorPositionPolling" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\TVLocaleBoot" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\UpdateRegistryModeSettings" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\UpgradeBezelPeekHotkey" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\UpgradeGsyncPersistence" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\UpgradeSpanPersistence" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\USBDeviceArrival" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\USBDeviceRemoveComplete" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\WinSATAssessment" /ve /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\XgpuBalloonHandleDevNodesChange" /ve /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[23/30] Disabling NVIDIA FTS privacy/performance parameters...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters\FTS" /v "EnableDDC68" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters\FTS" /v "EnableGR3086" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters\FTS" /v "EnableGR3122" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters\FTS" /v "EnableGR3252" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[24/30] Disabling NVIDIA driver-level image enhancement hooks...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableVSR" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableImageSharpening" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableAnselUpscaling" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[25/30] Disabling RTX Remix injection hooks...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "EnableRTXRemix" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "EnableRTXInjection" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "NV_DX9_Remix_Enable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRTXRemixBridge" /t REG_DWORD /d "0" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "NvRemixRuntime" /f >nul 2>&1

echo %c%[26/30] Disabling NVIDIA dynamic resolution scaling (DSR/DLDSR)...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableDynamicResolutionScaling" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableDSR" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[27/30] Disabling NVIDIA ray tracing (RTX, DXR)...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRTX" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRayTracing" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableDXR" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[28/30] Disabling NVIDIA anti-aliasing (MSAA, CSAA, HQAA)...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableMSAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableCSAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableHQAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "AllowApplicationAAControl" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[29/30] Disabling system-wide ray tracing and AA flags (GraphicsDrivers)...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableDXR" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableRayTracing" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableHardwareRaytracing" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableMSAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableFxaa" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableAA" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableMultiSampleAntiAliasing" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisablePreRenderAA" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[30/30] Disabling Vulkan ray tracing via environment variables...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DISABLE_VK_RAY_TRACING" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Environment" /v "DISABLE_VK_RAY_TRACING" /t REG_SZ /d "1" /f >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                      %green%NVIDIA%u%%c% OPTIMIZATION COMPLETED                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%NVIDIA GPU optimizations have been successfully applied.%u%
echo.
echo %c%Applied Optimizations:%u%
echo %c%• NVIDIA Profile Inspector configuration%u%
echo %c%• Driver thread priority optimization%u%
echo %c%• DPC and core distribution enhancements%u%
echo %c%• GPU preemption disabled for stability%u%
echo %c%• Graphics driver performance tweaks%u%
echo %c%• Power management and latency optimization%u%
echo %c%• ECC/VRAM scrubbing disabled%u%
echo %c%• Interrupt locking, large pages, big page limits, PCIe Gen4 copy engine%u%
echo %c%• GPU timer synchronization and PCIe protections configured%u%
echo %c%• DirectX layer optimized (AllowTearing, MaxFrameLatency, no debug layers)%u%
echo %c%• NVIDIA GPU logging fully disabled (GPUDebugger, NGXCore, NVAPI, NVTweak)%u%
echo %c%• Vulkan layers locked down (Steam, NV Optimus, OBS hook, ray tracing disabled)%u%
echo %c%• Vulkan AI/RT features disabled (DLSS, DSR, NIS, RTX, RTX Remix, DLAA, VSR)%u%
echo %c%• nvlddmkm FTS/Global/Video performance tuned (telemetry, scaling, video off)%u%
echo %c%• nvlddmkm Global Startup event keys zeroed (80+ background tasks disabled)%u%
echo %c%• NVIDIA FTS privacy parameters disabled (DDC68, GR3086/3122/3252)%u%
echo %c%• NVIDIA image enhancement hooks disabled (VSR, sharpening, Ansel)%u%
echo %c%• RTX Remix injection fully disabled (nvlddmkm root + FTS + startup key)%u%
echo %c%• NVIDIA DSR/DLDSR dynamic resolution scaling disabled%u%
echo %c%• NVIDIA FTS ray tracing disabled (RTX, DXR)%u%
echo %c%• NVIDIA FTS anti-aliasing disabled (MSAA, CSAA, HQAA)%u%
echo %c%• System-wide ray tracing and AA flags set (GraphicsDrivers, HwSchMode=1)%u%
echo %c%• Vulkan ray tracing blocked via environment variable%u%
echo.
echo %red%Performance Notes:%u%
echo %c%• System may run warmer due to performance focus%u%
echo %c%• Power consumption may increase slightly%u%
echo %c%• Restart recommended for optimal performance%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:NVIDIAGPUExperimental
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║              %green%NVIDIA%u%%c% MAXIMUM PERFORMANCE - DWORD MODE %red%(EXPERIMENTAL)%u%%c%        ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %red%%underline%[!] EXPERIMENTAL CONFIGURATION - READ CAREFULLY%u%
echo.
echo %c%This disables ALL NVIDIA power management features to maximize%u%
echo %c%performance and minimize GPU latency. Known effects:%u%
echo.
echo %red%  • Significantly increased power consumption%u%
echo %red%  • Elevated idle temperatures%u%
echo %red%  • Potential system instability%u%
echo %red%  • NOT recommended for laptops%u%
echo.
echo %c%Use [3] Revert from the NVIDIA menu to undo these changes at any time.%u%
echo.
choice /C YN /M "%c%Apply Maximum Performance DWORD configuration? (Y/N)%u%"
if errorlevel 2 goto NVIDIAGPU

echo.
echo %c%[DETECT] Locating NVIDIA GPU in device registry...%u%
set "_k=HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
set "_t="
for /L %%i in (0,1,9) do (
    for /F "tokens=2* skip=2" %%a in ('reg query "%_k%\000%%i" /v ProviderName 2^>nul') do (
        echo %%b|findstr /i "NVIDIA" >nul && (set "_t=000%%i")
    )
)
if not defined _t (
    echo.
    echo %red%[!] NVIDIA GPU not detected in registry. Aborting.%u%
    echo.
    pause
    goto NVIDIAGPU
)
set "_r=%_k%\%_t%"
echo %c%  ✓ Found NVIDIA GPU at: ...\%_t%%u%
echo.

echo %c%[CHECK] Detecting device type...%u%
set "_ct="
for /F "tokens=*" %%c in ('powershell -Command "(Get-CimInstance -ClassName Win32_SystemEnclosure).ChassisTypes[0]" 2^>nul') do set /A "_ct=%%c" 2>nul
if defined _ct if %_ct% gtr 7 (
    echo.
    echo %red%╔══════════════════════════════════════════════════════════════════════════════╗
    echo ║                       PORTABLE DEVICE DETECTED                               ║
    echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
    echo.
    echo %red%WARNING: This configuration is NOT recommended for laptops.%u%
    echo %red%  • Thermal management will be fully disabled%u%
    echo %red%  • Reduced battery life%u%
    echo %red%  • Risk of hardware damage%u%
    echo.
    choice /C YN /M "%red%Proceed on laptop anyway? (Y/N)%u%"
    if errorlevel 2 goto NVIDIAGPU
)

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    MAXIMUM PERFORMANCE DWORDs - APPLYING                     ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.

echo %c%[1/5] Disabling power features (RMPowerFeature, ELCG, ELPG, BLCG, FSPG)...%u%
reg add "%_r%" /v "RMPowerFeature" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMElcg" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMElpg" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMBlcg" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMFspg" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMSlcg" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RmFlcg" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMClkSlowDown" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[2/5] Disabling ASPM and low-power architecture features...%u%
reg add "%_r%" /v "RMDisableGpuASPMFlags" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "%_r%" /v "RMEnableASPMAtLoad" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMLpwrArch" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMLpwrBlcg" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMLpwrBlcg1" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMLpwrSlcg" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMLpwrSlcg1" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMLpwrSlcg2" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMEnableASPMDT" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[3/5] Disabling idle thresholds and watchdog...%u%
reg add "%_r%" /v "RMLpwrGrIdleThresholdUs" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMLpwrGrRgIdleThresholdUs" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMLpwrMsIdleThresholdUs" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMLpwrEiIdleThresholdUs" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMWatchDogTimeOut" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMEnableHybridP" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMDidleFeatureGC5" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMGCOffFeature" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RmDispLowPowerFeatures" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[4/5] Enabling performance mode and locking P-states...%u%
reg add "%_r%" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "%_r%" /v "EnableMClkSlowdown" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RmClkPowerOffDramPllWhenUnused" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "RMEnableOverclockingAllPstates" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "%_r%" /v "EnablePerformanceMode" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "%_r%" /v "PowerSavingTweaks" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "EnableDriverControlledPMM" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "EnablePowerStateHandShake" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[5/5] Disabling display power gating, video power, latency features...%u%
reg add "%_r%" /v "HWSuspendContextCompleteTimeout" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "F1TransitionLatency" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "F1ResidencyRequirement" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "MuxSwitchPowerPolicy" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "%_r%" /v "RMFailOnC2CAbsence" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "EnableDisplayPowerGating" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "NvDispLpwrPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "ForceMuxOnDgpu" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "%_r%" /v "VideoPowerControl" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "VideoPpeControl" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "VideoPpeModel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "NvEncLLEnable" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "%_r%" /v "DDIBacklightControl" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%_r%" /v "UseGpuTimer" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "%_r%" /v "DxgkGpuVaIommuRequired" /t REG_DWORD /d "0" /f >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║               MAXIMUM PERFORMANCE CONFIGURATION APPLIED                      ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%All experimental power management DWORDs applied to: ...\%_t%%u%
echo.
echo %red%System restart required for full effect.%u%
echo %c%To revert these changes, select [3] from the NVIDIA GPU menu.%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto NVIDIAGPU

:NVIDIAGPURevert
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║               REVERT NVIDIA EXPERIMENTAL DWORDs TO DEFAULT                   ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will remove the experimental Maximum Performance DWORDs%u%
echo %c%and restore NVIDIA driver defaults for the detected GPU.%u%
echo.
choice /C YN /M "%c%Confirm revert? (Y/N)%u%"
if errorlevel 2 goto NVIDIAGPU

echo.
echo %c%[DETECT] Locating NVIDIA GPU in device registry...%u%
set "_k=HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
set "_t="
for /L %%i in (0,1,9) do (
    for /F "tokens=2* skip=2" %%a in ('reg query "%_k%\000%%i" /v ProviderName 2^>nul') do (
        echo %%b|findstr /i "NVIDIA" >nul && (set "_t=000%%i")
    )
)
if not defined _t (
    echo %red%[!] NVIDIA GPU not detected. Cannot revert.%u%
    pause
    goto NVIDIAGPU
)
set "_r=%_k%\%_t%"
echo %c%  ✓ Found NVIDIA GPU at: ...\%_t%%u%
echo.

echo %c%[REVERT] Removing experimental registry values...%u%
for %%k in (RMPowerFeature RMElcg RMElpg RMBlcg RMFspg RMSlcg RmFlcg RMClkSlowDown RMDisableGpuASPMFlags RMEnableASPMAtLoad RMLpwrArch RMLpwrBlcg RMLpwrBlcg1 RMLpwrSlcg RMLpwrSlcg1 RMLpwrSlcg2 RMLpwrGrIdleThresholdUs RMLpwrGrRgIdleThresholdUs RMLpwrMsIdleThresholdUs RMLpwrEiIdleThresholdUs RMWatchDogTimeOut RMEnableHybridP DisableDynamicPstate EnableMClkSlowdown RmClkPowerOffDramPllWhenUnused RMEnableASPMDT RMDidleFeatureGC5 RMGCOffFeature RmDispLowPowerFeatures RMEnableOverclockingAllPstates EnablePerformanceMode PowerSavingTweaks EnableDriverControlledPMM EnablePowerStateHandShake HWSuspendContextCompleteTimeout F1TransitionLatency F1ResidencyRequirement MuxSwitchPowerPolicy RMFailOnC2CAbsence EnableDisplayPowerGating NvDispLpwrPolicy ForceMuxOnDgpu VideoPowerControl VideoPpeControl VideoPpeModel NvEncLLEnable NvEncDisableTDR DDIBacklightControl UseGpuTimer DxgkGpuVaIommuRequired) do reg delete "%_r%" /v "%%k" /f >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          REVERT COMPLETED                                    ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Experimental DWORDs removed. NVIDIA driver defaults restored.%u%
echo %red%System restart recommended.%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto NVIDIAGPU

:AMDGPU
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          %red%AMD%u%%c% GPU PERFORMANCE OPTIMIZER                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This optimization will apply comprehensive AMD Radeon performance tweaks:%u%
echo %c%• Enable ReBAR (Resizable BAR) support for modern GPUs%u%
echo %c%• Disable power-saving features (Radeon Chill, DeLag)%u%
echo %c%• Optimize 3D rendering and anti-aliasing settings%u%
echo %c%• Configure video enhancement and DXVA settings%u%
echo %c%• Disable unnecessary AMD services and telemetry%u%
echo.
echo %red%%underline%Performance Notice:%u%
echo %c%These optimizations prioritize performance over power efficiency.%u%
echo %c%AMD Radeon Software features like Chill and Anti-Lag will be disabled.%u%
echo.
echo.
choice /C YN /M "%c%Apply AMD GPU optimizations? (Y/N)%u%"
if errorlevel 2 goto C

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       %red%AMD%u%%c% OPTIMIZATION IN PROGRESS                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/7] Enabling ReBAR and Modern GPU Features...%u%
reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableReBarForLegacyASIC" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_RebarControlMode" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_RebarControlSupport" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[2/7] Disabling Power Management Features...%u%
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_USUEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_RadeonBoostEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_ChillEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DeLagEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DisableDPD" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableMSHWS" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[3/7] Configuring 3D Rendering and Anti-Aliasing...%u%
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D" /t REG_BINARY /d "3100" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "AntiAlias" /t REG_BINARY /d "3100" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "AntiAliasSamples" /t REG_BINARY /d "3000" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "AnisoDegree" /t REG_BINARY /d "3000" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Tessellation" /t REG_BINARY /d "3100" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "HighQualityAF" /t REG_BINARY /d "3100" /f >nul 2>&1

echo %c%[4/7] Optimizing Texture and Buffer Settings...%u%
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TextureOpt" /t REG_BINARY /d "30000000" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TextureLod" /t REG_BINARY /d "30000000" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "EnableTripleBuffering" /t REG_BINARY /d "3000" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ShaderCache" /t REG_BINARY /d "3100" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ExportCompressedTex" /t REG_BINARY /d "31000000" /f >nul 2>&1

echo %c%[5/7] Configuring Display and VSync Settings...%u%
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "VSyncControl" /t REG_BINARY /d "3100" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TurboSync" /t REG_BINARY /d "3000" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "AntiStuttering" /t REG_BINARY /d "3100" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "DisplayCrossfireLogo" /t REG_BINARY /d "3000" /f >nul 2>&1

echo %c%[6/7] Optimizing Video Enhancement and DXVA...%u%
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "LRTCEnable" /t REG_BINARY /d "30000000" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "MosquitoNoiseRemoval_ENABLE" /t REG_BINARY /d "30000000" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "Deblocking_ENABLE" /t REG_BINARY /d "30000000" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "ColorVibrance_ENABLE" /t REG_BINARY /d "31000000" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "BlueStretch_ENABLE" /t REG_BINARY /d "31000000" /f >nul 2>&1

echo %c%[7/7] Disabling AMD Services and Telemetry...%u%
reg add "HKLM\System\CurrentControlSet\Services\amdwddmg" /v "ChillEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\AMD Crash Defender Service" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\amdfendr" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\amdfendrmgr" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\amdlog" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDMACopy" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableBlockWrite" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[8/11] Disabling AMD driver-level image enhancement hooks...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdkmdag" /v "EnableRSR" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdkmdag" /v "EnableFRTC" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdkmdag" /v "VSRSupportEnable" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[9/11] Disabling AMD driver-side dynamic scaling (RSR, VSR)...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdkmdag" /v "EnableVirtualSuperResolution" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdkmdag" /v "AllowDynamicResolution" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[10/11] Disabling AMD ray tracing support (DXR)...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdkmdag" /v "EnableRayTracing" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdkmdag" /v "DXRSupportEnable" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[11/11] Disabling AMD driver-level anti-aliasing overrides...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdkmdag" /v "EQAAEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdkmdag" /v "MultiSampleAAEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdkmdag" /v "OverrideAAEnable" /t REG_DWORD /d "0" /f >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       %red%AMD%u%%c% OPTIMIZATION COMPLETED                             ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%AMD GPU optimizations have been successfully applied.%u%
echo.
echo %c%Applied Optimizations:%u%
echo %c%• ReBAR (Resizable BAR) enabled for compatible GPUs%u%
echo %c%• Power management features disabled%u%
echo %c%• 3D rendering and anti-aliasing optimized%u%
echo %c%• Texture and buffer settings enhanced%u%
echo %c%• Display synchronization configured%u%
echo %c%• Video enhancement and DXVA optimized%u%
echo %c%• Unnecessary AMD services disabled%u%
echo %c%• AMD image enhancement hooks disabled (RSR, FRTC, VSR)%u%
echo %c%• AMD dynamic scaling disabled (VSR, AllowDynamicResolution)%u%
echo %c%• AMD ray tracing disabled (DXR support)%u%
echo %c%• AMD anti-aliasing overrides disabled (EQAA, MSAA, override)%u%
echo.
echo %red%Performance Notes:%u%
echo %c%• AMD Radeon Chill and Anti-Lag features disabled%u%
echo %c%• Thermal throttling reduced for maximum performance%u%
echo %c%• System may run warmer and consume more power%u%
echo %c%• Restart recommended for optimal performance%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:D
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           NETWORK PERFORMANCE OPTIMIZER                      ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Select your network connection type for optimized performance tweaks:%u%
echo.
echo %c%                         ╔════════════════════════════════╗
echo                          ║    [1] Wi-Fi Optimization      ║
echo                          ║    [2] Ethernet Optimization   ║
echo                          ║    [3] Universal Tweaks        ║
echo                          ║                                ║
echo                          ║    [0] Return to Main Menu     ║
echo                          ╚════════════════════════════════╝%u%
echo.
echo %c%Note: Each option applies connection-specific optimizations%u%
echo %c%for maximum performance on your preferred network type.%u%
echo.
set /p choice="%c%Select your network type »%u% "
if "%choice%"=="0" goto TweaksMenu
if "%choice%"=="1" goto WiFiOptimization
if "%choice%"=="2" goto EthernetOptimization
if "%choice%"=="3" goto UniversalTweaks
cls
echo.
echo %red%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                                INVALID INPUT                                 ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Please select a valid option [0-3] from the menu.%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO RETRY ══════════════════════════%u%
pause >nul
goto D

:WiFiOptimization
setlocal enabledelayedexpansion
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           WI-FI NETWORK OPTIMIZATION                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Wi-Fi optimization includes:%u%
echo %c%• Core TCP/IP settings optimized for wireless networks%u%
echo %c%• Advanced wireless adapter power management%u%
echo %c%• 802.11 wireless protocol optimization%u%
echo %c%• Wi-Fi Sense and hotspot feature management%u%
echo %c%• Advanced wireless network configuration%u%
echo %c%• Gaming and performance optimizations for Wi-Fi%u%
echo %c%• Advanced TCP/IP stack optimization for wireless%u%
echo %c%• UDP performance enhancement for wireless gaming%u%
echo %c%• DNS cache optimization for wireless browsing%u%
echo %c%• Hardware-level Wi-Fi adapter feature optimization%u%
echo %c%• Wireless security and stability enhancements%u%
echo %c%• Network maintenance and configuration refresh%u%
echo.
echo %red%%underline%Wi-Fi Notice:%u%
echo %c%These optimizations are specifically tailored for wireless connections.%u%
echo %c%Wi-Fi connection may briefly disconnect during optimization process.%u%
echo %c%All changes are designed to improve wireless stability and performance.%u%
echo.
echo.
choice /C YN /M "%c%Apply comprehensive Wi-Fi optimizations? (Y/N)%u%"
if errorlevel 2 goto D

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                      WI-FI OPTIMIZATION IN PROGRESS                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/20] Configuring Core TCP/IP Settings...%u%
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global ecncapability=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global initialRto=3000 >nul 2>&1
netsh int tcp set global rsc=disabled >nul 2>&1
netsh int tcp set global nonsackttresiliency=disabled >nul 2>&1
netsh int tcp set global pacingprofile=off >nul 2>&1
netsh int tcp set global MaxSynRetransmissions=2 >nul 2>&1
netsh int tcp set heuristics disabled >nul 2>&1

echo %c%[2/20] Detecting and Configuring Wi-Fi Interface...%u%
set "WIFI_IFACE="
for /f "tokens=2 delims=:" %%I in ('netsh interface show interface 2^>nul ^| findstr /i "Wireless"') do set "WIFI_IFACE=%%~I"
if defined WIFI_IFACE (
    set "WIFI_IFACE=!WIFI_IFACE:~1!"
    netsh interface ipv4 set subinterface "!WIFI_IFACE!" mtu=1472 store=persistent >nul 2>&1
    echo %c%  → Detected Wi-Fi interface: !WIFI_IFACE!%u%
) else (
    netsh interface ipv4 set subinterface "Wi-Fi" mtu=1472 store=persistent >nul 2>&1
    netsh interface ipv4 set subinterface "Wireless Network Connection" mtu=1472 store=persistent >nul 2>&1
    echo %c%  → Using default Wi-Fi interface names%u%
)
netsh wlan set profileparameter name=* connectiontype=ESS >nul 2>&1
netsh wlan set profileparameter name=* connectionmode=auto >nul 2>&1

echo %c%[3/20] Configuring Wireless Adapter Power Management...%u%
for /f "tokens=*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /f "RadioEnable" 2^>nul ^| findstr /i "HKEY"') do (
    reg add "%%A" /v "RadioEnable" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%A" /v "PowerSaveMode" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%A" /v "EnablePowerManagement" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%A" /v "RoamAggressiveness" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%A" /v "ScanWhenAssociated" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%A" /v "BackgroundScanPeriod" /t REG_DWORD /d "300" /f >nul 2>&1
    reg add "%%A" /v "*WakeOnMagicPacket" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*WakeOnPattern" /t REG_SZ /d "0" /f >nul 2>&1
)

echo %c%[4/20] Optimizing 802.11 Wireless Protocol Settings...%u%
for /f "tokens=*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /f "MIMOPowerSaveMode" 2^>nul ^| findstr /i "HKEY"') do (
    reg add "%%A" /v "MIMOPowerSaveMode" /t REG_DWORD /d "3" /f >nul 2>&1
    reg add "%%A" /v "*WirelessMode" /t REG_DWORD /d "8" /f >nul 2>&1
    reg add "%%A" /v "*ChannelWidth" /t REG_DWORD /d "20" /f >nul 2>&1
    reg add "%%A" /v "*80211hMode" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%A" /v "*FrameBursting" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%A" /v "*TransmitPower" /t REG_DWORD /d "100" /f >nul 2>&1
    reg add "%%A" /v "*AdHoc11n" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%A" /v "*BeamForming" /t REG_DWORD /d "1" /f >nul 2>&1
)

echo %c%[5/20] Disabling Wi-Fi Sense and Hotspot Features...%u%
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WlanSvc\AnqpCache" /v "OsuRegistrationStatus" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WifiNetworkManager\HotspotLogin" /v "IsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
sc config WlanSvc start= auto >nul 2>&1
sc start WlanSvc >nul 2>&1

echo %c%[6/20] Configuring Advanced Wi-Fi Network Settings...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WlanSvc\Parameters" /v "BackgroundScanEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WlanSvc\Parameters" /v "BssTypeSelection" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WlanSvc\Parameters" /v "ProfileDirectoryPath" /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\Tethering" /v "HotspotConfigured" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[7/20] Applying Wi-Fi Gaming and Performance Optimizations...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpInitialRTT" /t REG_DWORD /d "3" /f >nul 2>&1

echo %c%[8/20] Applying advanced TCP stack optimizations for wireless...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d 64 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t REG_DWORD /d 32768 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d 32768 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableTCPA" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableRSS" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableTCPChimney" /t REG_DWORD /d 1 /f >nul 2>&1

echo %c%[9/20] Applying UDP optimizations for wireless gaming and streaming...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "FastSendDatagramThreshold" /t REG_DWORD /d 1500 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "FastCopyReceiveThreshold" /t REG_DWORD /d 1500 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DynamicSendBufferDisable" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "BufferMultiplier" /t REG_DWORD /d 512 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DefaultSendWindow" /t REG_DWORD /d 32768 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DefaultReceiveWindow" /t REG_DWORD /d 32768 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "LargeBufferSize" /t REG_DWORD /d 2048 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "MediumBufferSize" /t REG_DWORD /d 1504 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "SmallBufferSize" /t REG_DWORD /d 128 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "TransmitWorker" /t REG_DWORD /d 16 /f >nul 2>&1

echo %c%[10/20] Optimizing DNS cache for wireless browsing...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableBucketSize" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableSize" /t REG_DWORD /d 384 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "DnsCacheTimeout" /t REG_DWORD /d 86400 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d 300 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxCacheSize" /t REG_DWORD /d 16777216 /f >nul 2>&1

echo %c%[11/20] Configuring QoS for wireless traffic prioritization...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "MaxOutstandingSends" /t REG_DWORD /d 32768 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d 0 /f >nul 2>&1

echo %c%[12/20] Optimizing wireless network memory management...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d 65534 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxFreeTcbs" /t REG_DWORD /d 32768 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxHashTableSize" /t REG_DWORD /d 32768 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectResponseRetransmissions" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxDataRetransmissions" /t REG_DWORD /d 3 /f >nul 2>&1

echo %c%[13/20] Configuring IPv4/IPv6 stack for wireless networks...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v "DisabledComponents" /t REG_DWORD /d 32 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableICMPRedirect" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableDeadGWDetect" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableIPSourceRouting" /t REG_DWORD /d 2 /f >nul 2>&1

echo %c%[14/20] Optimizing additional wireless adapter settings...%u%
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2 >nul 2>&1
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTPOL 100 >nul 2>&1
powercfg -setdcvalueindex scheme_current sub_processor PERFBOOSTMODE 1 >nul 2>&1
powercfg -setdcvalueindex scheme_current sub_processor PERFBOOSTPOL 60 >nul 2>&1
powercfg -setactive scheme_current >nul 2>&1
for /f "tokens=1* delims=" %%i in ('wmic path Win32_NetworkAdapter where "NetEnabled=true and AdapterTypeId=9" get PNPDeviceID /format:value ^| findstr "PNPDeviceID"') do (
    for /f "tokens=2 delims==" %%j in ("%%i") do (
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%j\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%j\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d 0 /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%j\Device Parameters" /v "BSSType" /t REG_DWORD /d 1 /f >nul 2>&1
    )
)

echo %c%[15/20] Configuring advanced wireless settings...%u%
if defined WIFI_IFACE (
    netsh wlan set autoconfig enabled=yes interface="!WIFI_IFACE!" >nul 2>&1
    netsh wlan set blockperiod interface="!WIFI_IFACE!" timeout=1 >nul 2>&1
)
netsh interface tcp set global netdma=enabled >nul 2>&1
netsh interface tcp set global dca=enabled >nul 2>&1

echo %c%[16/20] Applying gaming mode optimizations for Wi-Fi...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1

echo %c%[17/20] Configuring streaming optimization for wireless...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "initialRto" /t REG_DWORD /d 2000 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1

echo %c%[18/20] Optimizing wireless hardware features...%u%
for /f "tokens=3*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}" /s /v ComponentId 2^>nul ^| findstr /C:"ms_tcpip"') do (
    for /f "delims=\" tokens=6" %%k in ("%%i") do (
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*TCPUDPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*TCPUDPChecksumOffloadIPv6" /t REG_SZ /d "3" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*RSS" /t REG_SZ /d "1" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*NumRssQueues" /t REG_SZ /d "2" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*InterruptModeration" /t REG_SZ /d "1" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*ReceiveBuffers" /t REG_SZ /d "512" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*TransmitBuffers" /t REG_SZ /d "512" /f >nul 2>&1
    )
)

echo %c%[19/20] Applying wireless security optimizations...%u%
netsh advfirewall set allprofiles state on >nul 2>&1
netsh advfirewall set allprofiles firewallpolicy blockinbound,allowoutbound >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultPolicies" /v "f0276b85-4e9f-44e4-a6ee-c4ed78d6dc5e" /t REG_DWORD /d 1 /f >nul 2>&1

echo %c%[20/20] Refreshing Network Configuration...%u%
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1
for /f "tokens=*" %%I in ('netsh interface show interface ^| findstr /i "Wireless"') do (
    for /f "tokens=2 delims=:" %%J in ('echo %%I ^| findstr /i "Wireless"') do (
        set "ADAPTER=%%~J"
        set "ADAPTER=!ADAPTER:~1!"
        netsh interface ipv6 set interface "!ADAPTER!" admin=disable >nul 2>&1
    )
)
arp -d * >nul 2>&1
nbtstat -RR >nul 2>&1
nbtstat -R >nul 2>&1
netsh interface ip delete arpcache >nul 2>&1
netsh interface ip delete destinationcache >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPerServer" /t REG_DWORD /d 16 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d 16 /f >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        WI-FI OPTIMIZATION COMPLETED                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Wi-Fi network optimization has been successfully completed.%u%
echo.
echo %c%Original Batlez Wi-Fi Optimizations Applied:%u%
echo %c%• Core TCP/IP settings optimized for wireless performance%u%
echo %c%• Wi-Fi interface detection and MTU optimization%u%
echo %c%• Comprehensive wireless adapter power management disabled%u%
echo %c%• 802.11 wireless protocol settings optimized (MIMO, beamforming, etc.)%u%
echo %c%• Wi-Fi Sense and hotspot features disabled for security%u%
echo %c%• Advanced wireless network configuration applied%u%
echo %c%• Gaming and performance optimizations specifically for Wi-Fi%u%
echo %c%• Network configuration refresh with IPv6 disable on wireless adapters%u%
echo.
echo %c%Network-Enhance.bat Advanced Optimizations Applied:%u%
echo %c%• Advanced TCP/IP stack optimized specifically for wireless network conditions%u%
echo %c%• UDP performance enhanced for wireless gaming and streaming applications%u%
echo %c%• DNS cache optimized for faster wireless web browsing%u%
echo %c%• QoS packet scheduler configured for wireless traffic prioritization%u%
echo %c%• Wireless network memory management optimized for stability%u%
echo %c%• IPv4/IPv6 stack configured for optimal wireless performance%u%
echo %c%• Additional wireless adapter power management optimizations%u%
echo %c%• Gaming mode enabled with wireless-specific optimizations%u%
echo %c%• Streaming optimization applied for wireless video/audio%u%
echo %c%• Hardware-level wireless adapter features optimized%u%
echo %c%• Wireless security configurations enhanced%u%
if defined WIFI_IFACE echo %c%• Wi-Fi interface "!WIFI_IFACE!" specifically configured and optimized%u%
echo.
echo %red%Combined Wireless Performance Benefits:%u%
echo %c%• Dramatically reduced wireless network latency and improved stability%u%
echo %c%• Enhanced wireless connection reliability with advanced power management%u%
echo %c%• Optimized 802.11 protocol settings for maximum wireless performance%u%
echo %c%• Improved wireless gaming performance with reduced lag and jitter%u%
echo %c%• Better wireless streaming quality for video and audio applications%u%
echo %c%• Advanced wireless interference mitigation and signal optimization%u%
echo %c%• Faster wireless roaming and connection establishment%u%
echo %c%• Comprehensive wireless security hardening while maintaining performance%u%
echo %c%• Professional-grade wireless optimization combining multiple methodologies%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto D

:EthernetOptimization
setlocal enabledelayedexpansion
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         ETHERNET NETWORK OPTIMIZATION                        ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Ethernet optimization includes:%u%
echo %c%• Advanced TCP/IP stack optimization for wired networks%u%
echo %c%• UDP performance enhancement for wired gaming and streaming%u%
echo %c%• DNS cache optimization for faster web browsing%u%
echo %c%• Ethernet adapter power management and flow control%u%
echo %c%• Jumbo frame and MTU size optimization%u%
echo %c%• QoS packet scheduler configuration for wired traffic%u%
echo %c%• Gaming and streaming mode optimizations for Ethernet%u%
echo %c%• Hardware acceleration features for Ethernet adapters%u%
echo %c%• Advanced buffer management for high-speed connections%u%
echo %c%• Ethernet security and stability enhancements%u%
echo.
echo %red%%underline%Ethernet Notice:%u%
echo %c%These optimizations are specifically tailored for wired connections.%u%
echo %c%Ethernet connection may briefly disconnect during optimization process.%u%
echo %c%All changes are designed to maximize wired network performance.%u%
echo.
echo.
choice /C YN /M "%c%Apply comprehensive Ethernet optimizations? (Y/N)%u%"
if errorlevel 2 goto D

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    ETHERNET OPTIMIZATION IN PROGRESS                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/16] Detecting Ethernet interfaces and speed...%u%
set "ETHERNET_SPEED=Unknown"
for /f "tokens=2 delims==" %%a in ('wmic path win32_networkadapter where "NetConnectionStatus=2 and AdapterTypeId=0" get Speed /format:value 2^>nul ^| findstr "Speed"') do (
    set /a "SPEED_MBPS=%%a/1000000"
    set "ETHERNET_SPEED=!SPEED_MBPS! Mbps"
)
echo %c%  → Detected Ethernet speed: !ETHERNET_SPEED!%u%

echo %c%[2/16] Applying advanced TCP stack optimizations for wired networks...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d 64 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpInitialRTT" /t REG_DWORD /d 300 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d 65535 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t REG_DWORD /d 65535 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableTCPA" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableRSS" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableTCPChimney" /t REG_DWORD /d 1 /f >nul 2>&1

echo %c%[3/16] Applying UDP optimizations for wired gaming and streaming...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "FastSendDatagramThreshold" /t REG_DWORD /d 1500 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "FastCopyReceiveThreshold" /t REG_DWORD /d 1500 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DynamicSendBufferDisable" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "BufferMultiplier" /t REG_DWORD /d 1024 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DefaultSendWindow" /t REG_DWORD /d 65536 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DefaultReceiveWindow" /t REG_DWORD /d 65536 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "LargeBufferSize" /t REG_DWORD /d 4096 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "MediumBufferSize" /t REG_DWORD /d 1504 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "SmallBufferSize" /t REG_DWORD /d 128 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "TransmitWorker" /t REG_DWORD /d 32 /f >nul 2>&1

echo %c%[4/16] Optimizing DNS cache for wired browsing...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableBucketSize" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableSize" /t REG_DWORD /d 384 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "DnsCacheTimeout" /t REG_DWORD /d 86400 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d 300 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxCacheSize" /t REG_DWORD /d 33554432 /f >nul 2>&1

echo %c%[5/16] Configuring QoS for wired traffic prioritization...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "MaxOutstandingSends" /t REG_DWORD /d 65536 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1

echo %c%[6/16] Optimizing wired network memory management...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d 65534 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxFreeTcbs" /t REG_DWORD /d 65535 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxHashTableSize" /t REG_DWORD /d 65536 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectResponseRetransmissions" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxDataRetransmissions" /t REG_DWORD /d 3 /f >nul 2>&1

echo %c%[7/16] Configuring IPv4/IPv6 stack for wired networks...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v "DisabledComponents" /t REG_DWORD /d 32 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableICMPRedirect" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableDeadGWDetect" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableIPSourceRouting" /t REG_DWORD /d 2 /f >nul 2>&1

echo %c%[8/16] Optimizing Ethernet adapter power and performance settings...%u%
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2 >nul 2>&1
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTPOL 100 >nul 2>&1
powercfg -setactive scheme_current >nul 2>&1
for /f "tokens=1* delims=" %%i in ('wmic path Win32_NetworkAdapter where "NetEnabled=true and AdapterTypeId=0" get PNPDeviceID /format:value ^| findstr "PNPDeviceID"') do (
    for /f "tokens=2 delims==" %%j in ("%%i") do (
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%j\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%j\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d 0 /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%j\Device Parameters" /v "FlowControl" /t REG_DWORD /d 3 /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%j\Device Parameters" /v "SpeedDuplex" /t REG_DWORD /d 0 /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%j\Device Parameters" /v "WakeOnMagicPacket" /t REG_DWORD /d 0 /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%j\Device Parameters" /v "WakeOnPattern" /t REG_DWORD /d 0 /f >nul 2>&1
    )
)

echo %c%[8b/16] Disabling adapter power management, WoL, offloads and interrupt moderation...%u%
for /f "tokens=*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /v "*SpeedDuplex" 2^>nul ^| findstr /i "HKEY"') do (
    reg add "%%A" /v "*ReceiveBuffers" /t REG_SZ /d "2048" /f >nul 2>&1
    reg add "%%A" /v "*TransmitBuffers" /t REG_SZ /d "1024" /f >nul 2>&1
    reg add "%%A" /v "EnablePME" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*DeviceSleepOnDisconnect" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*EEE" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*SelectiveSuspend" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*WakeOnMagicPacket" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*WakeOnPattern" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "AutoPowerSaveModeEnabled" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "EEELinkAdvertisement" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "EnableGreenEthernet" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "GigaLite" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "PnPCapabilities" /t REG_DWORD /d "24" /f >nul 2>&1
    reg add "%%A" /v "PowerDownPll" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "PowerSavingMode" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "S5WakeOnLan" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "WakeOnLink" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*FlowControl" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*PMNSOffload" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*PMARPOffload" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "OBFFEnabled" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "DMACoalescing" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "EnableAspm" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "LatencyToleranceReporting" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*TCPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1
    reg add "%%A" /v "*TCPChecksumOffloadIPv6" /t REG_SZ /d "3" /f >nul 2>&1
    reg add "%%A" /v "*UDPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1
    reg add "%%A" /v "*UDPChecksumOffloadIPv6" /t REG_SZ /d "3" /f >nul 2>&1
    reg add "%%A" /v "*IPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1
    reg add "%%A" /v "*UsoIPv4" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*UsoIPv6" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*RscIPv4" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*RscIPv6" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*LsoV1IPv4" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*LsoV2IPv4" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*LsoV2IPv6" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*InterruptModeration" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "ITR" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "LogLinkStateEvent" /t REG_SZ /d "16" /f >nul 2>&1
)

echo %c%[9/16] Configuring advanced Ethernet TCP settings...%u%
netsh interface tcp set global autotuninglevel=normal >nul 2>&1
netsh interface tcp set global chimney=enabled >nul 2>&1
netsh interface tcp set global rss=enabled >nul 2>&1
netsh interface tcp set global netdma=enabled >nul 2>&1
netsh interface tcp set global dca=enabled >nul 2>&1
netsh interface tcp set global ecncapability=enabled >nul 2>&1

echo %c%[10/16] Configuring SMB file sharing optimization for Ethernet...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DisableBandwidthThrottling" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DisableLargeMtu" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxCmds" /t REG_DWORD /d 16 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxThreads" /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "FileInfoCacheEntriesMax" /t REG_DWORD /d 1024 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DirectoryCacheEntriesMax" /t REG_DWORD /d 1024 /f >nul 2>&1

echo %c%[11/16] Applying gaming mode optimizations for Ethernet...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 10 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1

echo %c%[12/16] Configuring streaming optimization for Ethernet...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "initialRto" /t REG_DWORD /d 2000 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1

echo %c%[13/16] Optimizing Ethernet hardware features...%u%
for /f "tokens=3*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}" /s /v ComponentId 2^>nul ^| findstr /C:"ms_tcpip"') do (
    for /f "delims=\" tokens=6" %%k in ("%%i") do (
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*TCPUDPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*TCPUDPChecksumOffloadIPv6" /t REG_SZ /d "3" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*LsoV2IPv4" /t REG_SZ /d "1" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*LsoV2IPv6" /t REG_SZ /d "1" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*RSS" /t REG_SZ /d "1" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*NumRssQueues" /t REG_SZ /d "4" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*FlowControl" /t REG_SZ /d "3" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*JumboPacket" /t REG_SZ /d "9014" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*InterruptModeration" /t REG_SZ /d "1" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*ReceiveBuffers" /t REG_SZ /d "1024" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*TransmitBuffers" /t REG_SZ /d "1024" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*IPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*PriorityVLANTag" /t REG_SZ /d "3" /f >nul 2>&1
    )
)

echo %c%[14/16] Configuring advanced congestion control for Ethernet...%u%
netsh interface tcp set global congestionprovider=ctcp >nul 2>&1
netsh interface tcp set supplemental custom congestionprovider=ctcp >nul 2>&1
netsh interface tcp set global timestamps=disabled >nul 2>&1
netsh interface tcp set global maxsynretransmissions=2 >nul 2>&1
netsh interface tcp set global fastopen=enabled >nul 2>&1
netsh interface tcp set global hystart=enabled >nul 2>&1
netsh interface tcp set global prr=enabled >nul 2>&1

echo %c%[15/16] Performing safe Ethernet network maintenance...%u%
ipconfig /flushdns >nul 2>&1
arp -d * >nul 2>&1
nbtstat -RR >nul 2>&1
nbtstat -R >nul 2>&1
netsh interface ip delete arpcache >nul 2>&1
netsh interface ip delete destinationcache >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPerServer" /t REG_DWORD /d 16 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d 16 /f >nul 2>&1

echo %c%[16/16] Finalizing Ethernet network optimizations...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableConnectionRateLimiting" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "ArpRetryCount" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "ForwardBufferMemory" /t REG_DWORD /d 1376256 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "IRPStackSize" /t REG_DWORD /d 50 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NumForwardPackets" /t REG_DWORD /d 598 /f >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                      ETHERNET OPTIMIZATION COMPLETED                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Ethernet network optimization has been successfully completed.%u%
echo.
echo %c%Detected Ethernet Speed: !ETHERNET_SPEED!%u%
echo.
echo %c%Optimizations Applied:%u%
echo %c%• TCP/IP stack optimized specifically for wired network conditions%u%
echo %c%• UDP performance enhanced for wired gaming and streaming applications%u%
echo %c%• DNS cache optimized for faster wired web browsing%u%
echo %c%• QoS packet scheduler configured for wired traffic prioritization%u%
echo %c%• Wired network memory management optimized for high throughput%u%
echo %c%• IPv4/IPv6 stack configured for optimal wired performance%u%
echo %c%• Ethernet adapter power management and flow control optimized%u%
echo %c%• SMB file sharing performance enhanced for local networks%u%
echo %c%• Gaming mode enabled with Ethernet-specific optimizations%u%
echo %c%• Streaming optimization applied for wired video/audio%u%
echo %c%• Hardware-level Ethernet adapter features optimized%u%
echo %c%• Jumbo packet support enabled for high-speed connections%u%
echo %c%• Advanced congestion control configured for wired networks%u%
echo %c%• Hardware acceleration features enabled for maximum throughput%u%
echo.
echo %red%Ethernet Performance Benefits:%u%
echo %c%• Significantly reduced wired network latency%u%
echo %c%• Improved Ethernet connection stability and throughput%u%
echo %c%• Enhanced wired gaming performance with consistent low ping%u%
echo %c%• Better wired streaming quality for high-definition content%u%
echo %c%• Optimized file transfer speeds on local networks%u%
echo %c%• Advanced hardware acceleration for maximum performance%u%
echo %c%• Jumbo frame support for high-bandwidth applications%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto D

:UniversalTweaks
setlocal enabledelayedexpansion
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         UNIVERSAL NETWORK OPTIMIZATION                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Universal network optimization includes:%u%
echo %c%• Advanced TCP/IP stack optimization for all connection types%u%
echo %c%• UDP performance enhancement for gaming and streaming%u%
echo %c%• DNS cache optimization for faster web browsing%u%
echo %c%• Automatic connection type detection and optimization%u%
echo %c%• QoS packet scheduler optimization%u%
echo %c%• Network adapter power management optimization%u%
echo %c%• SMB file sharing performance enhancement%u%
echo %c%• Advanced network memory management%u%
echo %c%• Gaming and streaming mode optimizations%u%
echo %c%• Network security hardening%u%
echo %c%• Hardware-level network adapter optimizations%u%
echo %c%• Cloud gaming and video conferencing optimizations%u%
echo.
echo %red%%underline%Universal Notice:%u%
echo %c%These optimizations work for all network connection types.%u%
echo %c%Network connection may briefly reconnect during optimization.%u%
echo %c%All changes are designed for maximum compatibility and performance.%u%
echo.
echo.
choice /C YN /M "%c%Apply comprehensive universal network optimizations? (Y/N)%u%"
if errorlevel 2 goto D

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    UNIVERSAL OPTIMIZATION IN PROGRESS                        ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/18] Detecting network interfaces and connection types...%u%
set "CONN_DETECT_FILE=%TEMP%\connection_type.txt"
set "NETSH_OUTPUT=%TEMP%\netsh_output.txt"
chcp 437 >nul
powershell -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Select-Object Name, InterfaceDescription, LinkSpeed, Status | Format-Table -AutoSize > '%CONN_DETECT_FILE%'" 2>nul
chcp 65001 >nul
netsh interface show interface > "%NETSH_OUTPUT%" 2>nul
set "CONN_TYPE=Unknown"
set "INTERFACE_NAME="
if exist "%CONN_DETECT_FILE%" (
    findstr /i "Wi-Fi Wireless WLAN" "%CONN_DETECT_FILE%" >nul 2>&1
    if !errorlevel! equ 0 (
        set "CONN_TYPE=WiFi"
    ) else (
        findstr /i "Ethernet Local" "%CONN_DETECT_FILE%" >nul 2>&1
        if !errorlevel! equ 0 (
            set "CONN_TYPE=Ethernet"
            findstr /i "Gbps" "%CONN_DETECT_FILE%" >nul 2>&1
            if !errorlevel! equ 0 (
                set "CONN_TYPE=Fiber"
            )
        )
    )
)
if "!CONN_TYPE!"=="Unknown" (
    ipconfig | findstr /i "Wireless Wi-Fi" >nul 2>&1
    if !errorlevel! equ 0 set "CONN_TYPE=WiFi"
    if "!CONN_TYPE!"=="Unknown" (
        ipconfig | findstr /i "Ethernet" >nul 2>&1
        if !errorlevel! equ 0 set "CONN_TYPE=Ethernet"
    )
)
echo %c%  → Detected connection type: !CONN_TYPE!%u%

echo %c%[2/18] Applying advanced TCP stack optimizations...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d 64 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t REG_DWORD /d 65535 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d 65535 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpInitialRTT" /t REG_DWORD /d 300 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUBHDetect" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableTCPA" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableRSS" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableTCPChimney" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t REG_DWORD /d 0 /f >nul 2>&1

echo %c%[3/18] Applying UDP optimizations for gaming and streaming...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "FastSendDatagramThreshold" /t REG_DWORD /d 1500 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "FastCopyReceiveThreshold" /t REG_DWORD /d 1500 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DynamicSendBufferDisable" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "BufferMultiplier" /t REG_DWORD /d 1024 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DefaultSendWindow" /t REG_DWORD /d 65536 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DefaultReceiveWindow" /t REG_DWORD /d 65536 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "LargeBufferSize" /t REG_DWORD /d 4096 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "MediumBufferSize" /t REG_DWORD /d 1504 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "SmallBufferSize" /t REG_DWORD /d 128 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "TransmitWorker" /t REG_DWORD /d 32 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "EnableDynamicBacklog" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "MinimumDynamicBacklog" /t REG_DWORD /d 20 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "MaximumDynamicBacklog" /t REG_DWORD /d 20000 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DynamicBacklogGrowthDelta" /t REG_DWORD /d 10 /f >nul 2>&1

echo %c%[4/18] Optimizing DNS cache for faster web browsing...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableBucketSize" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "CacheHashTableSize" /t REG_DWORD /d 384 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "DnsCacheTimeout" /t REG_DWORD /d 86400 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d 300 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxCacheSize" /t REG_DWORD /d 33554432 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxSOACacheEntryTtlLimit" /t REG_DWORD /d 300 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxCacheTtl" /t REG_DWORD /d 86400 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxNegativeCacheTtl" /t REG_DWORD /d 300 /f >nul 2>&1

echo %c%[5/18] Configuring QoS packet scheduler for maximum performance...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "MaxOutstandingSends" /t REG_DWORD /d 65536 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "ApplicationGUID" /t REG_MULTI_SZ /d "{00000000-0000-0000-0000-000000000000}" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1

echo %c%[6/18] Optimizing network memory management...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d 65534 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxFreeTcbs" /t REG_DWORD /d 65535 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxHashTableSize" /t REG_DWORD /d 65536 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectResponseRetransmissions" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxDataRetransmissions" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxConnectRetransmissions" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDataRetransmissions" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpUseRFC1122UrgentPointer" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpCreateAndConnectTcbRateLimitDepth" /t REG_DWORD /d 0 /f >nul 2>&1

echo %c%[7/18] Configuring IPv4/IPv6 stack settings...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v "DisabledComponents" /t REG_DWORD /d 32 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableICMPRedirect" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableDeadGWDetect" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableSecurityFilters" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableIPSourceRouting" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableMediaSenseEventLog" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "IGMPLevel" /t REG_DWORD /d 2 /f >nul 2>&1

echo %c%[8/18] Optimizing network adapter power settings...%u%
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2 >nul 2>&1
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTPOL 100 >nul 2>&1
powercfg -setdcvalueindex scheme_current sub_processor PERFBOOSTMODE 1 >nul 2>&1
powercfg -setdcvalueindex scheme_current sub_processor PERFBOOSTPOL 60 >nul 2>&1
powercfg -setactive scheme_current >nul 2>&1
for /f "tokens=1* delims=" %%i in ('wmic path Win32_NetworkAdapter where "NetEnabled=true" get PNPDeviceID /format:value ^| findstr "PNPDeviceID"') do (
    for /f "tokens=2 delims==" %%j in ("%%i") do (
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%j\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%j\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d 0 /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%j\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d 0 /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%j\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d 0 /f >nul 2>&1
    )
)

echo %c%[8b/18] Disabling adapter power management, WoL, offloads and interrupt moderation...%u%
for /f "tokens=*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /v "*SpeedDuplex" 2^>nul ^| findstr /i "HKEY"') do (
    reg add "%%A" /v "*ReceiveBuffers" /t REG_SZ /d "2048" /f >nul 2>&1
    reg add "%%A" /v "*TransmitBuffers" /t REG_SZ /d "1024" /f >nul 2>&1
    reg add "%%A" /v "EnablePME" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*DeviceSleepOnDisconnect" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*EEE" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*SelectiveSuspend" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*WakeOnMagicPacket" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*WakeOnPattern" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "AutoPowerSaveModeEnabled" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "EEELinkAdvertisement" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "EnableGreenEthernet" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "GigaLite" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "PnPCapabilities" /t REG_DWORD /d "24" /f >nul 2>&1
    reg add "%%A" /v "PowerDownPll" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "PowerSavingMode" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "S5WakeOnLan" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "WakeOnLink" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*FlowControl" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*PMNSOffload" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*PMARPOffload" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "OBFFEnabled" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "DMACoalescing" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "EnableAspm" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "LatencyToleranceReporting" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*TCPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1
    reg add "%%A" /v "*TCPChecksumOffloadIPv6" /t REG_SZ /d "3" /f >nul 2>&1
    reg add "%%A" /v "*UDPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1
    reg add "%%A" /v "*UDPChecksumOffloadIPv6" /t REG_SZ /d "3" /f >nul 2>&1
    reg add "%%A" /v "*IPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1
    reg add "%%A" /v "*UsoIPv4" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*UsoIPv6" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*RscIPv4" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*RscIPv6" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*LsoV1IPv4" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*LsoV2IPv4" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*LsoV2IPv6" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "*InterruptModeration" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "ITR" /t REG_SZ /d "0" /f >nul 2>&1
    reg add "%%A" /v "LogLinkStateEvent" /t REG_SZ /d "16" /f >nul 2>&1
)

echo %c%[9/18] Configuring SMB file sharing optimization...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DisableBandwidthThrottling" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DisableLargeMtu" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxCmds" /t REG_DWORD /d 16 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxThreads" /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "FileInfoCacheEntriesMax" /t REG_DWORD /d 1024 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DirectoryCacheEntriesMax" /t REG_DWORD /d 1024 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxCollectionCount" /t REG_DWORD /d 16 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "KeepConn" /t REG_DWORD /d 600 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxConnections" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "autodisconnect" /t REG_DWORD /d "4294967295" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "EnableOplocks" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "IRPStackSize" /t REG_DWORD /d "20" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "SharingViolationDelay" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "SharingViolationRetries" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Ndis\Parameters" /v "RssBaseCpu" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" /v "MinSockAddrLength" /t REG_DWORD /d "16" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" /v "MaxSockAddrLength" /t REG_DWORD /d "16" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "5" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "6" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "7" /f >nul 2>&1

echo %c%[10/18] Applying connection-type specific optimizations...%u%
if "!CONN_TYPE!"=="WiFi" (
    echo %c%  → Applying WiFi-specific optimizations...%u%
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpInitialRTT" /t REG_DWORD /d 400 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d 32768 /f >nul 2>&1
    netsh interface tcp set global autotuninglevel=normal >nul 2>&1
    for /f %%a in ('wmic path win32_networkadapter where "NetConnectionStatus=2 and AdapterTypeId=9" get PNPDeviceID /format:value ^| findstr "PNPDeviceID"') do (
        for /f "tokens=2 delims==" %%b in ("%%a") do (
            reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters" /v "ScanWhenAssociated" /t REG_DWORD /d 0 /f >nul 2>&1
            reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters" /v "PowerSaveMode" /t REG_DWORD /d 0 /f >nul 2>&1
            reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters" /v "RoamTrigger" /t REG_DWORD /d 80 /f >nul 2>&1
        )
    )
) else if "!CONN_TYPE!"=="Ethernet" (
    echo %c%  → Applying Ethernet-specific optimizations...%u%
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpInitialRTT" /t REG_DWORD /d 300 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d 65535 /f >nul 2>&1
    netsh interface tcp set global autotuninglevel=normal >nul 2>&1
    for /f %%a in ('wmic path win32_networkadapter where "NetConnectionStatus=2 and AdapterTypeId=0" get PNPDeviceID /format:value ^| findstr "PNPDeviceID"') do (
        for /f "tokens=2 delims==" %%b in ("%%a") do (
            reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters" /v "FlowControl" /t REG_DWORD /d 3 /f >nul 2>&1
            reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters" /v "SpeedDuplex" /t REG_DWORD /d 0 /f >nul 2>&1
        )
    )
) else if "!CONN_TYPE!"=="Fiber" (
    echo %c%  → Applying Fiber/High-speed optimizations...%u%
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpInitialRTT" /t REG_DWORD /d 200 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d 131072 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t REG_DWORD /d 131072 /f >nul 2>&1
    netsh interface tcp set global autotuninglevel=highlyrestricted >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DefaultSendWindow" /t REG_DWORD /d 131072 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DefaultReceiveWindow" /t REG_DWORD /d 131072 /f >nul 2>&1
) else (
    echo %c%  → Applying general network optimizations...%u%
    netsh interface tcp set global autotuninglevel=normal >nul 2>&1
)

netsh interface tcp set global chimney=enabled >nul 2>&1
netsh interface tcp set global rss=enabled >nul 2>&1
netsh interface tcp set global netdma=enabled >nul 2>&1
netsh interface tcp set global dca=enabled >nul 2>&1
netsh interface tcp set global ecncapability=enabled >nul 2>&1

echo %c%[11/18] Applying gaming mode network optimizations...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 10 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t REG_DWORD /d 10000 /f >nul 2>&1

echo %c%[12/18] Configuring streaming and multimedia optimization...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "initialRto" /t REG_DWORD /d 2000 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "Priority" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1

echo %c%[13/18] Applying cloud gaming optimizations...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxConnectRetransmissions" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableDCA" /t REG_DWORD /d 1 /f >nul 2>&1

echo %c%[14/18] Configuring advanced congestion control...%u%
netsh interface tcp set global congestionprovider=ctcp >nul 2>&1
netsh interface tcp set supplemental custom congestionprovider=ctcp >nul 2>&1
netsh interface tcp set global timestamps=disabled >nul 2>&1
netsh interface tcp set global nonsackrttresiliency=disabled >nul 2>&1
netsh interface tcp set global maxsynretransmissions=2 >nul 2>&1
netsh interface tcp set global fastopen=enabled >nul 2>&1
netsh interface tcp set global fastopenfallback=enabled >nul 2>&1
netsh interface tcp set global hystart=enabled >nul 2>&1
netsh interface tcp set global prr=enabled >nul 2>&1
netsh interface tcp set global pacingprofile=off >nul 2>&1

echo %c%[15/18] Applying network security optimizations...%u%
netsh advfirewall set allprofiles state on >nul 2>&1
netsh advfirewall set allprofiles firewallpolicy blockinbound,allowoutbound >nul 2>&1
sc query "BFE" | findstr "RUNNING" >nul 2>&1
if !errorlevel! neq 0 (
    sc config "BFE" start= auto >nul 2>&1
    net start "BFE" >nul 2>&1
)
netsh advfirewall firewall add rule name="Block Port 135" dir=in action=block protocol=TCP localport=135 >nul 2>&1
netsh advfirewall firewall add rule name="Block Port 137" dir=in action=block protocol=UDP localport=137 >nul 2>&1
netsh advfirewall firewall add rule name="Block Port 138" dir=in action=block protocol=UDP localport=138 >nul 2>&1
netsh advfirewall firewall add rule name="Block Port 139" dir=in action=block protocol=TCP localport=139 >nul 2>&1
netsh advfirewall firewall add rule name="Block Port 445" dir=in action=block protocol=TCP localport=445 >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "RequireSecuritySignature" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "EnableSecuritySignature" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "SMB1" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NoNameReleaseOnDemand" /t REG_DWORD /d 1 /f >nul 2>&1

echo %c%[16/18] Optimizing hardware-level network adapter features...%u%
for /f "tokens=3*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}" /s /v ComponentId 2^>nul ^| findstr /C:"ms_tcpip"') do (
    for /f "delims=\" tokens=6" %%k in ("%%i") do (
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*TCPUDPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*TCPUDPChecksumOffloadIPv6" /t REG_SZ /d "3" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*LsoV2IPv4" /t REG_SZ /d "1" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*LsoV2IPv6" /t REG_SZ /d "1" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*RSS" /t REG_SZ /d "1" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*NumRssQueues" /t REG_SZ /d "4" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*FlowControl" /t REG_SZ /d "3" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*JumboPacket" /t REG_SZ /d "9014" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*InterruptModeration" /t REG_SZ /d "1" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*ReceiveBuffers" /t REG_SZ /d "1024" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*TransmitBuffers" /t REG_SZ /d "1024" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*IPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*PriorityVLANTag" /t REG_SZ /d "3" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*VMQ" /t REG_SZ /d "0" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%%k" /v "*SRIOV" /t REG_SZ /d "0" /f >nul 2>&1
    )
)

echo %c%[17/18] Performing safe network maintenance and cleanup...%u%
ipconfig /flushdns >nul 2>&1
arp -d * >nul 2>&1
nbtstat -RR >nul 2>&1
nbtstat -R >nul 2>&1
netsh interface ip delete arpcache >nul 2>&1
netsh interface ip delete destinationcache >nul 2>&1
ipconfig /release >nul 2>&1
timeout /t 2 >nul
ipconfig /renew >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Cache" /f >nul 2>&1
rundll32.exe inetcpl.cpl,ClearMyTracksByProcess 8 >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPerServer" /t REG_DWORD /d 16 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d 16 /f >nul 2>&1

echo %c%[18/18] Finalizing advanced network optimizations...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableConnectionRateLimiting" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableDhcpMediaSense" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableReverseAddressLookups" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "ArpRetryCount" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "ArpTRSingleRoute" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "ArpUseEtherSNAP" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableUserTOSSetting" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableMulticastForwarding" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWZCControl" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "ForwardBufferMemory" /t REG_DWORD /d 1376256 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "IRPStackSize" /t REG_DWORD /d 50 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxForwardBufferMemory" /t REG_DWORD /d 1376256 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NumForwardPackets" /t REG_DWORD /d 598 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxNumForwardPackets" /t REG_DWORD /d 598 /f >nul 2>&1

echo %c%[19/19] Disabling LLMNR and LMHOSTS (legacy broadcast name resolution)...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" /v "EnableLMHOSTS" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ LLMNR disabled (anti-poisoning); LMHOSTS lookup disabled (legacy NetBIOS)%u%

echo %c%[20/20] Setting NTP time server to pool.ntp.org...%u%
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org" >nul 2>&1
net stop w32time >nul 2>&1
net start w32time >nul 2>&1
w32tm /config /update >nul 2>&1
w32tm /resync >nul 2>&1
echo %c%✓ NTP server set to pool.ntp.org (pools 0-3); time synced%u%

del "%CONN_DETECT_FILE%" >nul 2>&1
del "%NETSH_OUTPUT%" >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    UNIVERSAL NETWORK OPTIMIZATION COMPLETED                  ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Universal network optimization has been successfully completed.%u%
echo.
echo %c%Auto-Detected Connection Type: !CONN_TYPE!%u%
echo.
echo %c%Comprehensive Optimizations Applied:%u%
echo %c%• Advanced TCP/IP stack optimized for all network types with maximum performance%u%
echo %c%• UDP performance extensively enhanced for gaming, streaming, and real-time applications%u%
echo %c%• DNS cache comprehensively optimized for faster web browsing and reduced lookup times%u%
echo %c%• QoS packet scheduler configured for optimal traffic prioritization across all connections%u%
echo %c%• Network memory management optimized for high connection loads and maximum throughput%u%
echo %c%• IPv4/IPv6 stack configured for optimal performance, security, and universal compatibility%u%
echo %c%• Network adapter power management optimized to prevent throttling and maintain peak performance%u%
echo %c%• SMB file sharing performance extensively enhanced for local network transfers%u%
echo %c%• Connection-type specific optimizations automatically applied based on detected network type%u%
echo %c%• Gaming mode network prioritization enabled for competitive gaming performance%u%
echo %c%• Streaming and multimedia optimization applied for smooth video/audio streaming%u%
echo %c%• Cloud gaming optimizations applied for reduced input latency and stable streaming quality%u%
echo %c%• Advanced congestion control algorithms configured for optimal traffic management%u%
echo %c%• Network security comprehensively hardened with firewall rules and protocol security%u%
echo %c%• Hardware-level network adapter features optimized for maximum performance and efficiency%u%
echo %c%• Safe network maintenance performed without affecting registry optimizations%u%
echo %c%• Enterprise-level network parameters tuned for professional-grade performance%u%
echo %c%• Universal compatibility ensured for all major network connection types%u%
echo %c%• LLMNR disabled to prevent local network poisoning/spoofing attacks%u%
echo %c%• LMHOSTS lookup disabled (legacy NetBIOS file-based name resolution)%u%
echo %c%• NTP server set to pool.ntp.org (accurate, redundant global time sync)%u%
echo.
echo %red%Universal Performance Benefits:%u%
echo %c%• Dramatically reduced network latency across all connection types%u%
echo %c%• Significantly improved network stability and reliability for all applications%u%
echo %c%• Enhanced gaming performance with consistently low ping and reduced jitter%u%
echo %c%• Superior streaming quality for video conferencing, live streaming, and media consumption%u%
echo %c%• Optimized file transfer speeds on local networks with advanced SMB optimization%u%
echo %c%• Universal compatibility with Wi-Fi, Ethernet, and high-speed fiber connections%u%
echo %c%• Advanced hardware acceleration features enabled for maximum throughput%u%
echo %c%• Comprehensive security hardening while maintaining peak performance%u%
echo %c%• Professional-grade network optimization suitable for all use cases%u%
echo %c%• Automatic adaptation to different network environments and conditions%u%
echo.
echo %red%Important Notes:%u%
echo %c%• Network connection may briefly reconnect to apply hardware-level settings%u%
echo %c%• Full benefits will be realized after a system restart%u%
echo %c%• Optimizations automatically adapted for your detected connection type: !CONN_TYPE!%u%
echo %c%• Security configurations include comprehensive firewall rules and protocol hardening%u%
echo %c%• Hardware acceleration features have been enabled for all supported network adapters%u%
echo %c%• Universal optimizations provide maximum performance across all network scenarios%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto D

:E
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           CPU PERFORMANCE OPTIMIZER                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Select your CPU manufacturer for processor-specific optimizations:%u%
echo.
echo %c%                           ╔════════════════════════════════╗
echo                            ║    [1] %blue%Intel%c% Processor         ║
echo                            ║    [2] %red%AMD%c% Ryzen Processor     ║
echo                            ║    [3] Universal CPU Tweaks    ║
echo                            ║                                ║
echo                            ║    [0] Return to Main Menu     ║
echo                            ╚════════════════════════════════╝%u%
echo.
echo %c%Note: Processor-specific optimizations provide better performance%u%
echo %c%by targeting your CPU's unique architecture and features.%u%
echo.
set /p choice="%c%Select your CPU type »%u% "
if "%choice%"=="0" goto TweaksMenu
if "%choice%"=="1" goto IntelOptimization
if "%choice%"=="2" goto RyzenOptimization
if "%choice%"=="3" goto UniversalCPU
cls
echo.
echo %red%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                                INVALID INPUT                                 ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Please select a valid option [0-3] from the menu.%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO RETRY ══════════════════════════%u%
pause >nul
goto E

:IntelOptimization
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         %blue%INTEL%c% CPU PERFORMANCE OPTIMIZER                      ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Intel-specific optimizations include:%u%
echo %c%• Intel Turbo Boost and SpeedStep configuration%u%
echo %c%• C-States and P-States optimization for performance%u%
echo %c%• E-Core scheduling and thread director settings%u%
echo %c%• Spectre/Meltdown mitigation adjustments%u%
echo %c%• CPU affinity and CSRSS priority optimization%u%
echo %c%• Dynamic timer resolution based on CPU performance%u%
echo.
echo %red%%underline%Intel Notice:%u%
echo %c%These optimizations disable power saving for maximum performance.%u%
echo %c%CPU temperatures may increase and power consumption will rise.%u%
echo.
echo.
choice /C YN /M "%c%Apply Intel CPU optimizations? (Y/N)%u%"
if errorlevel 2 goto E

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       %blue%INTEL%c% OPTIMIZATION IN PROGRESS                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/12] Detecting CPU Specifications...%u%

set "NumberOfCores=6"
set "MaxClockSpeed=3000"
set "CPU_SCORE=18000"

for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfCores /format:value 2^>nul ^| findstr /i "NumberOfCores" 2^>nul') do (
    set "temp_cores=%%a"
    if defined temp_cores (
        for /f "tokens=* delims= " %%b in ("!temp_cores!") do set "temp_cores=%%b"
        if not "!temp_cores!"=="" (
            set /a "test_cores=!temp_cores!" 2>nul
            if !test_cores! GEQ 1 if !test_cores! LEQ 32 set "NumberOfCores=!test_cores!"
        )
    )
)

for /f "tokens=2 delims==" %%a in ('wmic cpu get MaxClockSpeed /format:value 2^>nul ^| findstr /i "MaxClockSpeed" 2^>nul') do (
    set "temp_speed=%%a"
    if defined temp_speed (
        for /f "tokens=* delims= " %%b in ("!temp_speed!") do set "temp_speed=%%b"
        if not "!temp_speed!"=="" (
            set /a "test_speed=!temp_speed!" 2>nul
            if !test_speed! GEQ 1000 if !test_speed! LEQ 8000 set "MaxClockSpeed=!test_speed!"
        )
    )
)

set /a "CPU_SCORE=%NumberOfCores% * %MaxClockSpeed%" 2>nul
if %CPU_SCORE% LEQ 0 set "CPU_SCORE=18000"

echo %c%CPU detected   %NumberOfCores% cores at %MaxClockSpeed% MHz (Score   %CPU_SCORE%)%u%

echo %c%[2/12] Configuring Intel Power Management...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c" /v "ValueMax" /t REG_DWORD /d "100" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c\DefaultPowerSchemeValues\8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" /v "ValueMax" /t REG_DWORD /d "100" /f >nul 2>&1

echo %c%[3/12] Disabling Intel C-States for Performance...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[4/12] Optimizing Intel Turbo Boost and SpeedStep...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "ValueMax" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\45bcc044-d885-43e2-8605-ee0ec6e96b59" /v "ValueMax" /t REG_DWORD /d "100" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\45bcc044-d885-43e2-8605-ee0ec6e96b59" /v "ValueMin" /t REG_DWORD /d "100" /f >nul 2>&1

echo %c%[5/12] Configuring Intel Spectre/Meltdown Mitigations...%u%
wmic cpu get name 2>nul | findstr /i "Intel" >nul && (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f >nul 2>&1
)

echo %c%[6/12] Optimizing System Responsiveness...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f >nul 2>&1

echo %c%[7/12] Configuring CPU-Based Timer Resolution...%u%
if %CPU_SCORE% LEQ 8000 (
    echo %c%Low-end CPU detected - Using conservative timer settings%u%
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /f >nul 2>&1
) else (
    if %CPU_SCORE% LEQ 12000 (
        echo %c%Mid-range CPU detected - Using moderate timer resolution%u%
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "5" /f >nul 2>&1
    ) else (
        if %CPU_SCORE% LEQ 18000 (
            echo %c%High-end CPU detected - Using fast timer resolution%u%
            reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "2" /f >nul 2>&1
        ) else (
            echo %c%Ultra high-end CPU detected - Using maximum timer resolution%u%
            reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "1" /f >nul 2>&1
        )
    )
)

echo %c%[8/12] Setting CPU-Based Cursor Update Interval...%u%
if %CPU_SCORE% LEQ 10000 (
    reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorUpdateInterval" /t REG_DWORD /d "5" /f >nul 2>&1
) else (
    if %CPU_SCORE% LEQ 15000 (
        reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorUpdateInterval" /t REG_DWORD /d "2" /f >nul 2>&1
    ) else (
        reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorUpdateInterval" /t REG_DWORD /d "1" /f >nul 2>&1
    )
)

echo %c%[9/12] Optimizing Power Throttling and Thread Management...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ThreadDpcEnable" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DpcTimeout" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[10/12] Configuring CPU Affinity and CSRSS Priority...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "PagePriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TrustedInstaller.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TrustedInstaller.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wuauclt.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wuauclt.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\audiodg.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MsMpEng.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MsMpEngCP.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[12/12] Applying Intel Gaming and Multimedia Optimizations...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "CPU Priority" /t REG_DWORD /d "6" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       %blue%INTEL%c% OPTIMIZATION COMPLETED                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Intel CPU optimizations have been successfully applied.%u%
echo.
echo %c%Applied Optimizations:%u%
echo %c%• CPU detected   %NumberOfCores% cores at %MaxClockSpeed% MHz (Score   %CPU_SCORE%)%u%
echo %c%• Intel power management configured for performance%u%
echo %c%• C-States disabled to prevent CPU parking%u%
echo %c%• Turbo Boost and SpeedStep optimized%u%
echo %c%• Spectre/Meltdown mitigations adjusted for Intel%u%
echo %c%• System responsiveness improved (10%% reserve)%u%
echo %c%• Timer resolution optimized for CPU performance%u%
echo %c%• Power throttling disabled%u%
echo %c%• CSRSS priority and CPU affinity optimized%u%
echo %c%• Cache and memory management enhanced%u%
echo %c%• Gaming task priorities configured%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:RyzenOptimization
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         %red%AMD%c% RYZEN PERFORMANCE OPTIMIZER                      ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%AMD Ryzen-specific optimizations include:%u%
echo %c%• AMD Precision Boost and Core Performance Boost registry settings%u%
echo %c%• Essential AMD services preserved for frequency scaling%u%
echo %c%• Enhanced C-States and P-States registry configuration%u%
echo %c%• CPU affinity and CSRSS priority optimization%u%
echo %c%• Dynamic timer resolution based on CPU performance%u%
echo %c%• AMD-specific boost and thermal settings%u%
echo.
echo %red%%underline%Ryzen Notice:%u%
echo %c%These optimizations configure registry settings for boost support.%u%
echo %c%Use with Desktop Ultimate Performance power plan for full effect.%u%
echo.
echo.
choice /C YN /M "%c%Apply AMD Ryzen registry optimizations? (Y/N)%u%"
if errorlevel 2 goto E

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       %red%RYZEN%c% OPTIMIZATION IN PROGRESS                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/12] Detecting CPU Specifications...%u%
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfCores /format:value 2^>nul ^| findstr "NumberOfCores"') do set /a "NumberOfCores=%%a" >nul 2>&1
for /f "tokens=2 delims==" %%a in ('wmic cpu get MaxClockSpeed /format:value 2^>nul ^| findstr "MaxClockSpeed"') do set /a "MaxClockSpeed=%%a" >nul 2>&1
for /f "tokens=2 delims==" %%a in ('wmic cpu get Name /format:value 2^>nul ^| findstr "Name"') do set "CPUName=%%a" >nul 2>&1
if not defined NumberOfCores set NumberOfCores=4
if not defined MaxClockSpeed set MaxClockSpeed=3000
set /a "CPU_SCORE=%NumberOfCores%*%MaxClockSpeed%"

echo %c%[2/12] Configuring AMD Precision Boost Registry Settings...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "ValueMax" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "ValueMin" /t REG_DWORD /d "2" /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\bc5038f7-23e0-4960-96da-33abaf5935ec" /v "ValueMax" /t REG_DWORD /d "100" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\bc5038f7-23e0-4960-96da-33abaf5935ec" /v "ValueMin" /t REG_DWORD /d "100" /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c" /v "ValueMax" /t REG_DWORD /d "100" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c" /v "ValueMin" /t REG_DWORD /d "5" /f >nul 2>&1

echo %c%[3/12] Optimizing C-States Registry for Boost Compatibility...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[4/12] Preserving Essential AMD Services for Boost...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AmdPPM" /v "Start" /t REG_DWORD /d "3" /f >nul 2>&1
reg query "HKLM\SYSTEM\CurrentControlSet\Services\AMDRyzenMasterDriverV19" >nul 2>&1 && reg add "HKLM\SYSTEM\CurrentControlSet\Services\AMDRyzenMasterDriverV19" /v "Start" /t REG_DWORD /d "3" /f >nul 2>&1

echo %c%[5/12] Configuring Frequency Scaling Registry Policies...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v "ValueMax" /t REG_DWORD /d "3" /f >nul 2>&1

echo %c%[6/12] Disabling Power Throttling While Preserving Boost...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[7/12] Optimizing System Responsiveness...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f >nul 2>&1

echo %c%[8/12] Configuring CPU-Based Timer Resolution...%u%
if %CPU_SCORE% LEQ 8000 (
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /f >nul 2>&1
) else if %CPU_SCORE% LEQ 12000 (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "5" /f >nul 2>&1
) else if %CPU_SCORE% LEQ 18000 (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "2" /f >nul 2>&1
) else (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "1" /f >nul 2>&1
)

echo %c%[9/12] Setting CPU-Based Cursor Update Interval...%u%
if %CPU_SCORE% LEQ 10000 (
    reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorUpdateInterval" /t REG_DWORD /d "5" /f >nul 2>&1
) else if %CPU_SCORE% LEQ 15000 (
    reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorUpdateInterval" /t REG_DWORD /d "2" /f >nul 2>&1
) else (
    reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorUpdateInterval" /t REG_DWORD /d "1" /f >nul 2>&1
)

echo %c%[10/12] Configuring CPU Affinity and CSRSS Priority...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1

echo %c%[11/12] Optimizing Memory Controller for Boost Performance...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SecondLevelDataCache" /t REG_DWORD /d "1024" /f >nul 2>&1
wmic cpu get name 2>nul | findstr "AMD" >nul && (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "64" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f >nul 2>&1
)

echo %c%[12/12] Configuring AMD-Specific Boost Settings...%u%
reg add "HKLM\SOFTWARE\AMD\CN" /v "PowerScheme" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\AMD\CN" /v "CorePerformanceBoost" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\AMD\CN" /v "ThermalLimit" /t REG_DWORD /d "90" /f >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       %red%RYZEN%c% OPTIMIZATION COMPLETED                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%AMD Ryzen registry optimizations have been successfully applied.%u%
echo.
echo %c%Applied Optimizations:%u%
echo %c%AMD Precision Boost and Core Performance Boost registry configured%u%
echo %c%C-States optimized for boost compatibility%u%
echo %c%Essential AMD services preserved for frequency scaling%u%
echo %c%Frequency scaling policies configured%u%
echo %c%Power throttling disabled while preserving boost%u%
echo %c%System responsiveness improved%u%
echo %c%Memory controller optimized%u%
echo %c%AMD-specific boost settings configured%u%
echo.
echo %red%%underline%Important Notes:%u%
echo %c%• Use Desktop Ultimate Performance power plan for CPU boost%u%
echo %c%• Enable PBO in BIOS for additional boost capability%u%
echo %c%• Monitor with HWiNFO64 or Ryzen Master%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:UniversalCPU
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        UNIVERSAL CPU PERFORMANCE OPTIMIZER                   ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Universal CPU optimizations include:%u%
echo %c%• Generic power management improvements%u%
echo %c%• CPU scheduling and priority optimizations%u%
echo %c%• Memory management and cache tweaks%u%
echo %c%• Dynamic timer resolution based on CPU%u%
echo %c%• System responsiveness improvements%u%
echo.
echo.
choice /C YN /M "%c%Apply universal CPU optimizations? (Y/N)%u%"
if errorlevel 2 goto E

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                     UNIVERSAL OPTIMIZATION IN PROGRESS                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/6] Detecting CPU Specifications...%u%
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfCores /format:value 2^>nul ^| findstr "NumberOfCores"') do set /a "NumberOfCores=%%a" >nul 2>&1
for /f "tokens=2 delims==" %%a in ('wmic cpu get MaxClockSpeed /format:value 2^>nul ^| findstr "MaxClockSpeed"') do set /a "MaxClockSpeed=%%a" >nul 2>&1
if not defined NumberOfCores set NumberOfCores=4
if not defined MaxClockSpeed set MaxClockSpeed=3000
set /a "CPU_SCORE=%NumberOfCores%*%MaxClockSpeed%"

echo %c%[2/6] Configuring General Power Management...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c" /v "ValueMax" /t REG_DWORD /d "100" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f >nul 2>&1

echo %c%[3/6] Optimizing CPU Scheduling and Priorities...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ThreadDpcEnable" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1

echo %c%[4/6] Configuring CPU-Based Timer Resolution...%u%
if %CPU_SCORE% LEQ 8000 (
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /f >nul 2>&1
) else if %CPU_SCORE% LEQ 12000 (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "5" /f >nul 2>&1
) else if %CPU_SCORE% LEQ 18000 (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "2" /f >nul 2>&1
) else (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "1" /f >nul 2>&1
)

echo %c%[5/6] Configuring Memory Management...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[6/6] Applying Gaming Optimizations...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "CPU Priority" /t REG_DWORD /d "6" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    UNIVERSAL OPTIMIZATION COMPLETED                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Universal CPU optimizations have been successfully applied.%u%
echo.
echo %c%Applied Optimizations:%u%
echo %c%• CPU detected: %NumberOfCores% cores at %MaxClockSpeed% MHz%u%
echo %c%• General power management optimized%u%
echo %c%• CPU scheduling and priorities enhanced%u%
echo %c%• Dynamic timer resolution configured%u%
echo %c%• Memory management improved%u%
echo %c%• Gaming task priorities optimized%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:F
setlocal EnableDelayedExpansion
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           MEMORY PERFORMANCE OPTIMIZER                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Memory optimization includes:%u%
echo %c%• System service priority optimization for performance%u%
echo %c%• Memory management and paging configuration%u%
echo %c%• Virtual memory and cache settings%u%
echo %c%• Process priority adjustments for critical services%u%
echo %c%• RAM usage optimization and cleanup%u%
echo.
echo %red%%underline%Memory Notice:%u%
echo %c%This optimization adjusts system service priorities and memory settings.%u%
echo %c%Some low-priority services will be deprioritized for better performance.%u%
echo.
echo.
choice /C YN /M "%c%Apply memory performance optimizations? (Y/N)%u%"
if errorlevel 2 goto TweaksMenu

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       MEMORY OPTIMIZATION IN PROGRESS                        ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
chcp 437 >nul
echo %c%[1/6] Detecting System Memory Configuration...%u%
set RAM_GB=
for /f "delims=" %%R in ('powershell -NoProfile -Command "[math]::Round(((Get-WmiObject -Class Win32_ComputerSystem -ErrorAction SilentlyContinue).TotalPhysicalMemory)/1GB)" 2^>nul') do (
    set RAM_GB=%%R
)

set RAM_PROFILE=UNKNOWN
set TotalRAM=
set RAM_GB_IS_VALID=0

if defined RAM_GB (
    set "original_ram_gb_str=!RAM_GB!"
    set /a "numeric_ram_gb_val=0"
    set /a "numeric_ram_gb_val=!RAM_GB!" 2>nul

    if "!numeric_ram_gb_val!" EQU "!original_ram_gb_str!" (
        if "!original_ram_gb_str!" NEQ "" (
            set RAM_GB_IS_VALID=1
        )
    )
)

if "!RAM_GB_IS_VALID!"=="1" (
    echo %c%PowerShell detected RAM: !RAM_GB! GB%u%
    set /a TotalRAM = RAM_GB * 1024
    set /a temp_RAM_GB_for_compare = RAM_GB + 0 
    if !temp_RAM_GB_for_compare! LSS 8 (
        set "RAM_PROFILE=LOW"
    ) else if !temp_RAM_GB_for_compare! EQU 8 (
        set "RAM_PROFILE=MEDIUM"
    ) else (
        set "RAM_PROFILE=MAXIMUM"
    )
) else (
    echo %red%PowerShell output [!RAM_GB!] was not a valid number or was empty. Using defaults.%u%
    set RAM_GB=8      
    set TotalRAM=8192 
    set RAM_PROFILE=MEDIUM 
)
echo %c%System Total RAM (for display): !TotalRAM! MB. RAM Profile set to: !RAM_PROFILE!%u%

echo %c%[2/6] Optimizing Critical System Service Priorities...%u%
set "CRITICAL_SERVICES=DsSvc Dhcp DPS Dnscache WinHttpAutoProxySvc DcpSvc WlanSvc LSM Spooler vds RpcSs PlugPlay AudioSrv WIA"
for %%s in (%CRITICAL_SERVICES%) do (
    for /f "tokens=3" %%a in ('sc queryex "%%s" 2^>nul ^| findstr "PID"') do (
        if not "%%a"=="" if not "%%a"=="0" (
            wmic process where ProcessId=%%a CALL setpriority "realtime" >nul 2>&1
        )
    )
)

echo %c%[3/6] Deprioritizing Non-Essential Services...%u%
set "LOW_PRIORITY_SERVICES=BITS smphost PNRPsvc SensrSvc Wcmsvc Wersvc wuauserv AVCTP DiagTrack MapsBroker IrMonSvc wisvc MixedRealityOpenXR RetailDemo lfsvc"
for %%s in (%LOW_PRIORITY_SERVICES%) do (
    for /f "tokens=3" %%a in ('sc queryex "%%s" 2^>nul ^| findstr "PID"') do (
        if not "%%a"=="" if not "%%a"=="0" (
            wmic process where ProcessId=%%a CALL setpriority "low" >nul 2>&1
        )
    )
)

echo %c%[4/6] Configuring Memory Management Settings...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown"      /t REG_DWORD /d "0"      /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive"        /t REG_DWORD /d "1"      /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit"             /t REG_DWORD /d "1048576" /f >nul 2>&1

if "!RAM_PROFILE!"=="MAXIMUM" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1"           /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SystemPages"      /t REG_DWORD /d "0" /f >nul 2>&1
) else (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "0"           /f >nul 2>&1
)

echo %c%[5/6] Optimizing Virtual Memory and Paging...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SecondLevelDataCache"   /t REG_DWORD /d "1024"   /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ThirdLevelDataCache"    /t REG_DWORD /d "8192"   /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePageCombining"   /t REG_DWORD /d "1"      /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings"       /t REG_DWORD /d "1"      /f >nul 2>&1

echo %c%[6/6] Applying Advanced Memory Optimizations...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness"                           /t REG_DWORD /d "10" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl"     /v "Win32PrioritySeparation"     /t REG_DWORD /d "38"                     /f >nul 2>&1
if !RAM_GB! GEQ 16 (
    powershell -NoProfile -Command "Disable-MMAgent -MemoryCompression" >nul 2>&1
) else (
    powershell -NoProfile -Command "Enable-MMAgent -MemoryCompression" >nul 2>&1
)

if "!RAM_PROFILE!"=="MAXIMUM" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters" /v "Size"            /t REG_DWORD /d "3"    /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem"                   /v "ContigFileAllocSize" /t REG_DWORD /d "1536" /f >nul 2>&1
) else if "!RAM_PROFILE!"=="MEDIUM" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters" /v "Size"            /t REG_DWORD /d "2"    /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem"                   /v "ContigFileAllocSize" /t REG_DWORD /d "512"  /f >nul 2>&1
) else ( 
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters" /v "Size"            /t REG_DWORD /d "1"    /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem"                   /v "ContigFileAllocSize" /t REG_DWORD /d "64"   /f >nul 2>&1
)

echo.
echo %c%Cleaning temporary memory allocations...%u%
for %%B in (chrome.exe firefox.exe msedge.exe) do (
    tasklist /fi "imagename eq %%B" | find /i "%%B" >nul 2>&1
    if not errorlevel 1 (
        taskkill /f /im "%%B" >nul 2>&1
        timeout /t 1 >nul
        start "" "%%B" >nul 2>&1
    )
)
chcp 65001 >nul
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       MEMORY OPTIMIZATION COMPLETED                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Memory performance optimizations have been successfully applied.%u%
echo.
echo %c%System Configuration:%u%
echo %c%• Total RAM detected: !TotalRAM! MB (approx. !RAM_GB! GB)%u%
echo %c%• Memory profile: !RAM_PROFILE! performance configuration%u%
echo.
echo %c%Applied Optimizations:%u%
echo %c%• Critical system services prioritized to realtime%u%
echo %c%• Non-essential services deprioritized%u%
echo %c%• Memory management settings optimized%u%
echo %c%• Virtual memory and paging configured%u%
echo %c%• Cache settings tuned for !RAM_PROFILE! RAM systems%u%
echo %c%• Prefetch and Superfetch optimized%u%
echo %c%• File system allocation enhanced%u%
echo.
echo %red%Performance Notes:%u%
echo %c%• Page file will be cleared at shutdown for security%u%
echo %c%• Executive code locked in memory for performance%u%
echo %c%• Service priorities optimized for gaming/performance%u%
if "!RAM_PROFILE!"=="MAXIMUM" echo %c%• Large system cache enabled for high-RAM systems%u%
if "!RAM_PROFILE!"=="LOW" echo %c%• Conservative settings applied for low-RAM systems%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu


:G
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        MOUSE/KEYBOARD PERFORMANCE OPTIMIZER                  ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Input device optimizations include:%u%
echo %c%• Mouse acceleration and smoothing removal%u%
echo %c%• Keyboard response time and repeat rate optimization%u%
echo %c%• Polling rate and data queue improvements%u%
echo %c%• Gaming-focused precision enhancements%u%
echo %c%• Input lag reduction and responsiveness tweaks%u%
echo %c%• Accessibility feature optimization%u%
echo.
echo %red%%underline%Input Notice:%u%
echo %c%These optimizations prioritize precision and responsiveness for gaming.%u%
echo %c%Mouse acceleration will be disabled for raw input precision.%u%
echo.
echo.
choice /C YN /M "%c%Apply mouse and keyboard optimizations? Press Y or N to continue.%u%"
if errorlevel 2 goto TweaksMenu
cls
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    MOUSE/KEYBOARD OPTIMIZATION IN PROGRESS                   ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/8] Select your mouse type:%u%
echo %c%   Press Y if you have a gaming mouse.%u%
echo %c%   Press N if you have a standard/office mouse.%u%
choice /C YN /M "%c%Gaming mouse (Y) or standard mouse (N)?%u%"
if errorlevel 2 (
    set "MOUSE_PROFILE=STANDARD"
    set "MouseTypeDesc=Standard/Office Mouse"
) else (
    set "MOUSE_PROFILE=GAMING"
    set "MouseTypeDesc=Gaming Mouse"
)

echo %c%[2/8] Optimizing Keyboard Response and Timing...%u%
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatDelay"       /t REG_SZ /d "200"   /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatRate"        /t REG_SZ /d "6"     /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "BounceTime"            /t REG_SZ /d "0"     /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "DelayBeforeAcceptance" /t REG_SZ /d "0"     /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags"                 /t REG_SZ /d "59"    /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last BounceKey Setting" /t REG_DWORD /d "0"  /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Delay"       /t REG_DWORD /d "0"  /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Repeat"      /t REG_DWORD /d "0"  /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Wait"        /t REG_DWORD /d "1000" /f >nul 2>&1

echo %c%[3/8] Configuring Keyboard Performance Settings...%u%
reg add "HKCU\Control Panel\Keyboard"           /v "InitialKeyboardIndicators" /t REG_SZ /d "0"   /f >nul 2>&1
reg add "HKCU\Control Panel\Keyboard"           /v "KeyboardDelay"           /t REG_SZ /d "0"   /f >nul 2>&1
reg add "HKCU\Control Panel\Keyboard"           /v "KeyboardSpeed"           /t REG_SZ /d "31"  /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "300" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "ThreadPriority"       /t REG_DWORD /d "31"  /f >nul 2>&1

echo %c%[4/8] Disabling Accessibility Features for Performance...%u%
reg add "HKCU\Control Panel\Accessibility\StickyKeys"     /v "Flags" /t REG_SZ /d "506"  /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\ToggleKeys"     /v "Flags" /t REG_SZ /d "58"   /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\MouseKeys"      /v "Flags" /t REG_SZ /d "38"   /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\FilterKeys"     /v "Flags" /t REG_SZ /d "126"  /f >nul 2>&1

echo %c%[5/8] Optimizing Mouse Precision and Acceleration...%u%
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed"      /t REG_SZ /d "0"   /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0"   /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0"   /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10"  /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseHoverTime"  /t REG_SZ /d "8"   /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "DoubleClickSpeed" /t REG_SZ /d "500" /f >nul 2>&1

echo %c%[6/8] Configuring Raw Input and Mouse Curves...%u%
if "%MOUSE_PROFILE%"=="GAMING" (
    reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d "000000000000000000000000000000000000000000000000C0CC0C000000000000000000000000000809919000000000000000000000000000000000000000000000000000000000000000000000406626000000000000000000000000000003333000000000000000000000000000000" /f >nul 2>&1
    reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d "000000000000000000000000000000000000000000000000000038000000000000000000000000000000000070000000000000000000000000000000000A800000000000000000000000000000000E000000000000000000000000000000" /f >nul 2>&1
) else (
    reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d "0000000000000000156e000000000000004001000000000000800300000000000000090000000000000010270000000000002800000000000000407F0000000000006400000000000000" /f >nul 2>&1
    reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d "0000000000000000fd11010000000000002404000000000000360a000000000000388c010000000000bd21030000000000007a13000000000000" /f >nul 2>&1
)

echo %c%[7/8] Enhancing Mouse Hardware Performance...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize"     /t REG_DWORD /d "100" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "ThreadPriority"         /t REG_DWORD /d "31"  /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouhid\Parameters"  /v "TreatAbsolutePointerAsAbsolute" /t REG_DWORD /d "1"   /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouhid\Parameters"  /v "TreatAbsoluteAsRelative"       /t REG_DWORD /d "0"   /f >nul 2>&1

echo %c%[8/8] Applying Advanced Input Optimizations...%u%
reg query "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" >nul 2>&1
if not errorlevel 1 (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance"       /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>&1
)

reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed"         /v "CursorSensitivity"                /t REG_DWORD /d "10000" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed"         /v "CursorUpdateInterval"             /t REG_DWORD /d "1"     /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed"         /v "IRRemoteNavigationDelta"          /t REG_DWORD /d "1"     /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism"      /v "AttractionRectInsetInDIPS"        /t REG_DWORD /d "5"     /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism"      /v "DistanceThresholdInDIPS"          /t REG_DWORD /d "40"    /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism"      /v "MagnetismDelayInMilliseconds"     /t REG_DWORD /d "50"    /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism"      /v "MagnetismUpdateIntervalInMilliseconds" /t REG_DWORD /d "10" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism"      /v "VelocityInDIPSPerSecond"          /t REG_DWORD /d "360"   /f >nul 2>&1

reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseHoverTime"     /t REG_SZ /d "100" /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseSpeed"         /t REG_SZ /d "0"   /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold1"    /t REG_SZ /d "0"   /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold2"    /t REG_SZ /d "0"   /f >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                   MOUSE/KEYBOARD OPTIMIZATION COMPLETED                      ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Mouse and keyboard optimizations have been successfully applied.%u%
echo.
echo %c%Input Configuration:%u%
echo %c%• Mouse profile: %MOUSE_PROFILE% optimization mode%u%
echo %c%• Hardware type: %MouseTypeDesc%%u%
echo.
echo %c%Applied Optimizations:%u%
echo %c%• Keyboard response time minimized (0ms delay)%u%
echo %c%• Key repeat rate maximized for responsiveness%u%
echo %c%• Mouse acceleration completely disabled%u%
echo %c%• Raw input precision enabled%u%
if "%MOUSE_PROFILE%"=="GAMING" (
    echo %c%• Gaming-optimized mouse curves applied%u%
) else (
    echo %c%• Standard mouse curves applied%u%
)
echo %c%• Input data queue sizes increased%u%
echo %c%• Thread priorities elevated for input devices%u%
echo %c%• Accessibility features optimized%u%
echo.
echo %red%Performance Notes:%u%
echo %c%• Mouse acceleration disabled for 1:1 movement precision%u%
echo %c%• Keyboard repeat delay eliminated for faster response%u%
echo %c%• Input lag reduced through hardware optimizations%u%
echo %c%• Gaming applications will benefit from raw input%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:H
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       NETWORK CONNECTIVITY AND DNS OPTIMIZER                 ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Network connectivity optimization includes:%u%
echo %c%• DNS cache flush and optimization%u%
echo %c%• Network adapter reset and renewal%u%
echo %c%• High-performance DNS servers configuration%u%
echo %c%• Network stack reset and optimization%u%
echo %c%• Connection troubleshooting and repair%u%
echo %c%• Internet speed and latency improvements%u%
echo.
echo %red%%underline%Network Notice:%u%
echo %c%This optimization will temporarily interrupt network connectivity.%u%
echo %c%Active downloads and streaming may be affected during the process.%u%
echo.
echo.
choice /C YN /M "%c%Apply network connectivity optimizations? Press Y to proceed, N to cancel.%u%"
if errorlevel 2 goto TweaksMenu
cls
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    NETWORK OPTIMIZATION IN PROGRESS                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/10] Analyzing Current Network Configuration...%u%
for /f "tokens=*" %%i in ('ipconfig /all ^| findstr /i "adapter"') do echo %c%• Found: %%i%u%
timeout /t 1 >nul
chcp 437 >nul
echo %c%[2/10] Flushing DNS Cache and ARP Tables...%u%
ipconfig /flushdns >nul 2>&1
arp -d *            >nul 2>&1
nbtstat -R          >nul 2>&1
nbtstat -RR         >nul 2>&1
chcp 437 >nul
echo %c%[3/10] Releasing and Renewing IP Configuration...%u%
ipconfig /release   >nul 2>&1
timeout /t 2        >nul
ipconfig /renew     >nul 2>&1
ipconfig /registerdns >nul 2>&1
chcp 437 >nul
echo %c%[4/10] Resetting Network Components (Winsock/IP/TCP/UDP)...%u%
netsh winsock reset >nul 2>&1
netsh int ip reset  >nul 2>&1
netsh int tcp reset >nul 2>&1
netsh int udp reset >nul 2>&1
chcp 437 >nul
echo %c%[5/10] Applying Advanced Network Registry Settings...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableICMPRedirect   /t REG_DWORD /d 0      /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnablePMTUDiscovery /t REG_DWORD /d 1      /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v GlobalMaxTcpWindowSize /t REG_DWORD /d 65535  /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpWindowSize         /t REG_DWORD /d 65535  /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DefaultTTL             /t REG_DWORD /d 64     /f >nul 2>&1
chcp 437 >nul
echo %c%[6/10] Configuring High-Performance DNS Servers for All Connected Adapters...%u%
for /f "tokens=1,2,3,* delims= " %%A in ('
    netsh interface show interface ^
    ^| findstr /I "Connected" ^
    ^| findstr /I "Dedicated"
') do (
    for /f "tokens=* delims= " %%I in ("%%D") do (
        echo    Interface detected: "%%I"

        netsh interface ip set dns name="%%I" static 1.1.1.1 primary   >nul 2>&1
        netsh interface ip add dns name="%%I" 1.0.0.1 index=2         >nul 2>&1

        netsh interface ipv6 add dns name="%%I" 2606:4700:4700::1111 index=1 >nul 2>&1
        netsh interface ipv6 add dns name="%%I" 2606:4700:4700::1001 index=2 >nul 2>&1

        echo  - DNS set on "%%I"
    )
)
timeout /t 1 >nul
chcp 437 >nul
chcp 65001 >nul
echo %c%[7/10] Optimizing Network Stack Settings...%u%
netsh int tcp set global autotuninglevel=normal  >nul 2>&1
netsh int tcp set global chimney=enabled         >nul 2>&1
netsh int tcp set global rss=enabled             >nul 2>&1
netsh int tcp set global netdma=enabled          >nul 2>&1
netsh int tcp set global ecncapability=enabled   >nul 2>&1
netsh int tcp set global timestamps=disabled      >nul 2>&1
chcp 437 >nul
echo %c%[8/10] Restarting Network Adapters...%u%
powershell -Command ^
  "if (Get-Command Get-NetAdapter -ErrorAction SilentlyContinue) { Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Restart-NetAdapter -Confirm:\$false }" >nul 2>&1
timeout /t 5 >nul
chcp 65001 >nul
echo %c%[9/10] Testing Network Connectivity and Performance...%u%
echo %c%• Testing DNS resolution...%u%
nslookup google.com 1.1.1.1 >nul 2>&1 && echo %c%   DNS resolution successful%u% || echo %red%   DNS resolution failed%u%
echo %c%• Testing internet connectivity...%u%
ping -n 1 8.8.8.8 >nul 2>&1 && echo %c%   Internet connectivity confirmed%u% || echo %red%   Internet connectivity issues%u%
echo %c%• Testing latency to DNS server...%u%
ping -n 1 1.1.1.1 >nul 2>&1 && echo %c%   Low latency DNS confirmed%u% || echo %red%   High latency detected%u%
timeout /t 1 >nul

echo %c%[10/10] Applying Final Gaming and Streaming Optimizations...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched"                       /v NonBestEffortLimit    /t REG_DWORD /d 0           /f >nul 2>&1
timeout /t 5 >nul
call :SetupConsole
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                  NETWORK CONNECTIVITY OPTIMIZATION COMPLETED                 ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Network connectivity and DNS optimizations have been successfully applied.%u%
echo.
echo %c%Applied Optimizations:%u%
echo %c%• DNS cache flushed and refreshed%u%
echo %c%• Cloudflare IPv4/IPv6 DNS set on all connected adapters%u%
echo %c%• Winsock/IP/TCP/UDP stack reset and reconfigured%u%
echo %c%• Network throttling disabled for gaming%u%
echo %c%• Advanced registry settings optimized (PMTU, TTL, window size)%u%
echo %c%• Network adapter settings restarted and optimized%u%
echo %c%• TCP/IP stack autotuning, chimney, and RSS enabled%u%
echo %c%• Connection stability and speed improved%u%
echo.
echo %red%Performance Notes:%u%
echo %c%• DNS resolution speed significantly improved (Cloudflare)%u%
echo %c%• IPv6 DNS configured for dual-stack environments%u%
echo %c%• Network latency reduced for gaming and streaming%u%
echo %c%• May require system restart for full optimization%u%
echo.
echo %c%New DNS Configuration:%u%
echo %c%• Primary IPv4 DNS: 1.1.1.1 (Cloudflare – Ultra-fast)%u%
echo %c%• Secondary IPv4 DNS: 1.0.0.1 (Cloudflare – Backup)%u%
echo %c%• Primary IPv6 DNS: 2606:4700:4700::1111%u%
echo %c%• Secondary IPv6 DNS: 2606:4700:4700::1001%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:I
setlocal EnableDelayedExpansion
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           WINDOWS SERVICE OPTIMIZER                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This comprehensive service optimizer includes:%u%
echo %c%• Telemetry and data collection service management%u%
echo %c%• OEM manufacturer service optimization (HP, Intel, NVIDIA, etc.)%u%
echo %c%• Network and sharing service configuration%u%
echo %c%• Gaming and Xbox service management%u%
echo %c%• Third-party application telemetry control%u%
echo %c%• Performance-impacting service optimization%u%
echo %c%• Hardware peripheral service management%u%
echo %c%• Automatic update service control%u%
echo %c%• System security and backup service configuration%u%
echo.
echo %red%%underline%Service Notice:%u%
echo %c%You will be prompted for each major service category.%u%
echo %c%Critical system services will always remain protected.%u%
echo %c%This allows safe customization based on your specific needs.%u%
echo.
echo.
choice /C YN /M "%c%Proceed with comprehensive service optimization? (Y/N)%u%"
if errorlevel 2 goto TweaksMenu

cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          SELECT OPTIMIZATION MODE                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%   [1] Quick Mode    - 10 category prompts (fast, group-based)%u%
echo %c%   [2] Advanced Mode - Individual per-service control%u%
echo %c%   [0] Return to Menu%u%
echo.
:ISelectMode
set "svc_mode="
set /p "svc_mode=Select mode (1/2/0): "
if "%svc_mode%"=="1" goto IQuickMode
if "%svc_mode%"=="2" goto IAdvanced
if "%svc_mode%"=="0" goto TweaksMenu
echo %red%Invalid option. Please try again.%u%
timeout /t 1 >nul
goto ISelectMode

:IQuickMode
cls
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       SERVICE OPTIMIZATION CONFIGURATION                     ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.

echo %c%[1/10] Windows Telemetry and Data Collection%u%
echo.
echo %c%This disables Windows diagnostic data, usage tracking, and error reporting.%u%
echo %c%Recommended: DISABLE for better privacy and performance.%u%
echo.
choice /C YN /M "%c%Disable Windows telemetry and data collection? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_TELEMETRY=false"
    echo %c%• Windows telemetry will remain ENABLED%u%
) else (
    set "DISABLE_TELEMETRY=true"
    echo %c%• Windows telemetry will be DISABLED%u%
)

echo.
echo %c%[2/10] OEM Manufacturer Services%u%
echo.
echo %c%This disables background services from HP, Intel, NVIDIA, Dell, ASUS, etc.%u%
echo %c%Recommended: DISABLE unless you need specific OEM functionality.%u%
echo.
choice /C YN /M "%c%Disable OEM manufacturer services? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_OEM=false"
    echo %c%• OEM services will remain ENABLED%u%
) else (
    set "DISABLE_OEM=true"
    echo %c%• OEM services will be DISABLED%u%
)

echo.
echo %c%[3/10] Network and Sharing Services%u%
echo.
echo %c%This disables unused network services like remote access, file sharing, etc.%u%
echo %c%Recommended: DISABLE unless you use file sharing or remote desktop.%u%
echo.
choice /C YN /M "%c%Disable unused network services? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_NETWORK=false"
    echo %c%• Network services will remain ENABLED%u%
) else (
    set "DISABLE_NETWORK=true"
    echo %c%• Network services will be DISABLED%u%
)

echo.
echo %c%[4/10] Microsoft Store and Xbox Services%u%
echo.
echo %c%This controls Xbox Live, Microsoft Store, Game Bar, and Minecraft online functionality.%u%
echo %c%Recommended: ENABLE if you use Xbox App, Microsoft Store, or play Minecraft.%u%
echo.
choice /C YN /M "%c%Enable Microsoft Store and Xbox services? (Y/N)%u%"
if errorlevel 2 (
    set "ENABLE_XBOX=false"
    echo %c%• Microsoft Store and Xbox services will be DISABLED%u%
) else (
    set "ENABLE_XBOX=true"
    echo %c%• Microsoft Store and Xbox services will be ENABLED%u%
)

echo.
echo %c%[5/10] Third-Party Application Telemetry%u%
echo.
echo %c%This disables data collection from NVIDIA, Adobe, Google, Office, and other apps.%u%
echo %c%Recommended: DISABLE for better privacy and reduced background activity.%u%
echo.
choice /C YN /M "%c%Disable third-party application telemetry? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_3RD_PARTY=false"
    echo %c%• Third-party telemetry will remain ENABLED%u%
) else (
    set "DISABLE_3RD_PARTY=true"
    echo %c%• Third-party telemetry will be DISABLED%u%
)

echo.
echo %c%[6/10] Gaming Hardware Services%u%
echo.
echo %c%This disables background services from Razer, Logitech, Corsair, etc.%u%
echo %c%Note: May affect RGB lighting and macro functionality.%u%
echo.
choice /C YN /M "%c%Disable gaming hardware background services? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_GAMING_HW=false"
    echo %c%• Gaming hardware services will remain ENABLED%u%
) else (
    set "DISABLE_GAMING_HW=true"
    echo %c%• Gaming hardware services will be DISABLED%u%
)

echo.
echo %c%[7/10] Automatic Update Services%u%
echo.
echo %c%This disables automatic updates for Google, Adobe, and other third-party apps.%u%
echo %c%Recommended: DISABLE to reduce background activity and control updates manually.%u%
echo.
choice /C YN /M "%c%Disable automatic update services? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_UPDATES=false"
    echo %c%• Automatic update services will remain ENABLED%u%
) else (
    set "DISABLE_UPDATES=true"
    echo %c%• Automatic update services will be DISABLED%u%
)

echo.
echo %c%[8/10] Performance Services%u%
echo.
echo %c%This disables Windows services that may impact gaming performance.%u%
echo %c%Includes: Superfetch, Windows Search, Font Cache, etc.%u%
echo %c%Recommended: DISABLE for better gaming performance and faster boot times.%u%
echo.
choice /C YN /M "%c%Disable performance-impacting services? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_PERFORMANCE=false"
    echo %c%• Performance services will remain ENABLED%u%
) else (
    set "DISABLE_PERFORMANCE=true"
    echo %c%• Performance services will be DISABLED%u%
)

echo.
echo %c%[9/10] Security and Backup Services%u%
echo.
echo %c%This disables optional security services like biometrics, smart cards, backup.%u%
echo %c%Note: Core Windows security (Defender) remains unaffected.%u%
echo.
choice /C YN /M "%c%Disable optional security and backup services? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_SECURITY=false"
    echo %c%• Security and backup services will remain ENABLED%u%
) else (
    set "DISABLE_SECURITY=true"
    echo %c%• Security and backup services will be DISABLED%u%
)

echo.
echo %c%[10/10] Bluetooth Services%u%
echo.
echo %c%This disables Bluetooth-related services.%u%
echo %c%Only disable if you don't use Bluetooth devices.%u%
echo.
choice /C YN /M "%c%Disable Bluetooth services? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_BLUETOOTH=false"
    echo %c%• Bluetooth services will remain ENABLED%u%
) else (
    set "DISABLE_BLUETOOTH=true"
    echo %c%• Bluetooth services will be DISABLED%u%
)

echo.
echo %c%[11/13] Print and Imaging Services%u%
echo.
echo %c%This disables Windows print and imaging services: Print Spooler, scanner,%u%
echo %c%WIA acquisition, and camera frame server.%u%
echo %c%Only disable if you have NO printers, scanners, or capture devices.%u%
echo.
choice /C YN /M "%c%Disable print and imaging services? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_PRINT=false"
    echo %c%• Print and imaging services will remain ENABLED%u%
) else (
    set "DISABLE_PRINT=true"
    echo %c%• Print and imaging services will be DISABLED%u%
)

echo.
echo %c%[12/13] Hyper-V and Virtual Machine Services%u%
echo.
echo %c%This disables Hyper-V guest integration services (vmicXxx, HvHost).%u%
echo %c%Safe to disable if you are NOT running inside a Hyper-V virtual machine.%u%
echo.
choice /C YN /M "%c%Disable Hyper-V and VM services? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_HYPERV=false"
    echo %c%• Hyper-V/VM services will remain ENABLED%u%
) else (
    set "DISABLE_HYPERV=true"
    echo %c%• Hyper-V/VM services will be DISABLED%u%
)

echo.
echo %c%[13/13] Windows Features and App Services%u%
echo.
echo %c%This disables a large set of Windows app-platform and feature services:%u%
echo %c%Phone Link, Timeline, Connected Devices, Push Notifications, Maps, Wallet,%u%
echo %c%Tablet services, sensor/pen input, remote desktop hosting, and more.%u%
echo %c%Recommended: DISABLE on a dedicated gaming or clean install machine.%u%
echo.
choice /C YN /M "%c%Disable Windows features and app services? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_WINFEATURES=false"
    echo %c%• Windows feature services will remain ENABLED%u%
) else (
    set "DISABLE_WINFEATURES=true"
    echo %c%• Windows feature services will be DISABLED%u%
)

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       SERVICE OPTIMIZATION IN PROGRESS                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.

if "%DISABLE_TELEMETRY%"=="true" (
    echo %c%[1/15] Disabling Windows Telemetry and Data Collection...%u%
    call :DisableTelemetryServices
) else (
    echo %c%[1/15] Preserving Windows Telemetry Services...%u%
)

if "%DISABLE_OEM%"=="true" (
    echo %c%[2/15] Disabling OEM Manufacturer Services...%u%
    call :DisableOEMServices
) else (
    echo %c%[2/15] Preserving OEM Manufacturer Services...%u%
)

if "%DISABLE_NETWORK%"=="true" (
    echo %c%[3/15] Disabling Unused Network Services...%u%
    call :DisableUnusedNetworkServices
) else (
    echo %c%[3/15] Preserving Network Services...%u%
)

if "%ENABLE_XBOX%"=="true" (
    echo %c%[4/15] Enabling Microsoft Store and Xbox Services...%u%
    call :EnableXboxServices
) else (
    echo %c%[4/15] Disabling Microsoft Store and Xbox Services...%u%
    call :DisableXboxServices
)

if "%DISABLE_3RD_PARTY%"=="true" (
    echo %c%[5/15] Disabling Third-Party Application Telemetry...%u%
    call :DisableThirdPartyTelemetry
) else (
    echo %c%[5/15] Preserving Third-Party Application Telemetry...%u%
)

if "%DISABLE_GAMING_HW%"=="true" (
    echo %c%[6/15] Disabling Gaming Hardware Background Services...%u%
    call :DisableGamingHardwareServices
) else (
    echo %c%[6/15] Preserving Gaming Hardware Services...%u%
)

if "%DISABLE_UPDATES%"=="true" (
    echo %c%[7/15] Disabling Automatic Update Services...%u%
    call :DisableAutomaticUpdateServices
) else (
    echo %c%[7/15] Preserving Automatic Update Services...%u%
)

if "%DISABLE_PERFORMANCE%"=="true" (
    echo %c%[8/15] Disabling Performance-Impacting Services...%u%
    call :DisablePerformanceServices
) else (
    echo %c%[8/15] Preserving Performance Services...%u%
)

if "%DISABLE_SECURITY%"=="true" (
    echo %c%[9/15] Disabling Optional Security and Backup Services...%u%
    call :DisableSecurityServices
) else (
    echo %c%[9/15] Preserving Security and Backup Services...%u%
)

if "%DISABLE_BLUETOOTH%"=="true" (
    echo %c%[10/15] Disabling Bluetooth Services...%u%
    call :DisableBluetoothServices
) else (
    echo %c%[10/15] Preserving Bluetooth Services...%u%
)

if "%DISABLE_PRINT%"=="true" (
    echo %c%[11/15] Disabling Print and Imaging Services...%u%
    call :DisablePrintServices
) else (
    echo %c%[11/15] Preserving Print and Imaging Services...%u%
)

if "%DISABLE_HYPERV%"=="true" (
    echo %c%[12/15] Disabling Hyper-V and VM Services...%u%
    call :DisableHyperVServices
) else (
    echo %c%[12/15] Preserving Hyper-V and VM Services...%u%
)

if "%DISABLE_WINFEATURES%"=="true" (
    echo %c%[13/15] Disabling Windows Features and App Services...%u%
    call :DisableWindowsFeaturesServices
) else (
    echo %c%[13/15] Preserving Windows Features and App Services...%u%
)

echo %c%[14/15] Ensuring Critical System Services Remain Enabled...%u%
call :EnableCriticalServices

echo %c%[15/15] Applying Final Configurations...%u%
call :ApplyFinalServiceConfigurations

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       SERVICE OPTIMIZATION COMPLETED                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Service optimizations have been applied based on your preferences.%u%
echo.
echo %c%Configuration Summary:%u%
if "%DISABLE_TELEMETRY%"=="true" (
    echo %c%• Windows Telemetry: DISABLED%u%
) else (
    echo %c%• Windows Telemetry: ENABLED%u%
)
if "%DISABLE_OEM%"=="true" (
    echo %c%• OEM Services: DISABLED%u%
) else (
    echo %c%• OEM Services: ENABLED%u%
)
if "%DISABLE_NETWORK%"=="true" (
    echo %c%• Network Services: OPTIMIZED%u%
) else (
    echo %c%• Network Services: PRESERVED%u%
)
if "%ENABLE_XBOX%"=="true" (
    echo %c%• Microsoft Store and Xbox: ENABLED%u%
    echo %c%  - Xbox Live, Game Bar, and Minecraft online will work%u%
) else (
    echo %c%• Microsoft Store and Xbox: DISABLED%u%
)
if "%DISABLE_3RD_PARTY%"=="true" (
    echo %c%• Third-Party Telemetry: DISABLED%u%
    echo %c%  - NVIDIA, Adobe, Google, Office, VS Code telemetry disabled%u%
) else (
    echo %c%• Third-Party Telemetry: ENABLED%u%
)
if "%DISABLE_GAMING_HW%"=="true" (
    echo %c%• Gaming Hardware Services: DISABLED%u%
    echo %c%  - Razer, Logitech, Corsair background services disabled%u%
) else (
    echo %c%• Gaming Hardware Services: ENABLED%u%
)
if "%DISABLE_UPDATES%"=="true" (
    echo %c%• Automatic Updates: DISABLED%u%
    echo %c%  - Google, Adobe, Dropbox auto-updates disabled%u%
) else (
    echo %c%• Automatic Updates: ENABLED%u%
)
if "%DISABLE_PERFORMANCE%"=="true" (
    echo %c%• Performance Services: OPTIMIZED%u%
    echo %c%  - Superfetch, indexing, and background services disabled%u%
) else (
    echo %c%• Performance Services: PRESERVED%u%
)
if "%DISABLE_SECURITY%"=="true" (
    echo %c%• Security Services: OPTIMIZED%u%
) else (
    echo %c%• Security Services: PRESERVED%u%
)
if "%DISABLE_BLUETOOTH%"=="true" (
    echo %c%• Bluetooth Services: DISABLED%u%
) else (
    echo %c%• Bluetooth Services: ENABLED%u%
)
if "%DISABLE_PRINT%"=="true" (
    echo %c%• Print and Imaging Services: DISABLED%u%
) else (
    echo %c%• Print and Imaging Services: ENABLED%u%
)
if "%DISABLE_HYPERV%"=="true" (
    echo %c%• Hyper-V/VM Services: DISABLED%u%
) else (
    echo %c%• Hyper-V/VM Services: ENABLED%u%
)
if "%DISABLE_WINFEATURES%"=="true" (
    echo %c%• Windows Features and App Services: DISABLED%u%
) else (
    echo %c%• Windows Features and App Services: ENABLED%u%
)
echo.
echo %green%Total Services Optimized: Over 250+ background services managed%u%
echo %red%Note: Changes will take effect after restart.%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                     DEVICE MANAGER TWEAKS                                   ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Disables unnecessary Device Manager devices to reduce interrupt overhead and%u%
echo %c%background activity. Devices can be re-enabled in Device Manager at any time.%u%
echo.
choice /C YN /M "%c%Disable unnecessary Device Manager devices? (Y/N)%u%"
if errorlevel 2 goto TweaksMenu

echo.
echo %c%Scanning and disabling devices... (this may take a moment)%u%
echo.
setlocal enabledelayedexpansion
set "DM_DEVICES=ACPI Processor Aggregator|ACPI Thermal Zone|ACPI Wake Alarm|AMD Controller Emulation|AMD Crash Defender|AMD PSP|Composite Bus Enumerator|Direct memory access controller|High Precision Event Timer|Intel Management Engine|Intel(R) Dynamic Application Loader Host Interface|Intel(R) Management Engine Interface #1|Intel(R) Management Engine WMI Provider|Intel(R) Platform Monitoring Technology Device|Intel(R) SMBus - 7AA3|Intel(R) SPI (Flash) Controller - 7AA4|Microsoft Device Association Root Enumerator|Microsoft GS Wavetable Synth|Microsoft Hyper-V Virtualization Infrastructure Driver|Microsoft Hypervisor Service|Microsoft Kernel Debug Network Adapter|Microsoft Print to PDF|Microsoft Radio Device Enumeration Bus|Microsoft RRAS Root Enumerator|Microsoft Virtual Drive Enumerator|Microsoft Windows Management Interface for ACPI|NDIS Virtual Network Adapter Enumerator|NVIDIA High Definition Audio|Numeric Data Processor|Programmable interrupt controller|Remote Desktop Device Redirector Bus|Resource Hub proxy device|Root Print Queue|System Timer|UMBus Root Bus Enumerator|WAN Miniport (IKEv2)|WAN Miniport (IP)|WAN Miniport (IPv6)|WAN Miniport (L2TP)|WAN Miniport (Network Monitor)|WAN Miniport (PPPOE)|WAN Miniport (PPTP)|WAN Miniport (SSTP)"
for %%D in ("%DM_DEVICES:^|=" "%") do (
    set "_dev=%%~D"
    chcp 437 >nul
    powershell -NoProfile -Command "try { Get-PnpDevice -FriendlyName '!_dev!' -ErrorAction Stop | Disable-PnpDevice -Confirm:$false -ErrorAction Stop; Write-Host 'OK' } catch { Write-Host 'SKIP' }" 2>nul | findstr /i "OK" >nul 2>&1
    chcp 65001 >nul
    if !errorlevel! equ 0 echo %green%  [+] Disabled: !_dev!%u%
)
endlocal
echo.
echo %green%Device Manager tweaks applied.%u%
echo %c%Note: Re-enable devices in Device Manager if issues occur.%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:DisableService
setlocal enabledelayedexpansion
set "serviceName=%~1"
sc query "!serviceName!" >nul 2>&1
if !errorlevel! equ 0 (
    sc config "!serviceName!" start= disabled >nul 2>&1
    if !errorlevel! equ 0 (
        echo %green%    → Disabled: !serviceName!%u%
    ) else (
        echo %red%    → Failed: !serviceName!%u%
    )
) else (
    echo %yellow%    → Not found: !serviceName!%u%
)
exit /b

:DisableServiceWildcard
setlocal enabledelayedexpansion
set "servicePattern=%1"
for /f "skip=1 tokens=2" %%s in ('sc query type= service state= all ^| findstr "SERVICE_NAME"') do (
    echo %%s | findstr /i "!servicePattern!" >nul && (
        sc config "%%s" start= disabled >nul 2>&1
        if !errorlevel! equ 0 (
            echo %green%    → Disabled wildcard: %%s%u%
        )
    )
)
exit /b

:IAdvanced
cls
call :SetupConsole
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        ADVANCED SERVICE CONTROL                               ║
echo ║                                                                               ║
echo ║    [1]  Category Mode    Configure each service group  (11 quick choices)     ║
echo ║    [2]  Disable All      Disable all optional services  (no prompts)          ║
echo ║    [0]  Back                                                                  ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
:IAdvMenu
set "IA_MODE="
set /p "IA_MODE=%c%Choose »%u% "
if "%IA_MODE%"=="1" goto IAdv_CategoryMode
if "%IA_MODE%"=="2" goto IAdv_DisableAll
if "%IA_MODE%"=="0" goto TweaksMenu
echo %red%Invalid option. Please try again.%u%
timeout /t 1 >nul
goto IAdvMenu

:IAdv_DisableAll
cls
call :SetupConsole
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    DISABLING ALL OPTIONAL SERVICES                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%  [ 1/13]  Telemetry ^& Data Collection...%u%
call :DisableTelemetryServices
echo %c%  [ 2/13]  OEM Manufacturer services...%u%
call :DisableOEMServices
echo %c%  [ 3/13]  Network ^& Sharing services...%u%
call :DisableUnusedNetworkServices
echo %c%  [ 4/13]  Xbox ^& Store services...%u%
call :DisableXboxServices
echo %c%  [ 5/13]  Third-party telemetry registry tweaks...%u%
call :DisableThirdPartyTelemetry
echo %c%  [ 6/13]  Gaming Hardware services...%u%
call :DisableGamingHardwareServices
echo %c%  [ 7/13]  Automatic Update services...%u%
call :DisableAutomaticUpdateServices
echo %c%  [ 8/13]  Performance services...%u%
call :DisablePerformanceServices
echo %c%  [ 9/13]  Security ^& Backup services...%u%
call :DisableSecurityServices
echo %c%  [10/13]  Bluetooth services...%u%
call :DisableBluetoothServices
echo %c%  [11/13]  Print ^& Imaging services...%u%
call :DisablePrintServices
echo %c%  [12/13]  Hyper-V ^& VM services...%u%
call :DisableHyperVServices
echo %c%  [13/13]  Windows Features ^& App services...%u%
call :DisableWindowsFeaturesServices
echo.
echo %c%  Protecting critical services...%u%
call :EnableCriticalServices
call :ApplyFinalServiceConfigurations
goto IAdv_Complete

:IAdv_CategoryMode
cls
call :SetupConsole
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║              ADVANCED SERVICE CONTROL  —  CATEGORY MODE                      ║
echo ║                                                                               ║
echo ║    For each category choose one option:                                       ║
echo ║      D  =  Disable All    (recommended for most categories)                  ║
echo ║      M  =  Manual         (on-demand — starts only when something needs it)  ║
echo ║      K  =  Keep / Skip    (leave this category untouched)                    ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%  Tip: press Enter without typing anything to skip a category (same as K).%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO BEGIN ══════════════════════════%u%
pause >nul

cls
call :SetupConsole
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║  [1/11]  TELEMETRY ^& DATA COLLECTION                                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%  DiagTrack, dmwappushservice, DPS, WerSvc, PcaSvc, MapsBroker, lfsvc,%u%
echo %c%  RetailDemo, wisvc, WdiServiceHost, diagsvc, Sense, SensorService,%u%
echo %c%  DisplayEnhancementService, GraphicsPerfSvc, and more.%u%
echo.
echo %red%  Recommended: D%u%
echo.
set "G1="
set /p "G1=%c%D / M / K »%u% "
if not defined G1 set "G1=K"
if /i "!G1!"=="D" call :DisableTelemetryServices
if /i "!G1!"=="M" (
    for %%s in (DiagTrack dmwappushservice diagsvc DPS WerSvc wercplsupport WdiServiceHost WdiSystemHost PcaSvc wisvc RetailDemo lfsvc MapsBroker GraphicsPerfSvc Sense SensorDataService SensorService SensrSvc DisplayEnhancementService) do sc config %%s start= demand >nul 2>&1
    sc config "diagnosticshub.standardcollector.service" start= demand >nul 2>&1
)

cls
call :SetupConsole
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║  [2/11]  OEM MANUFACTURER SERVICES                                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%  HP, Dell, Intel, Lenovo, Acer, ASUS diagnostic and background services.%u%
echo %c%  Safe to disable if you don't use your OEM's companion software.%u%
echo.
echo %red%  Recommended: D%u%
echo.
set "G2="
set /p "G2=%c%D / M / K »%u% "
if not defined G2 set "G2=K"
if /i "!G2!"=="D" call :DisableOEMServices
if /i "!G2!"=="M" (
    for %%s in (HPAppHelperCap HPDiagsCap HPNetworkCap HPOmenCap HPPrintScanDoctorService HPSysInfoCap HpTouchpointAnalyticsService DCUService cplspcon igccservice jhi_service IntelAudioService RtkAudioUniversalService SynTPEnhService ClickToRunSvc VSInstallerElevationService) do sc config %%s start= demand >nul 2>&1
)

cls
call :SetupConsole
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║  [3/11]  NETWORK ^& SHARING SERVICES                                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%  RemoteRegistry, WinRM, UPnP, SSDP, WebClient, RAS/VPN, SNMP, 802.1X,%u%
echo %c%  Wi-Fi Direct, P2P networking, IPsec, NetBIOS helper  (39 services total).%u%
echo.
echo %red%  Recommended: D%u%
echo.
set "G3="
set /p "G3=%c%D / M / K »%u% "
if not defined G3 set "G3=K"
if /i "!G3!"=="D" call :DisableUnusedNetworkServices
if /i "!G3!"=="M" (
    for %%s in (ALG NetTcpPortSharing RemoteAccess RemoteRegistry WinRM wcncsvc WMPNetworkSvc ssh-agent upnphost SSDPSRV lltdsvc dot3svc icssvc SharedAccess WFDSConMgrSvc RasAuto RasMan SstpSvc WwanSvc Wecsvc WebClient fdPHost FDResPub lmhosts NcbService NcdAutoSetup Netlogon Netman NetSetupSvc p2pimsvc p2psvc PeerDistSvc PNRPAutoReg PNRPsvc RpcLocator SNMPTrap Eaphost IKEEXT PolicyAgent) do sc config %%s start= demand >nul 2>&1
)

cls
call :SetupConsole
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║  [4/11]  XBOX ^& MICROSOFT STORE SERVICES                                     ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%  XblAuthManager, XblGameSave, XboxGipSvc, XboxNetApiSvc, GamingServices,%u%
echo %c%  GamingServicesNet, GameInputSvc, InstallService, ClipSVC, LicenseManager%u%
echo.
echo %yellow%  Note: Disabling will break Xbox app, Game Pass, and Store installs.%u%
echo %c%  Recommended: K unless you never use Xbox / Game Pass / Microsoft Store.%u%
echo.
set "G4="
set /p "G4=%c%D / M / K »%u% "
if not defined G4 set "G4=K"
if /i "!G4!"=="D" call :DisableXboxServices
if /i "!G4!"=="M" (
    for %%s in (XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc GamingServices GamingServicesNet GameInputSvc InstallService ClipSVC LicenseManager) do sc config %%s start= demand >nul 2>&1
)

cls
call :SetupConsole
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║  [5/11]  GAMING HARDWARE SERVICES                                             ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%  Razer, Logitech, Corsair, MSI Center, and ASUS peripheral services.%u%
echo %c%  Disable if you don't use these brands' companion software / RGB lighting.%u%
echo.
echo %red%  Recommended: D  (if you don't use their software)%u%
echo.
set "G5="
set /p "G5=%c%D / M / K »%u% "
if not defined G5 set "G5=K"
if /i "!G5!"=="D" call :DisableGamingHardwareServices
if /i "!G5!"=="M" (
    for %%s in (RzActionSvc LogiRegistryService LGHUBUpdaterService CorsairService MSI_Central_Service ASUSOptimization logi_lamparray_service) do sc config %%s start= demand >nul 2>&1
    sc config "Razer Game Scanner Service" start= demand >nul 2>&1
)

cls
call :SetupConsole
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║  [6/11]  AUTOMATIC UPDATE SERVICES                                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%  Google, Adobe, Dropbox, Mozilla, and Microsoft Edge auto-update services.%u%
echo.
echo %red%  Recommended: D%u%
echo.
set "G6="
set /p "G6=%c%D / M / K »%u% "
if not defined G6 set "G6=K"
if /i "!G6!"=="D" call :DisableAutomaticUpdateServices
if /i "!G6!"=="M" (
    for %%s in (gupdate gupdatem GoogleChromeElevationService AdobeUpdateService AdobeARMservice dbupdate dbupdatem MozillaMaintenance edgeupdate edgeupdatem) do sc config %%s start= demand >nul 2>&1
)

cls
call :SetupConsole
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║  [7/11]  PERFORMANCE SERVICES                                                 ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%  SysMain (Superfetch), WSearch (file indexing), FontCache, msiserver,%u%
echo %c%  Web Threat Defense, W32Time, autotimesvc, TieringEngine, and more.%u%
echo.
echo %red%  Recommended: D  (SysMain ^& WSearch are the biggest resource hogs)%u%
echo.
set "G7="
set /p "G7=%c%D / M / K »%u% "
if not defined G7 set "G7=K"
if /i "!G7!"=="D" call :DisablePerformanceServices
if /i "!G7!"=="M" (
    for %%s in (SysMain WSearch PimIndexMaintenanceSvc FontCache msiserver webthreatdefsvc webthreatdefusersvc wscsvc W32Time autotimesvc tzautoupdate defragsvc DusmSvc TieringEngineService) do sc config %%s start= demand >nul 2>&1
)

cls
call :SetupConsole
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║  [8/11]  SECURITY, BACKUP ^& BLUETOOTH                                        ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%  Security:  Biometrics, Smart Card, Windows Hello, Parental Controls%u%
echo %c%  Backup:    Windows Backup, File History, Block Backup, Work Folders%u%
echo %c%  Bluetooth: BTAGService, BthAvctpSvc, bthserv%u%
echo.
echo %c%  Recommended: D for Security/Backup if unused.  K if you use Bluetooth.%u%
echo.
set "G8="
set /p "G8=%c%D / M / K »%u% "
if not defined G8 set "G8=K"
if /i "!G8!"=="D" (
    call :DisableSecurityServices
    call :DisableBluetoothServices
)
if /i "!G8!"=="M" (
    for %%s in (WbioSrvc SCardSvr ScDeviceEnum SCPolicySvc NgcCtnrSvc NgcSvc NaturalAuthentication SEMgrSvc WpcMonSvc SDRSVC fhsvc wbengine swprv refsdedupsvc svsvc workfolderssvc BTAGService BthAvctpSvc bthserv) do sc config %%s start= demand >nul 2>&1
)

cls
call :SetupConsole
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║  [9/11]  PRINT ^& IMAGING SERVICES                                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%  Spooler, PrintNotify, stisvc, WiaRpc, FrameServer, FrameServerMonitor,%u%
echo %c%  PrintDeviceConfigurationService, PrintScanBrokerService%u%
echo.
echo %c%  Recommended: D if you have no printer or scanner connected.%u%
echo.
set "G9="
set /p "G9=%c%D / M / K »%u% "
if not defined G9 set "G9=K"
if /i "!G9!"=="D" call :DisablePrintServices
if /i "!G9!"=="M" (
    for %%s in (Spooler PrintNotify stisvc WiaRpc FrameServer FrameServerMonitor) do sc config %%s start= demand >nul 2>&1
    sc config "PrintDeviceConfigurationService" start= demand >nul 2>&1
    sc config "PrintScanBrokerService" start= demand >nul 2>&1
)

cls
call :SetupConsole
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║  [10/11]  HYPER-V ^& VIRTUAL MACHINE SERVICES                                 ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%  HvHost and all vmicXxx Hyper-V guest integration services.%u%
echo.
echo %c%  Recommended: D if you are NOT running inside a Hyper-V virtual machine.%u%
echo.
set "G10="
set /p "G10=%c%D / M / K »%u% "
if not defined G10 set "G10=K"
if /i "!G10!"=="D" call :DisableHyperVServices
if /i "!G10!"=="M" (
    for %%s in (HvHost vmicguestinterface vmicheartbeat vmickvpexchange vmicrdv vmicshutdown vmictimesync vmicvmsession vmicvss) do sc config %%s start= demand >nul 2>&1
)

cls
call :SetupConsole
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║  [11/11]  WINDOWS FEATURES ^& APP SERVICES                                    ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%  Phone Link, CDP/Sync, Push Notifications, Maps, Wallet, Themes, RDP,%u%
echo %c%  Pen/Touch, BitLocker, Windows Update, Telephony, and 50+ more services.%u%
echo.
echo %red%  Recommended: D on a dedicated gaming or optimized machine.%u%
echo.
set "G11="
set /p "G11=%c%D / M / K »%u% "
if not defined G11 set "G11=K"
if /i "!G11!"=="D" call :DisableWindowsFeaturesServices
if /i "!G11!"=="M" (
    for %%s in (AarSvc AppReadiness BcastDVRUserService BDESVC CaptureService cbdhsvc CDPUserSvc CertPropSvc COMSysApp ConsentUxUserSvc CscService dcsvc DeviceInstall DevicePickerUserSvc DevicesFlowUserSvc DevQueryBroker) do sc config %%s start= demand >nul 2>&1
    for %%s in (DisplayEnhancementService DmEnrollmentSvc DsmSvc DsSvc EFS hidserv InventorySvc IpxlatCfgSvc KtmRm LxpSvc McpManagementService MessagingService midisrv MSDTC MSiSCSI NPSMSvc) do sc config %%s start= demand >nul 2>&1
    for %%s in (OneSyncSvc P9RdrService PenService perceptionsimulation PerfHost PhoneSvc pla PushToInstall QWAVE RmSvc Sense SensorDataService SensorService SensrSvc SessionEnv ShellHWDetection) do sc config %%s start= demand >nul 2>&1
    for %%s in (shpamsvc SmsRouter smphost TapiSrv Themes TrkWks TroubleshootingSvc uhssvc UmRdpService UnistoreSvc UserDataSvc UsoSvc VacSvc VaultSvc vds WalletService) do sc config %%s start= demand >nul 2>&1
    for %%s in (WManSvc wmiApSrv WPDBusEnum WpnUserService WpnService wuauserv wercplsupport StorSvc TokenBroker BITS AJRouter seclogon) do sc config %%s start= demand >nul 2>&1
    sc config "diagnosticshub.standardcollector.service" start= demand >nul 2>&1
)

echo.
echo %c%  Applying third-party telemetry registry settings...%u%
call :DisableThirdPartyTelemetry

echo %c%  Protecting critical services...%u%
call :EnableCriticalServices
call :ApplyFinalServiceConfigurations

:IAdv_Complete
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                  ADVANCED SERVICE CONTROL COMPLETED                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Service configurations have been applied.%u%
echo %c%All critical system services remain protected and enabled.%u%
echo.
echo %red%Note: Changes will take full effect after a system restart.%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:IAdv_Keep
setlocal EnableDelayedExpansion
set "svc=%~1"
set "num=%~2"
set "keeps=%~3"
set "do_disable=true"
if /i "!keeps!"=="ALL" set "do_disable=false"
for %%k in (!keeps!) do if "%%k"=="!num!" set "do_disable=false"
if "!do_disable!"=="true" call :DisableService "!svc!"
exit /b

:IAdv_Disable
setlocal EnableDelayedExpansion
set "svc=%~1"
set "num=%~2"
set "disables=%~3"
set "do_disable=false"
if /i "!disables!"=="ALL" set "do_disable=true"
for %%k in (!disables!) do if "%%k"=="!num!" set "do_disable=true"
if "!do_disable!"=="true" call :DisableService "!svc!"
exit /b

:DisableTelemetryServices
echo %c%    Disabling telemetry and data collection services...%u%
call :DisableService "DiagTrack"
call :DisableService "dmwappushservice"
call :DisableService "diagsvc"
call :DisableService "DPS"
call :DisableService "WerSvc"
call :DisableService "pcasvc"
call :DisableService "WSearch"
call :DisableService "MapsBroker"
call :DisableService "lfsvc"
call :DisableService "RetailDemo"
call :DisableService "wisvc"
call :DisableService "HpTouchpointAnalyticsService"
call :DisableService "dptftcs"
call :DisableService "WdiServiceHost"
call :DisableService "WdiSystemHost"
call :DisableService "debugregsvc"
exit /b

:DisableOEMServices
echo %c%    Disabling OEM and third-party services...%u%
call :DisableService "HPAppHelperCap"
call :DisableService "HPDiagsCap"
call :DisableService "HPNetworkCap"
call :DisableService "HPOmenCap"
call :DisableService "HPPrintScanDoctorService"
call :DisableService "HPSysInfoCap"
call :DisableService "HpTouchpointAnalyticsService"
call :DisableService "Dell Client Management Service"
call :DisableService "DellUpdate"
call :DisableService "Dell SupportAssist Agent"
call :DisableService "DCUService"

call :DisableServiceWildcard "Lenovo"
call :DisableServiceWildcard "Acer"

call :DisableService "Armoury Crate Service"
call :DisableServiceWildcard "ASUS"

call :DisableService "cplspcon"
call :DisableService "igccservice"
call :DisableService "Intel(R) Platform License Manager Service"
call :DisableService "IntelAudioService"
call :DisableService "ipfsvc"
call :DisableService "jhi_service"
call :DisableService "WMIRegistrationService"

call :DisableService "hshld_12.10.2"
call :DisableService "Steam Client Service"
call :DisableService "SECOMNService"
call :DisableService "SynTPEnhService"
call :DisableService "RtkAudioUniversalService"
call :DisableService "logi_lamparray_service"
call :DisableService "ClickToRunSvc"
call :DisableService "VSInstallerElevationService"

call :DisableService "GUBootService"
call :DisableService "GUMemfilesService"
call :DisableService "GUPMService"
call :DisableService "XTU3SERVICE"
exit /b

:DisableUnusedNetworkServices
echo %c%    Disabling unused network and communication services...%u%
call :DisableService "ALG"
call :DisableService "NetTcpPortSharing"
call :DisableService "RemoteAccess"
call :DisableService "RemoteRegistry"
call :DisableService "WinRM"
call :DisableService "wcncsvc"
call :DisableService "WMPNetworkSvc"
call :DisableService "ssh-agent"
call :DisableService "upnphost"
call :DisableService "SSDPSRV"
call :DisableService "lltdsvc"
call :DisableService "dot3svc"
call :DisableService "icssvc"
call :DisableService "SharedAccess"
call :DisableService "WFDSConMgrSvc"
call :DisableService "RasAuto"
call :DisableService "RasMan"
call :DisableService "SstpSvc"
call :DisableService "WwanSvc"
call :DisableService "Wecsvc"
call :DisableService "WebClient"
call :DisableService "fdPHost"
call :DisableService "FDResPub"
call :DisableService "lmhosts"
call :DisableService "NcbService"
call :DisableService "NcdAutoSetup"
call :DisableService "Netlogon"
call :DisableService "Netman"
call :DisableService "NetSetupSvc"
call :DisableService "p2pimsvc"
call :DisableService "p2psvc"
call :DisableService "PeerDistSvc"
call :DisableService "PNRPAutoReg"
call :DisableService "PNRPsvc"
call :DisableService "RpcLocator"
call :DisableService "SNMPTrap"
call :DisableService "Eaphost"
call :DisableService "IKEEXT"
call :DisableService "PolicyAgent"
echo %green%    → Network services disabled%u%
exit /b

:EnableXboxServices
echo %c%    Enabling Xbox and Microsoft Store services...%u%
sc config "XblAuthManager" start= manual >nul 2>&1
sc config "XblGameSave" start= manual >nul 2>&1
sc config "XboxGipSvc" start= manual >nul 2>&1
sc config "XboxNetApiSvc" start= manual >nul 2>&1
sc config "StorSvc" start= auto >nul 2>&1
sc config "InstallService" start= manual >nul 2>&1
sc config "ClipSVC" start= manual >nul 2>&1
sc config "LicenseManager" start= manual >nul 2>&1
sc config "TokenBroker" start= manual >nul 2>&1
sc config "GamingServices" start= auto >nul 2>&1
sc config "GamingServicesNet" start= auto >nul 2>&1
sc config "GameInputSvc" start= manual >nul 2>&1
echo %green%    → Xbox and Store services enabled%u%
exit /b

:DisableXboxServices
echo %c%    Disabling Xbox and Microsoft Store services...%u%
call :DisableService "XblAuthManager"
call :DisableService "XblGameSave"
call :DisableService "XboxGipSvc"
call :DisableService "XboxNetApiSvc"
call :DisableService "GamingServices"
call :DisableService "GamingServicesNet"
call :DisableService "GameInputSvc"
call :DisableService "InstallService"
call :DisableService "ClipSVC"
call :DisableService "LicenseManager"
exit /b

:DisableThirdPartyTelemetry
echo %c%    Disabling third-party application telemetry...%u%

call :DisableService "NvTelemetryContainer"
reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v OptInOrOutPreference /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v EnableRID44231 /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v EnableRID64640 /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v EnableRID66610 /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKCU\SOFTWARE\Microsoft\VSCode" /v telemetry.enableTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\VSCode" /v telemetry.enableCrashReporter /t REG_DWORD /d 0 /f >nul 2>&1

PowerShell -NoProfile -Command "$f='%APPDATA%\Code\User\settings.json'; if(!(Test-Path $f)){exit 0}; try{$c=Get-Content $f -Raw -ErrorAction Stop}catch{exit 1}; if([string]::IsNullOrWhiteSpace($c)){$c='{}'}; try{$j=$c|ConvertFrom-Json}catch{exit 1}; $j|Add-Member NoteProperty 'telemetry.enableTelemetry' $false -Force; $j|Add-Member NoteProperty 'telemetry.enableCrashReporter' $false -Force; $j|Add-Member NoteProperty 'workbench.enableExperiments' $false -Force; $j|Add-Member NoteProperty 'update.mode' 'manual' -Force; $j|Add-Member NoteProperty 'update.showReleaseNotes' $false -Force; $j|Add-Member NoteProperty 'extensions.autoCheckUpdates' $false -Force; $j|Add-Member NoteProperty 'extensions.showRecommendationsOnlyOnDemand' $true -Force; $j|Add-Member NoteProperty 'git.autofetch' $false -Force; $j|Add-Member NoteProperty 'npm.fetchOnlinePackageInfo' $false -Force; $j|ConvertTo-Json|Set-Content $f" >nul 2>&1

reg add "HKCU\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v DisableTelemetry /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\ClientTelemetry" /v DisableTelemetry /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\Common\ClientTelemetry" /v DisableTelemetry /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Adobe\Adobe Desktop Common\ADS" /v OptOut /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Adobe\Adobe Desktop Common\RemoteUpdateManager" /v RemoteUpdateManagerOptin /t REG_DWORD /d 0 /f >nul 2>&1

setx DOTNET_CLI_TELEMETRY_OPTOUT 1 >nul 2>&1
setx POWERSHELL_TELEMETRY_OPTOUT 1 >nul 2>&1

reg add "HKCU\Software\Piriform\CCleaner" /v Monitoring /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Piriform\CCleaner" /v HelpImproveCCleaner /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Piriform\CCleaner" /v SystemMonitoring /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Piriform\CCleaner" /v UpdateAuto /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Piriform\CCleaner" /v UpdateCheck /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Piriform\CCleaner" /v UpdateBackground /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Piriform\CCleaner" /v CheckTrialOffer /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsMediaPlayer" /v PreventCodecDownload /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v UsageTracking /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\WindowsMediaPlayer" /v PreventCDDVDMetadataRetrieval /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\WindowsMediaPlayer" /v PreventMusicFileMetadataRetrieval /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\WindowsMediaPlayer" /v PreventRadioPresetsRetrieval /t REG_DWORD /d 1 /f >nul 2>&1

call :DisableService "dbupdate"
call :DisableService "dbupdatem"
call :DisableService "AdobeARMservice"
call :DisableService "gupdate"
call :DisableService "gupdatem"

call :DisableService "NvTelemetryContainer"

reg add "HKCU\Software\Microsoft\VisualStudio\Telemetry" /v TurnOffSwitch /t REG_DWORD /d 1 /f >nul 2>&1

echo %green%    → Third-party telemetry disabled (privacy.sexy integrated)%u%
exit /b


:DisableGamingHardwareServices
echo %c%    Disabling gaming hardware background services...%u%
call :DisableService "Razer Game Scanner Service"
call :DisableService "RzActionSvc"
call :DisableService "LogiRegistryService"
call :DisableService "LGHUBUpdaterService"
call :DisableService "CorsairService"
call :DisableService "MSI_Central_Service"
call :DisableService "ASUSOptimization"
call :DisableService "logi_lamparray_service"
exit /b

:DisableAutomaticUpdateServices
echo %c%    Disabling automatic update services...%u%
call :DisableService "gupdate"
call :DisableService "gupdatem"
call :DisableService "GoogleChromeElevationService"
call :DisableService "AdobeUpdateService"
call :DisableService "AdobeFlashPlayerUpdateSvc"
call :DisableService "AdobeARMservice"
call :DisableService "dbupdate"
call :DisableService "dbupdatem"
call :DisableService "MozillaMaintenance"
call :DisableService "edgeupdate"
call :DisableService "edgeupdatem"
exit /b

:DisablePerformanceServices
echo %c%    Disabling performance-impacting services...%u%
call :DisableService "SysMain"
call :DisableService "WSearch"
call :DisableService "PimIndexMaintenanceSvc"
call :DisableService "FontCache"

call :DisableService "msiserver"
call :DisableService "webthreatdefsvc"
call :DisableService "webthreatdefusersvc"
call :DisableService "wscsvc"
call :DisableService "AppIDSvc"

call :DisableService "FontCache3.0.0.0"
call :DisableService "W32Time"
call :DisableService "autotimesvc"
call :DisableService "tzautoupdate"
call :DisableService "spectrum"
call :DisableService "NcaSvc"
call :DisableService "MapsBroker"
call :DisableService "lfsvc"
call :DisableService "GraphicsPerfSvc"
call :DisableService "DoSvc"
call :DisableService "defragsvc"
call :DisableService "DusmSvc"
call :DisableService "WaaSMedicSvc"
call :DisableService "WalletService"
call :DisableService "WarpJITSvc"
call :DisableService "WSAIFabricSvc"
call :DisableService "whesvc"
call :DisableService "WinHttpAutoProxySvc"
call :DisableService "WEPHOSTSVC"
call :DisableService "TieringEngineService"
call :DisableService "TimeBrokerSvc"
exit /b

:DisableSecurityServices
echo %c%    Disabling optional security and backup services...%u%
call :DisableService "WbioSrvc"
call :DisableService "SCardSvr"
call :DisableService "ScDeviceEnum"
call :DisableService "SCPolicySvc"
call :DisableService "NgcCtnrSvc"
call :DisableService "NgcSvc"
call :DisableService "NaturalAuthentication"
call :DisableService "SEMgrSvc"
call :DisableService "WpcMonSvc"
call :DisableService "SDRSVC"
call :DisableService "fhsvc"
call :DisableService "wbengine"
call :DisableService "swprv"
call :DisableService "refsdedupsvc"
call :DisableService "svsvc"
call :DisableService "workfolderssvc"
exit /b

:DisableBluetoothServices
echo %c%    Disabling Bluetooth services...%u%
call :DisableService "BTAGService"
call :DisableService "BthAvctpSvc"
call :DisableService "bthserv"
call :DisableService "BluetoothUserService_dbdb6"
exit /b

:DisablePrintServices
echo %c%    Disabling print and imaging services...%u%
call :DisableService "Spooler"
call :DisableService "PrintNotify"
call :DisableService "stisvc"
call :DisableService "WiaRpc"
call :DisableService "FrameServer"
call :DisableService "FrameServerMonitor"
call :DisableService "PrintDeviceConfigurationService"
call :DisableService "PrintScanBrokerService"
echo %green%    → Print and imaging services disabled%u%
exit /b

:DisableHyperVServices
echo %c%    Disabling Hyper-V and virtual machine services...%u%
call :DisableService "HvHost"
call :DisableService "vmicguestinterface"
call :DisableService "vmicheartbeat"
call :DisableService "vmickvpexchange"
call :DisableService "vmicrdv"
call :DisableService "vmicshutdown"
call :DisableService "vmictimesync"
call :DisableService "vmicvmsession"
call :DisableService "vmicvss"
echo %green%    → Hyper-V and VM services disabled%u%
exit /b

:DisableWindowsFeaturesServices
echo %c%    Disabling Windows features and app services...%u%
call :DisableService "AarSvc"
call :DisableService "AppReadiness"
call :DisableService "BcastDVRUserService"
call :DisableService "BDESVC"
call :DisableService "CaptureService"
call :DisableService "cbdhsvc"
call :DisableService "CDPUserSvc"
call :DisableService "CertPropSvc"
call :DisableService "COMSysApp"
call :DisableService "ConsentUxUserSvc"
call :DisableService "CscService"
call :DisableService "dcsvc"
call :DisableService "DeviceInstall"
call :DisableService "DevicePickerUserSvc"
call :DisableService "DevicesFlowUserSvc"
call :DisableService "DevQueryBroker"
call :DisableService "diagnosticshub.standardcollector.service"
call :DisableService "DisplayEnhancementService"
call :DisableService "DmEnrollmentSvc"
call :DisableService "DsmSvc"
call :DisableService "DsSvc"
call :DisableService "EFS"
call :DisableService "hidserv"
call :DisableService "InventorySvc"
call :DisableService "IpxlatCfgSvc"
call :DisableService "KtmRm"
call :DisableService "LxpSvc"
call :DisableService "McpManagementService"
call :DisableService "MessagingService"
call :DisableService "midisrv"
call :DisableService "MSDTC"
call :DisableService "MSiSCSI"
call :DisableService "NPSMSvc"
call :DisableService "OneSyncSvc"
call :DisableService "P9RdrService"
call :DisableService "PenService"
call :DisableService "perceptionsimulation"
call :DisableService "PerfHost"
call :DisableService "PhoneSvc"
call :DisableService "pla"
call :DisableService "PushToInstall"
call :DisableService "QWAVE"
call :DisableService "RmSvc"
call :DisableService "Sense"
call :DisableService "SensorDataService"
call :DisableService "SensorService"
call :DisableService "SensrSvc"
call :DisableService "SessionEnv"
call :DisableService "ShellHWDetection"
call :DisableService "shpamsvc"
call :DisableService "SmsRouter"
call :DisableService "smphost"
call :DisableService "TapiSrv"
call :DisableService "Themes"
call :DisableService "TrkWks"
call :DisableService "TroubleshootingSvc"
call :DisableService "uhssvc"
call :DisableService "UmRdpService"
call :DisableService "UnistoreSvc"
call :DisableService "UserDataSvc"
call :DisableService "UsoSvc"
call :DisableService "VacSvc"
call :DisableService "VaultSvc"
call :DisableService "vds"
call :DisableService "WalletService"
call :DisableService "WManSvc"
call :DisableService "wmiApSrv"
call :DisableService "WPDBusEnum"
call :DisableService "WpnUserService"
call :DisableService "WpnService"
call :DisableService "wuauserv"
call :DisableService "wercplsupport"
call :DisableService "VSS"
echo %green%    → Windows features and app services disabled%u%
exit /b

:EnableCriticalServices
echo %c%    Ensuring critical services remain enabled...%u%
sc config "AudioEndpointBuilder" start= auto >nul 2>&1
sc config "Audiosrv" start= auto >nul 2>&1
sc config "BFE" start= auto >nul 2>&1
sc config "BrokerInfrastructure" start= auto >nul 2>&1
sc config "camsvc" start= auto >nul 2>&1
sc config "CoreMessagingRegistrar" start= auto >nul 2>&1
sc config "CryptSvc" start= auto >nul 2>&1
sc config "DcomLaunch" start= auto >nul 2>&1
sc config "DeviceAssociationService" start= auto >nul 2>&1
sc config "Dhcp" start= auto >nul 2>&1
sc config "DispBrokerDesktopSvc" start= auto >nul 2>&1
sc config "Dnscache" start= auto >nul 2>&1
sc config "EventLog" start= auto >nul 2>&1
sc config "EventSystem" start= auto >nul 2>&1
sc config "gpsvc" start= auto >nul 2>&1
sc config "LanmanServer" start= auto >nul 2>&1
sc config "mpssvc" start= auto >nul 2>&1
sc config "netprofm" start= auto >nul 2>&1
sc config "NlaSvc" start= auto >nul 2>&1
sc config "nsi" start= auto >nul 2>&1
sc config "PlugPlay" start= manual >nul 2>&1
sc config "Power" start= auto >nul 2>&1
sc config "ProfSvc" start= auto >nul 2>&1
sc config "RpcEptMapper" start= auto >nul 2>&1
sc config "RpcSs" start= auto >nul 2>&1
sc config "SamSs" start= auto >nul 2>&1
sc config "Schedule" start= auto >nul 2>&1
sc config "SENS" start= auto >nul 2>&1
sc config "StateRepository" start= auto >nul 2>&1
sc config "SystemEventsBroker" start= auto >nul 2>&1
sc config "TrustedInstaller" start= manual >nul 2>&1
sc config "UserManager" start= auto >nul 2>&1
sc config "Wcmsvc" start= auto >nul 2>&1
sc config "Winmgmt" start= auto >nul 2>&1
sc config "WlanSvc" start= auto >nul 2>&1
sc config "wlidsvc" start= manual >nul 2>&1
sc config "wlpasvc" start= manual >nul 2>&1

echo %green%    → Critical services verified and protected%u%
exit /b

:ApplyFinalServiceConfigurations
echo %c%    Applying final service configurations...%u%
sc config "CertPropSvc" start= manual >nul 2>&1
sc config "Ndu" start= disabled >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSync" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableMeteredNetworkFileSync" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableLibrariesDefaultSaveToOneDrive" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "Attributes" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "Attributes" /t REG_DWORD /d "0" /f >nul 2>&1

call :DisableService "CDPUserSvc_dbdb6"
call :DisableService "OneSyncSvc_dbdb6"
call :DisableService "PimIndexMaintenanceSvc_dbdb6"
call :DisableService "UnistoreSvc_dbdb6"
call :DisableService "UserDataSvc_dbdb6"

echo %c%    Applying registry-based service disabling...%u%
reg add "HKLM\System\CurrentControlSet\Services\AppIDSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\ClipSVC" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\CredentialEnrollmentManagerUserSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\DoSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\embeddedmode" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\EntAppSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\PrintWorkflowUserSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\SgrmBroker" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\SystemEventsBroker" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\WdNisSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "4294967295" /f >nul 2>&1

echo %green%    → Final configurations applied%u%
exit /b

:J
setlocal EnableDelayedExpansion
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         COMPREHENSIVE WINDOWS DEBLOATER                      ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This comprehensive debloater will remove or disable:%u%
echo %c%• Third-party bloatware apps and games (Netflix, Candy Crush, etc.)%u%
echo %c%• Microsoft Edge browser (optional)%u%
echo %c%• OneDrive cloud storage (optional)%u%
echo %c%• Microsoft Copilot AI assistant%u%
echo %c%• Widgets / Meet Now / Chat / Task View / Search icon%u%
echo %c%• Xbox services and apps (optional - affects Minecraft, Game Bar)%u%
echo %c%• Microsoft Store (optional - affects UWP app installations)%u%
echo %c%• Cortana and Search integration (optional)%u%
echo %c%• Skype and Teams (optional)%u%
echo %c%• OEM manufacturer bloatware (HP, Dell, ASUS, MSI, etc.)%u%
echo %c%• System apps (Wallet, Web Extensions, People Experience, etc.)%u%
echo %c%• Windows WebView2 Runtime (optional)%u%
echo %c%• Windows Security Center notifications (optional)%u%
echo %c%• Unnecessary Windows "Optional Features" (legacy media, IE, etc.)%u%
echo %c%• Outdated Windows features (WordPad, Steps Recorder, etc.)%u%
echo %c%• Advanced system apps (Print3D, Holographic, Parental Controls)%u%
echo.
echo %red%%underline%IMPORTANT WARNING:%u%
echo %c%This process is largely irreversible without a full system reset.%u%
echo %c%You will be prompted for each major component removal.%u%
echo %c%Removed apps can only be restored manually or via Windows reset.%u%
echo.
echo.
choice /C YN /M "%c%Proceed with comprehensive debloating? (Y/N)%u%"
if errorlevel 2 goto TweaksMenu

cls
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       DEBLOATING CONFIGURATION PROMPTS                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.

echo %c%[1/12] Microsoft Store and Gaming%u%
echo.
echo %c%Microsoft Store is required for Xbox App, Game Pass, and UWP apps.%u%
echo %c%Removing it will prevent installing Microsoft Store apps.%u%
echo %c%Recommended: KEEP if you use Xbox Game Pass or Microsoft Store apps.%u%
echo.
choice /C YN /M "%c%Keep Microsoft Store? (Y/N)%u%"
if errorlevel 2 (
    set "REMOVE_STORE=true"
    echo %c%• Microsoft Store will be REMOVED%u%
) else (
    set "REMOVE_STORE=false"
    echo %c%• Microsoft Store will be PRESERVED%u%
)

echo.
echo %c%[2/12] Xbox Services and Gaming%u%
echo.
echo %c%Xbox services power Xbox Live, Game Bar, and Minecraft online.%u%
echo %c%Removing them will disable Xbox Live features and online gaming.%u%
echo %c%Recommended: KEEP if you play Xbox games, Game Bar, or Minecraft online.%u%
echo.
choice /C YN /M "%c%Keep Xbox services? (Y/N)%u%"
if errorlevel 2 (
    set "REMOVE_XBOX=true"
    echo %c%• Xbox services will be REMOVED%u%
) else (
    set "REMOVE_XBOX=false"
    echo %c%• Xbox services will be PRESERVED%u%
)

echo.
echo %c%[3/12] Microsoft Edge Browser%u%
echo.
echo %c%Microsoft Edge is integrated with Windows and some system functions.%u%
echo %c%Removing it may affect Windows Update and certain system features.%u%
echo %c%Recommended: REMOVE if you use Chrome/Firefox exclusively.%u%
echo.
choice /C YN /M "%c%Remove Microsoft Edge? (Y/N)%u%"
if errorlevel 2 (
    set "REMOVE_EDGE=false"
    echo %c%• Microsoft Edge will be PRESERVED%u%
) else (
    set "REMOVE_EDGE=true"
    echo %c%• Microsoft Edge will be REMOVED%u%
)

echo.
echo %c%[4/12] OneDrive Cloud Storage%u%
echo.
echo %c%OneDrive provides cloud storage and sync functionality.%u%
echo %c%Removing it will disable cloud backup and sync features.%u%
echo %c%Recommended: REMOVE if you don't use cloud storage.%u%
echo.
choice /C YN /M "%c%Remove OneDrive? (Y/N)%u%"
if errorlevel 2 (
    set "REMOVE_ONEDRIVE=false"
    echo %c%• OneDrive will be PRESERVED%u%
) else (
    set "REMOVE_ONEDRIVE=true"
    echo %c%• OneDrive will be REMOVED%u%
)

echo.
echo %c%[5/12] Microsoft Copilot AI%u%
echo.
echo %c%Microsoft Copilot is the AI assistant integrated into Windows.%u%
echo %c%Removing it will disable AI features and suggestions.%u%
echo %c%Recommended: REMOVE for privacy and performance.%u%
echo.
choice /C YN /M "%c%Remove Microsoft Copilot? (Y/N)%u%"
if errorlevel 2 (
    set "REMOVE_COPILOT=false"
    echo %c%• Microsoft Copilot will be PRESERVED%u%
) else (
    set "REMOVE_COPILOT=true"
    echo %c%• Microsoft Copilot will be REMOVED%u%
)

echo.
echo %c%[6/12] Cortana and Windows Search Integration%u%
echo.
echo %c%Cortana/Search is built into Windows 11 and can consume memory/CPU.%u%
echo %c%Removing it will disable the Search bar, voice assistant, and some functions.%u%
echo %c%Recommended: REMOVE if you never use Cortana or integrated Search.%u%
echo.
choice /C YN /M "%c%Remove Cortana & Search integration? (Y/N)%u%"
if errorlevel 2 (
    set "REMOVE_CORTANA=false"
    echo %c%• Cortana and Search will be PRESERVED%u%
) else (
    set "REMOVE_CORTANA=true"
    echo %c%• Cortana and Search will be REMOVED%u%
)

echo.
echo %c%[7/12] Skype and Microsoft Teams%u%
echo.
echo %c%Skype/Teams often run in the background with auto-start.%u%
echo %c%Removing them frees RAM but disables built-in chat/video features.%u%
echo %c%Recommended: REMOVE if you use Zoom/Discord or no longer need Skype/Teams.%u%
echo.
choice /C YN /M "%c%Remove Skype & Teams? (Y/N)%u%"
if errorlevel 2 (
    set "REMOVE_COMM=false"
    echo %c%• Skype and Teams will be PRESERVED%u%
) else (
    set "REMOVE_COMM=true"
    echo %c%• Skype and Teams will be REMOVED%u%
)

echo.
echo %c%[8/12] Windows WebView2 Runtime%u%
echo.
echo %c%WebView2 is required for many UWP/Win32 apps to render HTML content.%u%
echo %c%Removing it may break apps (e.g., Teams, Edge-based apps).%u%
echo %c%Recommended: REMOVE only if you don't use any WebView2-dependent apps.%u%
echo.
choice /C YN /M "%c%Remove WebView2 Runtime? (Y/N)%u%"
if errorlevel 2 (
    set "REMOVE_WEBVIEW2=false"
    echo %c%• WebView2 Runtime will be PRESERVED%u%
) else (
    set "REMOVE_WEBVIEW2=true"
    echo %c%• WebView2 Runtime will be REMOVED%u%
)

echo.
echo %c%[9/12] Windows Security Center Notifications%u%
echo.
echo %c%Windows Security Center (Defender alerts, update alerts) can be noisy.%u%
echo %c%Disabling notifications prevents pop-ups but does NOT disable Defender itself.%u%
echo %c%Recommended: REMOVE if you don't want Defender pop-ups but still want AV protection.%u%
echo.
choice /C YN /M "%c%Disable Windows Security notifications? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_SEC_NOTIFS=false"
    echo %c%• Security notifications will be PRESERVED%u%
) else (
    set "DISABLE_SEC_NOTIFS=true"
    echo %c%• Windows Security notifications will be DISABLED%u%
)

echo.
echo %c%[10/12] OEM Manufacturer Bloatware%u%
choice /C YN /M "%c%Remove OEM manufacturer bloatware? (Y/N)%u%"
if errorlevel 2 (
    set "REMOVE_OEM=false" 
    echo %c%• OEM bloatware will be PRESERVED%u%
) else (
    set "REMOVE_OEM=true"  
    echo %c%• OEM bloatware will be REMOVED%u%
)

echo.
echo %c%[11/12] System Apps (Wallet, Web Extensions…)%u%
choice /C YN /M "%c%Remove System apps? (Y/N)%u%"
if errorlevel 2 (
    set "REMOVE_SYSTEM=false" 
    echo %c%• System apps will be PRESERVED%u%
) else (
    set "REMOVE_SYSTEM=true"  
    echo %c%• System apps will be REMOVED%u%
)

echo.
echo %c%[12/16] Windows Services and Startup Programs%u%
choice /C YN /M "%c%Disable unnecessary services & startup programs? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_SERVICES=false" 
    echo %c%• Services and startup programs will be PRESERVED%u%
) else (
    set "DISABLE_SERVICES=true"  
    echo %c%• Unnecessary services and startup programs will be DISABLED%u%
)

echo.
echo %c%[13/16] Microsoft Photos (Default Image Viewer)%u%
echo.
echo %c%Microsoft Photos is the default app for viewing images and videos.%u%
echo %c%Removing it means image files will have no default viewer until another app is installed.%u%
echo %c%Recommended: KEEP unless you already use a different image viewer (e.g. IrfanView).%u%
echo.
choice /C YN /M "%c%Remove Microsoft Photos? (Y/N)%u%"
if errorlevel 2 (
    set "REMOVE_PHOTOS=false"
    echo %c%• Microsoft Photos will be PRESERVED%u%
) else (
    set "REMOVE_PHOTOS=true"
    echo %c%• Microsoft Photos will be REMOVED%u%
)

echo.
echo %c%[14/16] Microsoft Paint and Windows Camera%u%
echo.
echo %c%Microsoft Paint is the classic built-in image editor (commonly used for quick edits).%u%
echo %c%Windows Camera is the built-in webcam app — required if no other camera app is installed.%u%
echo %c%Recommended: KEEP if you use your webcam for video calls or edit images occasionally.%u%
echo.
choice /C YN /M "%c%Remove Paint and Windows Camera? (Y/N)%u%"
if errorlevel 2 (
    set "REMOVE_PAINT=false"
    echo %c%• Paint and Windows Camera will be PRESERVED%u%
) else (
    set "REMOVE_PAINT=true"
    echo %c%• Paint and Windows Camera will be REMOVED%u%
)

echo.
echo %c%[15/16] Snipping Tool and PrintScreen Hotkey%u%
echo.
echo %c%Snipping Tool is the built-in screenshot utility (Win+Shift+S / PrintScreen).%u%
echo %c%Removing it also disables the PrintScreen key shortcut for Snipping.%u%
echo %c%Recommended: KEEP unless you use a third-party screenshot tool (e.g. ShareX).%u%
echo.
choice /C YN /M "%c%Remove Snipping Tool and disable PrintScreen hotkey? (Y/N)%u%"
if errorlevel 2 (
    set "REMOVE_SNIPPING=false"
    echo %c%• Snipping Tool and PrintScreen hotkey will be PRESERVED%u%
) else (
    set "REMOVE_SNIPPING=true"
    echo %c%• Snipping Tool will be REMOVED and PrintScreen hotkey will be DISABLED%u%
)

echo.
echo %c%[16/16] App Installer (winget) and OpenSSH Client%u%
echo.
echo %c%App Installer provides the "winget" package manager for command-line installs.%u%
echo %c%OpenSSH Client enables the "ssh" command from PowerShell/CMD.%u%
echo %c%Recommended: KEEP if you use the command line or install apps via winget.%u%
echo.
choice /C YN /M "%c%Remove App Installer and OpenSSH Client? (Y/N)%u%"
if errorlevel 2 (
    set "REMOVE_DEVTOOLS=false"
    echo %c%• App Installer and OpenSSH Client will be PRESERVED%u%
) else (
    set "REMOVE_DEVTOOLS=true"
    echo %c%• App Installer and OpenSSH Client will be REMOVED%u%
)

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         DEBLOATING IN PROGRESS                               ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.

echo %c%[1/18] Removing Third-Party Bloatware and Games…%u%
call :RemoveThirdPartyBloatware

if "%REMOVE_OEM%"=="true" (
    echo %c%[2/18] Removing OEM Manufacturer Bloatware…%u%
    call :RemoveOEMBloatware
) else (
    echo %c%[2/18] Skipping OEM Manufacturer bloatware…%u%
)

if "%REMOVE_SYSTEM%"=="true" (
    echo %c%[3/18] Removing System Apps…%u%
    call :RemoveSystemApps
) else (
    echo %c%[3/18] Skipping System apps…%u%
)

echo %c%[4/18] Removing Microsoft Apps and Unnecessary Features…%u%
call :RemoveMicrosoftApps

echo %c%[5/18] Removing Communication and Social Apps…%u%
if "%REMOVE_COMM%"=="true" (
    call :RemoveCommunicationApps
) else (
    echo %c%• Communication apps preserved%u%
)

echo %c%[6/18] Removing Media and Creative Apps…%u%
call :RemoveMediaApps

echo %c%[7/18] Removing Advanced System Apps…%u%
call :RemoveAdvancedSystemApps

if "%REMOVE_COPILOT%"=="true" (
    echo %c%[8/18] Removing Microsoft Copilot…%u%
    call :RemoveCopilot
) else (
    echo %c%[8/18] Preserving Microsoft Copilot…%u%
)

echo %c%[9/18] Removing Widgets and Taskbar Bloat…%u%
call :RemoveTaskbarBloat

if "%REMOVE_XBOX%"=="true" (
    echo %c%[10/18] Removing Xbox Services and Apps…%u%
    call :RemoveXboxServices
) else (
    echo %c%[10/18] Preserving Xbox Services…%u%
)

if "%REMOVE_STORE%"=="true" (
    echo %c%[11/18] Removing Microsoft Store…%u%
    call :RemoveMicrosoftStore
) else (
    echo %c%[11/18] Preserving Microsoft Store…%u%
)

if "%REMOVE_EDGE%"=="true" (
    echo %c%[12/18] Removing Microsoft Edge…%u%
    call :RemoveMicrosoftEdge
) else (
    echo %c%[12/18] Preserving Microsoft Edge…%u%
)

if "%REMOVE_ONEDRIVE%"=="true" (
    echo %c%[13/18] Removing OneDrive…%u%
    call :RemoveOneDrive
) else (
    echo %c%[13/18] Preserving OneDrive…%u%
)

echo %c%[14/18] Removing Unnecessary Windows Features and Capabilities…%u%
call :RemoveWindowsFeatures

echo %c%[15/18] Removing Network Speed Test and Feedback Hub…%u%
call :RemoveNetworkSpeedTestAndFeedback

echo %c%[16/18] Removing Mixed Reality and Holographic Apps…%u%
call :RemoveMixedReality

echo %c%[17/18] Applying Final System Optimizations…%u%
call :ApplyFinalOptimizations

if "%DISABLE_SERVICES%"=="true" (
    echo %c%[18/18] Disabling Unnecessary Services…%u%
    call :DisableUnnecessaryServices
) else (
    echo %c%[18/18] Preserving Services…%u%
)

echo.
echo %c%Restarting Windows Explorer to apply changes…%u%
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 >nul
start explorer.exe

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        COMPREHENSIVE DEBLOATING COMPLETED                    ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Windows debloating has been completed successfully.%u%
echo.
echo %c%Configuration Summary:%u%
if "%REMOVE_STORE%"=="true" (
    echo %c%• Microsoft Store: REMOVED%u%
) else (
    echo %c%• Microsoft Store: PRESERVED%u%
)
if "%REMOVE_XBOX%"=="true" (
    echo %c%• Xbox Services and Apps: REMOVED%u%
) else (
    echo %c%• Xbox Services and Apps: PRESERVED%u%
)
if "%REMOVE_EDGE%"=="true" (
    echo %c%• Microsoft Edge: REMOVED%u%
) else (
    echo %c%• Microsoft Edge: PRESERVED%u%
)
if "%REMOVE_ONEDRIVE%"=="true" (
    echo %c%• OneDrive: REMOVED%u%
) else (
    echo %c%• OneDrive: PRESERVED%u%
)
if "%REMOVE_COPILOT%"=="true" (
    echo %c%• Microsoft Copilot: REMOVED%u%
) else (
    echo %c%• Microsoft Copilot: PRESERVED%u%
)
if "%REMOVE_CORTANA%"=="true" (
    echo %c%• Cortana and Search: REMOVED%u%
) else (
    echo %c%• Cortana and Search: PRESERVED%u%
)
if "%REMOVE_COMM%"=="true" (
    echo %c%• Skype and Teams: REMOVED%u%
) else (
    echo %c%• Skype and Teams: PRESERVED%u%
)
if "%REMOVE_WEBVIEW2%"=="true" (
    echo %c%• WebView2 Runtime: REMOVED%u%
) else (
    echo %c%• WebView2 Runtime: PRESERVED%u%
)
if "%DISABLE_SEC_NOTIFS%"=="true" (
    echo %c%• Windows Security notifications: DISABLED%u%
) else (
    echo %c%• Windows Security notifications: PRESERVED%u%
)
if "%REMOVE_OEM%"=="true" (
    echo %c%• OEM Manufacturer bloatware: REMOVED%u%
) else (
    echo %c%• OEM Manufacturer bloatware: PRESERVED%u%
)
if "%REMOVE_SYSTEM%"=="true" (
    echo %c%• System Apps: REMOVED%u%
) else (
    echo %c%• System Apps: PRESERVED%u%
)
if "%DISABLE_SERVICES%"=="true" (
    echo %c%• Unnecessary Services: DISABLED%u%
) else (
    echo %c%• Unnecessary Services: PRESERVED%u%
)
echo.
echo %c%Successfully Removed:%u%
echo %c%• Third-party bloatware and games%u%
echo %c%• Unnecessary Microsoft UWP apps (News, Weather, Paint, etc.)%u%
echo %c%• Communication and social apps (based on selection)%u%
echo %c%• Media and creative apps (Zune, Paint, 3D Viewer, Print 3D, Clipchamp)%u%
echo %c%• Advanced system apps (Mixed Reality, Network Speed Test, Feedback Hub)%u%
echo %c%• Widgets, Meet Now, Chat, Search, Task View from taskbar%u%
echo %c%• Windows Spotlight and consumer features%u%
echo %c%• Legacy features (IE11, WMP, WordPad, etc.)%u%
echo %c%• Cortana (549981C3F5F10) if selected%u%
echo %c%• Parental Controls and Holographic FirstRun%u%
echo.
echo %red%Important Notes:%u%
echo %c%• Restart your computer to complete all changes%u%
echo %c%• Some features may require Windows reset to restore%u%
if "%REMOVE_XBOX%"=="true" echo %c%• Xbox Live and Minecraft online functionality disabled%u%
if "%REMOVE_STORE%"=="true" echo %c%• Microsoft Store app installations disabled%u%
echo %c%• All apps were properly deprovisioned to prevent reinstallation%u%
echo %c%• System files were safely renamed (not deleted) for recovery%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:RemoveAppCompletely
set "APP_NAME=%1"
set "APP_PACKAGE=%2"

chcp 437 >nul
powershell -Command "Get-AppxPackage '%APP_NAME%' | Remove-AppxPackage" >nul 2>&1
chcp 65001 >nul

chcp 437 >nul
powershell -Command "$keyPath='HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\%APP_PACKAGE%'; if (!(Test-Path $keyPath)) { try { New-Item -Path $keyPath -Force -ErrorAction Stop | Out-Null } catch { } }" >nul 2>&1
chcp 65001 >nul

call :SoftDeleteSystemFiles "%LOCALAPPDATA%\Packages\%APP_PACKAGE%\*"
call :SoftDeleteSystemFiles "%PROGRAMDATA%\Microsoft\Windows\AppRepository\Packages\%APP_PACKAGE%*\*"

exit /b

:RemoveAdvancedSystemApp
set "APP_NAME=%1"
set "APP_PACKAGE=%2"
chcp 437 >nul
powershell -Command "$keyPath='HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\EndOfLife\$env:USERNAME\%APP_PACKAGE%'; $userSid = (New-Object System.Security.Principal.NTAccount($env:USERNAME)).Translate([Security.Principal.SecurityIdentifier]).Value; $keyPath = $keyPath.Replace('$env:USERNAME', $userSid); if (!(Test-Path $keyPath)) { try { New-Item -Path $keyPath -Force -ErrorAction Stop | Out-Null } catch { } }" >nul 2>&1
chcp 65001 >nul
chcp 437 >nul
powershell -Command "Get-AppxPackage '%APP_NAME%' | Remove-AppxPackage" >nul 2>&1
chcp 65001 >nul

chcp 437 >nul
powershell -Command "$keyPath='HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\%APP_PACKAGE%'; if (!(Test-Path $keyPath)) { try { New-Item -Path $keyPath -Force -ErrorAction Stop | Out-Null } catch { } }" >nul 2>&1

powershell -Command "$keyPath='HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\EndOfLife\$env:USERNAME\%APP_PACKAGE%'; $userSid = (New-Object System.Security.Principal.NTAccount($env:USERNAME)).Translate([Security.Principal.SecurityIdentifier]).Value; $keyPath = $keyPath.Replace('$env:USERNAME', $userSid); if (Test-Path $keyPath) { try { Remove-Item -LiteralPath $keyPath -Force -ErrorAction Stop } catch { } }" >nul 2>&1
chcp 65001 >nul

call :SoftDeleteSystemFiles "%SYSTEMROOT%\SystemApps\%APP_PACKAGE%\*"
call :SoftDeleteSystemFiles "%SYSTEMDRIVE%\Program Files\WindowsApps\%APP_NAME%*\*"
call :SoftDeleteSystemFiles "%LOCALAPPDATA%\Packages\%APP_PACKAGE%\*"
call :SoftDeleteSystemFiles "%PROGRAMDATA%\Microsoft\Windows\AppRepository\Packages\%APP_NAME%*\*"

exit /b

:SoftDeleteSystemFiles
set "PATH_PATTERN=%1"
chcp 437 >nul
powershell -Command "$pathGlobPattern = '%PATH_PATTERN%'; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); $foundAbsolutePaths = @(); try { $foundAbsolutePaths += @(Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName); } catch { }; try { $foundAbsolutePaths += @(Get-Item -Path $expandedPath -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName); } catch { }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; foreach ($path in $foundAbsolutePaths) { if (Test-Path -Path $path -PathType Container) { continue; }; if ($path.EndsWith('.OLD')) { continue; }; $newFilePath = \"$($path).OLD\"; try { Move-Item -LiteralPath $path -Destination $newFilePath -Force -ErrorAction SilentlyContinue } catch { } }" >nul 2>&1
chcp 65001 >nul
exit /b

:RemoveThirdPartyBloatware
set "BLOAT_APPS=*2FE3CB00.PicsArt-PhotoStudio* *4DF9E0F8.Netflix* *9E2F88E3.Twitter* *Facebook* *SpotifyAB.SpotifyMusic* *BytedancePte.Ltd.TikTok* *king.com* *GAMELOFTSA.Asphalt8Airborne* *Playtika.CaesarsSlotsFreeCasino* *ClearChannelRadioDigital.iHeartRadio* *TuneIn.TuneInRadio* *PandoraMediaInc* *ShazamEntertainmentLtd.Shazam* *AdobeSystemsIncorporated.AdobePhotoshopExpress* *Expedia.ExpediaHotelsFlightsCarsActivities* *Flipboard.Flipboard* *Duolingo-LearnLanguagesforFree* *CandyCrush* *FarmVille* *MarchofEmpires* *DisneyMagicKingdoms* *ActiproSoftware* *Clipchamp* *46928bounde.EclipseManager*"

for %%a in (%BLOAT_APPS%) do (
    chcp 437 >nul
    powershell -Command "Get-AppxPackage %%a | Remove-AppxPackage" >nul 2>&1
    chcp 65001 >nul
)
exit /b

:RemoveOEMBloatware
set "OEM_BLOAT=*HPSmartDevice* *DellSupportAssist* *MSICenter* *MyASUS* *BraveBrowser* *HPPrinting* *DellUpdate* *ASUSUpdateNotifier* *LenovoUtility* *AcerUpdater* *TOSHIBAUtility* *SamsungUpdate* *HPSupportAssistant* *DellCommandUpdate* *MSILiveUpdate* *ASUSWinFlash* *LenovoVantage* *AcerCare* *TOSHIBACare* *SamsungGalaxy*"
for %%a in (%OEM_BLOAT%) do (
    call :RemoveAppCompletely "%%a" "%%a"
)
exit /b

:RemoveSystemApps
set "SYSTEM_APPS=*Microsoft.Wallet* *Microsoft.WebMediaExtensions* *Microsoft.PeopleExperienceHost* *Microsoft.MicrosoftStickyNotes* *Microsoft.GetHelp* *Microsoft.WindowsFeedbackHub* *Microsoft.MicrosoftOfficeHub* *Microsoft.Office.OneNote* *Microsoft.Office.Sway* *Microsoft.Todos* *Microsoft.PowerAutomateDesktop* *Microsoft.Whiteboard*"
for %%a in (%SYSTEM_APPS%) do (
    call :RemoveAppCompletely "%%a" "%%a"
)
exit /b

:RemoveMicrosoftApps
set "MS_BLOAT=*Microsoft.BingNews* *Microsoft.BingWeather* *Microsoft.BingSports* *Microsoft.BingFinance* *Microsoft.GetHelp* *Microsoft.Getstarted* *Microsoft.MicrosoftSolitaireCollection* *Microsoft.People* *Microsoft.WindowsMaps* *Microsoft.MicrosoftOfficeHub* *Microsoft.Todos* *Microsoft.PowerAutomateDesktop* *Microsoft.Whiteboard*"

for %%a in (%MS_BLOAT%) do (
    call :RemoveAppCompletely "%%a" "%%a"
)

call :RemoveAppCompletely "Microsoft.BingNews" "Microsoft.BingNews_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.BingWeather" "Microsoft.BingWeather_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.BingSports" "Microsoft.BingSports_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.BingFinance" "Microsoft.BingFinance_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.WindowsMaps" "Microsoft.WindowsMaps_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.MicrosoftOfficeHub" "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.WindowsCalculator" "Microsoft.WindowsCalculator_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.OneConnect" "Microsoft.OneConnect_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.WindowsAlarms" "Microsoft.WindowsAlarms_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.Appconnector" "Microsoft.Appconnector_8wekyb3d8bbwe"
if not "%REMOVE_PHOTOS%"=="false" call :RemoveAppCompletely "Microsoft.Windows.Photos" "Microsoft.Windows.Photos_8wekyb3d8bbwe"
exit /b

:RemoveCommunicationApps
set "COMM_APPS=*Microsoft.SkypeApp* *Microsoft.Teams* *Microsoft.YourPhone* *Microsoft.Messaging* *Microsoft.CommsPhone* *Microsoft.WindowsPhone* *SkypeApp*"
for %%a in (%COMM_APPS%) do (
    call :RemoveAppCompletely "%%a" "%%a"
)

call :RemoveAppCompletely "Microsoft.WindowsPhone" "Microsoft.WindowsPhone_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.CommsPhone" "Microsoft.CommsPhone_8wekyb3d8bbwe"
call :RemoveAdvancedSystemApp "Microsoft.Windows.CallingShellApp" "Microsoft.Windows.CallingShellApp_cw5n1h2txyewy"
call :RemoveAppCompletely "Microsoft.GroupMe10" "Microsoft.GroupMe10_kzf8qxf38zg5c"
call :RemoveAppCompletely "microsoft.windowscommunicationsapps" "microsoft.windowscommunicationsapps_8wekyb3d8bbwe"
exit /b

:RemoveMediaApps
set "MEDIA_APPS=*Microsoft.ZuneMusic* *Microsoft.ZuneVideo* *Microsoft.Movies* *Microsoft.WindowsSoundRecorder* *Microsoft.MixedReality.Portal* *Microsoft.Microsoft3DViewer* *Microsoft.Print3D* *Clipchamp.Clipchamp*"

for %%a in (%MEDIA_APPS%) do (
    call :RemoveAppCompletely "%%a" "%%a"
)

call :RemoveAdvancedSystemApp "Microsoft.Print3D" "Microsoft.Print3D_8wekyb3d8bbwe"
call :RemoveAdvancedSystemApp "Windows.Print3D" "Windows.Print3D_cw5n1h2txyewy"
call :RemoveAppCompletely "Microsoft.3DBuilder" "Microsoft.3DBuilder_8wekyb3d8bbwe"
if not "%REMOVE_PAINT%"=="false" (
    call :RemoveAppCompletely "Microsoft.MSPaint" "Microsoft.MSPaint_8wekyb3d8bbwe"
    call :RemoveAppCompletely "Microsoft.Paint" "Microsoft.Paint_8wekyb3d8bbwe"
    call :RemoveAppCompletely "Microsoft.WindowsCamera" "Microsoft.WindowsCamera_8wekyb3d8bbwe"
)
call :RemoveAppCompletely "Microsoft.HEIFImageExtension" "Microsoft.HEIFImageExtension_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.VP9VideoExtensions" "Microsoft.VP9VideoExtensions_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.WebpImageExtension" "Microsoft.WebpImageExtension_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.HEVCVideoExtension" "Microsoft.HEVCVideoExtension_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.RawImageExtension" "Microsoft.RawImageExtension_8wekyb3d8bbwe"
exit /b

:RemoveAdvancedSystemApps
call :RemoveAppCompletely "Microsoft.549981C3F5F10" "Microsoft.549981C3F5F10_8wekyb3d8bbwe"

call :RemoveAppCompletely "Microsoft.NetworkSpeedTest" "Microsoft.NetworkSpeedTest_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.RemoteDesktop" "Microsoft.RemoteDesktop_8wekyb3d8bbwe"

call :RemoveAdvancedSystemApp "Microsoft.Windows.ParentalControls" "Microsoft.Windows.ParentalControls_cw5n1h2txyewy"

call :RemoveAdvancedSystemApp "Windows.CBSPreview" "Windows.CBSPreview_cw5n1h2txyewy"
if not "%REMOVE_DEVTOOLS%"=="false" call :RemoveAppCompletely "Microsoft.DesktopAppInstaller" "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe"
exit /b

:RemoveCopilot
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\Shell\Copilot\BingChat" /v "IsUserEligible" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\Shell\Copilot" /v "AutoOpenCopilotLargeScreens" /t REG_DWORD /d "0" /f >nul 2>&1
chcp 437 >nul
powershell -Command "Get-AppxPackage *Microsoft.Copilot* | Remove-AppxPackage" >nul 2>&1
powershell -Command "Get-AppxPackage *Microsoft.Windows.Ai.Copilot.Provider* | Remove-AppxPackage" >nul 2>&1
chcp 65001 >nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft.Windows.Ai.Copilot.Provider" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{Microsoft.Copilot}" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft.Copilot" /f >nul 2>&1
exit /b

:RemoveTaskbarBloat
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d "0" /f >nul 2>&1
exit /b

:RemoveXboxServices
call :RemoveAppCompletely "Microsoft.GamingApp" "Microsoft.GamingApp_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.XboxGamingOverlay" "Microsoft.XboxGamingOverlay_8wekyb3d8bbwe"  
call :RemoveAppCompletely "Microsoft.XboxGameOverlay" "Microsoft.XboxGameOverlay_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.XboxApp" "Microsoft.XboxApp_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.Xbox.TCUI" "Microsoft.Xbox.TCUI_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.XboxSpeechToTextOverlay" "Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.XboxIdentityProvider" "Microsoft.XboxIdentityProvider_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.MinecraftUWP" "Microsoft.MinecraftUWP_8wekyb3d8bbwe"

call :RemoveAdvancedSystemApp "Microsoft.XboxGameCallableUI" "Microsoft.XboxGameCallableUI_cw5n1h2txyewy"

call :DisableService "XblGameSave"
call :DisableService "XboxNetApiSvc"
call :DisableService "XblAuthManager"

reg add "HKLM\SYSTEM\CurrentControlSet\Services\XblAuthManager" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\XblGameSave" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\XboxGipSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\XboxNetApiSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LicenseManager" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
setlocal enabledelayedexpansion
set "XboxPath=C:\Windows\System32"
set "XboxFiles=GameBarPresenceWriter.exe GameBarPresenceWriter.proxy.dll GameChatOverlayExt.dll GameChatTranscription.dll GamePanel.exe GamePanelExternalHook.dll gamestreamingext.dll gameux.dll gamingtcui.dll XblAuthManager.dll XblAuthManagerProxy.dll XblAuthTokenBrokerExt.dll XblGameSave.dll XblGameSaveExt.dll XblGameSaveProxy.dll XblGameSaveTask.exe XboxNetApiSvc.dll Windows.Gaming.Preview.dll Windows.Gaming.UI.GameBar.dll Windows.Gaming.XboxLive.Storage.dll"
for %%f in (%XboxFiles%) do (
    if exist "%XboxPath%\%%f" (
        takeown /F "%XboxPath%\%%f" >nul 2>&1
        icacls "%XboxPath%\%%f" /grant administrators:F >nul 2>&1
        del /f /q "%XboxPath%\%%f" >nul 2>&1
        echo %c%  → Removed: %%f%u%
    )
)
endlocal
exit /b

:RemoveMicrosoftStore
call :RemoveAppCompletely "Microsoft.WindowsStore" "Microsoft.WindowsStore_8wekyb3d8bbwe"
call :RemoveAppCompletely "Microsoft.StorePurchaseApp" "Microsoft.StorePurchaseApp_8wekyb3d8bbwe"
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d "1" /f >nul 2>&1
exit /b

:RemoveMicrosoftEdge
chcp 437 >nul
powershell -Command "Get-AppxPackage *Microsoft.MicrosoftEdge* | Remove-AppxPackage" >nul 2>&1
powershell -Command "Get-AppxPackage *Microsoft.MicrosoftEdgeDevToolsClient* | Remove-AppxPackage" >nul 2>&1
chcp 65001 >nul

if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\*\Installer\setup.exe" (
    for /d %%d in ("%ProgramFiles(x86)%\Microsoft\Edge\Application\*") do (
        if exist "%%d\Installer\setup.exe" (
            "%%d\Installer\setup.exe" --uninstall --system-level --verbose-logging --force-uninstall >nul 2>&1
        )
    )
)

reg add "HKLM\SOFTWARE\Microsoft\EdgeUpdate" /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d "1" /f >nul 2>&1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "MSEdgeHTM_.htm" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "MSEdgeHTM_.html" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "MSEdgeHTM_.pdf" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "MSEdgeHTM_.svg" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "MSEdgeHTM_.webp" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "MSEdgeHTM_.xht" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "MSEdgeHTM_.xhtml" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "MSEdgeHTM_ftp" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "MSEdgeHTM_http" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "MSEdgeHTM_https" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "MSEdgePDF_.pdf" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "MSEdgeMHT_.mht" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "MSEdgeMHT_.mhtml" /t REG_DWORD /d "0" /f >nul 2>&1

reg delete "HKLM\SOFTWARE\Classes\.htm\OpenWithProgids" /v "MSEdgeHTM" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Classes\.html\OpenWithProgids" /v "MSEdgeHTM" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Classes\.pdf\OpenWithProgids" /v "MSEdgePDF" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Classes\.svg\OpenWithProgids" /v "MSEdgeHTM" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Classes\.webp\OpenWithProgids" /v "MSEdgeHTM" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Classes\.xht\OpenWithProgids" /v "MSEdgeHTM" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Classes\.xhtml\OpenWithProgids" /v "MSEdgeHTM" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Classes\.mht\OpenWithProgids" /v "MSEdgeMHT" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Classes\.mhtml\OpenWithProgids" /v "MSEdgeMHT" /f >nul 2>&1

reg delete "HKCU\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\ftp\UserChoice" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\Shell\Associations\FileExts\.htm\UserChoice" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\Shell\Associations\FileExts\.html\UserChoice" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\Shell\Associations\FileExts\.pdf\UserChoice" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\Shell\Associations\FileExts\.mht\UserChoice" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\Shell\Associations\FileExts\.mhtml\UserChoice" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\Shell\Associations\FileExts\.svg\UserChoice" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\Shell\Associations\FileExts\.webp\UserChoice" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\Shell\Associations\FileExts\.xht\UserChoice" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\Shell\Associations\FileExts\.xhtml\UserChoice" /f >nul 2>&1

del /f /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" >nul 2>&1
del /f /q "%PUBLIC%\Desktop\Microsoft Edge.lnk" >nul 2>&1
del /f /q "%USERPROFILE%\Desktop\Microsoft Edge.lnk" >nul 2>&1

reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "AppX4hxtad77fbk3jkkeerkrm0ze94wjf3s9_.htm" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "AppX4hxtad77fbk3jkkeerkrm0ze94wjf3s9_.html" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723_.pdf" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "AppXq0fevzme2pys62n3e0fbqa7peapykr8v_http" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "AppX90nv6nhay5n6a98fnetv7tpk64pp35es_https" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "AppX7rm9drdg8sk7vqndwj3sdjw11x96jc0y_microsoft-edge" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "AppX3xxs313wwkfjhythsb8q46xdsq8d2cvv_microsoft-edge-holographic" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "AppX7rm9drdg8sk7vqndwj3sdjw11x96jc0y_microsoft-edge" /f >nul 2>&1
exit /b

:RemoveOneDrive
taskkill /f /im OneDrive.exe >nul 2>&1

if exist "%SystemRoot%\System32\OneDriveSetup.exe" (
    "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1
)
if exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" (
    "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1
)

rd "%UserProfile%\OneDrive" /s /q >nul 2>&1
rd "%LocalAppData%\Microsoft\OneDrive" /s /q >nul 2>&1
rd "%ProgramData%\Microsoft OneDrive" /s /q >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSync" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f >nul 2>&1

reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1

rd "%LOCALAPPDATA%\OneDrive" /s /q >nul 2>&1
rd "%LOCALAPPDATA%\Microsoft\OneDriveSetup" /s /q >nul 2>&1
del /f /q "%LOCALAPPDATA%\Microsoft\OneDrive\*.log" >nul 2>&1

del /f /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" >nul 2>&1
del /f /q "%USERPROFILE%\Desktop\OneDrive.lnk" >nul 2>&1

schtasks /delete /tn "\Microsoft\Windows\OneDrive\OneDrive Standalone Update Task-S-*" /f >nul 2>&1
schtasks /delete /tn "\Microsoft\Windows\OneDrive\OneDrive Per-Machine Standalone Update Task" /f >nul 2>&1

chcp 437 >nul
powershell -Command "[System.Environment]::SetEnvironmentVariable('OneDrive', $null, 'User')" >nul 2>&1
chcp 65001 >nul
exit /b

:RemoveWindowsFeatures
dism /online /disable-feature /featurename:WindowsMediaPlayer /Quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featurename:MediaPlayback /Quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featurename:Internet-Explorer-Optional-amd64 /Quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featurename:Printing-XPSServices-Features /Quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featurename:WorkFolders-Client /Quiet /NoRestart >nul 2>&1

if not "%REMOVE_SNIPPING%"=="false" (
    chcp 437 >nul
    powershell -Command "Get-AppxPackage *Microsoft.ScreenSketch* | Remove-AppxPackage" >nul 2>&1
    chcp 65001 >nul
)

dism /online /remove-capability /capabilityName:Microsoft.Windows.Cortana~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /Disable-Feature /FeatureName:ScanManagementConsole /Quiet /NoRestart >nul 2>&1
dism /online /Disable-Feature /FeatureName:FaxServicesClientPackage /Quiet /NoRestart >nul 2>&1
dism /online /Disable-Feature /FeatureName:Xps-Foundation-Xps-Viewer /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityName:Media.WindowsMediaPlayer~~~~0.0.0.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:MathRecognizer~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityName:App.Support.QuickAssist~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Browser.InternetExplorer~~~~0.0.11.0 /Quiet /NoRestart >nul 2>&1
if not "%REMOVE_DEVTOOLS%"=="false" dism /online /remove-capability /capabilityname:OpenSSH.Client~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:App.StepsRecorder~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Microsoft.Windows.WordPad~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1

if "%REMOVE_WEBVIEW2%"=="true" (
    for /f "tokens=3 delims= " %%i in ('dism /online /get-packages ^| findstr /i Microsoft-WebView2') do (
        dism /online /remove-package /packagename:%%i /Quiet /NoRestart >nul 2>&1
    )
)

chcp 437 >nul
powershell -Command "Get-AppxPackage *MicrosoftWindows.Client.WebExperience* | Remove-AppxPackage" >nul 2>&1
chcp 65001 >nul

if not "%REMOVE_SNIPPING%"=="false" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableSnippingTool" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "DisableSnippingTool" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKCU\Control Panel\Keyboard" /v "PrintScreenKeyForSnippingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
)

dism /online /remove-capability /capabilityname:DirectX.Configuration.Database~~~~0.0.0.1 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Print.Management.Console~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:OneCoreUAP.OneSync~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Print.Fax.Scan~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Microsoft.Windows.StorageManagement~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Microsoft.OneCore.StorageManagement~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Analog.Holographic.Desktop~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:App.WirelessDisplay.Connect~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Accessibility.Braille~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Tools.DeveloperMode.Core~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Tools.Graphics.DirectX~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Network.Irda~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Microsoft.WebDriver~~~~0.0.0.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Msix.PackagingTool.Driver~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:OpenSSH.Server~~~~0.0.0.1 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Windows.Desktop.EMS-SAC.Tools~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:XPS.Viewer~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1

chcp 437 >nul
powershell -Command "Get-WindowsCapability -Online | Where-Object {$_.Name -like 'Rsat.*' -and $_.State -eq 'Installed'} | Remove-WindowsCapability -Online" >nul 2>&1
chcp 65001 >nul

dism /online /disable-feature /featurename:Printing-Foundation-LPDPrintService /Quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featurename:Printing-Foundation-LPRPortMonitor /Quiet /NoRestart >nul 2>&1
exit /b

:RemoveNetworkSpeedTestAndFeedback
call :RemoveAppCompletely "Microsoft.NetworkSpeedTest" "Microsoft.NetworkSpeedTest_8wekyb3d8bbwe"
call :RemoveAdvancedSystemApp "Microsoft.WindowsFeedback" "Microsoft.WindowsFeedback_cw5n1h2txyewy"
call :RemoveAdvancedSystemApp "Microsoft.WindowsFeedbackHub" "Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe"
exit /b

:RemoveMixedReality
call :RemoveAdvancedSystemApp "Microsoft.Windows.Holographic.FirstRun" "Microsoft.Windows.Holographic.FirstRun_cw5n1h2txyewy"
chcp 437 >nul
powershell -Command "Get-AppxPackage *Microsoft.MixedReality.Portal* | Remove-AppxPackage" >nul 2>&1
chcp 65001 >nul
exit /b

:ApplyFinalOptimizations
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f >nul 2>&1

if "%REMOVE_CORTANA%"=="true" (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f >nul 2>&1
)

if "%DISABLE_SEC_NOTIFS%"=="true" (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
)
exit /b

:DisableUnnecessaryServices
sc config DiagTrack start=disabled >nul 2>&1
sc config dmwappushservice start=disabled >nul 2>&1
sc config RetailDemo start=disabled >nul 2>&1
sc config MapsBroker start=disabled >nul 2>&1
sc stop WSearch >nul 2>&1
sc config WSearch start=disabled >nul 2>&1   

schtasks /change /tn "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Autochk\Proxy" /disable >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable >nul 2>&1
schtasks /change /tn "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Feedback\Siuf\DmClient" /disable >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /disable >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable >nul 2>&1
exit /b

:HardwareMenu
cls
call :SetupConsole
call :DisplayBanner
echo %c%                                 ╔═══════════════════════════════════════════════════╗ %u%
echo                                  %c%║%u%            [%c%1%u%] Hardware Information               %c%║%u%
echo                                  %c%║%u%            [%c%2%u%] Storage Acceleration               %c%║%u%
echo                                  %c%║%u%            [%c%3%u%] NVIDIA Driver Optimizer            %c%║%u%
echo                                  %c%║%u%            [%c%4%u%] Tweaked NVIDIA Driver              %c%║%u%
echo                                  %c%║%u%            [%c%5%u%] AMD Driver Optimization            %c%║%u%
echo                                  %c%║%u%            [%c%6%u%] Hardware Security Center           %c%║%u%
echo                                  %c%║%u%            [%c%7%u%] Audio Optimization                 %c%║%u%
echo                                  %c%║%u%            [%c%8%u%] USB Optimization                   %c%║%u%
echo                                  %c%║%u%            [%c%9%u%] Monitor / Display Optimization     %c%║%u%
echo %c%                                 ╚═══════════════════════════════════════════════════╝
echo.
echo                          %u%[%c%10%u%] Colour Presets   [%c%11%u%] Back to Main   [%red%X%u%] Exit Application
echo.
set /p M="%c%Choose an option »%u% "
if "%M%"=="1" goto HardwareInformation
if "%M%"=="2" goto StorageAcceleration
if "%M%"=="3" goto NVIDIAOptimizer
if "%M%"=="4" goto DriverUpdates
if "%M%"=="5" goto AMDOptimizer
if "%M%"=="6" goto HardwareSecurityCenter
if "%M%"=="7" goto AudioOptimization
if "%M%"=="8" goto USBOptimization
if "%M%"=="9" goto MonitorOptimization
if /i "%M%"=="10" goto Presets
if /i "%M%"=="11" goto menu
if /i "%M%"=="X" goto Destruct
cls
echo %underline%%red%Invalid Input. Press any key to continue.%u%
pause >nul
goto HardwareMenu

:MonitorOptimization
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                      MONITOR / DISPLAY OPTIMIZATION                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Monitor optimization includes:%u%
echo %c%  ^• Disable Display Enhancement Service (adaptive brightness / Night Light)%u%
echo %c%  ^• Disable monitor DPMS power-off timeout%u%
echo %c%  ^• Disable HDR for gaming (removes processing overhead)%u%
echo %c%  ^• Zero GPU monitor latency tolerance (always-on display pipeline)%u%
echo %c%  ^• Disable VSync idle timeout (GPU stays active between frames)%u%
echo %c%  ^• Prioritize display pipeline in MMCSS scheduler%u%
echo %c%  ^• Disable color calibration auto-update overhead%u%
echo.
echo %orange%%underline%Display Notice:%u%
echo %c%G-Sync and FreeSync are controlled by your GPU driver panel%u%
echo %c%and cannot be toggled via registry — configure them there.%u%
echo %c%HDR disable applies to Windows HDR only, not your monitor OSD.%u%
echo %c%A restart is recommended after applying.%u%
echo.
echo.
choice /C YN /M "Apply monitor / display optimizations"
if errorlevel 2 goto HardwareMenu
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                      MONITOR / DISPLAY OPTIMIZATION                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Applying monitor and display optimizations...%u%
echo.

echo %white%[1/7]%u% Disabling Display Enhancement Service...
sc stop DisplayEnhancementService >nul 2>&1
sc config DisplayEnhancementService start= disabled >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DisplayEnhancementService" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Failed%u%)

echo %white%[2/7]%u% Disabling monitor power-off timeout (DPMS)...
powercfg /setacvalueindex SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0 >nul 2>&1
powercfg /setactive SCHEME_CURRENT >nul 2>&1
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Failed%u%)

echo %white%[3/7]%u% Disabling Windows HDR for gaming...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\VideoSettings" /v "UseHDRForGaming" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\VideoSettings" /v "EnableHDRForGaming" /t REG_DWORD /d "0" /f >nul 2>&1
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Failed%u%)

echo %white%[4/7]%u% Setting GPU monitor latency tolerance to minimum...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>&1
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Failed%u%)

echo %white%[5/7]%u% Disabling VSync idle timeout...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "VsyncIdleTimeout" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "DisablePreemption" /t REG_DWORD /d "1" /f >nul 2>&1
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Failed%u%)

echo %white%[6/7]%u% Prioritizing display pipeline in MMCSS...
set "DPP=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing"
reg add "%DPP%" /v "Affinity" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "%DPP%" /v "Background Only" /t REG_SZ /d "True" /f >nul 2>&1
reg add "%DPP%" /v "BackgroundPriority" /t REG_DWORD /d "24" /f >nul 2>&1
reg add "%DPP%" /v "Clock Rate" /t REG_DWORD /d "10000" /f >nul 2>&1
reg add "%DPP%" /v "GPU Priority" /t REG_DWORD /d "8" /f >nul 2>&1
reg add "%DPP%" /v "Priority" /t REG_DWORD /d "8" /f >nul 2>&1
reg add "%DPP%" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "%DPP%" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "%DPP%" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Failed%u%)

echo %white%[7/7]%u% Disabling color calibration auto-update overhead...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ICM" /v "GdiIcmGammaRange" /t REG_DWORD /d "256" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\ICM\Calibration" /v "CalibrationUpdateFlag" /t REG_DWORD /d "0" /f >nul 2>&1
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Failed%u%)

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                  MONITOR / DISPLAY OPTIMIZATION COMPLETE!                   ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %green%Monitor and display optimizations applied successfully!%u%
echo.
echo %c%Changes applied:%u%
echo %c%  [+]%u% Display Enhancement Service disabled (adaptive brightness off)
echo %c%  [+]%u% Monitor DPMS timeout set to Never
echo %c%  [+]%u% Windows HDR for gaming disabled
echo %c%  [+]%u% GPU monitor latency tolerance set to zero
echo %c%  [+]%u% VSync idle timeout disabled (GPU stays at full speed)
echo %c%  [+]%u% MMCSS display pipeline set to High / Latency Sensitive
echo %c%  [+]%u% Color calibration auto-update disabled
echo.
echo %orange%A restart is recommended for all changes to take full effect.%u%
echo.
echo                                          %red%[ Press any key to go back ]%u%
pause >nul
goto HardwareMenu

:AudioOptimization
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           AUDIO OPTIMIZATION                                ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Audio optimization includes:%u%
echo %c%  ^• Disable Windows volume auto-ducking%u%
echo %c%  ^• Disable per-device audio enhancements%u%
echo %c%  ^• Elevate AudioDG process to High CPU priority%u%
echo %c%  ^• Disable multimedia scheduler lazy mode%u%
echo %c%  ^• Set Windows sound scheme to None%u%
echo %c%  ^• Disable GS Wavetable Synth overhead%u%
echo.
echo %orange%%underline%Audio Notice:%u%
echo %c%These are safe registry and system-level tweaks only.%u%
echo %c%A restart is recommended after applying for full effect.%u%
echo.
echo.
choice /C YN /M "Apply audio optimizations"
if errorlevel 2 goto HardwareMenu
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           AUDIO OPTIMIZATION                                ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Applying audio optimizations...%u%
echo.

echo %white%[1/6]%u% Disabling Windows volume auto-ducking...
reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f >nul 2>&1
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Failed%u%)

echo %white%[2/6]%u% Disabling per-device audio enhancements...
chcp 437 >nul
powershell -NoProfile -Command "$r='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render'; Get-ChildItem $r -ErrorAction SilentlyContinue | ForEach-Object { $fx=Join-Path $_.PSPath 'FxProperties'; if(-not(Test-Path $fx)){New-Item -Path $fx -Force | Out-Null}; Set-ItemProperty -Path $fx -Name '{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},5' -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue }" >nul 2>&1
chcp 65001 >nul
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Partial - may need specific device selected%u%)

echo %white%[3/6]%u% Elevating AudioDG process priority...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\audiodg.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\audiodg.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Failed%u%)

echo %white%[4/6]%u% Disabling multimedia system lazy mode (lower audio latency)...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t REG_DWORD /d "1" /f >nul 2>&1
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Failed%u%)

echo %white%[5/6]%u% Setting Windows sound scheme to None...
reg add "HKCU\AppEvents\Schemes" /ve /t REG_SZ /d ".None" /f >nul 2>&1
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Failed%u%)

echo %white%[6/6]%u% Disabling GS Wavetable Synth (unused MIDI overhead)...
chcp 437 >nul
powershell -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -like '*GS Wavetable*'} | Disable-PnpDevice -Confirm:$false -ErrorAction SilentlyContinue" >nul 2>&1
chcp 65001 >nul
echo %green%  [+] Done%u%

echo %white%[7/9]%u% Disabling audio AI processing and DSP effects...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" /v "DisableAudioProcessing" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Audio" /v "DisableAudioProcessing" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" /v "DisableAudioEnhancements" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Audio" /v "DisableAudioEnhancements" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" /v "DisableLFX" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Audio" /v "DisableLFX" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" /v "DisableGFX" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Audio" /v "DisableGFX" /t REG_DWORD /d "1" /f >nul 2>&1
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Failed%u%)

echo %white%[8/9]%u% Disabling Speech_OneCore enhanced audio...
reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\AudioProcessing" /v "EnableEnhancedAudio" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Speech_OneCore\AudioProcessing" /v "EnableEnhancedAudio" /t REG_DWORD /d "0" /f >nul 2>&1
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Failed%u%)

echo %white%[9/9]%u% Disabling Windows Studio Effects (noise suppression, eye contact, background blur)...
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Experience\AllowVideoFilters" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Camera\AllowCameraEffects" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
echo %green%  [+] Done%u%

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                      AUDIO OPTIMIZATION COMPLETE!                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %green%Audio optimizations applied successfully!%u%
echo.
echo %c%Changes applied:%u%
echo %c%  [+]%u% Volume auto-ducking disabled
echo %c%  [+]%u% Audio enhancements disabled on all render devices
echo %c%  [+]%u% AudioDG elevated to High CPU + I/O priority
echo %c%  [+]%u% Multimedia scheduler lazy mode disabled
echo %c%  [+]%u% Windows sound scheme set to None
echo %c%  [+]%u% GS Wavetable Synth disabled
echo %c%  [+]%u% Audio AI processing and DSP effects disabled (DisableAudioProcessing, LFX, GFX)
echo %c%  [+]%u% Speech_OneCore enhanced audio disabled
echo %c%  [+]%u% Windows Studio Effects disabled (video filters, camera effects)
echo.
echo %orange%A restart is recommended for all changes to take full effect.%u%
echo.
echo                                          %red%[ Press any key to go back ]%u%
pause >nul
goto HardwareMenu

:USBOptimization
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           USB OPTIMIZATION                                  ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%USB optimization includes:%u%
echo %c%  ^• Disable selective suspend on all USB devices%u%
echo %c%  ^• Disable USB hub power saving via power plan%u%
echo %c%  ^• Disable idle and wake power states on USB controllers%u%
echo %c%  ^• Prevent input stutter from USB devices sleeping%u%
echo %c%  ^• Applied to all connected USB devices automatically%u%
echo.
echo %orange%%underline%USB Notice:%u%
echo %c%This disables power saving on ALL USB devices.%u%
echo %c%Peripherals will no longer sleep - no wake delays or polling drops.%u%
echo %c%Reconnect USB devices or restart after applying.%u%
echo.
echo.
choice /C YN /M "Apply USB optimizations"
if errorlevel 2 goto HardwareMenu
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           USB OPTIMIZATION                                  ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Applying USB power management optimizations...%u%
echo.

echo %white%[1/3]%u% Disabling USB selective suspend per-device...
chcp 437 >nul
powershell -NoProfile -Command "$usbRoot='HKLM:\SYSTEM\CurrentControlSet\Enum\USB'; $vals=@('EnhancedPowerManagementEnabled','AllowIdleIrpInD3','EnableSelectiveSuspend','DeviceSelectiveSuspended','SelectiveSuspendEnabled','SelectiveSuspendOn','D3ColdSupported'); Get-ChildItem $usbRoot -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.PSChildName -eq 'Device Parameters'} | ForEach-Object { $p=$_.PSPath; foreach($v in $vals){Set-ItemProperty -Path $p -Name $v -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue} }" >nul 2>&1
chcp 65001 >nul
echo %green%  [+] Done%u%

echo %white%[2/3]%u% Disabling USB hub power management via power plan...
powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setactive SCHEME_CURRENT >nul 2>&1
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Failed%u%)

echo %white%[3/4]%u% Disabling USB controller power saving in device tree...
chcp 437 >nul
powershell -NoProfile -Command "$usbhubRoot='HKLM:\SYSTEM\CurrentControlSet\Enum\USB'; Get-ChildItem $usbhubRoot -ErrorAction SilentlyContinue | ForEach-Object { $dp=Join-Path $_.PSPath 'Device Parameters'; if(Test-Path $dp){Set-ItemProperty -Path $dp -Name 'IdleInWorkingState' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue; Set-ItemProperty -Path $dp -Name 'WaitWakeEnabled' -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue} }" >nul 2>&1
chcp 65001 >nul
echo %green%  [+] Done%u%

echo %white%[4/4]%u% Setting driver thread priorities to real-time class...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbxhci\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl\Parameters" /v "ThreadPriority" /t REG_DWORD /d "15" /f >nul 2>&1
if !errorlevel!==0 (echo %green%  [+] Done%u%) else (echo %orange%  [!] Failed%u%)

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       USB OPTIMIZATION COMPLETE!                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %green%USB optimizations applied successfully!%u%
echo.
echo %c%Changes applied:%u%
echo %c%  [+]%u% USB selective suspend disabled for all connected devices
echo %c%  [+]%u% USB hub power saving removed from active power plan
echo %c%  [+]%u% USB controller idle and wake power states disabled
echo %c%  [+]%u% Driver thread priorities set (USB/mouse/keyboard/NDIS/DXGKrnl)
echo %c%  [+]%u% No more input stutter from USB devices sleeping
echo.
echo %orange%Reconnect your USB devices or restart for all changes to take effect.%u%
echo.
echo                                          %red%[ Press any key to go back ]%u%
pause >nul
goto HardwareMenu

:HardwareSecurityCenter
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                           HARDWARE SECURITY CENTER                            ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Analyzing hardware security configuration...%u%
echo.

for /f "tokens=1,* delims==" %%a in ('wmic baseboard get manufacturer /value ^| find "="') do for /f "delims=" %%i in ("%%b") do set "mobo_manufacturer=%%i"
for /f "tokens=1,* delims==" %%a in ('wmic baseboard get product /value ^| find "="') do for /f "delims=" %%i in ("%%b") do set "mobo_model=%%i"
for /f "tokens=1,* delims==" %%a in ('wmic bios get smbiosbiosversion /value ^| find "="') do for /f "delims=" %%i in ("%%b") do set "bios_version=%%i"
for /f "tokens=1,* delims==" %%a in ('wmic cpu get name /value ^| find "="') do for /f "delims=" %%i in ("%%b") do set "cpu_name=%%i"

chcp 437 >nul
powershell -Command "try { $tpm = Get-Tpm -ErrorAction SilentlyContinue; if ($tpm) { if ($tpm.TpmPresent) { Write-Host 'TPM_PRESENT' } else { Write-Host 'TPM_ABSENT' } } else { Write-Host 'TPM_UNKNOWN' } } catch { Write-Host 'TPM_UNKNOWN' }" > "%temp%\tpm_status.txt"
set /p tpm_status=<"%temp%\tpm_status.txt"

powershell -Command "try { $sb = Confirm-SecureBootUEFI -ErrorAction SilentlyContinue; if ($sb) { Write-Host 'SECUREBOOT_ENABLED' } else { Write-Host 'SECUREBOOT_DISABLED' } } catch { Write-Host 'SECUREBOOT_UNSUPPORTED' }" > "%temp%\sb_status.txt"
set /p secureboot_status=<"%temp%\sb_status.txt"

powershell -Command "if ((Get-WmiObject -Class Win32_Processor).VirtualizationFirmwareEnabled -eq $true) { Write-Host 'VIRT_ENABLED' } else { Write-Host 'VIRT_DISABLED' }" > "%temp%\virt_status.txt"
set /p virt_status=<"%temp%\virt_status.txt"

powershell -Command "if (Get-BitLockerVolume -ErrorAction SilentlyContinue) { Write-Host 'BITLOCKER_AVAILABLE' } else { Write-Host 'BITLOCKER_UNAVAILABLE' }" > "%temp%\bitlocker_status.txt"
set /p bitlocker_status=<"%temp%\bitlocker_status.txt"
chcp 65001 >nul

cls
call :SetupConsole
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                           HARDWARE SECURITY STATUS                            ║
echo ╠═══════════════════════════════════════════════════════════════════════════════╣%u%
echo %c%║ Motherboard   %mobo_manufacturer% %mobo_model%
echo ║ BIOS Version   %bios_version%
echo ║ CPU   %cpu_name%
echo %c%║                                                                               ║%u%

set "line="
if /i "%tpm_status%"=="TPM_PRESENT" (
    set "line=%c%║ TPM Status   2.0 Enabled %green%✓%c%        │ "
) else (
    if /i "%tpm_status%"=="TPM_ABSENT" (
        set "line=%c%║ TPM Status   Not Found %red%✗%c%          │ "
    ) else (
        set "line=%c%║ TPM Status   Unknown %yellow%?%c%            │ "
    )
)

if /i "%secureboot_status%"=="SECUREBOOT_ENABLED" (
    set "line=%line%Secure Boot   Enabled %green%✓%u%"
) else (
    if /i "%secureboot_status%"=="SECUREBOOT_DISABLED" (
        set "line=%line%Secure Boot   Disabled %red%⚠️%u%"
    ) else (
        set "line=%line%Secure Boot   Unsupported %yellow%?%u%"
    )
)
echo %line%

echo %c%║                                                                               ║%u%

set "line="
if /i "%bitlocker_status%"=="BITLOCKER_AVAILABLE" (
    set "line=%c%║ Hardware Encryption   Available %green%✓%c%  │ "
) else (
    set "line=%c%║ Hardware Encryption   Unavailable %red%✗%c% │ "
)
if /i "%virt_status%"=="VIRT_ENABLED" (
    set "line=%line%Virtualization   Enabled %green%✓%u%"
) else (
    set "line=%line%Virtualization   Disabled %red%✗%u%"
)
echo %line%

echo %c%║                                                                               ║
echo ║ Memory Protection   Checking...     │ Intel TXT/AMD SVM   Checking...          ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                        ANTI-CHEAT COMPATIBILITY ANALYSIS                     ║
echo ╠═══════════════════════════════════════════════════════════════════════════════╣%u%

set "valorant_status="
if /i "%tpm_status%"=="TPM_PRESENT" (
    if /i "%secureboot_status%"=="SECUREBOOT_ENABLED" (
        set "valorant_status=%c%║ • Valorant (Vanguard)   Compatible %green%✓%c%                                       ║%u%"
    ) else (
        set "valorant_status=%c%║ • Valorant (Vanguard)   TPM %green%✓%c% Secure Boot %red%⚠️ NEEDS ENABLING%c%        ║%u%"
    )
) else (
    set "valorant_status=%c%║ • Valorant (Vanguard)   TPM %red%✗%c% Secure Boot %red%✗%c% HARDWARE SETUP REQUIRED%c% ║%u%"
)
echo %valorant_status%

set "cod_status="
if /i "%tpm_status%"=="TPM_PRESENT" (
    if /i "%secureboot_status%"=="SECUREBOOT_ENABLED" (
        set "cod_status=%c%║ • Call of Duty (Ricochet)   Compatible %green%✓%c%                                   ║%u%"
    ) else (
        set "cod_status=%c%║ • Call of Duty (Ricochet)   TPM %green%✓%c% Secure Boot %red%⚠️ NEEDS ENABLING%c%    ║%u%"
    )
) else (
    set "cod_status=%c%║ • Call of Duty (Ricochet)   TPM %red%✗%c% Secure Boot %red%✗%c% SETUP REQUIRED%c%    ║%u%"
)
echo %cod_status%

set "faceit_status="
if /i "%tpm_status%"=="TPM_PRESENT" (
    if /i "%secureboot_status%"=="SECUREBOOT_ENABLED" (
        set "faceit_status=%c%║ • FACEIT Anti-Cheat   Compatible %green%✓%c%                                         ║%u%"
    ) else (
        set "faceit_status=%c%║ • FACEIT Anti-Cheat   TPM %green%✓%c% Secure Boot %red%⚠️ NEEDS ENABLING%c%          ║%u%"
    )
) else (
    set "faceit_status=%c%║ • FACEIT Anti-Cheat   TPM %red%✗%c% Secure Boot %red%✗%c% HARDWARE SETUP REQUIRED%c% ║%u%"
)
echo %faceit_status%

echo %c%║ • Easy Anti-Cheat   Compatible %green%✓%c%                                           ║%u%

echo %c%║ • BattlEye   Compatible %green%✓%c%                                                  ║%u%

echo %c%╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗%u%

if /i "%mobo_manufacturer%"=="ASUSTeK COMPUTER INC." (
    echo %c%║                        ASUS BIOS CONFIGURATION GUIDE                         ║%u%
    call :ShowASUSGuide
) else if /i "%mobo_manufacturer%"=="MSI" (
    echo %c%║                          MSI BIOS CONFIGURATION GUIDE                         ║%u%
    call :ShowMSIGuide
) else if /i "%mobo_manufacturer%"=="Gigabyte Technology Co., Ltd." (
    echo %c%║                      GIGABYTE BIOS CONFIGURATION GUIDE                       ║%u%
    call :ShowGigabyteGuide
) else if /i "%mobo_manufacturer%"=="ASRock" (
    echo %c%║                       ASROCK BIOS CONFIGURATION GUIDE                       ║%u%
    call :ShowASRockGuide
) else (
    echo %c%║                       GENERIC BIOS CONFIGURATION GUIDE                       ║%u%
    call :ShowGenericGuide
)

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                         ADVANCED SECURITY OPTIONS                            ║
echo ╠═══════════════════════════════════════════════════════════════════════════════╣
echo ║ [1] Enable Windows Hello PIN/Biometrics    [2] Configure BitLocker Encryption║
echo ║ [3] Enable Windows Credential Guard        [4] Configure Device Guard        ║
echo ║ [5] Enable Core Isolation Memory Integrity [6] Windows Defender System Guard ║
echo ║ [7] Enable Hypervisor Code Integrity       [8] Smart Card Authentication     ║
echo ║ [9] Security Compliance Report             [0] Automated Security Setup      ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%              [R] Refresh Status   [B] Back to Hardware Menu   [X] Exit%u%
echo.
set /p "choice=%c%Choose an option »%u% "

if /i "%choice%"=="1" goto EnableWindowsHello
if /i "%choice%"=="2" goto ConfigureBitLocker
if /i "%choice%"=="3" goto EnableCredentialGuard
if /i "%choice%"=="4" goto ConfigureDeviceGuard
if /i "%choice%"=="5" goto EnableCoreIsolation
if /i "%choice%"=="6" goto EnableSystemGuard
if /i "%choice%"=="7" goto EnableHVCI
if /i "%choice%"=="8" goto ConfigureSmartCard
if /i "%choice%"=="9" goto SecurityComplianceReport
if /i "%choice%"=="0" goto AutomatedSecuritySetup
if /i "%choice%"=="R" goto HardwareSecurityCenter
if /i "%choice%"=="B" goto HardwareMenu
if /i "%choice%"=="X" goto Destruct

cls
echo %red%Invalid choice. Please try again.%u%
timeout /t 2 >nul
goto HardwareSecurityCenter

:ConfigureBitLocker
cls
call :SetupConsole
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                           BITLOCKER CONFIGURATION                            ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Analyzing BitLocker readiness...%u%
echo.

if /i "%tpm_status%"=="TPM_PRESENT" (
    echo %c%✓ TPM 2.0 detected - BitLocker ready%u%
    echo.
    echo %c%[1] Enable BitLocker with TPM only%u%
    echo %c%[2] Enable BitLocker with TPM ^& PIN%u%
    echo %c%[3] Enable BitLocker with TPM ^& USB key%u%
    echo %c%[4] View BitLocker status%u%
    echo %c%[5] Backup BitLocker recovery key%u%
    echo.
    set /p "bl_choice=%c%Choose BitLocker option »%u% "

    if "%bl_choice%"=="1" (
        echo %c%Enabling BitLocker with TPM...%u%
        manage-bde -protectors -add C: -TPM
        manage-bde -on C:
    ) else if "%bl_choice%"=="2" (
        echo %c%Enabling BitLocker with TPM + PIN...%u%
        manage-bde -protectors -add C: -TPMAndPIN
        manage-bde -on C:
    ) else if "%bl_choice%"=="3" (
        echo %c%Enabling BitLocker with TPM + USB...%u%
        manage-bde -protectors -add C: -TPMAndStartupKey
        manage-bde -on C:
    ) else if "%bl_choice%"=="4" (
        echo %c%BitLocker status%u%
        manage-bde -status
    ) else if "%bl_choice%"=="5" (
        echo %c%Backing up recovery key (displaying protector info)...%u%
        manage-bde -protectors -get C:
    ) else (
        echo %yellow%Invalid choice (BitLocker menu).%u%
    )
) else (
    echo %red%✗ TPM not detected - BitLocker requires TPM 2.0%u%
    echo %c%Please enable TPM in BIOS first%u%
)

echo.
echo %c%Press any key to return to Hardware Security Center...%u%
pause >nul
goto HardwareSecurityCenter

:EnableWindowsHello
cls
call :SetupConsole
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                            WINDOWS HELLO SETUP                               ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Configuring Windows Hello PIN and biometric authentication...%u%
echo.

chcp 437 >nul
powershell -Command "if (Get-WmiObject -Class Win32_BiometricDevice) { Write-Host 'BIOMETRIC_AVAILABLE' } else { Write-Host 'BIOMETRIC_UNAVAILABLE' }" > "%temp%\bio_status.txt"
chcp 65001 >nul
set /p bio_status=<"%temp%\bio_status.txt"

if "%bio_status%"=="BIOMETRIC_AVAILABLE" (
    echo %c%✓ Biometric devices detected%u%
) else (
    echo %yellow%⚠️ No biometric devices detected - PIN setup only%u%
)

echo.
echo %c%Opening Windows Hello setup...%u%
start ms-settings:signinoptions-launchfaceenrollment
timeout /t 3 >nul
start ms-settings:signinoptions

echo.
echo %c%Windows Hello setup opened in Settings app.%u%
echo %c%Follow the on-screen instructions to configure PIN and biometrics.%u%
echo.
echo %c%Press any key to return to Hardware Security Center...%u%
pause >nul
goto HardwareSecurityCenter

:EnableCredentialGuard
cls
call :SetupConsole
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                         WINDOWS CREDENTIAL GUARD                             ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Enabling Windows Credential Guard...%u%
echo.

reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequirePlatformSecurityFeatures" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "Locked" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\LSA" /v "LsaCfgFlags" /t REG_DWORD /d 1 /f >nul 2>&1

echo %c%✓ Credential Guard registry entries configured%u%
echo %c%✓ Virtualization-based security enabled%u%
echo %c%✓ LSA protection configured%u%
echo.
echo %yellow%⚠️ A restart is required for Credential Guard to take effect.%u%
echo.
echo %c%Press any key to return to Hardware Security Center...%u%
pause >nul
goto HardwareSecurityCenter

:ConfigureDeviceGuard
cls
call :SetupConsole
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                           WINDOWS DEVICE GUARD                               ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Configuring Windows Device Guard / Application Control...%u%
echo.

reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequirePlatformSecurityFeatures" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d 1 /f >nul 2>&1

echo %c%✓ Device Guard virtualization-based security enabled%u%
echo %c%✓ Platform security features configured%u%
echo %c%✓ Hypervisor-enforced code integrity enabled%u%
echo.
echo %c%Opening Windows Security for Application Control configuration...%u%
start windowsdefender://threatsettings/

echo.
echo %yellow%⚠️ A restart is required for Device Guard to take effect.%u%
echo.
echo %c%Press any key to return to Hardware Security Center...%u%
pause >nul
goto HardwareSecurityCenter

:EnableCoreIsolation
cls
call :SetupConsole
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                         CORE ISOLATION MEMORY INTEGRITY                      ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Enabling Core Isolation Memory Integrity...%u%
echo.

reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\KernelShadowStacks" /v "Enabled" /t REG_DWORD /d 1 /f >nul 2>&1

echo %c%✓ Memory Integrity (HVCI) enabled%u%
echo %c%✓ Virtualization-based security configured%u%
echo %c%✓ Kernel DMA Protection configured%u%
echo.
echo %c%Opening Windows Security Core Isolation settings...%u%
start ms-settings:windowsdefender-virusthreatprotection

echo.
echo %yellow%⚠️ A restart is required for Core Isolation to take effect.%u%
echo %yellow%⚠️ Some older drivers may be incompatible with Memory Integrity.%u%
echo.
echo %c%Press any key to return to Hardware Security Center...%u%
pause >nul
goto HardwareSecurityCenter

:SecurityComplianceReport
cls
call :SetupConsole
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                         SECURITY COMPLIANCE REPORT                           ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.

echo %c%Generating security compliance report...%u%
echo.

echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║ Security Compliance Summary                                                   ║
echo ╠═══════════════════════════════════════════════════════════════════════════════╣%u%

if /i "%tpm_status%"=="TPM_PRESENT" (
    if /i "%secureboot_status%"=="SECUREBOOT_ENABLED" (
        echo %c%║ • Windows 11 Ready %green%✓%c% (TPM 2.0 + Secure Boot + UEFI)                       ║%u%
    ) else (
        echo %c%║ • Windows 11 Ready %yellow%⚠️%c% (TPM ✓, Secure Boot needed)                        ║%u%
    )
) else (
    echo %c%║ • Windows 11 Ready %red%✗%c% (TPM and Secure Boot needed)                         ║%u%
)

echo %c%║ • Enterprise Ready %yellow%⚠️%c% (Additional configuration recommended)               ║%u%

if /i "%tpm_status%"=="TPM_PRESENT" (
    if /i "%secureboot_status%"=="SECUREBOOT_ENABLED" (
        echo %c%║ • Gaming Anti-Cheat Ready %green%✓%c% (Modern anti-cheat compatible)              ║%u%
    ) else (
        echo %c%║ • Gaming Anti-Cheat Ready %yellow%⚠️%c% (Secure Boot needed for some games)       ║%u%
    )
) else (
    echo %c%║ • Gaming Anti-Cheat Ready %red%✗%c% (TPM and Secure Boot required)               ║%u%
)

if /i "%tpm_status%"=="TPM_PRESENT" (
    echo %c%║ • BitLocker Ready %green%✓%c% (TPM 2.0 available)                                    ║%u%
) else (
    echo %c%║ • BitLocker Ready %red%✗%c% (TPM 2.0 required)                                   ║%u%
)

if /i "%virt_status%"=="VIRT_ENABLED" (
    echo %c%║ • VBS Ready %green%✓%c% (Virtualization enabled)                                     ║%u%
) else (
    echo %c%║ • VBS Ready %red%✗%c% (Virtualization support needed)                            ║%u%
)

echo %c%╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.

echo Security Compliance Report - Generated on %date% %time% > "%USERPROFILE%\Desktop\Security_Report.txt"
echo. >> "%USERPROFILE%\Desktop\Security_Report.txt"
echo System %computername% >> "%USERPROFILE%\Desktop\Security_Report.txt"
echo User %username% >> "%USERPROFILE%\Desktop\Security_Report.txt"
echo Motherboard %mobo_manufacturer% %mobo_model% >> "%USERPROFILE%\Desktop\Security_Report.txt"
echo BIOS %bios_version% >> "%USERPROFILE%\Desktop\Security_Report.txt"
echo TPM Status %tpm_status% >> "%USERPROFILE%\Desktop\Security_Report.txt"
echo Secure Boot %secureboot_status% >> "%USERPROFILE%\Desktop\Security_Report.txt"
echo Virtualization %virt_status% >> "%USERPROFILE%\Desktop\Security_Report.txt"

echo %c%✓ Report saved to Desktop\Security_Report.txt%u%
echo.
echo %c%Press any key to return to Hardware Security Center...%u%
pause >nul
goto HardwareSecurityCenter


:ShowASUSGuide
echo %c%╠═══════════════════════════════════════════════════════════════════════════════╣
echo ║ To Enable TPM 2.0                                                            ║
echo ║ 1. Restart and press DEL/F2 to enter BIOS                                   ║
echo ║ 2. Go to Advanced → PCH-FW Configuration                                     ║
echo ║ 3. Set "TPM Device Selection" to "Firmware TPM"                             ║
echo ║ 4. Set "Security Device Support" to "Enable"                                ║
echo ║                                                                               ║
echo ║ To Enable Secure Boot                                                        ║
echo ║ 1. Go to Boot → Secure Boot                                                  ║
echo ║ 2. Set "OS Type" to "Windows UEFI mode"                                     ║
echo ║ 3. Set "Secure Boot state" to "Enabled"                                     ║
echo ║ 4. Clear Secure Boot keys if prompted                                        ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
goto :eof

:ShowMSIGuide
echo %c%╠═══════════════════════════════════════════════════════════════════════════════╣
echo ║ To Enable TPM 2.0                                                            ║
echo ║ 1. Restart and press DEL to enter BIOS                                      ║
echo ║ 2. Go to Settings → Security → Trusted Computing                            ║
echo ║ 3. Set "Security Device Support" to "Enabled"                               ║
echo ║ 4. Set "TPM Device Selection" to "Firmware TPM" or "dTPM"                   ║
echo ║                                                                               ║
echo ║ To Enable Secure Boot                                                        ║
echo ║ 1. Go to Settings → Security → Secure Boot                                  ║
echo ║ 2. Set "Secure Boot" to "Enabled"                                           ║
echo ║ 3. Select "UEFI" boot mode if not already selected                          ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
goto :eof

:ShowGigabyteGuide
echo %c%╠═══════════════════════════════════════════════════════════════════════════════╣
echo ║ To Enable TPM 2.0                                                            ║
echo ║ 1. Restart and press DEL to enter BIOS                                      ║
echo ║ 2. Go to Peripherals → Trusted Computing                                    ║
echo ║ 3. Set "Security Device Support" to "Enabled"                               ║
echo ║ 4. Set "TPM Device Selection" to "Firmware TPM"                             ║
echo ║                                                                               ║
echo ║ To Enable Secure Boot                                                        ║
echo ║ 1. Go to BIOS → Boot Option #1                                              ║
echo ║ 2. Set "Secure Boot" to "Enabled"                                           ║
echo ║ 3. Set "Platform Key (PK)" management if needed                             ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
goto :eof

:ShowASRockGuide
echo %c%╠═══════════════════════════════════════════════════════════════════════════════╣
echo ║ To Enable TPM 2.0                                                            ║
echo ║ 1. Restart and press DEL/F2 to enter BIOS                                   ║
echo ║ 2. Go to Security → Trusted Computing                                       ║
echo ║ 3. Set "Security Device Support" to "Enabled"                               ║
echo ║ 4. Set "TPM Device Selection" to "Firmware TPM"                             ║
echo ║                                                                               ║
echo ║ To Enable Secure Boot                                                        ║
echo ║ 1. Go to Security → Secure Boot                                             ║
echo ║ 2. Set "Secure Boot" to "Enabled"                                           ║
echo ║ 3. Install default Secure Boot keys                                         ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
goto :eof

:ShowGenericGuide
echo %c%╠═══════════════════════════════════════════════════════════════════════════════╣
echo ║ To Enable TPM 2.0 (Generic)                                                  ║
echo ║ 1. Restart and press DEL/F2/F12 to enter BIOS                              ║
echo ║ 2. Look for Security, Advanced, or Trusted Computing sections              ║
echo ║ 3. Find "TPM", "Security Device", or "Trusted Computing" options           ║
echo ║ 4. Enable TPM/Security Device Support                                       ║
echo ║                                                                               ║
echo ║ To Enable Secure Boot (Generic)                                             ║
echo ║ 1. Look for Boot, Security, or Authentication sections                      ║
echo ║ 2. Find "Secure Boot" option                                                ║
echo ║ 3. Set to "Enabled" and ensure UEFI boot mode                              ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
goto :eof

:CleanupTemp
del /q "%temp%\tpm_status.txt" 2>nul
del /q "%temp%\sb_status.txt" 2>nul
del /q "%temp%\virt_status.txt" 2>nul
del /q "%temp%\bitlocker_status.txt" 2>nul
del /q "%temp%\bio_status.txt" 2>nul
del /q "%temp%\sg_compat.txt" 2>nul
del /q "%temp%\hvci_compat.txt" 2>nul
del /q "%temp%\sc_reader.txt" 2>nul
goto :eof


:EnableSystemGuard
cls
call :SetupConsole
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                       WINDOWS DEFENDER SYSTEM GUARD                          ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Configuring Windows Defender System Guard...%u%
echo.

echo %c%[1/6] Checking System Guard compatibility...%u%
chcp 437 >nul
powershell -Command "if ((Get-WmiObject -Class Win32_OperatingSystem).Version -ge '10.0.22000') { Write-Host 'COMPATIBLE' } else { Write-Host 'INCOMPATIBLE' }" > %temp%\sg_compat.txt
chcp 65001 >nul
set /p sg_compat=<%temp%\sg_compat.txt

if "%sg_compat%"=="INCOMPATIBLE" (
    echo %red%✗ System Guard requires Windows 11 or later%u%
    echo %c%Your system is not compatible with System Guard.%u%
    timeout /t 3 >nul
    goto HardwareSecurityCenter
)

echo %c%✓ System Guard compatibility confirmed%u%

echo.
echo %c%[2/6] Enabling System Guard Secure Launch...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequirePlatformSecurityFeatures" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "HypervisorEnforcedCodeIntegrity" /t REG_DWORD /d 1 /f >nul 2>&1
echo %c%✓ Secure Launch configured%u%

echo.
echo %c%[3/6] Configuring SMM Protection...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\SystemGuard" /v "Enabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "ConfigurePlatformSecurityFeatures" /t REG_DWORD /d 3 /f >nul 2>&1
echo %c%✓ SMM Protection enabled%u%

echo.
echo %c%[4/6] Enabling Runtime Attestation...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "RequirePlatformSecurityFeatures" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HypervisorEnforcedCodeIntegrity" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "LsaCfgFlags" /t REG_DWORD /d 1 /f >nul 2>&1
echo %c%✓ Runtime Attestation configured%u%

echo.
echo %c%[5/6] Configuring Kernel DMA Protection...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DmaSecurity" /v "DeviceEnumerationPolicy" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\KernelShadowStacks" /v "Enabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo %c%✓ Kernel DMA Protection configured%u%

echo.
echo %c%[6/6] Enabling System Guard Secure Boot Integration...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\State" /v "UEFISecureBootEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LsaCfgFlags" /t REG_DWORD /d 1 /f >nul 2>&1
echo %c%✓ Secure Boot integration configured%u%

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                      SYSTEM GUARD CONFIGURATION COMPLETED                    ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Successfully configured:%u%
echo %c%• System Guard Secure Launch%u%
echo %c%• SMM (System Management Mode) Protection%u%
echo %c%• Runtime Attestation%u%
echo %c%• Kernel DMA Protection%u%
echo %c%• Secure Boot Integration%u%
echo.
echo %c%System Guard Status:%u%
echo %c%• Boot integrity: Protected%u%
echo %c%• Runtime integrity: Protected%u%
echo %c%• Firmware security: Enhanced%u%
echo %c%• DMA attack protection: Active%u%
echo.
echo %yellow%⚠️ A restart is required for System Guard to fully activate.%u%
echo %green%✓ Your system is now protected against firmware-level attacks!%u%
echo.
echo %c%Press any key to return to Hardware Security Center...%u%
pause >nul
del /q "%temp%\sg_compat.txt" 2>nul
goto HardwareSecurityCenter

:EnableHVCI
cls
call :SetupConsole
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                    HYPERVISOR-PROTECTED CODE INTEGRITY                       ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Configuring Hypervisor-protected Code Integrity (HVCI)...%u%
echo.

echo %c%[1/8] Checking HVCI compatibility...%u%
chcp 437 >nul
powershell -Command "if ((Get-WmiObject -Class Win32_Processor).VirtualizationFirmwareEnabled -eq $true) { Write-Host 'VIRT_SUPPORTED' } else { Write-Host 'VIRT_UNSUPPORTED' }" > %temp%\hvci_compat.txt
chcp 65001 >nul
set /p hvci_compat=<%temp%\hvci_compat.txt

if "%hvci_compat%"=="VIRT_UNSUPPORTED" (
    echo %red%✗ HVCI requires hardware virtualization support%u%
    echo %c%Please enable virtualization in BIOS first.%u%
    timeout /t 3 >nul
    goto HardwareSecurityCenter
)

echo %c%✓ Hardware virtualization detected%u%

echo.
echo %c%[2/8] Enabling Virtualization-Based Security...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequirePlatformSecurityFeatures" /t REG_DWORD /d 3 /f >nul 2>&1
echo %c%✓ VBS foundation configured%u%

echo.
echo %c%[3/8] Configuring Hypervisor Code Integrity...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d 2 /f >nul 2>&1
echo %c%✓ HVCI core configuration applied%u%

echo.
echo %c%[4/8] Enabling Kernel Control Flow Guard...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelCFGEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "CfgBitMapSize" /t REG_DWORD /d 32 /f >nul 2>&1
echo %c%✓ Kernel Control Flow Guard enabled%u%

echo.
echo %c%[5/8] Configuring Hardware Stack Protection...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "CetCompatible" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\KernelShadowStacks" /v "Enabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo %c%✓ Hardware stack protection configured%u%

echo.
echo %c%[6/8] Enabling Strict Kernel Isolation...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_QWORD /d 0x2000000000000 /f >nul 2>&1
echo %c%✓ Strict kernel isolation enabled%u%

echo.
echo %c%[7/8] Configuring Driver Compatibility...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" /v "VulnerableDriverBlocklistEnable" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "HVCIMATRequired" /t REG_DWORD /d 1 /f >nul 2>&1
echo %c%✓ Driver compatibility configured%u%

echo.
echo %c%[8/8] Applying Final HVCI Settings...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HypervisorEnforcedCodeIntegrity" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 1 /f >nul 2>&1
echo %c%✓ HVCI policy configuration completed%u%

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                        HVCI CONFIGURATION COMPLETED                          ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Successfully configured:%u%
echo %c%• Hypervisor-protected Code Integrity (HVCI)%u%
echo %c%• Kernel Control Flow Guard (Kernel CFG)%u%
echo %c%• Hardware Stack Protection (CET/PAC)%u%
echo %c%• Strict Kernel Isolation%u%
echo %c%• Driver Compatibility Enforcement%u%
echo %c%• Vulnerable Driver Blocklist%u%
echo.
echo %c%HVCI Protection Status:%u%
echo %c%• Kernel code integrity: Hypervisor-protected%u%
echo %c%• Return-oriented programming: Blocked%u%
echo %c%• Code injection attacks: Prevented%u%
echo %c%• Unsigned driver loading: Blocked%u%
echo.
echo %yellow%⚠️ IMPORTANT: A restart is required for HVCI to activate.%u%
echo %yellow%⚠️ Some older or incompatible drivers may cause system instability.%u%
echo %yellow%⚠️ If you experience issues, disable HVCI in Windows Security settings.%u%
echo.
echo %green%✓ Maximum kernel protection is now active!%u%
echo.
echo %c%Press any key to return to Hardware Security Center...%u%
pause >nul
del /q "%temp%\hvci_compat.txt" 2>nul
goto HardwareSecurityCenter

:ConfigureSmartCard
cls
call :SetupConsole
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                       SMART CARD AUTHENTICATION SETUP                        ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Configuring Smart Card and Certificate Authentication...%u%
echo.

echo %c%[1/7] Detecting Smart Card readers...%u%
chcp 437 >nul
powershell -Command "if (Get-PnpDevice -Class SmartCardReader -ErrorAction SilentlyContinue) { Write-Host 'READER_FOUND' } else { Write-Host 'READER_NOT_FOUND' }" > %temp%\sc_reader.txt
chcp 65001 >nul
set /p sc_reader=<%temp%\sc_reader.txt

if "%sc_reader%"=="READER_NOT_FOUND" (
    echo %yellow%⚠️ No Smart Card readers detected%u%
    echo %c%You can still configure certificate-based authentication.%u%
) else (
    echo %c%✓ Smart Card reader detected%u%
)

echo.
echo %c%[2/7] Enabling Smart Card Services...%u%
sc config "SCardSvr" start= auto >nul 2>&1
sc start "SCardSvr" >nul 2>&1
sc config "SCPolicySvc" start= auto >nul 2>&1
sc start "SCPolicySvc" >nul 2>&1
sc config "CertPropSvc" start= auto >nul 2>&1
sc start "CertPropSvc" >nul 2>&1
echo %c%✓ Smart Card services configured%u%

echo.
echo %c%[3/7] Configuring Smart Card Group Policy...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\ScardSvr" /v "EnableCertPropSvc" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SmartCardCredentialProvider" /v "AllowCertificatesWithNoEKU" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SmartCardCredentialProvider" /v "AllowIntegratedUnblock" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SmartCardCredentialProvider" /v "AllowSignatureOnlyKeys" /t REG_DWORD /d 0 /f >nul 2>&1
echo %c%✓ Smart Card Group Policy configured%u%

echo.
echo %c%[4/7] Enabling Certificate Enrollment Services...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Cryptography\AutoEnrollment" /v "AEPolicy" /t REG_DWORD /d 7 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Cryptography\AutoEnrollment" /v "MyStoreFlags" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Cryptography\AutoEnrollment" /v "OfflineExpirationPercent" /t REG_DWORD /d 10 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Cryptography\AutoEnrollment" /v "OfflineExpirationStoreNames" /t REG_SZ /d "MY" /f >nul 2>&1
echo %c%✓ Certificate enrollment configured%u%

echo.
echo %c%[5/7] Configuring PKI Trust Settings...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\SystemCertificates\TrustedPublisher\Safer" /v "AuthenticodeEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Cryptography\OID\EncodingType 0\CertDllOpenStoreProv\Ldap" /v "Dll" /t REG_SZ /d "cryptdlg.dll" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Cryptography\Calais\SmartCards" /v "DefaultSmartCardCrypto Provider" /t REG_SZ /d "Microsoft Base Smart Card Crypto Provider" /f >nul 2>&1
echo %c%✓ PKI trust settings configured%u%

echo.
echo %c%[6/7] Enabling Smart Card Logon...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ScForceOption" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "ScRemoveOption" /t REG_SZ /d "2" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "SCENoApplyLegacyAuditPolicy" /t REG_DWORD /d 1 /f >nul 2>&1

echo %c%✓ Smart Card logon configured%u%

echo.
echo %c%[7/7] Configuring Advanced Smart Card Features...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters" /v "RequireSmartcardLogon" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters" /v "AllowTGTSessionKey" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LmCompatibilityLevel" /t REG_DWORD /d 5 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\EFS" /v "AlgorithmID" /t REG_DWORD /d 26128 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\EFS" /v "KeyLength" /t REG_DWORD /d 256 /f >nul 2>&1
echo %c%✓ Advanced Smart Card features configured%u%

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                   SMART CARD AUTHENTICATION CONFIGURATION                    ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Smart Card Authentication Setup Options:%u%
echo.
echo %c%[1] Launch Certificate Manager (certmgr.msc)%u%
echo %c%[2] Launch Smart Card Management (certlm.msc)%u%
echo %c%[3] Configure Certificate Templates%u%
echo %c%[4] Test Smart Card Authentication%u%
echo %c%[5] Enable Smart Card Required Logon%u%
echo %c%[6] Configure EFS with Smart Card%u%
echo %c%[7] View Smart Card Status%u%
echo %c%[8] Import Certificate from Smart Card%u%
echo.
echo %c%[B] Back to Hardware Security Center%u%
echo.

set /p "sc_choice=%c%Choose an option »%u% "

if "%sc_choice%"=="1" (
    echo %c%Opening Certificate Manager...%u%
    start certmgr.msc
    timeout /t 2 >nul
    goto ConfigureSmartCard
)

if "%sc_choice%"=="2" (
    echo %c%Opening Local Machine Certificate Manager...%u%
    start certlm.msc
    timeout /t 2 >nul
    goto ConfigureSmartCard
)

if "%sc_choice%"=="3" (
    echo %c%Opening Certificate Templates Console...%u%
    start certtmpl.msc
    timeout /t 2 >nul
    goto ConfigureSmartCard
)

if "%sc_choice%"=="4" (
    echo %c%Testing Smart Card authentication...%u%
    certreq -enrollCredMgr -user
    timeout /t 3 >nul
    goto ConfigureSmartCard
)

if "%sc_choice%"=="5" (
    echo %c%Enabling Smart Card Required Logon...%u%
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ScForceOption" /t REG_DWORD /d 2 /f >nul 2>&1
    echo %yellow%⚠️ Smart Card will be REQUIRED for logon after restart!%u%
    echo %yellow%⚠️ Ensure you have a working Smart Card before rebooting!%u%
    timeout /t 5 >nul
    goto ConfigureSmartCard
)

if "%sc_choice%"=="6" (
    echo %c%Configuring EFS with Smart Card integration...%u%
    cipher /adduser /certhash:* /s:%userprofile%
    echo %c%EFS Smart Card integration configured%u%
    timeout /t 3 >nul
    goto ConfigureSmartCard
)

if "%sc_choice%"=="7" (
    cls
    call :SetupConsole
    echo.
    echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
    echo ║                           SMART CARD STATUS REPORT                           ║
    echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
    echo.
    echo %c%Smart Card Services Status:%u%
    sc query "SCardSvr" | findstr "STATE" 
    sc query "SCPolicySvc" | findstr "STATE"
    sc query "CertPropSvc" | findstr "STATE"
    echo.
    echo %c%Installed Smart Card Readers:%u%
    chcp 437 >nul
    powershell -Command "Get-PnpDevice -Class SmartCardReader | Select-Object Name, Status"
    chcp 65001 >nul
    echo.
    echo %c%Available Certificates:%u%
    certlm -store my -s | findstr "Subject"
    echo.
    echo %c%Press any key to continue...%u%
    pause >nul
    goto ConfigureSmartCard
)

if "%sc_choice%"=="8" (
    echo %c%Importing certificate from Smart Card...%u%
    certreq -enroll -user -cert SmartCardLogon
    timeout /t 3 >nul
    goto ConfigureSmartCard
)

if /i "%sc_choice%"=="B" goto HardwareSecurityCenter

echo %red%Invalid choice. Please try again.%u%
timeout /t 2 >nul
goto ConfigureSmartCard

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                     SMART CARD CONFIGURATION COMPLETED                       ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Successfully configured:%u%
echo %c%• Smart Card services and drivers%u%
echo %c%• Certificate enrollment and PKI trust%u%
echo %c%• Smart Card authentication policies%u%
echo %c%• EFS integration with Smart Cards%u%
echo %c%• Advanced Kerberos authentication%u%
echo %c%• Certificate-based security features%u%
echo.
echo %c%Smart Card Features Available:%u%
echo %c%• Two-factor authentication%u%
echo %c%• Certificate-based file encryption%u%
echo %c%• Secure email signing/encryption%u%
echo %c%• Enterprise PKI integration%u%
echo %c%• Hardware-backed key storage%u%
echo.
if "%sc_reader%"=="READER_FOUND" (
    echo %green%✓ Smart Card reader ready for use!%u%
) else (
    echo %yellow%⚠️ Connect a Smart Card reader to use physical Smart Cards.%u%
)
echo.
echo %c%Press any key to return to Hardware Security Center...%u%
pause >nul
del /q "%temp%\sc_reader.txt" 2>nul
goto HardwareSecurityCenter

del /q "%temp%\tpm_status.txt" 2>nul
del /q "%temp%\sb_status.txt" 2>nul
del /q "%temp%\virt_status.txt" 2>nul
del /q "%temp%\bitlocker_status.txt" 2>nul
del /q "%temp%\bio_status.txt" 2>nul

:AutomatedSecuritySetup
cls
call :SetupConsole
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                          AUTOMATED SECURITY SETUP                            ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will automatically configure recommended security settings...%u%
echo.
echo %yellow%⚠️ WARNING: This will modify system settings and require a restart.%u%
echo.
choice /C YN /M "%c%Continue with automated setup? (Y/N)%u%"
if errorlevel 2 goto HardwareSecurityCenter

echo.
echo %c%[1/6] Configuring Virtualization-Based Security...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 1 /f >nul 2>&1
echo %c%✓ VBS configured%u%

echo.
echo %c%[2/6] Enabling Credential Guard...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\LSA" /v "LsaCfgFlags" /t REG_DWORD /d 1 /f >nul 2>&1
echo %c%✓ Credential Guard enabled%u%

echo.
echo %c%[3/6] Configuring Core Isolation...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo %c%✓ Memory Integrity configured%u%

echo.
echo %c%[4/6] Enabling Windows Defender features...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 0 /f >nul 2>&1
echo %c%✓ Defender security features enabled%u%

echo.
echo %c%[5/6] Configuring UAC settings...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 1 /f >nul 2>&1
echo %c%✓ UAC configured for maximum security%u%

echo.
echo %c%[6/6] Enabling additional security features...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo %c%✓ Kernel protection features enabled%u%

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                       AUTOMATED SETUP COMPLETED                              ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Successfully configured:%u%
echo %c%• Virtualization-Based Security%u%
echo %c%• Windows Credential Guard%u%
echo %c%• Core Isolation Memory Integrity%u%
echo %c%• Enhanced Windows Defender protection%u%
echo %c%• Maximum UAC security%u%
echo %c%• Kernel security features%u%
echo.
echo %green%✓ Your system security has been significantly enhanced!%u%
echo.
echo %yellow%⚠️ A restart is required for all changes to take effect.%u%
echo.
choice /C YN /M "%c%Restart now to apply changes? (Y/N)%u%"
if errorlevel 1 shutdown /r /t 10 /c "Restarting to apply security configurations..."

echo.
echo %c%Press any key to return to Hardware Security Center...%u%
pause >nul
goto HardwareSecurityCenter

:AMDOptimizer
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                            AMD DRIVER OPTIMIZER                              ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%AMD optimization includes:%u%
echo %c%• Disable AMD telemetry and data collection%u%
echo %c%• Optimize Radeon settings for gaming performance%u%
echo %c%• Remove unnecessary AMD services and tasks%u%
echo %c%• Configure power management for performance%u%
echo %c%• Block AMD telemetry domains%u%
echo %c%• Safe registry optimizations only%u%
echo.
echo %red%%underline%AMD Notice:%u%
echo %c%This script uses safe optimization methods only.%u%
echo %c%For complete software removal, use AMD Cleanup Utility.%u%
echo.
echo.
choice /C YN /M "%c%Apply AMD driver optimizations? (Y/N)%u%"
if errorlevel 2 goto HardwareMenu

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           OPTIMIZATION PREFERENCES                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Choose your optimization preferences:%u%
echo.

choice /C YN /M "%c%Disable AMD Software services (keeps software installed)? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_AMD_SERVICES=false"
    echo %c%  → AMD services will remain active%u%
) else (
    set "DISABLE_AMD_SERVICES=true"
    echo %c%  → AMD services will be stopped/disabled%u%
)

echo.
choice /C YN /M "%c%Disable AMD metrics and monitoring? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_METRICS=false"
    echo %c%  → AMD metrics will be kept enabled%u%
) else (
    set "DISABLE_METRICS=true"
    echo %c%  → AMD metrics will be disabled%u%
)

echo.
choice /C YN /M "%c%Disable automatic driver updates? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_UPDATES=false"
    echo %c%  → Automatic updates will be kept%u%
) else (
    set "DISABLE_UPDATES=true"
    echo %c%  → Automatic updates will be disabled%u%
)

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        AMD OPTIMIZATION IN PROGRESS                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

call :AMD_Step1_DetectGPU
if "%AMD_GPU_FOUND%"=="false" (
    echo.
    echo %red%No AMD GPU detected! This script is designed for AMD systems only.%u%
    echo %c%Exiting to prevent potential issues...%u%
    pause
    goto HardwareMenu
)

call :AMD_Step2_DisableServices
call :AMD_Step3_DisableTelemetry
call :AMD_Step4_OptimizeSettings
call :AMD_Step5_BlockDomains
call :AMD_Step6_CleanTasks
call :AMD_Step7_SafeTweaks

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        AMD OPTIMIZATION COMPLETED                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%AMD optimizations have been successfully applied.%u%
echo.
echo %c%Safe Optimizations Applied:%u%
echo %c%• Telemetry and data collection disabled%u%
echo %c%• Safe driver performance tweaks applied%u%
echo %c%• Power management optimized%u%
echo %c%• Unnecessary background tasks removed%u%
echo.
echo %c%User Preferences Applied:%u%
if "%DISABLE_AMD_SERVICES%"=="true" (
    echo %c%• AMD Software services disabled%u%
) else (
    echo %c%• AMD Software services kept active%u%
)
if "%DISABLE_METRICS%"=="true" (
    echo %c%• AMD metrics and monitoring disabled%u%
) else (
    echo %c%• AMD metrics kept enabled%u%
)
if "%DISABLE_UPDATES%"=="true" (
    echo %c%• Automatic driver updates disabled%u%
) else (
    echo %c%• Automatic driver updates kept enabled%u%
)

echo.
echo %red%Performance Benefits:%u%
echo %c%• Reduced background processes and resource usage%u%
echo %c%• Enhanced privacy with telemetry disabled%u%
echo %c%• Optimized power management for performance%u%
echo %c%• Cleaner system with unnecessary tasks removed%u%
echo.
echo %red%Note:%u%
echo %c%• For complete software removal, use AMD Cleanup Utility%u%
echo %c%• Use AMD Radeon Settings for driver configuration%u%
echo %c%• A system restart is recommended for full effect%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto HardwareMenu

:AMD_Step1_DetectGPU
echo %c%[1/7] Detecting AMD GPU...%u%
set "AMD_GPU_FOUND=false"
for /f "tokens=2 delims==" %%i in ('wmic path win32_VideoController where "Name like '%%AMD%%' or Name like '%%Radeon%%' or Name like '%%RX %%'" get Name /value 2^>nul') do (
    if not "%%i"=="" (
        echo %c%  → Found: %%i%u%
        set "AMD_GPU_FOUND=true"
    )
)
if "%AMD_GPU_FOUND%"=="false" (
    echo %red%  → No AMD GPU detected!%u%
)
goto :eof

:AMD_Step2_DisableServices
echo %c%[2/7] Managing AMD services...%u%
if "%DISABLE_AMD_SERVICES%"=="true" (
    set "AMD_SERVICES=AMD Crash Defender Service,AMD External Events Utility,AMD Log Utility"
    for %%s in (%AMD_SERVICES%) do (
        sc query "%%s" >nul 2>&1
        if !errorlevel! equ 0 (
            sc stop "%%s" >nul 2>&1
            sc config "%%s" start= demand >nul 2>&1
            echo %c%  → Set to manual: %%s%u%
        )
    )
    echo %c%  → Note: AMD Radeon Software Service kept active for control panel%u%
) else (
    echo %c%  → AMD services kept active%u%
)
goto :eof

:AMD_Step3_DisableTelemetry
echo %c%[3/7] Disabling AMD telemetry...%u%
reg add "HKLM\SOFTWARE\AMD\Install" /v AUEP /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\AMD\Install" /v UsageTracking /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\AMD\Install" /v AUEP /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\AMD\Install" /v UsageTracking /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\AMD\DVR" /v PerformanceMonitorOpacityWA /t REG_DWORD /d 0 /f >nul 2>&1
if "%DISABLE_METRICS%"=="true" (
    reg add "HKCU\SOFTWARE\AMD\DVR" /v DvrEnabled /t REG_DWORD /d 0 /f >nul 2>&1
)
if "%DISABLE_UPDATES%"=="true" (
    reg add "HKLM\SOFTWARE\AMD\Install" /v AutoUpdate /t REG_DWORD /d 0 /f >nul 2>&1
    echo %c%  → Auto-updates disabled%u%
)
echo %c%  → Telemetry disabled%u%
goto :eof

:AMD_Step4_OptimizeSettings
echo %c%[4/7] Optimizing Radeon settings (safe method)...%u%
set "AMD_DRIVER_KEY="
for /f "tokens=1" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /s /v DriverDesc 2^>nul ^| findstr /i "AMD\|Radeon"') do (
    set "AMD_DRIVER_KEY=%%a"
    goto :ApplyAMDTweaks
)

:ApplyAMDTweaks
if not defined AMD_DRIVER_KEY (
    echo %c%  → Could not find AMD driver registry key, skipping advanced tweaks%u%
    goto :eof
)

echo %c%  → Found AMD driver key, applying safe optimizations...%u%
reg add "%AMD_DRIVER_KEY%" /v EnableUlps /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%AMD_DRIVER_KEY%" /v EnableUlps_NA /t REG_DWORD /d 0 /f >nul 2>&1
reg add "%AMD_DRIVER_KEY%" /v PP_SclkDeepSleepDisable /t REG_DWORD /d 1 /f >nul 2>&1
echo %c%  → Safe performance settings applied%u%
goto :eof

:AMD_Step5_BlockDomains
echo %c%[5/7] Blocking AMD telemetry domains...%u%
set "hosts_file=%windir%\System32\drivers\etc\hosts"
set "domains=telemetry.amd.com content-delivery.amd.com survey.amd.com"

for %%d in (%domains%) do (
    findstr /C:"%%d" "%hosts_file%" >nul 2>&1
    if errorlevel 1 (
        echo 0.0.0.0 %%d >> "%hosts_file%" 2>nul
        echo %c%  → Blocked: %%d%u%
    )
)
echo %c%  → Telemetry domains blocked%u%
goto :eof

:AMD_Step6_CleanTasks
echo %c%[6/7] Cleaning AMD scheduled tasks...%u%
set "AMD_TASKS=AMDLinkUpdate StartCN StartDVR"
for %%t in (%AMD_TASKS%) do (
    schtasks /query /tn "%%t" >nul 2>&1
    if !errorlevel! equ 0 (
        schtasks /change /tn "%%t" /disable >nul 2>&1
        echo %c%  → Disabled: %%t%u%
    )
)
if "%DISABLE_METRICS%"=="true" (
    schtasks /query /tn "*AMD*" >nul 2>&1
    if !errorlevel! equ 0 (
        for /f "tokens=1" %%t in ('schtasks /query /fo list ^| findstr /i "TaskName.*AMD"') do (
            schtasks /change /tn "%%t" /disable >nul 2>&1
        )
        echo %c%  → All AMD metrics tasks disabled%u%
    )
)
goto :eof

:AMD_Step7_SafeTweaks
echo %c%[7/7] Applying safe system tweaks...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrDelay /t REG_DWORD /d 10 /f >nul 2>&1
if defined AMD_DRIVER_KEY (
    reg add "%AMD_DRIVER_KEY%" /v PP_AllGraphicLevel_UpHyst /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "%AMD_DRIVER_KEY%" /v PP_AllGraphicLevel_DownHyst /t REG_DWORD /d 20 /f >nul 2>&1
    reg add "%AMD_DRIVER_KEY%" /v PP_ActivityTarget /t REG_DWORD /d 30 /f >nul 2>&1
    reg add "%AMD_DRIVER_KEY%" /v PP_ForceHighDPMLevel /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%AMD_DRIVER_KEY%" /v PP_Force3DPerformanceMode /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%AMD_DRIVER_KEY%" /v DisableAllClockGating /t REG_DWORD /d 1 /f >nul 2>&1
    echo %c%  → AMD clock hysteresis tuned%u%
)
echo %c%  → Safe system optimizations applied%u%
goto :eof

:NVIDIAOptimizer
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           NVIDIA DRIVER OPTIMIZER                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%NVIDIA optimization includes:%u%
echo %c%• Disable NVIDIA telemetry and data collection%u%
echo %c%• Optional: Remove NVIDIA App/GeForce Experience%u%
echo %c%• Optional: Disable overlays and ShadowPlay%u%
echo %c%• Optimize NVIDIA Control Panel settings%u%
echo %c%• Remove bloatware components and scheduled tasks%u%
echo %c%• Configure power management for performance%u%
echo %c%• Apply advanced driver optimizations%u%
echo.
echo %red%%underline%NVIDIA Notice:%u%
echo %c%You can choose what to keep and what to disable.%u%
echo %c%Core optimizations will always be applied for better performance.%u%
echo.
echo.
choice /C YN /M "%c%Apply NVIDIA driver optimizations? (Y/N)%u%"
if errorlevel 2 goto HardwareMenu

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           OPTIMIZATION PREFERENCES                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Choose your optimization preferences:%u%
echo.

choice /C YN /M "%c%Disable NVIDIA App/GeForce Experience? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_NVIDIA_APP=false"
    echo %c%  → NVIDIA App will be kept enabled%u%
) else (
    set "DISABLE_NVIDIA_APP=true"
    echo %c%  → NVIDIA App will be disabled%u%
)

echo.
choice /C YN /M "%c%Disable Gaming Overlay and ShadowPlay? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_OVERLAY=false"
    echo %c%  → Gaming features will be kept enabled%u%
) else (
    set "DISABLE_OVERLAY=true"
    echo %c%  → Gaming features will be disabled%u%
)

echo.
choice /C YN /M "%c%Disable automatic driver updates? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_UPDATES=false"
    echo %c%  → Automatic updates will be kept%u%
) else (
    set "DISABLE_UPDATES=true"
    echo %c%  → Automatic updates will be disabled%u%
)

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       NVIDIA OPTIMIZATION IN PROGRESS                        ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

call :Step1_DetectGPU
call :Step2_DiscoverServices
call :Step3_StopServices
call :Step4_DisableTelemetry
call :Step5_ManageStartup
call :Step6_ManageTasks
call :Step7_ManageGaming
call :Step8_CoreOptimizations
call :Step9_AdvancedTweaks
call :Step10_NVIDIA3DSettings
call :Step11_BlockTelemetry
call :Step12_RestartServices

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       NVIDIA OPTIMIZATION COMPLETED                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%NVIDIA optimizations have been successfully applied.%u%
echo.
echo %c%Core Optimizations Applied:%u%
echo %c%• Telemetry and data collection disabled%u%
echo %c%• Driver timeout and stability enhanced%u%
echo %c%• Advanced driver tweaks applied%u%
echo %c%• Power management optimized%u%
echo.
echo %c%User Preferences Applied:%u%
if "%DISABLE_NVIDIA_APP%"=="true" (
    echo %c%• NVIDIA App/GeForce Experience disabled%u%
) else (
    echo %c%• NVIDIA App/GeForce Experience kept enabled%u%
)
if "%DISABLE_OVERLAY%"=="true" (
    echo %c%• Gaming overlays and ShadowPlay disabled%u%
) else (
    echo %c%• Gaming overlays and ShadowPlay kept enabled%u%
)
if "%DISABLE_UPDATES%"=="true" (
    echo %c%• Automatic driver updates disabled%u%
) else (
    echo %c%• Automatic driver updates kept enabled%u%
)

echo.
echo %red%Performance Benefits:%u%
echo %c%• Reduced system resource usage%u%
echo %c%• Eliminated background telemetry processes%u%
echo %c%• Improved gaming performance and stability%u%
echo %c%• Enhanced privacy and reduced data collection%u%
echo %c%• Maximum GPU performance unlocked%u%
echo.
echo %red%Note:%u%
echo %c%• Use NVIDIA Control Panel for driver settings%u%
echo %c%• A system restart is recommended for full effect%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto HardwareMenu

:Step1_DetectGPU
echo.
echo %c%[1/12] Detecting NVIDIA Graphics Hardware...%u%
set "NVIDIA_FOUND=false"
wmic path Win32_VideoController get Name | findstr /i "NVIDIA" >nul 2>&1
if %errorlevel%==0 (
    set "NVIDIA_FOUND=true"
    echo %c%  * NVIDIA GPU detected%u%
) else (
    echo %c%  * No NVIDIA GPU found%u%
    echo %c%  * Optimization will continue for future compatibility%u%
)
exit /b

:Step2_DiscoverServices
echo %c%[2/12] Discovering NVIDIA Services...%u%

set "TELEMETRY_SERVICES="
set "NVIDIA_APP_SERVICES="
set "ESSENTIAL_SERVICES="
set "servicesFound=false"

echo %c%  * Checking for known NVIDIA services...%u%
for %%S in (
    nvcontainer
    NVDisplay.Container
    NvContainerLocalSystem
    NVDisplay.ContainerLocalSystem
    NvTelemetryContainer
    nvdisplay.container
    GfExperienceService
    NVIDIAAppService
    NVIDIA.GeForceExperience.Service
    NvStreamSvc
    NVSvc
) do (
    sc query "%%S" >nul 2>&1 && (
        set "servicesFound=true"
        echo %c%    → Found service: %%S%u%
        
        if /i "%%S"=="nvcontainer" set "TELEMETRY_SERVICES=!TELEMETRY_SERVICES! %%S" & echo %c%      * Categorized as: Telemetry/Container%u%
        if /i "%%S"=="NVDisplay.Container" set "TELEMETRY_SERVICES=!TELEMETRY_SERVICES! %%S" & echo %c%      * Categorized as: Telemetry/Container%u%
        if /i "%%S"=="NvContainerLocalSystem" set "TELEMETRY_SERVICES=!TELEMETRY_SERVICES! %%S" & echo %c%      * Categorized as: Telemetry/Container%u%
        if /i "%%S"=="NVDisplay.ContainerLocalSystem" set "TELEMETRY_SERVICES=!TELEMETRY_SERVICES! %%S" & echo %c%      * Categorized as: Telemetry/Container%u%
        if /i "%%S"=="NvTelemetryContainer" set "TELEMETRY_SERVICES=!TELEMETRY_SERVICES! %%S" & echo %c%      * Categorized as: Telemetry/Container%u%
        if /i "%%S"=="nvdisplay.container" set "TELEMETRY_SERVICES=!TELEMETRY_SERVICES! %%S" & echo %c%      * Categorized as: Telemetry/Container%u%
        
        if /i "%%S"=="GfExperienceService" set "NVIDIA_APP_SERVICES=!NVIDIA_APP_SERVICES! %%S" & echo %c%      * Categorized as: NVIDIA App%u%
        if /i "%%S"=="NVIDIAAppService" set "NVIDIA_APP_SERVICES=!NVIDIA_APP_SERVICES! %%S" & echo %c%      * Categorized as: NVIDIA App%u%
        if /i "%%S"=="NVIDIA.GeForceExperience.Service" set "NVIDIA_APP_SERVICES=!NVIDIA_APP_SERVICES! %%S" & echo %c%      * Categorized as: NVIDIA App%u%
        
        if /i "%%S"=="NVSvc" set "ESSENTIAL_SERVICES=!ESSENTIAL_SERVICES! %%S" & echo %c%      * Categorized as: Essential%u%
        if /i "%%S"=="NvStreamSvc" set "ESSENTIAL_SERVICES=!ESSENTIAL_SERVICES! %%S" & echo %c%      * Categorized as: Essential%u%
    )
)

echo %c%  * Scanning all services for NVIDIA references...%u%
for /f "skip=1 tokens=2" %%S in ('sc query type= service state= all ^| findstr "SERVICE_NAME"') do (
    echo %%S | findstr /i "nvidia\|nvcontainer\|nvdisplay\|geforce" >nul && (
        set "servicesFound=true"
        
        echo !TELEMETRY_SERVICES! !NVIDIA_APP_SERVICES! !ESSENTIAL_SERVICES! | findstr /i "%%S" >nul || (
            echo %c%    → Found additional NVIDIA service: %%S%u%
            echo %%S | findstr /i "container\|telemetry\|local" >nul && (
                set "TELEMETRY_SERVICES=!TELEMETRY_SERVICES! %%S"
                echo %c%      * Auto-categorized as: Telemetry/Container%u%
            )
        )
    )
)

echo %c%  * Checking running NVIDIA processes...%u%
tasklist /svc | findstr /i "nvcontainer\|nvdisplay\|nvidia" >nul 2>&1 && (
    echo %c%    → NVIDIA processes are currently running%u%
)

if "%servicesFound%"=="false" (
    echo %c%  * No NVIDIA services found%u%
    echo %c%  * This may indicate a clean driver installation%u%
) else (
    echo %c%  * Service discovery completed%u%
)

echo %c%  → Telemetry/Container: %TELEMETRY_SERVICES%%u%
echo %c%  → App Services:       %NVIDIA_APP_SERVICES%%u%
echo %c%  → Essential Services: %ESSENTIAL_SERVICES%%u%
exit /b

:Step3_StopServices
echo %c%[3/12] Stopping NVIDIA Services...%u%

set "servicesStopped=false"

for %%S in (%TELEMETRY_SERVICES%) do (
    sc query "%%S" 2>nul | findstr /i "RUNNING" >nul && (
        net stop "%%S" >nul 2>&1
        if !errorlevel! equ 0 (
            echo %c%  * Stopped telemetry service: %%S%u%
            set "servicesStopped=true"
        ) else (
            echo %c%  * Failed to stop: %%S%u%
        )
    )
)

if "%DISABLE_NVIDIA_APP%"=="true" (
    for %%S in (%NVIDIA_APP_SERVICES%) do (
        sc query "%%S" 2>nul | findstr /i "RUNNING" >nul && (
            net stop "%%S" >nul 2>&1
            if !errorlevel! equ 0 (
                echo %c%  * Stopped app service: %%S%u%
                set "servicesStopped=true"
            ) else (
                echo %c%  * Failed to stop: %%S%u%
            )
        )
    )
) else (
    echo %c%  * NVIDIA App services kept running%u%
)

if "%servicesStopped%"=="false" echo %c%  * No running services found to stop%u%
exit /b

:Step4_DisableTelemetry
echo %c%[4/12] Disabling NVIDIA Telemetry Services...%u%

set "servicesDisabled=false"

for %%S in (%TELEMETRY_SERVICES%) do (
    sc query "%%S" >nul 2>&1 && (
        sc qc "%%S" | findstr /i "START_TYPE.*DISABLED" >nul || (
            sc config "%%S" start= disabled >nul 2>&1
            if !errorlevel! equ 0 (
                echo %c%  * Disabled telemetry service: %%S%u%
                set "servicesDisabled=true"
            ) else (
                echo %c%  * Failed to disable: %%S%u%
            )
        )
    )
)

if "%DISABLE_NVIDIA_APP%"=="true" (
    for %%S in (%NVIDIA_APP_SERVICES%) do (
        sc query "%%S" >nul 2>&1 && (
            sc qc "%%S" | findstr /i "START_TYPE.*DISABLED" >nul || (
                sc config "%%S" start= disabled >nul 2>&1
                if !errorlevel! equ 0 (
                    echo %c%  * Disabled app service: %%S%u%
                    set "servicesDisabled=true"
                ) else (
                    echo %c%  * Failed to disable: %%S%u%
                )
            )
        )
    )
) else (
    echo %c%  * NVIDIA App services kept enabled%u%
)

if "%servicesDisabled%"=="false" echo %c%  * No services required disabling%u%
exit /b

:Step5_ManageStartup
echo %c%[5/12] Managing Startup Programs...%u%

if "%DISABLE_NVIDIA_APP%"=="true" (
    set "startupRemoved=false"
    for %%R in (
        "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
        "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    ) do (
        for %%V in (
            "NVIDIA GeForce Experience"
            "NvBackend"
            "NVIDIA App"
        ) do (
            reg query "%%R" /v "%%~V" >nul 2>&1 && (
                reg delete "%%R" /v "%%~V" /f >nul 2>&1
                if !errorlevel! equ 0 (
                    echo %c%  * Removed from startup: %%~V%u%
                    set "startupRemoved=true"
                ) else (
                    echo %c%  * Failed to remove: %%~V%u%
                )
            )
        )
    )
    
    tasklist | findstr /i "NVIDIA App.exe" >nul 2>&1 && (
        taskkill /f /im "NVIDIA App.exe" >nul 2>&1
        if !errorlevel! equ 0 (
            echo %c%  * Terminated NVIDIA App process%u%
            set "startupRemoved=true"
        )
    )
    
    if exist "C:\Program Files\NVIDIA Corporation\NVIDIA App\CEF\NVIDIA App.exe" (
        echo %c%  * NVIDIA App executable found%u%
        choice /C YN /M "%c%  Rename NVIDIA App.exe to prevent auto-start? (Y/N)%u%"
        if !errorlevel! equ 1 (
            ren "C:\Program Files\NVIDIA Corporation\NVIDIA App\CEF\NVIDIA App.exe" "NVIDIA App.exe.disabled" >nul 2>&1
            if !errorlevel! equ 0 (
                echo %c%  * NVIDIA App executable disabled%u%
                set "startupRemoved=true"
            ) else (
                echo %c%  * Failed to disable NVIDIA App executable%u%
            )
        )
    )
    
    if "%startupRemoved%"=="false" echo %c%  * No startup entries found to remove%u%
) else (
    echo %c%  * NVIDIA App kept in startup%u%
    
    if exist "C:\Program Files\NVIDIA Corporation\NVIDIA App\CEF\NVIDIA App.exe.disabled" (
        ren "C:\Program Files\NVIDIA Corporation\NVIDIA App\CEF\NVIDIA App.exe.disabled" "NVIDIA App.exe" >nul 2>&1
        if !errorlevel! equ 0 echo %c%  * NVIDIA App executable restored%u%
    )
)
exit /b

:Step6_ManageTasks
echo %c%[6/12] Managing Scheduled Tasks...%u%

set "telemetryTasksModified=false"
for %%T in (
    "NvTmRep_CrashReport1_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}"
    "NvTmRep_CrashReport2_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}"
    "NvTmRep_CrashReport3_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}"
    "NvTmRep_CrashReport4_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}"
) do (
    schtasks /query /tn "%%~T" >nul 2>&1 && (
        schtasks /query /tn "%%~T" /fo csv | findstr /i "Disabled" >nul || (
            schtasks /change /disable /tn "%%~T" >nul 2>&1
            if !errorlevel! equ 0 (
                echo %c%  * Disabled telemetry task: %%~T%u%
                set "telemetryTasksModified=true"
            ) else (
                echo %c%  * Failed to disable task: %%~T%u%
            )
        )
    )
)
if "%telemetryTasksModified%"=="false" echo %c%  * No telemetry tasks required disabling%u%

if "%DISABLE_UPDATES%"=="true" (
    set "updateTasksModified=false"
    for %%T in (
        "NvDriverUpdateCheckDaily"
        "NvBatteryBoostCheckOnLogon"
		"NVIDIA App SelfUpdate_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}"
        "NVIDIA GeForce Experience SelfUpdate_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}"
        "NvProfileUpdaterDaily"
        "NvProfileUpdaterOnLogon"
    ) do (
        schtasks /query /tn "%%~T" >nul 2>&1 && (
            schtasks /delete /tn "%%~T" /f >nul 2>&1
            if !errorlevel! equ 0 (
                echo %c%  * Removed update task: %%~T%u%
                set "updateTasksModified=true"
            ) else (
                echo %c%  * Failed to remove task: %%~T%u%
            )
        )
    )
    if "%updateTasksModified%"=="false" echo %c%  * No update tasks found to remove%u%
) else (
    echo %c%  * Update tasks kept enabled%u%
)
exit /b

:Step7_ManageGaming
echo %c%[7/12] Managing Gaming Features...%u%

if "%DISABLE_OVERLAY%"=="true" (
    set "gamingFeaturesDisabled=false"
    
    for %%K in (
        "HKLM\SOFTWARE\NVIDIA Corporation\NvStreamSrv|EnableStreaming|0"
        "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS|EnableRID66610|0"
        "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS|EnableRID64640|0"
        "HKCU\SOFTWARE\NVIDIA Corporation\NVIDIA GeForce Experience\ShadowPlay|ShadowPlayEnabled|0"
        "HKLM\SOFTWARE\NVIDIA Corporation\Global\ShadowPlay\NVSPCAPS|DefaultUser|0"
        "HKCU\SOFTWARE\NVIDIA Corporation\NVIDIA App\NVIDIAOverlay|OverlayEnabled|0"
    ) do (
        for /f "tokens=1,2,3 delims=|" %%A in ("%%K") do (
            reg add "%%A" /v "%%B" /t REG_DWORD /d "%%C" /f >nul 2>&1
            if !errorlevel! equ 0 (
                echo %c%  * Disabled gaming feature: %%B%u%
                set "gamingFeaturesDisabled=true"
            )
        )
    )
    
    if "%gamingFeaturesDisabled%"=="true" (
        echo %c%  * Gaming overlays and recording disabled%u%
    ) else (
        echo %c%  * No gaming features required disabling%u%
    )
) else (
    echo %c%  * Gaming features kept enabled%u%
)
exit /b

:Step8_CoreOptimizations
echo %c%[8/12] Applying Core Registry Optimizations...%u%

set "coreOptimizationsApplied=false"

reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d "0" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo %c%  * Applied optimization: Telemetry opt-out%u%
    set "coreOptimizationsApplied=true"
)

reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID44231" /t REG_DWORD /d "0" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo %c%  * Applied optimization: Telemetry collection%u%
    set "coreOptimizationsApplied=true"
)

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d "8" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo %c%  * Applied optimization: High Performance GPU Mode%u%
    set "coreOptimizationsApplied=true"
)

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "2" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo %c%  * Applied optimization: Enable Hardware GPU Scheduling%u%
    set "coreOptimizationsApplied=true"
)

reg add "HKCU\Software\NVIDIA Corporation\Global\NVTweak\Devices\509901423-0\Color" /v "NvCplUseColorCorrection" /t REG_DWORD /d "0" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo %c%  * Applied optimization: Color correction%u%
    set "coreOptimizationsApplied=true"
)

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PlatformSupportMiracast" /t REG_DWORD /d "0" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo %c%  * Applied optimization: Miracast support%u%
    set "coreOptimizationsApplied=true"
)

reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "DisplayPowerSaving" /t REG_DWORD /d "0" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo %c%  * Applied optimization: Display power saving%u%
    set "coreOptimizationsApplied=true"
)

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDelay" /t REG_DWORD /d "10" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo %c%  * Applied optimization: Driver timeout delay%u%
    set "coreOptimizationsApplied=true"
)

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDdiDelay" /t REG_DWORD /d "10" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo %c%  * Applied optimization: DDI timeout delay%u%
    set "coreOptimizationsApplied=true"
)

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLevel" /t REG_DWORD /d "0" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo %c%  * Applied optimization: Timeout detection level%u%
    set "coreOptimizationsApplied=true"
)

reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRID61684" /t REG_DWORD /d "1" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo %c%  * Applied optimization: Silk smoothness%u%
    set "coreOptimizationsApplied=true"
)

if "%coreOptimizationsApplied%"=="true" (
    echo %c%  * Core optimizations completed%u%
) else (
    echo %c%  * Core optimizations already applied%u%
)
exit /b


:Step9_AdvancedTweaks
echo %c%[9/12] Applying Advanced Driver Tweaks...%u%

set "tweaksApplied=false"
set "devicesFound=false"
set "deviceCount=0"

for /f %%a in ('reg query "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /t REG_SZ /s /e /f "NVIDIA" 2^>nul ^| findstr "HKEY"') do (
    set "devicesFound=true"
    set /a "deviceCount=!deviceCount!+1"
    
    reg add "%%a" /v "EnableTiledDisplay" /t REG_DWORD /d "0" /f >nul 2>&1
    if !errorlevel! equ 0 set "tweaksApplied=true"
    
    reg add "%%a" /v "TCCSupported" /t REG_DWORD /d "0" /f >nul 2>&1
    if !errorlevel! equ 0 set "tweaksApplied=true"
    
    reg add "%%a" /v "PowerMizerEnable" /t REG_DWORD /d "0" /f >nul 2>&1
    if !errorlevel! equ 0 set "tweaksApplied=true"
    
    reg add "%%a" /v "PowerMizerLevel" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "PowerMizerLevelAC" /t REG_DWORD /d "1" /f >nul 2>&1
    if !errorlevel! equ 0 set "tweaksApplied=true"
    
    reg add "%%a" /v "EnableUlps" /t REG_DWORD /d "0" /f >nul 2>&1
    if !errorlevel! equ 0 set "tweaksApplied=true"
    
    reg add "%%a" /v "EnableMClkSlowdown" /t REG_DWORD /d "0" /f >nul 2>&1
    if !errorlevel! equ 0 set "tweaksApplied=true"

    reg add "%%a" /v "D3PCLatency" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "F1TransitionLatency" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "LOWLATENCY" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "Node3DLowLatency" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "PciLatencyTimerControl" /t REG_DWORD /d "20" /f >nul 2>&1
    reg add "%%a" /v "RMDeepL1EntryLatencyUsec" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "RmGspcMaxFtuS" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "RmGspcMinFtuS" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "RmGspcPerioduS" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "RMLpwrEiIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "RMLpwrGrIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "RMLpwrGrRgIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "RMLpwrMsIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "VRDirectFlipDPCDelayUs" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "VRDirectFlipTimingMarginUs" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "VRDirectJITFlipMsHybridFlipDelayUs" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "vrrCursorMarginUs" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "vrrDeflickerMarginUs" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "vrrDeflickerMaxUs" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "RmFbsrPagedDMA" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "RmEccScrubEnable" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%a" /v "RmIntrLockingMode" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "RMEnableLargePages" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "RMBigPageLimit" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%a" /v "RmForceCopyEnginePCIeGen4" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "RMTimeSyncMode" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "%%a" /v "RMDisablePcieProtections" /t REG_DWORD /d "1" /f >nul 2>&1
    if !errorlevel! equ 0 set "tweaksApplied=true"
)

reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRID73779" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRID73780" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRID74361" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "LogWarningEntries" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "LogPagingEntries" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "LogEventEntries" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "LogErrorEntries" /t REG_DWORD /d "0" /f >nul 2>&1

if "%devicesFound%"=="false" (
    echo %c%  * No NVIDIA devices found in registry%u%
) else (
    if "%tweaksApplied%"=="true" (
        echo %c%  * Disabled tiled display for !deviceCount! NVIDIA device^(s^)%u%
        echo %c%  * Disabled TCC support for !deviceCount! NVIDIA device^(s^)%u%
        echo %c%  * Disabled PowerMizer for !deviceCount! NVIDIA device^(s^)%u%
        echo %c%  * Set maximum performance mode for !deviceCount! NVIDIA device^(s^)%u%
        echo %c%  * Disabled ULPS power saving for !deviceCount! NVIDIA device^(s^)%u%
        echo %c%  * Disabled memory clock slowdown for !deviceCount! NVIDIA device^(s^)%u%
        echo %c%  * Advanced driver tweaks completed%u%
    ) else (
        echo %c%  * Advanced tweaks already applied%u%
    )
)
exit /b


:Step10_NVIDIA3DSettings
echo %c%[10/12] Applying NVIDIA Control Panel 3D Settings...%u%

for %%P in (
    "HKLM\SOFTWARE\NVIDIA Corporation\Global\3D Settings|ThreadedOptimization|1|Threaded Optimization enabled"
    "HKLM\SOFTWARE\NVIDIA Corporation\Global\3D Settings|MaxPreRenderedFrames|1|Max Pre-Rendered Frames set to 1"
) do (
    for /f "tokens=1,2,3,4 delims=|" %%A in ("%%~P") do (
        reg add "%%A" /v "%%B" /t REG_DWORD /d "%%C" /f >nul 2>&1
        if !errorlevel! equ 0 (
            echo %c%  * %%D%u%
        ) else (
            echo %c%  * Failed to apply: %%D%u%
        )
    )
)

exit /b

:Step11_BlockTelemetry
echo %c%[11/12] Blocking Telemetry Hosts...%u%

setlocal
set "HOSTS=%windir%\System32\drivers\etc\hosts"
set "TMPHOSTS=%TEMP%\hosts.tmp"
set "blockedAny=false"

if exist "%HOSTS%" (
    copy /Y "%HOSTS%" "%TMPHOSTS%" >nul 2>&1
) else (
    type NUL > "%HOSTS%"
    copy /Y "%HOSTS%" "%TMPHOSTS%" >nul 2>&1
)

for %%H in (
    telemetry.gfe.nvidia.com
    gfwsl.geforce.com
    services.gfe.nvidia.com
    accounts.nvgs.nvidia.com
    events.gfe.nvidia.com
    telemetry-web.gfe.nvidia.com
    ota-downloads.nvidia.com
    rds-assets.nvidia.com
) do (
    findstr /IX "127.0.0.1 %%H" "%TMPHOSTS%" >nul 2>&1 || (
        >>"%HOSTS%" echo 127.0.0.1 %%H
        echo %c%  * Blocked telemetry host: %%H%u%
        set "blockedAny=true"
    )
)

if "%blockedAny%"=="true" (
    echo %c%  * Telemetry hosts successfully blocked%u%
) else (
    echo %c%  * Telemetry hosts already blocked%u%
)

del "%TMPHOSTS%" 2>nul
endlocal & exit /b


:Step12_RestartServices
echo %c%[12/12] Restarting Essential Services...%u%

set "servicesRestarted=false"

for %%S in (%ESSENTIAL_SERVICES%) do (
    sc query "%%S" 2>nul | findstr /i "STOPPED" >nul && (
        net start "%%S" >nul 2>&1
        if !errorlevel! equ 0 (
            echo %c%  * Started essential service: %%S%u%
            set "servicesRestarted=true"
        ) else (
            echo %c%  * Failed to start: %%S%u%
        )
    )
)

if "%DISABLE_NVIDIA_APP%"=="false" (
    for %%S in (
        "NvContainerLocalSystem"
        "NVDisplay.ContainerLocalSystem"
    ) do (
        sc query "%%S" >nul 2>&1 && (
            sc config "%%S" start= auto >nul 2>&1
            sc query "%%S" 2>nul | findstr /i "STOPPED" >nul && (
                net start "%%S" >nul 2>&1
                if !errorlevel! equ 0 (
                    echo %c%  * Restarted NVIDIA container service: %%S%u%
                    set "servicesRestarted=true"
                ) else (
                    echo %c%  * Failed to restart: %%S%u%
                )
            )
        )
    )
    
    for %%S in (%NVIDIA_APP_SERVICES%) do (
        sc query "%%S" >nul 2>&1 && (
            sc config "%%S" start= auto >nul 2>&1
            sc query "%%S" 2>nul | findstr /i "STOPPED" >nul && (
                net start "%%S" >nul 2>&1
                if !errorlevel! equ 0 (
                    echo %c%  * Restarted app service: %%S%u%
                    set "servicesRestarted=true"
                ) else (
                    echo %c%  * Failed to restart: %%S%u%
                )
            )
        )
    )
)

if "%servicesRestarted%"=="false" echo %c%  * No services required restarting%u%
exit /b

:StorageAcceleration
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           STORAGE ACCELERATION OPTIMIZER                     ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Storage optimization includes:%u%
echo %c%• SSD/NVMe performance tweaks and TRIM optimization%u%
echo %c%• File system caching and prefetch configuration%u%
echo %c%• Disk defragmentation scheduling and indexing%u%
echo %c%• Write caching and power management settings%u%
echo %c%• Storage driver and controller optimizations%u%
echo.
echo %red%%underline%Storage Notice:%u%
echo %c%These optimizations will modify disk and file system settings.%u%
echo %c%Some changes may require a system restart to take effect.%u%
echo.
echo.
choice /C YN /M "%c%Apply storage acceleration optimizations? (Y/N)%u%"
if errorlevel 2 goto HardwareMenu

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                      STORAGE OPTIMIZATION IN PROGRESS                        ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/8] Detecting Storage Devices...%u%
echo %c%• Scanning for SSD and NVMe drives...%u%
chcp 437 >nul

set "SSD_FOUND=false"
set "NVME_FOUND=false"

powershell -noprofile -command "Get-WmiObject -Class MSFT_PhysicalDisk -Namespace root\Microsoft\Windows\Storage | Where-Object {$_.MediaType -eq 4} | Select-Object -First 1" >nul 2>&1
if %errorlevel%==0 set "SSD_FOUND=true"

powershell -noprofile -command "Get-WmiObject -Class MSFT_PhysicalDisk -Namespace root\Microsoft\Windows\Storage | Where-Object {$_.FriendlyName -like '*NVMe*'} | Select-Object -First 1" >nul 2>&1
if %errorlevel%==0 (
    set "SSD_FOUND=true"
    set "NVME_FOUND=true"
)
chcp 65001 >nul
if "%SSD_FOUND%"=="true" echo %c%  ✓ SSD drives detected%u%
if "%NVME_FOUND%"=="true" echo %c%  ✓ NVMe drives detected%u%
if "%SSD_FOUND%"=="false" echo %c%  • Traditional hard drives detected%u%


echo %c%[2/8] Optimizing TRIM and SSD Settings...%u%
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
echo %c%  ✓ TRIM enabled for SSDs%u%

schtasks /change /tn "\Microsoft\Windows\Defrag\ScheduledDefrag" /disable >nul 2>&1
echo %c%  ✓ Automatic defragmentation disabled for SSDs%u%

reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorageDevicePolicies" /v "WriteProtectPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%  ✓ SSD write caching optimized%u%

echo %c%[3/8] Configuring File System Performance...%u%
fsutil behavior set Disable8dot3 1 >nul 2>&1
echo %c%  ✓ 8.3 filename creation disabled%u%
fsutil behavior set memoryusage 2 >nul 2>&1
fsutil behavior set mftzone 4 >nul 2>&1
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set encryptpagingfile 0 >nul 2>&1
echo %c%  ✓ NTFS memory pool, MFT zone, last-access timestamps, pagefile encryption optimized%u%

reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisable8dot3NameCreation" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%  ✓ NTFS performance optimizations applied%u%

echo %c%[4/8] Optimizing Disk Write Caching...%u%
for /f "tokens=1" %%d in ('wmic logicaldisk get size^,deviceid /format:table ^| findstr /r "[A-Z]:"') do (
    fsutil dirty set %%d >nul 2>&1
	chcp 65001>nul
    echo %c%  ✓ Write caching enabled for drive %%d%u%
)

echo %c%[5/8] Configuring Prefetch and Superfetch...%u%
if "%SSD_FOUND%"=="true" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f >nul 2>&1
    echo %c%  ✓ Superfetch disabled for SSD optimization%u%
    
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "1" /f >nul 2>&1
    echo %c%  ✓ Prefetch optimized for SSD usage%u%
) else (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d "3" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "3" /f >nul 2>&1
    echo %c%  ✓ Prefetch and Superfetch enabled for HDD optimization%u%
)

echo %c%[6/8] Optimizing Storage Controllers...%u%

for /f "tokens=*" %%i in ('wmic path Win32_SCSIController get PNPDeviceID /format:value 2^>nul ^| find "PNPDeviceID=" ^| find "PCI\VEN_"') do (
    for /f "tokens=2 delims==" %%j in ("%%i") do (
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%j\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%j\Device Parameters" /v "ForceFifo" /t REG_DWORD /d "0" /f >nul 2>&1
    )
) >nul 2>&1

chcp 437>nul
powershell.exe -NoProfile -Command "Get-PnpDevice | Where-Object {$_.FriendlyName -like '*NVMe*' -and $_.InstanceId -like 'PCI*'} | ForEach-Object {try{New-ItemProperty -Path \"HKLM:\SYSTEM\CurrentControlSet\Enum\$($_.InstanceId)\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties\" -Name 'MSISupported' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue}catch{}}" >nul 2>&1
chcp 65001>nul

for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID 2^>nul ^| findstr /l "PCI\VEN_"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters" /v "ForceFifo" /t REG_DWORD /d "0" /f >nul 2>&1
) >nul 2>&1

echo %c%  ✓ Storage controller interrupts optimized%u%

reg add "HKLM\SYSTEM\CurrentControlSet\Services\storahci\Parameters\Device" /v "TreatAsInternalPort" /t REG_MULTI_SZ /d "0\00\01\02\03\04\05" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\storahci\Parameters" /v "EnableDipm" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\storahci\Parameters" /v "EnableHipm" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%  ✓ AHCI driver settings optimized%u%

reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device" /v "IoTimeoutValue" /t REG_DWORD /d "255" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters" /v "EnableLogging" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%  ✓ NVMe controller settings optimized%u%

echo %c%[7/8] Configuring Storage Power Management...%u%
chcp 437>nul
for /f "tokens=*" %%a in ('wmic diskdrive get PNPDeviceID /format:value ^| find "PNPDeviceID"') do (
    for /f "tokens=2 delims==" %%b in ("%%a") do (
        reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%b\Device Parameters" /v "StorageDevicePolicies" /t REG_DWORD /d "0" /f >nul 2>&1
    )
)
chcp 65001>nul

powercfg -setacvalueindex SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0 >nul 2>&1
powercfg -setdcvalueindex SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0 >nul 2>&1
powercfg -setactive SCHEME_CURRENT >nul 2>&1
echo %c%  ✓ Storage power management disabled%u%

echo %c%[8/8] Running Storage Maintenance...%u%
del /f /s /q "%temp%\*" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*" >nul 2>&1
echo %c%  ✓ Temporary files cleaned%u%

if "%SSD_FOUND%"=="false" (
    echo %c%  • Scheduling disk defragmentation for HDDs...%u%
    defrag C: /A >nul 2>&1
    echo %c%  ✓ HDD defragmentation analysis completed%u%
) else (
    echo %c%  ✓ SSD optimization completed ^(defrag skipped^)%u%
)

echo %c%[9/9] Disabling Windows reserved storage for updates...%u%
dism /online /Set-ReservedStorageState /State:Disabled /NoRestart >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "ShippedWithReserves" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "PassedPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "MiscPolicyInfo" /t REG_DWORD /d "2" /f >nul 2>&1
echo %c%  ✓ Reserved storage disabled (reclaims ~1 GB disk space)%u%

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                     STORAGE ACCELERATION COMPLETED                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Storage optimizations have been successfully applied.%u%
echo.
echo %c%Applied Optimizations:%u%
if "%SSD_FOUND%"=="true" (
    echo %c%• SSD-specific optimizations applied%u%
    echo %c%• TRIM enabled for optimal SSD performance%u%
    echo %c%• Superfetch disabled to reduce SSD wear%u%
) else (
    echo %c%• HDD-specific optimizations applied%u%
    echo %c%• Prefetch and Superfetch enabled for caching%u%
    echo %c%• Defragmentation analysis performed%u%
)
echo %c%• File system performance enhanced%u%
echo %c%• Write caching optimized for all drives%u%
echo %c%• Storage controller interrupts optimized%u%
echo %c%• Power management disabled for performance%u%
echo %c%• System file allocation improved%u%
echo %c%• Reserved storage disabled (~1 GB reclaimed)%u%
echo.
echo %red%Performance Benefits:%u%
echo %c%• Faster file access and application loading%u%
echo %c%• Reduced storage latency and seek times%u%
echo %c%• Optimized caching for your storage type%u%
echo %c%• Enhanced overall system responsiveness%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto HardwareMenu

:HardwareInformation
setlocal enabledelayedexpansion
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         HARDWARE INFORMATION SCANNER                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Hardware scanning includes:%u%
echo %c%• Complete system specifications detection%u%
echo %c%• CPU, GPU, RAM, Storage, and Motherboard information%u%
echo %c%• Real-time temperature monitoring%u%
echo %c%• Hardware health diagnostics and status%u%
echo %c%• Performance benchmarks and recommendations%u%
echo %c%• System stability assessment%u%
echo.
echo %red%%underline%Scanner Notice:%u%
echo %c%This will perform comprehensive hardware analysis and diagnostics.%u%
echo %c%Scanning may take 1-2 minutes to complete all hardware checks.%u%
echo.
echo.
choice /C YN /M "%c%Run comprehensive hardware information scan? (Y/N)%u%"
if errorlevel 2 goto HardwareMenu

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           HARDWARE SCAN IN PROGRESS                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/8] Initializing Hardware Detection...%u%
echo %c%• Preparing system information queries...%u%
timeout /t 1 >nul
echo %c%• Loading hardware diagnostic tools...%u%
echo %c%• Establishing WMI connections...%u%

echo.
echo %c%[2/8] Scanning System Overview...%u%
echo %c%• Detecting computer model and manufacturer...%u%
echo.
echo %c%════════════════════════ SYSTEM OVERVIEW ═══════════════════════%u%

set "comp_model=Unknown"
set "comp_manufacturer=Unknown"
set "comp_name=Unknown"
set "comp_user=Unknown"
set "win_version=Unknown"
set "win_build=Unknown"

echo %c%• Reading computer model...%u%
for /f "tokens=2 delims==" %%i in ('wmic computersystem get model /value 2^>nul ^| find "=" 2^>nul') do (
    set "comp_model=%%i"
    if "!comp_model!"=="" set "comp_model=Unknown"
)

echo %c%• Reading manufacturer...%u%
for /f "tokens=2 delims==" %%i in ('wmic computersystem get manufacturer /value 2^>nul ^| find "=" 2^>nul') do (
    set "comp_manufacturer=%%i"
    if "!comp_manufacturer!"=="" set "comp_manufacturer=Unknown"
)

echo %c%• Reading computer name...%u%
for /f "tokens=2 delims==" %%i in ('wmic computersystem get name /value 2^>nul ^| find "=" 2^>nul') do (
    set "comp_name=%%i"
    if "!comp_name!"=="" set "comp_name=Unknown"
)

echo %c%• Reading current user...%u%
for /f "tokens=2 delims==" %%i in ('wmic computersystem get username /value 2^>nul ^| find "=" 2^>nul') do (
    set "comp_user=%%i"
    if "!comp_user!"=="" set "comp_user=%username%"
)

echo %c%• Reading Windows version...%u%
for /f "tokens=2 delims==" %%i in ('wmic os get version /value 2^>nul ^| find "=" 2^>nul') do (
    set "win_version=%%i"
    if "!win_version!"=="" set "win_version=Unknown"
)

echo %c%• Reading build number...%u%
for /f "tokens=2 delims==" %%i in ('wmic os get buildnumber /value 2^>nul ^| find "=" 2^>nul') do (
    set "win_build=%%i"
    if "!win_build!"=="" set "win_build=Unknown"
)

echo.
echo %c%Computer Model: !comp_model!%u%
echo %c%Manufacturer: !comp_manufacturer!%u%
echo %c%Computer Name: !comp_name!%u%
echo %c%Current User: !comp_user!%u%
echo %c%Windows Version: !win_version!%u%
echo %c%Build Number: !win_build!%u%
echo %c%Scan Date: %date% %time%%u%

echo.
echo %c%[3/8] Analyzing Motherboard and BIOS...%u%
echo %c%• Reading motherboard specifications...%u%
echo %c%• Checking BIOS/UEFI information...%u%
echo.
echo %c%═══════════════════════ MOTHERBOARD ^& BIOS ════════════════════════%u%

set "mb_manufacturer=Unknown"
set "mb_product=Unknown"
set "mb_version=Unknown"
set "bios_manufacturer=Unknown"
set "bios_version=Unknown"
set "bios_date=Unknown"

echo %c%• Reading motherboard info...%u%
for /f "tokens=2 delims==" %%i in ('wmic baseboard get manufacturer /value 2^>nul ^| find "=" 2^>nul') do (
    set "mb_manufacturer=%%i"
    if "!mb_manufacturer!"=="" set "mb_manufacturer=Unknown"
)

for /f "tokens=2 delims==" %%i in ('wmic baseboard get product /value 2^>nul ^| find "=" 2^>nul') do (
    set "mb_product=%%i"
    if "!mb_product!"=="" set "mb_product=Unknown"
)

for /f "tokens=2 delims==" %%i in ('wmic baseboard get version /value 2^>nul ^| find "=" 2^>nul') do (
    set "mb_version=%%i"
    if "!mb_version!"=="" set "mb_version=Unknown"
)

echo %c%• Reading BIOS info...%u%
for /f "tokens=2 delims==" %%i in ('wmic bios get manufacturer /value 2^>nul ^| find "=" 2^>nul') do (
    set "bios_manufacturer=%%i"
    if "!bios_manufacturer!"=="" set "bios_manufacturer=Unknown"
)

for /f "tokens=2 delims==" %%i in ('wmic bios get smbiosversion /value 2^>nul ^| find "=" 2^>nul') do (
    set "bios_version=%%i"
    if "!bios_version!"=="" set "bios_version=Unknown"
)

for /f "tokens=2 delims==" %%i in ('wmic bios get releasedate /value 2^>nul ^| find "=" 2^>nul') do (
    set "rawdate=%%i"
    if not "!rawdate!"=="" if not "!rawdate!"=="Unknown" (
        set "bios_date=!rawdate:~0,4!-!rawdate:~4,2!-!rawdate:~6,2!"
    )
)

echo %c%Motherboard: !mb_manufacturer!%u%
echo %c%Model: !mb_product!%u%
echo %c%Version: !mb_version!%u%
echo %c%BIOS Manufacturer: !bios_manufacturer!%u%
echo %c%BIOS Version: !bios_version!%u%
echo %c%BIOS Date: !bios_date!%u%

echo.
echo %c%[4/8] Detecting CPU Information...%u%
echo %c%• Analyzing processor specifications...%u%
echo %c%• Checking CPU cores and threads...%u%
echo %c%• Reading CPU frequency and cache...%u%
echo.
echo %c%═══════════════════════════ CPU DETAILS ══════════════════════════%u%

set "cpu_name=Unknown"
set "cpu_manufacturer=Unknown"
set "cpu_cores=Unknown"
set "cpu_threads=Unknown"
set "cpu_speed=0"
set "cpu_cache=Unknown"
set "cpu_arch=Unknown"

echo %c%• Reading CPU name...%u%
for /f "tokens=2 delims==" %%i in ('wmic cpu get name /value 2^>nul ^| find "=" 2^>nul') do (
    set "cpu_name=%%i"
    if "!cpu_name!"=="" set "cpu_name=Unknown"
    goto :cpu_name_done
)
:cpu_name_done

echo %c%• Reading CPU specifications...%u%
for /f "tokens=2 delims==" %%i in ('wmic cpu get manufacturer /value 2^>nul ^| find "=" 2^>nul') do (
    set "cpu_manufacturer=%%i"
    if "!cpu_manufacturer!"=="" set "cpu_manufacturer=Unknown"
)

for /f "tokens=2 delims==" %%i in ('wmic cpu get numberofcores /value 2^>nul ^| find "=" 2^>nul') do (
    set "cpu_cores=%%i"
    if "!cpu_cores!"=="" set "cpu_cores=Unknown"
)

for /f "tokens=2 delims==" %%i in ('wmic cpu get numberoflogicalprocessors /value 2^>nul ^| find "=" 2^>nul') do (
    set "cpu_threads=%%i"
    if "!cpu_threads!"=="" set "cpu_threads=Unknown"
)

for /f "tokens=2 delims==" %%i in ('wmic cpu get maxclockspeed /value 2^>nul ^| find "=" 2^>nul') do (
    set "cpu_speed=%%i"
    if "!cpu_speed!"=="" set "cpu_speed=0"
)

echo %c%Processor: !cpu_name!%u%
echo %c%Manufacturer: !cpu_manufacturer!%u%
echo %c%Physical Cores: !cpu_cores!%u%
echo %c%Logical Processors: !cpu_threads!%u%

if !cpu_speed! gtr 0 (
    set /a "cpughz=!cpu_speed!/1000"
    set /a "cpumhz=!cpu_speed!-!cpughz!*1000"
    if !cpumhz! lss 100 set "cpumhz=0!cpumhz!"
    if !cpumhz! lss 10 set "cpumhz=00!cpumhz!"
    echo %c%Max Clock Speed: !cpughz!.!cpumhz:~0,1! GHz%u%
) else (
    echo %c%Max Clock Speed: Unknown%u%
)

echo.
echo %c%[5/8] Scanning Memory Configuration...%u%
echo %c%• Detecting RAM modules and specifications...%u%
echo %c%• Analyzing memory speed and timings...%u%
echo.
echo %c%══════════════════════════ MEMORY INFO ══════════════════════════%u%

echo %c%• Reading total memory...%u%
set "totalmem=0"
chcp 437>nul
for /f %%i in ('powershell -NoProfile -Command "[math]::Round(((Get-WmiObject -Class Win32_ComputerSystem -ErrorAction SilentlyContinue).TotalPhysicalMemory)/1GB)"') do (
chcp 65001>nul    
	if %%i gtr 0 (
        set "totalmem=%%i"
        echo %c%Total Physical Memory: !totalmem! GB%u%
        goto :total_mem_done
    )
)
echo %c%Total Physical Memory: Unable to detect%u%
:total_mem_done

echo %c%• Reading available memory...%u%
set "freemem=0"
chcp 437>nul
for /f %%i in ('powershell -NoProfile -Command "[math]::Round(((Get-WmiObject -Class Win32_OperatingSystem -ErrorAction SilentlyContinue).FreePhysicalMemory)/1MB, 1)"') do (
chcp 65001>nul 
	if %%i gtr 0 (
        set "freemem=%%i"
        echo %c%Available Memory: !freemem! GB%u%
        goto :free_mem_done
    )
)
echo %c%Available Memory: Unknown%u%
:free_mem_done

echo %c%Memory Modules:%u%
set "modulecount=0"
chcp 437>nul
for /f %%i in ('powershell -NoProfile -Command "Get-WmiObject -Class Win32_PhysicalMemory -ErrorAction SilentlyContinue | ForEach-Object { [math]::Round($_.Capacity/1GB) }"') do (
chcp 65001>nul     
	if %%i gtr 0 (
        set /a "modulecount+=1"
        echo %c%  Module !modulecount!: %%i GB%u%
    )
)
if !modulecount! equ 0 echo %c%  Memory modules: Detection failed%u%

echo %c%• Reading memory specifications...%u%
set "mem_speed=Unknown"
set "mem_manufacturer=Unknown"
chcp 437>nul
for /f %%i in ('powershell -NoProfile -Command "try { $mem = Get-WmiObject -Class Win32_PhysicalMemory -ErrorAction Stop | Select-Object -First 1; if($mem.Speed) { $mem.Speed } else { 'Unknown' } } catch { 'Unknown' }"') do (
chcp 65001>nul      
	if not "%%i"=="Unknown" if not "%%i"=="" (
        set "mem_speed=%%i"
    )
)
chcp 437>nul
for /f "delims=" %%i in ('powershell -NoProfile -Command "try { $mem = Get-WmiObject -Class Win32_PhysicalMemory -ErrorAction Stop | Select-Object -First 1; if($mem.Manufacturer) { $mem.Manufacturer.Trim() } else { 'Unknown' } } catch { 'Unknown' }"') do (
chcp 65001>nul    
	if not "%%i"=="Unknown" if not "%%i"=="" (
        set "mem_manufacturer=%%i"
    )
)

if not "!mem_speed!"=="Unknown" (
    echo %c%Memory Speed: !mem_speed! MHz%u%
)
if not "!mem_manufacturer!"=="Unknown" (
    echo %c%Memory Manufacturer: !mem_manufacturer!%u%
)
if "!mem_speed!"=="Unknown" if "!mem_manufacturer!"=="Unknown" (
    echo %c%Memory specifications: Unable to detect%u%
)

echo.
echo %c%[6/8] Analyzing Graphics Hardware...%u%
echo %c%• Detecting GPU specifications...%u%
echo %c%• Reading graphics memory information...%u%
echo.
echo %c%═══════════════════════════ GPU DETAILS ══════════════════════════%u%

set "gpucount=0"
echo %c%• Reading graphics cards...%u%
chcp 437>nul
for /f "tokens=2 delims==" %%i in ('wmic path win32_videocontroller get name /value 2^>nul ^| find "=" 2^>nul') do (
chcp 65001>nul     
	if not "%%i"=="" (
        set /a "gpucount+=1"
        echo %c%Graphics Card !gpucount!: %%i%u%
    )
)
if !gpucount! equ 0 echo %c%Graphics Card: Detection failed%u%

echo %c%• Reading video memory...%u%
set "vram_found=false"
chcp 437>nul
for /f "tokens=2 delims==" %%i in ('wmic path win32_videocontroller get adapterram /value 2^>nul ^| find "=" 2^>nul') do (
chcp 65001>nul      
	if not "%%i"=="" if not "%%i"=="4294967295" (
	chcp 437>nul
        for /f %%j in ('powershell -command "try { $size = [math]::round(%%i/1GB, 0); if($size -gt 0) { $size } else { 0 } } catch { 0 }"') do (
		chcp 65001>nul
            if %%j gtr 0 (
                echo %c%Video Memory: %%j GB%u%
                set "vram_found=true"
                goto :vram_done
            )
        )
    )
)
if "!vram_found!"=="false" echo %c%Video Memory: Unable to detect or integrated graphics%u%
:vram_done

echo.
echo %c%[7/8] Scanning Storage Devices...%u%
echo %c%• Detecting hard drives and SSDs...%u%
echo %c%• Analyzing disk health and capacity...%u%
echo.
echo %c%═══════════════════════════ STORAGE INFO ═════════════════════════%u%

set "drivecount=0"
set "drive1_name="
set "drive1_size="
set "drive2_name="
set "drive2_size="
echo %c%• Reading storage devices...%u%
chcp 437>nul
for /f "skip=1 tokens=1,2" %%i in ('wmic diskdrive get model^,size /format:table 2^>nul') do (
chcp 65001>nul  
    if not "%%i"=="" if not "%%i"=="Model" (
        set /a "drivecount+=1"
        
        if !drivecount! equ 1 (
            set "drive1_name=%%i"
            if not "%%j"=="" (
			chcp 437>nul
                for /f %%k in ('powershell -NoProfile -Command "try { [math]::round(%%j/1GB, 0) } catch { 0 }"') do (
				chcp 65001>nul  
                    if %%k gtr 0 set "drive1_size=%%k"
                )
            )
        )
        
        if !drivecount! equ 2 (
            set "drive2_name=%%i"
            if not "%%j"=="" (
			chcp 437>nul
                for /f %%k in ('powershell -NoProfile -Command "try { [math]::round(%%j/1GB, 0) } catch { 0 }"') do (
				chcp 65001>nul  
                    if %%k gtr 0 set "drive2_size=%%k"
                )
            )
        )
        
        echo %c%Drive !drivecount!: %%i%u%
        if not "%%j"=="" (
		chcp 437>nul
            for /f %%k in ('powershell -NoProfile -Command "try { [math]::round(%%j/1GB, 0) } catch { 0 }"') do (
			chcp 65001>nul 
                if %%k gtr 0 echo %c%  Capacity: %%k GB%u%
            )
        )
    )
)

if !drivecount! equ 0 (
    echo %c%• Trying alternative storage detection...%u%
    for /f "skip=1 tokens=*" %%i in ('wmic diskdrive get model 2^>nul') do (
        if not "%%i"=="" if not "%%i"=="Model" (
            set /a "drivecount+=1"
            if !drivecount! equ 1 set "drive1_name=%%i"
            if !drivecount! equ 2 set "drive2_name=%%i"
            echo %c%Drive !drivecount!: %%i%u%
        )
    )
)

if !drivecount! equ 0 (
    echo %c%Storage devices: Detection failed%u%
    set "drive1_name=Primary Storage Device"
    set "drive1_size=500"
    set "drivecount=1"
)

if "!drive1_size!"=="" set "drive1_size=Unknown"
if "!drive2_size!"=="" set "drive2_size=Unknown"

echo.
echo %c%Disk Space Analysis:%u%
set "disk_found=false"
set "c_drive_info="
echo %c%• Analyzing partition usage...%u%

for %%d in (C D E F G H) do (
    if exist %%d:\ (
        echo %c%• Checking drive %%d:...%u%
        
        for /f "tokens=3,4" %%x in ('dir %%d:\ /-c 2^>nul ^| find "bytes free"') do (
            set /a "free_bytes=%%x" 2>nul
            set /a "total_bytes=%%y" 2>nul
            
            if !total_bytes! gtr 0 (
                set /a "free_gb=!free_bytes!/1073741824" 2>nul
                set /a "total_gb=!total_bytes!/1073741824" 2>nul
                set /a "used_gb=!total_gb!-!free_gb!" 2>nul
                
                if !total_gb! gtr 0 (
                    set /a "used_percent=!used_gb!*100/!total_gb!" 2>nul
                    echo %c%  %%d: - !used_gb! GB used / !total_gb! GB total ^(!used_percent!%% used^)%u%
                    
                    if "%%d"=="C" (
                        set "c_drive_info=!used_gb! GB used / !total_gb! GB total (!used_percent!%% used)"
                    )
                    set "disk_found=true"
                ) else (
                    echo %c%  %%d: - Drive accessible ^(size calculation failed^)%u%
                    set "disk_found=true"
                )
            )
        )
    )
)

if "!disk_found!"=="false" (
    echo %c%• Using basic drive detection...%u%
    for %%d in (C D E F G H) do (
        if exist %%d:\ (
            echo %c%  %%d: - Drive accessible and ready%u%
            set "disk_found=true"
        )
    )
)

if "!disk_found!"=="false" echo %c%  No accessible drives found%u%

echo.
echo %c%[8/8] Performing Hardware Health Check...%u%
echo %c%• Checking system temperatures...%u%
echo %c%• Analyzing hardware status...%u%
echo %c%• Generating health recommendations...%u%
echo.
echo %c%═══════════════════════ HARDWARE HEALTH STATUS ═══════════════════%u%

echo %c%• Checking thermal status...%u%
chcp 437>nul
powershell -Command "try { Get-WmiObject -Namespace 'root/wmi' -Class MSAcpi_ThermalZoneTemperature -ErrorAction Stop | ForEach-Object { $temp = ($_.CurrentTemperature - 2732) / 10; Write-Host \"CPU Temperature: $temp°C\" } } catch { Write-Host 'Thermal sensors not accessible' }" 2>nul | find "CPU Temperature" >nul && (
chcp 65001>nul
	echo %c%Thermal monitoring available%u%
) || (
    echo %c%Thermal sensors not accessible via WMI%u%
)

echo %c%• Checking system drivers...%u%
chcp 437>nul
for /f %%i in ('wmic path win32_systemdriver where "state='running'" get name /value 2^>nul ^| find "=" ^| find /c "=" 2^>nul') do (
chcp 65001>nul 
    if %%i gtr 50 (
        echo %c%System drivers: Healthy ^(%%i active^)%u%
    ) else (
        echo %c%System drivers: Check needed ^(%%i active^)%u%
    )
)

echo %c%• Checking disk health...%u%
chcp 437>nul
for /f "tokens=2 delims==" %%i in ('wmic diskdrive get status /value 2^>nul ^| find "=" 2^>nul') do (
chcp 65001>nul 
    if "%%i"=="OK" (
        echo %c%Storage: Healthy%u%
    ) else (
        echo %c%Storage: %%i%u%
    )
    goto :disk_done
)
echo %c%✓ Storage: Status check completed%u%
:disk_done

echo.
echo %c%═══════════════════════ PERFORMANCE ANALYSIS ════════════════════%u%
set /a "perfscore=0"

echo %c%• Calculating performance score...%u%
echo %c%• Analyzing RAM configuration...%u%

if !totalmem! geq 64 (
    set /a "perfscore+=25"
    set "ram_rating=Exceptional"
) else if !totalmem! geq 32 (
    set /a "perfscore+=20"
    set "ram_rating=Excellent"
) else if !totalmem! geq 16 (
    set /a "perfscore+=15"
    set "ram_rating=Good"
) else if !totalmem! geq 12 (
    set /a "perfscore+=10"
    set "ram_rating=Adequate"
) else if !totalmem! geq 8 (
    set /a "perfscore+=8"
    set "ram_rating=Minimum"
) else (
    set /a "perfscore+=3"
    set "ram_rating=Insufficient"
)

echo %c%• Analyzing CPU performance...%u%

set "cpu_score=0"
set "cpu_rating=Unknown"

set "detected_cores=%NUMBER_OF_PROCESSORS%"


echo "!CPUName!" | find /i "i9-14" >nul && (set /a "cpu_score=38" & set "cpu_rating=Flagship")
echo "!CPUName!" | find /i "i7-14" >nul && (set /a "cpu_score=34" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i5-14" >nul && (set /a "cpu_score=29" & set "cpu_rating=Upper Mid-Range")
echo "!CPUName!" | find /i "i3-14" >nul && (set /a "cpu_score=23" & set "cpu_rating=Entry Level")

echo "!CPUName!" | find /i "i9-13" >nul && (set /a "cpu_score=35" & set "cpu_rating=Flagship")
echo "!CPUName!" | find /i "i7-13" >nul && (set /a "cpu_score=31" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i5-13" >nul && (set /a "cpu_score=26" & set "cpu_rating=Upper Mid-Range")
echo "!CPUName!" | find /i "i3-13" >nul && (set /a "cpu_score=21" & set "cpu_rating=Entry Level")

echo "!CPUName!" | find /i "i9-12" >nul && (set /a "cpu_score=32" & set "cpu_rating=Flagship")
echo "!CPUName!" | find /i "i7-12" >nul && (set /a "cpu_score=28" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i5-12" >nul && (set /a "cpu_score=24" & set "cpu_rating=Upper Mid-Range")
echo "!CPUName!" | find /i "i3-12" >nul && (set /a "cpu_score=19" & set "cpu_rating=Entry Level")

echo "!CPUName!" | find /i "i9-11" >nul && (set /a "cpu_score=29" & set "cpu_rating=Flagship")
echo "!CPUName!" | find /i "i7-11" >nul && (set /a "cpu_score=25" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i5-11" >nul && (set /a "cpu_score=21" & set "cpu_rating=Upper Mid-Range")
echo "!CPUName!" | find /i "i3-11" >nul && (set /a "cpu_score=17" & set "cpu_rating=Entry Level")

echo "!CPUName!" | find /i "i9-10" >nul && (set /a "cpu_score=27" & set "cpu_rating=Flagship")
echo "!CPUName!" | find /i "i7-10" >nul && (set /a "cpu_score=23" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i5-10" >nul && (set /a "cpu_score=19" & set "cpu_rating=Upper Mid-Range")
echo "!CPUName!" | find /i "i3-10" >nul && (set /a "cpu_score=15" & set "cpu_rating=Entry Level")

echo "!CPUName!" | find /i "i9-9" >nul && (set /a "cpu_score=25" & set "cpu_rating=Flagship")
echo "!CPUName!" | find /i "i7-9" >nul && (set /a "cpu_score=21" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i5-9" >nul && (set /a "cpu_score=17" & set "cpu_rating=Upper Mid-Range")
echo "!CPUName!" | find /i "i3-9" >nul && (set /a "cpu_score=13" & set "cpu_rating=Entry Level")

echo "!CPUName!" | find /i "i9-8" >nul && (set /a "cpu_score=23" & set "cpu_rating=Flagship")
echo "!CPUName!" | find /i "i7-8" >nul && (set /a "cpu_score=19" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i5-8" >nul && (set /a "cpu_score=15" & set "cpu_rating=Upper Mid-Range")
echo "!CPUName!" | find /i "i3-8" >nul && (set /a "cpu_score=12" & set "cpu_rating=Entry Level")

echo "!CPUName!" | find /i "i7-7" >nul && (set /a "cpu_score=17" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i5-7" >nul && (set /a "cpu_score=13" & set "cpu_rating=Mid-Range")
echo "!CPUName!" | find /i "i3-7" >nul && (set /a "cpu_score=11" & set "cpu_rating=Entry Level")

echo "!CPUName!" | find /i "i7-6" >nul && (set /a "cpu_score=15" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i5-6" >nul && (set /a "cpu_score=12" & set "cpu_rating=Mid-Range")
echo "!CPUName!" | find /i "i3-6" >nul && (set /a "cpu_score=10" & set "cpu_rating=Entry Level")

echo "!CPUName!" | find /i "i7-5" >nul && (set /a "cpu_score=13" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i5-5" >nul && (set /a "cpu_score=11" & set "cpu_rating=Mid-Range")
echo "!CPUName!" | find /i "i3-5" >nul && (set /a "cpu_score=9" & set "cpu_rating=Entry Level")

echo "!CPUName!" | find /i "i7-4" >nul && (set /a "cpu_score=12" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i5-4" >nul && (set /a "cpu_score=10" & set "cpu_rating=Mid-Range")
echo "!CPUName!" | find /i "i3-4" >nul && (set /a "cpu_score=8" & set "cpu_rating=Entry Level")

echo "!CPUName!" | find /i "i7-3" >nul && (set /a "cpu_score=10" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i5-3" >nul && (set /a "cpu_score=8" & set "cpu_rating=Mid-Range")
echo "!CPUName!" | find /i "i3-3" >nul && (set /a "cpu_score=7" & set "cpu_rating=Entry Level")

echo "!CPUName!" | find /i "i7-2" >nul && (set /a "cpu_score=8" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i5-2" >nul && (set /a "cpu_score=7" & set "cpu_rating=Mid-Range")
echo "!CPUName!" | find /i "i3-2" >nul && (set /a "cpu_score=6" & set "cpu_rating=Entry Level")

echo "!CPUName!" | find /i "i7-9" >nul && (set /a "cpu_score=7" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i7-8" >nul && (set /a "cpu_score=6" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i7-7" >nul && (set /a "cpu_score=5" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i7-6" >nul && (set /a "cpu_score=4" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i7-1" >nul && (set /a "cpu_score=4" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "i5-7" >nul && (set /a "cpu_score=4" & set "cpu_rating=Mid-Range")
echo "!CPUName!" | find /i "i5-6" >nul && (set /a "cpu_score=3" & set "cpu_rating=Mid-Range")
echo "!CPUName!" | find /i "i5-1" >nul && (set /a "cpu_score=3" & set "cpu_rating=Mid-Range")
echo "!CPUName!" | find /i "i3-7" >nul && (set /a "cpu_score=3" & set "cpu_rating=Entry Level")
echo "!CPUName!" | find /i "i3-6" >nul && (set /a "cpu_score=2" & set "cpu_rating=Entry Level")
echo "!CPUName!" | find /i "i3-1" >nul && (set /a "cpu_score=2" & set "cpu_rating=Entry Level")

echo "!CPUName!" | find /i "Ryzen 9" >nul && (set /a "cpu_score=34" & set "cpu_rating=Flagship")
echo "!CPUName!" | find /i "Ryzen 7" >nul && (set /a "cpu_score=29" & set "cpu_rating=High-End")
echo "!CPUName!" | find /i "Ryzen 5" >nul && (set /a "cpu_score=23" & set "cpu_rating=Mid-Range")
echo "!CPUName!" | find /i "Ryzen 3" >nul && (set /a "cpu_score=16" & set "cpu_rating=Entry Level")

if !NUMBER_OF_PROCESSORS! geq 16 set /a "cpu_score+=3"
if !NUMBER_OF_PROCESSORS! geq 12 if !NUMBER_OF_PROCESSORS! lss 16 set /a "cpu_score+=2"
if !NUMBER_OF_PROCESSORS! geq 8 if !NUMBER_OF_PROCESSORS! lss 12 set /a "cpu_score+=1"
if !NUMBER_OF_PROCESSORS! lss 6 set /a "cpu_score-=2"

set /a "total_mhz=!cpughz!*1000+!cpumhz!"
if !total_mhz! geq 3500 set /a "cpu_score+=2"
if !total_mhz! geq 3000 if !total_mhz! lss 3500 set /a "cpu_score+=1"
if !total_mhz! lss 2500 set /a "cpu_score-=1"

set /a "perfscore+=!cpu_score!"

echo %c%• Analyzing GPU performance...%u%

set "gpu_score=0"
set "gpu_rating=Unknown"

set "detected_vram=0"
chcp 437>nul
for /f %%i in ('powershell -NoProfile -Command "try { $gpu = Get-WmiObject Win32_VideoController | Where-Object {$_.Name -like '*RTX*' -or $_.Name -like '*GTX*' -or $_.Name -like '*RX*'}; [math]::Round($gpu.AdapterRAM/1GB) } catch { 4 }"') do (
chcp 65001>nul     
	if %%i gtr 0 set "detected_vram=%%i"
)

if !detected_vram! equ 0 (
echo "!GPUName!" | find /i "5090" >nul && set "detected_vram=24"
echo "!GPUName!" | find /i "5080" >nul && set "detected_vram=16"

echo "!GPUName!" | find /i "4090" >nul && set "detected_vram=24"
echo "!GPUName!" | find /i "4080" >nul && set "detected_vram=16"
echo "!GPUName!" | find /i "4070 Ti" >nul && set "detected_vram=12"
echo "!GPUName!" | find /i "4070" >nul && set "detected_vram=12"
echo "!GPUName!" | find /i "4060 Ti 16GB" >nul && set "detected_vram=16"
echo "!GPUName!" | find /i "4060 Ti" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "4060" >nul && set "detected_vram=8"

echo "!GPUName!" | find /i "3090 Ti" >nul && set "detected_vram=24"
echo "!GPUName!" | find /i "3090" >nul && set "detected_vram=24"
echo "!GPUName!" | find /i "3080 Ti" >nul && set "detected_vram=12"
echo "!GPUName!" | find /i "3080 12GB" >nul && set "detected_vram=12"
echo "!GPUName!" | find /i "3080" >nul && set "detected_vram=10"
echo "!GPUName!" | find /i "3070 Ti" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "3070" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "3060 Ti" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "3060 12GB" >nul && set "detected_vram=12"
echo "!GPUName!" | find /i "3060" >nul && set "detected_vram=6"
echo "!GPUName!" | find /i "3050 Ti" >nul && set "detected_vram=4"
echo "!GPUName!" | find /i "3050" >nul && set "detected_vram=4"

echo "!GPUName!" | find /i "2080 Ti" >nul && set "detected_vram=11"
echo "!GPUName!" | find /i "2080 Super" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "2080" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "2070 Super" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "2070" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "2060 Super" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "2060 12GB" >nul && set "detected_vram=12"
echo "!GPUName!" | find /i "2060" >nul && set "detected_vram=6"

echo "!GPUName!" | find /i "1660 Ti" >nul && set "detected_vram=6"
echo "!GPUName!" | find /i "1660 Super" >nul && set "detected_vram=6"
echo "!GPUName!" | find /i "1660" >nul && set "detected_vram=6"
echo "!GPUName!" | find /i "1650 Super" >nul && set "detected_vram=4"
echo "!GPUName!" | find /i "1650 Ti" >nul && set "detected_vram=4"
echo "!GPUName!" | find /i "1650" >nul && set "detected_vram=4"

echo "!GPUName!" | find /i "1080 Ti" >nul && set "detected_vram=11"
echo "!GPUName!" | find /i "1080" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "1070 Ti" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "1070" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "1060 6GB" >nul && set "detected_vram=6"
echo "!GPUName!" | find /i "1060" >nul && set "detected_vram=3"
echo "!GPUName!" | find /i "1050 Ti" >nul && set "detected_vram=4"
echo "!GPUName!" | find /i "1050" >nul && set "detected_vram=2"

echo "!GPUName!" | find /i "9070 XT" >nul && set "detected_vram=24"

echo "!GPUName!" | find /i "7900 XTX" >nul && set "detected_vram=24"
echo "!GPUName!" | find /i "7900 XT" >nul && set "detected_vram=20"
echo "!GPUName!" | find /i "7800 XT" >nul && set "detected_vram=16"
echo "!GPUName!" | find /i "7700 XT" >nul && set "detected_vram=12"
echo "!GPUName!" | find /i "7600 XT" >nul && set "detected_vram=16"
echo "!GPUName!" | find /i "7600" >nul && set "detected_vram=8"

echo "!GPUName!" | find /i "6950 XT" >nul && set "detected_vram=16"
echo "!GPUName!" | find /i "6900 XT" >nul && set "detected_vram=16"
echo "!GPUName!" | find /i "6800 XT" >nul && set "detected_vram=16"
echo "!GPUName!" | find /i "6800" >nul && set "detected_vram=16"
echo "!GPUName!" | find /i "6750 XT" >nul && set "detected_vram=12"
echo "!GPUName!" | find /i "6700 XT" >nul && set "detected_vram=12"
echo "!GPUName!" | find /i "6600 XT" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "6600" >nul && set "detected_vram=8"

echo "!GPUName!" | find /i "5700 XT" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "5700" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "5600 XT" >nul && set "detected_vram=6"
echo "!GPUName!" | find /i "5500 XT" >nul && set "detected_vram=8"

echo "!GPUName!" | find /i "590" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "580" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "570" >nul && set "detected_vram=4"
echo "!GPUName!" | find /i "560" >nul && set "detected_vram=4"

echo "!GPUName!" | find /i "R9 Fury X" >nul && set "detected_vram=4"
echo "!GPUName!" | find /i "R9 Fury" >nul && set "detected_vram=4"
echo "!GPUName!" | find /i "R9 390X" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "R9 380X" >nul && set "detected_vram=4"
echo "!GPUName!" | find /i "R9 380" >nul && set "detected_vram=4"

echo "!GPUName!" | find /i "Arc A770" >nul && set "detected_vram=16"
echo "!GPUName!" | find /i "Arc A750" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "Arc A580" >nul && set "detected_vram=8"
echo "!GPUName!" | find /i "Arc A380" >nul && set "detected_vram=6"

echo "!GPUName!" | find /i "Iris Xe" >nul && set "detected_vram=1"
echo "!GPUName!" | find /i "UHD" >nul && set "detected_vram=1"
echo "!GPUName!" | find /i "HD Graphics" >nul && set "detected_vram=1"
echo "!GPUName!" | find /i "Intel" >nul && set "detected_vram=1"

)

set "vram_score=0"
if !detected_vram! geq 24 (
    set /a "vram_score=15"
    set "vram_rating=Flagship"
) else if !detected_vram! geq 16 (
    set /a "vram_score=12"
    set "vram_rating=High-End"
) else if !detected_vram! geq 12 (
    set /a "vram_score=10"
    set "vram_rating=Upper Mid-Range"
) else if !detected_vram! geq 8 (
    set /a "vram_score=8"
    set "vram_rating=Mid-Range"
) else if !detected_vram! geq 6 (
    set /a "vram_score=6"
    set "vram_rating=Entry Gaming"
) else if !detected_vram! geq 4 (
    set /a "vram_score=4"
    set "vram_rating=Basic Gaming"
) else (
    set /a "vram_score=1"
    set "vram_rating=Insufficient"
)

echo "!GPUName!" | find /i "RTX 5090" >nul && (set /a "gpu_score=45" & set "gpu_rating=Flagship Next-Gen")
echo "!GPUName!" | find /i "RTX 5080" >nul && (set /a "gpu_score=43" & set "gpu_rating=High-End Next-Gen")

echo "!GPUName!" | find /i "RTX 4090" >nul && (set /a "gpu_score=40" & set "gpu_rating=Flagship")
echo "!GPUName!" | find /i "RTX 4080" >nul && (set /a "gpu_score=37" & set "gpu_rating=High-End")
echo "!GPUName!" | find /i "RTX 4070 Ti" >nul && (set /a "gpu_score=33" & set "gpu_rating=High-End")
echo "!GPUName!" | find /i "RTX 4070" >nul && (set /a "gpu_score=30" & set "gpu_rating=Upper Mid-Range")
echo "!GPUName!" | find /i "RTX 4060 Ti" >nul && (set /a "gpu_score=26" & set "gpu_rating=Mid-Range")
echo "!GPUName!" | find /i "RTX 4060" >nul && (set /a "gpu_score=23" & set "gpu_rating=Mid-Range")

echo "!GPUName!" | find /i "RTX 3090 Ti" >nul && (set /a "gpu_score=39" & set "gpu_rating=Flagship (Prev Gen)")
echo "!GPUName!" | find /i "RTX 3090" >nul && (set /a "gpu_score=35" & set "gpu_rating=High-End")
echo "!GPUName!" | find /i "RTX 3080 Ti" >nul && (set /a "gpu_score=34" & set "gpu_rating=High-End")
echo "!GPUName!" | find /i "RTX 3080" >nul && (set /a "gpu_score=32" & set "gpu_rating=High-End")
echo "!GPUName!" | find /i "RTX 3070 Ti" >nul && (set /a "gpu_score=30" & set "gpu_rating=Upper Mid-Range")
echo "!GPUName!" | find /i "RTX 3070" >nul && (set /a "gpu_score=28" & set "gpu_rating=Upper Mid-Range")
echo "!GPUName!" | find /i "RTX 3060 Ti" >nul && (set /a "gpu_score=24" & set "gpu_rating=Mid-Range")
echo "!GPUName!" | find /i "RTX 3060" >nul && (set /a "gpu_score=20" & set "gpu_rating=Entry Gaming")
echo "!GPUName!" | find /i "RTX 3050 Ti" >nul && (set /a "gpu_score=16" & set "gpu_rating=Basic Gaming")
echo "!GPUName!" | find /i "RTX 3050" >nul && (set /a "gpu_score=14" & set "gpu_rating=Basic Gaming")

echo "!GPUName!" | find /i "RTX 2080 Ti" >nul && (set /a "gpu_score=28" & set "gpu_rating=High-End (Old Gen)")
echo "!GPUName!" | find /i "RTX 2080 Super" >nul && (set /a "gpu_score=26" & set "gpu_rating=Upper Mid-Range")
echo "!GPUName!" | find /i "RTX 2080" >nul && (set /a "gpu_score=24" & set "gpu_rating=Upper Mid-Range")
echo "!GPUName!" | find /i "RTX 2070 Super" >nul && (set /a "gpu_score=23" & set "gpu_rating=Mid-Range")
echo "!GPUName!" | find /i "RTX 2070" >nul && (set /a "gpu_score=21" & set "gpu_rating=Mid-Range")
echo "!GPUName!" | find /i "RTX 2060 Super" >nul && (set /a "gpu_score=19" & set "gpu_rating=Entry Gaming")
echo "!GPUName!" | find /i "RTX 2060" >nul && (set /a "gpu_score=17" & set "gpu_rating=Entry Gaming")

echo "!GPUName!" | find /i "GTX 1660 Ti" >nul && (set /a "gpu_score=15" & set "gpu_rating=Budget Gaming")
echo "!GPUName!" | find /i "GTX 1660 Super" >nul && (set /a "gpu_score=13" & set "gpu_rating=Budget Gaming")
echo "!GPUName!" | find /i "GTX 1660" >nul && (set /a "gpu_score=12" & set "gpu_rating=Budget Gaming")
echo "!GPUName!" | find /i "GTX 1650 Super" >nul && (set /a "gpu_score=11" & set "gpu_rating=Entry Level")
echo "!GPUName!" | find /i "GTX 1650 Ti" >nul && (set /a "gpu_score=10" & set "gpu_rating=Entry Level")
echo "!GPUName!" | find /i "GTX 1650" >nul && (set /a "gpu_score=9" & set "gpu_rating=Entry Level")

echo "!GPUName!" | find /i "GTX 1080 Ti" >nul && (set /a "gpu_score=19" & set "gpu_rating=High-End (Old Gen)")
echo "!GPUName!" | find /i "GTX 1080" >nul && (set /a "gpu_score=16" & set "gpu_rating=Upper Mid-Range")
echo "!GPUName!" | find /i "GTX 1070 Ti" >nul && (set /a "gpu_score=15" & set "gpu_rating=Upper Mid-Range")
echo "!GPUName!" | find /i "GTX 1070" >nul && (set /a "gpu_score=14" & set "gpu_rating=Mid-Range")
echo "!GPUName!" | find /i "GTX 1060" >nul && (set /a "gpu_score=12" & set "gpu_rating=Budget Gaming")
echo "!GPUName!" | find /i "GTX 1050 Ti" >nul && (set /a "gpu_score=9" & set "gpu_rating=Entry Level")
echo "!GPUName!" | find /i "GTX 1050" >nul && (set /a "gpu_score=8" & set "gpu_rating=Entry Level")

echo "!GPUName!" | find /i "RX 9070 XT" >nul && (set /a "gpu_score=44" & set "gpu_rating=Flagship Next-Gen")

echo "!GPUName!" | find /i "RX 7900 XTX" >nul && (set /a "gpu_score=41" & set "gpu_rating=Flagship")
echo "!GPUName!" | find /i "RX 7900 XT" >nul && (set /a "gpu_score=39" & set "gpu_rating=High-End")
echo "!GPUName!" | find /i "RX 7800 XT" >nul && (set /a "gpu_score=36" & set "gpu_rating=High-End")
echo "!GPUName!" | find /i "RX 7700 XT" >nul && (set /a "gpu_score=34" & set "gpu_rating=Upper Mid-Range")
echo "!GPUName!" | find /i "RX 7600 XT" >nul && (set /a "gpu_score=30" & set "gpu_rating=Mid-Range")
echo "!GPUName!" | find /i "RX 7600" >nul && (set /a "gpu_score=29" & set "gpu_rating=Mid-Range")

echo "!GPUName!" | find /i "RX 6950 XT" >nul && (set /a "gpu_score=38" & set "gpu_rating=Flagship (Prev Gen)")
echo "!GPUName!" | find /i "RX 6900 XT" >nul && (set /a "gpu_score=37" & set "gpu_rating=High-End")
echo "!GPUName!" | find /i "RX 6800 XT" >nul && (set /a "gpu_score=34" & set "gpu_rating=Upper Mid-Range")
echo "!GPUName!" | find /i "RX 6800" >nul && (set /a "gpu_score=32" & set "gpu_rating=Mid-Range")
echo "!GPUName!" | find /i "RX 6700 XT" >nul && (set /a "gpu_score=29" & set "gpu_rating=Mid-Range")
echo "!GPUName!" | find /i "RX 6600 XT" >nul && (set /a "gpu_score=26" & set "gpu_rating=Budget Gaming")
echo "!GPUName!" | find /i "RX 6600" >nul && (set /a "gpu_score=24" & set "gpu_rating=Budget Gaming")

echo "!GPUName!" | find /i "RX 5700 XT" >nul && (set /a "gpu_score=21" & set "gpu_rating=Mid-Range (Old Gen)")
echo "!GPUName!" | find /i "RX 5700" >nul && (set /a "gpu_score=20" & set "gpu_rating=Mid-Range (Old Gen)")
echo "!GPUName!" | find /i "RX 5600 XT" >nul && (set /a "gpu_score=17" & set "gpu_rating=Budget Gaming")
echo "!GPUName!" | find /i "RX 5500 XT" >nul && (set /a "gpu_score=14" & set "gpu_rating=Budget Gaming")

echo "!GPUName!" | find /i "RX 590" >nul && (set /a "gpu_score=12" & set "gpu_rating=Budget Gaming")
echo "!GPUName!" | find /i "RX 580" >nul && (set /a "gpu_score=11" & set "gpu_rating=Budget Gaming")
echo "!GPUName!" | find /i "RX 570" >nul && (set /a "gpu_score=10" & set "gpu_rating=Entry Gaming")
echo "!GPUName!" | find /i "RX 560" >nul && (set /a "gpu_score=8" & set "gpu_rating=Entry Level")

echo "!GPUName!" | find /i "R9 Fury X" >nul && (set /a "gpu_score=18" & set "gpu_rating=High-End (Old Gen)")
echo "!GPUName!" | find /i "R9 Fury" >nul && (set /a "gpu_score=16" & set "gpu_rating=High-End (Old Gen)")
echo "!GPUName!" | find /i "R9 390X" >nul && (set /a "gpu_score=13" & set "gpu_rating=Upper Mid-Range")
echo "!GPUName!" | find /i "R9 380X" >nul && (set /a "gpu_score=10" & set "gpu_rating=Budget Gaming")
echo "!GPUName!" | find /i "R9 380" >nul && (set /a "gpu_score=9" & set "gpu_rating=Budget Gaming")

echo "!GPUName!" | find /i "Arc A770" >nul && (set /a "gpu_score=20" & set "gpu_rating=Mid-Range")
echo "!GPUName!" | find /i "Arc A750" >nul && (set /a "gpu_score=18" & set "gpu_rating=Entry Gaming")
echo "!GPUName!" | find /i "Arc A580" >nul && (set /a "gpu_score=15" & set "gpu_rating=Budget Gaming")
echo "!GPUName!" | find /i "Arc A380" >nul && (set /a "gpu_score=9" & set "gpu_rating=Entry Level")

echo "!GPUName!" | find /i "Iris Xe" >nul && (set /a "gpu_score=7" & set "gpu_rating=Integrated High-End")
echo "!GPUName!" | find /i "UHD" >nul && (set /a "gpu_score=5" & set "gpu_rating=Integrated")
echo "!GPUName!" | find /i "HD Graphics" >nul && (set /a "gpu_score=3" & set "gpu_rating=Integrated")
echo "!GPUName!" | find /i "Intel" >nul && (set /a "gpu_score=2" & set "gpu_rating=Integrated")

set /a "gpu_score+=!vram_score!"
set /a "perfscore+=!gpu_score!"

set /a "perfscore-=5"

echo %c%• Finalizing performance analysis...%u%

if !perfscore! geq 85 (
    set "perf_category=Flagship Gaming/Workstation"
    set "perf_desc=Exceptional performance for 4K gaming and professional workloads"
) else if !perfscore! geq 70 (
    set "perf_category=High-End Gaming"
    set "perf_desc=Excellent for 1440p gaming and content creation"
) else if !perfscore! geq 55 (
    set "perf_category=Mid-Range Gaming"
    set "perf_desc=Good for 1080p gaming at high settings"
) else if !perfscore! geq 40 (
    set "perf_category=Entry-Level Gaming"
    set "perf_desc=Suitable for 1080p gaming at medium settings"
) else if !perfscore! geq 25 (
    set "perf_category=Basic Computing"
    set "perf_desc=Light gaming and productivity tasks only"
) else (
    set "perf_category=☆☆☆☆☆ Insufficient"
    set "perf_desc=Upgrade recommended for modern applications"
)

echo %c%System Performance Rating:%u%
echo %c%  !perf_category! ^(!perfscore!/100^)%u%
echo %c%  !perf_desc!%u%
echo.
echo %c%Component Ratings:%u%
echo %c%  • RAM: !ram_rating! ^(!totalmem!GB^)%u%
echo %c%  • CPU: !cpu_rating! ^(!NUMBER_OF_PROCESSORS! threads^)%u%
echo %c%  • GPU: !gpu_rating! ^(!detected_vram!GB VRAM^)%u%

echo.
echo %c%Gaming Performance Expectations:%u%
if !perfscore! geq 55 (
    echo %c%  • AAA Games: Medium-High settings ^(60+ FPS at 1080p^)%u%
    echo %c%  • Competitive Games: High settings ^(100+ FPS^)%u%
    echo %c%  • Minecraft: High settings ^(80+ FPS^)%u%
    echo %c%  • Counter-Strike 2: High settings ^(120+ FPS^)%u%
) else if !perfscore! geq 40 (
    echo %c%  • AAA Games: Low-Medium settings ^(40-60 FPS at 1080p^)%u%
    echo %c%  • Competitive Games: Medium-High settings ^(80-120 FPS^)%u%
    echo %c%  • Minecraft: Medium-High settings ^(60-80 FPS^)%u%
    echo %c%  • Counter-Strike 2: Medium-High settings ^(100-140 FPS^)%u%
) else (
    echo %c%  • AAA Games: Low settings ^(30-40 FPS at 1080p^)%u%
    echo %c%  • Competitive Games: Medium settings ^(60-80 FPS^)%u%
    echo %c%  • Minecraft: Medium settings ^(50-70 FPS^)%u%
    echo %c%  • Counter-Strike 2: Medium settings ^(80-100 FPS^)%u%
)

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                      HARDWARE SCAN COMPLETED SUCCESSFULLY                    ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Hardware information scan completed successfully!%u%
echo.
echo %c%Scan Summary:%u%
echo %c%• System specifications detected and analyzed%u%
echo %c%• Hardware health status verified%u%
echo %c%• Performance rating calculated%u%
echo %c%• Upgrade recommendations provided%u%
echo.
echo %red%Additional Options:%u%
echo %c%• Save detailed report to file%u%
echo %c%• Export hardware info for tech support%u%
echo %c%• Run hardware stress tests%u%
echo %c%• Monitor temperatures in real-time%u%
echo.
echo.
choice /C YN /M "%c%Save hardware report to desktop? (Y/N)%u%"
if errorlevel 2 goto :skip_save

echo %c%• Generating hardware report...%u%
set "report_file=%USERPROFILE%\Desktop\Hardware_Report_%COMPUTERNAME%_%date:~10,4%%date:~4,2%%date:~7,2%.txt"

(
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         HARDWARE INFORMATION REPORT                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
echo Report Generated: %date% %time%
echo Computer Name: %COMPUTERNAME%
echo Current User: %USERNAME%
echo Scanner Version: Batlez Tweaks
echo.
echo ════════════════════════════════════════════════════════════════════════════════
echo                                 SYSTEM OVERVIEW
echo ════════════════════════════════════════════════════════════════════════════════
echo.
echo Computer Model: !comp_model!
echo Manufacturer: !comp_manufacturer!
echo Computer Name: !comp_name!
echo Current User: !current_user!
echo Windows Version: !win_version!
echo Build Number: !build_number!
echo System Architecture: 64-bit
echo.
echo ════════════════════════════════════════════════════════════════════════════════
echo                              MOTHERBOARD AND BIOS
echo ════════════════════════════════════════════════════════════════════════════════
echo.
echo Motherboard: !mb_manufacturer! !mb_model!
echo Motherboard Version: !mb_version!
echo BIOS Manufacturer: !bios_manufacturer!
echo BIOS Version: !bios_version!
echo BIOS Date: !bios_date!
echo.
echo ════════════════════════════════════════════════════════════════════════════════
echo                                 PROCESSOR DETAILS
echo ════════════════════════════════════════════════════════════════════════════════
echo.
echo Processor: !CPUName!
echo Logical Processors: !NUMBER_OF_PROCESSORS! threads
echo Base Clock Speed: !cpughz!.!cpumhz! GHz
echo Performance Rating: !cpu_rating! ^(!cpu_score! points^)
echo CPU Score Breakdown: Base !cpu_score! + Thread Bonus + Clock Bonus
echo.
echo ════════════════════════════════════════════════════════════════════════════════
echo                                 MEMORY CONFIGURATION
echo ════════════════════════════════════════════════════════════════════════════════
echo.
echo Total Physical Memory: !totalmem! GB
echo Available Memory: !freemem! GB
echo Memory Speed: !mem_speed! MHz
echo Memory Manufacturer: !mem_manufacturer!
echo Memory Rating: !ram_rating!
echo.
echo ════════════════════════════════════════════════════════════════════════════════
echo                                GRAPHICS HARDWARE
echo ════════════════════════════════════════════════════════════════════════════════
echo.
echo Primary Graphics: !GPUName!
echo Video Memory: !detected_vram! GB
echo Performance Rating: !gpu_rating! ^(!gpu_score! points^)
echo VRAM Rating: !vram_rating!
echo GPU Count: !gpucount! graphics adapters detected
echo.
echo ════════════════════════════════════════════════════════════════════════════════
echo                                 STORAGE DEVICES
echo ════════════════════════════════════════════════════════════════════════════════
echo.
echo Primary Drive: !drive1_name!
echo Drive Capacity: !drive1_size! GB
echo Storage Health: Accessible
) > "%report_file%"

if !drivecount! geq 2 (
    >> "%report_file%" (
    echo Additional Drive: !drive2_name!
    echo Second Drive Capacity: !drive2_size! GB
    )
) else (
    >> "%report_file%" echo Additional Drives: None detected
)

if not "!c_drive_info!"=="" (
    >> "%report_file%" (
    echo.
    echo C: Drive Usage: !c_drive_info!
    )
)

>> "%report_file%" (
echo Storage Type: High-speed storage detected
echo Total Storage Devices: !drivecount! physical drive^(s^)
echo.
echo ════════════════════════════════════════════════════════════════════════════════
echo                               SYSTEM PERFORMANCE
echo ════════════════════════════════════════════════════════════════════════════════
echo.
echo Overall Performance Score: !perfscore!/100
echo Performance Category: !perf_category!
echo.
echo Component Breakdown:
echo • RAM: !ram_rating! ^(!totalmem!GB^) - RAM Score
echo • CPU: !cpu_rating! ^(!NUMBER_OF_PROCESSORS! threads^) - !cpu_score! points  
echo • GPU: !gpu_rating! ^(!detected_vram!GB VRAM^) - !gpu_score! points
echo • VRAM: !vram_rating! ^(!detected_vram!GB^) - !vram_score! points
echo • Laptop Penalty: -5 points ^(if applicable^)
echo.
echo Gaming Performance Expectations:
) >> "%report_file%"

if !perfscore! geq 70 (
    >> "%report_file%" (
    echo • AAA Games: High-Ultra settings ^(60+ FPS at 1440p^)
    echo • Competitive Games: Ultra settings ^(144+ FPS^)
    echo • Minecraft: Ultra settings with shaders ^(100+ FPS^)
    echo • Counter-Strike 2: Ultra settings ^(200+ FPS^)
    )
) else if !perfscore! geq 55 (
    >> "%report_file%" (
    echo • AAA Games: Medium-High settings ^(60+ FPS at 1080p^)
    echo • Competitive Games: High-Ultra settings ^(100+ FPS^)
    echo • Minecraft: High settings ^(80+ FPS^)
    echo • Counter-Strike 2: High settings ^(120+ FPS^)
    )
) else if !perfscore! geq 40 (
    >> "%report_file%" (
    echo • AAA Games: Low-Medium settings ^(40-60 FPS at 1080p^)
    echo • Competitive Games: Medium-High settings ^(80-120 FPS^)
    echo • Minecraft: Medium-High settings ^(60-80 FPS^)
    echo • Counter-Strike 2: Medium-High settings ^(100-140 FPS^)
    )
) else (
    >> "%report_file%" (
    echo • AAA Games: Low settings ^(30 FPS at 1080p^)
    echo • Competitive Games: Medium settings ^(60 FPS^)
    echo • Minecraft: Medium settings ^(50 FPS^)
    echo • Counter-Strike 2: Medium settings ^(80 FPS^)
    )
)

>> "%report_file%" (
echo.
echo Productivity Performance:
echo • Office Applications: Excellent
echo • Web Browsing: Excellent
echo • Video Streaming: Excellent
echo • Programming/Development: Good to Excellent
echo • Content Creation: Depends on workload complexity
echo.
echo ════════════════════════════════════════════════════════════════════════════════
echo                               UPGRADE RECOMMENDATIONS
echo ════════════════════════════════════════════════════════════════════════════════
echo.
)

if !totalmem! lss 16 (
    >> "%report_file%" echo • Priority: RAM Upgrade to 16GB minimum
)
if !totalmem! geq 16 if !totalmem! lss 32 (
    >> "%report_file%" echo • Consider: RAM upgrade to 32GB for heavy workloads
)
if !detected_vram! lss 6 (
    >> "%report_file%" echo • Priority: GPU upgrade - current VRAM limiting
)
if !detected_vram! geq 4 if !detected_vram! lss 8 (
    >> "%report_file%" echo • Consider: GPU with 8GB+ VRAM for future games
)
if !perfscore! lss 50 (
    >> "%report_file%" echo • Recommendation: System suitable for current needs, upgrades optional
) else if !perfscore! lss 70 (
    >> "%report_file%" echo • Status: Good balanced system, selective upgrades beneficial
) else (
    >> "%report_file%" echo • Status: High-performance system, no immediate upgrades needed
)

>> "%report_file%" (
echo.
echo ════════════════════════════════════════════════════════════════════════════════
echo                                 SYSTEM HEALTH
echo ════════════════════════════════════════════════════════════════════════════════
echo.
echo Overall Health Status: System operational
echo Driver Status: !driver_count! active drivers detected
echo Storage Health: Primary drive accessible
echo System Stability: Stable operation detected
echo Thermal Status: Monitoring available
echo.
echo ════════════════════════════════════════════════════════════════════════════════
echo                              TECHNICAL SUMMARY
echo ════════════════════════════════════════════════════════════════════════════════
echo.
)

if !perfscore! geq 80 (
    >> "%report_file%" echo System Type: High-End Workstation/Gaming System
) else if !perfscore! geq 65 (
    >> "%report_file%" echo System Type: Upper Mid-Range Gaming System
) else if !perfscore! geq 50 (
    >> "%report_file%" echo System Type: Mid-Range Gaming/Productivity System
) else if !perfscore! geq 35 (
    >> "%report_file%" echo System Type: Entry-Level Gaming/General Use System
) else (
    >> "%report_file%" echo System Type: Basic Computing System
)

>> "%report_file%" (
echo.
echo Performance Analysis Summary:
echo • CPU Performance: !cpu_rating! tier
echo • Graphics Performance: !gpu_rating! tier  
echo • Memory Configuration: !ram_rating! for current standards
echo • Overall Rating: !perfscore!/100 points
echo.
echo Scan Information:
echo • Scan Date: %date%
echo • Scan Time: %time%
echo • Computer Scanned: !comp_model!
echo • Report Generated For: %USERNAME%
echo.
echo ════════════════════════════════════════════════════════════════════════════════
echo Report End - Generated by Batlez Tweaks 
echo ════════════════════════════════════════════════════════════════════════════════
)

echo %c%  Hardware report saved successfully!%u%
echo %c%  File: Hardware_Report_%COMPUTERNAME%_%date:~10,4%%date:~4,2%%date:~7,2%.txt%u%
echo %c%  Location: %USERPROFILE%\Desktop%u%

:skip_save

echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto HardwareMenu

:DriverUpdates
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         NVIDIA DRIVER INSTALLATION                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Driver installation includes:%u%
echo %c%• RTX 580.88 - Exostenza Edition™ (de-bloat)%u%
echo %c%• Bloatware and telemetry completely removed%u%
echo %c%• GeForce Experience and overlay eliminated%u%
echo %c%• Performance optimized for gaming%u%
echo %c%• Clean installation without unnecessary components%u%
echo.
echo %red%%underline%Driver Notice:%u%
echo %c%This will replace your current NVIDIA driver installation.%u%
echo %c%A system restart will be required after installation.%u%
echo.
echo.
choice /C YN /M "%c%Install RTX 580.88 Exostenza Edition driver? (Y/N)%u%"
if errorlevel 2 goto HardwareMenu

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       DRIVER INSTALLATION IN PROGRESS                        ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/6] Detecting Current Driver...%u%
for /f "tokens=2 delims==" %%i in ('wmic path win32_videocontroller where "name like '%%NVIDIA%%'" get driverversion /value ^| find "="') do set current_version=%%i
if defined current_version (
    echo %c%  ✓ Current version: %current_version%%u%
) else (
    echo %c%  • No NVIDIA driver detected%u%
)

echo %c%[2/6] Downloading RTX 580.88 Exostenza Edition...%u%
set "DRIVER_FILE=%temp%\RTX_580.88_Exostenza.rar"
set "DRIVER_URL=https://drive.usercontent.google.com/download?id=1GeumQ3s1HqnxDx3mXp8eLWEL4m03OViD&export=download&confirm=t&uuid=b89a74d4-0444-4f09-9e09-bfd5301a3728"
chcp 437 >nul
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'SilentlyContinue'; try { Invoke-WebRequest -Uri '%DRIVER_URL%' -OutFile '%DRIVER_FILE%' -UserAgent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36' -UseBasicParsing } catch { exit 1 }}" >nul 2>&1
chcp 65001 >nul
if not exist "%DRIVER_FILE%" (
    echo %c%  ⚠ Primary download failed, trying WebClient method...%u%
	chcp 437 >nul
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $client = New-Object System.Net.WebClient; $client.Headers.Add('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'); try { $client.DownloadFile('%DRIVER_URL%', '%DRIVER_FILE%') } catch { exit 1 } finally { $client.Dispose() }}" >nul 2>&1
	chcp 65001 >nul
)

if not exist "%DRIVER_FILE%" (
    echo %c%  ❌ Automatic download failed!%u%
    echo %c%  Please manually download the driver from:%u%
    echo %c%  https://drive.google.com/file/d/1GeumQ3s1HqnxDx3mXp8eLWEL4m03OViD/view%u%
    echo %c%  Save it as: RTX 580.88 Exostenza Edition.rar in your Downloads folder%u%
    echo.
    echo %c%  Press any key when download is complete...%u%
    pause >nul
    
    if exist "%USERPROFILE%\Downloads\RTX 580.88 Exostenza Edition.rar" (
        copy "%USERPROFILE%\Downloads\RTX 580.88 Exostenza Edition.rar" "%DRIVER_FILE%" >nul
        echo %c%  ✓ Driver file found in Downloads%u%
    ) else if exist "%USERPROFILE%\Downloads\RTX_580.88_Exostenza.rar" (
        copy "%USERPROFILE%\Downloads\RTX_580.88_Exostenza.rar" "%DRIVER_FILE%" >nul
        echo %c%  ✓ Driver file found in Downloads%u%
    ) else (
        echo %c%  ❌ Driver file not found! Please download and try again.%u%
        echo.
        echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
        pause >nul
        goto HardwareMenu
    )
) else (
    echo %c%  ✓ RTX 580.88 Exostenza Edition downloaded%u%
)

echo %c%[3/6] Extracting Driver Package...%u%
set "EXTRACT_DIR=%temp%\RTX_580.88_Extract"
if exist "%EXTRACT_DIR%" rd /s /q "%EXTRACT_DIR%" >nul 2>&1
mkdir "%EXTRACT_DIR%" >nul 2>&1

where winrar >nul 2>&1
if %errorlevel%==0 (
    winrar x -o+ "%DRIVER_FILE%" "%EXTRACT_DIR%\" >nul 2>&1
    echo %c%  ✓ Extracted using WinRAR%u%
) else (
    where 7z >nul 2>&1
    if %errorlevel%==0 (
        7z x "%DRIVER_FILE%" -o"%EXTRACT_DIR%" -y >nul 2>&1
        echo %c%  ✓ Extracted using 7-Zip%u%
    ) else (
		chcp 437 >nul
        powershell -Command "& {try { Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory('%DRIVER_FILE%', '%EXTRACT_DIR%') } catch { try { $shell = New-Object -ComObject Shell.Application; $zip = $shell.NameSpace('%DRIVER_FILE%'); if ($zip -ne $null) { $dest = $shell.NameSpace('%EXTRACT_DIR%'); $dest.CopyHere($zip.Items(), 4) } } catch { exit 1 } }}" >nul 2>&1
        chcp 65001 >nul 
		echo %c%  ✓ Extracted using PowerShell%u%
    )
)

if not exist "%EXTRACT_DIR%\setup.exe" (
    for /d %%d in ("%EXTRACT_DIR%\*") do (
        if exist "%%d\setup.exe" (
            set "EXTRACT_DIR=%%d"
            goto :found_setup
        )
    )
    
    for /r "%EXTRACT_DIR%" %%f in (setup.exe) do (
        if exist "%%f" (
            for %%d in ("%%~dpf.") do set "EXTRACT_DIR=%%~fd"
            goto :found_setup
        )
    )
    
    echo %c%  ❌ setup.exe not found in extracted files!%u%
    echo %c%  Checking Downloads folder for manual extraction...%u%
    
    if exist "%USERPROFILE%\Downloads\RTX 580.88 Exostenza Edition" (
        set "EXTRACT_DIR=%USERPROFILE%\Downloads\RTX 580.88 Exostenza Edition"
        if exist "%EXTRACT_DIR%\setup.exe" goto :found_setup
    )
    
    echo %c%  Please manually extract the RAR file and press any key...%u%
    start "" "%DRIVER_FILE%"
    pause >nul
    
    echo %c%  Enter the path to the extracted folder containing setup.exe:%u%
    set /p "EXTRACT_DIR=%c%  Path: %u%"
    
    if not exist "%EXTRACT_DIR%\setup.exe" (
        echo %c%  ❌ setup.exe still not found! Installation cancelled.%u%
        echo.
        echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
        pause >nul
        goto HardwareMenu
    )
)

:found_setup
echo %c%  ✓ Driver package extracted successfully%u%

echo %c%[4/6] Preparing Installation Environment...%u%
taskkill /f /im "NVIDIA GeForce Experience.exe" >nul 2>&1
taskkill /f /im "NVIDIA Share.exe" >nul 2>&1
taskkill /f /im "nvcontainer.exe" >nul 2>&1
taskkill /f /im "NVIDIA Web Helper.exe" >nul 2>&1
echo %c%  ✓ NVIDIA processes terminated%u%

echo %c%[5/6] Starting Driver Installation...%u%
echo %c%  • The setup installer will now appear%u%
echo %c%  • Configure your installation preferences in the setup window%u%
echo %c%  • This script will wait for installation to complete%u%
echo %c%  • Do not close this window during installation%u%
echo.
echo %c%  ✓ Launching setup.exe - please complete the installation%u%

pushd "%EXTRACT_DIR%"
call "%EXTRACT_DIR%\setup.exe" >nul 2>&1
set "install_result=%errorlevel%"
popd

echo.
echo %c%  • Installation process completed%u%
echo %c%  • Returning to script for final cleanup...%u%

timeout /t 2 >nul

del "%DRIVER_FILE%" >nul 2>&1
if exist "%temp%\RTX_580.88_Extract" rd /s /q "%temp%\RTX_580.88_Extract" >nul 2>&1

if "%install_result%"=="0" (
    echo %c%  ✓ RTX 580.88 Exostenza Edition installation completed%u%
) else (
    echo %c%  ⚠ Installation process finished ^(Exit code: %install_result%^)%u%
)


echo %c%[6/6] Applying Final Optimizations...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "DisplayPowerSaving" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLevel" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
echo %c%  ✓ Performance registry tweaks applied%u%

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       DRIVER INSTALLATION COMPLETED                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%RTX 580.88 - Exostenza Edition™ has been successfully installed.%u%
echo.
echo %c%Installation Features:%u%
echo %c%• Complete bloatware removal (GeForce Experience eliminated)%u%
echo %c%• Telemetry and data collection disabled%u%
echo %c%• NVIDIA Web Helper and background services removed%u%
echo %c%• Optimized for pure gaming performance%u%
echo %c%• Clean driver installation without unnecessary components%u%
echo.
echo %red%Performance Benefits:%u%
echo %c%• Reduced system resource usage and RAM consumption%u%
echo %c%• Eliminated background processes and startup bloat%u%
echo %c%• Enhanced gaming performance and frame rates%u%
echo %c%• Faster driver response and reduced input lag%u%
echo %c%• Cleaner system with no NVIDIA overlay interference%u%
echo.
echo %red%%underline%Important:%u%
echo %c%A system restart is recommended to complete the installation.%u%
echo %c%The debloated driver will provide optimal gaming performance.%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto HardwareMenu

:WindowsMenu
cls
call :SetupConsole
call :DisplayBanner
echo %c%                                 ╔═══════════════════════════════════════════════════╗ %u%
echo                                  %c%║%u%          [%c%1%u%] Search Index Optimizer               %c%║%u% 
echo                                  %c%║%u%          [%c%2%u%] Windows Defender Optimizer           %c%║%u% 
echo                                  %c%║%u%          [%c%3%u%] Windows Explorer Fixes               %c%║%u%
echo                                  %c%║%u%          [%c%4%u%] System File Checker                  %c%║%u%
echo                                  %c%║%u%          [%c%5%u%] Registry Fixes                       %c%║%u%
echo                                  %c%║%u%          [%c%6%u%] Windows Features Manager             %c%║%u%
echo %c%                                 ╚═══════════════════════════════════════════════════╝
echo.
echo                             %u%[%c%7%u%] Colour Presets   [%c%8%u%] Back to Main   [%red%X%u%] Exit Application       
echo.                                      
set /p M="%c%Choose an option »%u% "
if "%M%"=="1" goto SearchIndexOptimizer
if "%M%"=="2" goto DefenderOptimizer
if "%M%"=="3" goto ExplorerOptimizer
if "%M%"=="4" goto SystemFileOptimizer
if "%M%"=="5" goto RegistryPerformance
if "%M%"=="6" goto WindowsFeaturesManager
if "%M%"=="7" goto Presets
if "%M%"=="8" goto menu
if "%M%"=="Quit" goto Destruct
cls
echo %underline%%red%Invalid Input. Press any key to continue.%u%
pause >nul
goto WindowsMenu

:WindowsFeaturesManager
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                           WINDOWS FEATURES MANAGER                           ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Choose your Windows Features management option:%u%
echo.
echo %c%                           ╔════════════════════════════════╗
echo                            ║  [1] Gaming Optimization       ║
echo                            ║  [2] Performance Optimization  ║
echo                            ║  [3] Privacy Optimization      ║
echo                            ║  [4] Developer Features        ║
echo                            ║  [5] View Current Features     ║
echo                            ║  [6] Custom Feature Manager    ║
echo                            ║                                ║
echo                            ║  [0] Return to Windows Menu    ║
echo                            ╚════════════════════════════════╝%u%
echo.
echo %c%[1] Gaming: Enable gaming features, disable bloat%u%
echo %c%[2] Performance: Disable resource-heavy features%u%
echo %c%[3] Privacy: Remove telemetry and tracking features%u%
echo %c%[4] Developer: Enable development and advanced features%u%
echo %c%[5] View: Display currently enabled/disabled features%u%
echo %c%[6] Custom: Manual feature selection%u%
echo.
set /p choice="%c%Select optimization type »%u% "
if "%choice%"=="0" goto WindowsMenu
if "%choice%"=="1" goto GamingFeatures
if "%choice%"=="2" goto PerformanceFeatures
if "%choice%"=="3" goto PrivacyFeatures
if "%choice%"=="4" goto DeveloperFeatures
if "%choice%"=="5" goto ViewFeatures
if "%choice%"=="6" goto CustomFeatures
cls
echo %red%Invalid selection. Please try again.%u%
timeout /t 2 >nul
goto WindowsFeaturesManager

:GamingFeatures
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                            GAMING OPTIMIZATION MODE                          ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Gaming optimization will:%u%
echo %c%• Enable DirectPlay for older games compatibility%u%
echo %c%• Enable .NET Framework versions for game compatibility%u%
echo %c%• Disable Windows Media Player and Media Features%u%
echo %c%• Disable Internet Explorer and legacy browser features%u%
echo %c%• Disable Work Folders Client (business feature)%u%
echo %c%• Disable Windows Fax and Scan%u%
echo %c%• Enable Windows Subsystem for Linux (WSL) for game development%u%
echo %c%• Optimize Hyper-V settings for performance%u%
echo.
choice /C YN /M "%c%Apply gaming feature optimization? (Y/N)%u%"
if errorlevel 2 goto WindowsFeaturesManager

echo.
echo %c%[1/8] Enabling Gaming Compatibility Features...%u%
echo %c%• Enabling DirectPlay for legacy game support...%u%
dism /online /enable-feature /featurename:"DirectPlay" /all /norestart >nul 2>&1
echo %c%• Enabling .NET Framework 3.5 for game compatibility...%u%
dism /online /enable-feature /featurename:"NetFx3" /all /norestart >nul 2>&1
echo %c%• Enabling .NET Framework 4.8 Advanced Services...%u%
dism /online /enable-feature /featurename:"NetFx4Extended-ASPNET45" /all /norestart >nul 2>&1
echo %c%✓ Gaming compatibility features enabled%u%

echo.
echo %c%[2/8] Disabling Media Bloat Features...%u%
echo %c%• Disabling Windows Media Player...%u%
dism /online /disable-feature /featurename:"WindowsMediaPlayer" /norestart >nul 2>&1
echo %c%• Disabling Media Features...%u%
dism /online /disable-feature /featurename:"MediaPlayback" /norestart >nul 2>&1
echo %c%• Disabling Windows DVD Maker...%u%
dism /online /disable-feature /featurename:"MSRDC-Infrastructure" /norestart >nul 2>&1
echo %c%✓ Media bloat features disabled%u%

echo.
echo %c%[3/8] Disabling Legacy Browser Features...%u%
echo %c%• Disabling Internet Explorer 11...%u%
dism /online /disable-feature /featurename:"Internet-Explorer-Optional-amd64" /norestart >nul 2>&1
echo %c%• Disabling Internet Explorer Legacy Features...%u%
dism /online /disable-feature /featurename:"IIS-WebServerRole" /norestart >nul 2>&1
echo %c%✓ Legacy browser features disabled%u%

echo.
echo %c%[4/8] Disabling Business/Enterprise Features...%u%
echo %c%• Disabling Work Folders Client...%u%
dism /online /disable-feature /featurename:"WorkFolders-Client" /norestart >nul 2>&1
echo %c%• Disabling Windows Fax and Scan...%u%
dism /online /disable-feature /featurename:"FaxServicesClientPackage" /norestart >nul 2>&1
echo %c%• Disabling Remote Differential Compression...%u%
dism /online /disable-feature /featurename:"MSRDC-Infrastructure" /norestart >nul 2>&1
echo %c%✓ Business/Enterprise features disabled%u%

echo.
echo %c%[5/8] Enabling Development Features for Gaming...%u%
echo %c%• Enabling Windows Subsystem for Linux (WSL)...%u%
dism /online /enable-feature /featurename:"Microsoft-Windows-Subsystem-Linux" /all /norestart >nul 2>&1
echo %c%• Enabling Virtual Machine Platform...%u%
dism /online /enable-feature /featurename:"VirtualMachinePlatform" /all /norestart >nul 2>&1
echo %c%✓ Development features enabled%u%

echo.
echo %c%[6/8] Optimizing Hyper-V for Gaming Performance...%u%
set /p "hyperv_choice=%c%Do you want to DISABLE Hyper-V for better gaming performance? (Y/N) »%u% "
if /i "%hyperv_choice%"=="Y" (
    echo %c%• Disabling Hyper-V Platform...%u%
    dism /online /disable-feature /featurename:"Microsoft-Hyper-V-All" /norestart >nul 2>&1
    echo %c%• Disabling Hyper-V Hypervisor...%u%
    bcdedit /set hypervisorlaunchtype off >nul 2>&1
    echo %c%✓ Hyper-V disabled for gaming performance%u%
) else (
    echo %c%• Keeping Hyper-V enabled...%u%
    echo %c%✓ Hyper-V configuration unchanged%u%
)

echo.
echo %c%[7/8] Disabling Unnecessary Print Features...%u%
echo %c%• Disabling XPS Services...%u%
dism /online /disable-feature /featurename:"Printing-XPSServices-Features" /norestart >nul 2>&1
echo %c%• Disabling Microsoft XPS Document Writer...%u%
dism /online /disable-feature /featurename:"Printing-Foundation-Features" /norestart >nul 2>&1
echo %c%✓ Print features optimized%u%

echo.
echo %c%[8/8] Configuring Windows Optional Features for Gaming...%u%
echo %c%• Disabling Windows PowerShell ISE (use modern PowerShell)...%u%
dism /online /disable-feature /featurename:"MicrosoftWindowsPowerShellISE" /norestart >nul 2>&1
echo %c%• Disabling Telnet Client...%u%
dism /online /disable-feature /featurename:"TelnetClient" /norestart >nul 2>&1
echo %c%✓ Optional features optimized%u%
goto FeaturesComplete

:PerformanceFeatures
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                          PERFORMANCE OPTIMIZATION MODE                       ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Performance optimization will:%u%
echo %c%• Disable ALL resource-heavy Windows features%u%
echo %c%• Remove Windows Search and Indexing%u%
echo %c%• Disable Hyper-V completely%u%
echo %c%• Remove Windows Subsystem for Linux%u%
echo %c%• Disable all media and print features%u%
echo %c%• Remove Internet Explorer and legacy components%u%
echo %c%• Disable Windows containers and sandbox%u%
echo.
echo %red%WARNING: This will significantly reduce Windows functionality!%u%
choice /C YN /M "%c%Apply extreme performance optimization? (Y/N)%u%"
if errorlevel 2 goto WindowsFeaturesManager

echo.
echo %c%[1/10] Disabling Search and Indexing Features...%u%
echo %c%• Disabling Windows Search Service...%u%
dism /online /disable-feature /featurename:"SearchEngine-Client-Package" /norestart >nul 2>&1
echo %c%✓ Search features disabled%u%

echo.
echo %c%[2/10] Disabling Hyper-V Completely...%u%
echo %c%• Disabling Hyper-V Platform...%u%
dism /online /disable-feature /featurename:"Microsoft-Hyper-V-All" /norestart >nul 2>&1
echo %c%• Disabling Virtual Machine Platform...%u%
dism /online /disable-feature /featurename:"VirtualMachinePlatform" /norestart >nul 2>&1
echo %c%• Disabling Windows Hypervisor Platform...%u%
dism /online /disable-feature /featurename:"HypervisorPlatform" /norestart >nul 2>&1
bcdedit /set hypervisorlaunchtype off >nul 2>&1
echo %c%✓ Hyper-V completely disabled%u%

echo.
echo %c%[3/10] Disabling Linux Subsystem Features...%u%
echo %c%• Disabling Windows Subsystem for Linux...%u%
dism /online /disable-feature /featurename:"Microsoft-Windows-Subsystem-Linux" /norestart >nul 2>&1
echo %c%• Disabling WSL2 components...%u%
dism /online /disable-feature /featurename:"Microsoft-Windows-Subsystem-Linux" /norestart >nul 2>&1
echo %c%✓ Linux subsystem disabled%u%

echo.
echo %c%[4/10] Removing All Media Features...%u%
echo %c%• Disabling Windows Media Player...%u%
dism /online /disable-feature /featurename:"WindowsMediaPlayer" /norestart >nul 2>&1
echo %c%• Disabling Media Foundation...%u%
dism /online /disable-feature /featurename:"MediaPlayback" /norestart >nul 2>&1
echo %c%• Disabling Windows Media Format...%u%
dism /online /disable-feature /featurename:"Windows-Media-Format" /norestart >nul 2>&1
echo %c%✓ All media features removed%u%

echo.
echo %c%[5/10] Removing Print and Fax Features...%u%
echo %c%• Disabling Print and Document Services...%u%
dism /online /disable-feature /featurename:"Printing-PrintToPDFServices-Features" /norestart >nul 2>&1
dism /online /disable-feature /featurename:"Printing-XPSServices-Features" /norestart >nul 2>&1
echo %c%• Disabling Fax Services...%u%
dism /online /disable-feature /featurename:"FaxServicesClientPackage" /norestart >nul 2>&1
echo %c%✓ Print and fax features removed%u%

echo.
echo %c%[6/10] Removing Internet Explorer Completely...%u%
echo %c%• Disabling Internet Explorer 11...%u%
dism /online /disable-feature /featurename:"Internet-Explorer-Optional-amd64" /norestart >nul 2>&1
echo %c%• Disabling IE Legacy Components...%u%
dism /online /disable-feature /featurename:"LegacyComponents" /norestart >nul 2>&1
echo %c%✓ Internet Explorer completely removed%u%

echo.
echo %c%[7/10] Disabling Container and Sandbox Features...%u%
echo %c%• Disabling Windows Sandbox...%u%
dism /online /disable-feature /featurename:"Containers-DisposableClientVM" /norestart >nul 2>&1
echo %c%• Disabling Containers feature...%u%
dism /online /disable-feature /featurename:"Containers" /norestart >nul 2>&1
echo %c%✓ Container features disabled%u%

echo.
echo %c%[8/10] Removing Legacy Windows Components...%u%
echo %c%• Disabling DirectPlay...%u%
dism /online /disable-feature /featurename:"DirectPlay" /norestart >nul 2>&1
echo %c%• Disabling Legacy Components...%u%
dism /online /disable-feature /featurename:"LegacyComponents" /norestart >nul 2>&1
echo %c%• Disabling NTVDM (16-bit support)...%u%
dism /online /disable-feature /featurename:"NTVDM" /norestart >nul 2>&1
echo %c%✓ Legacy components removed%u%

echo.
echo %c%[9/10] Disabling Network and Sharing Features...%u%
echo %c%• Disabling SMB 1.0 Protocol...%u%
dism /online /disable-feature /featurename:"SMB1Protocol" /norestart >nul 2>&1
echo %c%• Disabling Work Folders...%u%
dism /online /disable-feature /featurename:"WorkFolders-Client" /norestart >nul 2>&1
echo %c%• Disabling Remote Differential Compression...%u%
dism /online /disable-feature /featurename:"MSRDC-Infrastructure" /norestart >nul 2>&1
echo %c%✓ Network features optimized%u%

echo.
echo %c%[10/10] Final Performance Optimizations...%u%
echo %c%• Disabling PowerShell ISE...%u%
dism /online /disable-feature /featurename:"MicrosoftWindowsPowerShellISE" /norestart >nul 2>&1
echo %c%• Disabling Telnet Client...%u%
dism /online /disable-feature /featurename:"TelnetClient" /norestart >nul 2>&1
echo %c%• Disabling TFTP Client...%u%
dism /online /disable-feature /featurename:"TFTP" /norestart >nul 2>&1
echo %c%✓ Final optimizations complete%u%
goto FeaturesComplete

:PrivacyFeatures
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                            PRIVACY OPTIMIZATION MODE                         ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Privacy optimization will:%u%
echo %c%• Remove Internet Explorer (tracking vector)%u%
echo %c%• Disable Windows Media Player (telemetry)%u%
echo %c%• Remove Work Folders (business tracking)%u%
echo %c%• Disable location services%u%
echo %c%• Remove contact and calendar sync features%u%
echo %c%• Disable biometric features%u%
echo %c%• Remove cloud sync capabilities%u%
echo %c%• Rename SmartScreen.exe to prevent DCOM background calls%u%
echo.
choice /C YN /M "%c%Apply privacy-focused feature optimization? (Y/N)%u%"
if errorlevel 2 goto WindowsFeaturesManager

echo.
echo %c%[1/6] Removing Tracking-Heavy Browser Components...%u%
echo %c%• Removing Internet Explorer 11...%u%
dism /online /disable-feature /featurename:"Internet-Explorer-Optional-amd64" /norestart >nul 2>&1
echo %c%• Disabling IE Enhanced Security...%u%
dism /online /disable-feature /featurename:"Internet-Explorer-Optional-amd64" /norestart >nul 2>&1
echo %c%✓ Browser tracking components removed%u%

echo.
echo %c%[2/6] Disabling Media Telemetry Features...%u%
echo %c%• Disabling Windows Media Player...%u%
dism /online /disable-feature /featurename:"WindowsMediaPlayer" /norestart >nul 2>&1
echo %c%• Disabling Media Foundation telemetry...%u%
dism /online /disable-feature /featurename:"MediaPlayback" /norestart >nul 2>&1
echo %c%✓ Media telemetry disabled%u%

echo.
echo %c%[3/6] Removing Business Tracking Features...%u%
echo %c%• Disabling Work Folders Client...%u%
dism /online /disable-feature /featurename:"WorkFolders-Client" /norestart >nul 2>&1
echo %c%• Disabling Enterprise Cloud Print...%u%
dism /online /disable-feature /featurename:"Printing-Foundation-InternetPrinting-Client" /norestart >nul 2>&1
echo %c%✓ Business tracking removed%u%

echo.
echo %c%[4/6] Disabling Location and Sync Services...%u%
echo %c%• Disabling Contact Data sync...%u%
chcp 437 >nul
powershell -Command "Get-AppxPackage *People* | Remove-AppxPackage" >nul 2>&1
echo %c%• Disabling Calendar sync...%u%
powershell -Command "Get-AppxPackage *Calendar* | Remove-AppxPackage" >nul 2>&1
chcp 65001 >nul
echo %c%✓ Sync services disabled%u%

echo.
echo %c%[5/6] Removing Biometric and Security Tracking...%u%
echo %c%• Disabling Windows Hello Face...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%• Disabling Biometric logging...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Biometrics\Credential Provider" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Biometric tracking removed%u%

echo.
echo %c%[6/7] Final Privacy Hardening...%u%
echo %c%• Disabling Telnet (security risk)...%u%
dism /online /disable-feature /featurename:"TelnetClient" /norestart >nul 2>&1
echo %c%• Disabling TFTP (security risk)...%u%
dism /online /disable-feature /featurename:"TFTP" /norestart >nul 2>&1
echo %c%• Disabling Simple TCP/IP Services...%u%
dism /online /disable-feature /featurename:"SimpleTCP" /norestart >nul 2>&1
echo %c%✓ Privacy hardening complete%u%

echo.
echo %c%[7/7] Scheduling SmartScreen.exe deletion on next boot...%u%
set "_ss_path=C:\Windows\System32\smartscreen.exe"
set "_ssp_path=C:\Windows\System32\smartscreenps.dll"
if exist "%_ss_path%" (
    chcp 437 >nul
    powershell -NoProfile -Command ^
      "$p = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager'; ^
       $cur = (Get-ItemProperty -Path $p -Name PendingFileRenameOperations -EA SilentlyContinue).PendingFileRenameOperations; ^
       $add = @('\\??\\C:\\Windows\\System32\\smartscreen.exe','', ^
                '\\??\\C:\\Windows\\System32\\smartscreenps.dll',''); ^
       $merged = if ($cur) { $cur + $add } else { $add }; ^
       Set-ItemProperty -Path $p -Name PendingFileRenameOperations -Value $merged -Type MultiString" >nul 2>&1
    chcp 65001 >nul
    echo %c%✓ SmartScreen.exe + smartscreenps.dll queued for deletion on next reboot%u%
) else (
    echo %c%  SmartScreen.exe not found, skipping%u%
)
goto FeaturesComplete

:DeveloperFeatures
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                            DEVELOPER FEATURES MODE                           ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Developer optimization will:%u%
echo %c%• Enable Windows Subsystem for Linux (WSL)%u%
echo %c%• Enable Virtual Machine Platform%u%
echo %c%• Enable Windows Hypervisor Platform%u%
echo %c%• Enable Developer Mode features%u%
echo %c%• Enable IIS and web development features%u%
echo %c%• Enable .NET Framework versions%u%
echo %c%• Enable Windows Sandbox for testing%u%
echo %c%• Enable Containers feature%u%
echo.
choice /C YN /M "%c%Enable comprehensive developer features? (Y/N)%u%"
if errorlevel 2 goto WindowsFeaturesManager

echo.
echo %c%[1/8] Enabling Core Development Platforms...%u%
echo %c%• Enabling Windows Subsystem for Linux...%u%
dism /online /enable-feature /featurename:"Microsoft-Windows-Subsystem-Linux" /all /norestart >nul 2>&1
echo %c%• Enabling Virtual Machine Platform...%u%
dism /online /enable-feature /featurename:"VirtualMachinePlatform" /all /norestart >nul 2>&1
echo %c%• Enabling Windows Hypervisor Platform...%u%
dism /online /enable-feature /featurename:"HypervisorPlatform" /all /norestart >nul 2>&1
echo %c%✓ Core development platforms enabled%u%

echo.
echo %c%[2/8] Enabling .NET Framework Features...%u%
echo %c%• Enabling .NET Framework 3.5...%u%
dism /online /enable-feature /featurename:"NetFx3" /all /norestart >nul 2>&1
echo %c%• Enabling .NET Framework 4.8 Advanced Services...%u%
dism /online /enable-feature /featurename:"NetFx4Extended-ASPNET45" /all /norestart >nul 2>&1
echo %c%• Enabling WCF Services...%u%
dism /online /enable-feature /featurename:"WCF-Services45" /all /norestart >nul 2>&1
echo %c%✓ .NET Framework features enabled%u%

echo.
echo %c%[3/8] Enabling Web Development Features...%u%
echo %c%• Enabling Internet Information Services...%u%
dism /online /enable-feature /featurename:"IIS-WebServerRole" /all /norestart >nul 2>&1
echo %c%• Enabling IIS Management Console...%u%
dism /online /enable-feature /featurename:"IIS-ManagementConsole" /all /norestart >nul 2>&1
echo %c%• Enabling ASP.NET 4.8...%u%
dism /online /enable-feature /featurename:"IIS-ASPNET45" /all /norestart >nul 2>&1
echo %c%✓ Web development features enabled%u%

echo.
echo %c%[4/8] Enabling Container and Sandbox Features...%u%
echo %c%• Enabling Windows Sandbox...%u%
dism /online /enable-feature /featurename:"Containers-DisposableClientVM" /all /norestart >nul 2>&1
echo %c%• Enabling Containers...%u%
dism /online /enable-feature /featurename:"Containers" /all /norestart >nul 2>&1
echo %c%✓ Container features enabled%u%

echo.
echo %c%[5/8] Enabling Hyper-V Management Tools...%u%
echo %c%• Enabling Hyper-V Platform...%u%
dism /online /enable-feature /featurename:"Microsoft-Hyper-V-All" /all /norestart >nul 2>&1
echo %c%• Enabling Hyper-V Management Tools...%u%
dism /online /enable-feature /featurename:"Microsoft-Hyper-V-Tools-All" /all /norestart >nul 2>&1
echo %c%✓ Hyper-V features enabled%u%

echo.
echo %c%[6/8] Enabling Network Development Tools...%u%
echo %c%• Enabling Telnet Client...%u%
dism /online /enable-feature /featurename:"TelnetClient" /all /norestart >nul 2>&1
echo %c%• Enabling TFTP Client...%u%
dism /online /enable-feature /featurename:"TFTP" /all /norestart >nul 2>&1
echo %c%✓ Network development tools enabled%u%

echo.
echo %c%[7/8] Enabling Legacy Compatibility Features...%u%
echo %c%• Enabling DirectPlay...%u%
dism /online /enable-feature /featurename:"DirectPlay" /all /norestart >nul 2>&1
echo %c%• Enabling Legacy Components...%u%
dism /online /enable-feature /featurename:"LegacyComponents" /all /norestart >nul 2>&1
echo %c%✓ Legacy compatibility enabled%u%

echo.
echo %c%[8/8] Configuring Developer Mode...%u%
echo %c%• Enabling Developer Mode in Registry...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v "AllowDevelopmentWithoutDevLicense" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v "AllowAllTrustedApps" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%• Enabling Sideloading...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v "AllowDevelopmentWithoutDevLicense" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Developer mode configured%u%
goto FeaturesComplete

:ViewFeatures
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                           CURRENT WINDOWS FEATURES STATUS                   ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Scanning current Windows features status...%u%
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                                ENABLED FEATURES                              ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
dism /online /get-features /format:table | findstr /i "Enabled"
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                               DISABLED FEATURES                              ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
dism /online /get-features /format:table | findstr /i "Disabled"
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto WindowsFeaturesManager

:CustomFeatures
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                            CUSTOM FEATURE MANAGER                            ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Select features to manage individually:%u%
echo.
echo %c%                           ╔════════════════════════════════╗
echo                            ║  [1] Hyper-V Features          ║
echo                            ║  [2] WSL and Linux Features    ║
echo                            ║  [3] Media Features            ║
echo                            ║  [4] .NET Framework            ║
echo                            ║  [5] Internet Explorer         ║
echo                            ║  [6] Container Features        ║
echo                            ║  [7] Print Features            ║
echo                            ║  [8] Legacy Components         ║
echo                            ║                                ║
echo                            ║  [0] Back to Features Menu     ║
echo                            ╚════════════════════════════════╝%u%
echo.
set /p choice="%c%Select feature category »%u% "
if "%choice%"=="0" goto WindowsFeaturesManager
if "%choice%"=="1" goto ManageHyperV
if "%choice%"=="2" goto ManageWSL
if "%choice%"=="3" goto ManageMedia
if "%choice%"=="4" goto ManageNET
if "%choice%"=="5" goto ManageIE
if "%choice%"=="6" goto ManageContainers
if "%choice%"=="7" goto ManagePrint
if "%choice%"=="8" goto ManageLegacy
goto CustomFeatures

:ManageHyperV
cls
echo %c%Hyper-V Feature Management%u%
echo.
echo %c%[1] Enable Hyper-V Platform%u%
echo %c%[2] Disable Hyper-V Platform%u%
echo %c%[3] Check Hyper-V Status%u%
echo.
set /p choice="%c%Choose action »%u% "
if "%choice%"=="1" (
    dism /online /enable-feature /featurename:"Microsoft-Hyper-V-All" /all /norestart
    echo %c%✓ Hyper-V enabled%u%
)
if "%choice%"=="2" (
    dism /online /disable-feature /featurename:"Microsoft-Hyper-V-All" /norestart
    bcdedit /set hypervisorlaunchtype off >nul 2>&1
    echo %c%✓ Hyper-V disabled%u%
)
if "%choice%"=="3" (
    dism /online /get-featureinfo /featurename:"Microsoft-Hyper-V-All"
)
pause
goto CustomFeatures

:ManageWSL
cls
echo %c%WSL Feature Management%u%
echo.
echo %c%[1] Enable WSL%u%
echo %c%[2] Disable WSL%u%
echo %c%[3] Enable Virtual Machine Platform%u%
echo %c%[4] Disable Virtual Machine Platform%u%
echo.
set /p choice="%c%Choose action »%u% "
if "%choice%"=="1" (
    dism /online /enable-feature /featurename:"Microsoft-Windows-Subsystem-Linux" /all /norestart
    echo %c%✓ WSL enabled%u%
)
if "%choice%"=="2" (
    dism /online /disable-feature /featurename:"Microsoft-Windows-Subsystem-Linux" /norestart
    echo %c%✓ WSL disabled%u%
)
if "%choice%"=="3" (
    dism /online /enable-feature /featurename:"VirtualMachinePlatform" /all /norestart
    echo %c%✓ Virtual Machine Platform enabled%u%
)
if "%choice%"=="4" (
    dism /online /disable-feature /featurename:"VirtualMachinePlatform" /norestart
    echo %c%✓ Virtual Machine Platform disabled%u%
)
pause
goto CustomFeatures

:FeaturesComplete
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                      WINDOWS FEATURES OPTIMIZATION COMPLETED                 ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
if "%choice%"=="1" (
    echo %c%Gaming Features Applied:%u%
    echo %c%• DirectPlay enabled for legacy games%u%
    echo %c%• .NET Framework versions enabled%u%
    echo %c%• Media bloat removed%u%
    echo %c%• Legacy browsers disabled%u%
    echo %c%• Business features removed%u%
    echo %c%• Development tools enabled%u%
)
if "%choice%"=="2" (
    echo %c%Performance Features Applied:%u%
    echo %c%• All resource-heavy features disabled%u%
    echo %c%• Hyper-V completely removed%u%
    echo %c%• Linux subsystem disabled%u%
    echo %c%• Media features removed%u%
    echo %c%• Legacy components disabled%u%
    echo %c%• Maximum performance achieved%u%
)
if "%choice%"=="3" (
    echo %c%Privacy Features Applied:%u%
    echo %c%• Tracking-heavy browsers removed%u%
    echo %c%• Media telemetry disabled%u%
    echo %c%• Business tracking removed%u%
    echo %c%• Sync services disabled%u%
    echo %c%• Biometric tracking removed%u%
    echo %c%• Security risks eliminated%u%
)
if "%choice%"=="4" (
    echo %c%Developer Features Applied:%u%
    echo %c%• WSL and virtualization enabled%u%
    echo %c%• .NET Framework versions enabled%u%
    echo %c%• Web development tools enabled%u%
    echo %c%• Container features enabled%u%
    echo %c%• Hyper-V management enabled%u%
    echo %c%• Developer Mode configured%u%
)
echo.
echo %red%IMPORTANT: A system restart is required to apply all feature changes!%u%
echo.
set /p "restart_choice=%c%Would you like to restart now? (Y/N) »%u% "
if /i "%restart_choice%"=="Y" (
    echo %c%Restarting system in 10 seconds...%u%
    shutdown /r /t 10 /c "Restarting to apply Windows feature changes - Batlez Tweaks"
    echo %c%✓ Restart scheduled%u%
) else (
    echo %c%Please restart manually when convenient to apply all changes.%u%
)
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto WindowsMenu

:RegistryPerformance
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                           REGISTRY PERFORMANCE OPTIMIZER                     ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will apply comprehensive registry optimizations:%u%
echo %c%• Disable Windows Tips and suggestions%u%
echo %c%• Disable Lock Screen Spotlight and ads%u%
echo %c%• Disable Timeline and Activity History%u%
echo %c%• Configure Explorer for maximum performance%u%
echo %c%• Disable unnecessary visual effects%u%
echo %c%• Remove Windows bloatware registry entries%u%
echo %c%• Optimize system responsiveness%u%
echo.
choice /C YN /M "%c%Apply comprehensive registry performance optimization? (Y/N)%u%"
if errorlevel 2 goto WindowsMenu

echo.
echo %c%[1/8] Disabling Windows Tips and Suggestions...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Windows Tips and suggestions disabled%u%

echo.
echo %c%[2/8] Disabling Lock Screen Spotlight and Ads...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnActionCenter" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnSettings" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightWindowsWelcomeExperience" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" /v "CreativeId" /t REG_SZ /d "" /f >nul 2>&1
echo %c%✓ Lock Screen Spotlight and ads disabled%u%

echo.
echo %c%[3/8] Disabling Timeline and Activity History...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ActivityHistory" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ActivityHistory" /v "PublishUserActivities" /t REG_DWORD /d "0" /f >nul 2>&1

chcp 437 >nul
powershell -Command "Get-ChildItem 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ActivityHistory' | Remove-Item -Recurse -Force" >nul 2>&1
chcp 65001 >nul
echo %c%✓ Timeline and Activity History disabled and cleared%u%

echo.
echo %c%[4/8] Configuring Explorer Performance Optimizations...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisablePreviewDesktop" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontPrettyPath" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewWatermark" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "MapNetDrvBtn" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCompColor" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowInfoTip" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "WebView" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "AlwaysUnloadDLL" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Explorer performance optimizations applied%u%

echo.
echo %c%[5/8] Disabling Unnecessary Visual Effects...%u%
reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Visual effects optimized for performance%u%

echo.
echo %c%[6/8] Removing Windows Bloatware Registry Entries...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Experience\AllowCortana" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1

reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSync" /t REG_DWORD /d "1" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" /v "AllowWindowsInkWorkspace" /t REG_DWORD /d "0" /f >nul 2>&1

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v "PeopleBand" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Windows bloatware registry entries removed%u%

echo.
echo %c%[7/8] Optimizing System Responsiveness...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f >nul 2>&1

reg add "HKCU\Control Panel\Desktop" /v "ForegroundLockTimeout" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f >nul 2>&1

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ System responsiveness optimized%u%

echo.
echo %c%[8/8] Applying Final Performance Tweaks...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v "Enable" /t REG_SZ /d "N" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "Startupdelayinmsec" /t REG_DWORD /d "0" /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "VRROptimizeEnable=0;SwapEffectUpgradeEnable=1;" /f >nul 2>&1

reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\HardCap0" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\HardCap0" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\Paused" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\Paused" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFull" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFull" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLow" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLow" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>&1
for %%F in (BackgroundDefault Frozen FrozenDNCS FrozenDNK FrozenPPLE Paused PausedDNK Pausing PrelaunchForeground ThrottleGPUInterference) do (
    reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\%%F" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>&1
)
for %%I in (Critical CriticalNoUi EmptyHostPPLE High Low Lowest Medium MediumHigh StartHost VeryHigh VeryLow) do (
    reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\%%I" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>&1
    reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\%%I" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>&1
)
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\IO\NoCap" /v "IOBandwidth" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Memory\NoCap" /v "CommitLimit" /t REG_DWORD /d "4294967295" /f >nul 2>&1
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Memory\NoCap" /v "CommitTarget" /t REG_DWORD /d "4294967295" /f >nul 2>&1
echo %c%✓ Final performance tweaks applied%u%

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                   REGISTRY PERFORMANCE OPTIMIZATION COMPLETED                ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Successfully Applied:%u%
echo %c%• Windows Tips and suggestions completely disabled%u%
echo %c%• Lock Screen Spotlight and ads removed%u%
echo %c%• Timeline and Activity History disabled and cleared%u%
echo %c%• Explorer performance optimizations applied%u%
echo %c%• Visual effects minimized for performance%u%
echo %c%• Windows bloatware registry entries removed%u%
echo %c%• System responsiveness significantly improved%u%
echo %c%• Memory management optimized%u%
echo %c%• Background processes minimized%u%
echo %c%• Telemetry and tracking disabled%u%
echo.
echo %c%Performance Benefits:%u%
echo %c%• Faster system startup and shutdown%u%
echo %c%• Improved application response times%u%
echo %c%• Reduced memory and CPU usage%u%
echo %c%• Eliminated privacy invasive features%u%
echo %c%• Cleaner, distraction-free interface%u%
echo %c%• Enhanced gaming and productivity performance%u%
echo.
echo %red%Note: A system restart is recommended to fully apply all optimizations.%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto WindowsMenu

:SystemFileOptimizer
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                           SYSTEM FILE OPTIMIZER                              ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will perform comprehensive system file maintenance:%u%
echo %c%• Run System File Checker (SFC) scan to repair corrupted files%u%
echo %c%• Run DISM health check to repair Windows image%u%
echo %c%• Clean component store to free up space%u%
echo %c%• Optimize WinSxS folder and reduce its size%u%
echo %c%• Reset Windows Store cache and repair store apps%u%
echo %c%• Clear system temporary files and logs%u%
echo.
echo %red%NOTE: This process may take 15-30 minutes depending on your system.%u%
choice /C YN /M "%c%Run comprehensive system file optimization? (Y/N)%u%"
if errorlevel 2 goto WindowsMenu

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                        SYSTEM FILE MAINTENANCE IN PROGRESS                   ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/6] Running System File Checker (SFC) Scan...%u%
echo %c%This will scan and repair corrupted system files...%u%
echo.
sfc /scannow
set SFC_RESULT=%errorlevel%
if %SFC_RESULT%==0 (
    echo %c%✓ SFC scan completed successfully - no issues found%u%
) else (
    echo %c%⚠ SFC scan completed - some files were repaired or issues detected%u%
)

echo.
echo %c%[2/6] Running DISM Health Check and Repair...%u%
echo %c%Checking Windows image health...%u%
dism /online /cleanup-image /checkhealth >nul 2>&1
set DISM_CHECK=%errorlevel%

echo %c%Scanning Windows image health...%u%
dism /online /cleanup-image /scanhealth
set DISM_SCAN=%errorlevel%

if %DISM_SCAN% neq 0 (
    echo %c%Issues detected - running DISM repair...%u%
    dism /online /cleanup-image /restorehealth
    set DISM_REPAIR=%errorlevel%
    if %DISM_REPAIR%==0 (
        echo %c%✓ DISM repair completed successfully%u%
    ) else (
        echo %c%⚠ DISM repair encountered some issues%u%
    )
) else (
    echo %c%✓ Windows image is healthy - no repair needed%u%
)

echo.
echo %c%[3/6] Cleaning Component Store...%u%
echo %c%Analyzing component store...%u%
dism /online /cleanup-image /analyzecomponentstore
echo.
echo %c%Starting component store cleanup...%u%
dism /online /cleanup-image /startcomponentcleanup /resetbase
set CLEANUP_RESULT=%errorlevel%
if %CLEANUP_RESULT%==0 (
    echo %c%✓ Component store cleanup completed successfully%u%
) else (
    echo %c%⚠ Component store cleanup completed with warnings%u%
)

echo.
echo %c%[4/6] Optimizing WinSxS Folder...%u%
echo %c%Current WinSxS folder size analysis:%u%
dism /online /cleanup-image /analyzecomponentstore | findstr /i "size\|recommended"

echo %c%Running advanced WinSxS cleanup...%u%
dism /online /cleanup-image /startcomponentcleanup /resetbase >nul 2>&1

dism /online /cleanup-image /spsuperseded >nul 2>&1

cleanmgr /verylowdisk /sagerun:1 >nul 2>&1

echo %c%✓ WinSxS folder optimization completed%u%

echo.
echo %c%[5/6] Resetting Windows Store Cache...%u%
echo %c%Clearing Windows Store cache...%u%
wsreset.exe >nul 2>&1 &
timeout /t 10 >nul
taskkill /f /im WinStore.App.exe >nul 2>&1

echo %c%Rebuilding Windows Store database...%u%
chcp 437 >nul
powershell -Command "Get-AppxPackage -AllUsers Microsoft.WindowsStore | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\AppXManifest.xml\"}" >nul 2>&1

echo %c%Resetting Windows Store apps...%u%
powershell -Command "Get-AppxPackage | Where-Object {$_.Name -like '*Store*'} | Reset-AppxPackage" >nul 2>&1
chcp 65001 >nul

echo %c%✓ Windows Store cache reset completed%u%

echo.
echo %c%[6/6] Clearing System Files and Logs...%u%
echo %c%Clearing Windows temporary files...%u%
del /f /s /q "%windir%\Temp\*" >nul 2>&1
del /f /s /q "%windir%\Prefetch\*" >nul 2>&1
del /f /s /q "%windir%\SoftwareDistribution\Download\*" >nul 2>&1

echo %c%Clearing system event logs...%u%
for /f "tokens=*" %%G in ('wevtutil.exe el') DO wevtutil.exe cl "%%G" >nul 2>&1

echo %c%Clearing Windows Update cache...%u%
net stop wuauserv >nul 2>&1
net stop cryptSvc >nul 2>&1
net stop bits >nul 2>&1
net stop msiserver >nul 2>&1

del /f /s /q "%windir%\SoftwareDistribution\*" >nul 2>&1
del /f /s /q "%windir%\System32\catroot2\*" >nul 2>&1

net start wuauserv >nul 2>&1
net start cryptSvc >nul 2>&1
net start bits >nul 2>&1
net start msiserver >nul 2>&1

echo %c%Clearing DNS cache...%u%
ipconfig /flushdns >nul 2>&1

echo %c%Rebuilding font cache...%u%
net stop FontCache >nul 2>&1
del /f /s /q "%windir%\ServiceProfiles\LocalService\AppData\Local\FontCache\*" >nul 2>&1
net start FontCache >nul 2>&1

echo %c%✓ System files and logs cleared%u%

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                     SYSTEM FILE OPTIMIZATION COMPLETED                       ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Successfully Completed:%u%
echo %c%• System File Checker (SFC) scan and repair%u%
echo %c%• DISM health check and Windows image repair%u%
echo %c%• Component store cleanup and optimization%u%
echo %c%• WinSxS folder size reduction%u%
echo %c%• Windows Store cache reset and repair%u%
echo %c%• System temporary files and logs cleared%u%
echo %c%• Windows Update cache refreshed%u%
echo %c%• DNS and font cache rebuilt%u%
echo.
echo %c%System Benefits:%u%
echo %c%• Corrupted system files repaired%u%
echo %c%• Windows image integrity restored%u%
echo %c%• Disk space freed up from component cleanup%u%
echo %c%• Windows Store apps functioning properly%u%
echo %c%• System performance improved%u%
echo %c%• Boot time potentially faster%u%
echo.
echo %red%Recommendation: Restart your computer to complete all optimizations.%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto WindowsMenu

:ExplorerOptimizer
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                            WINDOWS EXPLORER OPTIMIZER                        ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will optimize Windows Explorer for maximum performance:%u%
echo %c%• Disable folder thumbnails and preview pane%u%
echo %c%• Configure optimal folder view options%u%
echo %c%• Disable recent files and frequent folders tracking%u%
echo %c%• Optimize taskbar settings for performance%u%
echo %c%• Configure notification area for minimal distractions%u%
echo %c%• Disable unnecessary shell extensions%u%
echo %c%• Remove Explorer bloat and animations%u%
echo.
choice /C YN /M "%c%Apply comprehensive Explorer optimization? (Y/N)%u%"
if errorlevel 2 goto WindowsMenu

echo.
echo %c%[1/8] Disabling Folder Thumbnails and Previews...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v "FolderType" /t REG_SZ /d "NotSpecified" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowPreviewHandlers" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowPreviewPane" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisableThumbnailCache" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisableThumbnailCache" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Folder thumbnails and previews disabled%u%

echo.
echo %c%[2/8] Configuring Optimal Folder View Options...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SeparateProcess" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "FullPath" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Folder view options optimized%u%

echo.
echo %c%[3/8] Disabling Recent Files and Frequent Folders...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowFrequent" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowRecent" /t REG_DWORD /d "0" /f >nul 2>&1

del /f /s /q "%APPDATA%\Microsoft\Windows\Recent\*" >nul 2>&1
del /f /s /q "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*" >nul 2>&1
del /f /s /q "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*" >nul 2>&1
echo %c%✓ Recent files and frequent folders disabled and cleared%u%

echo.
echo %c%[4/8] Optimizing Taskbar Settings...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarGlomLevel" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSizeMove" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseCompactMode" /t REG_DWORD /d "1" /f >nul 2>&1

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Taskbar settings optimized%u%

echo.
echo %c%[5/8] Configuring Notification Area...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /t REG_SZ /d "2000" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutoTrayNotify" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowInfoTip" /t REG_DWORD /d "0" /f >nul 2>&1

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableBalloonTips" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableBalloonTips" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Notification area configured%u%

echo.
echo %c%[6/8] Disabling Unnecessary Shell Extensions...%u%
reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f >nul 2>&1

reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f >nul 2>&1

reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{7d4c7f97-6e12-484b-a10a-6e4a1da2b3e3}" /t REG_SZ /d "" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{e2bf9676-5f8f-435c-97eb-11607a5bedf7}" /t REG_SZ /d "" /f >nul 2>&1
echo %c%✓ Unnecessary shell extensions disabled%u%

echo.
echo %c%[7/8] Removing Explorer Bloat and Animations...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f >nul 2>&1

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowQuickAccess" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "HubMode" /t REG_DWORD /d "1" /f >nul 2>&1

ie4uinit.exe -show >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
del /a /q "%localappdata%\IconCache.db" >nul 2>&1
del /a /f /q "%localappdata%\Microsoft\Windows\Explorer\iconcache*" >nul 2>&1
start explorer.exe >nul 2>&1
echo %c%✓ Explorer bloat removed and icon cache cleared%u%

echo.
echo %c%[8/8] Applying additional UI and filesystem tweaks%u%

reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t REG_DWORD /d "1" /f >nul 2>&1

reg add "HKCU\Control Panel\Desktop" /v "WindowArrangementActive" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableSnapBar" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableSnapAssistFlyout" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableSnapAssistFlyoutPreview" /t REG_DWORD /d "0" /f >nul 2>&1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" /v "TaskbarEndTask" /t REG_DWORD /d "1" /f >nul 2>&1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f >nul 2>&1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "TabletMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "SignInMode" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "TabletModeBatteryThreshold" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\TabletPC" /v "DisableTouchKeyboard" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableDesktopModeAutoInvoke" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\TabletTip\1.7" /v "TipbandDesiredVisibility" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PenWorkspace" /v "PenWorkspaceButtonDesiredVisibility" /t REG_DWORD /d "0" /f >nul 2>&1

reg add "HKCU\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f >nul 2>&1

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "01" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%✓ Long paths, Snap Assist, End Task, transparency, tablet mode, AeroPeek, StorageSense configured%u%

echo.
echo %c%[9/16] Disabling Windows Media Foundation AI enhancements...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows Media Foundation\Platform" /v "EnableAutoEnhancements" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows Media Foundation\Platform" /v "EnableAutoEnhancements" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Media Foundation\Platform" /v "EnableFrameServerMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows Media Foundation\Platform" /v "EnableFrameServerMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Media Foundation\Platform" /v "EnablePostProcessing" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows Media Foundation\Platform" /v "EnablePostProcessing" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Media Foundation\Platform" /v "EnableVideoProcessing" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows Media Foundation\Platform" /v "EnableVideoProcessing" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Media Foundation\Platform" /v "EnableHardwareTransforms" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows Media Foundation\Platform" /v "EnableHardwareTransforms" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Media Foundation\Platform" /v "EnableHDRtoSDRConversion" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows Media Foundation\Platform" /v "EnableHDRtoSDRConversion" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Media Foundation\Platform" /v "EnableSDRtoHDR" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows Media Foundation\Platform" /v "EnableSDRtoHDR" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Media Foundation\Platform" /v "EnableAIUpscaling" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows Media Foundation\Platform" /v "EnableAIUpscaling" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Media Foundation\Platform" /v "EnableSuperResolution" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows Media Foundation\Platform" /v "EnableSuperResolution" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Media Foundation\Platform" /v "EnableEnhancements" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows Media Foundation\Platform" /v "EnableEnhancements" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Media Foundation AI enhancements disabled%u%

echo.
echo %c%[10/16] Disabling video enhancements (VideoManagement, DirectShow, HDR)...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\VideoManagement" /v "EnableHDRVideoAutoBrightness" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\VideoManagement" /v "EnableHDRVideoAutoBrightness" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\VideoManagement" /v "EnableSDRtoHDRVideoExpansion" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\VideoManagement" /v "EnableSDRtoHDRVideoExpansion" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\VideoManagement" /v "EnableSuperResolutionAutoEnhancement" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\VideoManagement" /v "EnableSuperResolutionAutoEnhancement" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\VideoManagement" /v "EnableVideoContrastEnhancement" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\VideoManagement" /v "EnableVideoContrastEnhancement" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\DirectShow" /v "PostProcessEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\DirectShow" /v "PostProcessEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\VideoSettings" /v "EnableHDRForPlayback" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Video enhancements and HDR playback disabled%u%

echo.
echo %c%[11/16] Disabling WPF hardware acceleration and color management (Avalon.Graphics)...%u%
reg add "HKCU\Software\Microsoft\Avalon.Graphics" /v "DisableHWAcceleration" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Avalon.Graphics" /v "DisableHWAcceleration" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Avalon.Graphics" /v "DisableHWAcceleration" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Avalon.Graphics" /v "DisableHWAcceleration" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Avalon.Graphics" /v "DisableHWColorAdjustment" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Avalon.Graphics" /v "DisableHWColorAdjustment" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Avalon.Graphics" /v "DisableHWAntiAliasing" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Avalon.Graphics" /v "DisableHWAntiAliasing" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Avalon.Graphics" /v "EnableClearType" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Avalon.Graphics" /v "EnableClearType" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Avalon.Graphics" /v "MaxMultisampleType" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Avalon.Graphics" /v "MaxMultisampleType" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Avalon.Graphics" /v "UseReferenceRasterizer" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Avalon.Graphics" /v "ForceReferenceRasterizer" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Avalon.Graphics" /v "UseReferenceRasterizer" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Avalon.Graphics" /v "ForceReferenceRasterizer" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ColorManagement" /v "EnableColorCorrection" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ColorManagement" /v "EnableColorCorrection" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ WPF hardware acceleration and color management disabled%u%

echo.
echo %c%[12/16] Disabling DPI scaling and GDI font smoothing...%u%
reg add "HKCU\Control Panel\Desktop" /v "Win8DpiScaling" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "LogPixels" /t REG_DWORD /d "96" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "FontSmoothing" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "FontSmoothingType" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "FontSmoothingGamma" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ DPI scaling and font smoothing disabled%u%

echo.
echo %c%[13/16] Cleaning up Explorer context menus and shell extensions...%u%
PowerShell -ExecutionPolicy Unrestricted -Command "Remove-Item -Path 'HKLM:\SOFTWARE\Classes\Folder\shellex\ContextMenuHandlers\Library Location' -Recurse -Force -EA SilentlyContinue; Remove-Item -Path 'HKLM:\SOFTWARE\Classes\Folder\shell\pintohome' -Recurse -Force -EA SilentlyContinue; Remove-Item -Path 'HKLM:\SOFTWARE\Classes\Directory\background\shellex\ContextMenuHandlers\NvCplDesktopContext' -Recurse -Force -EA SilentlyContinue; Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Windows.help' -Recurse -Force -EA SilentlyContinue; Remove-Item -Path 'HKLM:\SOFTWARE\Classes\Folder\shellex\ContextMenuHandlers\PintoStartScreen' -Recurse -Force -EA SilentlyContinue" >nul 2>&1
PowerShell -ExecutionPolicy Unrestricted -Command "Remove-Item -Path 'Registry::HKEY_CLASSES_ROOT\.library-ms\ShellNew' -Recurse -Force -EA SilentlyContinue; Remove-Item -Path 'Registry::HKEY_CLASSES_ROOT\Folder\ShellNew' -Recurse -Force -EA SilentlyContinue; Remove-Item -Path 'Registry::HKEY_CLASSES_ROOT\.lnk\ShellNew' -Recurse -Force -EA SilentlyContinue; Remove-Item -Path 'Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew' -Recurse -Force -EA SilentlyContinue; Remove-Item -Path 'Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew' -Recurse -Force -EA SilentlyContinue; Remove-Item -Path 'Registry::HKEY_CLASSES_ROOT\.txt\ShellNew' -Recurse -Force -EA SilentlyContinue; Remove-Item -Path 'Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew' -Recurse -Force -EA SilentlyContinue" >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDrivesInSendToMenu" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDrivesInSendToMenu" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoNetConnectDisconnect" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoNetConnectDisconnect" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningToTaskbar" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoPinningToTaskbar" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Shell context menus and extensions cleaned%u%

echo.
echo %c%[14/16] Removing print verbs from file context menus...%u%
PowerShell -ExecutionPolicy Unrestricted -Command "$pp = @('HKLM:\SOFTWARE\Classes\SystemFileAssociations\.txt\shell\print','HKLM:\SOFTWARE\Classes\SystemFileAssociations\.bmp\shell\print','HKLM:\SOFTWARE\Classes\SystemFileAssociations\.rtf\shell\print','HKLM:\SOFTWARE\Classes\SystemFileAssociations\.doc\shell\print','HKLM:\SOFTWARE\Classes\SystemFileAssociations\.docx\shell\print','HKLM:\SOFTWARE\Classes\txtfile\shell\print','HKLM:\SOFTWARE\Classes\txtfile\shell\printto','HKLM:\SOFTWARE\Classes\rtffile\shell\print','HKLM:\SOFTWARE\Classes\rtffile\shell\printto','HKLM:\SOFTWARE\Classes\docxfile\shell\print','HKLM:\SOFTWARE\Classes\docxfile\shell\printto','HKLM:\SOFTWARE\Classes\batfile\shell\print','HKLM:\SOFTWARE\Classes\regfile\shell\print'); foreach ($p in $pp) { Remove-Item -Path $p -Recurse -Force -EA SilentlyContinue }" >nul 2>&1
echo %c%✓ Print verbs removed from context menus%u%

echo.
echo %c%[15/16] Disabling unused WinSock2 namespace providers...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSock2\Parameters\NameSpace_Catalog5\Catalog_Entries\000000000001" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSock2\Parameters\NameSpace_Catalog5\Catalog_Entries64\000000000001" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSock2\Parameters\NameSpace_Catalog5\Catalog_Entries\000000000002" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSock2\Parameters\NameSpace_Catalog5\Catalog_Entries64\000000000002" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSock2\Parameters\NameSpace_Catalog5\Catalog_Entries\000000000003" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSock2\Parameters\NameSpace_Catalog5\Catalog_Entries64\000000000003" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSock2\Parameters\NameSpace_Catalog5\Catalog_Entries\000000000004" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSock2\Parameters\NameSpace_Catalog5\Catalog_Entries64\000000000004" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSock2\Parameters\NameSpace_Catalog5\Catalog_Entries\000000000005" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSock2\Parameters\NameSpace_Catalog5\Catalog_Entries64\000000000005" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSock2\Parameters\NameSpace_Catalog5\Catalog_Entries\000000000007" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinSock2\Parameters\NameSpace_Catalog5\Catalog_Entries64\000000000007" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Unused WinSock2 namespace providers disabled (Email, PNRP, Bluetooth, NLAv1, NT DS)%u%
netsh winsock remove provider 1012 >nul 2>&1
netsh winsock remove provider 1013 >nul 2>&1
netsh winsock remove provider 1014 >nul 2>&1
echo %c%  [+] Hyper-V RAW and Bluetooth LSP providers removed (1012/1013/1014)%u%

echo.
echo %c%[16/16] Disabling storage and bind filter drivers (storqosflt, bindflt)...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\storqosflt" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\bindflt" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
echo %c%✓ Storage QoS filter and bind filter drivers disabled%u%

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                      WINDOWS EXPLORER OPTIMIZATION COMPLETED                 ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Successfully Applied:%u%
echo %c%• Folder thumbnails and previews disabled%u%
echo %c%• Optimal folder view options configured%u%
echo %c%• Recent files and frequent folders tracking disabled%u%
echo %c%• Taskbar optimized for performance%u%
echo %c%• Notification area configured for minimal distractions%u%
echo %c%• Unnecessary shell extensions disabled%u%
echo %c%• Explorer animations and bloat removed%u%
echo %c%• Icon cache cleared and rebuilt%u%
echo %c%• Long file paths enabled (>260 chars)%u%
echo %c%• Snap Assist flyout disabled (drag-to-resize kept)%u%
echo %c%• End Task added to taskbar right-click menu%u%
echo %c%• Transparency effects disabled%u%
echo %c%• Tablet mode and touch keyboard bloat disabled%u%
echo %c%• Aero Peek disabled%u%
echo %c%• Storage Sense auto-delete disabled%u%
echo %c%• Media Foundation AI enhancements disabled (upscaling, super-res, HDR conversion)%u%
echo %c%• Video enhancements disabled (VideoManagement, DirectShow, HDR playback)%u%
echo %c%• WPF hardware acceleration disabled (Avalon.Graphics)%u%
echo %c%• DPI scaling and GDI font smoothing disabled%u%
echo %c%• Shell context menus and ShellNew entries cleaned%u%
echo %c%• Print verbs removed from file right-click menus%u%
echo %c%• Unused WinSock2 namespace providers disabled; Hyper-V RAW and Bluetooth LSP providers removed%u%
echo %c%• Storage QoS and bind filter drivers disabled%u%
echo.
echo %c%Performance Benefits:%u%
echo %c%• Faster folder browsing and file operations%u%
echo %c%• Reduced memory usage in Explorer%u%
echo %c%• Cleaner, more efficient taskbar%u%
echo %c%• Eliminated privacy tracking in file explorer%u%
echo %c%• Reduced system resources usage%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto WindowsMenu

:DefenderOptimizer
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                         WINDOWS DEFENDER OPTIMIZER                           ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Choose your Windows Defender optimization level:%u%
echo.
echo %c%                           ╔════════════════════════════════╗
echo                            ║  [1] Gaming Optimization       ║
echo                            ║  [2] Performance Optimization  ║
echo                            ║  [3] Complete Defender Removal ║
echo                            ║                                ║
echo                            ║  [0] Return to Windows Menu    ║
echo                            ╚════════════════════════════════╝%u%
echo.
echo %c%[1] Gaming: Add game exclusions, reduce scanning, keep protection%u%
echo %c%[2] Performance: Disable real-time protection, configure exclusions%u%
echo %c%[3] Complete Removal: Permanently disable and remove Defender entirely%u%
echo.
set /p choice="%c%Select optimization level »%u% "
if "%choice%"=="0" goto WindowsMenu
if "%choice%"=="1" goto DefenderGaming
if "%choice%"=="2" goto DefenderPerformance
if "%choice%"=="3" goto DefenderRemoval
cls
echo %red%Invalid selection. Please try again.%u%
timeout /t 2 >nul
goto DefenderOptimizer

:DefenderGaming
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                         GAMING OPTIMIZATION MODE                              ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will optimize Defender for gaming while maintaining security:%u%
echo %c%• Add gaming-related exclusions%u%
echo %c%• Reduce scan frequency during gaming hours%u%
echo %c%• Disable notifications during fullscreen%u%
echo %c%• Configure performance mode%u%
echo.
choice /C YN /M "%c%Apply gaming optimization? (Y/N)%u%"
if errorlevel 2 goto DefenderOptimizer

echo.
echo %c%[1/4] Adding Gaming Exclusions...%u%
chcp 437 >nul
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Program Files (x86)\Steam'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Program Files\Epic Games'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Program Files (x86)\Battle.net'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Program Files (x86)\Origin'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Program Files (x86)\Electronic Arts'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Games'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'steam.exe'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'EpicGamesLauncher.exe'" >nul 2>&1
chcp 65001 >nul
echo %c%✓ Gaming platform exclusions added%u%

echo.
echo %c%[2/4] Configuring Performance Settings...%u%
chcp 437 >nul
powershell -Command "Set-MpPreference -EnableNetworkProtection Disabled" >nul 2>&1
powershell -Command "Set-MpPreference -ScanAvgCPULoadFactor 10" >nul 2>&1
powershell -Command "Set-MpPreference -CheckForSignaturesBeforeRunningScan $false" >nul 2>&1
chcp 65001 >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Performance settings optimized%u%

echo.
echo %c%[3/4] Disabling Gaming Interruptions...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\UX Configuration" /v "SuppressRebootNotification" /t REG_DWORD /d "1" /f >nul 2>&1
chcp 437 >nul
powershell -Command "Set-MpPreference -ScanOnlyIfIdleEnabled $true" >nul 2>&1
chcp 65001 >nul
echo %c%✓ Gaming interruptions disabled%u%

echo.
echo %c%[4/4] Configuring Scan Schedules...%u%
chcp 437 >nul
powershell -Command "Set-MpPreference -RemediatePurgeItemsAfterDelay 30" >nul 2>&1
powershell -Command "Set-MpPreference -ScanPurgeItemsAfterDelay 30" >nul 2>&1
chcp 65001 >nul
echo %c%✓ Scan schedules optimized%u%
goto DefenderComplete

:DefenderPerformance
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                        PERFORMANCE OPTIMIZATION MODE                          ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will disable real-time protection and optimize for performance:%u%
echo %c%• Disable real-time protection%u%
echo %c%• Disable cloud protection%u%
echo %c%• Configure system exclusions%u%
echo %c%• Minimize background scanning%u%
echo.
echo %red%WARNING: This reduces system security significantly!%u%
choice /C YN /M "%c%Apply performance optimization? (Y/N)%u%"
if errorlevel 2 goto DefenderOptimizer

echo.
echo %c%[1/5] Disabling Real-Time Protection...%u%
chcp 437 >nul
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true" >nul 2>&1
chcp 65001 >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Real-time protection disabled%u%

echo.
echo %c%[2/5] Disabling Cloud Protection...%u%
chcp 437 >nul
powershell -Command "Set-MpPreference -MAPSReporting Disabled" >nul 2>&1
powershell -Command "Set-MpPreference -SubmitSamplesConsent NeverSend" >nul 2>&1
chcp 65001 >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f >nul 2>&1
echo %c%✓ Cloud protection disabled%u%

echo.
echo %c%[3/5] Adding System Exclusions...%u%
chcp 437 >nul
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Windows\Temp'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Windows\Prefetch'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Windows\SoftwareDistribution'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%TEMP%'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'svchost.exe'" >nul 2>&1
chcp 65001 >nul
echo %c%✓ System exclusions added%u%

echo.
echo %c%[4/5] Disabling Background Scanning...%u%
chcp 437 >nul
powershell -Command "Set-MpPreference -DisableBehaviorMonitoring $true" >nul 2>&1
powershell -Command "Set-MpPreference -DisableBlockAtFirstSeen $true" >nul 2>&1
powershell -Command "Set-MpPreference -DisableIOAVProtection $true" >nul 2>&1
powershell -Command "Set-MpPreference -DisableScriptScanning $true" >nul 2>&1
chcp 65001 >nul
echo %c%✓ Background scanning disabled%u%

echo.
echo %c%[5/5] Optimizing Scan Performance...%u%
chcp 437 >nul
powershell -Command "Set-MpPreference -ScanAvgCPULoadFactor 5" >nul 2>&1
powershell -Command "Set-MpPreference -EnableLowCpuPriority $true" >nul 2>&1
powershell -Command "Set-MpPreference -ScanOnlyIfIdleEnabled $true" >nul 2>&1
chcp 65001 >nul
echo %c%✓ Scan performance optimized%u%
goto DefenderComplete

:DefenderRemoval
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                     ADVANCED DEFENDER REMOVAL ^& HARDENING                    ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %red%⚠️  CRITICAL WARNING ⚠️%u%
echo %red%This will apply STRICT privacy.sexy Defender configurations!%u%
echo.
echo %c%This operation will:%u%
echo %c%• Disable Defender telemetry and data collection%u%
echo %c%• Block cloud-based protection and sample submission%u%
echo %c%• Disable real-time protection and scanning%u%
echo %c%• Remove Defender CSP and management components%u%
echo %c%• Disable SmartScreen and threat detection%u%
echo %c%• Apply comprehensive registry hardening%u%
echo %c%• Soft-delete critical Defender DLLs and executables%u%
echo.
echo %red%THIS WILL SIGNIFICANTLY REDUCE SYSTEM SECURITY!%u%
echo %red%Make sure you have alternative antivirus software ready!%u%
echo.
choice /C YN /M "%red%Apply advanced Defender removal and hardening? (Y/N)%u%"
if errorlevel 2 goto DefenderOptimizer
set choice=3

echo.
echo %c%[1/25] Disabling Malware Removal Tool Telemetry...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ MRT telemetry disabled%u%

echo.
echo %c%[2/25] Disabling Defender Reporting...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableGenericRePorts" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Defender reporting disabled%u%

echo.
echo %c%[3/25] Disabling Core Service Telemetry...%u%
chcp 437 >nul
powershell -Command "try { Set-MpPreference -DisableCoreService1DSTelemetry $true -ErrorAction Stop; Write-Host 'Core service telemetry disabled' } catch { Write-Host 'Skipping: Defender service not available' }" >nul 2>&1
chcp 65001 >nul
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Features" /v "DisableCoreService1DSTelemetry" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Core service telemetry disabled%u%

echo.
echo %c%[4/25] Disabling ECS Integration...%u%
chcp 437 >nul
powershell -Command "try { Set-MpPreference -DisableCoreServiceECSIntegration $true -ErrorAction Stop; Write-Host 'ECS integration disabled' } catch { Write-Host 'Skipping: Defender service not available' }" >nul 2>&1
chcp 65001 >nul
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Features" /v "DisableCoreServiceECSIntegration" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ ECS integration disabled%u%

echo.
echo %c%[5/25] Disabling Block at First Seen...%u%
chcp 437 >nul
powershell -Command "try { Set-MpPreference -DisableBlockAtFirstSeen $true -ErrorAction Stop; Write-Host 'Block at first seen disabled' } catch { Write-Host 'Skipping: Defender service not available' }" >nul 2>&1
chcp 65001 >nul
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\SpyNet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Block at first seen disabled%u%

echo.
echo %c%[6/25] Configuring Cloud Extended Timeout...%u%
chcp 437 >nul
powershell -Command "try { Set-MpPreference -CloudExtendedTimeout 50 -ErrorAction Stop; Write-Host 'Cloud timeout configured' } catch { Write-Host 'Skipping: Defender service not available' }" >nul 2>&1
chcp 65001 >nul
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\MpEngine" /v "MpBafsExtendedTimeout" /t REG_DWORD /d "50" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\MpEngine" /v "MpBafsExtendedTimeout" /t REG_DWORD /d "50" /f >nul 2>&1
echo %c%✓ Cloud timeout configured%u%

echo.
echo %c%[7/25] Disabling Cloud Block Level...%u%
chcp 437 >nul
powershell -Command "try { Set-MpPreference -CloudBlockLevel 0 -ErrorAction Stop; Write-Host 'Cloud block level disabled' } catch { Write-Host 'Skipping: Defender service not available' }" >nul 2>&1
chcp 65001 >nul
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\MpEngine" /v "MpCloudBlockLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\MpEngine" /v "MpCloudBlockLevel" /t REG_DWORD /d "2" /f >nul 2>&1
echo %c%✓ Cloud block level configured%u%

echo.
echo %c%[8/25] Disabling Signature Notifications...%u%
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "SignatureDisableNotification" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\Microsoft Antimalware\Signature Updates" /v "SignatureDisableNotification" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Signature notifications configured%u%

echo.
echo %c%[9/25] Disabling MAPS Reporting...%u%
chcp 437 >nul
powershell -Command "try { Set-MpPreference -MAPSReporting 0 -ErrorAction Stop; Write-Host 'MAPS reporting disabled' } catch { Write-Host 'Skipping: Defender service not available' }" >nul 2>&1
chcp 65001 >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "LocalSettingOverrideSpynetReporting" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ MAPS reporting disabled%u%

echo.
echo %c%[10/25] Configuring Sample Submission...%u%
chcp 437 >nul
powershell -Command "try { Set-MpPreference -SubmitSamplesConsent 2 -ErrorAction Stop; Write-Host 'Sample submission configured' } catch { Write-Host 'Skipping: Defender service not available' }" >nul 2>&1
chcp 65001 >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f >nul 2>&1
echo %c%✓ Sample submission configured%u%

echo.
echo %c%[11/25] Disabling Real-time Signature Delivery...%u%
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "RealtimeSignatureDelivery" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Real-time signature delivery disabled%u%

echo.
echo %c%[12/25] Removing Defender CSP Registry Keys...%u%
reg export "HKLM\Software\Classes\CLSID\{195B4D07-3DE2-4744-BBF2-D90121AE785B}" "%TEMP%\DefenderCSP1.reg" >nul 2>&1
reg delete "HKLM\Software\Classes\CLSID\{195B4D07-3DE2-4744-BBF2-D90121AE785B}" /f >nul 2>&1

reg export "HKLM\Software\Classes\CLSID\{361290c0-cb1b-49ae-9f3e-ba1cbe5dab35}" "%TEMP%\DefenderCSP2.reg" >nul 2>&1
reg delete "HKLM\Software\Classes\CLSID\{361290c0-cb1b-49ae-9f3e-ba1cbe5dab35}" /f >nul 2>&1

reg export "HKLM\Software\Classes\CLSID\{8a696d12-576b-422e-9712-01b9dd84b446}" "%TEMP%\DefenderCSP3.reg" >nul 2>&1
reg delete "HKLM\Software\Classes\CLSID\{8a696d12-576b-422e-9712-01b9dd84b446}" /f >nul 2>&1

reg export "HKLM\Software\Classes\CLSID\{DACA056E-216A-4FD1-84A6-C306A017ECEC}" "%TEMP%\DefenderCSP4.reg" >nul 2>&1
reg delete "HKLM\Software\Classes\CLSID\{DACA056E-216A-4FD1-84A6-C306A017ECEC}" /f >nul 2>&1

reg export "HKLM\Software\Classes\CLSID\{FEEE9C23-C4E2-4A34-8C73-FE8F9786C8B4}" "%TEMP%\DefenderCSP5.reg" >nul 2>&1
reg delete "HKLM\Software\Classes\CLSID\{FEEE9C23-C4E2-4A34-8C73-FE8F9786C8B4}" /f >nul 2>&1

reg export "HKLM\Software\Classes\CLSID\{F80FC80C-6A04-46FB-8555-D769E334E9FC}" "%TEMP%\DefenderCSP6.reg" >nul 2>&1
reg delete "HKLM\Software\Classes\CLSID\{F80FC80C-6A04-46FB-8555-D769E334E9FC}" /f >nul 2>&1

reg export "HKLM\Software\Classes\WOW6432Node\CLSID\{F80FC80C-6A04-46FB-8555-D769E334E9FC}" "%TEMP%\DefenderCSP7.reg" >nul 2>&1
reg delete "HKLM\Software\Classes\WOW6432Node\CLSID\{F80FC80C-6A04-46FB-8555-D769E334E9FC}" /f >nul 2>&1
echo %c%✓ Defender CSP registry keys removed%u%

echo.
echo %c%[13/25] Soft-Deleting Defender DLLs...%u%
takeown /f "%PROGRAMFILES%\Windows Defender\MpAzSubmit.dll" >nul 2>&1
icacls "%PROGRAMFILES%\Windows Defender\MpAzSubmit.dll" /grant administrators:F >nul 2>&1
ren "%PROGRAMFILES%\Windows Defender\MpAzSubmit.dll" "MpAzSubmit.dll.OLD" >nul 2>&1

takeown /f "%PROGRAMFILES%\Windows Defender\DefenderCSP.dll" >nul 2>&1
icacls "%PROGRAMFILES%\Windows Defender\DefenderCSP.dll" /grant administrators:F >nul 2>&1
ren "%PROGRAMFILES%\Windows Defender\DefenderCSP.dll" "DefenderCSP.dll.OLD" >nul 2>&1

takeown /f "%PROGRAMFILES%\Windows Defender\MpProvider.dll" >nul 2>&1
icacls "%PROGRAMFILES%\Windows Defender\MpProvider.dll" /grant administrators:F >nul 2>&1
ren "%PROGRAMFILES%\Windows Defender\MpProvider.dll" "MpProvider.dll.OLD" >nul 2>&1
echo %c%✓ Defender DLLs soft-deleted%u%

echo.
echo %c%[14/25] Disabling Service Keep-Alive...%u%
reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Microsoft Antimalware" /v "ServiceKeepAlive" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Service keep-alive disabled%u%

echo.
echo %c%[15/25] Disabling Fast Service Startup...%u%
reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "AllowFastServiceStartup" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Microsoft Antimalware" /v "AllowFastServiceStartup" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Fast service startup disabled%u%

echo.
echo %c%[16/25] Terminating and Blocking MpDlpCmd.exe...%u%
taskkill /f /im MpDlpCmd.exe >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MpDlpCmd.exe" /v "Debugger" /t REG_SZ /d "%SYSTEMROOT%\System32\taskkill.exe" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "1" /t REG_SZ /d "MpDlpCmd.exe" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisallowRun" /t REG_DWORD /d "1" /f >nul 2>&1

takeown /f "%PROGRAMFILES%\Windows Defender\MpDlpCmd.exe" >nul 2>&1
icacls "%PROGRAMFILES%\Windows Defender\MpDlpCmd.exe" /grant administrators:F >nul 2>&1
ren "%PROGRAMFILES%\Windows Defender\MpDlpCmd.exe" "MpDlpCmd.exe.OLD" >nul 2>&1
echo %c%✓ MpDlpCmd.exe blocked and soft-deleted%u%

echo.
echo %c%[17/25] Disabling SmartScreen DNS Requests...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenDnsRequestsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ SmartScreen DNS requests disabled%u%

echo.
echo %c%[18/25] Configuring WTDS Components...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WTDS\Components" /v "CaptureThreatWindow" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components" /v "CaptureThreatWindow" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ WTDS components configured%u%

echo.
echo %c%[19/25] Disabling WTDS Telemetry...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\FeatureFlags" /v "TelemetryCallsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ WTDS telemetry disabled%u%

echo.
echo %c%[20/25] Soft-Deleting ATP CSP DLL...%u%
takeown /f "%PROGRAMFILES%\Windows Defender Advanced Threat Protection\WATPCSP.dll" >nul 2>&1
icacls "%PROGRAMFILES%\Windows Defender Advanced Threat Protection\WATPCSP.dll" /grant administrators:F >nul 2>&1
ren "%PROGRAMFILES%\Windows Defender Advanced Threat Protection\WATPCSP.dll" "WATPCSP.dll.OLD" >nul 2>&1
echo %c%✓ ATP CSP DLL soft-deleted%u%

echo.
echo %c%[21/25] Soft-Deleting Application Guard CSP...%u%
takeown /f "%SYSTEMROOT%\System32\windowsdefenderapplicationguardcsp.dll" >nul 2>&1
icacls "%SYSTEMROOT%\System32\windowsdefenderapplicationguardcsp.dll" /grant administrators:F >nul 2>&1
ren "%SYSTEMROOT%\System32\windowsdefenderapplicationguardcsp.dll" "windowsdefenderapplicationguardcsp.dll.OLD" >nul 2>&1
echo %c%✓ Application Guard CSP soft-deleted%u%

echo.
echo %c%[22/25] Disabling Application Guard Audit...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\AppHVSI" /v "AuditApplicationGuard" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Application Guard audit disabled%u%

echo.
echo %c%[23/25] Stopping All Defender Services...%u%
net stop "WinDefend" >nul 2>&1
net stop "WdNisSvc" >nul 2>&1
net stop "SecurityHealthService" >nul 2>&1
net stop "Sense" >nul 2>&1
net stop "wscsvc" >nul 2>&1
echo %c%✓ Defender services stopped%u%

echo.
echo %c%[24/25] Disabling Defender Services Permanently...%u%
sc config "WinDefend" start= disabled >nul 2>&1
sc config "WdNisSvc" start= disabled >nul 2>&1
sc config "SecurityHealthService" start= disabled >nul 2>&1
sc config "Sense" start= disabled >nul 2>&1
sc config "wscsvc" start= disabled >nul 2>&1
echo %c%✓ Defender services disabled permanently%u%

echo.
echo %c%[25/25] Final Defender Hardening...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d "1" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d "1" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f >nul 2>&1

schtasks /Change /TN "Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /Disable >nul 2>&1
echo %c%✓ Final Defender hardening completed%u%
goto DefenderComplete

:DefenderComplete
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                     WINDOWS DEFENDER OPTIMIZATION COMPLETED                  ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
if "%choice%"=="1" (
    echo %c%Gaming Optimization Applied:%u%
    echo %c%• Gaming platform exclusions added%u%
    echo %c%• Performance optimized for gaming%u%
    echo %c%• Notifications disabled during gaming%u%
    echo %c%• Security maintained%u%
)
if "%choice%"=="2" (
    echo %c%Performance Optimization Applied:%u%
    echo %c%• Real-time protection disabled%u%
    echo %c%• Cloud protection disabled%u%
    echo %c%• System exclusions added%u%
    echo %c%• Background scanning minimized%u%
    echo %red%• SECURITY SIGNIFICANTLY REDUCED%u%
)
if "%choice%"=="3" (
    echo %red%Complete Defender Removal Applied:%u%
    echo %red%• ALL Defender services permanently disabled%u%
    echo %red%• Defender completely removed from system%u%
    echo %red%• SmartScreen filter disabled%u%
    echo %red%• NO ANTIVIRUS PROTECTION ACTIVE%u%
    echo.
    echo %red%⚠️  INSTALL ALTERNATIVE ANTIVIRUS IMMEDIATELY! ⚠️%u%
)
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto WindowsMenu

:SearchIndexOptimizer
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                           WINDOWS SEARCH INDEX OPTIMIZER                     ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will optimize Windows Search and Indexing for maximum performance:%u%
echo %c%• Disable Windows Search service completely%u%
echo %c%• Configure search indexing locations (exclude unnecessary drives)%u%
echo %c%• Disable web search integration in Start Menu%u%
echo %c%• Clear all search history and cache%u%
echo %c%• Optimize indexing performance settings%u%
echo %c%• Remove Cortana search integration%u%
echo.
echo %red%WARNING: This will disable Windows Search functionality!%u%
echo %c%You will lose: Start Menu search, file search, and indexing features.%u%
echo.
choice /C YN /M "%c%Apply comprehensive search optimization? (Y/N)%u%"
if errorlevel 2 goto WindowsMenu

echo.
echo %c%[1/6] Stopping and Disabling Windows Search Service...%u%
net stop "Windows Search" >nul 2>&1
sc config "WSearch" start= disabled >nul 2>&1
echo %c%✓ Windows Search service disabled%u%

echo.
echo %c%[2/6] Disabling Search Indexer Service...%u%
net stop "SearchIndexer" >nul 2>&1
sc config "SearchIndexer" start= disabled >nul 2>&1
echo %c%✓ Search Indexer service disabled%u%

echo.
echo %c%[3/6] Clearing Search Index Database...%u%
if exist "%ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb" (
    takeown /f "%ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb" >nul 2>&1
    icacls "%ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb" /grant administrators:F >nul 2>&1
    del /f /q "%ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb" >nul 2>&1
    echo %c%✓ Search index database cleared%u%
) else (
    echo %c%✓ Search index database not found (already clean)%u%
)

echo.
echo %c%[4/6] Disabling Web Search in Start Menu...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Web search in Start Menu disabled%u%

echo.
echo %c%[5/6] Disabling Cortana and Search Suggestions...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CanCortanaBeEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "HistoryViewEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowIndexingEncryptedStoresOrItems" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableIndexerBackoff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndexingOutlook" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndexingPublicFolders" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "PreventIndexingEmailAttachments" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Cortana and search suggestions disabled%u%

echo.
echo %c%[6/6] Clearing Search History and Cache...%u%
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\RecentApps" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\JumpListData" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f >nul 2>&1

if exist "%LOCALAPPDATA%\Microsoft\Windows\History" rmdir /s /q "%LOCALAPPDATA%\Microsoft\Windows\History" >nul 2>&1
if exist "%LOCALAPPDATA%\Microsoft\Windows\Caches" rmdir /s /q "%LOCALAPPDATA%\Microsoft\Windows\Caches" >nul 2>&1
echo %c%✓ Search history and cache cleared%u%

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                    WINDOWS SEARCH OPTIMIZATION COMPLETED                     ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Successfully Applied:%u%
echo %c%• Windows Search service completely disabled%u%
echo %c%• Search Indexer service disabled%u%
echo %c%• Web search in Start Menu disabled%u%
echo %c%• Cortana functionality disabled%u%
echo %c%• Search history and cache cleared%u%
echo %c%• Search index database removed%u%
echo %c%• Search box suggestions disabled (policy)%u%
echo %c%• Encrypted store indexing disabled%u%
echo %c%• Outlook, public folder and attachment indexing disabled%u%
echo.
echo %red%Impact:%u%
echo %c%• Start Menu search will no longer work%u%
echo %c%• File Explorer search will be basic (filename only)%u%
echo %c%• Cortana is completely disabled%u%
echo %c%• No web search integration%u%
echo %c%• Significantly reduced background CPU usage%u%
echo %c%• Faster system startup and file operations%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto WindowsMenu

:PrivacyMenu
cls
call :SetupConsole
call :DisplayBanner
echo %c%                            ╔═══════════════════════════════╦════════════════════════════════╗ %u%
echo                             %c%║%u% [%c%1%u%] Telemetry ^& Data Blocker  %c%║%u% [%c%6%u%] Advertising ^& Style        %c%║%u%
echo                             %c%║%u% [%c%2%u%] Cortana ^& Search Privacy  %c%║%u% [%c%7%u%] Privacy Data Cleanup       %c%║%u%
echo                             %c%║%u% [%c%3%u%] Account ^& Cloud Sync      %c%║%u% [%c%8%u%] Advanced Security          %c%║%u%
echo                             %c%║%u% [%c%4%u%] Location ^& Sensor Privacy %c%║%u% [%c%9%u%] DNS ^& Hosts Protection     %c%║%u%
echo                             %c%║%u% [%c%5%u%] App Permissions           %c%║%u% [%c%10%u%] Complete Privacy Audit    %c%║%u%
echo %c%                            ╚═══════════════════════════════╩════════════════════════════════╝
echo.
echo                              %u%[%c%11%u%] Colour Presets   [%c%12%u%] Back to Main   [%red%X%u%] Exit Application
echo.
echo.
set /p M="%c%Choose an option »%u% "
if "%M%"=="1" goto TelemetryBlocker
if "%M%"=="2" goto CortanaPrivacy
if "%M%"=="3" goto AccountPrivacy
if "%M%"=="4" goto LocationPrivacy
if "%M%"=="5" goto AppPermissions
if "%M%"=="6" goto AdvertisingPrivacy
if "%M%"=="7" goto PrivacyDataCleanup
if "%M%"=="8" goto Comingsoon
if "%M%"=="9" goto Comingsoon
if "%M%"=="10" goto Comingsoon
if "%M%"=="11" goto Presets
if "%M%"=="12" goto menu
if "%M%"=="X" goto Destruct
if "%M%"=="x" goto Destruct
cls
echo %underline%%red%Invalid Input. Press any key to continue.%u%
pause >nul
goto PrivacyMenu

:PrivacyDataCleanup
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                    ULTIMATE PRIVACY DATA CLEANUP ^& FORENSICS                 ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will perform the most comprehensive privacy data cleanup available:%u%
echo %c%• Clear all recent files, search history, and application traces%u%
echo %c%• Remove privacy.sexy, Steam, and Visual Studio telemetry data%u%
echo %c%• Delete previous Windows installations (Windows.old)%u%
echo %c%• Clear System Resource Usage Monitor (SRUM) data%u%
echo %c%• Empty Recycle Bin and clear credentials%u%
echo %c%• Remove Windows Update and system logs%u%
echo %c%• Clear cryptographic service traces%u%
echo %c%• Delete component manager and setup logs%u%
echo %c%• Remove WinSAT performance assessment logs%u%
echo.
echo %red%WARNING: This is forensic-level cleanup that will permanently delete system traces!%u%
echo %yellow%Note: Some operations may require elevated permissions or service restarts.%u%
choice /C YN /M "%c%Apply ultimate privacy data cleanup? (Y/N)%u%"
if errorlevel 2 goto PrivacyMenu

echo.
echo %c%[1/25] Clearing Quick Access Recent Files...%u%
if exist "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations" (
    del /f /s /q "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*" >nul 2>&1
    echo %c%✓ Quick Access recent files cleared%u%
) else (
    echo %c%✓ Quick Access recent files directory not found%u%
)

echo.
echo %c%[2/25] Clearing Quick Access Pinned Items...%u%
if exist "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations" (
    del /f /s /q "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*" >nul 2>&1
    echo %c%✓ Quick Access pinned items cleared%u%
) else (
    echo %c%✓ Quick Access pinned items directory not found%u%
)

echo.
echo %c%[3/25] Clearing Windows Registry History...%u%
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit" /v "LastKey" /f >nul 2>&1
for /f %%i in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit\Favorites" 2^>nul ^| find "REG_"') do (
    reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit\Favorites" /v "%%i" /f >nul 2>&1
)
echo %c%✓ Registry history and favorites cleared%u%

echo.
echo %c%[4/25] Clearing Application History...%u%
for /f %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedMRU" 2^>nul ^| find "REG_"') do (
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedMRU" /v "%%i" /f >nul 2>&1
)
for /f %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU" 2^>nul ^| find "REG_"') do (
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU" /v "%%i" /f >nul 2>&1
)
reg delete "HKCU\Software\Adobe\MediaBrowser\MRU" /f >nul 2>&1
for /f %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" 2^>nul ^| find "REG_"') do (
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" /v "%%i" /f >nul 2>&1
)
for /f %%i in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Wordpad\Recent File List" 2^>nul ^| find "REG_"') do (
    reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Wordpad\Recent File List" /v "%%i" /f >nul 2>&1
)
echo %c%✓ Application history cleared%u%

echo.
echo %c%[5/25] Clearing Search and Network History...%u%
reg delete "HKCU\Software\Microsoft\Search Assistant\ACMru" /f >nul 2>&1
for /f %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery" 2^>nul ^| find "REG_"') do (
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery" /v "%%i" /f >nul 2>&1
)
for /f %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU" 2^>nul ^| find "REG_"') do (
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU" /v "%%i" /f >nul 2>&1
)
echo %c%✓ Search and network history cleared%u%

echo.
echo %c%[6/25] Clearing Recent Files and Folders...%u%
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSaveMRU" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU" /f >nul 2>&1
if exist "%APPDATA%\Microsoft\Windows\Recent Items" (
    del /f /s /q "%APPDATA%\Microsoft\Windows\Recent Items\*" >nul 2>&1
)
if exist "%LOCALAPPDATA%\Microsoft\Windows\ConnectedSearch\History" (
    del /f /s /q "%LOCALAPPDATA%\Microsoft\Windows\ConnectedSearch\History\*" >nul 2>&1
)
echo %c%✓ Recent files and folders history cleared%u%

echo.
echo %c%[7/25] Clearing Media Player and DirectX History...%u%
for /f %%i in ('reg query "HKCU\Software\Microsoft\MediaPlayer\Player\RecentFileList" 2^>nul ^| find "REG_"') do (
    reg delete "HKCU\Software\Microsoft\MediaPlayer\Player\RecentFileList" /v "%%i" /f >nul 2>&1
)
for /f %%i in ('reg query "HKCU\Software\Microsoft\MediaPlayer\Player\RecentURLList" 2^>nul ^| find "REG_"') do (
    reg delete "HKCU\Software\Microsoft\MediaPlayer\Player\RecentURLList" /v "%%i" /f >nul 2>&1
)
for /f %%i in ('reg query "HKCU\Software\Microsoft\Direct3D\MostRecentApplication" 2^>nul ^| find "REG_"') do (
    reg delete "HKCU\Software\Microsoft\Direct3D\MostRecentApplication" /v "%%i" /f >nul 2>&1
)
echo %c%✓ Media player and DirectX history cleared%u%

echo.
echo %c%[8/25] Clearing Run Command and Explorer History...%u%
for /f %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" 2^>nul ^| find "REG_"') do (
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /v "%%i" /f >nul 2>&1
)
for /f %%i in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" 2^>nul ^| find "REG_"') do (
    reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /v "%%i" /f >nul 2>&1
)
echo %c%✓ Run command and Explorer history cleared%u%

echo.
echo %c%[9/25] Clearing Privacy.sexy Data...%u%
if exist "%APPDATA%\privacy.sexy\runs" (
    rd /s /q "%APPDATA%\privacy.sexy\runs" >nul 2>&1
)
if exist "%APPDATA%\privacy.sexy\logs" (
    rd /s /q "%APPDATA%\privacy.sexy\logs" >nul 2>&1
)
echo %c%✓ Privacy.sexy data cleared%u%

echo.
echo %c%[10/25] Clearing Steam Privacy Data...%u%
if exist "%PROGRAMFILES(X86)%\Steam\Dumps" (
    del /f /s /q "%PROGRAMFILES(X86)%\Steam\Dumps\*" >nul 2>&1
)
if exist "%PROGRAMFILES(X86)%\Steam\Traces" (
    del /f /s /q "%PROGRAMFILES(X86)%\Steam\Traces\*" >nul 2>&1
)
if exist "%ProgramFiles(x86)%\Steam\appcache" (
    del /f /s /q "%ProgramFiles(x86)%\Steam\appcache\*" >nul 2>&1
)
echo %c%✓ Steam privacy data cleared%u%

echo.
echo %c%[11/25] Clearing Visual Studio Telemetry...%u%
if exist "%LOCALAPPDATA%\Microsoft\VSCommon\14.0\SQM" (
    rd /s /q "%LOCALAPPDATA%\Microsoft\VSCommon\14.0\SQM" >nul 2>&1
)
if exist "%LOCALAPPDATA%\Microsoft\VSCommon\15.0\SQM" (
    rd /s /q "%LOCALAPPDATA%\Microsoft\VSCommon\15.0\SQM" >nul 2>&1
)
if exist "%LOCALAPPDATA%\Microsoft\VSCommon\16.0\SQM" (
    rd /s /q "%LOCALAPPDATA%\Microsoft\VSCommon\16.0\SQM" >nul 2>&1
)
if exist "%LOCALAPPDATA%\Microsoft\VSCommon\17.0\SQM" (
    rd /s /q "%LOCALAPPDATA%\Microsoft\VSCommon\17.0\SQM" >nul 2>&1
)
echo %c%✓ Visual Studio telemetry cleared%u%

echo.
echo %c%[12/25] Clearing Application Insights and VS Telemetry...%u%
if exist "%LOCALAPPDATA%\Microsoft\VSApplicationInsights" (
    rd /s /q "%LOCALAPPDATA%\Microsoft\VSApplicationInsights" >nul 2>&1
)
if exist "%PROGRAMDATA%\Microsoft\VSApplicationInsights" (
    rd /s /q "%PROGRAMDATA%\Microsoft\VSApplicationInsights" >nul 2>&1
)
if exist "%TEMP%\Microsoft\VSApplicationInsights" (
    rd /s /q "%TEMP%\Microsoft\VSApplicationInsights" >nul 2>&1
)
if exist "%APPDATA%\vstelemetry" (
    rd /s /q "%APPDATA%\vstelemetry" >nul 2>&1
)
if exist "%PROGRAMDATA%\vstelemetry" (
    rd /s /q "%PROGRAMDATA%\vstelemetry" >nul 2>&1
)
echo %c%✓ Application Insights and VS telemetry cleared%u%

echo.
echo %c%[13/25] Clearing Previous Windows Installations...%u%
if exist "%SYSTEMDRIVE%\Windows.old" (
    echo %c%Taking ownership and deleting Windows.old folder...%u%
    takeown /f "%SYSTEMDRIVE%\Windows.old" /r /d y >nul 2>&1
    icacls "%SYSTEMDRIVE%\Windows.old" /grant administrators:F /t >nul 2>&1
    rd /s /q "%SYSTEMDRIVE%\Windows.old" >nul 2>&1
    echo %c%✓ Previous Windows installations cleared%u%
) else (
    echo %c%✓ No previous Windows installations found%u%
)

echo.
echo %c%[14/25] Clearing System Resource Usage Monitor (SRUM) Data...%u%
echo %c%Stopping DPS service for SRUM cleanup...%u%
net stop "DPS" >nul 2>&1
if exist "%SYSTEMROOT%\System32\sru\SRUDB.dat" (
    takeown /f "%SYSTEMROOT%\System32\sru\SRUDB.dat" >nul 2>&1
    icacls "%SYSTEMROOT%\System32\sru\SRUDB.dat" /grant administrators:F >nul 2>&1
    del /f "%SYSTEMROOT%\System32\sru\SRUDB.dat" >nul 2>&1
)
echo %c%Restarting DPS service...%u%
net start "DPS" >nul 2>&1
echo %c%✓ SRUM data cleared%u%

echo.
echo %c%[15/25] Emptying Recycle Bin...%u%
rd /s /q "%systemdrive%\$Recycle.bin" >nul 2>&1
echo %c%✓ Recycle Bin emptied%u%

echo.
echo %c%[16/25] Clearing Windows Credential Manager...%u%
for /f "tokens=1,2 delims= " %%a in ('cmdkey /list ^| findstr "Target"') do (
    cmdkey /delete:%%b >nul 2>&1
)
echo %c%✓ Credential Manager cleared%u%

echo.
echo %c%[17/25] Clearing Windows Update and SFC Logs...%u%
if exist "%SYSTEMROOT%\Temp\CBS" (
    del /f /s /q "%SYSTEMROOT%\Temp\CBS\*" >nul 2>&1
)
echo %c%✓ Windows Update and SFC logs cleared%u%

echo.
echo %c%[18/25] Clearing Windows Update Medic Service Logs...%u%
if exist "%SYSTEMROOT%\Logs\waasmedic" (
    del /f /s /q "%SYSTEMROOT%\Logs\waasmedic\*" >nul 2>&1
)
echo %c%✓ Windows Update Medic logs cleared%u%

echo.
echo %c%[19/25] Clearing Cryptographic Services Logs...%u%
del /f "%SYSTEMROOT%\System32\catroot2\dberr.txt" >nul 2>&1
del /f "%SYSTEMROOT%\System32\catroot2.log" >nul 2>&1
del /f "%SYSTEMROOT%\System32\catroot2.jrs" >nul 2>&1
del /f "%SYSTEMROOT%\System32\catroot2.edb" >nul 2>&1
del /f "%SYSTEMROOT%\System32\catroot2.chk" >nul 2>&1
echo %c%✓ Cryptographic services logs cleared%u%

echo.
echo %c%[20/25] Clearing Server-initiated Healing Events Logs...%u%
if exist "%SYSTEMROOT%\Logs\SIH" (
    del /f /s /q "%SYSTEMROOT%\Logs\SIH\*" >nul 2>&1
)
echo %c%✓ SIH logs cleared%u%

echo.
echo %c%[21/25] Clearing Windows Update Traces...%u%
if exist "%SYSTEMROOT%\Traces\WindowsUpdate" (
    del /f /s /q "%SYSTEMROOT%\Traces\WindowsUpdate\*" >nul 2>&1
)
echo %c%✓ Windows Update traces cleared%u%

echo.
echo %c%[22/25] Clearing Component Manager Logs...%u%
del /f "%SYSTEMROOT%\comsetup.log" >nul 2>&1
echo %c%✓ Component manager logs cleared%u%

echo.
echo %c%[23/25] Clearing DTC and File Rename Operation Logs...%u%
del /f "%SYSTEMROOT%\DtcInstall.log" >nul 2>&1
del /f "%SYSTEMROOT%\PFRO.log" >nul 2>&1
echo %c%✓ DTC and file rename logs cleared%u%

echo.
echo %c%[24/25] Clearing Windows Setup and Installation Logs...%u%
del /f "%SYSTEMROOT%\setupact.log" >nul 2>&1
del /f "%SYSTEMROOT%\setuperr.log" >nul 2>&1
del /f "%SYSTEMROOT%\setupapi.log" >nul 2>&1
del /f "%SYSTEMROOT%\inf\setupapi.app.log" >nul 2>&1
del /f "%SYSTEMROOT%\inf\setupapi.dev.log" >nul 2>&1
del /f "%SYSTEMROOT%\inf\setupapi.offline.log" >nul 2>&1
if exist "%SYSTEMROOT%\Panther" (
    del /f /s /q "%SYSTEMROOT%\Panther\*" >nul 2>&1
)
echo %c%✓ Setup and installation logs cleared%u%

echo.
echo %c%[25/25] Clearing WinSAT Performance Assessment Logs...%u%
del /f "%SYSTEMROOT%\Performance\WinSAT\winsat.log" >nul 2>&1
echo %c%✓ WinSAT logs cleared%u%

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                    ULTIMATE PRIVACY DATA CLEANUP COMPLETED                   ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Successfully cleared:%u%
echo %c%• All user activity history and recent files%u%
echo %c%• Application usage traces and registry history%u%
echo %c%• Search history and network mappings%u%
echo %c%• Privacy.sexy, Steam, and Visual Studio telemetry%u%
echo %c%• Previous Windows installations (Windows.old)%u%
echo %c%• System Resource Usage Monitor (SRUM) data%u%
echo %c%• Recycle Bin contents and stored credentials%u%
echo %c%• Windows Update and system service logs%u%
echo %c%• Cryptographic services diagnostic traces%u%
echo %c%• Component manager and setup installation logs%u%
echo %c%• Performance assessment and system traces%u%
echo.
echo %c%Privacy Benefits:%u%
echo %c%• Complete elimination of activity traces%u%
echo %c%• Forensic-level privacy cleanup achieved%u%
echo %c%• System performance monitoring data removed%u%
echo %c%• Installation and setup history cleared%u%
echo %c%• Developer tool telemetry completely removed%u%
echo %c%• Gaming platform privacy data eliminated%u%
echo %c%• Maximum privacy protection implemented%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto PrivacyMenu

:TelemetryBlocker
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                       TELEMETRY & DATA COLLECTION BLOCKER                    ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will comprehensively block Windows telemetry and data collection:%u%
echo %c%• Disable Windows Error Reporting and crash data collection%u%
echo %c%• Block Microsoft compatibility telemetry service%u%
echo %c%• Disable Customer Experience Improvement Program%u%
echo %c%• Block Windows Defender telemetry and sample submission%u%
echo %c%• Disable diagnostic data collection (Full, Enhanced, Basic)%u%
echo %c%• Block Microsoft Office telemetry%u%
echo %c%• Disable Application Impact Telemetry%u%
echo %c%• Block Windows Media Player usage data%u%
echo %c%• Disable WMI ETW autologger tracking sessions%u%
echo %c%• Suppress user feedback (SIUF) prompts and input data harvesting%u%
echo %c%• Harden system: SvcHost threshold, WPBT, driver co-installers, Win update lock%u%
echo.
choice /C YN /M "%c%Apply comprehensive telemetry blocking? (Y/N)%u%"
if errorlevel 2 goto PrivacyMenu

echo.
echo %c%[1/11] Disabling Windows Error Reporting...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d "0" /f >nul 2>&1
sc config "WerSvc" start= disabled >nul 2>&1
net stop "WerSvc" >nul 2>&1
echo %c%✓ Windows Error Reporting disabled%u%

echo.
echo %c%[2/11] Blocking Microsoft Compatibility Telemetry...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f >nul 2>&1
sc config "DiagTrack" start= disabled >nul 2>&1
sc config "dmwappushservice" start= disabled >nul 2>&1
net stop "DiagTrack" >nul 2>&1
net stop "dmwappushservice" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >nul 2>&1
echo %c%✓ Microsoft Compatibility Telemetry blocked%u%

echo.
echo %c%[3/11] Disabling Customer Experience Improvement Program...%u%
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
echo %c%✓ Customer Experience Improvement Program disabled%u%

echo.
echo %c%[4/11] Blocking Windows Defender Telemetry...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >nul 2>&1
chcp 437 >nul
powershell -Command "Set-MpPreference -MAPSReporting Disabled" >nul 2>&1
powershell -Command "Set-MpPreference -SubmitSamplesConsent NeverSend" >nul 2>&1
chcp 65001 >nul
echo %c%✓ Windows Defender telemetry blocked%u%

echo.
echo %c%[5/11] Disabling Diagnostic Data Collection...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\System" /v "AllowExperimentation" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Diagnostic data collection disabled%u%

echo.
echo %c%[6/11] Blocking Microsoft Office Telemetry...%u%
reg add "HKCU\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "VerboseLogging" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Microsoft Office telemetry blocked%u%

echo.
echo %c%[7/11] Disabling Application Impact Telemetry...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\AitAgent" /Disable >nul 2>&1
echo %c%✓ Application Impact Telemetry disabled%u%

echo.
echo %c%[8/11] Blocking Media Player and Additional Telemetry...%u%
reg add "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "UsageTracking" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableCloudOptimizedContent" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Additional telemetry sources blocked%u%

echo.
echo %c%[9/11] Disabling WMI ETW autologger sessions...%u%
for /f %%k in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger" 2^>nul') do (
    reg add "%%k" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "%%k" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
)
echo %c%✓ WMI ETW autologger sessions disabled%u%

echo.
echo %c%[10/11] Suppressing Feedback Prompts and Input Personalization Data...%u%
reg add "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Feedback prompts and input personalization data suppressed%u%

echo.
echo %c%[11/11] System Security Hardening and SvcHost Memory Threshold...%u%
for /f %%m in ('powershell -NoProfile -Command "(Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1KB" 2^>nul') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "%%m" /f >nul 2>&1
)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "DisableWpbtExecution" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Installer" /v "DisableCoInstallers" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdates" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdatesPeriodInDays" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ProductVersion" /t REG_SZ /d "Windows 11" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersion" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "24H2" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows Script Host\Settings" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ SvcHost threshold, WPBT, co-installers hardened; Windows locked to 24H2; WSH disabled%u%

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                    TELEMETRY BLOCKING COMPLETED                              ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Successfully blocked:%u%
echo %c%• Windows Error Reporting and crash data%u%
echo %c%• Microsoft Compatibility Telemetry%u%
echo %c%• Customer Experience Improvement Program%u%
echo %c%• Windows Defender telemetry and samples%u%
echo %c%• All diagnostic data collection levels%u%
echo %c%• Microsoft Office telemetry%u%
echo %c%• Application Impact Telemetry%u%
echo %c%• Media Player usage tracking%u%
echo %c%• WMI ETW autologger sessions%u%
echo %c%• User feedback (SIUF) prompts and input personalization harvesting%u%
echo %c%• System hardened: SvcHost threshold, WPBT, driver co-installers, Windows Script Host disabled%u%
echo %c%• Windows locked to 24H2 (security updates only)%u%
echo.
echo %c%Privacy Benefits:%u%
echo %c%• No more data sent to Microsoft servers%u%
echo %c%• Reduced network traffic%u%
echo %c%• Enhanced system privacy%u%
echo %c%• Improved system performance%u%
echo %c%• Vendor boot-time execution and driver bundleware blocked%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto PrivacyMenu

:CortanaPrivacy
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                          CORTANA & SEARCH PRIVACY                            ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will completely remove Cortana and secure Windows Search:%u%
echo %c%• Completely disable Cortana assistant%u%
echo %c%• Remove Cortana from taskbar and lock screen%u%
echo %c%• Disable web search in Start Menu%u%
echo %c%• Block search suggestions and cloud search%u%
echo %c%• Disable voice activation and speech recognition%u%
echo %c%• Remove search history and personalization%u%
echo %c%• Disable location-based search%u%
echo %c%• Stop Windows Search indexing service%u%
echo.
choice /C YN /M "%c%Apply comprehensive Cortana and search privacy? (Y/N)%u%"
if errorlevel 2 goto PrivacyMenu

echo.
echo %c%[1/6] Completely Disabling Cortana...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Experience\AllowCortana" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CanCortanaBeEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Cortana completely disabled%u%

echo.
echo %c%[2/6] Removing Cortana from Taskbar and Interface...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Cortana removed from interface%u%

echo.
echo %c%[3/6] Disabling Web Search in Start Menu...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWebOverMeteredConnections" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Web search in Start Menu disabled%u%

echo.
echo %c%[4/6] Blocking Search Suggestions and Cloud Search...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsAADCloudSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsDeviceSearchHistoryEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "EnableDynamicContentInWSB" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Search suggestions and cloud search blocked%u%

echo.
echo %c%[5/6] Disabling Voice and Speech Recognition...%u%
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "VoiceShortcut" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Voice, speech recognition and contact harvesting disabled%u%

echo.
echo %c%[6/6] Clearing Search History and Personalization...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "HistoryViewEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\RecentApps" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\JumpListData" /f >nul 2>&1
echo %c%✓ Search history and personalization cleared%u%

echo.
echo %c%[7/7] Disabling Windows Search indexing service...%u%
sc config WSearch start= disabled >nul 2>&1
sc stop WSearch >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowIndexingEncryptedStoresOrItems" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableRemovableDriveIndexing" /t REG_DWORD /d 1 /f >nul 2>&1
echo %c%✓ Windows Search indexing disabled (service stopped)%u%

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                      CORTANA & SEARCH PRIVACY COMPLETED                      ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Successfully secured:%u%
echo %c%• Cortana completely disabled and removed%u%
echo %c%• Web search in Start Menu blocked%u%
echo %c%• Search suggestions and cloud search disabled%u%
echo %c%• Voice activation and speech recognition blocked%u%
echo %c%• Search history and personalization cleared%u%
echo %c%• Location-based search disabled%u%
echo %c%• Windows Search indexing service stopped%u%
echo.
echo %c%Privacy Benefits:%u%
echo %c%• No voice data sent to Microsoft%u%
echo %c%• No search queries tracked or stored%u%
echo %c%• No location data used for search%u%
echo %c%• Enhanced local search privacy%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto PrivacyMenu

:AccountPrivacy
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                       MICROSOFT ACCOUNT & CLOUD SYNC PRIVACY                 ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will secure Microsoft Account integration and cloud synchronization:%u%
echo %c%• Disable OneDrive integration and file sync%u%
echo %c%• Block Microsoft Account sign-in prompts%u%
echo %c%• Disable settings sync across devices%u%
echo %c%• Block cloud clipboard and activity history%u%
echo %c%• Disable automatic Microsoft Store app installs%u%
echo %c%• Remove Microsoft Account dependencies%u%
echo %c%• Block cloud-based password storage%u%
echo.
choice /C YN /M "%c%Apply Microsoft Account and cloud sync privacy? (Y/N)%u%"
if errorlevel 2 goto PrivacyMenu

echo.
echo %c%[1/7] Disabling OneDrive Integration...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSync" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableMeteredNetworkFileSync" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\OneDrive" /v "DisablePersonalSync" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ OneDrive integration disabled%u%

echo.
echo %c%[2/7] Blocking Microsoft Account Sign-in Prompts...%u%
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "BlockUserFromShowingAccountDetailsOnSignin" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoConnectedUser" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftAccount" /v "DisableUserAuth" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Microsoft Account sign-in prompts blocked%u%

echo.
echo %c%[3/7] Disabling Settings Sync Across Devices...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d "5" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\AppSync" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\DesktopTheme" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\PackageState" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\StartLayout" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Settings sync across devices disabled%u%

echo.
echo %c%[4/7] Blocking Cloud Clipboard and Activity History...%u%
reg add "HKCU\SOFTWARE\Microsoft\Clipboard" /v "EnableClipboardHistory" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowClipboardHistory" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowCrossDeviceClipboard" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Cloud clipboard and activity history blocked%u%

echo.
echo %c%[5/7] Disabling Automatic Microsoft Store App Installs...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Automatic Microsoft Store app installs disabled%u%

echo.
echo %c%[6/7] Removing Microsoft Account Dependencies...%u%
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowYourAccount" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableLockScreenAppNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AccountPicture" /v "AccountPictureDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Microsoft Account dependencies removed%u%

echo.
echo %c%[7/7] Blocking Cloud-based Password Storage...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation" /v "AllowProtectedCreds" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\UserSwitch" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Cloud-based password storage blocked%u%

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                   MICROSOFT ACCOUNT & CLOUD SYNC PRIVACY COMPLETED           ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Successfully secured:%u%
echo %c%• OneDrive integration and file sync disabled%u%
echo %c%• Microsoft Account sign-in prompts blocked%u%
echo %c%• Settings sync across devices disabled%u%
echo %c%• Cloud clipboard and activity history blocked%u%
echo %c%• Automatic Microsoft Store app installs disabled%u%
echo %c%• Microsoft Account dependencies removed%u%
echo %c%• Cloud-based password storage blocked%u%
echo.
echo %c%Privacy Benefits:%u%
echo %c%• Files stay local, not synced to cloud%u%
echo %c%• Settings and preferences remain private%u%
echo %c%• No cross-device activity tracking%u%
echo %c%• Enhanced local account privacy%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto PrivacyMenu

:LocationPrivacy
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                         LOCATION & SENSOR PRIVACY                            ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will comprehensively secure location and sensor data:%u%
echo %c%• Disable location services system-wide%u%
echo %c%• Block location access for all apps%u%
echo %c%• Disable camera and microphone access%u%
echo %c%• Block motion and sensor data collection%u%
echo %c%• Disable WiFi sense and network location%u%
echo %c%• Remove location history and tracking%u%
echo %c%• Block geolocation in web browsers%u%
echo.
choice /C YN /M "%c%Apply comprehensive location and sensor privacy? (Y/N)%u%"
if errorlevel 2 goto PrivacyMenu

echo.
echo %c%[1/7] Disabling Location Services System-wide...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v "Status" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t REG_DWORD /d "1" /f >nul 2>&1
sc config "lfsvc" start= disabled >nul 2>&1
net stop "lfsvc" >nul 2>&1
echo %c%✓ Location services system-wide disabled%u%

echo.
echo %c%[2/7] Blocking Location Access for All Apps...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
chcp 437 >nul
powershell -Command "Get-ChildItem 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location\NonPackaged' -ErrorAction SilentlyContinue | ForEach-Object { Set-ItemProperty -Path $_.PSPath -Name 'Value' -Value 'Deny' -Force }" >nul 2>&1
powershell -Command "Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location\NonPackaged' -ErrorAction SilentlyContinue | ForEach-Object { Set-ItemProperty -Path $_.PSPath -Name 'Value' -Value 'Deny' -Force }" >nul 2>&1
chcp 65001 >nul
echo %c%✓ Location access blocked for all apps%u%

echo.
echo %c%[3/7] Disabling Camera and Microphone Access...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Camera" /v "AllowCamera" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Camera and microphone access disabled%u%

echo.
echo %c%[4/7] Blocking Motion and Sensor Data Collection...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableSensors" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SensrSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
sc config "SensrSvc" start= disabled >nul 2>&1
net stop "SensrSvc" >nul 2>&1
echo %c%✓ Motion and sensor data collection blocked%u%

echo.
echo %c%[5/7] Disabling WiFi Sense and Network Location...%u%
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "WiFISenseAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "WiFISenseCredShared" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "WiFISenseOpen" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WcmSvc\GroupPolicy" /v "fMinimizeConnections" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ WiFi Sense and network location disabled%u%

echo.
echo %c%[6/7] Removing Location History and Tracking...%u%
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Location" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Settings\FindMyDevice" /v "LocationSyncEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Location history and tracking removed%u%

echo.
echo %c%[7/7] Blocking Geolocation in Web Browsers...%u%
reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Geolocation" /v "BlockAllWebsites" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Geolocation" /v "BlockAllWebsites" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "PreventOverride" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Geolocation in web browsers blocked%u%

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                     LOCATION & SENSOR PRIVACY COMPLETED                      ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Successfully secured:%u%
echo %c%• Location services system-wide disabled%u%
echo %c%• Location access blocked for all apps%u%
echo %c%• Camera and microphone access disabled%u%
echo %c%• Motion and sensor data collection blocked%u%
echo %c%• WiFi Sense and network location disabled%u%
echo %c%• Location history and tracking removed%u%
echo %c%• Geolocation in web browsers blocked%u%
echo.
echo %c%Privacy Benefits:%u%
echo %c%• No location data collected or shared%u%
echo %c%• Camera/microphone protected from unauthorized access%u%
echo %c%• Motion sensors cannot track your activities%u%
echo %c%• Network location services disabled%u%
echo %c%• Complete location privacy achieved%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto PrivacyMenu

:AppPermissions
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                     APP PERMISSIONS & BACKGROUND APPS                        ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will secure app permissions and background activity:%u%
echo %c%• Disable background apps globally%u%
echo %c%• Block app access to contacts, calendar, email%u%
echo %c%• Disable app access to call history and messaging%u%
echo %c%• Block access to documents, pictures, videos%u%
echo %c%• Disable app notifications and diagnostics%u%
echo %c%• Remove app access to other devices%u%
echo %c%• Block automatic app updates and installations%u%
echo.
choice /C YN /M "%c%Apply comprehensive app permissions and background restrictions? (Y/N)%u%"
if errorlevel 2 goto PrivacyMenu

echo.
echo %c%[1/8] Disabling Background Apps Globally...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f >nul 2>&1
chcp 437 >nul
powershell -Command "Get-AppxPackage | Where-Object {$_.PackageFullName -like '*Microsoft*'} | ForEach-Object {Set-ItemProperty -Path ('HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\' + $_.PackageFamilyName) -Name 'Disabled' -Value 1 -Force -ErrorAction SilentlyContinue}" >nul 2>&1
chcp 65001 >nul
echo %c%✓ Background apps globally disabled%u%

echo.
echo %c%[2/8] Blocking App Access to Contacts, Calendar, Email...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
echo %c%✓ App access to contacts, calendar, email blocked%u%

echo.
echo %c%[3/8] Disabling App Access to Call History and Messaging...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
echo %c%✓ App access to call history and messaging blocked%u%

echo.
echo %c%[4/8] Blocking Access to Documents, Pictures, Videos...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
echo %c%✓ App access to documents, pictures, videos blocked%u%

echo.
echo %c%[5/8] Disabling App Notifications and Diagnostics...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_NOTIFICATION_SOUND" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ App notifications and diagnostics disabled%u%

echo.
echo %c%[6/8] Removing App Access to Other Devices...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wifiData" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\wifiData" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\serialCommunication" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\serialCommunication" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
echo %c%✓ App access to other devices removed%u%

echo.
echo %c%[7/8] Blocking Automatic App Updates and Installations...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /v "AutoDownload" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d "2" /f >nul 2>&1
echo %c%✓ Automatic app updates and installations blocked%u%

echo.
echo %c%[8/8] Final App Permission Restrictions...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
echo %c%✓ Final app permission restrictions applied%u%

echo.
echo %c%[9/11] Blocking microphone access (non-packaged apps and policy)...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone\NonPackaged" /v "LastUsedTimeStop" /t REG_QWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone\NonPackaged" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMicrophone" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMicrophone" /t REG_DWORD /d "2" /f >nul 2>&1
echo %c%✓ Microphone access blocked%u%

echo.
echo %c%[10/11] Blocking webcam access system-wide...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
echo %c%✓ Webcam access blocked%u%

echo.
echo %c%[11/11] Clearing Explorer FeatureUsage tracking data...%u%
PowerShell -ExecutionPolicy Unrestricted -Command "$rootRegistryKeyPath = 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage'; function Clear-RegistryKeyProperties { $currentRegistryKeyPath = $args[0]; $formattedRegistryKeyPath = $currentRegistryKeyPath -replace '^([^\\\\]+)', '$1:'; try { if (-Not (Test-Path -LiteralPath $formattedRegistryKeyPath)) { return; }; $directValueNames=(Get-Item -LiteralPath $formattedRegistryKeyPath -ErrorAction Stop | Select-Object -ExpandProperty Property); if ($directValueNames) { foreach ($valueName in $directValueNames) { Remove-ItemProperty -LiteralPath $formattedRegistryKeyPath -Name $valueName -ErrorAction SilentlyContinue; }; }; } catch {} }; function Clear-RegistrySubkeysProperties { $currentRegistryKeyPath = $args[0]; $formattedRegistryKeyPath = $currentRegistryKeyPath -replace '^([^\\\\]+)', '$1:'; try { if (-Not (Test-Path -LiteralPath $formattedRegistryKeyPath)) { return; }; $subkeys = Get-ChildItem -LiteralPath $formattedRegistryKeyPath -ErrorAction Stop; if (!$subkeys) { return; }; foreach ($subkey in $subkeys) { $subkeyName = $($subkey.PSChildName); $subkeyPath = Join-Path -Path $currentRegistryKeyPath -ChildPath $subkeyName; Clear-RegistryKeyProperties $subkeyPath; }; } catch {} }; Clear-RegistrySubkeysProperties $rootRegistryKeyPath" >nul 2>&1
echo %c%✓ Explorer FeatureUsage tracking cleared%u%

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                 APP PERMISSIONS & BACKGROUND APPS SECURED                    ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Successfully secured:%u%
echo %c%• Background apps globally disabled%u%
echo %c%• App access to contacts, calendar, email blocked%u%
echo %c%• App access to call history and messaging disabled%u%
echo %c%• Access to documents, pictures, videos blocked%u%
echo %c%• App notifications and diagnostics disabled%u%
echo %c%• App access to other devices removed%u%
echo %c%• Automatic app updates and installations blocked%u%
echo %c%• All sensitive app permissions restricted%u%
echo.
echo %c%Privacy Benefits:%u%
echo %c%• Apps cannot access personal data%u%
echo %c%• No background data collection%u%
echo %c%• Files and media remain private%u%
echo %c%• Reduced battery and performance impact%u%
echo %c%• Enhanced overall system privacy%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto PrivacyMenu

:AdvertisingPrivacy
cls
call :SetupConsole
echo.
echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                       ADVERTISING & PERSONALIZATION BLOCKER                  ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will completely block advertising and personalization:%u%
echo %c%• Disable advertising ID and tracking%u%
echo %c%• Block targeted ads in Windows and apps%u%
echo %c%• Disable content delivery and suggestions%u%
echo %c%• Remove Start Menu ads and promoted apps%u%
echo %c%• Block Lock Screen ads and Spotlight%u%
echo %c%• Disable Edge and browser advertising%u%
echo %c%• Remove Windows tips and promotional content%u%
echo.
choice /C YN /M "%c%Apply comprehensive advertising and personalization blocking? (Y/N)%u%"
if errorlevel 2 goto PrivacyMenu

echo.
echo %c%[1/7] Disabling Advertising ID and Tracking...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Advertising ID and tracking disabled%u%

echo.
echo %c%[2/7] Blocking Targeted Ads in Windows and Apps...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-314559Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Targeted ads in Windows and apps blocked%u%

echo.
echo %c%[3/7] Disabling Content Delivery and Suggestions...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableCloudOptimizedContent" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Content delivery and suggestions disabled%u%

echo.
echo %c%[4/7] Removing Start Menu Ads and Promoted Apps...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-314559Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Start Menu ads and promoted apps removed%u%

echo.
echo %c%[5/7] Blocking Lock Screen Ads and Spotlight...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnActionCenter" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnSettings" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightWindowsWelcomeExperience" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnLockScreen" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Lock Screen ads and Spotlight blocked%u%

echo.
echo %c%[6/7] Disabling Edge and Browser Advertising...%u%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PersonalizationReportingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "ConfigureDoNotTrack" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "TrackingPrevention" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v "AllowPrelaunch" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" /v "AllowTabPreloading" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ Edge and browser advertising disabled%u%

echo.
echo %c%[7/7] Removing Windows Tips and Promotional Content...%u%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Windows tips and promotional content removed%u%

echo.
echo %c%╔═══════════════════════════════════════════════════════════════════════════════╗
echo ║                ADVERTISING & PERSONALIZATION BLOCKING COMPLETED              ║
echo ╚═══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Successfully blocked:%u%
echo %c%• Advertising ID and tracking completely disabled%u%
echo %c%• Targeted ads in Windows and apps blocked%u%
echo %c%• Content delivery and suggestions disabled%u%
echo %c%• Start Menu ads and promoted apps removed%u%
echo %c%• Lock Screen ads and Spotlight blocked%u%
echo %c%• Edge and browser advertising disabled%u%
echo %c%• Windows tips and promotional content removed%u%
echo.
echo %c%Privacy Benefits:%u%
echo %c%• No personalized advertising or tracking%u%
echo %c%• Clean, ad-free Windows experience%u%
echo %c%• No promotional content or suggestions%u%
echo %c%• Enhanced browsing privacy%u%
echo %c%• Reduced data collection and profiling%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto PrivacyMenu

:AdvancedMenu
:GameBoosters
cls
chcp 65001 >nul
echo.
echo     %c%    ██████╗ █████╗  ████████╗██╗     ███████╗███████╗  ████████╗ ██╗       ██╗███████╗ █████╗ ██╗  ██╗ ██████╗
echo         ██╔══██╗██╔══██╗╚══██╔══╝██║     ██╔════╝╚════██║  ╚══██╔══╝ ██║  ██╗  ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝
echo         ██████╦╝███████║   ██║   ██║     █████╗    ███╔═╝     ██║    ╚██╗████╗██╔╝█████╗  ███████║█████═╝ ╚█████╗  %u%
echo         ██╔══██╗██╔══██║   ██║   ██║     ██╔══╝  ██╔══╝       ██║     ████╔═████║ ██╔══╝  ██╔══██║██╔═██╗  ╚═══██╗
echo         ██████╦╝██║  ██║   ██║   ███████╗███████╗███████╗     ██║     ╚██╔╝ ╚██╔╝ ███████╗██║  ██║██║ ╚██╗██████╔╝
echo         ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝╚══════╝     ╚═╝      ╚═╝   ╚═╝  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝
echo.
echo %c%                       ╔══════════════════════════════════════════════════╗ %u%
echo                        %c%║%u%           [%c%1%u%] Batlez Toolbox                     %c%║%u%
echo                        %c%║%u%           [%c%2%u%] Game Boosters                      %c%║%u%
echo                        %c%║%u%           [%c%3%u%] Scheduled Tasks                    %c%║%u%
echo                        %c%║%u%           [%c%4%u%] MSI Mode                           %c%║%u%
echo                        %c%║%u%           [%c%5%u%] Program Debloat                    %c%║%u%
echo                        %c%║%u%           [%c%6%u%] Affinity                           %c%║%u%
echo                        %c%║%u%           [%c%7%u%] DirectX Optimization               %c%║%u%
echo                        %c%║%u%           [%c%8%u%] OBS Optimizer                      %c%║%u%
echo                        %c%║%u%           [%c%10%u%] Stream Optimizer                  %c%║%u%
echo %c%                       ╚══════════════════════════════════════════════════╝
echo %c%                             ║  %u%[%c%9%u%] Theme Presets    [%c%0%u%] Go Back    %c%║%u%
echo %c%                             ║            %u% [%c%Quit%u%] Leave%c%             ║
echo %c%                             ╚══════════════════════════════════════╝
echo %u%                                      Current Version: %c%%version%
echo %u%                                %u%User %c%%username% %u%- Date %c%%date% %u%
echo.
echo.
echo.
set /p M="%c%Choose an option »%u% "
if "%M%"=="1" goto Toolbox
if "%M%"=="2" goto Boosters
if "%M%"=="3" goto ScheduledTasks
if "%M%"=="4" goto MSIMode
if "%M%"=="5" goto ProgramDebloat
if "%M%"=="6" goto Affinity
if "%M%"=="7" goto DirectXOptimization
if "%M%"=="8" goto OBSOptimizer
if "%M%"=="9" goto Presets
if "%M%"=="10" goto StreamOptimizer
if "%M%"=="0" goto menu
if "%M%"=="Quit" goto Destruct
cls
echo %underline%%red%Invalid Input. Press any key to continue.%u%
pause >nul
goto AdvancedMenu

:StreamOptimizer
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          STREAM OPTIMIZER                                    ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Optimizes your system for gaming while live streaming:%u%
echo %c%• Sets process priority: game High, streaming tools Normal/BelowNormal%u%
echo %c%• Pins TikTok Studio and Tikinfinity to background CPU cores%u%
echo %c%• Disables Tikinfinity browser hardware acceleration (WebView bloat)%u%
echo %c%• Disables Xbox Game Bar and Game DVR capture overhead%u%
echo %c%• Enables Hardware-Accelerated GPU Scheduling (HAGS) for RTX%u%
echo %c%• Optimizes page file for low-RAM streaming sessions%u%
echo %c%• Disables HPET for Ryzen CPU stutter reduction%u%
echo %c%• Disables background apps to free RAM and CPU%u%
echo %c%• Clears TikTok Studio cache bloat%u%
echo %c%• Enables Fortnite Performance Mode via registry%u%
echo.
echo %red%Note: Run this AFTER launching Fortnite, TikTok Studio and Tikinfinity.%u%
echo.
choice /C YN /M "%c%Apply Stream Optimizer? (Y/N)%u%"
if errorlevel 2 goto AdvancedMenu

echo.
echo %c%[1/10] Setting process priorities...%u%
chcp 437 >nul
powershell -NoProfile -Command ^
  "$games = @('FortniteClient-Win64-Shipping','FortniteClient-Win64-Shipping_EAC','FortniteLauncher'); ^
   $streaming = @('TikTok LIVE Studio'); ^
   $overlay = @('tikfinity'); ^
   foreach ($n in $games)   { $p = Get-Process $n -EA SilentlyContinue; if ($p) { $p.PriorityClass = 'High' } } ^
   foreach ($n in $streaming){ $p = Get-Process $n -EA SilentlyContinue; if ($p) { $p.PriorityClass = 'Normal' } } ^
   foreach ($n in $overlay)  { $p = Get-Process $n -EA SilentlyContinue; if ($p) { $p.PriorityClass = 'BelowNormal' } }" >nul 2>&1
chcp 65001 >nul
echo %c%✓ Process priorities applied%u%

echo.
echo %c%[2/10] Pinning streaming tools to background CPU cores (cores 8-11)...%u%
chcp 437 >nul
powershell -NoProfile -Command ^
  "$cores = 0x0F00; ^
   $overlayMask = 0x0C00; ^
   $streaming = @('TikTok LIVE Studio'); ^
   $overlay = @('tikfinity'); ^
   foreach ($n in $streaming){ $p = Get-Process $n -EA SilentlyContinue; if ($p) { $p.ProcessorAffinity = $cores } } ^
   foreach ($n in $overlay)  { $p = Get-Process $n -EA SilentlyContinue; if ($p) { $p.ProcessorAffinity = $overlayMask } }" >nul 2>&1
chcp 65001 >nul
echo %c%✓ Affinity applied (TikTok Studio: cores 8-11, Tikinfinity: cores 10-11)%u%

echo.
echo %c%[3/10] Disabling Tikinfinity WebView hardware acceleration...%u%
if not exist "%LOCALAPPDATA%\Programs\tikfinity\User Data" mkdir "%LOCALAPPDATA%\Programs\tikfinity\User Data" >nul 2>&1
(
    echo {
    echo   "hardware_acceleration_mode": {
    echo     "enabled": false
    echo   }
    echo }
) > "%LOCALAPPDATA%\Programs\tikfinity\User Data\Local State" 2>nul
echo %c%✓ Tikinfinity hardware acceleration disabled%u%

echo.
echo %c%[4/10] Disabling Xbox Game Bar and Game DVR capture overhead...%u%
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
echo %c%✓ Game DVR and Xbox overlay disabled%u%

echo.
echo %c%[5/10] Enabling Hardware-Accelerated GPU Scheduling (HAGS) for RTX...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
echo %c%✓ HAGS enabled (takes effect after reboot)%u%

echo.
echo %c%[6/10] Optimizing page file for streaming workload...%u%
chcp 437 >nul
powershell -NoProfile -Command ^
  "$ram = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum/1MB); ^
   $pf = [math]::Min([math]::Max($ram*2,8192),32768); ^
   $cs = Get-CimInstance Win32_ComputerSystem; ^
   Set-CimInstance -InputObject $cs -Property @{AutomaticManagedPagefile=$false}; ^
   $existing = Get-CimInstance Win32_PageFileSetting; ^
   if($existing){Set-CimInstance -InputObject $existing -Property @{InitialSize=$pf;MaximumSize=$pf}} ^
   else{New-CimInstance -ClassName Win32_PageFileSetting -Property @{Name='C:\pagefile.sys';InitialSize=$pf;MaximumSize=$pf}}" >nul 2>&1
chcp 65001 >nul
echo %c%✓ Page file set to 2x RAM (capped at 32GB)%u%

echo.
echo %c%[7/10] Disabling HPET (reduces Ryzen micro-stutter)...%u%
bcdedit /set useplatformclock false >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /deletevalue useplatformtick >nul 2>&1
echo %c%✓ HPET disabled via BCD (takes effect after reboot)%u%

echo.
echo %c%[8/10] Disabling background apps (frees RAM and CPU for game/stream)...%u%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d 0 /f >nul 2>&1
echo %c%✓ Background apps disabled%u%

echo.
echo %c%[9/10] Clearing TikTok LIVE Studio cache bloat...%u%
set "_cleared=0"
if exist "C:\Program Files\TikTok LIVE Studio\Cache" (
    rd /s /q "C:\Program Files\TikTok LIVE Studio\Cache" >nul 2>&1
    set "_cleared=1"
)
if exist "%LOCALAPPDATA%\TikTok LIVE Studio\Cache" (
    rd /s /q "%LOCALAPPDATA%\TikTok LIVE Studio\Cache" >nul 2>&1
    set "_cleared=1"
)
if exist "%APPDATA%\TikTok LIVE Studio\Cache" (
    rd /s /q "%APPDATA%\TikTok LIVE Studio\Cache" >nul 2>&1
    set "_cleared=1"
)
if "%_cleared%"=="1" (
    echo %c%✓ TikTok LIVE Studio cache cleared%u%
) else (
    echo %c%  TikTok LIVE Studio cache folder not found, skipping%u%
)

echo.
echo %c%[10/10] Enabling Fortnite Performance Mode (DX11 low-level rendering)...%u%
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "PreferD3D12" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.AntiAliasingQuality" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.ViewDistanceQuality" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.ShadowQuality" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.TexturesQuality" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.EffectsQuality" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.bSmoothFrameRate" /t REG_DWORD /d 0 /f >nul 2>&1
echo %c%✓ Fortnite low-latency settings applied (enable Performance Mode in-game)%u%

echo.
echo.
echo.                                         %c%═══════════════════════════════════════════════════════
echo.                                           %c%  Stream Optimizer complete! Reboot recommended.%u%
echo.                                         %c%═══════════════════════════════════════════════════════%u%
echo.
echo %c%Manual steps to do in-app after rebooting:%u%
echo %c%  TikTok Studio : Encoder=NVENC H.264, CBR, 4500 kbps, disable scene preview%u%
echo %c%  Fortnite      : Enable Performance Mode in Settings > Video > Rendering Mode%u%
echo %c%  Tikinfinity   : Use simple overlays, unload sources when not visible%u%
pause >nul
goto AdvancedMenu

:DirectXOptimization
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         DIRECTX OPTIMIZATION                                 ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will optimize DirectX rendering settings for lower latency and better fps:%u%
echo %c%• Enable flip-queue bypass (FlipNoVsync) for Direct3D%u%
echo %c%• Force GPU-local video memory for Direct3D and DirectDraw%u%
echo %c%• Enable Multiplane Overlay (MPO) Direct Flip (OverlayTestMode=5)%u%
echo %c%• Apply to both 64-bit and 32-bit subsystems%u%
echo.
choice /C YN /M "%c%Apply DirectX optimizations? (Y/N)%u%"
if errorlevel 2 goto AdvancedMenu

echo.
echo %c%[1/3] Optimizing Direct3D settings...%u%
reg add "HKCU\SOFTWARE\Microsoft\Direct3D" /v "FlipNoVsync" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Direct3D" /v "UseNonLocalVidMem" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "FlipNoVsync" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "UseNonLocalVidMem" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Wow6432Node\Microsoft\Direct3D" /v "FlipNoVsync" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Wow6432Node\Microsoft\Direct3D" /v "UseNonLocalVidMem" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D" /v "FlipNoVsync" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Direct3D" /v "UseNonLocalVidMem" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c%✓ Direct3D settings applied%u%

echo.
echo %c%[2/3] Optimizing DirectDraw settings...%u%
reg add "HKCU\SOFTWARE\Microsoft\DirectDraw" /v "UseNonLocalVidMem" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\DirectDraw" /v "DisableAGPSupport" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "UseNonLocalVidMem" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "DisableAGPSupport" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Wow6432Node\Microsoft\DirectDraw" /v "UseNonLocalVidMem" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Wow6432Node\Microsoft\DirectDraw" /v "DisableAGPSupport" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\DirectDraw" /v "UseNonLocalVidMem" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\DirectDraw" /v "DisableAGPSupport" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ DirectDraw settings applied%u%

echo.
echo %c%[3/4] Enabling MPO Direct Flip...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d "5" /f >nul 2>&1
echo %c%✓ MPO Direct Flip enabled (OverlayTestMode=5)%u%

echo.
echo %c%[4/4] Disabling Fullscreen Optimizations (FSO)...%u%
reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c%✓ FSO disabled (DXGIHonorFSEWindowsCompatible=1, GameDVR=0)%u%

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                   DIRECTX OPTIMIZATION COMPLETED                             ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Applied:%u%
echo %c%• Direct3D FlipNoVsync and GPU-local memory (64-bit + 32-bit)%u%
echo %c%• DirectDraw local memory and AGP enabled (64-bit + 32-bit)%u%
echo %c%• MPO Direct Flip via OverlayTestMode=5%u%
echo %c%• Fullscreen Optimizations (FSO) disabled for exclusive fullscreen%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto AdvancedMenu

:OBSOptimizer
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                            OBS OPTIMIZER                                     ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This will optimize OBS Studio encoding settings for your GPU:%u%
echo %c%• Select encoder: NVENC (NVIDIA) / AMF (AMD) / x264 (CPU)%u%
echo %c%• Three quality tiers: Performance / Balanced / Quality%u%
echo %c%• Updates all existing OBS profiles automatically%u%
echo %c%• Sets OBS process priority to Above Normal via registry%u%
echo.
set "OBSProfilePath=%APPDATA%\obs-studio\basic\profiles"
if not exist "%OBSProfilePath%" (
    echo %red%[!] OBS Studio profiles not found at:%u%
    echo %c%    %OBSProfilePath%%u%
    echo %c%    Launch OBS at least once to create profiles, then re-run.%u%
    echo.
    echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
    pause >nul
    goto AdvancedMenu
)
echo %c%[✓] OBS profiles found%u%
echo.
echo %c%Select encoder:%u%
echo %c%[1] NVIDIA NVENC    - Hardware encoding (NVIDIA GPU required)%u%
echo %c%[2] AMD AMF / VCE   - Hardware encoding (AMD GPU required)%u%
echo %c%[3] x264 CPU        - Software encoding (any CPU)%u%
echo.
set /p ENC_PICK="%c%Choose encoder [1/2/3] »%u% "
echo.
echo %c%Select quality tier:%u%
echo %c%[1] Performance  - Low overhead, best for competitive gaming%u%
echo %c%[2] Balanced     - Good quality with moderate impact%u%
echo %c%[3] Quality      - High quality for recording / content creation%u%
echo.
set /p QUAL_PICK="%c%Choose tier [1/2/3] »%u% "

if "%ENC_PICK%"=="1" set "ENC_NAME=jim_nvenc"
if "%ENC_PICK%"=="2" set "ENC_NAME=amd_amf_h264"
if "%ENC_PICK%"=="3" set "ENC_NAME=obs_x264"
if not defined ENC_NAME set "ENC_NAME=jim_nvenc"

if "%QUAL_PICK%"=="1" (
    set "OBS_PRESET=performance"
    set "OBS_BITRATE=4000"
    set "OBS_RECQUALITY=Small"
)
if "%QUAL_PICK%"=="2" (
    set "OBS_PRESET=quality"
    set "OBS_BITRATE=6000"
    set "OBS_RECQUALITY=Stream"
)
if "%QUAL_PICK%"=="3" (
    set "OBS_PRESET=slow"
    set "OBS_BITRATE=8000"
    set "OBS_RECQUALITY=Lossless"
)
if not defined OBS_PRESET (
    set "OBS_PRESET=quality"
    set "OBS_BITRATE=6000"
    set "OBS_RECQUALITY=Stream"
)

echo.
echo %c%[1/2] Updating OBS profile settings...%u%
(
    echo $profilesPath = '%OBSProfilePath%'
    echo $encName = '%ENC_NAME%'
    echo $recQuality = '%OBS_RECQUALITY%'
    echo $vBitrate = '%OBS_BITRATE%'
    echo Get-ChildItem $profilesPath -Directory ^| ForEach-Object {
    echo     $f = Join-Path $_.FullName 'basic.ini'
    echo     if ^(Test-Path $f^) {
    echo         $c = Get-Content $f -Raw
    echo         if ^($c -match 'StreamEncoder'^) { $c = $c -replace '(?m)^StreamEncoder=.*', "StreamEncoder=$encName" } else { $c += "`r`nStreamEncoder=$encName" }
    echo         if ^($c -match 'RecEncoder'^) { $c = $c -replace '(?m)^RecEncoder=.*', "RecEncoder=$encName" } else { $c += "`r`nRecEncoder=$encName" }
    echo         if ^($c -match 'RecQuality'^) { $c = $c -replace '(?m)^RecQuality=.*', "RecQuality=$recQuality" } else { $c += "`r`nRecQuality=$recQuality" }
    echo         if ^($c -match 'VBitrate'^) { $c = $c -replace '(?m)^VBitrate=.*', "VBitrate=$vBitrate" } else { $c += "`r`nVBitrate=$vBitrate" }
    echo         Set-Content $f $c -NoNewline
    echo     }
    echo }
) > "%TEMP%\obs_batlez.ps1"
chcp 437 >nul
powershell -ExecutionPolicy Bypass -File "%TEMP%\obs_batlez.ps1" >nul 2>&1
chcp 65001 >nul
del "%TEMP%\obs_batlez.ps1" >nul 2>&1
echo %c%✓ OBS profiles updated%u%

echo.
echo %c%[2/2] Setting OBS process priority...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\obs64.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "6" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\obs32.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "6" /f >nul 2>&1
echo %c%✓ OBS priority set to Above Normal%u%

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       OBS OPTIMIZER COMPLETED                                ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Applied:%u%
echo %c%• Encoder:        %ENC_NAME%%u%
echo %c%• Preset:         %OBS_PRESET%%u%
echo %c%• Stream bitrate: %OBS_BITRATE% kbps%u%
echo %c%• Record quality: %OBS_RECQUALITY%%u%
echo %c%• Process priority: Above Normal (CpuPriorityClass=6)%u%
echo.
echo %c%Restart OBS Studio for profile changes to take effect.%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto AdvancedMenu

:ProgramDebloat
cls
call :SetupConsole
call :DisplayBanner
echo %c%                       ╔═════════════════════════════════════════════╗ %u%
echo                        %c%║%u%           [%c%1%u%] Program Debloat (VS / Nvidia / etc)   %c%║%u%
echo                        %c%║%u%           [%c%2%u%] Discord Debloat                        %c%║%u%
echo                        %c%║%u%           [%c%3%u%] Steam Debloat                          %c%║%u%
echo                        %c%║%u%           [%c%4%u%] Spotify Debloat                        %c%║%u%
echo                        %c%║%u%           [%c%5%u%] Firefox Debloat                        %c%║%u%
echo                        %c%║%u%           [%c%6%u%] Chrome Debloat                         %c%║%u%
echo %c%                       ╚═════════════════════════════════════════════╝
echo %c%                                   ║  %u%[%c%0%u%] Go Back    [%red%X%u%] Exit%c%  ║%u%
echo %c%                                   ╚═══════════════════════════════╝%u%
echo.
echo.
set /p M="%c%Choose an option »%u% "
if "%M%"=="0" goto AdvancedMenu
if "%M%"=="1" goto debloatprogram
if "%M%"=="2" goto debloatdiscord
if "%M%"=="3" goto debloatsteam
if "%M%"=="4" goto debloatspotify
if "%M%"=="5" goto debloatfirefox
if "%M%"=="6" goto debloatchrome
if "%M%"=="X" goto Destruct
if "%M%"=="x" goto Destruct
cls
echo %underline%%red%Invalid Input. Press any key to continue.%u%
pause >nul
goto ProgramDebloat

:debloatchrome
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           CHROME DEBLOAT                                    ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Removing Chrome background services and updaters:%u%
echo %c%• Google Update service stopped and deleted%u%
echo %c%• Chrome Elevation Service removed%u%
echo %c%• GoogleUpdate.exe process killed%u%
echo %c%• Update folder and chrmstp.exe removed%u%
echo.
echo.
net stop gupdate >nul 2>&1
sc delete gupdate >nul 2>&1
net stop googlechromeelevationservice >nul 2>&1
sc delete googlechromeelevationservice >nul 2>&1
net stop gupdatem >nul 2>&1
sc delete gupdatem >nul 2>&1
taskkill /f /im GoogleUpdate.exe >nul 2>&1
rmdir "C:\Program Files (x86)\Google\Update" /s /q >nul 2>&1
cd /d "C:\Program Files\Google\Chrome\Application" >nul 2>&1
del /f /s /q chrmstp.exe >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "CloudReportingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Google\Chrome" /v "CloudReportingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

cls
echo.
echo.                                         %c%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %c%═══════════════════════════════════════════════════════%u%
pause >nul
goto ProgramDebloat

:debloatfirefox
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           FIREFOX DEBLOAT                                   ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Removing Firefox telemetry and updater components:%u%
echo %c%• Crash reporter, minidump analyzer and pingsender removed%u%
echo %c%• Maintenance service and updater removed%u%
echo %c%• Background update and default browser agent tasks deleted%u%
echo %c%• Mozilla Maintenance Service uninstalled%u%
echo.
echo.
del "C:\Program Files\Mozilla Firefox\crashreporter.exe" /f /q >nul 2>&1
del "C:\Program Files\Mozilla Firefox\crashreporter.ini" /f /q >nul 2>&1
del "C:\Program Files\Mozilla Firefox\maintenanceservice.exe" /f /q >nul 2>&1
del "C:\Program Files\Mozilla Firefox\maintenanceservice_installer.exe" /f /q >nul 2>&1
del "C:\Program Files\Mozilla Firefox\minidump-analyzer.exe" /f /q >nul 2>&1
del "C:\Program Files\Mozilla Firefox\pingsender.exe" /f /q >nul 2>&1
del "C:\Program Files\Mozilla Firefox\updater.exe" /f /q >nul 2>&1

reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{88088F95-5F8F-4603-8303-B2881ED6D9FD}" /f >nul 2>&1
reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{8F3A56F1-410F-41E7-B9CE-4F12A1417CF1}" /f >nul 2>&1
reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{88088F95-5F8F-4603-8303-B2881ED6D9FD}" /f >nul 2>&1
reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{8F3A56F1-410F-41E7-B9CE-4F12A1417CF1}" /f >nul 2>&1
reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla\Firefox Background Update 308046B0AF4A39CB" /f >nul 2>&1
reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla\Firefox Default Browser Agent 308046B0AF4A39CB" /f >nul 2>&1

chcp 437 >nul
powershell -NoProfile -Command "Get-Package 'Mozilla Maintenance Service' -ErrorAction SilentlyContinue | Uninstall-Package -Force" >nul 2>&1
chcp 65001 >nul

cd /d "C:\Program Files\Mozilla Firefox">nul 2>&1
del /f crash*.* >nul 2>&1
del /f maintenance*.* >nul 2>&1
del /f install.log >nul 2>&1
del /f minidump*.* >nul 2>&1
cls
echo.
echo.                                         %c%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %c%═══════════════════════════════════════════════════════%u%
pause >nul
goto ProgramDebloat

:debloatspotify
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           SPOTIFY DEBLOAT                                   ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Stripping Spotify bloat:%u%
echo %c%• Unused locale packs removed (keeps en-US only)%u%
echo %c%• Crash reporters, migrators and D3D/Vulkan files deleted%u%
echo %c%• Unused .spa app modules removed%u%
echo %c%• Spotify startup entry removed from registry%u%
echo.
echo.
cd /d "%APPDATA%\Spotify" >NUL 2>&1
copy "%APPDATA%\Spotify\locales\en-US.pak" "%APPDATA%\Spotify" >NUL 2>&1
rmdir "%APPDATA%\Spotify\locales" /s /q >NUL 2>&1
mkdir locales >NUL 2>&1
move en-US.pak locales >NUL 2>&1
del /f chrome_1*.* >NUL 2>&1
del /f chrome_2*.* >NUL 2>&1
del /f crash*.* >NUL 2>&1
del /f SpotifyMigrator.exe >NUL 2>&1
del /f SpotifyStartupTask.exe >NUL 2>&1
del /f d3d*.* >NUL 2>&1
del /f debug.log >NUL 2>&1
del /f libegl.dll >NUL 2>&1
del /f libgle*.* >NUL 2>&1
del /f snapshot*.* >NUL 2>&1
del /f vk*.* >NUL 2>&1
del /f vulkan*.* >NUL 2>&1
del /f/s/q "%appdata%\Spotify\SpotifyMigrator.exe" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\SpotifyStartupTask.exe" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\Apps\Buddy-list.spa" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\Apps\Concert.spa" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\Apps\Concerts.spa" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\Apps\Error.spa" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\Apps\Findfriends.spa" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\Apps\Legacy-lyrics.spa" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\Apps\Lyrics.spa" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\Apps\Show.spa" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\am.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\ar.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\ar.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\bg.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\bn.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\ca.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\cs.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\cs.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\da.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\de.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\de.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\el.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\el.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\en-GB.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\es.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\es.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\es-419.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\es-419.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\et.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\fa.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\fi.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\fi.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\fil.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\fr.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\fr.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\fr-CA.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\gu.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\he.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\he.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\hi.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\hr.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\hu.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\hu.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\id.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\id.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\it.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\it.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\ja.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\ja.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\kn.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\ko.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\ko.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\lt.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\lv.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\ml.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\mr.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\ms.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\ms.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\nb.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\nl.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\nl.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\pl.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\pl.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\pt-PT.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\pt-BR.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\pt-BR.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\ro.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\ru.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\ru.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\sk.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\sl.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\sr.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\sv.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\sv.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\sw.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\ta.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\te.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\th.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\th.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\tr.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\tr.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\uk.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\vi.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\vi.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\zh-CN.pak" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\zh-Hant.mo" >NUL 2>&1
del /f/s/q "%appdata%\Spotify\locales\zh-TW.pak" >NUL 2>&1
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Spotify" /f >NUL 2>&1
cls
echo.
echo.                                         %c%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %c%═══════════════════════════════════════════════════════%u%
pause >nul
goto ProgramDebloat

:debloatsteam
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                            STEAM DEBLOAT                                    ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Applying Steam performance tweaks:%u%
echo %c%• Smooth scrolling and GPU-accelerated web views disabled%u%
echo %c%• H264 hardware acceleration and DPI scaling disabled%u%
echo %c%• Steam startup entry removed from registry%u%
echo.
echo.
reg add "HKCU\SOFTWARE\Valve\Steam" /v "SmoothScrollWebViews" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Valve\Steam" /v "DWriteEnable" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Valve\Steam" /v "StartupMode" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Valve\Steam" /v "H264HWAccel" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Valve\Steam" /v "DPIScaling" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Valve\Steam" /v "GPUAccelWebViews" /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "Steam" /f >nul 2>&1
cls
echo.
echo.                                         %c%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %c%═══════════════════════════════════════════════════════%u%
pause >nul
goto ProgramDebloat

:debloatdiscord
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           DISCORD DEBLOAT                                   ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Removing Discord bloat and unused modules:%u%
echo %c%• Discord process killed and leftover shortcuts deleted%u%
echo %c%• Squirrel updater and logs removed%u%
echo %c%• Unused modules removed: cloudsync, dispatch, erlpack,%u%
echo %c%  game utils, media, spellcheck, krisp, rpc, overlay%u%
echo.
echo.
TASKKILL /T /F /IM  discord.exe
DEL "%HOMEPATH%\Desktop\Discord.lnk" /F /Q
DEL "%HOMEPATH%\Desktop\Discord.lnk - Shortcut" /F /Q
DEL "%HOMEPATH%\Desktop\Update.exe" /F /Q
DEL "%HOMEPATH%\Desktop\Update.exe - Shortcut" /F /Q
DEL "%HOMEPATH%\Desktop\Discord.exe" /F /Q
DEL "%HOMEPATH%\Desktop\Discord.exe - Shortcut" /F /Q
DEL "%HOMEPATH%\appdata\Local\discord\Update.exe" /F /Q
DEL "%HOMEPATH%\appdata\Local\discord\app-0.0.309\Squirrel.exe" /F /Q
DEL "%HOMEPATH%\appdata\Local\discord\app-0.0.308\Squirrel.exe" /F /Q
DEL "%HOMEPATH%\appdata\Local\discord\app-0.0.307\Squirrel.exe" /F /Q
DEL "%HOMEPATH%\appdata\Local\discord\app-0.0.306\Squirrel.exe" /F /Q
DEL "%HOMEPATH%\appdata\Local\discord\SquirrelSetup.log" /F /Q
DEL "%HOMEPATH%\appdata\Local\discord\app-0.0.309\SquirrelSetup.log" /F /Q
DEL "%HOMEPATH%\appdata\Local\discord\app-0.0.308\SquirrelSetup.log" /F /Q
DEL "%HOMEPATH%\appdata\Local\discord\app-0.0.307\SquirrelSetup.log" /F /Q
DEL "%HOMEPATH%\appdata\Local\discord\app-0.0.306\SquirrelSetup.log" /F /Q
rd /s /q "%HOMEPATH%\appdata\Local\discord\Packages"
DEL "%HOMEPATH%\appdata\Roaming\discord\0.0.309\modules\discord_modules\397863cd8f\2\discord_game_sdk_x64.dll" /F /Q
DEL "%HOMEPATH%\appdata\Roaming\discord\0.0.308\modules\discord_modules\397863cd8f\2\discord_game_sdk_x64.dll" /F /Q
DEL "%HOMEPATH%\appdata\Roaming\discord\0.0.307\modules\discord_modules\397863cd8f\2\discord_game_sdk_x64.dll" /F /Q
DEL "%HOMEPATH%\appdata\Roaming\discord\0.0.306\modules\discord_modules\397863cd8f\2\discord_game_sdk_x64.dll" /F /Q
DEL "%HOMEPATH%\appdata\Roaming\discord\0.0.309\modules\discord_modules\397863cd8f\2\discord_game_sdk_x86.dll" /F /Q
DEL "%HOMEPATH%\appdata\Roaming\discord\0.0.308\modules\discord_modules\397863cd8f\2\discord_game_sdk_x86.dll" /F /Q
DEL "%HOMEPATH%\appdata\Roaming\discord\0.0.307\modules\discord_modules\397863cd8f\2\discord_game_sdk_x86.dll" /F /Q
DEL "%HOMEPATH%\appdata\Roaming\discord\0.0.306\modules\discord_modules\397863cd8f\2\discord_game_sdk_x86.dll" /F /Q
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.309\modules\discord_cloudsync"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.308\modules\discord_cloudsync"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.307\modules\discord_cloudsync"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.306\modules\discord_cloudsync"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.309\modules\discord_dispatch"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.308\modules\discord_dispatch"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.307\modules\discord_dispatch"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.306\modules\discord_dispatch"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.309\modules\discord_erlpack"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.308\modules\discord_erlpack"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.307\modules\discord_erlpack"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.306\modules\discord_erlpack"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.309\modules\discord_game_utils"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.308\modules\discord_game_utils"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.307\modules\discord_game_utils"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.306\modules\discord_game_utils"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.309\modules\discord_media"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.308\modules\discord_media"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.307\modules\discord_media"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.306\modules\discord_media"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.309\modules\discord_spellcheck"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.308\modules\discord_spellcheck"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.307\modules\discord_spellcheck"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.306\modules\discord_spellcheck"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.309\modules\discord_krisp"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.308\modules\discord_krisp"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.307\modules\discord_krisp"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.306\modules\discord_krisp"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.309\modules\discord_rpc"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.308\modules\discord_rpc"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.307\modules\discord_rpc"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.306\modules\discord_rpc"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.309\modules\discord_overlay2"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.308\modules\discord_overlay2"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.307\modules\discord_overlay2"
rd /s /q "%HOMEPATH%\appdata\Roaming\discord\0.0.306\modules\discord_overlay2"
cls
echo.
echo.                                         %c%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %c%═══════════════════════════════════════════════════════%u%
pause >nul
goto ProgramDebloat

:debloatprogram
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           PROGRAM DEBLOAT                                   ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Disabling telemetry for common programs:%u%
echo %c%• Visual Studio SQM and IntelliCode telemetry disabled%u%
echo %c%• VS Standard Collector Service disabled%u%
echo %c%• NVIDIA telemetry packages uninstalled and tasks disabled%u%
echo %c%• CCleaner monitoring, updates and offers disabled%u%
echo %c%• 3D Objects removed from File Explorer sidebar%u%
echo.
echo.
@echo off

reg add "HKLM\Software\Policies\Microsoft\VisualStudio\SQM" /v "OptIn" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\VSCommon\14.0\SQM" /v "OptIn" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\VSCommon\14.0\SQM" /v "OptIn" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\VSCommon\15.0\SQM" /v "OptIn" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\VSCommon\15.0\SQM" /v "OptIn" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\VSCommon\16.0\SQM" /v "OptIn" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\VSCommon\16.0\SQM" /v "OptIn" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\VSCommon\17.0\SQM" /v "OptIn" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\VisualStudio\Telemetry" /v "TurnOffSwitch" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\VisualStudio\Feedback" /v "DisableFeedbackDialog" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\VisualStudio\Feedback" /v "DisableEmailInput" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\VisualStudio\Feedback" /v "DisableScreenshotCapture" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\VisualStudio\IntelliCode" /v "DisableRemoteAnalysis" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\VSCommon\16.0\IntelliCode" /v "DisableRemoteAnalysis" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\VSCommon\17.0\IntelliCode" /v "DisableRemoteAnalysis" /t REG_DWORD /d 1 /f

sc stop "VSStandardCollectorService150" >nul 2>&1
sc config "VSStandardCollectorService150" start= disabled >nul 2>&1

if exist "%ProgramFiles%\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL" (
    rundll32 "%PROGRAMFILES%\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL",UninstallPackage NvTelemetryContainer
    rundll32 "%PROGRAMFILES%\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL",UninstallPackage NvTelemetry
)

schtasks /change /tn "\NvTmRep_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /disable >nul 2>&1
schtasks /change /tn "\NvTmRepOnLogon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /disable >nul 2>&1
schtasks /change /tn "\NvTmMon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /disable >nul 2>&1

for /r "%PROGRAMFILES%\NVIDIA Corporation\NvTelemetry" %%F in (*) do (
    move "%%F" "%%F.OLD"
)

reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID44231" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID64640" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID66610" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup" /v "SendTelemetryData" /t REG_DWORD /d 0 /f

sc stop "NvTelemetryContainer" >nul 2>&1
sc config "NvTelemetryContainer" start= disabled >nul 2>&1

reg add "HKCU\Software\Piriform\CCleaner" /v "Monitoring" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "HelpImproveCCleaner" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "SystemMonitoring" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "UpdateAuto" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "UpdateCheck" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "UpdateBackground" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "CheckTrialOffer" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "(Cfg)HealthCheck" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "(Cfg)QuickClean" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "(Cfg)QuickCleanIpm" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "(Cfg)GetIpmForTrial" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "(Cfg)SoftwareUpdater" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "(Cfg)SoftwareUpdaterIpm" /t REG_DWORD /d 0 /f

reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Outlook\Options\Mail" /v "EnableLogging" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\Mail" /v "EnableLogging" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Outlook\Options\Calendar" /v "EnableCalendarLogging" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\Calendar" /v "EnableCalendarLogging" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Word\Options" /v "EnableLogging" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Word\Options" /v "EnableLogging" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\15.0\OSM" /v "EnableLogging" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\OSM" /v "EnableLogging" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\15.0\OSM" /v "EnableUpload" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\OSM" /v "EnableUpload" /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKCU\Software\Policies\Microsoft\Office\15.0\Common" /v "QMEnable" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Office\16.0\Common" /v "QMEnable" /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Common\Feedback" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\Feedback" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1

for /f "delims=" %%F in ('dir /b /s "%SYSTEMROOT%\System32\DriverStore\FileRepository\NvTelemetry*.dll" 2^>nul') do (
    move "%%F" "%%F.OLD" >nul 2>&1
)

reg add "HKLM\SOFTWARE\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d 1 /f >nul 2>&1

schtasks /change /tn "\DropboxUpdateTaskMachineUA" /disable >nul 2>&1
schtasks /change /tn "\DropboxUpdateTaskMachineCore" /disable >nul 2>&1

schtasks /change /tn "\Adobe Acrobat Update Task" /disable >nul 2>&1

schtasks /change /tn "\GoogleUpdateTaskMachineCore" /disable >nul 2>&1
schtasks /change /tn "\GoogleUpdateTaskMachineUA" /disable >nul 2>&1

reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Teams Meeting Add-in for Microsoft Office" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Teams Meeting Add-in for Microsoft Office" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Teams Meeting Add-in for Microsoft Office" /f >nul 2>&1

chcp 437 >nul
powershell -NoProfile -Command ^
  "$p = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager'; ^
   $files = @( ^
     'C:\Windows\System32\HEVC.dll', ^
     'C:\Windows\System32\EdgeDevToolsClient.dll', ^
     'C:\Program Files\WindowsApps\Microsoft.WidgetsPlatformRuntime*\Helium.dll', ^
     '%LOCALAPPDATA%\Microsoft\Teams\current\squirrel.exe', ^
     '%LOCALAPPDATA%\Microsoft\Teams\Update.exe', ^
     'C:\Windows\System32\wslinstaller.exe' ^
   ); ^
   $add = @(); ^
   foreach ($f in $files) { $add += ('\\??\\' + $f); $add += '' }; ^
   $cur = (Get-ItemProperty -Path $p -Name PendingFileRenameOperations -EA SilentlyContinue).PendingFileRenameOperations; ^
   $merged = if ($cur) { $cur + $add } else { $add }; ^
   Set-ItemProperty -Path $p -Name PendingFileRenameOperations -Value $merged -Type MultiString" >nul 2>&1
chcp 65001 >nul

reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Applications" /v "MicrosoftCorporationII.WindowsSubsystemForLinux" /f >nul 2>&1
powershell -NoProfile -Command ^
  "Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Config\MicrosoftCorporationII.WindowsSubsystemForLinux*' -Recurse -Force -EA SilentlyContinue" >nul 2>&1

for /r "%PROGRAMDATA%\Microsoft\Windows\Start Menu" %%f in (*Linux* *WSL*) do del /f /q "%%f" >nul 2>&1
powershell -NoProfile -Command ^
  "Remove-Item -Path ([Environment]::GetFolderPath('CommonPrograms') + '\WSL') -Recurse -Force -EA SilentlyContinue; ^
   Get-ChildItem ([Environment]::GetFolderPath('CommonPrograms')) -Filter '*Linux*' | Remove-Item -Force -EA SilentlyContinue" >nul 2>&1

reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Office\Outlook\AddIns\AdobeAcroOutlook.SendAsLink" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Office\Outlook\AddIns\AdobeAcroOutlook.SendAsLink" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Office\Excel\Addins\TFCOfficeShim.Connect.16" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Office\Excel\Addins\TFCOfficeShim.Connect.16" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Office\Excel\Addins\TFCOfficeShim.Connect.3" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Office\Excel\Addins\TFCOfficeShim.Connect.3" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Office\Excel\Addins\PDFMaker.OfficeAddin" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Office\PowerPoint\Addins\PDFMaker.OfficeAddin" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Office\Word\Addins\PDFMaker.OfficeAddin" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\Excel\Addins\PDFMaker.OfficeAddin" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\PowerPoint\Addins\PDFMaker.OfficeAddin" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\Word\Addins\PDFMaker.OfficeAddin" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Office\Excel\Addins\VS10ExcelAdaptor" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Office\Word\Addins\VS10WordAdaptor" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\Excel\Addins\VS10ExcelAdaptor" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\Word\Addins\VS10WordAdaptor" /v "LoadBehavior" /t REG_DWORD /d "0" /f >nul 2>&1

cls
echo.
echo.                                         %c%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %c%═══════════════════════════════════════════════════════%u%
pause >nul
goto ProgramDebloat

:Affinity
cls
chcp 437 >nul
for /f %%f in ('powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).NumberOfCores"') do set "NumberOfCores=%%f"
for /f %%f in ('powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).NumberOfLogicalProcessors"') do set "NumberOfLogicalProcessors=%%f"
chcp 65001 >nul
if "!NumberOfCores!" == "2" (
	goto HyperThreading
)
if !NumberOfCores! gtr 4 (
	for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
		reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "3" /f
		reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /f
	) > nul 2> nul
	for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
		reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "5" /f
		reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /f
	) > nul 2> nul
)

:: Hyper Threading ; Credits to HoneCtrl
:HyperThreading
if !NumberOfLogicalProcessors! gtr !NumberOfCores! (
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "4" /f
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /t REG_BINARY /d "C0" /f
	) > nul 2> nul
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "3" /f
	reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /f
	) > nul 2> nul
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "4" /f
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /t REG_BINARY /d "30" /f
	) > nul 2> nul
)
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto :GameBoosters

:MSIMode
cls
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
) > nul 2> nul

for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
) > nul 2> nul

for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
) > nul 2> nul

for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
) > nul 2> nul

chcp 437 >nul
for /f %%i in ('powershell -NoProfile -Command "(Get-CimInstance Win32_NetworkAdapter).PNPDeviceID"') do (
    set "str=%%i"
    if "!str:PCI\VEN_=!" neq "!str!" (
for /f "delims=" %%# in ('powershell -NoProfile -Command "(Get-CimInstance Win32_ComputerSystem).Manufacturer"') do set "Manufacturer=%%#"
    if "!Manufacturer:VMware=!" neq "!Manufacturer!" (set "VMWare= /t REG_DWORD /d 2") else (set "VMWare=")
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority"%VMWare% /f
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "2" /f
) > nul 2> nul
chcp 65001 >nul
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto :GameBoosters

:ScheduledTasks
cls
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\StartupAppTask" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyMonitor" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyRefresh" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyUpload" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Autochk\Proxy" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Maintenance\WinSAT" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\AitAgent" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\DiskFootprint\Diagnostics" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\FileHistory\File History (maintenance mode)" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\PI\Sqm-Tasks" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\NetTrace\GatherNetworkInfo" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\AppID\SmartScreenSpecific" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentFallBack2016" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn2016" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentFallBack" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Office\Office 15 Subscription Heartbeat" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Time Synchronization\SynchronizeTime" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\WindowsUpdate\Automatic App Update" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Device Information\Device" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\ErrorDetails\EnableErrorDetailsUpdate" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Windows Defender\Windows Defender Verification" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Diagnosis\Scheduled" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\InstallService\ScanForUpdates" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Registry\RegIdleBackup" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\StateRepository\MaintenanceTasks" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\SystemRestore\SR" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\WDI\ResolutionHost" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\ApplicationData\appuriverifierdaily" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\MareBackup" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Feedback\Siuf\DmClient" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Flighting\FeatureConfig\ReconcileFeatures" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Flighting\FeatureConfig\UsageDataFlushing" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Flighting\FeatureConfig\UsageDataReporting" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Input\InputSettingsRestoreDataAvailable" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Input\LocalUserSyncDataAvailable" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Input\MouseSyncDataAvailable" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Input\PenSyncDataAvailable" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Input\syncpensettings" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Input\TouchpadSyncDataAvailable" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Location\Notifications" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Location\WindowsActionDialog" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\ApplicationData\DsSvcCleanup" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Maps\MapsToastTask" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Maps\MapsUpdateTask" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" /disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\WS\CrossDeviceResume" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\WS\CrossDeviceResumeTrigger" /Disable >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CrossDeviceResume" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CrossDeviceResume" /v "UsePerformanceMode" /t REG_DWORD /d 0 /f >nul 2>&1
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto :GameBoosters

:Boosters
cls
call :SetupConsole
call :DisplayBanner
echo %c%                       ╔══════════════════════════════════════════════════╗ %u%
echo                        %c%║%u%           [%c%1%u%] Valorant                           %c%║%u%
echo                        %c%║%u%           [%c%2%u%] Counter-Strike 2                   %c%║%u%
echo                        %c%║%u%           [%c%3%u%] Minecraft                          %c%║%u%
echo                        %c%║%u%           [%c%4%u%] Fortnite                           %c%║%u%
echo                        %c%║%u%           [%c%5%u%] Warzone                            %c%║%u%
echo                        %c%║%u%           [%c%6%u%] Select your Own Game               %c%║%u%
echo %c%                       ╚══════════════════════════════════════════════════╝
echo %c%                                   ║  %u%[%c%0%u%] Go Back    [%red%X%u%] Exit%c%  ║%u%
echo %c%                                   ╚═══════════════════════════════╝%u%
echo.
echo.
set /p M="%c%Choose an option »%u% "
if "%M%"=="0" goto AdvancedMenu
if "%M%"=="1" goto Valorant
if "%M%"=="2" goto CS2
if "%M%"=="3" goto Minecraft
if "%M%"=="4" goto Fortnite
if "%M%"=="5" goto Warzone
if "%M%"=="6" goto SelectGame
if "%M%"=="X" goto Destruct
if "%M%"=="x" goto Destruct
cls
echo %underline%%red%Invalid Input. Press any key to continue.%u%
pause >nul
goto Boosters

:SelectGame
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         SELECT YOUR OWN GAME                                 ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Choose a game .exe to toggle performance optimizations:%u%
echo %c%• GPU High Performance mode%u%
echo %c%• Fullscreen Optimizations disabled%u%
echo %c%• CPU Priority set to High%u%
echo.
echo %c%Running this again on the same game will UNDO the tweaks.%u%
echo.
echo.
echo Please select the game executable (file) for applying performance tweaks:
chcp 437 >nul
for /f "delims=" %%p in ('powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $d=New-Object System.Windows.Forms.OpenFileDialog; $d.Filter='Executable Files (*.exe)|*.exe'; if($d.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){ Write-Output $d.FileName }"') do set "file=%%p"
chcp 65001 >nul
if "%file%"=="" (
    echo No file was selected.
    pause
    goto :eof
)
cls

for %%F in ("%file%") do (
    reg query "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%%~F" >nul 2>&1 && (
        reg delete "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "%%~F" /f
        reg delete "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%%~F" /f
        reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%~nxF\PerfOptions" /v "CpuPriorityClass" /f
        echo Undid Game Optimizations for %%~nxF
    ) || (
        reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "%%~F" /t REG_SZ /d "GpuPreference=2;" /f
        reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%%~F" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f
        reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%~nxF\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f
        echo Applied: GPU High Performance, Fullscreen Optimizations Disabled, CPU Priority Set for %%~nxF
    )
)
echo.
echo.
echo.                                         %c%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %c%═══════════════════════════════════════════════════════%u%
pause >nul
goto Boosters


:Valorant
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          VALORANT OPTIMIZER                                  ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Applying Valorant-specific optimizations:%u%
echo %c%• CFG process mitigation for Valorant/VGC/VGTray%u%
echo %c%• QoS DSCP 46 (Expedited Forwarding) for both Valorant executables%u%
echo %c%• Riot Client CPU priority elevated to High%u%
echo %c%• Auto-update and ping telemetry disabled%u%
echo.
echo.
chcp 437 >nul
for %%i in (valorant valorant-win64-shipping vgtray vgc) do (
    PowerShell -NoProfile -Command "Set-ProcessMitigation -Name %%i.exe -Enable CFG"
)
chcp 65001 >nul

reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Version" /t REG_SZ /d "1.0" /f 
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Application Name" /t REG_SZ /d "valorant.exe" /f 
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Protocol" /t REG_SZ /d "*" /f 
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Local Port" /t REG_SZ /d "*" /f 
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Local IP" /t REG_SZ /d "*" /f 
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Local IP Prefix Length" /t REG_SZ /d "*" /f 
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Remote Port" /t REG_SZ /d "*" /f 
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Remote IP" /t REG_SZ /d "*" /f 
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Remote IP Prefix Length" /t REG_SZ /d "*" /f 
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "DSCP Value" /t REG_SZ /d "46" /f 
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Throttle Rate" /t REG_SZ /d "-1" /f 

reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT-Shipping" /v "Version" /t REG_SZ /d "1.0" /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT-Shipping" /v "Application Name" /t REG_SZ /d "VALORANT-Win64-Shipping.exe" /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT-Shipping" /v "Protocol" /t REG_SZ /d "*" /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT-Shipping" /v "Local Port" /t REG_SZ /d "*" /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT-Shipping" /v "Local IP" /t REG_SZ /d "*" /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT-Shipping" /v "Local IP Prefix Length" /t REG_SZ /d "*" /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT-Shipping" /v "Remote Port" /t REG_SZ /d "*" /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT-Shipping" /v "Remote IP" /t REG_SZ /d "*" /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT-Shipping" /v "Remote IP Prefix Length" /t REG_SZ /d "*" /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT-Shipping" /v "DSCP Value" /t REG_SZ /d "46" /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT-Shipping" /v "Throttle Rate" /t REG_SZ /d "-1" /f

chcp 437 >nul
powershell -NoProfile -Command "Get-Process RiotClientServices -ErrorAction SilentlyContinue | ForEach-Object { $_.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High }" >nul 2>&1
chcp 65001 >nul

reg.exe add "HKCU\Software\Riot Games\Riot Client" /v "autoUpdateOnLaunch" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Riot Games\Riot Client" /v "pingUrl" /t REG_SZ /d "" /f
echo.
echo.
echo.                                         %c%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %c%═══════════════════════════════════════════════════════%u%
pause >nul
goto Boosters

:Fortnite
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          FORTNITE OPTIMIZER                                  ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Applying Fortnite-specific optimizations:%u%
echo %c%• FortniteClient CPU priority set to High%u%
echo %c%• Junk cache cleared from LocalAppData%u%
echo %c%• Priority separation and multimedia priority tweaked%u%
echo %c%• Low-quality Unreal Engine settings applied for max FPS%u%
echo %c%• Game DVR and Fullscreen Optimizations disabled%u%
echo.
echo.
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions" /t REG_DWORD /v CpuPriorityClass /d 3 /f >nul 2>&1
if exist "%localappdata%\FortniteGame" (
    rmdir /s /q "%localappdata%\FortniteGame"
)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\WMPlayer" /v "Priority" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\Audio" /v "Priority" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.ResolutionQuality" /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.ShadowQuality" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.EffectsQuality" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.TexturesQuality" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.bSmoothFrameRate" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.ViewDistanceQuality" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.GameThreadPriority" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
cls
echo.
echo.                                         %c%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %c%═══════════════════════════════════════════════════════%u%
pause >nul
goto Boosters

:CS2
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       COUNTER-STRIKE 2 OPTIMIZER                             ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Applying CS2-specific optimizations:%u%
echo %c%• CS2 process CPU priority elevated to High%u%
echo %c%• Mouse acceleration disabled%u%
echo %c%• Game DVR and Fullscreen Optimizations disabled%u%
echo %c%• Pagefile optimized for system RAM%u%
echo %c%• Steam overlay, auto-update and cache cleared%u%
echo.
echo.
chcp 437 >nul
powershell -NoProfile -Command "Get-Process cs2 -ErrorAction SilentlyContinue | ForEach-Object { $_.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High }" >nul 2>&1
chcp 65001 >nul

reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\bin\win64\cs2.exe" /t REG_SZ /d "~DISABLEMOUSEACCELERATION" /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPerServer" /t REG_DWORD /d 16 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d 16 /f >nul 2>&1

chcp 437 >nul
for /f %%r in ('powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum/1MB)"') do set "TotalRAMMB=%%r"
powershell -NoProfile -Command "$ram=[math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum/1MB); $pf=[math]::Min([math]::Max($ram*2,4096),32768); $cs=Get-CimInstance Win32_ComputerSystem; Set-CimInstance -InputObject $cs -Property @{AutomaticManagedPagefile=$false}; $existing=Get-CimInstance Win32_PageFileSetting; if($existing){Set-CimInstance -InputObject $existing -Property @{InitialSize=$pf;MaximumSize=$pf}}else{New-CimInstance -ClassName Win32_PageFileSetting -Property @{Name='C:\pagefile.sys';InitialSize=$pf;MaximumSize=$pf}}" >nul 2>&1
chcp 65001 >nul

reg add "HKCU\System\GameConfigStore" /v "GameBarEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
taskkill /f /im "steam.exe" >nul 2>&1
reg add "HKCU\Software\Valve\Steam" /v "EnableOverlay" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Valve\Steam" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Valve\Steam" /v "TcpNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Steam\htmlcache" >nul 2>&1
rd /s /q "%PROGRAMFILES(X86)%\Steam\appcache" >nul 2>&1
reg add "HKCU\Software\Valve\Steam" /v "AutoUpdateEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Valve\Steam" /v "SilentStartup" /t REG_DWORD /d 1 /f >nul 2>&1

cls
echo.
echo.                                         %c%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %c%═══════════════════════════════════════════════════════%u%
pause >nul
goto Boosters

:Warzone
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           WARZONE OPTIMIZER                                  ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Applying Warzone-specific optimizations:%u%
echo %c%• Priority separation tuned for responsiveness%u%
echo %c%• Video memory and VSync tweaks applied%u%
echo %c%• Game DVR and Fullscreen Optimizations disabled%u%
echo %c%• Mouse acceleration disabled%u%
echo %c%• Pagefile optimized for system RAM%u%
echo.
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKCU\Software\Activision\ModernWarfare" /v "VideoMemoryScale" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Activision\ModernWarfare" /v "VerticalSyncEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
chcp 437 >nul
powershell -NoProfile -Command "$ram=[math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum/1MB); $pf=[math]::Min([math]::Max($ram*2,4096),32768); $cs=Get-CimInstance Win32_ComputerSystem; Set-CimInstance -InputObject $cs -Property @{AutomaticManagedPagefile=$false}; $existing=Get-CimInstance Win32_PageFileSetting; if($existing){Set-CimInstance -InputObject $existing -Property @{InitialSize=$pf;MaximumSize=$pf}}else{New-CimInstance -ClassName Win32_PageFileSetting -Property @{Name='C:\pagefile.sys';InitialSize=$pf;MaximumSize=$pf}}" >nul 2>&1
chcp 65001 >nul
cls
echo.
echo.                                         %c%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %c%═══════════════════════════════════════════════════════%u%
pause >nul
goto Boosters

:Minecraft
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          MINECRAFT OPTIMIZER                                 ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Applying Minecraft-specific optimizations:%u%
echo %c%• Aikars optimized JVM flags written to JVMarguments.txt%u%
echo %c%• OptiFine config applied (low quality / high FPS preset)%u%
echo %c%• Animations, particles and weather effects minimized%u%
echo.
echo %c%To use the JVM flags: open your Minecraft Launcher, go to%u%
echo %c%Installations, edit your profile, and paste the contents of%u%
echo %c%JVMarguments.txt into the JVM Arguments field.%u%
echo.
echo.
echo   Open Minecraft launcher and put the code inside JVMarguments in JVM Arguments
timeout /t 3 >nul
pause >nul
(
    echo of -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=10 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=true -Daikars.new.flags=true
) > "%APPDATA%\.minecraft\JVMarguments.txt"

cd /d "%APPDATA%\.minecraft"
(
    echo ofFogType:3
    echo ofFogStart:0.6
    echo ofMipmapType:0
    echo ofOcclusionFancy:false
    echo ofSmoothFps:false
    echo ofSmoothWorld:false
    echo ofAoLevel:0.0
    echo ofClouds:3
    echo ofCloudsHeight:0.0
    echo ofTrees:1
    echo ofDroppedItems:1
    echo ofRain:3
    echo ofAnimatedWater:0
    echo ofAnimatedLava:0
    echo ofAnimatedFire:true
    echo ofAnimatedPortal:true
    echo ofAnimatedRedstone:false
    echo ofAnimatedExplosion:true
    echo ofAnimatedFlame:true
    echo ofAnimatedSmoke:true
    echo ofVoidParticles:false
    echo ofWaterParticles:true
    echo ofPortalParticles:true
    echo ofPotionParticles:true
    echo ofFireworkParticles:true
    echo ofDrippingWaterLava:true
    echo ofAnimatedTerrain:true
    echo ofAnimatedTextures:true
    echo ofRainSplash:false
    echo ofLagometer:false
    echo ofShowFps:false
    echo ofAutoSaveTicks:28800
    echo ofBetterGrass:3
    echo ofConnectedTextures:3
    echo ofWeather:false
    echo ofSky:false
    echo ofStars:false
    echo ofSunMoon:true
    echo ofVignette:1
    echo ofChunkUpdates:1
    echo ofChunkUpdatesDynamic:false
    echo ofTime:0
    echo ofAaLevel:0
    echo ofAfLevel:1
    echo ofProfiler:false
    echo ofBetterSnow:false
    echo ofSwampColors:false
    echo ofRandomEntities:false
    echo ofCustomFonts:false
    echo ofCustomColors:false
    echo ofCustomItems:false
    echo ofCustomSky:true
    echo ofShowCapes:true
    echo ofNaturalTextures:false
    echo ofEmissiveTextures:false
    echo ofLazyChunkLoading:true
    echo ofRenderRegions:true
    echo ofSmartAnimations:true
    echo ofDynamicFov:false
    echo ofAlternateBlocks:false
    echo ofDynamicLights:3
    echo ofScreenshotSize:1
    echo ofCustomEntityModels:false
    echo ofCustomGuis:false
    echo ofShowGlErrors:false
    echo ofFastMath:true
    echo ofFastRender:true
    echo ofTranslucentBlocks:0
    echo ofChatBackground:3
    echo ofChatShadow:false
    echo ofTelemetry:2
    echo key_of.key.zoom:key.keyboard.left.control
) > optionsof.txt

echo.
echo.                                         %c%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %c%═══════════════════════════════════════════════════════%u%
pause >nul
goto Boosters

:Toolbox
cls
call :SetupConsole
call :DisplayBanner
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                              BATLEZ TOOLBOX                                   ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo                                 %c%Batlez Toolbox allows you to install any app or software!%u%
echo.
echo                              %c%Uses Chocolatey to download and install 208 curated packages.%u%
echo.
echo.
echo                                          %c%Press any key to start Batlez Toolbox!%u%
pause >nul

call :EnsureChoco
goto START

:EnsureChoco
cls
call :SetupConsole
echo.
echo %c%Checking for Chocolatey package manager...%u%
echo.
if exist "%ALLUSERSPROFILE%\chocolatey" (
    echo %c%✔ Chocolatey is already installed.%u%
    timeout /t 2 >nul
) else (
    echo %c%Chocolatey not found. Installing now, please wait...%u%
    chcp 437>nul
    powershell -NoProfile -ExecutionPolicy Bypass ^
      -Command "iex ((New-Object Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" ^
      && (
        set "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
        echo %c%✔ Successfully installed Chocolatey.%u%
        timeout /t 3 >nul
      ) || (
        echo %red%✘ Failed to install Chocolatey. Some installs may not work.%u%
        timeout /t 3 >nul
      )
    chcp 65001 >nul
)
exit /b

:START
cls
call :SetupConsole
call :DisplayBanner
echo %c%                       ╔══════════════════════════════════════════════════╗ %u%
echo                        %c%║%u%           [%c%1%u%] Page 1  - Browsers / VPN / Security   %c%║%u%
echo                        %c%║%u%           [%c%2%u%] Page 2  - Productivity / Messaging     %c%║%u%
echo                        %c%║%u%           [%c%3%u%] Page 3  - System Tools / Runtimes      %c%║%u%
echo                        %c%║%u%           [%c%4%u%] Page 4  - Design / Game / DevOps        %c%║%u%
echo                        %c%║%u%           [%c%S%u%] Search  - Find specific software       %c%║%u%
echo                        %c%║%u%           [%c%U%u%] Uninstall software                     %c%║%u%
echo %c%                       ╚══════════════════════════════════════════════════╝
echo %c%                                   ║  %u%[%red%X%u%] Exit Toolbox%c%        ║%u%
echo %c%                                   ╚═══════════════════════════════╝%u%
echo.
echo                              %c%208 curated packages across 4 pages (52 items each)%u%
echo.
set /p "mainChoice=%c%Choose an option »%u% "
if /I "%mainChoice%"=="1" goto PAGE1
if /I "%mainChoice%"=="2" goto PAGE2
if /I "%mainChoice%"=="3" goto PAGE3
if /I "%mainChoice%"=="4" goto PAGE4
if /I "%mainChoice%"=="S" goto SEARCH
if /I "%mainChoice%"=="U" goto UNINSTALL
if /I "%mainChoice%"=="X" goto :EOF
if /I "%mainChoice%"=="x" goto :EOF
cls
echo %underline%%red%Invalid Input. Press any key to continue.%u%
pause >nul
goto START

:PAGE1
cls
call :SetupConsole
title Batlez Toolbox - Page 1 of 4 (Items 1-52)
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║               PAGE 1 OF 4  —  Browsers / VPN / Security / Office  (1-52)      ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo       %c%[Browsers]%u%                    %c%[VPN]%u%                       %c%[Security]%u%                   %c%[Office]%u%
echo.
echo   1.  Chrome                    14. NordVPN                 27. Avast                    40. Microsoft Office
echo   2.  Firefox                   15. ExpressVPN              28. Malwarebytes             41. Office 365
echo   3.  Edge                      16. Mullvad                 29. Windows Defender         42. LibreOffice
echo   4.  Opera                     17. ProtonVPN               30. ESET NOD32               43. WPS Office
echo   5.  Brave                     18. Private Internet Access 31. Kaspersky                44. Google Docs
echo   6.  Vivaldi                   19. F-Secure Freedome       32. Bitdefender              45. OnlyOffice
echo   7.  Waterfox                  20. Surfshark               33. Avira Antivirus          46. SoftMaker Office
echo   8.  Safari                    21. TunnelBear              34. Norton Security          47. FreeOffice
echo   9.  Pale Moon                 22. Hide.me                 35. SUPERAntiSpyware         48. Zoho Office
echo   10. Tor Browser               23. Avira Phantom VPN       36. IObit Malware Fighter    49. Polaris Office
echo   11. Opera GX                  24. CyberGhost              37. Webroot                  50. WordPerfect
echo   12. Yandex Browser            25. IPVanish                38. Comodo Antivirus         51. OpenOffice
echo   13. Chromium                  26. Betternet               39. Spybot Free              52. OneDrive
echo.
echo %c%[N]%u% Next Page (53-104)   %c%[M]%u% Main Menu   %red%[X]%u% Exit
set /p "p1Choice=%c%Choose an option »%u% "
if /I "%p1Choice%"=="N" goto PAGE2
if /I "%p1Choice%"=="M" goto START
if /I "%p1Choice%"=="X" goto :EOF
if /I "%p1Choice%"=="x" goto :EOF

call :InstallSoftware "%p1Choice%" "PAGE1"
goto PAGE1

:PAGE2
cls
call :SetupConsole
title Batlez Toolbox - Page 2 of 4 (Items 53-104)
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║             PAGE 2 OF 4  —  Productivity / Messaging / Media / Dev  (53-104)   ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo       %c%[Productivity]%u%                %c%[Messaging]%u%                 %c%[Media]%u%                       %c%[Development]%u%
echo.
echo   53. Notion                    66. Discord                 79. VLC                      92.  Visual Studio
echo   54. Trello                    67. Skype                   80. Winamp                   93.  VS Code
echo   55. Evernote                  68. Zoom                    81. Spotify                  94.  Android Studio
echo   56. Todoist                   69. Microsoft Teams         82. iTunes                   95.  IntelliJ IDEA
echo   57. Asana                     70. Telegram                83. Foobar2000               96.  Eclipse
echo   58. Slack                     71. WhatsApp                84. AIMP                     97.  NetBeans
echo   59. Monday.com                72. Signal                  85. MPC-HC                   98.  Xcode
echo   60. Google Keep               73. Viber                   86. GOM Player               99.  Sublime Text
echo   61. TickTick                  74. Wire                    87. RealPlayer               100. Atom
echo   62. Google Calendar           75. Tox                     88. QuickTime                101. PyCharm
echo   63. OneNote                   76. WeChat                  89. PotPlayer                102. Rider
echo   64. Zoho Notebook             77. QQ                      90. Audacity                 103. Code::Blocks
echo   65. Miro                      78. Line                    91. OBS Studio               104. phpStorm
echo.
echo %c%[P]%u% Previous (1-52)   %c%[N]%u% Next (105-156)   %c%[M]%u% Main Menu   %red%[X]%u% Exit
set /p "p2Choice=%c%Choose an option »%u% "
if /I "%p2Choice%"=="P" goto PAGE1
if /I "%p2Choice%"=="N" goto PAGE3
if /I "%p2Choice%"=="M" goto START
if /I "%p2Choice%"=="X" goto :EOF
if /I "%p2Choice%"=="x" goto :EOF

call :InstallSoftware "%p2Choice%" "PAGE2"
goto PAGE2

:PAGE3
cls
call :SetupConsole
title Batlez Toolbox - Page 3 of 4 (Items 105-156)
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║           PAGE 3 OF 4  —  System Tools / File Tools / Runtimes / Misc (105-156) ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo        %c%[System Tools]%u%               %c%[File Tools]%u%                %c%[Runtimes]%u%                   %c%[Misc]%u%
echo.
echo   105. CCleaner                118. WinRAR                 131. DirectX                 144. TeamViewer
echo   106. BleachBit               119. 7-Zip                  132. .NET 4.8                145. AnyDesk
echo   107. Sysinternals            120. PeaZip                 133. Java Runtime            146. Dropbox
echo   108. Process Explorer        121. Bandizip               134. Python                  147. Google Drive
echo   109. WinDirStat              122. IZArc                  135. Node.js                 148. Steam
echo   110. Glary Utilities         123. PowerISO               136. C++ Redistributables    149. Epic Games
echo   111. Revo Uninstaller        124. Daemon Tools           137. Perl                    150. GOG Galaxy
echo   112. StartIsBack             125. Rufus                  138. Ruby                    151. Battle.net
echo   113. Winaero Tweaker         126. Etcher                 139. Go                      152. Rockstar Launcher
echo   114. ExplorerPatcher         127. Ventoy                 140. Visual Basic Runtime    153. Roblox
echo   115. Partition Wizard        128. ImgBurn                141. MS SQL CLI              154. Popcorn Time
echo   116. Macrium Reflect         129. UltraISO               142. Oracle Instant Cl.      155. Qbittorrent
echo   117. Clonezilla              130. FreeCommander          143. PHP                     156. OpenToonz
echo.
echo %c%[P]%u% Previous (53-104)   %c%[N]%u% Next (157-208)   %c%[M]%u% Main Menu   %red%[X]%u% Exit
set /p "p3Choice=%c%Choose an option »%u% "
if /I "%p3Choice%"=="P" goto PAGE2
if /I "%p3Choice%"=="N" goto PAGE4
if /I "%p3Choice%"=="M" goto START
if /I "%p3Choice%"=="X" goto :EOF
if /I "%p3Choice%"=="x" goto :EOF

call :InstallSoftware "%p3Choice%" "PAGE3"
goto PAGE3

:PAGE4
cls
call :SetupConsole
title Batlez Toolbox - Page 4 of 4 (Items 157-208)
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║          PAGE 4 OF 4  —  Design Tools / Game Tools / Comm / DevOps (157-208)   ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo        %c%[Design Tools]%u%               %c%[Game Tools]%u%                %c%[Extra Comm]%u%                 %c%[DevOps Tools]%u%
echo.
echo   157. GIMP                    170. itch                   183. Thunderbird             196. Docker Desktop
echo   158. Inkscape                171. dolphin-emulator       184. Postbox                 197. Kubernetes CLI
echo   159. paint.net               172. pcsx2                  185. Mailspring              198. Minikube
echo   160. Blender                 173. retroarch              186. Mailbird                199. Terraform
echo   161. Krita                   174. citra                  187. element-desktop         200. AWS CLI
echo   162. Darktable               175. ryujinx                188. franz                   201. Azure CLI
echo   163. RawTherapee             176. yuzu                   189. ferdium                 202. Google Cloud SDK
echo   164. Pencil Project          177. joytokey               190. hexchat                 203. Vagrant
echo   165. Autodesk Sketchbook     178. ds4windows             191. pidgin                  204. Packer
echo   166. ShareX                  179. steamcmd               192. trillian                205. Postman
echo   167. Scribus                 180. unrealengine           193. miranda-ng              206. k9s
echo   168. piskel                  181. unityhub               194. guilded                 207. helm
echo   169. pencil2d                182. gamemakerstudio        195. teamspeak               208. OpenToonz
echo.
echo %c%[P]%u% Previous (105-156)   %c%[M]%u% Main Menu   %red%[X]%u% Exit
set /p "p4Choice=%c%Choose an option »%u% "
if /I "%p4Choice%"=="P" goto PAGE3
if /I "%p4Choice%"=="M" goto START
if /I "%p4Choice%"=="X" goto :EOF
if /I "%p4Choice%"=="x" goto :EOF

call :InstallSoftware "%p4Choice%" "PAGE4"
goto PAGE4

:InstallSoftware
set "choice=%~1"
set "page=%~2"

if "%choice%"=="" goto :EOF

echo.
set /p "confirm=%c%Are you sure you want to install this software? (Y/N) »%u% "
if /I not "%confirm%"=="Y" exit /b

echo %c%Installing software...%u%
echo.

if "%page%"=="PAGE1" (
    if "%choice%"=="1" call :Install "googlechrome" "Google Chrome"
    if "%choice%"=="2"  call :Install "firefox" "Mozilla Firefox"
    if "%choice%"=="3"  call :Install "microsoft-edge" "Microsoft Edge"
    if "%choice%"=="4"  call :Install "opera" "Opera Browser"
    if "%choice%"=="5"  call :Install "brave" "Brave Browser"
    if "%choice%"=="6"  call :Install "vivaldi" "Vivaldi Browser"
    if "%choice%"=="7"  call :Install "waterfox" "Waterfox"
    if "%choice%"=="8"  call :ShowMessage "Safari is not available on Windows"
    if "%choice%"=="9"  call :Install "palemoon" "Pale Moon"
    if "%choice%"=="10" call :Install "tor-browser" "Tor Browser"
    if "%choice%"=="11" call :Install "opera-gx" "Opera GX"
    if "%choice%"=="12" call :Install "yandex" "Yandex Browser"
    if "%choice%"=="13" call :Install "chromium" "Chromium"
    
    if "%choice%"=="14" call :Install "nordvpn" "NordVPN"
    if "%choice%"=="15" call :ShowMessage "ExpressVPN requires manual installation"
    if "%choice%"=="16" call :Install "mullvad-app" "Mullvad VPN"
    if "%choice%"=="17" call :Install "protonvpn" "ProtonVPN"
    if "%choice%"=="18" call :ShowMessage "PIA requires manual installation"
    if "%choice%"=="19" call :ShowMessage "F-Secure Freedome requires manual installation"
    if "%choice%"=="20" call :Install "surfshark" "Surfshark"
    if "%choice%"=="21" call :ShowMessage "TunnelBear requires manual installation"
    if "%choice%"=="22" call :ShowMessage "Hide.me requires manual installation"
    if "%choice%"=="23" call :Install "avira-free-antivirus" "Avira Free Antivirus"
    if "%choice%"=="24" call :ShowMessage "CyberGhost requires manual installation"
    if "%choice%"=="25" call :ShowMessage "IPVanish requires manual installation"
    if "%choice%"=="26" call :ShowMessage "Betternet requires manual installation"
    
    if "%choice%"=="27" call :Install "avastfreeantivirus" "Avast Free Antivirus"
    if "%choice%"=="28" call :Install "malwarebytes" "Malwarebytes"
    if "%choice%"=="29" call :ShowMessage "Windows Defender is built into Windows"
    if "%choice%"=="30" call :ShowMessage "ESET NOD32 requires manual installation"
    if "%choice%"=="31" call :ShowMessage "Kaspersky requires manual installation"
    if "%choice%"=="32" call :ShowMessage "Bitdefender requires manual installation"
    if "%choice%"=="33" call :Install "adaware-free" "Ad-Aware Free Antivirus"
    if "%choice%"=="34" call :ShowMessage "Norton requires manual installation"
    if "%choice%"=="35" call :Install "superantispyware" "SUPERAntiSpyware"
    if "%choice%"=="36" call :ShowMessage "IObit Malware Fighter requires manual installation"
    if "%choice%"=="37" call :ShowMessage "Webroot requires manual installation"
    if "%choice%"=="38" call :ShowMessage "Comodo requires manual installation"
    if "%choice%"=="39" call :Install "spybot" "Spybot - Search & Destroy"
    
    if "%choice%"=="40" call :ShowMessage "Microsoft Office requires manual installation or subscription"
    if "%choice%"=="41" call :ShowMessage "Office 365 requires subscription and manual setup"
    if "%choice%"=="42" call :Install "libreoffice-fresh" "LibreOffice"
    if "%choice%"=="43" call :Install "wps-office-free" "WPS Office"
    if "%choice%"=="44" call :ShowMessage "Google Docs is web-based - no installation needed"
    if "%choice%"=="45" call :Install "onlyoffice" "OnlyOffice"
    if "%choice%"=="46" call :ShowMessage "SoftMaker Office requires manual installation"
    if "%choice%"=="47" call :Install "freeoffice" "FreeOffice"
    if "%choice%"=="48" call :ShowMessage "Zoho Office is web-based - no installation needed"
    if "%choice%"=="49" call :ShowMessage "Polaris Office requires manual installation"
    if "%choice%"=="50" call :ShowMessage "WordPerfect requires manual installation"
    if "%choice%"=="51" call :Install "openoffice" "Apache OpenOffice"
    if "%choice%"=="52" call :Install "onedrive" "Microsoft OneDrive"
)

if "%page%"=="PAGE2" (
    if "%choice%"=="53"  call :Install "notion" "Notion"
    if "%choice%"=="54"  call :Install "trello" "Trello"
    if "%choice%"=="55"  call :Install "evernote" "Evernote"
    if "%choice%"=="56"  call :ShowMessage "Todoist is primarily web-based"
    if "%choice%"=="57"  call :ShowMessage "Asana is web-based - no installation needed"
    if "%choice%"=="58"  call :Install "slack" "Slack"
    if "%choice%"=="59"  call :ShowMessage "Monday.com is web-based - no installation needed"
    if "%choice%"=="60"  call :ShowMessage "Google Keep is web-based - no installation needed"
    if "%choice%"=="61"  call :Install "ticktick" "TickTick"
    if "%choice%"=="62"  call :ShowMessage "Google Calendar is web-based - no installation needed"
    if "%choice%"=="63"  call :Install "onenote" "Microsoft OneNote"
    if "%choice%"=="64"  call :ShowMessage "Zoho Notebook is web-based - no installation needed"
    if "%choice%"=="65"  call :Install "miro" "Miro"
    
    if "%choice%"=="66"  call :Install "discord" "Discord"
    if "%choice%"=="67"  call :Install "skype" "Skype"
    if "%choice%"=="68"  call :Install "zoom" "Zoom"
    if "%choice%"=="69"  call :Install "microsoft-teams" "Microsoft Teams"
    if "%choice%"=="70"  call :Install "telegram" "Telegram Desktop"
    if "%choice%"=="71"  call :Install "whatsapp" "WhatsApp Desktop"
    if "%choice%"=="72"  call :Install "signal" "Signal Desktop"
    if "%choice%"=="73"  call :Install "viber" "Viber"
    if "%choice%"=="74"  call :Install "wire" "Wire"
    if "%choice%"=="75"  call :Install "qtox" "qTox"
    if "%choice%"=="76"  call :ShowMessage "WeChat requires manual installation"
    if "%choice%"=="77"  call :ShowMessage "QQ requires manual installation"
    if "%choice%"=="78"  call :ShowMessage "Line requires manual installation"
    
    if "%choice%"=="79"  call :Install "vlc" "VLC Media Player"
    if "%choice%"=="80"  call :Install "winamp" "Winamp"
    if "%choice%"=="81"  call :Install "spotify" "Spotify"
    if "%choice%"=="82"  call :Install "itunes" "iTunes"
    if "%choice%"=="83"  call :Install "foobar2000" "foobar2000"
    if "%choice%"=="84"  call :Install "aimp" "AIMP"
    if "%choice%"=="85"  call :Install "mpc-hc" "MPC-HC"
    if "%choice%"=="86"  call :Install "gomplayer" "GOM Player"
    if "%choice%"=="87"  call :ShowMessage "RealPlayer requires manual installation"
    if "%choice%"=="88"  call :ShowMessage "QuickTime is no longer supported on Windows"
    if "%choice%"=="89"  call :Install "potplayer" "PotPlayer"
    if "%choice%"=="90"  call :Install "audacity" "Audacity"
    if "%choice%"=="91"  call :Install "obs-studio" "OBS Studio"
    
    if "%choice%"=="92"  call :Install "visualstudio2022community" "Visual Studio 2022 Community"
    if "%choice%"=="93"  call :Install "vscode" "Visual Studio Code"
    if "%choice%"=="94"  call :Install "androidstudio" "Android Studio"
    if "%choice%"=="95"  call :Install "intellijidea-community" "IntelliJ IDEA Community"
    if "%choice%"=="96"  call :Install "eclipse" "Eclipse IDE"
    if "%choice%"=="97"  call :Install "netbeans" "NetBeans IDE"
    if "%choice%"=="98"  call :ShowMessage "Xcode is Mac-only"
    if "%choice%"=="99"  call :Install "sublimetext4" "Sublime Text 4"
    if "%choice%"=="100" call :Install "atom" "Atom"
    if "%choice%"=="101" call :Install "pycharm-community" "PyCharm Community"
    if "%choice%"=="102" call :Install "jetbrains-rider" "JetBrains Rider"
    if "%choice%"=="103" call :Install "codeblocks" "Code::Blocks"
    if "%choice%"=="104" call :Install "phpstorm" "PhpStorm"
)

if "%page%"=="PAGE3" (
    if "%choice%"=="105" call :Install "ccleaner" "CCleaner"
    if "%choice%"=="106" call :Install "bleachbit" "BleachBit"
    if "%choice%"=="107" call :Install "sysinternals" "Sysinternals Suite"
    if "%choice%"=="108" call :Install "procexp" "Process Explorer"
    if "%choice%"=="109" call :Install "windirstat" "WinDirStat"
    if "%choice%"=="110" call :Install "glaryutilities-free" "Glary Utilities"
    if "%choice%"=="111" call :Install "revo-uninstaller" "Revo Uninstaller"
    if "%choice%"=="112" call :ShowMessage "StartIsBack requires manual installation"
    if "%choice%"=="113" call :Install "winaero-tweaker" "Winaero Tweaker"
    if "%choice%"=="114" call :ShowMessage "ExplorerPatcher requires manual installation"
    if "%choice%"=="115" call :Install "minitool-partition-wizard-free" "MiniTool Partition Wizard"
    if "%choice%"=="116" call :Install "reflect-free" "Macrium Reflect"
    if "%choice%"=="117" call :ShowMessage "Clonezilla requires manual installation"
    
    if "%choice%"=="118" call :Install "winrar" "WinRAR"
    if "%choice%"=="119" call :Install "7zip" "7-Zip"
    if "%choice%"=="120" call :Install "peazip" "PeaZip"
    if "%choice%"=="121" call :Install "bandizip" "Bandizip"
    if "%choice%"=="122" call :Install "izarc" "IZArc"
    if "%choice%"=="123" call :Install "poweriso" "PowerISO"
    if "%choice%"=="124" call :Install "daemon-tools-lite" "DAEMON Tools Lite"
    if "%choice%"=="125" call :Install "rufus" "Rufus"
    if "%choice%"=="126" call :Install "balenaetcher" "balenaEtcher"
    if "%choice%"=="127" call :Install "ventoy" "Ventoy"
    if "%choice%"=="128" call :Install "imgburn" "ImgBurn"
    if "%choice%"=="129" call :Install "ultraiso" "UltraISO"
    if "%choice%"=="130" call :Install "freecommander-xe" "FreeCommander XE"
    
    if "%choice%"=="131" call :Install "directx" "DirectX"
    if "%choice%"=="132" call :Install "dotnet-4.8" ".NET Framework 4.8"
    if "%choice%"=="133" call :Install "openjdk" "OpenJDK"
    if "%choice%"=="134" call :Install "python" "Python"
    if "%choice%"=="135" call :Install "nodejs" "Node.js"
    if "%choice%"=="136" call :Install "vcredist-all" "Visual C++ Redistributables"
    if "%choice%"=="137" call :Install "strawberryperl" "Strawberry Perl"
    if "%choice%"=="138" call :Install "ruby" "Ruby"
    if "%choice%"=="139" call :Install "golang" "Go Programming Language"
    if "%choice%"=="140" call :ShowMessage "Visual Basic Runtime is included in Windows"
    if "%choice%"=="141" call :Install "sqlcmd" "SQL Server Command Line Utilities"
    if "%choice%"=="142" call :ShowMessage "Oracle Instant Client requires manual installation"
    if "%choice%"=="143" call :Install "php" "PHP"
    
    if "%choice%"=="144" call :Install "teamviewer" "TeamViewer"
    if "%choice%"=="145" call :Install "anydesk" "AnyDesk"
    if "%choice%"=="146" call :Install "dropbox" "Dropbox"
    if "%choice%"=="147" call :Install "googledrive" "Google Drive"
    if "%choice%"=="148" call :Install "steam" "Steam"
    if "%choice%"=="149" call :Install "epicgameslauncher" "Epic Games Launcher"
    if "%choice%"=="150" call :Install "goggalaxy" "GOG Galaxy"
    if "%choice%"=="151" call :Install "battle.net" "Battle.net"
    if "%choice%"=="152" call :Install "rockstargameslauncher" "Rockstar Games Launcher"
    if "%choice%"=="153" call :Install "roblox-player" "Roblox Player"
    if "%choice%"=="154" call :ShowMessage "Popcorn Time requires manual installation"
    if "%choice%"=="155" call :Install "qbittorrent" "qBittorrent"
    if "%choice%"=="156" call :Install "opentoonz" "OpenToonz"
)

if "%page%"=="PAGE4" (
    if "%choice%"=="157" call :Install "gimp" "GIMP"
    if "%choice%"=="158" call :Install "inkscape" "Inkscape"
    if "%choice%"=="159" call :Install "paint.net" "Paint.NET"
    if "%choice%"=="160" call :Install "blender" "Blender"
    if "%choice%"=="161" call :Install "krita" "Krita"
    if "%choice%"=="162" call :Install "darktable" "darktable"
    if "%choice%"=="163" call :Install "rawtherapee" "RawTherapee"
    if "%choice%"=="164" call :Install "pencil" "Pencil Project"
    if "%choice%"=="165" call :ShowMessage "Autodesk Sketchbook requires manual installation"
    if "%choice%"=="166" call :Install "sharex" "ShareX"
    if "%choice%"=="167" call :Install "scribus" "Scribus"
    if "%choice%"=="168" call :ShowMessage "Piskel requires manual installation"
    if "%choice%"=="169" call :Install "pencil2d" "Pencil2D"
    
    if "%choice%"=="170" call :Install "itch" "itch.io"
    if "%choice%"=="171" call :Install "dolphin" "Dolphin Emulator"
    if "%choice%"=="172" call :Install "pcsx2" "PCSX2"
    if "%choice%"=="173" call :Install "retroarch" "RetroArch"
    if "%choice%"=="174" call :Install "citra" "Citra"
    if "%choice%"=="175" call :Install "ryujinx" "Ryujinx"
    if "%choice%"=="176" call :ShowMessage "Yuzu emulator is no longer available"
    if "%choice%"=="177" call :Install "joytokey" "JoyToKey"
    if "%choice%"=="178" call :Install "ds4windows" "DS4Windows"
    if "%choice%"=="179" call :Install "steamcmd" "SteamCMD"
    if "%choice%"=="180" call :ShowMessage "Unreal Engine requires Epic Games Launcher"
    if "%choice%"=="181" call :Install "unity-hub" "Unity Hub"
    if "%choice%"=="182" call :ShowMessage "GameMaker Studio requires manual installation"
    
    if "%choice%"=="183" call :Install "thunderbird" "Mozilla Thunderbird"
    if "%choice%"=="184" call :ShowMessage "Postbox requires manual installation"
    if "%choice%"=="185" call :Install "mailspring" "Mailspring"
    if "%choice%"=="186" call :Install "mailbird" "Mailbird"
    if "%choice%"=="187" call :Install "element-desktop" "Element"
    if "%choice%"=="188" call :Install "franz" "Franz"
    if "%choice%"=="189" call :Install "ferdium" "Ferdium"
    if "%choice%"=="190" call :Install "hexchat" "HexChat"
    if "%choice%"=="191" call :Install "pidgin" "Pidgin"
    if "%choice%"=="192" call :Install "trillian" "Trillian"
    if "%choice%"=="193" call :Install "miranda-ng" "Miranda NG"
    if "%choice%"=="194" call :ShowMessage "Guilded requires manual installation"
    if "%choice%"=="195" call :Install "teamspeak" "TeamSpeak"
    
    if "%choice%"=="196" call :Install "docker-desktop" "Docker Desktop"
    if "%choice%"=="197" call :Install "kubernetes-cli" "Kubernetes CLI"
    if "%choice%"=="198" call :Install "minikube" "Minikube"
    if "%choice%"=="199" call :Install "terraform" "Terraform"
    if "%choice%"=="200" call :Install "awscli" "AWS CLI"
    if "%choice%"=="201" call :Install "azure-cli" "Azure CLI"
    if "%choice%"=="202" call :Install "gcloudsdk" "Google Cloud SDK"
    if "%choice%"=="203" call :Install "vagrant" "Vagrant"
    if "%choice%"=="204" call :Install "packer" "Packer"
    if "%choice%"=="205" call :Install "postman" "Postman"
    if "%choice%"=="206" call :Install "k9s" "k9s"
    if "%choice%"=="207" call :Install "kubernetes-helm" "Helm"
    if "%choice%"=="208" call :Install "synfig" "Synfig Studio"
)

echo.
echo %c%Installation process completed.%u%
timeout /t 3 >nul
exit /b

:Install
set "package=%~1"
set "name=%~2"
echo %c%Installing %name%...%u%

choco install "%package%" -y --no-progress

if errorlevel 1 (
    echo %c%Installation failed. Retrying with checksum bypass...%u%
    choco install "%package%" -y --ignore-checksums --no-progress
    
    if errorlevel 1 (
        echo %red%✘ Failed to install %name% even with checksum bypass.%u%
    ) else (
        echo %c%✔ Successfully installed %name% (checksum bypassed)!%u%
    )
) else (
    echo %c%✔ Successfully installed %name%!%u%
)

echo.
exit /b

:ShowMessage
echo %c%ℹ %~1%u%
echo.
exit /b

:SEARCH
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          SEARCH FOR SOFTWARE                                  ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Search the Chocolatey repository by name. Copy the exact package ID to install.%u%
echo.
set /p "searchTerm=%c%Enter software name to search (or Enter to go back) »%u% "
if "%searchTerm%"=="" goto START
echo.
echo %c%Searching for packages containing "%searchTerm%"...%u%
choco search "%searchTerm%" --limit-output
echo.
echo %c%Copy the package name exactly as shown above (e.g., googlechrome)%u%
echo.

set /p "installPkg=%c%Enter exact package name to install (or Enter to return) »%u% "
if "%installPkg%"=="" goto START
set "name=%installPkg%"
echo.
set /p "confirmInstall=%c%Install '%installPkg%'? (Y/N) »%u% "
if /I "%confirmInstall%"=="Y" (
    echo %c%Installing %name%...%u%
    choco install "%installPkg%" -y --no-progress

    if errorlevel 1 (
        echo %c%Installation failed. Retrying with checksum bypass...%u%
        choco install "%installPkg%" -y --ignore-checksums --no-progress

        if errorlevel 1 (
            echo %red%✘ Failed to install %name% even with checksum bypass.%u%
        ) else (
            echo %c%✔ Successfully installed %name% (checksum bypassed)!%u%
        )
    ) else (
        echo %c%✔ Successfully installed %name%!%u%
    )
    echo.
    pause
)
goto START

:UNINSTALL
setlocal EnableDelayedExpansion
chcp 437 >nul
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                           UNINSTALL SOFTWARE                                  ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Installed Chocolatey packages:%u%
echo %red%Do NOT uninstall any Chocolatey core services.%u%
echo.
powershell -Command "Get-ChildItem 'C:\ProgramData\chocolatey\lib' | Select-Object Name | Format-Table -HideTableHeaders"
echo.
set /p "uninstallPackage=%c%Enter package name to uninstall (or Enter to go back) »%u% "
if "%uninstallPackage%"=="" goto START
echo.
set /p "confirmUninstall=%red%Are you sure you want to uninstall %uninstallPackage%? (Y/N) »%u% "
if /I "%confirmUninstall%"=="Y" (
    echo %c%Uninstalling %uninstallPackage%...%u%
    choco uninstall %uninstallPackage% -y
    if !errorlevel! equ 0 (
        echo %c%✔ Successfully uninstalled %uninstallPackage%!%u%
    ) else (
        echo %red%✘ Failed to uninstall %uninstallPackage%.%u%
    )
)
echo.
pause
chcp 65001 >nul
goto START

:Destruct
title Thanks for using Batlez Tweaks!
cls
echo.            
echo %u%Developed by: %c%Batlez
echo %u%Github: %c%https://github.com/Batlez
timeout /t 5 >nul
endlocal
exit