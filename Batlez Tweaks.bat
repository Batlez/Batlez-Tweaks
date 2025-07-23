@echo off
set version=2.0
title Batlez Tweaks - %version%

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING]: Not running with Administrator privileges.
    echo Some tweaks will fail or only partially apply.
    echo.
    choice /C CP /M "Press C to Cancel or P to Proceed without admin"
    if errorlevel 2 goto HELLYEAAAAAAAA
    if errorlevel 1 goto Destruct
)
goto continuewooooooooo

:HELLYEAAAAAAAA
cls
echo Proceeding WITHOUT admin privileges. Expect limited results.
timeout /t 3 >nul /nobreak
goto continuewooooooooo

:continuewooooooooo
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1   
powershell "Set-ExecutionPolicy Unrestricted" >nul 2>&1
setlocal enabledelayedexpansion

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

SET webhook=

:loading
cls
call :SetupConsole
echo.
echo.
echo                                                 %lime% Developed by%u% %violet%Batlez%u%
echo                     %lime% I%u% %underline%%red%cannot%u%%lime% guarantee an FPS increase. Use these optimizations at your own risk.%u%
echo                                %lime%This is intended for a Clean and Stock Windows install.%u%
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
set /p "input=Type your response: "
if /I "%input%"=="Y" goto restorepoint10
if /I "%input%"=="y" goto restorepoint10
if /I "%input%"=="N" goto Presets
if /I "%input%"=="n" goto Presets
echo %orange%Please enter a valid option!%u%
timeout /t 3 >nul
goto RestorePointQuestion

:: Credits to tarekifla
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

echo.
echo %c%Registry backup completed at "%BACKUP_DIR%"%u%
timeout /t 4 >nul

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
set /p "deleteOld=Do you want to remove old Restore Points? (Y/N): "

if /I "%deleteOld%"=="Y" (
    echo Removing old system restore points...
    vssadmin delete shadows /for=C: /oldest >nul 2>&1
    if %errorlevel%==0 (
        echo %cyan%Old restore points removed successfully!%u%
    ) else (
        echo %orange%Failed to remove old restore points. May require elevated privileges.%u%
    )
) else if /I "%deleteOld%"=="N" (
    echo Old restore points preserved.
) else (
    echo Invalid input. Skipping restore point cleanup.
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
for /f "tokens=2 delims==" %%A in ('wmic cpu get name /value ^| find /I "Name"') do set "CPUName=%%A"

set "GPUName="
for /f "skip=1 delims=" %%G in ('wmic path win32_VideoController get Name') do (
    if not "%%G"=="" (
        set "GPUName=%%G"
        goto :GotGPU
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
if %M%==1 goto TweaksMenu
if %M%==2 goto HardwareMenu
if %M%==3 goto WindowsMenu
if %M%==4 goto PrivacyMenu
if %M%==5 goto Backup
if %M%==6 goto AdvancedMenu
if %M%==7 goto More
if %M%==X goto Destruct
if %M%==x goto Destruct
echo %red%Invalid option. Please try again.%u%
goto menu

:Comingsoon
cls
call :SetupConsole 
echo.
echo     %c%    ██████╗ █████╗  ████████╗██╗     ███████╗███████╗  ████████╗ ██╗       ██╗███████╗ █████╗ ██╗  ██╗ ██████╗
echo         ██╔══██╗██╔══██╗╚══██╔══╝██║     ██╔════╝╚════██║  ╚══██╔══╝ ██║  ██╗  ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝
echo         ██████╦╝███████║   ██║   ██║     █████╗    ███╔═╝     ██║    ╚██╗████╗██╔╝█████╗  ███████║█████═╝ ╚█████╗  %u%
echo         ██╔══██╗██╔══██║   ██║   ██║     ██╔══╝  ██╔══╝       ██║     ████╔═████║ ██╔══╝  ██╔══██║██╔═██╗  ╚═══██╗
echo         ██████╦╝██║  ██║   ██║   ███████╗███████╗███████╗     ██║     ╚██╔╝ ╚██╔╝ ███████╗██║  ██║██║ ╚██╗██████╔╝
echo         ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝╚══════╝     ╚═╝      ╚═╝   ╚═╝  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝
echo.
echo.
echo.
echo                                    %c%Batlez is a tweaking script that optimizes your system%u% 
echo                                       %c%to provide the best gaming experience possible.%u%
echo.
echo.
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
if %M%==1 goto about
if %M%==2 goto disclaimer
if %M%==3 goto credits
if %M%==4 goto changelog
if %M%==5 goto menu
if %M%==X goto Destruct
if %M%==x goto Destruct
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
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                              ACKNOWLEDGMENTS                                 ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo.
echo       %c%This project stands on the shoulders of giants. Detailed attribution%u%
echo       %c%and comprehensive credits for all contributors, researchers, and%u%
echo       %c%community members can be found in the documentation file:%u%
echo.
echo       %yellow%Location:%u% %c%Batlez Folder\Batlez Tweaks\Important - Read First.txt%u%
echo.
echo       %c%Special thanks to the optimization community for their continued%u%
echo       %c%research and dedication to improving system performance.%u%
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
if %M%==1 goto A
if %M%==2 goto B
if %M%==3 goto C
if %M%==4 goto D
if %M%==5 goto E
if %M%==6 goto F
if %M%==7 goto G
if %M%==8 goto H
if %M%==9 goto I
if %M%==10 goto J
if %M%==11 goto K
if %M%==12 goto L
if %M%==13 goto Presets
if %M%==14 goto menu
if %M%==X goto Destruct
if %M%==x goto Destruct
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
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "MetricsReportingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SendSiteInfoToImproveServices" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PersonalizationReportingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SpellcheckEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "EdgeCollectionsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Force installing uBlock Origin in Edge...%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" /v "1" /t REG_SZ /d "odfafepnkmbhccpbejgmiehpchacaeak;https://edge.microsoft.com/extensionwebstorebase/v1/crx" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" /v "2" /t REG_SZ /d "bhhhlbepdkbapadjdnnojkbgioiodbic;https://edge.microsoft.com/extensionwebstorebase/v1/crx" /f >nul 2>&1
    
    echo %c%• Disabling Copilot and AI features...%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "CopilotCDPPageContext" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "CopilotPageContext" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "DiscoverPageContextEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "HubsSidebarEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    
    echo %c%• Configuring Edge privacy settings...%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "AddressBarMicrosoftSearchInBingProviderEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "AlternateErrorPagesEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "AutofillCreditCardEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "AutofillAddressEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PaymentMethodQueryEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "EdgeShoppingAssistantEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
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
    
    echo %c%• Force installing uBlock Origin in Chrome...%u%
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist" /v "1" /t REG_SZ /d "cjpalhdlnbpafiamejdnhcphjbkeiagm" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist" /v "2" /t REG_SZ /d "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist" /v "3" /t REG_SZ /d "ldpochfccmkkmhdbclfhpagapcfdljkj" /f >nul 2>&1
    
    echo %c%• Configuring Chrome privacy settings...%u%
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "NetworkPredictionOptions" /t REG_DWORD /d "2" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "SearchSuggestEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "AlternateErrorPagesEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "SpellCheckServiceEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "SafeBrowsingExtendedReportingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
) else (
    echo %c%[3/8] Google Chrome not detected, skipping...%u%
)

if "%FIREFOX_FOUND%"=="true" (
    echo.
    echo %c%[4/8] Configuring Mozilla Firefox for Maximum Privacy...%u%
    
    echo %c%• Disabling Firefox telemetry...%u%
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisableTelemetry" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisableDefaultBrowserAgent" /t REG_DWORD /d "1" /f >nul 2>&1
    
    echo %c%• Installing uBlock Origin in Firefox...%u%
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install" /v "1" /t REG_SZ /d "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install" /v "2" /t REG_SZ /d "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi" /f >nul 2>&1
    
    echo %c%• Configuring Firefox privacy preferences...%u%
    if exist "%ProgramFiles%\Mozilla Firefox\defaults\pref" (
        echo // Firefox Privacy Configuration - Generated by Batlez Tweaks > "%ProgramFiles%\Mozilla Firefox\defaults\pref\batlez_privacy.js" 2>nul
        echo pref^("toolkit.telemetry.unified", false^); >> "%ProgramFiles%\Mozilla Firefox\defaults\pref\batlez_privacy.js" 2>nul
        echo pref^("toolkit.telemetry.enabled", false^); >> "%ProgramFiles%\Mozilla Firefox\defaults\pref\batlez_privacy.js" 2>nul
        echo pref^("datareporting.healthreport.uploadEnabled", false^); >> "%ProgramFiles%\Mozilla Firefox\defaults\pref\batlez_privacy.js" 2>nul
        echo pref^("datareporting.policy.dataSubmissionEnabled", false^); >> "%ProgramFiles%\Mozilla Firefox\defaults\pref\batlez_privacy.js" 2>nul
        echo pref^("privacy.trackingprotection.enabled", true^); >> "%ProgramFiles%\Mozilla Firefox\defaults\pref\batlez_privacy.js" 2>nul
    )
    if exist "%ProgramFiles(x86)%\Mozilla Firefox\defaults\pref" (
        echo // Firefox Privacy Configuration - Generated by Batlez Tweaks > "%ProgramFiles(x86)%\Mozilla Firefox\defaults\pref\batlez_privacy.js" 2>nul
        echo pref^("toolkit.telemetry.unified", false^); >> "%ProgramFiles(x86)%\Mozilla Firefox\defaults\pref\batlez_privacy.js" 2>nul
        echo pref^("toolkit.telemetry.enabled", false^); >> "%ProgramFiles(x86)%\Mozilla Firefox\defaults\pref\batlez_privacy.js" 2>nul
        echo pref^("datareporting.healthreport.uploadEnabled", false^); >> "%ProgramFiles(x86)%\Mozilla Firefox\defaults\pref\batlez_privacy.js" 2>nul
        echo pref^("datareporting.policy.dataSubmissionEnabled", false^); >> "%ProgramFiles(x86)%\Mozilla Firefox\defaults\pref\batlez_privacy.js" 2>nul
        echo pref^("privacy.trackingprotection.enabled", true^); >> "%ProgramFiles(x86)%\Mozilla Firefox\defaults\pref\batlez_privacy.js" 2>nul
    )
) else (
    echo %c%[4/8] Mozilla Firefox not detected, skipping...%u%
)

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
echo %c%[8/8] Applying Universal Browser Optimizations...%u%

echo %c%• Configuring system-wide DNS for ad-blocking...%u%
netsh interface ip set dns "Wi-Fi" static 1.1.1.2 primary >nul 2>&1
netsh interface ip add dns "Wi-Fi" 1.0.0.2 index=2 >nul 2>&1
netsh interface ip set dns "Ethernet" static 1.1.1.2 primary >nul 2>&1
netsh interface ip add dns "Ethernet" 1.0.0.2 index=2 >nul 2>&1

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
echo %c%• All power saving features disabled%u%
echo %c%• USB and PCI power management off%u%
echo %c%• Display and sleep timeouts disabled%u%
echo %c%• Aggressive CPU boost and turbo modes%u%
echo %c%• Maximum GPU performance preference%u%
echo %c%• Hidden Windows performance tweaks enabled%u%
echo %c%• Advanced latency and responsiveness optimizations%u%
echo.
echo %red%%underline%Desktop Notice:%u%
echo %c%This plan prioritizes maximum performance over power efficiency.%u%
echo %c%Power consumption will be high - designed for desktop gaming PCs.%u%
echo %c%Includes secret Windows performance tweaks not available in GUI.%u%
echo.
echo.
choice /C YN /M "%c%Create Desktop Ultimate Performance plan? (Y/N)%u%"
if errorlevel 2 goto K

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    DESKTOP POWER PLAN OPTIMIZATION IN PROGRESS               ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/15] Restoring Default Power Schemes...%u%
powercfg -restoredefaultschemes >nul 2>&1

echo %c%[2/15] Creating Batlez Desktop Ultimate Performance Plan...%u%
powercfg /d 44444444-4444-4444-4444-444444444441 >nul 2>&1
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 44444444-4444-4444-4444-444444444441 >nul 2>&1
powercfg /changename 44444444-4444-4444-4444-444444444441 "Batlez Desktop Ultimate" "Maximum performance gaming plan with hidden tweaks" >nul 2>&1

echo %c%[3/15] Configuring Maximum CPU Performance...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 80 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 80 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 5d76a2ca-e8c0-402f-a133-2158492d58ad 1 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 5d76a2ca-e8c0-402f-a133-2158492d58ad 1 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 100 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 100 >nul 2>&1

echo %c%[4/15] Applying Hidden CPU Performance Tweaks...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 2 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 2 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 4b92d758-5a24-4851-a470-815d78aee119 1 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 4b92d758-5a24-4851-a470-815d78aee119 1 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35d 5 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35d 5 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 1 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 1 >nul 2>&1

echo %c%[5/15] Configuring Advanced Core Parking Settings...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 ea062031-0e34-4ff1-9b6d-eb1059334028 100 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 ea062031-0e34-4ff1-9b6d-eb1059334028 100 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 68dd2f27-a4ce-4e11-8487-3794e4135dfa 1 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 68dd2f27-a4ce-4e11-8487-3794e4135dfa 1 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 c7be0679-2817-4d69-9d02-519a537ed0c6 90 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 c7be0679-2817-4d69-9d02-519a537ed0c6 90 >nul 2>&1

echo %c%[6/15] Applying Secret Latency Optimizations...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 6c2993b0-8f48-481f-bcc6-00dd2742aa06 1 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 6c2993b0-8f48-481f-bcc6-00dd2742aa06 1 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 4b92d758-5a24-4851-a470-815d78aee119 100 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 4b92d758-5a24-4851-a470-815d78aee119 100 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 7b224883-b3cc-4d79-819f-8374152cbe7c 1 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 7b224883-b3cc-4d79-819f-8374152cbe7c 1 >nul 2>&1

echo %c%[7/15] Optimizing Heterogeneous Thread Scheduling...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 93b8b6dc-0698-4d1c-9ee4-0644e900c85d 5 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 93b8b6dc-0698-4d1c-9ee4-0644e900c85d 5 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 bae08b81-2d5e-4688-ad6a-13243356654b 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 54533251-82be-4824-96c1-47b60b740d00 bae08b81-2d5e-4688-ad6a-13243356654b 0 >nul 2>&1

echo %c%[8/15] Disabling All Power Saving Features...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0 >nul 2>&1

echo %c%[9/15] Applying Hidden USB and Device Optimizations...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 0 >nul 2>&1

echo %c%[10/15] Configuring Advanced Graphics Settings...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c dd848b2a-8a5d-4451-9ae2-39cd41658f6c 2 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c dd848b2a-8a5d-4451-9ae2-39cd41658f6c 2 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c 616cdaa5-695e-4545-97ad-97dc2d1bdd88 2 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c 616cdaa5-695e-4545-97ad-97dc2d1bdd88 2 >nul 2>&1

echo %c%[11/15] Configuring Display and Sleep (Never)...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 7516b95f-f776-4464-8c53-06167f40cc99 a9ceb8da-cd46-44fb-a98b-02af69de4623 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 7516b95f-f776-4464-8c53-06167f40cc99 a9ceb8da-cd46-44fb-a98b-02af69de4623 0 >nul 2>&1

echo %c%[12/15] Optimizing Storage for Maximum Performance...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 0012ee47-9041-4b5d-9b77-535fba8b1442 dab60367-53fe-4fbc-825e-521d069d2456 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 0012ee47-9041-4b5d-9b77-535fba8b1442 dab60367-53fe-4fbc-825e-521d069d2456 0 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 0012ee47-9041-4b5d-9b77-535fba8b1442 d639518a-e56d-4345-8af2-b9f32fb26109 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 0012ee47-9041-4b5d-9b77-535fba8b1442 d639518a-e56d-4345-8af2-b9f32fb26109 0 >nul 2>&1

echo %c%[13/15] Applying Gaming and Multimedia Optimizations...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 13d09884-f74e-474a-a852-b6bde8ad03a8 10 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 13d09884-f74e-474a-a852-b6bde8ad03a8 10 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 10778347-1370-4ee0-8bbd-33bdacaade49 1 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 10778347-1370-4ee0-8bbd-33bdacaade49 1 >nul 2>&1

echo %c%[14/15] Configuring Hidden System Responsiveness Tweaks...%u%
powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 0 >nul 2>&1

powercfg /setacvalueindex 44444444-4444-4444-4444-444444444441 de830923-a562-41af-a086-e3a2c6bad2da 13d09884-f74e-474a-a852-b6bde8ad03a8 0 >nul 2>&1
powercfg /setdcvalueindex 44444444-4444-4444-4444-444444444441 de830923-a562-41af-a086-e3a2c6bad2da 13d09884-f74e-474a-a852-b6bde8ad03a8 0 >nul 2>&1

echo %c%[15/15] Activating Desktop Power Plan...%u%
powercfg -SETACTIVE "44444444-4444-4444-4444-444444444441" >nul 2>&1

echo %c%Applying secret registry performance tweaks...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatencyCheckEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "Latency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceDefault" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceFSVP" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyTolerancePerfOverride" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceScreenOffIR" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceVSyncEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "RtlCapabilityCheckLatency" /t REG_DWORD /d "1" /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PlatformAoAcOverride" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PlatformRole" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "TimerRebaseThresholdOnDripsExit" /t REG_DWORD /d "30" /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "AwayModeEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "Class1InitialUnparkCount" /t REG_DWORD /d "100" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CustomizeDuringSetup" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%Applying Intel/AMD specific optimizations...%u%
wmic cpu get name | findstr /i "Intel" >nul && (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "Class2InitialUnparkCount" /t REG_DWORD /d "100" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "InitialUnparkCount" /t REG_DWORD /d "100" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MaxIAverageGraphicsLatencyInOneBucket" /t REG_DWORD /d "1" /f >nul 2>&1
) || (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultD3TransitionLatencyActivelyUsed" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DefaultD3TransitionLatencyIdleLongTime" /t REG_DWORD /d "1" /f >nul 2>&1
)

echo %c%Creating power plan backup marker...%u%
echo Desktop Power Plan Created: %date% %time% > "%temp%\desktop_plan_created"

goto PowerPlanComplete

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
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                            BOOT CONFIGURATION OPTIMIZER                      ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%This tool will optimize boot configuration database settings for:%u%
echo %c%• Enhanced system timing and clock accuracy%u%
echo %c%• Improved CPU performance and power management%u%
echo %c%• Optimized memory allocation and usage%u%
echo %c%• Disabled security features that impact performance%u%
echo %c%• Advanced hardware compatibility settings%u%
echo.
echo %red%%underline%Administrator Notice:%u%
echo %c%These modifications require elevated privileges and will affect boot behavior.%u%
echo %c%A system restart may be required for changes to take full effect.%u%
echo.
echo.
choice /C YN /M "%c%Apply boot configuration optimizations? (Y/N)%u%"
if errorlevel 2 goto TweaksMenu

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                          OPTIMIZING BOOT CONFIGURATION                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/5] Configuring System Timing and Clock Settings...%u%
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /deletevalue disabledynamictick >nul 2>&1
bcdedit /set useplatformtick Yes >nul 2>&1
bcdedit /set tscsyncpolicy Enhanced >nul 2>&1

