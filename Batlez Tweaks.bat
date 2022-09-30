@echo off
set version=1.6
title Batlez Tweaks - %version% 
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

:variables
set g=[92m
set r=[91m
set red=[04m
set l=[1m
set w=[0m
set b=[94m
set m=[95m
set p=[35m
set c=[35m
set d=[96m
set u=[0m
set z=[91m
set n=[96m
set y=[40;33m
set g2=[102m
set r2=[101m
set t=[40m

:: Webhook
SET webhook=


:loading
chcp 65001 >nul
cls
echo.
echo.
echo.
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
echo %w%                                       Developed by Batlez#3740 
echo %w%                                   Thank you for using Batlez Tweaks
echo %w%                                     Press any key to get started            
echo.                                
pause >nul
:legit
cls
color a
echo.
echo.
echo.
echo.
echo %u%[%g%+%u%] %g%Successful! 
echo.
echo %u%Developed by: %g%Batlez#3740
echo %u%Github: %g%https://github.com/Batlez
echo.
echo.
echo.
echo.
timeout /t 5 >nul & cls & goto Presets

:Presets
cls
chcp 437>nul
echo Choose a Colour.
echo %b%Blue%u%, %d%Cyan%u%, %g%Green%u%, %y%Yellow%u% or %r%Red%u%.
set /p preset=
if /i %preset%==Blue goto Blue
if /i %preset%==Cyan goto Cyan
if /i %preset%==Yellow goto Yellow
if /i %preset%==Green goto Green
if /i %preset%==Red goto Red
echo %c%Please enter a valid option.
timeout /t 1 /nobreak >nul
goto Presets

:Blue
set c=%b%
set u=%u%
set d=%n%
goto menu

:Yellow
set c=%y%
set u=%u%
set d=%n%
goto menu

:Green
set c=%g%
set u=%u%
set d=%n%
goto menu

:Cyan
set c=%d%
set u=%u%
set d=%d%
goto menu

:Red
set c=%r%
set u=%u%
set d=%r%
goto menu

:menu
cls
chcp 437>nul
chcp 65001 >nul 
echo.
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
echo                                               [%c%1%u%] Tweaks      [%c%2%u%] Hardware
echo.
echo.
echo.
echo                                         [%c%3%u%] Windows   [%c%4%u%] Privacy   [%c%5%u%] Backup
echo.
echo.
echo.
echo                                               [%c%6%u%] Advanced      [%c%7%u%] More
echo. 
echo.
echo.
echo                                                       %c%[ X to close ]%u%  
echo.
set /p M="%c%Choose an option »%u% "
set choice=%errorlevel%
if %M%==1 goto TweaksMenu
if %M%==2 goto ComingSoon
if %M%==3 goto ComingSoon
if %M%==4 goto ComingSoon
if %M%==5 goto Backup
if %M%==6 goto ComingSoon
if %M%==7 goto ComingSoon
if %M%==X goto Destruct
goto Menu

:Comingsoon
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
echo.
echo.
echo                                    %c%Batlez is a tweaking script that optimizes your system%u% 
echo                                       %c%to provide the best gaming experience possible.%u%
echo.
echo.
echo.
echo.
echo                                %g%This feature has not been finished yet but will be coming out soon.  
echo.
echo.
echo.
echo.
echo                                                    %c%[ Press any key to go back ]%u%
pause >nul
goto:menu

:Backup
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
echo.
echo.
echo                                    %c%Batlez is a tweaking script that optimizes your system%u% 
echo                                       %c%to provide the best gaming experience possible.%u%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set /p input="%c%Would you like to create a Restore and Registry Point? (Y/N) »%u% "
    if "%input%"=="Y" goto tweaksmain
    if "%input%"=="N" goto menu
echo %c%Please enter a valid number!%u% & goto Backup
:: Credits to tarekifla
:tweaksmain
echo %c%Backing up the Registry...%u%
if not exist "C:\RegistryBackup\" mkdir C:\RegistryBackup
cd /d C:\RegistryBackup
REG SAVE HKLM\SOFTWARE SOFTWARE
REG SAVE HKLM\SYSTEM SYSTEM
REG SAVE HKU\.DEFAULT DEFAULT
REG SAVE HKLM\SECURITY SECURITY
REG SAVE HKLM\SAM SAM
echo %c%The Registry backup is located at "C:\Registry"%u%
timeout 2 >nul /nobreak
echo %c%Backup succesfully created!%u%
cls

:restorepoint2
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v SystemRestorePointCreationFrequency /t REG_DWORD /d 0 /f >nul
echo %c%Creating a restore point...%u%
timeout 2 >nul /nobreak
@powershell -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'Before Batlez Tweaks' -RestorePointType 'MODIFY_SETTINGS'"
set SR_STATUS=%ERRORLEVEL%
IF %SR_STATUS%==0 & echo %c%System Restore point made succesfully!%u%
timeout 3 >nul /nobreak
cls
IF NOT %SR_STATUS%==0 & echo %c%Failed to create a restore point, please make sure you have enabled protection in System!%u% 
timeout 3 >nul /nobreak
goto menu


:TweaksMenu
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
echo %c%                       ╔═════════════════════════════════╦════════════════════════════╗ %u%
echo                        %c%║%u% [%c%1%u%] Windows Cleaner             %c%║%u% [%c%7%u%] Mouse/Keyboard Tweaks  %c%║%u%
echo                        %c%║%u% [%c%2%u%] Custom Regedit              %c%║%u% [%c%8%u%] Internet Refresher     %c%║%u%
echo                        %c%║%u% [%c%3%u%] GPU Optimizations           %c%║%u% [%c%9%u%] Service Tweaks         %c%║%u%
echo                        %c%║%u% [%c%4%u%] Network Tweaks              %c%║%u% [%c%10%u%] Debloater             %c%║%u%
echo                        %c%║%u% [%c%5%u%] CPU Optimizations           %c%║%u% [%c%11%u%] Custom Power Plan     %c%║%u%
echo                        %c%║%u% [%c%6%u%] Memory Optimizer            %c%║%u% [%c%12%u%] Changelog             %c%║%u%
echo %c%                       ╚═════════════════════════════════╩════════════════════════════╝
echo %c%                             ║  %u% [%c%13%u%] Theme Presets       [%c%14%u%] Go Back          %c%║%u%
echo %c%                             ║                %u% [%c%Quit%u%] Leave%c%                     ║
echo %c%                             ╚══════════════════════════════════════════════════╝
echo %u%                                                Current Version: %c%%version%
echo %u%                                            %u%User %c%%username% %u%- Date %c%%date% %u%
echo.
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
if %M%==12 goto changelog
if %M%==13 goto Presets
if %M%==14 goto menu
if %M%==Quit goto Destruct
cls
echo %g%============INVALID INPUT============
echo.
echo.
echo %g%_____________________________________
echo.
echo %r%Please select a number from the Main
echo %r%Menu [1-14] or type 'Quit' to Leave.
echo %g%_____________________________________
echo.
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto TweaksMenu

:K
chcp 437>nul
chcp 65001 >nul
echo.
echo.
echo %g%_____________________________________
echo.
echo      %c%Applying Custom Power Plan%u%         
echo %g%_____________________________________
timeout /t 3 >nul
cls
powercfg -restoredefaultschemes
powershell Invoke-WebRequest "https://cdn.discordapp.com/attachments/556585726301700097/1022009094279790612/Batlez_Tweaks.pow" -OutFile "%temp%\Batlez_Tweaks.pow"
cls
powercfg /d 44444444-4444-4444-4444-444444444449 >nul 2>&1 
powercfg -import "%temp%\Batlez_Tweaks.pow" 44444444-4444-4444-4444-444444444449 >nul 2>&1 
powercfg -SETACTIVE "44444444-4444-4444-4444-444444444449" >nul 2>&1 
powercfg /changename 44444444-4444-4444-4444-444444444449 "Batlez's Power Plan" "The Ultimate Power Plan to increase FPS, improve latency and reduce input lag." >nul 2>&1 
del "%temp%\Batlez_Tweaks.pow"
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto TweaksMenu

:changelog
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %g%_____________________________________
echo.
echo              %c%Changelog%u%         
echo %g%_____________________________________
timeout /t 3 >nul
cls
start https://github.com/Batlez/Batlez/releases
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto TweaksMenu

:A
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %g%_____________________________________
echo.
echo           %c%Windows Cleaner%u%         
echo %g%_____________________________________
timeout /t 3 >nul
cls
del /s /f /q c:\windows\temp\*.*
rd /s /q c:\windows\temp
md c:\windows\temp
del /s /f /q %temp%\*.*
rd /s /q %temp%
md %temp%
del /s /f /q c:\windows\tempor~1
del /s /f /q c:\windows\temp
del /s /f /q c:\windows\tmp
del /s /f /q c:\windows\ff*.tmp
del /s /f /q c:\windows\history
del /s /f /q c:\windows\cookies
del /s /f /q c:\windows\recent
del /s /f /q c:\windows\spool\printers
del /s /f /q %userprofile%\Recent\*.*
del /s /f /q C:\Windows\Prefetch\*.*
del /s /f /q C:\Windows\Temp\*.*
del /s /f /q %USERPROFILE%\appdata\local\temp\*.*
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto TweaksMenu

:B
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %g%_____________________________________
echo.
echo         %c%Apply Custom Regedit%u%         
echo %g%_____________________________________
timeout /t 3 >nul
cls
bcdedit /deletevalue useplatformclock
bcdedit /deletevalue disabledynamictick
bcdedit /set useplatformtick Yes
bcdedit /set tscsyncpolicy Enhanced
bcdedit /set nx AlwaysOff
bcdedit /set bootmenupolicy legacy
bcdedit /set hypervisorlaunchtype off
bcdedit /set tpmbootentropy ForceDisable
bcdedit /set linearaddress57 OptOut
bcdedit /set firstmegabytepolicy UseAll 
bcdedit /set nolowmem Yes
bcdedit /set allowedinmemorysettings 0 
bcdedit /set isolatedcontext No 
cls
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001" /v "*RSSProfile" /t REG_SZ /d "3" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile" /v "ParamDesc" /t REG_SZ /d "RSS load balancing profile" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile" /v "default" /t REG_SZ /d "1" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile" /v "type" /t REG_SZ /d "enum" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile\Enum" /v "1" /t REG_SZ /d "ClosestProcessor" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile\Enum" /v "2" /t REG_SZ /d "ClosestProcessorStatic" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile\Enum" /v "3" /t REG_SZ /d "NUMAScaling" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile\Enum" /v "4" /t REG_SZ /d "NUMAScalingStatic" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile\Enum" /v "5" /t REG_SZ /d "ConservativeScaling" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableICMPRedirect" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d "2" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "32" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d "8760" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t REG_DWORD /d "8760" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectionsPerServer" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\MSMQ\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "1" /f
taskkill /f /im explorer.exe
start explorer.exe
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto TweaksMenu

:C
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %g%_____________________________________
echo.
echo         %c%GPU Optimizations (AMD)%u%              
echo %g%_____________________________________
timeout /t 3 >nul
cls
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalOptimizeEdpLinkRate" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalPSRFeatureEnable" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmL0s" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmL1" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisablePllOffInL1" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuClockGating" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuLightSleep" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableGPUVirtualizationFeature" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_BlockchainSupport" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_ChillEnabled" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableGDIAcceleration" /t Reg_DWORD /d "1" /f >nul 2>&1

::AMD Tweaks
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_DisableAutoWattman" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_DisableLightSleep" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3D_Refresh_Rate_Override_DEF" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3to2Pulldown_NA" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AAF_NA" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Adaptive De-interlacing" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowRSOverlay" /t Reg_SZ /d "false" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSkins" /t Reg_SZ /d "false" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSnapshot" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSubscription" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AntiAlias_NA" /t Reg_SZ /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AreaAniso_NA" /t Reg_SZ /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ASTT_NA" /t Reg_SZ /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AutoColorDepthReduction_NA" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSAMUPowerGating" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableUVDPowerGatingDynamic" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableVCEPowerGating" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL0s" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL1" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps_NA" /t Reg_SZ /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DeLagEnabled" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_FRTEnabled" /t Reg_DWORD /d "0" /f >nul 2>&1

echo %c%AMD Reg Keys%u%
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t Reg_DWORD /d "1" /f >nul 2>&1
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto TweaksMenu

:D
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %g%_____________________________________
echo.
echo            %c%Network Tweaks%u%             
echo %g%_____________________________________
timeout /t 3 >nul
cls
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
netsh int tcp set heuristics disabled 
netsh int tcp set supp internet congestionprovider=ctcp
netsh int tcp set global rss=enabled
netsh int tcp set global chimney=disabled
netsh int tcp set global ecncapability=enabled
netsh int tcp set global timestamps=disabled
netsh int tcp set global initialRto=3000
netsh int tcp set global timestamps=disabled 
netsh int tcp set global rsc=disabled 
netsh int tcp set global nonsackttresiliency=disabled
netsh int tcp set global MaxSynRetransmissions=2 
netsh int tcp set global fastopen=enabled
netsh int tcp set global fastopenfallback=enabled
netsh int tcp set global pacingprofile=off
netsh int tcp set global hystart=disabled
netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled
netsh int 6to4 set state state=enabled
netsh int udp set global uro=enabled
netsh winsock set autotuning on
netsh int tcp set supplemental template=custom icw=10
netsh interface teredo set state enterprise
netsh int tcp set security mpp=disabled
netsh int tcp set security profiles=disabled
netsh interface ipv4 set subinterface "Wi-Fi" mtu=1500 store=persistent
netsh interface ipv6 set subinterface "Ethernet" mtu=1500 store=persistent
netsh interface ipv6 set subinterface "Ethernet" mtu=1500 store=persistent
netsh interface ipv4 set subinterface "Wi-Fi" mtu=1500 store=persistent

for /f %%r in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /f "1" /d /s^|Findstr HKEY_') do (
Reg add %%r /v "NonBestEffortLimit" /t Reg_DWORD /d "0" /f 
Reg add %%r /v "DeadGWDetectDefault" /t Reg_DWORD /d "1" /f 
Reg add %%r /v "PerformRouterDiscovery" /t Reg_DWORD /d "1" /f
Reg add %%r /v "TCPNoDelay" /t Reg_DWORD /d "1" /f
Reg add %%r /v "TcpAckFrequency" /t Reg_DWORD /d "1" /f
Reg add %%r /v "TcpInitialRTT" /t Reg_DWORD /d "2" /f
Reg add %%r /v "TcpDelAckTicks" /t Reg_DWORD /d "0" /f
Reg add %%r /v "MTU" /t Reg_DWORD /d "1500" /f
Reg add %%r /v "UseZeroBroadcast" /t Reg_DWORD /d "0" /f
)

for /f %%a in ('Reg query HKLM /v "*WakeOnMagicPacket" /s ^| findstr  "HKEY"') do (
for /f %%i in ('Reg query "%%a" /v "*EEE" ^| findstr "HKEY"') do (Reg add "%%i" /v "*EEE" /t Reg_DWORD /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "*FlowControl" ^| findstr "HKEY"') do (Reg add "%%i" /v "*FlowControl" /t Reg_DWORD /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "EnableSavePowerNow" ^| findstr "HKEY"') do (Reg add "%%i" /v "EnableSavePowerNow" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "EnablePowerManagement" ^| findstr "HKEY"') do (Reg add "%%i" /v "EnablePowerManagement" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "EnableDynamicPowerGating" ^| findstr "HKEY"') do (Reg add "%%i" /v "EnableDynamicPowerGating" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "EnableConnectedPowerGating" ^| findstr "HKEY"') do (Reg add "%%i" /v "EnableConnectedPowerGating" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "AutoPowerSaveModeEnabled" ^| findstr "HKEY"') do (Reg add "%%i" /v "AutoPowerSaveModeEnabled" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "AdvancedEEE" ^| findstr "HKEY"') do (Reg add "%%i" /v "AdvancedEEE" /t Reg_DWORD /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "ULPMode" ^| findstr "HKEY"') do (Reg add "%%i" /v "ULPMode" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "ReduceSpeedOnPowerDown" ^| findstr "HKEY"') do (Reg add "%%i" /v "ReduceSpeedOnPowerDown" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "EnablePME" ^| findstr "HKEY"') do (Reg add "%%i" /v "EnablePME" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "*WakeOnMagicPacket" ^| findstr "HKEY"') do (Reg add "%%i" /v "*WakeOnMagicPacket" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "*WakeOnPattern" ^| findstr "HKEY"') do (Reg add "%%i" /v "*WakeOnPattern" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "*TCPChecksumOffloadIPv4" ^| findstr "HKEY"') do (Reg add "%%i" /v "*TCPChecksumOffloadIPv4" /t Reg_SZ /d "1" /f)
for /f %%i in ('Reg query "%%a" /v "*TCPChecksumOffloadIPv6" ^| findstr "HKEY"') do (Reg add "%%i" /v "*TCPChecksumOffloadIPv6" /t Reg_SZ /d "1" /f)
for /f %%i in ('Reg query "%%a" /v "*UDPChecksumOffloadIPv4" ^| findstr "HKEY"') do (Reg add "%%i" /v "*UDPChecksumOffloadIPv4" /t Reg_SZ /d "1" /f)
for /f %%i in ('Reg query "%%a" /v "*UDPChecksumOffloadIPv6" ^| findstr "HKEY"') do (Reg add "%%i" /v "*UDPChecksumOffloadIPv6" /t Reg_SZ /d "1" /f)
for /f %%i in ('Reg query "%%a" /v "WolShutdownLinkSpeed" ^| findstr "HKEY"') do (Reg add "%%i" /v "WolShutdownLinkSpeed" /t Reg_SZ /d "2" /f)
for /f %%i in ('Reg query "%%a" /v "*SpeedDuplex" ^| findstr "HKEY"') do (Reg add "%%i" /v "*SpeedDuplex" /t Reg_SZ /d "6" /f)
for /f %%i in ('Reg query "%%a" /v "*LsoV2IPv4" ^| findstr "HKEY"') do (Reg add "%%i" /v "*LsoV2IPv4" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "*LsoV2IPv6" ^| findstr "HKEY"') do (Reg add "%%i" /v "*LsoV2IPv6" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "*TransmitBuffers" ^| findstr "HKEY"') do (Reg add "%%i" /v "*TransmitBuffers" /t Reg_SZ /d "128" /f)
for /f %%i in ('Reg query "%%a" /v "*ReceiveBuffers" ^| findstr "HKEY"') do (Reg add "%%i" /v "*ReceiveBuffers" /t Reg_SZ /d "512" /f)
for /f %%i in ('Reg query "%%a" /v "*JumboPacket" ^| findstr "HKEY"') do (Reg add "%%i" /v "*JumboPacket" /t Reg_SZ /d "9014" /f)
for /f %%i in ('Reg query "%%a" /v "*PMARPOffload" ^| findstr "HKEY"') do (Reg add "%%i" /v "*PMARPOffload" /t Reg_SZ /d "1" /f)
for /f %%i in ('Reg query "%%a" /v "*PMNSOffload" ^| findstr "HKEY"') do (Reg add "%%i" /v "*PMNSOffload" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "*InterruptModeration" ^| findstr "HKEY"') do (Reg add "%%i" /v "*InterruptModeration" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "*ModernStandbyWoLMagicPacket" ^| findstr "HKEY"') do (Reg add "%%i" /v "*ModernStandbyWoLMagicPacket" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "WakeOnLinkChange" ^| findstr "HKEY"') do (Reg add "%%i" /v "WakeOnLinkChange" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "*IPChecksumOffloadIPv4" ^| findstr "HKEY"') do (Reg add "%%i" /v "*IPChecksumOffloadIPv4" /t Reg_SZ /d "3" /f)
for /f %%i in ('Reg query "%%a" /v "*RSS" ^| findstr "HKEY"') do (Reg add "%%i" /v "*RSS" /t Reg_SZ /d "1" /f)
for /f %%i in ('Reg query "%%a" /v "*NumRssQueues" ^| findstr "HKEY"') do (Reg add "%%i" /v "*NumRssQueues" /t Reg_SZ /d "4" /f)
for /f %%i in ('Reg query "%%a" /v "EnableGreenEthernet" ^| findstr "HKEY"') do (Reg add "%%i" /v "EnableGreenEthernet" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "GigaLite" ^| findstr "HKEY"') do (Reg add "%%i" /v "GigaLite" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "PowerSavingMode" ^| findstr "HKEY"') do (Reg add "%%i" /v "PowerSavingMode" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "S5WakeOnLan" ^| findstr "HKEY"') do (Reg add "%%i" /v "S5WakeOnLan" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "AutoDisableGigabit" ^| findstr "HKEY"') do (Reg add "%%i" /v "AutoDisableGigabit" /t Reg_SZ /d "0" /f)
)
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto TweaksMenu

:E
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %g%_____________________________________
echo.
echo           %c%CPU Optimizations%u%                
echo %g%_____________________________________
timeout /t 3 >nul
cls
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c" /v "ValueMax" /t REG_DWORD /d "100" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c\DefaultPowerSchemeValues\8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" /v "ValueMax" /t REG_DWORD /d "100" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\ControlSet002\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\ControlSet002\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t REG_DWORD /d "0" /f
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto TweaksMenu

:F
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %g%_____________________________________
echo.
echo          %c%Memory Optimizer%u%            
echo %g%_____________________________________
timeout /t 3 >nul
cls
sc stop BITS
for /f "tokens=3" %%a in ('sc queryex "BITS" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "low"
sc start DsSvc
for /f "tokens=3" %%a in ('sc queryex "DsSvc" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "realtime"
sc start Dhcp
for /f "tokens=3" %%a in ('sc queryex "Dhcp" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "realtime"
sc start DPS 
for /f "tokens=3" %%a in ('sc queryex "DPS" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "realtime"
sc start Dnscache
for /f "tokens=3" %%a in ('sc queryex "Dnscache" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "realtime"
sc start WinHttpAutoProxySvc
for /f "tokens=3" %%a in ('sc queryex "WinHttpAutoProxySvc" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "realtime"
sc start DcpSvc
for /f "tokens=3" %%a in ('sc queryex "BITS" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "DcpSvc"
sc start WlanSvc
for /f "tokens=3" %%a in ('sc queryex "WlanSvc" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "realtime"
sc start LSM
for /f "tokens=3" %%a in ('sc queryex "LSM" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "realtime"
sc start smphost
for /f "tokens=3" %%a in ('sc queryex "smphost" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "low"
sc start PNRPsvc
for /f "tokens=3" %%a in ('sc queryex "PNRPsvc" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "low"
sc start SensrSvc
for /f "tokens=3" %%a in ('sc queryex "SensrSvc" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "low"
sc start Wcmsvc
for /f "tokens=3" %%a in ('sc queryex "Wcmsvc" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "low"
sc start Wersvc
for /f "tokens=3" %%a in ('sc queryex "Wersvc" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "low"
sc start Spooler
for /f "tokens=3" %%a in ('sc queryex "Spooler" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "realtime"
sc start vds
for /f "tokens=3" %%a in ('sc queryex "vds" ^| findstr "PID"') do (set pid=%%a)
wmic process where ProcessId=%pid% CALL setpriority "realtime"
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto TweaksMenu

:G
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %g%_____________________________________
echo.
echo        %c%Mouse/Keyboard Tweaks%u%             
echo %g%_____________________________________
timeout /t 3 >nul
cls
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatDelay" /t REG_SZ /d "200" /f
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatRate" /t REG_SZ /d "6" /f
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "BounceTime" /t REG_SZ /d "0" /f
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "DelayBeforeAcceptance" /t REG_SZ /d "0" /f
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "59" /f
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last BounceKey Setting" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Delay" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Repeat" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Wait" /t REG_DWORD /d "1000" /f
Reg.exe add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "506" /f
Reg.exe add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_SZ /d "58" /f
Reg.exe add "HKCU\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_SZ /d "38" /f
Reg.exe add "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d "0" /f
Reg.exe add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f
Reg.exe add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f
Reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d "0000000000000000156e000000000000004001000000000029dc0300000000000000280000000000" /f >nul 2>&1
	Reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d "0000000000000000fd11010000000000002404000000000000fc12000000000000c0bb0100000000" /f >nul 2>&1
Reg add "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
Reg add "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
Reg add "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1
Reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f >nul 2>&1
Reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d 
Reg.exe add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "100" /f
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto TweaksMenu

:H
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %g%_____________________________________
echo.
echo         %c%Internet Refresher%u%             
echo %g%_____________________________________
timeout /t 3 >nul
cls
ipconfig /all
ipconfig /flushdns
ipconfig /release
ipconfig /renew
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto TweaksMenu

:I
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %g%_____________________________________
echo.
echo             %c%Service Tweaks%u%              
echo %g%_____________________________________
timeout /t 3 >nul
cls
echo %c%Activating Service Tweaks...%u%
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\xbgm" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\XboxGipSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\spectrum" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wcncsvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SysMain" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NcaSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\diagsvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UserDataSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\stisvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AdobeFlashPlayerUpdateSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1 
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TrkWks" /v "Start" /t REG_DWORD /d "4" /f  >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1  
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PimIndexMaintenanceSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DiagTrack" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\GoogleChromeElevationService" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\OneSyncSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ibtsiva" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMPTRAP" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\pla" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ssh-agent" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\sshd" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DoSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WbioSrvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PcaSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetTcpPortSharing" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wersvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\gupdate" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\gupdatem" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MSiSCSI" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WMPNetworkSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UnistoreSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MapsBroker" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\debugregsvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Ndu" /v "Start" /d "2" /t REG_DWORD /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /d "3" /t REG_DWORD /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VaultSvc" /v "Start" /t REG_DWORD /d "3" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d "3" /f >nul 2>&1
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CertPropSvc" /v "Start" /t REG_DWORD /d "3" /f >nul 2>&1
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto TweaksMenu

:J
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %g%_____________________________________
echo.
echo            %c%Debloater%u%        
echo %g%_____________________________________
timeout /t 3 >nul
cls
"powershell.exe" "get-appxpackage -AllUsers *windowsalarms* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *windowscommunicationsapps* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *officehub* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *skypeapp* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *getstarted* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *zunemusic* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *windowsmaps* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *solitairecollection* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *bingfinance* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *zunevideo* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *bingnews* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *onenote* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *people* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *windowsphone* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *photos* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *bingsports* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *soundrecorder* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *bingweather* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *connectivitystore* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *messaging* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *sway* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *3d* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *holographic* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers  Microsoft.XboxGamingOverlay | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *3dbuilder* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers Microsoft.MicrosoftEdge.Stable | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers Microsoft.549981C3F5F10 | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers Microsoft.PowerAutomateDesktop | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers Microsoft.XboxGameOverlay | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers Microsoft.YourPhone | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers MicrosoftWindows.Client.WebExperience | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers Microsoft.WindowsFeedbackHub | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers Microsoft.GetHelp | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers Microsoft.MicrosoftStickyNotes | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers Microsoft.ScreenSketch | Remove-AppxPackage"
"powershell.exe" "Get-AppxProvisionedPackage -online Microsoft.ScreenSketch | Remove-AppxProvisionedPackage -online"
"powershell.exe" "Get-AppxProvisionedPackage -online Microsoft.MicrosoftStickyNotes | Remove-AppxProvisionedPackage -online"
"powershell.exe" "Get-AppxProvisionedPackage -online Microsoft.GetHelp | Remove-AppxProvisionedPackage -online"
"powershell.exe" "Get-AppxProvisionedPackage -online Microsoft.WindowsFeedbackHub | Remove-AppxProvisionedPackage -online"
"powershell.exe" "Get-AppxProvisionedPackage -online MicrosoftWindows.Client.WebExperience | Remove-AppxProvisionedPackage -online"
"powershell.exe" "Get-AppxProvisionedPackage -online Microsoft.YourPhone | Remove-AppxProvisionedPackage -online"
"powershell.exe" "Get-AppxProvisionedPackage -online Microsoft.XboxGameOverlay | Remove-AppxProvisionedPackage -online"
cls
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Security" /V "DisableSecuritySettingsCheck" /T "REG_DWORD" /D "00000001" /F
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /V "1806" /T "REG_DWORD" /D "00000000" /F
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /V "1806" /T "REG_DWORD" /D "00000000" /F
cls
taskkill /f /im explorer.exe
start explorer.exe
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto TweaksMenu

:Destruct
title Thanks for using Batlez Tweaks!
mode 42,5
cls
echo.            
echo %u%Developed by: %c%Batlez#3470
echo %u%Github: %c%https://github.com/Batlez
timeout /t 5 >nul
exit