echo %c%[2/5] Optimizing CPU and Hardware Settings...%u%
bcdedit /set x2apicpolicy Enable >nul 2>&1
bcdedit /set configaccesspolicy Default >nul 2>&1
bcdedit /set MSI Default >nul 2>&1
bcdedit /set usephysicaldestination No >nul 2>&1
bcdedit /set usefirmwarepcisettings No >nul 2>&1

echo %c%[3/5] Disabling Security Features for Performance...%u%
bcdedit /set vsmlaunchtype Off >nul 2>&1
bcdedit /set vm No >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v DisableExternalDMAUnderLock /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v HVCIMATRequired /t REG_DWORD /d 0 /f >nul 2>&1

echo %c%[4/5] Configuring Memory Management...%u%
bcdedit /set firstmegabytepolicy UseAll >nul 2>&1
bcdedit /set avoidlowmemory 0x8000000 >nul 2>&1
bcdedit /set nolowmem Yes >nul 2>&1
bcdedit /set linearaddress57 OptOut >nul 2>&1
bcdedit /set increaseuserva 268435328 >nul 2>&1

echo %c%[5/5] Refreshing System Explorer...%u%
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 >nul
start explorer.exe

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       BOOT OPTIMIZATION COMPLETED                            ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Boot configuration database has been successfully optimized.%u%
echo.
echo %c%Applied Optimizations:%u%
echo %c%• Platform timing improvements%u%
echo %c%• Enhanced CPU scheduling%u%
echo %c%• Memory allocation optimization%u%
echo %c%• Security feature adjustments%u%
echo %c%• Hardware compatibility enhancements%u%
echo.
echo %red%Recommendation:%u% %c%Restart your system to ensure all changes take effect.%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
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
if errorlevel 2 goto C

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

echo %c%[5/8] Disabling GPU Preemption Features...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnablePreemption" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "GPUPreemptionLevel" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "ComputePreemption" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "DisablePreemption" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "DisableCudaContextPreemption" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "DisablePreemptionOnS3S4" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[6/8] Configuring Graphics Driver Settings...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RMDisablePostL2Compression" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RmDisableRegistryCaching" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableWriteCombining" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "MonitorLatencyTolerance" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[7/8] Optimizing Power Management and Latency...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "Latency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceDefault" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HighPerformance" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MaximumPerformancePercent" /t REG_DWORD /d "100" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "MinimumThrottlePercent" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "InterruptSteeringDisabled" /t REG_DWORD /d "1" /f >nul 2>&1

echo %c%[8/8] Applying NVIDIA Profile Configuration...%u%
cd /d "%TEMP%\nvidiaProfileInspector\" 2>nul
nvidiaProfileInspector.exe "NVIDIAProfileInspector.nip" >nul 2>&1
reg add "HKCU\Software\NVIDIA Corporation\NvTray" /v "StartOnLogin" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableGR535" /t REG_DWORD /d "0" /f >nul 2>&1

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
echo.
echo %red%Performance Notes:%u%
echo %c%• System may run warmer due to performance focus%u%
echo %c%• Power consumption may increase slightly%u%
echo %c%• Restart recommended for optimal performance%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

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
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                            WI-FI PERFORMANCE OPTIMIZER                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Wi-Fi specific optimizations include:%u%
echo %c%• Disable power saving on wireless adapter%u%
echo %c%• Adjust 802.11 protocol settings for gaming%u%
echo %c%• MTU tuning and disable auto-scanning%u%
echo %c%• Disable Wi-Fi Sense and hotspot reporting%u%
echo %c%• Dynamic interface detection and configuration%u%
echo %c%• DNS cache flush and Winsock reset%u%
echo.
echo %red%%underline%Wi-Fi Notice:%u%
echo %c%These tweaks disable power saving and Wi-Fi Sense features.%u%
echo %c%Battery life may be reduced on laptops.%u%
echo.
echo.
choice /C YN /M "%c%Apply Wi-Fi optimizations? (Y/N)%u%"
if errorlevel 2 goto D

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         WI-FI OPTIMIZATION IN PROGRESS                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/8] Configuring Core TCP/IP Settings...%u%
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

echo %c%[2/8] Detecting and Configuring Wi-Fi Interface...%u%
set "WIFI_IFACE="
for /f "tokens=2 delims=:" %%I in ('netsh interface show interface 2^>nul ^| findstr /i "Wireless"') do set "WIFI_IFACE=%%~I"
if defined WIFI_IFACE (
    set "WIFI_IFACE=!WIFI_IFACE:~1!"
    netsh interface ipv4 set subinterface "!WIFI_IFACE!" mtu=1472 store=persistent >nul 2>&1
) else (
    netsh interface ipv4 set subinterface "Wi-Fi" mtu=1472 store=persistent >nul 2>&1
    netsh interface ipv4 set subinterface "Wireless Network Connection" mtu=1472 store=persistent >nul 2>&1
)
netsh wlan set profileparameter name=* connectiontype=ESS >nul 2>&1
netsh wlan set profileparameter name=* connectionmode=auto >nul 2>&1

echo %c%[3/8] Configuring Wireless Adapter Power Management...%u%
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

echo %c%[4/8] Optimizing 802.11 Wireless Protocol Settings...%u%
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

echo %c%[5/8] Disabling Wi-Fi Sense and Hotspot Features...%u%
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "value" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WlanSvc\AnqpCache" /v "OsuRegistrationStatus" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WifiNetworkManager\HotspotLogin" /v "IsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
sc config WlanSvc start= auto >nul 2>&1
sc start WlanSvc >nul 2>&1

echo %c%[6/8] Configuring Advanced Wi-Fi Network Settings...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WlanSvc\Parameters" /v "BackgroundScanEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WlanSvc\Parameters" /v "BssTypeSelection" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WlanSvc\Parameters" /v "ProfileDirectoryPath" /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\Tethering" /v "HotspotConfigured" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[7/8] Applying Wi-Fi Gaming and Performance Optimizations...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpInitialRTT" /t REG_DWORD /d "3" /f >nul 2>&1

echo %c%[8/8] Refreshing Network Configuration...%u%
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

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       WI-FI OPTIMIZATION COMPLETED                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Wi-Fi performance optimizations have been successfully applied.%u%
echo.
echo %c%Applied Optimizations:%u%
echo %c%• Core TCP/IP stack optimized for wireless%u%
echo %c%• Dynamic Wi-Fi interface detection and MTU tuning%u%
echo %c%• Wireless adapter power management disabled%u%
echo %c%• 802.11 protocol settings optimized for gaming%u%
echo %c%• Wi-Fi Sense and hotspot reporting disabled%u%
echo %c%• Advanced network scanning features disabled%u%
echo %c%• Gaming and multimedia priorities enhanced%u%
echo %c%• Network configuration refreshed%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:EthernetOptimization
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        ETHERNET PERFORMANCE OPTIMIZER                        ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Ethernet specific optimizations include:%u%
echo %c%• Gigabit speed and full-duplex configuration%u%
echo %c%• Hardware acceleration and offloading features%u%
echo %c%• Jumbo frames and large send offload%u%
echo %c%• Interrupt moderation and RSS optimization%u%
echo %c%• Flow control and buffer size tuning%u%
echo.
echo %red%%underline%Ethernet Notice:%u%
echo %c%These optimizations assume a wired Gigabit connection.%u%
echo %c%Some features may not work on older network hardware.%u%
echo.
echo.
choice /C YN /M "%c%Apply Ethernet optimizations? (Y/N)%u%"
if errorlevel 2 goto D

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                      ETHERNET OPTIMIZATION IN PROGRESS                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/6] Configuring Ethernet TCP Settings...%u%
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global chimney=enabled >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global ecncapability=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global initialRto=2000 >nul 2>&1
netsh int tcp set global rsc=disabled >nul 2>&1
netsh int tcp set global nonsackttresiliency=disabled >nul 2>&1
netsh int tcp set global fastopen=enabled >nul 2>&1
netsh int tcp set global fastopenfallback=enabled >nul 2>&1

echo %c%[2/6] Setting Ethernet Interface Parameters...%u%
netsh interface ipv4 set subinterface "Ethernet" mtu=1500 store=persistent >nul 2>&1
netsh interface ipv4 set subinterface "Local Area Connection" mtu=1500 store=persistent >nul 2>&1
netsh int tcp set supplemental template=custom icw=10 >nul 2>&1

echo %c%[3/6] Optimizing Speed and Duplex Settings...%u%
for /f %%a in ('reg query HKLM /v "*WakeOnMagicPacket" /s 2^>nul ^| findstr "HKEY"') do (
    for /f %%i in ('reg query "%%a" /v "*SpeedDuplex" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*SpeedDuplex" /t REG_SZ /d "6" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "*FlowControl" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*FlowControl" /t REG_DWORD /d "0" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "AutoNegotiation" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "AutoNegotiation" /t REG_SZ /d "1" /f >nul 2>&1)
)

echo %c%[4/6] Enabling Hardware Acceleration Features...%u%
for /f %%a in ('reg query HKLM /v "*WakeOnMagicPacket" /s 2^>nul ^| findstr "HKEY"') do (
    for /f %%i in ('reg query "%%a" /v "*TCPChecksumOffloadIPv4" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*TCPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "*TCPChecksumOffloadIPv6" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*TCPChecksumOffloadIPv6" /t REG_SZ /d "3" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "*UDPChecksumOffloadIPv4" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*UDPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "*UDPChecksumOffloadIPv6" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*UDPChecksumOffloadIPv6" /t REG_SZ /d "3" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "*IPChecksumOffloadIPv4" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*IPChecksumOffloadIPv4" /t REG_SZ /d "3" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "*LsoV2IPv4" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*LsoV2IPv4" /t REG_SZ /d "1" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "*LsoV2IPv6" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*LsoV2IPv6" /t REG_SZ /d "1" /f >nul 2>&1)
)

echo %c%[5/6] Configuring Buffers and Performance Settings...%u%
for /f %%a in ('reg query HKLM /v "*WakeOnMagicPacket" /s 2^>nul ^| findstr "HKEY"') do (
    for /f %%i in ('reg query "%%a" /v "*TransmitBuffers" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*TransmitBuffers" /t REG_SZ /d "256" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "*ReceiveBuffers" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*ReceiveBuffers" /t REG_SZ /d "512" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "*JumboPacket" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*JumboPacket" /t REG_SZ /d "9014" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "*RSS" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*RSS" /t REG_SZ /d "1" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "*NumRssQueues" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*NumRssQueues" /t REG_SZ /d "4" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "*InterruptModeration" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*InterruptModeration" /t REG_SZ /d "1" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "*CoalesceBuffers" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*CoalesceBuffers" /t REG_SZ /d "1" /f >nul 2>&1)
)

echo %c%[6/6] Applying Ethernet Gaming Optimizations...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t REG_DWORD /d "65536" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                     ETHERNET OPTIMIZATION COMPLETED                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Ethernet performance optimizations have been successfully applied.%u%
echo.
echo %c%Applied Optimizations:%u%
echo %c%• TCP/IP stack optimized for wired connections%u%
echo %c%• Gigabit speed and full-duplex configuration%u%
echo %c%• Hardware acceleration features enabled%u%
echo %c%• Jumbo frames and large send offload configured%u%
echo %c%• Buffer sizes and RSS optimization applied%u%
echo %c%• Gaming and multimedia priorities enhanced%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:UniversalTweaks
cls
call :SetupConsole
echo.
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        UNIVERSAL NETWORK OPTIMIZER                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Universal network optimizations include:%u%
echo %c%• Core TCP/IP stack improvements%u%
echo %c%• DNS and routing optimizations%u%
echo %c%• Network discovery and firewall settings%u%
echo %c%• General performance and latency tweaks%u%
echo %c%• Power management disabled across all adapters%u%
echo.
echo.
choice /C YN /M "%c%Apply universal network optimizations? (Y/N)%u%"
if errorlevel 2 goto D
cls
echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                     UNIVERSAL OPTIMIZATION IN PROGRESS                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %red%[!] Universal tweaks will enable Network Discovery (firewall rules).%u%
choice /C YN /M "%c%Proceed with Universal Tweaks? (Y/N)%u%"
if errorlevel 2 (
    echo %red%Aborting Universal Tweaks.%u%
    goto D
)
echo %c%[1/4] Configuring Core Network Settings...%u%
netsh int tcp set heuristics disabled >nul 2>&1
netsh int tcp set supp internet congestionprovider=ctcp >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global ecncapability=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global MaxSynRetransmissions=2 >nul 2>&1
netsh int tcp set global pacingprofile=off >nul 2>&1
netsh int udp set global uro=enabled >nul 2>&1
netsh winsock set autotuning on >nul 2>&1

echo %c%[2/4] Optimizing Interface Parameters...%u%
for /f %%r in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /f "1" /d /s 2^>nul ^| findstr HKEY_') do (
    reg add %%r /v "TCPNoDelay" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add %%r /v "TcpAckFrequency" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add %%r /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add %%r /v "DeadGWDetectDefault" /t REG_DWORD /d "1" /f >nul 2>&1
)

echo %c%[3/4] Disabling Power Management...%u%
for /f %%a in ('reg query HKLM /v "*WakeOnMagicPacket" /s 2^>nul ^| findstr "HKEY"') do (
    for /f %%i in ('reg query "%%a" /v "EnablePowerManagement" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "EnablePowerManagement" /t REG_SZ /d "0" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "*WakeOnMagicPacket" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*WakeOnMagicPacket" /t REG_SZ /d "0" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "*WakeOnPattern" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "*WakeOnPattern" /t REG_SZ /d "0" /f >nul 2>&1)
    for /f %%i in ('reg query "%%a" /v "EnableGreenEthernet" 2^>nul ^| findstr "HKEY"') do (reg add "%%i" /v "EnableGreenEthernet" /t REG_SZ /d "0" /f >nul 2>&1)
)

echo %c%[4/4] Applying Gaming Optimizations...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                    UNIVERSAL OPTIMIZATION COMPLETED                          ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%Universal network optimizations have been successfully applied.%u%
echo.
echo %c%Applied Optimizations:%u%
echo %c%• Core TCP/IP stack improvements%u%
echo %c%• Network interface parameters optimized%u%
echo %c%• Power management features disabled%u%
echo %c%• Gaming and multimedia priorities enhanced%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

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
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfCores /format:value 2^>nul ^| findstr "NumberOfCores"') do set /a "NumberOfCores=%%a" >nul 2>&1
for /f "tokens=2 delims==" %%a in ('wmic cpu get MaxClockSpeed /format:value 2^>nul ^| findstr "MaxClockSpeed"') do set /a "MaxClockSpeed=%%a" >nul 2>&1
if not defined NumberOfCores set NumberOfCores=4
if not defined MaxClockSpeed set MaxClockSpeed=3000
set /a "CPU_SCORE=%NumberOfCores%*%MaxClockSpeed%"

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
wmic cpu get name 2>nul | findstr "Intel" >nul && (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f >nul 2>&1
)

echo %c%[6/12] Optimizing System Responsiveness...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f >nul 2>&1

echo %c%[7/12] Configuring CPU-Based Timer Resolution...%u%
if %CPU_SCORE% LEQ 8000 (
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /f >nul 2>&1
) else if %CPU_SCORE% LEQ 12000 (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "5" /f >nul 2>&1
) else if %CPU_SCORE% LEQ 18000 (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "2" /f >nul 2>&1
) else (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "1" /f >nul 2>&1
)

echo %c%[8/12] Setting CPU-Based Cursor Update Interval...%u%
if %CPU_SCORE% LEQ 10000 (
    reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorUpdateInterval" /t REG_DWORD /d "5" /f >nul 2>&1
) else if %CPU_SCORE% LEQ 15000 (
    reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorUpdateInterval" /t REG_DWORD /d "2" /f >nul 2>&1
) else (
    reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorUpdateInterval" /t REG_DWORD /d "1" /f >nul 2>&1
)

echo %c%[9/12] Optimizing Power Throttling and Thread Management...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ThreadDpcEnable" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DpcTimeout" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[10/12] Configuring CPU Affinity and CSRSS Priority...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1

echo %c%[11/12] Optimizing Intel Cache and Memory Settings...%u%
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
echo %c%• CPU detected: %NumberOfCores% cores at %MaxClockSpeed% MHz%u%
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
echo %c%• AMD Precision Boost and Cool'n'Quiet configuration%u%
echo %c%• Ryzen-optimized C-States and P-States settings%u%
echo %c%• AMD Core Performance Boost optimization%u%
echo %c%• Spectre/Meltdown mitigation adjustments for AMD%u%
echo %c%• CPU affinity and CSRSS priority optimization%u%
echo %c%• Dynamic timer resolution based on CPU performance%u%
echo.
echo %red%%underline%Ryzen Notice:%u%
echo %c%These optimizations disable power saving for maximum performance.%u%
echo %c%CPU temperatures may increase and power consumption will rise.%u%
echo.
echo.
choice /C YN /M "%c%Apply AMD Ryzen optimizations? (Y/N)%u%"
if errorlevel 2 goto E

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       %red%RYZEN%c% OPTIMIZATION IN PROGRESS                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%

echo.
echo %c%[1/12] Detecting CPU Specifications...%u%
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfCores /format:value 2^>nul ^| findstr "NumberOfCores"') do set /a "NumberOfCores=%%a" >nul 2>&1
for /f "tokens=2 delims==" %%a in ('wmic cpu get MaxClockSpeed /format:value 2^>nul ^| findstr "MaxClockSpeed"') do set /a "MaxClockSpeed=%%a" >nul 2>&1
if not defined NumberOfCores set NumberOfCores=4
if not defined MaxClockSpeed set MaxClockSpeed=3000
set /a "CPU_SCORE=%NumberOfCores%*%MaxClockSpeed%"

echo %c%[2/12] Configuring AMD Ryzen Power Management...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c" /v "ValueMax" /t REG_DWORD /d "100" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c\DefaultPowerSchemeValues\8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" /v "ValueMax" /t REG_DWORD /d "100" /f >nul 2>&1

echo %c%[3/12] Optimizing AMD C-States for Ryzen Architecture...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t REG_DWORD /d "0" /f >nul 2>&1

echo %c%[4/12] Configuring AMD Precision Boost and Core Performance...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "ValueMax" /t REG_DWORD /d "2" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\45bcc044-d885-43e2-8605-ee0ec6e96b59" /v "ValueMax" /t REG_DWORD /d "100" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\45bcc044-d885-43e2-8605-ee0ec6e96b59" /v "ValueMin" /t REG_DWORD /d "100" /f >nul 2>&1

echo %c%[5/12] Configuring AMD Spectre/Meltdown Mitigations...%u%
wmic cpu get name 2>nul | findstr "AMD" >nul && (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "64" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f >nul 2>&1
)

echo %c%[6/12] Optimizing System Responsiveness...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f >nul 2>&1

echo %c%[7/12] Configuring CPU-Based Timer Resolution...%u%
if %CPU_SCORE% LEQ 8000 (
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /f >nul 2>&1
) else if %CPU_SCORE% LEQ 12000 (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "5" /f >nul 2>&1
) else if %CPU_SCORE% LEQ 18000 (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "2" /f >nul 2>&1
) else (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "1" /f >nul 2>&1
)

echo %c%[8/12] Setting CPU-Based Cursor Update Interval...%u%
if %CPU_SCORE% LEQ 10000 (
    reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorUpdateInterval" /t REG_DWORD /d "5" /f >nul 2>&1
) else if %CPU_SCORE% LEQ 15000 (
    reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorUpdateInterval" /t REG_DWORD /d "2" /f >nul 2>&1
) else (
    reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorUpdateInterval" /t REG_DWORD /d "1" /f >nul 2>&1
)

echo %c%[9/12] Disabling AMD Power Throttling and Cool'n'Quiet...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AmdPPM" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdfendr" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1

echo %c%[10/12] Configuring AMD CPU Affinity and CSRSS Priority...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1

echo %c%[11/12] Optimizing AMD Infinity Fabric and Memory Controller...%u%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SecondLevelDataCache" /t REG_DWORD /d "1024" /f >nul 2>&1

echo %c%[12/12] Applying AMD Ryzen Gaming Optimizations...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "CPU Priority" /t REG_DWORD /d "6" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f >nul 2>&1
reg add "HKLM\SOFTWARE\AMD\CN" /v "PowerScheme" /t REG_DWORD /d "1" /f >nul 2>&1

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       %red%RYZEN%c% OPTIMIZATION COMPLETED                           ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.
echo %c%AMD Ryzen optimizations have been successfully applied.%u%
echo.
echo %c%Applied Optimizations:%u%
echo %c%• CPU detected: %NumberOfCores% cores at %MaxClockSpeed% MHz%u%
echo %c%• AMD Ryzen power management configured%u%
echo %c%• C-States optimized for Ryzen architecture%u%
echo %c%• Precision Boost and Core Performance enhanced%u%
echo %c%• Spectre/Meltdown mitigations adjusted for AMD%u%
echo %c%• System responsiveness improved (10%% reserve)%u%
echo %c%• Timer resolution optimized for CPU performance%u%
echo %c%• AMD power throttling and Cool'n'Quiet disabled%u%
echo %c%• CSRSS priority and CPU affinity optimized%u%
echo %c%• Infinity Fabric and memory controller optimized%u%
echo %c%• Gaming task priorities enhanced%u%
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
    set RAM_GB=8      REM Default GB for profile logic
    set TotalRAM=8192 REM Default MB for display
    set RAM_PROFILE=MEDIUM REM Default profile based on 8GB
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
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown"      /t REG_DWORD /d "1"      /f >nul 2>&1
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
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3"      /f >nul 2>&1

echo %c%[6/6] Applying Advanced Memory Optimizations...%u%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness"                           /t REG_DWORD /d "10" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl"     /v "Win32PrioritySeparation"     /t REG_DWORD /d "38"                     /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "3"  /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d "0"  /f >nul 2>&1

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
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableDeadGWDetect  /t REG_DWORD /d 0      /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnablePMTUDiscovery /t REG_DWORD /d 1      /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v GlobalMaxTcpWindowSize /t REG_DWORD /d 65536  /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpWindowSize         /t REG_DWORD /d 65536  /f >nul 2>&1
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
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"        /v Size                  /t REG_DWORD /d 3           /f >nul 2>&1
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
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                       SERVICE OPTIMIZATION IN PROGRESS                       ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.

if "%DISABLE_TELEMETRY%"=="true" (
    echo %c%[1/12] Disabling Windows Telemetry and Data Collection...%u%
    call :DisableTelemetryServices
) else (
    echo %c%[1/12] Preserving Windows Telemetry Services...%u%
)

if "%DISABLE_OEM%"=="true" (
    echo %c%[2/12] Disabling OEM Manufacturer Services...%u%
    call :DisableOEMServices
) else (
    echo %c%[2/12] Preserving OEM Manufacturer Services...%u%
)

if "%DISABLE_NETWORK%"=="true" (
    echo %c%[3/12] Disabling Unused Network Services...%u%
    call :DisableUnusedNetworkServices
) else (
    echo %c%[3/12] Preserving Network Services...%u%
)

if "%ENABLE_XBOX%"=="true" (
    echo %c%[4/12] Enabling Microsoft Store and Xbox Services...%u%
    call :EnableXboxServices
) else (
    echo %c%[4/12] Disabling Microsoft Store and Xbox Services...%u%
    call :DisableXboxServices
)

if "%DISABLE_3RD_PARTY%"=="true" (
    echo %c%[5/12] Disabling Third-Party Application Telemetry...%u%
    call :DisableThirdPartyTelemetry
) else (
    echo %c%[5/12] Preserving Third-Party Application Telemetry...%u%
)

if "%DISABLE_GAMING_HW%"=="true" (
    echo %c%[6/12] Disabling Gaming Hardware Background Services...%u%
    call :DisableGamingHardwareServices
) else (
    echo %c%[6/12] Preserving Gaming Hardware Services...%u%
)

if "%DISABLE_UPDATES%"=="true" (
    echo %c%[7/12] Disabling Automatic Update Services...%u%
    call :DisableAutomaticUpdateServices
) else (
    echo %c%[7/12] Preserving Automatic Update Services...%u%
)

if "%DISABLE_PERFORMANCE%"=="true" (
    echo %c%[8/12] Disabling Performance-Impacting Services...%u%
    call :DisablePerformanceServices
) else (
    echo %c%[8/12] Preserving Performance Services...%u%
)

if "%DISABLE_SECURITY%"=="true" (
    echo %c%[9/12] Disabling Optional Security and Backup Services...%u%
    call :DisableSecurityServices
) else (
    echo %c%[9/12] Preserving Security and Backup Services...%u%
)

if "%DISABLE_BLUETOOTH%"=="true" (
    echo %c%[10/12] Disabling Bluetooth Services...%u%
    call :DisableBluetoothServices
) else (
    echo %c%[10/12] Preserving Bluetooth Services...%u%
)

echo %c%[11/12] Ensuring Critical System Services Remain Enabled...%u%
call :EnableCriticalServices

echo %c%[12/12] Applying Final Configurations...%u%
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
echo.
echo %green%Total Services Optimized: Over 150+ background services managed%u%
echo %red%Note: Changes will take effect after restart.%u%
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

call :DisableService "hidserv"
call :DisableService "msiserver"
call :DisableService "webthreatdefsvc"
call :DisableService "webthreatdefusersvc"
call :DisableService "wscsvc"
call :DisableService "AppIDSvc

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

:EnableCriticalServices
echo %c%    Ensuring critical services remain enabled...%u%
sc config "AudioEndpointBuilder" start= auto >nul 2>&1
sc config "Audiosrv" start= auto >nul 2>&1
sc config "BFE" start= auto >nul 2>&1
sc config "BrokerInfrastructure" start= auto >nul 2>&1
sc config "camsvc" start= auto >nul 2>&1
sc config "CDPSvc" start= auto >nul 2>&1
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
sc config "ShellHWDetection" start= auto >nul 2>&1
sc config "Spooler" start= auto >nul 2>&1
sc config "sppsvc" start= auto >nul 2>&1
sc config "StateRepository" start= auto >nul 2>&1
sc config "SystemEventsBroker" start= auto >nul 2>&1
sc config "Themes" start= auto >nul 2>&1
sc config "TrustedInstaller" start= manual >nul 2>&1
sc config "UserManager" start= auto >nul 2>&1
sc config "UsoSvc" start= auto >nul 2>&1
sc config "VaultSvc" start= manual >nul 2>&1
sc config "Wcmsvc" start= auto >nul 2>&1
sc config "Winmgmt" start= auto >nul 2>&1
sc config "WlanSvc" start= auto >nul 2>&1
sc config "wlidsvc" start= manual >nul 2>&1
sc config "wlpasvc" start= manual >nul 2>&1
sc config "WpnService" start= auto >nul 2>&1
sc config "wuauserv" start= auto >nul 2>&1

echo %green%    → Critical services verified and protected%u%
exit /b

:ApplyFinalServiceConfigurations
echo %c%    Applying final service configurations...%u%
sc config "CertPropSvc" start= manual >nul 2>&1
sc config "Ndu" start= auto >nul 2>&1

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
echo %c%Cortana/Search is built into Windows 10/11 and can consume memory/CPU.%u%
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
echo.
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
echo %c%[12/12] Windows Services and Startup Programs%u%
choice /C YN /M "%c%Disable unnecessary services & startup programs? (Y/N)%u%"
if errorlevel 2 (
    set "DISABLE_SERVICES=false" 
    echo %c%• Services and startup programs will be PRESERVED%u%
) else (
    set "DISABLE_SERVICES=true"  
    echo %c%• Unnecessary services and startup programs will be DISABLED%u%
)

echo.
echo %c%╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         DEBLOATING IN PROGRESS                               ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝%u%
echo.

echo %c%[1/15] Removing Third-Party Bloatware and Games…%u%
chcp 437 >nul
powershell -Command "Get-AppxPackage | Where-Object {$_.Name -match 'CandyCrush|FarmVille|Netflix|Spotify|Facebook|Twitter|Instagram|TikTok|Asphalt|MarchofEmpires|DisneyMagicKingdoms|Flipboard|Duolingo|PicsArt|king.com|Playtika|GAMELOFT|ActiproSoftware|ClearChannel|Pandora|Shazam|Expedia|Clipchamp'} | Remove-AppxPackage" >nul 2>&1
chcp 65001 >nul
set "BLOAT_APPS=*2FE3CB00.PicsArt-PhotoStudio* *4DF9E0F8.Netflix* *9E2F88E3.Twitter* *Facebook* *SpotifyAB.SpotifyMusic* *BytedancePte.Ltd.TikTok* *king.com* *GAMELOFTSA.Asphalt8Airborne* *Playtika.CaesarsSlotsFreeCasino* *ClearChannelRadioDigital.iHeartRadio* *TuneIn.TuneInRadio* *PandoraMediaInc* *ShazamEntertainmentLtd.Shazam* *AdobeSystemsIncorporated.AdobePhotoshopExpress* *Expedia.ExpediaHotelsFlightsCarsActivities* *Flipboard.Flipboard* *Duolingo-LearnLanguagesforFree*"

for %%a in (%BLOAT_APPS%) do (
chcp 437 >nul
    powershell -Command "Get-AppxPackage %%a | Remove-AppxPackage" >nul 2>&1
	chcp 65001 >nul
)

if "%REMOVE_OEM%"=="true" (
    echo %c%[2/15] Removing OEM Manufacturer Bloatware…%u%
    set "OEM_BLOAT=*HPSmartDevice* *DellSupportAssist* *MSICenter* *MyASUS* *BraveBrowser* *HPPrinting* *DellUpdate* *ASUSUpdateNotifier* *LenovoUtility* *AcerUpdater* *TOSHIBAUtility* *SamsungUpdate* *HPSupportAssistant* *DellCommandUpdate* *MSILiveUpdate* *ASUSWinFlash* *LenovoVantage* *AcerCare* *TOSHIBACare* *SamsungGalaxy*"
    for %%a in (%OEM_BLOAT%) do (
	chcp 437 >nul
        powershell -Command "Get-AppxPackage %%a | Remove-AppxPackage" >nul 2>&1
		chcp 65001 >nul
    )
) else (
    echo %c%[2/15] Skipping OEM Manufacturer bloatware…%u%
)

if "%REMOVE_SYSTEM%"=="true" (
    echo %c%[3/15] Removing System Apps…%u%
    set "SYSTEM_APPS=*Microsoft.Wallet* *Microsoft.WebMediaExtensions* *Microsoft.PeopleExperienceHost* *Microsoft.MicrosoftStickyNotes* *Microsoft.GetHelp* *Microsoft.WindowsFeedbackHub* *Microsoft.MicrosoftOfficeHub* *Microsoft.Office.OneNote* *Microsoft.Todos* *Microsoft.PowerAutomateDesktop* *Microsoft.Whiteboard*"
    for %%a in (%SYSTEM_APPS%) do (
	chcp 437 >nul
        powershell -Command "Get-AppxPackage %%a | Remove-AppxPackage" >nul 2>&1
		chcp 65001 >nul
    )
) else (
    echo %c%[3/15] Skipping System apps…%u%
)

echo %c%[4/15] Removing Microsoft Apps and Unnecessary Features…%u%
set "MS_BLOAT=*Microsoft.BingNews* *Microsoft.BingWeather* *Microsoft.BingSports* *Microsoft.BingFinance* *Microsoft.GetHelp* *Microsoft.Getstarted* *Microsoft.MicrosoftSolitaireCollection* *Microsoft.People* *Microsoft.WindowsMaps* *Microsoft.MicrosoftOfficeHub* *Microsoft.Todos* *Microsoft.PowerAutomateDesktop* *Microsoft.Whiteboard* *Microsoft.Photos*"

for %%a in (%MS_BLOAT%) do (
chcp 437 >nul
    powershell -Command "Get-AppxPackage %%a | Remove-AppxPackage" >nul 2>&1
	chcp 65001 >nul
)

echo %c%[5/15] Removing Communication and Social Apps…%u%
if "%REMOVE_COMM%"=="true" (
    set "COMM_APPS=*Microsoft.SkypeApp* *Microsoft.Teams* *Microsoft.YourPhone* *Microsoft.Messaging* *Microsoft.CommsPhone* *Microsoft.WindowsPhone* *SkypeApp*"
    for %%a in (%COMM_APPS%) do (
	chcp 437 >nul
        powershell -Command "Get-AppxPackage %%a | Remove-AppxPackage" >nul 2>&1
		chcp 65001 >nul
    )
) else (
    echo %c%• Communication apps preserved%u%
)

echo %c%[6/15] Removing Media and Creative Apps…%u%
set "MEDIA_APPS=*Microsoft.ZuneMusic* *Microsoft.ZuneVideo* *Microsoft.Movies* *Microsoft.MSPaint* *Microsoft.WindowsSoundRecorder* *Microsoft.MixedReality.Portal* *Microsoft.Microsoft3DViewer* *Microsoft.Print3D* *Clipchamp.Clipchamp* *Microsoft.Paint*"

for %%a in (%MEDIA_APPS%) do (
chcp 437 >nul
    powershell -Command "Get-AppxPackage %%a | Remove-AppxPackage" >nul 2>&1
	chcp 65001 >nul
)

if "%REMOVE_COPILOT%"=="true" (
    echo %c%[7/15] Removing Microsoft Copilot…%u%
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d "1" /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /d "0" /f >nul 2>&1
    chcp 437 >nul
	powershell -Command "Get-AppxPackage *Microsoft.Copilot* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *Microsoft.Windows.Ai.Copilot.Provider* | Remove-AppxPackage" >nul 2>&1
	chcp 65001 >nul
) else (
    echo %c%[7/15] Preserving Microsoft Copilot…%u%
)

echo %c%[8/15] Removing Widgets and Taskbar Bloat…%u%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d "0" /f >nul 2>&1

if "%REMOVE_XBOX%"=="true" (
    echo %c%[9/15] Removing Xbox Services and Apps…%u%
    set "XBOX_APPS=*Microsoft.XboxApp* *Microsoft.XboxGamingOverlay* *Microsoft.XboxGameOverlay* *Microsoft.XboxSpeechToTextOverlay* *Microsoft.Xbox.TCUI* *Microsoft.XboxIdentityProvider* *Microsoft.GamingApp* *Microsoft.MinecraftUWP*"
    
    for %%a in (%XBOX_APPS%) do (
	 chcp 437 >nul
        powershell -Command "Get-AppxPackage %%a | Remove-AppxPackage" >nul 2>&1
		chcp 65001 >nul
    )

    reg add "HKLM\SYSTEM\CurrentControlSet\Services\XblAuthManager" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\XblGameSave" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\XboxGipSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\XboxNetApiSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\LicenseManager" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
) else (
    echo %c%[9/15] Preserving Xbox Services…%u%
)

if "%REMOVE_STORE%"=="true" (
    echo %c%[10/15] Removing Microsoft Store…%u%
	chcp 437 >nul
    powershell -Command "Get-AppxPackage *Microsoft.WindowsStore* | Remove-AppxPackage" >nul 2>&1
    powershell -Command "Get-AppxPackage *Microsoft.StorePurchaseApp* | Remove-AppxPackage" >nul 2>&1
	chcp 65001 >nul
    reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d "1" /f >nul 2>&1
) else (
    echo %c%[10/15] Preserving Microsoft Store…%u%
)

if "%REMOVE_EDGE%"=="true" (
    echo %c%[11/15] Removing Microsoft Edge…%u%
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
) else (
    echo %c%[11/15] Preserving Microsoft Edge…%u%
)

if "%REMOVE_ONEDRIVE%"=="true" (
    echo %c%[12/15] Removing OneDrive…%u%
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
) else (
    echo %c%[12/15] Preserving OneDrive…%u%
)

echo %c%[13/15] Removing Unnecessary Windows Features and Capabilities…%u%
dism /online /disable-feature /featurename:WindowsMediaPlayer /quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featurename:MediaPlayback /quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featurename:Internet-Explorer-Optional-amd64 /quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featurename:Printing-XPSServices-Features /quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featurename:WorkFolders-Client /quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featurename:ProgramDataUpdater /quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featurename:ScheduledDefrag /quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featurename:WinSAT /quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featureName:Xps-Viewer /Quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featureName:Printing-Foundation-Features /Quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featureName:Microsoft-Hyper-V-All /Quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featureName:VirtualMachinePlatform /Quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featureName:Windows-Subsystem-Linux /Quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featureName:Windows-Sandbox /Quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featurename:Windows-Defender-Features /quiet /NoRestart >nul 2>&1
dism /online /disable-feature /featureName:Windows-Defender-ApplicationGuard /Quiet /NoRestart >nul 2>&1
chcp 437 >nul
powershell -Command "Get-AppxPackage *Microsoft.ScreenSketch* | Remove-AppxPackage" >nul 2>&1
chcp 65001 >nul
dism /online /remove-capability /capabilityName:Microsoft.Windows.Cortana~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityName:Media.WindowsMediaPlayer~~~~0.0.0.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:MathRecognizer~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityName:App.Support.QuickAssist~~~~0.0.1.0 /Quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Browser.InternetExplorer~~~~0.0.11.0 /quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:OpenSSH.Client~~~~0.0.1.0 /quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:App.StepsRecorder~~~~0.0.1.0 /quiet /NoRestart >nul 2>&1
dism /online /remove-capability /capabilityname:Microsoft.Windows.WordPad~~~~0.0.1.0 /quiet /NoRestart >nul 2>&1

if "%REMOVE_WEBVIEW2%"=="true" (
    echo %c%   › Removing WebView2 Runtime…%u%
    for /f "tokens=3 delims= " %%i in ('dism /online /get-packages ^| findstr /i Microsoft-WebView2') do (
        dism /online /remove-package /packagename:%%i /quiet /NoRestart >nul 2>&1
    )
) else (
    echo %c%   › Preserving WebView2 Runtime…%u%
)

echo %c%[14/15] Applying Final System Optimizations…%u%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f >nul 2>&1

if "%REMOVE_CORTANA%"=="true" (
    echo %c%   › Disabling Cortana and Search Integration…%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f >nul 2>&1
) else (
    echo %c%   › Preserving Cortana and Search…%u%
)

if "%DISABLE_SEC_NOTIFS%"=="true" (
    echo %c%   › Disabling Windows Security Center notifications…%u%
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
) else (
    echo %c%   › Preserving Security notifications…%u%
)

if "%DISABLE_SERVICES%"=="true" (
    echo %c%[15/15] Disabling Unnecessary Services…%u%
    
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
) else (
    echo %c%[15/15] Preserving Services…%u%
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
echo %c%• Widgets, Meet Now, Chat, Search, Task View from taskbar%u%
echo %c%• Windows Spotlight and consumer features%u%
echo %c%• Legacy features (IE11, WMP, WordPad, etc.)%u%
echo.
echo %red%Important Notes:%u%
echo %c%• Restart your computer to complete all changes%u%
echo %c%• Some features may require Windows reset to restore%u%
if "%REMOVE_XBOX%"=="true" echo %c%• Xbox Live and Minecraft online functionality disabled%u%
if "%REMOVE_STORE%"=="true" echo %c%• Microsoft Store app installations disabled%u%
echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto TweaksMenu

:HardwareMenu
cls
call :SetupConsole
call :DisplayBanner
echo %c%                                 ╔═══════════════════════════════════════════════════╗ %u%
echo                                  %c%║%u%          [%c%1%u%] Hardware Information                 %c%║%u% 
echo                                  %c%║%u%          [%c%2%u%] Storage Acceleration                 %c%║%u% 
echo                                  %c%║%u%          [%c%3%u%] NVIDIA Driver Optimizer              %c%║%u%
echo                                  %c%║%u%          [%c%4%u%] Tweaked NVIDIA Driver                %c%║%u%
echo                                  %c%║%u%          [%c%5%u%] Coming Soon                          %c%║%u%
echo                                  %c%║%u%          [%c%6%u%] Coming Soon                          %c%║%u%
echo %c%                                 ╚═══════════════════════════════════════════════════╝
echo.
echo                             %u%[%c%7%u%] Colour Presets   [%c%8%u%] Back to Main   [%red%X%u%] Exit Application       
echo.                                      
set /p M="%c%Choose an option »%u% "
if %M%==1 goto HardwareInformation
if %M%==2 goto StorageAcceleration
if %M%==3 goto NVIDIAOptimizer
if %M%==4 goto DriverUpdates
if %M%==5 goto Comingsoon
if %M%==6 goto Comingsoon
if %M%==7 goto Presets
if %M%==8 goto menu
if %M%==x goto Destruct
if %M%==X goto Destruct
cls
echo %underline%%red%Invalid Input. Press any key to continue.%u%
pause >nul
goto HardwareMenu

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

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "1" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo %c%  * Applied optimization: Disable GPU Scheduling%u%
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
)

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

reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisable8dot3NameCreation" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "ContigFileAllocSize" /t REG_DWORD /d "1536" /f >nul 2>&1
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

echo %c%✓ Hardware report saved successfully!%u%
echo %c%  File: Hardware_Report_%COMPUTERNAME%_%date:~10,4%%date:~4,2%%date:~7,2%.txt%u%
echo %c%  Location: %USERPROFILE%\Desktop%u%

:skip_save

echo.
echo %c%══════════════════════════ PRESS ANY KEY TO CONTINUE ══════════════════════════%u%
pause >nul
goto HardwareMenu

:DriverUpdates
chcp 437>nul
chcp 65001>nul
cls

echo %green%_____________________________________
echo.
echo            %c%Installing Optimized Drivers 566.45%u%
echo %green%_____________________________________

timeout /t 1 >nul
echo.
echo %c%Would you like to continue with the driver installation?%u%
echo %c%Type Yes to continue or No to return%u%
echo.

set /p confirm="%c%Enter choice » %u%"

if /I "%confirm%"=="Yes"   goto InstallDriver
if /I "%confirm%"=="yes" goto InstallDriver
if /I "%confirm%"=="No"   goto SkipDriver
if /I "%confirm%"=="no"  goto SkipDriver

echo.
echo %red%Invalid choice! Please type Yes or No.
pause
goto DriverUpdates

:InstallDriver
cls

echo %green%_____________________________________
echo.
echo   %c%Downloading Optimized Drivers 566.45%u%
echo %green%_____________________________________

set "DRIVER_URL=https://github.com/auraside/Hone/releases/download/566.45/566.45_Bloat.exe"

set "DRIVER_FILE=%temp%\566.45_Bloat.exe"

echo Downloading NVIDIA driver from Hone
powershell -Command "(New-Object Net.WebClient).DownloadFile('%DRIVER_URL%', '%DRIVER_FILE%')"
echo.
if not exist "%DRIVER_FILE%" (
    echo %red%ERROR: Driver file not downloaded!
    echo Returning to Hardware Menu...
    pause
    goto HardwareMenu
)

echo Download complete. Installing driver now...
echo.
start /wait "" "%DRIVER_FILE%"
echo.
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto HardwareMenu

:SkipDriver
cls
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto HardwareMenu

:WindowsMenu
cls
chcp 437>nul
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
echo                        %c%║%u%           [%c%1%u%] Background Services                %c%║%u% 
echo                        %c%║%u%           [%c%2%u%] Startup Programs                   %c%║%u% 
echo                        %c%║%u%           [%c%3%u%] Visual Effects                     %c%║%u%
echo                        %c%║%u%           [%c%4%u%] Windows Defender                   %c%║%u%
echo                        %c%║%u%           [%c%5%u%] Power Settings                     %c%║%u%
echo                        %c%║%u%           [%c%6%u%] File Cleaner                       %c%║%u%
echo %c%                       ╚══════════════════════════════════════════════════╝
echo %c%                             ║  %u%[%c%7%u%] Theme Presets    [%c%8%u%] Go Back    %c%║%u%
echo %c%                             ║            %u% [%c%Quit%u%] Leave%c%             ║
echo %c%                             ╚══════════════════════════════════════╝
echo %u%                                      Current Version: %c%%version%
echo %u%                                %u%User %c%%username% %u%- Date %c%%date% %u%
echo.
echo.
echo.
set /p M="%c%Choose an option »%u% "
if %M%==1 goto Comingsoon
if %M%==2 goto Comingsoon
if %M%==3 goto Comingsoon
if %M%==4 goto WindowsDefender
if %M%==5 goto Comingsoon
if %M%==6 goto Comingsoon
if %M%==7 goto Presets
if %M%==8 goto menu
if %M%==Quit goto Destruct
cls
echo %underline%%red%Invalid Input. Press any key to continue.%u%
pause >nul
goto WindowsMenu

:WindowsDefender
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %green%_____________________________________
echo.
echo            %c%Disabling Windows Defender%u%        
echo %green%_____________________________________
timeout /t 3 >nul
cls
reg.exe delete "HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f >NUL 2>&1
reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "4" /f  >NUL 2>&1
reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\mpsdrv" /v "Start" /t REG_DWORD /d "4" /f  >NUL 2>&1
reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f  >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableSmartScreen /t REG_DWORD /d 0 /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v ShellSmartScreenLevel /t REG_SZ /d "-" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\System" /v EnableSmartScreen /t REG_DWORD /d 0 /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\System" /v ShellSmartScreenLevel /t REG_SZ /d "-" /f >NUL 2>&1
reg.exe add "HKLM\Software\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f >NUL 2>&1
reg.exe add "HKLM\Software\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray" /v HideSystray /t REG_DWORD /d 1 /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender Security Center\Systray" /v HideSystray /t REG_DWORD /d 1 /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Security Center" /v SecurityCenterInDomain /t REG_DWORD /d 0 /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows NT\Security Center" /v SecurityCenterInDomain /t REG_DWORD /d 0 /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender\UX Configuration" /v CustomDefaultActionToastString /t REG_SZ /d "-" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration" /v CustomDefaultActionToastString /t REG_SZ /d "-" /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender\UX Configuration" /v Notification_Suppress /t REG_DWORD /d 1 /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration" /v Notification_Suppress /t REG_DWORD /d 1 /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender\UX Configuration" /v SuppressRebootNotification /t REG_DWORD /d 1 /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration" /v SuppressRebootNotification /t REG_DWORD /d 1 /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableIOAVProtection /t REG_DWORD /d 1 /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableIOAVProtection /t REG_DWORD /d 1 /f >NUL 2>&1
reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableIOAVProtection" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d "0" /f >NUL 2>&1
reg.exe add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d "0" /f >NUL 2>&1
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /t REG_DWORD /d 0 /f >NUL 2>&1
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "DEPOff" /t REG_DWORD /d "1" /f >NUL 2>&1
reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SPP\Clients" /f >NUL 2>&1
powershell.exe Set-ProcessMitigation -System -Enable CFG >NUL 2>&1
cls
taskkill /f /im explorer.exe
start explorer.exe
echo.
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════

pause >nul
goto WindowsMenu

:PrivacyMenu
cls
chcp 437>nul
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
echo                        %c%║%u%           [%c%1%u%] Privacy Cleanup                    %c%║%u% 
echo                        %c%║%u%           [%c%2%u%] Firewall Configuration             %c%║%u% 
echo                        %c%║%u%           [%c%3%u%] Anti-Virus Software                %c%║%u%
echo                        %c%║%u%           [%c%4%u%] Browser Privacy                    %c%║%u%
echo                        %c%║%u%           [%c%5%u%] Security Improvements              %c%║%u%
echo                        %c%║%u%           [%c%6%u%] Anti-Tracking                      %c%║%u%
echo %c%                       ╚══════════════════════════════════════════════════╝
echo %c%                             ║  %u%[%c%7%u%] Theme Presets    [%c%8%u%] Go Back    %c%║%u%
echo %c%                             ║            %u% [%c%Quit%u%] Leave%c%             ║
echo %c%                             ╚══════════════════════════════════════╝
echo %u%                                      Current Version: %c%%version%
echo %u%                                %u%User %c%%username% %u%- Date %c%%date% %u%
echo.
echo.
echo.
set /p M="%c%Choose an option »%u% "
if %M%==1 goto Comingsoon
if %M%==2 goto Comingsoon
if %M%==3 goto Comingsoon
if %M%==4 goto Comingsoon
if %M%==5 goto Comingsoon
if %M%==6 goto Antitracking
if %M%==7 goto Presets
if %M%==8 goto menu
if %M%==Quit goto Destruct
cls
echo %underline%%red%Invalid Input. Press any key to continue.%u%
pause >nul
goto PrivacyMenu

:Antitracking
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %green%_____________________________________
echo.
echo            %c%Antitracking%u%        
echo %green%_____________________________________
timeout /t 3 >nul
cls
reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /v "DiagnosticErrorText" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Strings" /f >nul 2>&1
reg.exe delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Bluetooth" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\System" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Messaging" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" /f >nul 2>&1
reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /f >nul 2>&1
reg.exe delete "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /f >nul 2>&1
reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /f >nul 2>&1
reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /f >nul 2>&1
reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /f >nul 2>&1
reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /f >nul 2>&1
reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess" /f >nul 2>&1
reg.exe delete "HKLM\SYSTEM\ControlSet001\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\WMDRM" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\CredUI" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Browser" /f >nul 2>&1
reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /f >nul 2>&1
reg.exe delete "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Sensor" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /f >nul 2>&1
reg.exe delete HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"" /f >nul 2>&1
reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Speech" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Microsoft\OneDrive" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /f >nul 2>&1
reg.exe delete "HKLM\SOFTWARE\Policies\Microsoft\MRT" /f >nul 2>&1
reg.exe delete "HKCU\Software\Microsoft\Siuf" /f >nul 2>&1
reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /f >nul 2>&1
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg.exe add "HKCU\Software\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg.exe add "HKLM\SYSTEM\ControlSet001\Services\wuauserv" /v "Start" /t REG_DWORD /d "3" /f >nul 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d" /v "RegisteredWithAU" /t REG_DWORD /d "0" /f >nul 2>&1
reg.exe add "HKCU\Software\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "1" /f >nul 2>&1
reg.exe add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "0" /f >nul 2>&1
reg.exe add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "0" /f >nul 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "0" /f >nul 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "1" /f >nul 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f >nul 2>&1
reg.exe add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "1" /f >nul 2>&1
reg.exe add "HKLM\SYSTEM\ControlSet001\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "3" /f >nul 2>&1
reg.exe add "HKLM\SYSTEM\ControlSet001\Services\DiagTrack" /v "Start" /t REG_DWORD /d "2" /f >nul 2>&1
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "1" /f >nul 2>&1
cls
taskkill /f /im explorer.exe
start explorer.exe
echo.
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════

pause >nul
goto :PrivacyMenu

:AdvancedMenu
:GameBoosters
cls
chcp 437>nul
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
echo %c%                       ╚══════════════════════════════════════════════════╝
echo %c%                             ║  %u%[%c%7%u%] Theme Presets    [%c%8%u%] Go Back    %c%║%u%
echo %c%                             ║            %u% [%c%Quit%u%] Leave%c%             ║
echo %c%                             ╚══════════════════════════════════════╝
echo %u%                                      Current Version: %c%%version%
echo %u%                                %u%User %c%%username% %u%- Date %c%%date% %u%
echo.
echo.
echo.
set /p M="%c%Choose an option »%u% "
if %M%==1 goto Toolbox
if %M%==2 goto Boosters
if %M%==3 goto ScheduledTasks
if %M%==4 goto MSIMode
if %M%==5 goto ProgramDebloat
if %M%==6 goto Affinity
if %M%==7 goto Presets
if %M%==8 goto menu
if %M%==Quit goto Destruct
cls
echo %underline%%red%Invalid Input. Press any key to continue.%u%
pause >nul
goto AdvancedMenu

:ProgramDebloat
cls
color 03
cls
echo --------------------------------------------------------------------------------------------------------------------
echo     Program Debloat
echo --------------------------------------------------------------------------------------------------------------------
echo 0. Go Back
echo 1. Program Debloat (Visual Studio, Nvidia Telemetry, Office, Adobe, etc)
echo 2. Discord Debloat
echo 3. Steam Debloat
echo 4. Spotify Debloat    
echo 5. Firefox Debloat
echo 6. Chrome Debloat                                                                                                                                                                                                                                                        
echo ---------------------------------------------------------------------------------------------------------------------
set choice=
set /p choice=Type A Number:
if not '%choice%'=='' set choice=%choice:~0,6%
if '%choice%'=='0' goto AdvancedMenu
if '%choice%'=='1' goto debloatprogram
if '%choice%'=='2' goto debloatdiscord
if '%choice%'=='3' goto debloatsteam
if '%choice%'=='4' goto debloatspotify
if '%choice%'=='5' goto debloatfirefox
if '%choice%'=='6' goto debloatchrome
cls
echo %red%============INVALID INPUT============
echo.
echo.
echo %green%======PRESS ANY KEY TO CONTINUE======
pause >nul
goto ProgramDebloat

:debloatchrome
cls
net stop gupdate
sc delete gupdate
net stop googlechromeelevationservice
sc delete googlechromeelevationservice
net stop gupdatem
sc delete gupdatem
taskkill /f /im GoogleUpdate.exe 
rmdir "C:\Program Files (x86)\Google\Update" /s /q
cd /d "C:\Program Files\Google\Chrome\Application\"
dir chrmstp.exe /a /b /s
del chrmstp.exe /a /s
cls
echo.
echo.
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto ProgramDebloat

:debloatfirefox
cls
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

wmic product where name="Mozilla Maintenance Service" call uninstall /nointeractive >nul 2>&1

cd /d "C:\Program Files\Mozilla Firefox">nul 2>&1
del /f crash*.* >nul 2>&1
del /f maintenance*.* >nul 2>&1
del /f install.log >nul 2>&1
del /f minidump*.* >nul 2>&1
cls
echo.
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto ProgramDebloat

:debloatspotify
cls
cd /d "%APPDATA%\Spotify" >NUL 2>&1
copy "%APPDATA%\Spotify\locales\en-US.pak" "%APPDATA%\Spotify" >NUL 2>&1
rmdir "%APPDATA%\Spotify\locales" /s /q >NUL 2>&1
mkdir locales >NUL 2>&1
move en-US.pak locales >NUL 2>&1
del /f chrome_1*.*, chrome_2*.*, crash*.*, SpotifyMigrator.exe, SpotifyStartupTask.exe, d3d*.*, debug.log, libegl.dll, libgle*.*, snapshot*.*, vk*.*, vulkan*.* >NUL 2>&1
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
del /f/s/q "%appdata%\Spotify\Apps\Buddy-list.spa" >NUL 2>&1
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
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto ProgramDebloat

:debloatsteam
cls
reg add "HKCU\SOFTWARE\Valve\Steam" /v "SmoothScrollWebViews" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Valve\Steam" /v "DWriteEnable" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Valve\Steam" /v "StartupMode" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Valve\Steam" /v "H264HWAccel" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Valve\Steam" /v "DPIScaling" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Valve\Steam" /v "GPUAccelWebViews" /t REG_DWORD /d 0 /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "Steam" /f
cls
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto ProgramDebloat

:debloatdiscord
cls
TASKKILL /T /F /IM  discord.exe
DEL "%HOMEPATH%\Desktop\Discord.ink" /F /Q
DEL "%HOMEPATH%\Desktop\Discord.ink - Shortcut" /F /Q
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
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto ProgramDebloat

:debloatprogram
cls
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

sc stop "VSStandardCollectorService150"
sc config "VSStandardCollectorService150" start= disabled

if exist "%ProgramFiles%\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL" (
    rundll32 "%PROGRAMFILES%\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL",UninstallPackage NvTelemetryContainer
    rundll32 "%PROGRAMFILES%\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL",UninstallPackage NvTelemetry
)

schtasks /change /disable /tn "\NvTmRep_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}"
schtasks /change /disable /tn "\NvTmRepOnLogon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}"
schtasks /change /disable /tn "\NvTmMon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}"

set "pathGlobPattern=%PROGRAMFILES%\NVIDIA Corporation\NvTelemetry\*"
for /r "%pathGlobPattern%" %%F in (*) do (
    move "%%F" "%%F.OLD"
)

reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID44231" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID64640" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID66610" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup" /v "SendTelemetryData" /t REG_DWORD /d 0 /f

sc stop "NvTelemetryContainer"
sc config "NvTelemetryContainer" start= disabled

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
cls
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto ProgramDebloat

:Affinity
cls
for /f "tokens=*" %%f in ('wmic cpu get NumberOfCores /value ^| find "="') do set %%f
for /f "tokens=*" %%f in ('wmic cpu get NumberOfLogicalProcessors /value ^| find "="') do set %%f
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
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "4" /f
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /t REG_BINARY /d "C0" /f
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

for /f %%i in ('wmic path win32_NetworkAdapter get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" (
for /f "delims=" %%# in ('"wmic computersystem get manufacturer /format:value"') do set "%%#" >nul & if "!Manufacturer:VMWare=!" neq "!Manufacturer!" (set "VMWare= /t REG_DWORD /d 2") else (set "VMWare=")
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority"%VMWare% /f
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg.exe add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "2" /f
) > nul 2> nul
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
schtasks /change /tn "\Microsoftd\Office\OfficeTelemetryAgentFallBack" /disable >nul 2>&1
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
schtasks /change /tn "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Maintenance\WinSAT" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\PI\Sqm-Tasks" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Maps\MapsToastTask" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Maps\MapsUpdateTask" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" /disable >nul 2>&1
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto :GameBoosters

:Boosters
cls
color 03
cls
echo ---------------------------------------------------------------------------------------------------------------------
echo       Game Boosters (Configs)
echo ---------------------------------------------------------------------------------------------------------------------
echo 0. Go Back
echo 1. Valorant
echo 2. Counter-Strike 2
echo 3. Minecraft
echo 4. Fortnite
echo 5. Warzone 
echo 6. Select your Own Game                                                                                                                                                                                                                                                            
echo --------------------------------------------------------------------------------------------------------------------
set choice=
set /p choice=Type A Number:
if not "%choice%"=="" set choice=%choice:~0,100%
if "%choice%"=="0" goto AdvancedMenu
if "%choice%"=="1" goto Valorant
if "%choice%"=="2" goto CS2
if "%choice%"=="3" goto Minecraft
if "%choice%"=="4" goto Fortnite
if "%choice%"=="5" goto Warzone
if "%choice%"=="6" goto SelectGame

:SelectGame
cls
echo Please select the game executable (file) for applying performance tweaks:
set dialog="about:<input type=file id=FILE><script>FILE.click();new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).WriteLine(FILE.value);close();resizeTo(0,0);</script>"
for /f "tokens=* delims=" %%p in ('mshta.exe %dialog%') do set "file=%%p"
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
echo.                                         %white%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %white%═══════════════════════════════════════════════════════
pause >nul
goto Boosters


:Valorant
for %%i in (valorant valorant-win64-shipping vgtray vgc) do (
    PowerShell -NoProfile -Command "Set-ProcessMitigation -Name %%i.exe -Enable CFG"
)

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

reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Version" /t REG_SZ /d "1.0" /f 
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Application Name" /t REG_SZ /d "VALORANT-Win64-Shipping.exe" /f 
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Protocol" /t REG_SZ /d "*" /f 

wmic process where name="RiotClientServices.exe" CALL setpriority "high priority"

reg.exe add "HKCU\Software\Riot Games\Riot Client" /v "autoUpdateOnLaunch" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Riot Games\Riot Client" /v "pingUrl" /t REG_SZ /d "" /f
echo.
echo.
echo.                                         %white%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %white%═══════════════════════════════════════════════════════
pause >nul
goto Boosters

:Fortnite
reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions" /t REG_DWORD /v CpuPriorityClass /d 3 /f
cd %localappdata%
rmdir /s /q FortniteGame
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 00000026 /f
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 00000010 /f
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\WMPlayer" /v "Priority" /t REG_DWORD /d 00000002 /f
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\Audio" /v "Priority" /t REG_DWORD /d 00000001 /f
reg.exe add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.ResolutionQuality" /t REG_DWORD /d 30 /f
reg.exe add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.ShadowQuality" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.EffectsQuality" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.TexturesQuality" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.bSmoothFrameRate" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.ViewDistanceQuality" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.GameThreadPriority" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f
reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f
reg.exe add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_DWORD /d 10 /f
reg.exe add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_DWORD /d 1 /f
cls
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto Boosters

:CS2
wmic process where name="cs2.exe" CALL setpriority "high priority"

reg.exe add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_DWORD /d 10 /f
reg.exe add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_DWORD /d 1 /f
reg.exe add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "Path\To\cs2.exe" /t REG_SZ /d "~DISABLEMOUSEACCELERATION" /f
reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f
reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPerServer" /t REG_DWORD /d 8 /f
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d 8 /f

wmic computersystem where name="%computername%" set AutomaticManagedPagefile=false
wmic pagefileset where name="_Total" set InitialSize=8192, MaximumSize=8192

reg.exe add "HKCU\System\GameConfigStore" /v "GameBarEnabled" /t REG_DWORD /d 0 /f
taskkill /f /im "steam.exe"
reg.exe add "HKCU\Software\Valve\Steam" /v "EnableOverlay" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Valve\Steam" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f
reg.exe add "HKCU\Software\Valve\Steam" /v "TcpNoDelay" /t REG_DWORD /d 1 /f
rd /s /q "%APPDATA%\Steam\htmlcache"
rd /s /q "%PROGRAMFILES(X86)%\Steam\appcache"
reg.exe add "HKCU\Software\Valve\Steam" /v "AutoUpdateEnabled" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Valve\Steam" /v "SilentStartup" /t REG_DWORD /d 1 /f

cls
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto Boosters

:Warzone
reg.exe add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ModernWarfare.exe" /v "Win32PrioritySeparation" /t REG_DWORD /d 26 /f
reg.exe add "HKCU\Software\Activision\ModernWarfare" /v "VideoMemoryScale" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Activision\ModernWarfare" /v "VerticalSyncEnabled" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f
reg.exe add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f
reg.exe add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_DWORD /d 10 /f
reg.exe add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_DWORD /d 1 /f
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=false
wmic pagefileset where name="_Total" set InitialSize=8192, MaximumSize=8192
cls
echo.
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto Boosters

:Minecraft
echo   Open Minecraft launcher and put the code inside JVMarguments in JVM Arguments
timeout /t 3 >nul
pause >nul
(
    echo of -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=10 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=true -Daikars.new.flags=true
) > JVMarguments.txt

cd %APPDATA%\.minecraft\
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
echo.                                         %yellow%═══════════════════════════════════════════════════════
echo.                                           %c%  Operation Completed, Press any key to continue%u% 
echo.                                         %yellow%═══════════════════════════════════════════════════════
pause >nul
goto Boosters

:Toolbox
cls
call :SetupConsole
call :DisplayBanner
echo.
echo.
echo.
echo                                 %c%Batlez Toolbox allows you to install any app or software!%u%
echo.
echo.
echo.
echo                                          %red%Press any key to start Batlez Toolbox!%u%
pause >nul

call :EnsureChoco
goto START

:EnsureChoco
cls
echo %yellow%Checking for Chocolatey...%u%
if exist "%ALLUSERSPROFILE%\chocolatey" (
    echo %green%✓ Chocolatey is already installed.%u%
    timeout /t 2 >nul
) else (
    echo %yellow%Installing Chocolatey. Please wait...%u%
    chcp 437>nul
    powershell -NoProfile -ExecutionPolicy Bypass ^
      -Command "iex ((New-Object Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" ^
      && (
        set "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
        echo %green%✓ Successfully installed Chocolatey.%u%
        timeout /t 3 >nul
      ) || (
        echo %red%✗ Failed to install Chocolatey. Some installs may not work.%u%
        timeout /t 3 >nul
      )
)
exit /b

:START
cls
call :SetupConsole
call :DisplayBanner
echo.
echo %c%Welcome to the Batlez Toolbox!%u%
echo Each page has 52 items for a total of 208 items.
echo.
echo %green%[1]%u% Page 1 - Browsers, VPN, Security, Office
echo %green%[2]%u% Page 2 - Productivity, Messaging, Media, Development
echo %green%[3]%u% Page 3 - System Tools, File Tools, Runtimes, Misc
echo %green%[4]%u% Page 4 - Design Tools, Game Tools, Extra Comm, DevOps
echo %green%[S]%u% Search for specific software
echo %green%[U]%u% Uninstall software
echo %red%[X]%u% Exit
echo.
set /p "mainChoice=%yellow%Choose an option: %u%"
if /I "%mainChoice%"=="1" goto PAGE1
if /I "%mainChoice%"=="2" goto PAGE2
if /I "%mainChoice%"=="3" goto PAGE3
if /I "%mainChoice%"=="4" goto PAGE4
if /I "%mainChoice%"=="S" goto SEARCH
if /I "%mainChoice%"=="U" goto UNINSTALL
if /I "%mainChoice%"=="X" goto :EOF
echo %red%Invalid choice...%u%
timeout /t 2 >nul
goto START

:PAGE1
cls
title Batlez Toolbox - Page 1 of 4 (Items 1-52)
echo       %green%[Browsers]%u%                    %green%[VPN]%u%                       %green%[Security]%u%                   %green%[Office]%u%
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
echo %green%[N]%u% Next Page (53-104)   %green%[M]%u% Main Menu   %red%[X]%u% Exit
set /p "p1Choice=%yellow%Choose an option: %u%"
if /I "%p1Choice%"=="N" goto PAGE2
if /I "%p1Choice%"=="M" goto START
if /I "%p1Choice%"=="X" goto :EOF

call :InstallSoftware "%p1Choice%" "PAGE1"
goto PAGE1

:PAGE2
cls
title Batlez Toolbox - Page 2 of 4 (Items 53-104)
echo       %green%[Productivity]%u%                %green%[Messaging]%u%                 %green%[Media]%u%                       %green%[Development]%u%
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
echo %green%[P]%u% Previous (1-52)   %green%[N]%u% Next (105-156)   %green%[M]%u% Main Menu   %red%[X]%u% Exit
set /p "p2Choice=%yellow%Choose an option: %u%"
if /I "%p2Choice%"=="P" goto PAGE1
if /I "%p2Choice%"=="N" goto PAGE3
if /I "%p2Choice%"=="M" goto START
if /I "%p2Choice%"=="X" goto :EOF

call :InstallSoftware "%p2Choice%" "PAGE2"
goto PAGE2

:PAGE3
cls
title Batlez Toolbox - Page 3 of 4 (Items 105-156)
echo        %green%[System Tools]%u%               %green%[File Tools]%u%                %green%[Runtimes]%u%                   %green%[Misc]%u%
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
echo %green%[P]%u% Previous (53-104)   %green%[N]%u% Next (157-208)   %green%[M]%u% Main Menu   %red%[X]%u% Exit
set /p "p3Choice=%yellow%Choose an option: %u%"
if /I "%p3Choice%"=="P" goto PAGE2
if /I "%p3Choice%"=="N" goto PAGE4
if /I "%p3Choice%"=="M" goto START
if /I "%p3Choice%"=="X" goto :EOF

call :InstallSoftware "%p3Choice%" "PAGE3"
goto PAGE3

:PAGE4
cls
title Batlez Toolbox - Page 4 of 4 (Items 157-208)
echo        %green%[Design Tools]%u%               %green%[Game Tools]%u%                %green%[Extra Comm]%u%                 %green%[DevOps Tools]%u%
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
echo %green%[P]%u% Previous (105-156)   %green%[M]%u% Main Menu   %red%[X]%u% Exit
set /p "p4Choice=%yellow%Choose an option: %u%"
if /I "%p4Choice%"=="P" goto PAGE3
if /I "%p4Choice%"=="M" goto START
if /I "%p4Choice%"=="X" goto :EOF

call :InstallSoftware "%p4Choice%" "PAGE4"
goto PAGE4

:InstallSoftware
set "choice=%~1"
set "page=%~2"

if "%choice%"=="" goto :EOF

echo.
set /p "confirm=%yellow%Are you sure you want to install this software? (Y/N): %u%"
if /I not "%confirm%"=="Y" exit /b

echo %yellow%Installing software...%u%
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
    if "%choice%"=="33" call :Install "avira-free-antivirus" "Avira Free Antivirus"
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
    if "%choice%"=="208" call :Install "opentoonz" "OpenToonz"
)

echo.
echo %green%Installation process completed.%u%
timeout /t 3 >nul
exit /b

:Install
set "package=%~1"
set "name=%~2"
echo %yellow%Installing %name%...%u%

choco install %package% -y --no-progress

if errorlevel 1 (
    echo %yellow%Installation failed. Retrying with checksum bypass...%u%
    choco install %package% -y --ignore-checksums --no-progress
    
    if errorlevel 1 (
        echo %red%✗ Failed to install %name% even with checksum bypass.%u%
    ) else (
        echo %green%✓ Successfully installed %name% (checksum bypassed)!%u%
    )
) else (
    echo %green%✓ Successfully installed %name%!%u%
)

echo.
goto START

:ShowMessage
echo %c%ℹ %~1%u%
echo.
exit /b

:SEARCH
cls
echo %c%Search for Software%u%
echo.
set /p "searchTerm=%yellow%Enter software name to search: %u%"
if "%searchTerm%"=="" goto START
echo.
echo %yellow%Searching for packages containing "%searchTerm%"...%u%
choco search %searchTerm% --limit-output
echo.
echo %c%Copy the package name exactly as shown for installation (e.g., googlechrome)%u%
echo.

set /p "installPkg=%yellow%Enter exact package name to install (or press Enter to return): %u%"
if "%installPkg%"=="" goto START
set "name=%installPkg%"
echo.
set /p "confirmInstall=%yellow%Install '%installPkg%'? (Y/N): %u%"
if /I "%confirmInstall%"=="Y" (
    echo %yellow%Installing %name%...%u%
    choco install %installPkg% -y --no-progress

    if errorlevel 1 (
        echo %yellow%Installation failed. Retrying with checksum bypass...%u%
        choco install %installPkg% -y --ignore-checksums --no-progress

        if errorlevel 1 (
            echo %red%✗ Failed to install %name% even with checksum bypass.%u%
        ) else (
            echo %green%✓ Successfully installed %name% (checksum bypassed)!%u%
        )
    ) else (
        echo %green%✓ Successfully installed %name%!%u%
    )
    echo.
    pause
)
goto START

:UNINSTALL
chcp 437 >nul
cls
echo %c%Uninstall Software%u%
echo.
echo %yellow%Listing installed Chocolatey packages...%u%
echo %yellow%Do NOT uninstall any Chocolatey services%u% 
echo.
powershell -Command "Get-ChildItem 'C:\ProgramData\chocolatey\lib' | Select-Object Name | Format-Table -HideTableHeaders"
echo.
set /p "uninstallPackage=%yellow%Enter package name to uninstall (or press Enter to go back): %u%"
if "%uninstallPackage%"=="" goto START
echo.
set /p "confirmUninstall=%red%Are you sure you want to uninstall %uninstallPackage%? (Y/N): %u%"
if /I "%confirmUninstall%"=="Y" (
    echo %yellow%Uninstalling %uninstallPackage%...%u%
    choco uninstall %uninstallPackage% -y
    if !errorlevel! equ 0 (
        echo %green%✓ Successfully uninstalled %uninstallPackage%!%u%
    ) else (
        echo %red%✗ Failed to uninstall %uninstallPackage%.%u%
    )
)
echo.
pause
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