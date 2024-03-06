@echo off
set version=1.7
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
set gold=[93m

:: Webhook
SET webhook=


:loading
chcp 65001 >nul
cls
echo.
echo.
echo.
echo.                  
echo     %b%    ██████╗ █████╗  ████████╗██╗     ███████╗███████╗  ████████╗ ██╗       ██╗███████╗ █████╗ ██╗  ██╗ ██████╗
echo         ██╔══██╗██╔══██╗╚══██╔══╝██║     ██╔════╝╚════██║  ╚══██╔══╝ ██║  ██╗  ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝
echo         ██████╦╝███████║   ██║   ██║     █████╗    ███╔═╝     ██║    ╚██╗████╗██╔╝█████╗  ███████║█████═╝ ╚█████╗  %u%
echo     %r%    ██╔══██╗██╔══██║   ██║   ██║     ██╔══╝  ██╔══╝       ██║     ████╔═████║ ██╔══╝  ██╔══██║██╔═██╗  ╚═══██╗
echo         ██████╦╝██║  ██║   ██║   ███████╗███████╗███████╗     ██║     ╚██╔╝ ╚██╔╝ ███████╗██║  ██║██║ ╚██╗██████╔╝
echo         ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝╚══════╝     ╚═╝      ╚═╝   ╚═╝  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  %u%
echo.
echo.
echo.
echo %w%                                                 Developed by Croakq
echo %w%                                          Thank you for using Batlez Tweaks
echo %w%                                            %g%Press any key to get started%u%            
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
echo %u%Developed by: %g%Croakq
echo %u%Github: %g%https://github.com/Batlez
echo.
echo.
echo.
echo.
timeout /t 2 >nul & cls & goto Presets

:Presets
cls
chcp 437>nul
echo %w%Choose one Colour from below!%u%
echo.
echo %b%Blue%u%, %d%Cyan%u%, %g%Green%u%, %y%Yellow%u%, %r%Red%u% or %gold%Gold%u%.
echo.
echo.
set /p preset= 

if /i "%preset%"=="Gold" goto Gold
if /i "%preset%"=="Blue" goto Blue
if /i "%preset%"=="Cyan" goto Cyan
if /i "%preset%"=="Yellow" goto Yellow
if /i "%preset%"=="Green" goto Green
if /i "%preset%"=="Red" goto Red
echo Please enter a valid option.
timeout /t 2 /nobreak >nul
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

:Gold
set c=%gold%
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
echo                                 %c%Batlez is a tweaking script that optimizes your system%u% 
echo                                    %c%to provide the best gaming experience possible.%u%
echo.
echo.                                    
echo.
echo                                            [%c%1%u%] Optimizations   [%c%2%u%] Hardware
echo.
echo.
echo.
echo                                        [%c%3%u%] Windows   [%c%4%u%] Privacy   [%c%5%u%] Backup
echo.
echo.
echo.
echo                                             [%c%6%u%] Advanced      [%c%7%u%] More Info
echo. 
echo.
echo.
echo                                                      %c%[ X to close ]%u%  
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
echo                              %r%This feature has not been finished yet but will be coming out soon.  
echo.
echo.
echo.
echo.
echo                                                 %c%[ Press any key to go back ]%u%
pause >nul
goto menu

:More
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
echo                                                 [%c%1%u%] About     [%c%2%u%] Disclaimer
echo.
echo.
echo.
echo                                                 [%c%3%u%] Credits   [%c%4%u%] Changelog   
echo.
echo.
echo.
echo                                                          [%c%5%u%] Back
echo. 
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
goto More

:about
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %g%_____________________________________
echo.
echo              %c%About%u%         
echo %g%_____________________________________
echo.
echo.
echo.
echo      %c%Created by Croakq%u%
echo %c%This is a GUI for the Batlez Tweaks%u%
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto More

:disclaimer
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %g%_____________________________________
echo.
echo              %c%Disclaimer%u%         
echo %g%_____________________________________
echo.
echo.
echo.
echo %c%Batlez Tweaks is a tweaking script that optimizes your%u% 
echo %c%system to provide the best gaming experience possible.%u%
echo.
echo %c%Please be advised that%u% %r%I cannot guarantee an FPS increase%u% %c%by 
echo implementing the suggested optimizations. Each system and%u%
echo %c%configuration may have varying results.%u%
echo.
echo %c%It is important to note that everything presented here will be used at your%u% 
echo %r%own risk.%u% %c%I will not be held liable for any damages caused due to failure to%u% 
echo %c%follow the instructions carefully.%u%
echo.
echo %c%If you need clarification on a tweak, please refrain from using it and %u% 
echo %c%contact me for further assistance.%u% 
echo.
echo %c%I recommend creating a manual restore point before%u% 
echo %c%executing any tweaks.%u% 
echo.
echo %c%If you have any questions or concerns, please get in touch with me%u%
echo %c%on%u% %y%Discord at Croakq%u%
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto More

:credits
chcp 437>nul
chcp 65001 >nul
echo.
echo.
cls
echo %g%_____________________________________
echo.
echo              %c%Credits%u%         
echo %g%_____________________________________
echo.
echo.
echo.
echo %c%Please find the appropriate credits at the location below:%u%
echo %r%Batlez\Batlez Folder\Important - Read First.txt%u%
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto More

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
echo.
echo.
echo.
start https://github.com/Batlez/Batlez/releases
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto More

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
set /p input="%c%Would you like to create a Restore and registry Point? %w%(Y/N)%u% %c%»%u% "
if "%input%"=="Y" goto restorepoint1
if "%input%"=="N" goto menu
echo %c%Please enter a valid number!%u% & goto Backup

:: Credits to tarekifla
:restorepoint1
echo %c%Backing up the registry...%u%
if not exist "C:\registryBackup\" mkdir C:\registryBackup
cd /d C:\registryBackup
REG SAVE HKLM\SOFTWARE SOFTWARE
REG SAVE HKLM\SYSTEM SYSTEM
REG SAVE HKU\.DEFAULT DEFAULT
REG SAVE HKLM\SECURITY SECURITY
REG SAVE HKLM\SAM SAM
echo %c%The registry backup is located at "C:\registryBackup"%u%
timeout 4 >nul /nobreak
echo %c%Backup succesfully created!%u%
cls

:restorepoint2
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t reg_DWORD /d "0" /f
echo %c%Creating a restore point...%u%
timeout 4 >nul /nobreak
powershell.exe -ExecutionPolicy Bypass -NoExit -Command "Checkpoint-Computer -Description "PreTweaksBackup" -RestorePointType "MODIFY_SETTINGS""
set SR_STATUS=%ERRORLEVEL%
IF %SR_STATUS%==0 & echo %c%System Restore point made succesfully!%u%
timeout 4 >nul /nobreak
cls
IF NOT %SR_STATUS%==0 & echo %c%Failed to create a restore point, please make sure you have enabled protection in System!%u% 
timeout 4 >nul /nobreak
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
powershell Invoke-WebRequest "https://cdn.discordapp.com/attachments/1145945307205611623/1145945358707470386/Batlez_Tweaks.pow" -OutFile "%temp%\Batlez_Tweaks.pow"
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
del /Q C:\Users\%username%\AppData\Local\Microsoft\Windows\INetCache\IE\*.*
del /Q C:\Windows\Downloaded Program Files\*.*
rd /s /q %SYSTEMDRIVE%\$Recycle.bin
del /Q C:\Users\%username%\AppData\Local\Temp\*.*
del /Q C:\Windows\Temp\*.*
del /Q C:\Windows\Prefetch\*.*
del /s /f /q %SystemRoot%\setupapi.log
del /s /f /q %SystemRoot%\Panther\*
del /s /f /q %SystemRoot%\inf\setupapi.app.log
del /s /f /q %SystemRoot%\inf\setupapi.dev.log
del /s /f /q %SystemRoot%\inf\setupapi.offline.log
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit" /va /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit\Favorites" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit\Favorites" /va /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU" /va /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRULegacy" /va /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" /va /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Wordpad\Recent File List" /va /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU" /va /f
reg delete "HKCU\Software\Microsoft\Search Assistant\ACMru" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /va /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /va /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSaveMRU" /va /f
reg delete "HKCU\Software\Microsoft\MediaPlayer\Player\RecentFileList" /va /f
reg delete "HKCU\Software\Microsoft\MediaPlayer\Player\RecentURLList" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\MediaPlayer\Player\RecentFileList" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\MediaPlayer\Player\RecentURLList" /va /f
reg delete "HKCU\SOFTWARE\Microsoft\Direct3D\MostRecentApplication" /va /f
reg delete "HKLM\SOFTWARE\Microsoft\Direct3D\MostRecentApplication" /va /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /va /f
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
echo         %c%Custom Regedit%u%         
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
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001" /v "*RSSProfile" /t reg_SZ /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile" /v "ParamDesc" /t reg_SZ /d "RSS load balancing profile" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile" /v "default" /t reg_SZ /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile" /v "type" /t reg_SZ /d "enum" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile\Enum" /v "1" /t reg_SZ /d "ClosestProcessor" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile\Enum" /v "2" /t reg_SZ /d "ClosestProcessorStatic" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile\Enum" /v "3" /t reg_SZ /d "NUMAScaling" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile\Enum" /v "4" /t reg_SZ /d "NUMAScalingStatic" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0001\Ndi\Params\*RSSProfile\Enum" /v "5" /t reg_SZ /d "ConservativeScaling" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableICMPRedirect" /t reg_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /t reg_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t reg_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t reg_DWORD /d "2" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t reg_DWORD /d "32" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t reg_DWORD /d "8760" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t reg_DWORD /d "8760" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectionsPerServer" /t reg_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t reg_DWORD /d "65534" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t reg_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t reg_DWORD /d "64" /f
reg add "HKLM\SOFTWARE\Microsoft\MSMQ\Parameters" /v "TCPNoDelay" /t reg_DWORD /d "1" /f
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
::Made by imribiy#0001
Reg.exe add "HKCU\Software\AMD\CN" /v "AutoUpdateTriggered" /t REG_DWORD /d "0" /f > nul 2>&1 > nul 2>&1
Reg.exe add "HKCU\Software\AMD\CN" /v "PowerSaverAutoEnable_CUR" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\CN" /v "WindowSize" /t REG_SZ /d "1440,960" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\CN" /v "BuildType" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\CN" /v "WizardProfile" /t REG_SZ /d "PROFILE_CUSTOM" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\CN" /v "UserTypeWizardShown" /t REG_DWORD /d "1" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\CN" /v "LastPage" /t REG_SZ /d "settings/graphics/0/" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\CN" /v "AutoUpdate" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\CN" /v "RSXBrowserUnavailable" /t REG_SZ /d "true" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\CN" /v "SystemTray" /t REG_SZ /d "false" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\CN" /v "AllowWebContent" /t REG_SZ /d "false" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\CN" /v "CN_Hide_Toast_Notification" /t REG_SZ /d "true" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\CN" /v "AnimationEffect" /t REG_SZ /d "false" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\CN\OverlayNotification" /v "AlreadyNotified" /t REG_DWORD /d "1" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\CN\VirtualSuperResolution" /v "AlreadyNotified" /t REG_DWORD /d "1" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\DVR" /v "PerformanceMonitorOpacityWA" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\DVR" /v "CaptureFileOutput" /t REG_SZ /d "C:\Users\Emre\Videos\Radeon ReLive" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\DVR" /v "DvrEnabled" /t REG_DWORD /d "1" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\DVR" /v "ActiveSceneId" /t REG_SZ /d "0" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\DVR" /v "AVCCaps" /t REG_SZ /d "256,1,4096,4096,100000000,244800,0;" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\DVR" /v "HEVCCaps" /t REG_SZ /d "256,1,4096,4096,2147483647,979200,0;" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\DVR" /v "AvcEfcSupport" /t REG_SZ /d "0;" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\DVR" /v "HevcEfcSupport" /t REG_SZ /d "0;" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\DVR" /v "PrevInstantReplayEnable" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\DVR" /v "PrevInGameReplayEnabled" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\DVR" /v "PrevInstantGifEnabled" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\DVR" /v "DvrDesktops" /t REG_SZ /d "\\.\DISPLAY19" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\DVR" /v "RemoteServerStatus" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\DVR" /v "ShowRSOverlay" /t REG_SZ /d "false" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "CameraSize" /t REG_DWORD /d "3" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "CameraEnabled" /t REG_DWORD /d "1" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "CameraOpacity" /t REG_DWORD /d "100" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "CameraAnchor" /t REG_DWORD /d "3" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "CameraShownOnScreen" /t REG_DWORD /d "1" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "IndicatorPosition" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "TimerEnabled" /t REG_DWORD /d "1" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "ChatOverlayEnabled" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "ChatCustomOffset" /t REG_SZ /d "0.0260,0.0462" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "ChatOverlayAnchor" /t REG_DWORD /d "4" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "ChatBackgroundBlur" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "ChatFontSize" /t REG_DWORD /d "1" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "RelativeCoords" /t REG_DWORD /d "1" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "CameraOffset" /t REG_SZ /d "0.0208,0.0370" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "CameraCustomOffset" /t REG_SZ /d "0.0208,0.0370" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "CameraRect" /t REG_SZ /d "0.1667,0.2222" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "CameraCustomRect" /t REG_SZ /d "0.1667,0.2222" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "ChatCustomRect" /t REG_SZ /d "0.1562,0.1562" /f > nul 2>&1
Reg.exe add "HKCU\Software\AMD\SCENE\0" /v "ChatOverlaySize" /t REG_DWORD /d "3" /f > nul 2>&1
Reg.exe add "HKCU\Software\ATI\ACE\Settings\ADL\AppProfiles" /v "AplReloadCounter" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKLM\Software\AMD\Install" /v "AUEP" /t REG_DWORD /d "1" /f > nul 2>&1
Reg.exe add "HKLM\Software\AUEP" /v "RSX_AUEPStatus" /t REG_DWORD /d "2" /f > nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalOptimizeEdpLinkRate" /t reg_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalPSRFeatureEnable" /t reg_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmL0s" /t reg_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmL1" /t reg_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisablePllOffInL1" /t reg_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuClockGating" /t reg_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuLightSleep" /t reg_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableGPUVirtualizationFeature" /t reg_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_BlockchainSupport" /t reg_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_ChillEnabled" /t reg_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableGDIAcceleration" /t reg_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_DisableAutoWattman" /t reg_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_DisableLightSleep" /t reg_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t reg_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3D_Refresh_Rate_Override_DEF" /t reg_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3to2Pulldown_NA" /t reg_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AAF_NA" /t reg_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Adaptive De-interlacing" /t reg_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowRSOverlay" /t reg_SZ /d "false" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSkins" /t reg_SZ /d "false" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSnapshot" /t reg_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSubscription" /t reg_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AntiAlias_NA" /t reg_SZ /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AreaAniso_NA" /t reg_SZ /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ASTT_NA" /t reg_SZ /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AutoColorDepthReduction_NA" /t reg_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSAMUPowerGating" /t reg_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableUVDPowerGatingDynamic" /t reg_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableVCEPowerGating" /t reg_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL0s" /t reg_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL1" /t reg_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps" /t reg_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps_NA" /t reg_SZ /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DeLagEnabled" /t reg_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_FRTEnabled" /t reg_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "NotifySubscription" /t REG_BINARY /d "3000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "IsComponentControl" /t REG_BINARY /d "00000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_USUEnable" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_RadeonBoostEnabled" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "IsAutoDefault" /t REG_BINARY /d "01000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_ChillEnabled" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DeLagEnabled" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ACE" /t REG_BINARY /d "3000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "AnisoDegree_SET" /t REG_BINARY /d "3020322034203820313600" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D_SET" /t REG_BINARY /d "302031203220332034203500" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Tessellation_OPTION" /t REG_BINARY /d "3200" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Tessellation" /t REG_BINARY /d "3100" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "AAF" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "GI" /t REG_BINARY /d "31000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "CatalystAI" /t REG_BINARY /d "31000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TemporalAAMultiplier_NA" /t REG_BINARY /d "3100" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ForceZBufferDepth" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "EnableTripleBuffering" /t REG_BINARY /d "3000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ExportCompressedTex" /t REG_BINARY /d "31000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "PixelCenter" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ZFormats_NA" /t REG_BINARY /d "3100" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "DitherAlpha_NA" /t REG_BINARY /d "3100" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "SwapEffect_D3D_SET" /t REG_BINARY /d "3020312032203320342038203900" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TFQ" /t REG_BINARY /d "3200" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "VSyncControl" /t REG_BINARY /d "3100" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TextureOpt" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TextureLod" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ASE" /t REG_BINARY /d "3000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ASD" /t REG_BINARY /d "3000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ASTT" /t REG_BINARY /d "3000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "AntiAliasSamples" /t REG_BINARY /d "3000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "AntiAlias" /t REG_BINARY /d "3100" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "AnisoDegree" /t REG_BINARY /d "3000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "AnisoType" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "AntiAliasMapping_SET" /t REG_BINARY /d "3028303A302C313A3029203228303A322C313A3229203428303A342C313A3429203828303A382C313A382900" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "AntiAliasSamples_SET" /t REG_BINARY /d "3020322034203800" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ForceZBufferDepth_SET" /t REG_BINARY /d "3020313620323400" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "SwapEffect_OGL_SET" /t REG_BINARY /d "3020312032203320342035203620372038203920313120313220313320313420313520313620313700" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Tessellation_SET" /t REG_BINARY /d "31203220342036203820313620333220363400" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "HighQualityAF" /t REG_BINARY /d "3100" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "DisplayCrossfireLogo" /t REG_BINARY /d "3000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "AppGpuId" /t REG_BINARY /d "300078003000310030003000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "SwapEffect" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "PowerState" /t REG_BINARY /d "3000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "AntiStuttering" /t REG_BINARY /d "3100" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TurboSync" /t REG_BINARY /d "3000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "SurfaceFormatReplacements" /t REG_BINARY /d "3100" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "EQAA" /t REG_BINARY /d "3000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ShaderCache" /t REG_BINARY /d "3100" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "MLF" /t REG_BINARY /d "3000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TruformMode_NA" /t REG_BINARY /d "3100" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "LRTCEnable" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "3to2Pulldown" /t REG_BINARY /d "31000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "MosquitoNoiseRemoval_ENABLE" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "MosquitoNoiseRemoval" /t REG_BINARY /d "350030000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "Deblocking_ENABLE" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "Deblocking" /t REG_BINARY /d "350030000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "DemoMode" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "OverridePA" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "DynamicRange" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "StaticGamma_ENABLE" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "BlueStretch_ENABLE" /t REG_BINARY /d "31000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "BlueStretch" /t REG_BINARY /d "31000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "LRTCCoef" /t REG_BINARY /d "3100300030000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "DynamicContrast_ENABLE" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "WhiteBalanceCorrection" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "Fleshtone_ENABLE" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "Fleshtone" /t REG_BINARY /d "350030000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "ColorVibrance_ENABLE" /t REG_BINARY /d "31000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "ColorVibrance" /t REG_BINARY /d "340030000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "Detail_ENABLE" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "Detail" /t REG_BINARY /d "310030000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "Denoise_ENABLE" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "Denoise" /t REG_BINARY /d "360034000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "TrueWhite" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "OvlTheaterMode" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "StaticGamma" /t REG_BINARY /d "3100300030000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD\DXVA" /v "InternetVideo" /t REG_BINARY /d "30000000" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Services\amdwddmg" /v "ChillEnabled" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D_DEF" /t REG_SZ /d "1" /f > nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D" /t REG_BINARY /d "3100" /f > nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDMACopy" /t REG_DWORD /d "1" /f > nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableBlockWrite" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t REG_DWORD /d "0" /f > nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t REG_DWORD /d "1" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Services\AMD Crash Defender Service" /v "Start" /t REG_DWORD /d "4" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t REG_DWORD /d "4" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Services\amdfendr" /v "Start" /t REG_DWORD /d "4" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Services\amdfendrmgr" /v "Start" /t REG_DWORD /d "4" /f > nul 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Services\amdlog" /v "Start" /t REG_DWORD /d "4" /f > nul 2>&1
sc config amdlog start=disabled
sc config "AMD External Events Utility" start=disabled
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
netsh int tcp set global chimney=enabled
netsh int tcp set global ecncapability=enabled
netsh int tcp set global timestamps=disabled
netsh int tcp set global initialRto=2000
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
netsh interface ipv4 set subinterface Ethernet mtu=1500 store=persistent

for /f %%r in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /f "1" /d /s^|Findstr HKEY_') do (
reg add %%r /v "NonBestEffortLimit" /t reg_DWORD /d "0" /f 
reg add %%r /v "DeadGWDetectDefault" /t reg_DWORD /d "1" /f 
reg add %%r /v "PerformRouterDiscovery" /t reg_DWORD /d "1" /f
reg add %%r /v "TCPNoDelay" /t reg_DWORD /d "1" /f
reg add %%r /v "TcpAckFrequency" /t reg_DWORD /d "1" /f
reg add %%r /v "TcpInitialRTT" /t reg_DWORD /d "2" /f
reg add %%r /v "TcpDelAckTicks" /t reg_DWORD /d "0" /f
reg add %%r /v "MTU" /t reg_DWORD /d "1500" /f
reg add %%r /v "UseZeroBroadcast" /t reg_DWORD /d "0" /f
)

for /f %%a in ('reg query HKLM /v "*WakeOnMagicPacket" /s ^| findstr  "HKEY"') do (
for /f %%i in ('reg query "%%a" /v "*EEE" ^| findstr "HKEY"') do (reg add "%%i" /v "*EEE" /t reg_DWORD /d "0" /f)
for /f %%i in ('reg query "%%a" /v "*FlowControl" ^| findstr "HKEY"') do (reg add "%%i" /v "*FlowControl" /t reg_DWORD /d "0" /f)
for /f %%i in ('reg query "%%a" /v "EnableSavePowerNow" ^| findstr "HKEY"') do (reg add "%%i" /v "EnableSavePowerNow" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "EnablePowerManagement" ^| findstr "HKEY"') do (reg add "%%i" /v "EnablePowerManagement" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "EnableDynamicPowerGating" ^| findstr "HKEY"') do (reg add "%%i" /v "EnableDynamicPowerGating" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "EnableConnectedPowerGating" ^| findstr "HKEY"') do (reg add "%%i" /v "EnableConnectedPowerGating" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "AutoPowerSaveModeEnabled" ^| findstr "HKEY"') do (reg add "%%i" /v "AutoPowerSaveModeEnabled" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "AdvancedEEE" ^| findstr "HKEY"') do (reg add "%%i" /v "AdvancedEEE" /t reg_DWORD /d "0" /f)
for /f %%i in ('reg query "%%a" /v "ULPMode" ^| findstr "HKEY"') do (reg add "%%i" /v "ULPMode" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "ReduceSpeedOnPowerDown" ^| findstr "HKEY"') do (reg add "%%i" /v "ReduceSpeedOnPowerDown" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "EnablePME" ^| findstr "HKEY"') do (reg add "%%i" /v "EnablePME" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "*WakeOnMagicPacket" ^| findstr "HKEY"') do (reg add "%%i" /v "*WakeOnMagicPacket" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "*WakeOnPattern" ^| findstr "HKEY"') do (reg add "%%i" /v "*WakeOnPattern" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "*TCPChecksumOffloadIPv4" ^| findstr "HKEY"') do (reg add "%%i" /v "*TCPChecksumOffloadIPv4" /t reg_SZ /d "1" /f)
for /f %%i in ('reg query "%%a" /v "*TCPChecksumOffloadIPv6" ^| findstr "HKEY"') do (reg add "%%i" /v "*TCPChecksumOffloadIPv6" /t reg_SZ /d "1" /f)
for /f %%i in ('reg query "%%a" /v "*UDPChecksumOffloadIPv4" ^| findstr "HKEY"') do (reg add "%%i" /v "*UDPChecksumOffloadIPv4" /t reg_SZ /d "1" /f)
for /f %%i in ('reg query "%%a" /v "*UDPChecksumOffloadIPv6" ^| findstr "HKEY"') do (reg add "%%i" /v "*UDPChecksumOffloadIPv6" /t reg_SZ /d "1" /f)
for /f %%i in ('reg query "%%a" /v "WolShutdownLinkSpeed" ^| findstr "HKEY"') do (reg add "%%i" /v "WolShutdownLinkSpeed" /t reg_SZ /d "2" /f)
for /f %%i in ('reg query "%%a" /v "*SpeedDuplex" ^| findstr "HKEY"') do (reg add "%%i" /v "*SpeedDuplex" /t reg_SZ /d "6" /f)
for /f %%i in ('reg query "%%a" /v "*LsoV2IPv4" ^| findstr "HKEY"') do (reg add "%%i" /v "*LsoV2IPv4" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "*LsoV2IPv6" ^| findstr "HKEY"') do (reg add "%%i" /v "*LsoV2IPv6" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "*TransmitBuffers" ^| findstr "HKEY"') do (reg add "%%i" /v "*TransmitBuffers" /t reg_SZ /d "128" /f)
for /f %%i in ('reg query "%%a" /v "*ReceiveBuffers" ^| findstr "HKEY"') do (reg add "%%i" /v "*ReceiveBuffers" /t reg_SZ /d "512" /f)
for /f %%i in ('reg query "%%a" /v "*JumboPacket" ^| findstr "HKEY"') do (reg add "%%i" /v "*JumboPacket" /t reg_SZ /d "9014" /f)
for /f %%i in ('reg query "%%a" /v "*PMARPOffload" ^| findstr "HKEY"') do (reg add "%%i" /v "*PMARPOffload" /t reg_SZ /d "1" /f)
for /f %%i in ('reg query "%%a" /v "*PMNSOffload" ^| findstr "HKEY"') do (reg add "%%i" /v "*PMNSOffload" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "*InterruptModeration" ^| findstr "HKEY"') do (reg add "%%i" /v "*InterruptModeration" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "*ModernStandbyWoLMagicPacket" ^| findstr "HKEY"') do (reg add "%%i" /v "*ModernStandbyWoLMagicPacket" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "WakeOnLinkChange" ^| findstr "HKEY"') do (reg add "%%i" /v "WakeOnLinkChange" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "*IPChecksumOffloadIPv4" ^| findstr "HKEY"') do (reg add "%%i" /v "*IPChecksumOffloadIPv4" /t reg_SZ /d "3" /f)
for /f %%i in ('reg query "%%a" /v "*RSS" ^| findstr "HKEY"') do (reg add "%%i" /v "*RSS" /t reg_SZ /d "1" /f)
for /f %%i in ('reg query "%%a" /v "*NumRssQueues" ^| findstr "HKEY"') do (reg add "%%i" /v "*NumRssQueues" /t reg_SZ /d "4" /f)
for /f %%i in ('reg query "%%a" /v "EnableGreenEthernet" ^| findstr "HKEY"') do (reg add "%%i" /v "EnableGreenEthernet" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "GigaLite" ^| findstr "HKEY"') do (reg add "%%i" /v "GigaLite" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "PowerSavingMode" ^| findstr "HKEY"') do (reg add "%%i" /v "PowerSavingMode" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "S5WakeOnLan" ^| findstr "HKEY"') do (reg add "%%i" /v "S5WakeOnLan" /t reg_SZ /d "0" /f)
for /f %%i in ('reg query "%%a" /v "AutoDisableGigabit" ^| findstr "HKEY"') do (reg add "%%i" /v "AutoDisableGigabit" /t reg_SZ /d "0" /f)
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
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c" /v "ValueMax" /t reg_DWORD /d "100" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c\DefaultPowerSchemeValues\8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" /v "ValueMax" /t reg_DWORD /d "100" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t reg_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t reg_DWORD /d "0" /f
reg add "HKLM\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t reg_DWORD /d "0" /f
reg add "HKLM\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t reg_DWORD /d "0" /f
reg add "HKLM\SYSTEM\ControlSet002\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t reg_DWORD /d "0" /f
reg add "HKLM\SYSTEM\ControlSet002\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t reg_DWORD /d "0" /f
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
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatDelay" /t reg_SZ /d "200" /f
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatRate" /t reg_SZ /d "6" /f
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "BounceTime" /t reg_SZ /d "0" /f
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "DelayBeforeAcceptance" /t reg_SZ /d "0" /f
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t reg_SZ /d "59" /f
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last BounceKey Setting" /t reg_DWORD /d "0" /f
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Delay" /t reg_DWORD /d "0" /f
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Repeat" /t reg_DWORD /d "0" /f
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Wait" /t reg_DWORD /d "1000" /f
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t reg_SZ /d "506" /f
reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t reg_SZ /d "58" /f
reg add "HKCU\Control Panel\Accessibility\MouseKeys" /v "Flags" /t reg_SZ /d "38" /f
reg add "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t reg_SZ /d "0" /f
reg add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t reg_SZ /d "0" /f
reg add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t reg_SZ /d "31" /f
reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "SmoothMouseXCurve" /t reg_BINARY /d "0000000000000000156e000000000000004001000000000029dc0300000000000000280000000000" /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "SmoothMouseYCurve" /t reg_BINARY /d "0000000000000000fd11010000000000002404000000000000fc12000000000000c0bb0100000000" /f >nul 2>&1
reg add "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v "MouseSpeed" /t reg_SZ /d "0" /f >nul 2>&1
reg add "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold1" /t reg_SZ /d "0" /f >nul 2>&1
reg add "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold2" /t reg_SZ /d "0" /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseSensitivity" /t reg_SZ /d "10" /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "SmoothMouseYCurve" /t reg_BINARY /d 
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseHoverTime" /t reg_SZ /d "100" /f
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
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\xbgm" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\XboxGipSvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\spectrum" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wcncsvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SysMain" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NcaSvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\diagsvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UserDataSvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\stisvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AdobeFlashPlayerUpdateSvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1 
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TrkWks" /v "Start" /t reg_DWORD /d "4" /f  >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1  
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PimIndexMaintenanceSvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DiagTrack" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\GoogleChromeElevationService" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\OneSyncSvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ibtsiva" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMPTRAP" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\pla" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ssh-agent" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\sshd" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DoSvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WbioSrvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PcaSvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetTcpPortSharing" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wersvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\gupdate" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\gupdatem" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MSiSCSI" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WMPNetworkSvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UnistoreSvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MapsBroker" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\debugregsvc" /v "Start" /t reg_DWORD /d "4" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Ndu" /v "Start" /d "2" /t reg_DWORD /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /d "3" /t reg_DWORD /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VaultSvc" /v "Start" /t reg_DWORD /d "3" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t reg_DWORD /d "3" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CertPropSvc" /v "Start" /t reg_DWORD /d "3" /f >nul 2>&1
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
"powershell.exe" "get-appxpackage -AllUsers *AdobeSystemsIncorporated.AdobePhotoshopExpress* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *Duolingo-LearnLanguagesforFree* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *Microsoft.ZuneVideo* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *Microsoft.ZuneMusic* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *Microsoft.MSPaint* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *Dolby* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *Speed Test* | Remove-AppxPackage"
"powershell.exe" "get-appxpackage -AllUsers *PandoraMediaInc* | Remove-AppxPackage"
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
"powershell.exe" "get-AppxProvisionedPackage -online Microsoft.ScreenSketch | Remove-AppxProvisionedPackage -online"
"powershell.exe" "get-AppxProvisionedPackage -online Microsoft.MicrosoftStickyNotes | Remove-AppxProvisionedPackage -online"
"powershell.exe" "get-AppxProvisionedPackage -online Microsoft.GetHelp | Remove-AppxProvisionedPackage -online"
"powershell.exe" "get-AppxProvisionedPackage -online Microsoft.WindowsFeedbackHub | Remove-AppxProvisionedPackage -online"
"powershell.exe" "get-AppxProvisionedPackage -online MicrosoftWindows.Client.WebExperience | Remove-AppxProvisionedPackage -online"
"powershell.exe" "get-AppxProvisionedPackage -online Microsoft.YourPhone | Remove-AppxProvisionedPackage -online"
"powershell.exe" "get-AppxProvisionedPackage -online Microsoft.XboxGameOverlay | Remove-AppxProvisionedPackage -online"
cls
reg ADD "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Security" /V "DisableSecuritySettingsCheck" /T "reg_DWORD" /D "00000001" /F
reg ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /V "1806" /T "reg_DWORD" /D "00000000" /F
reg ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /V "1806" /T "reg_DWORD" /D "00000000" /F
cls
taskkill /f /im explorer.exe
start explorer.exe
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto TweaksMenu

:HardwareMenu
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
echo                        %c%║%u%           [%c%1%u%] GPU Optimizations                  %c%║%u% 
echo                        %c%║%u%           [%c%2%u%] CPU Optimizations                  %c%║%u% 
echo                        %c%║%u%           [%c%3%u%] RAM Management                     %c%║%u%
echo                        %c%║%u%           [%c%4%u%] Network Tweaks                     %c%║%u%
echo                        %c%║%u%           [%c%5%u%] Driver Updates                     %c%║%u%
echo                        %c%║%u%           [%c%6%u%] Disk Optimization                  %c%║%u%
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
if %M%==6 goto Comingsoon
if %M%==7 goto Presets
if %M%==8 goto menu
if %M%==Quit goto Destruct
cls
echo %g%============INVALID INPUT============
echo.
echo.
echo %g%_____________________________________
echo.
echo %r%Please select a number from the Main
echo %r%Menu [1-8] or type 'Quit' to Leave.
echo %g%_____________________________________
echo.
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

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
echo                        %c%║%u%           [%c%4%u%] Registry Clean-Up                  %c%║%u%
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
if %M%==4 goto Comingsoon
if %M%==5 goto Comingsoon
if %M%==6 goto Comingsoon
if %M%==7 goto Presets
if %M%==8 goto menu
if %M%==Quit goto Destruct
cls
echo %g%============INVALID INPUT============
echo.
echo.
echo %g%_____________________________________
echo.
echo %r%Please select a number from the Main
echo %r%Menu [1-8] or type 'Quit' to Leave.
echo %g%_____________________________________
echo.
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

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
echo                        %c%║%u%           [%c%6%u%] Program Spying                     %c%║%u%
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
if %M%==6 goto Comingsoon
if %M%==7 goto Presets
if %M%==8 goto menu
if %M%==Quit goto Destruct
cls
echo %g%============INVALID INPUT============
echo.
echo.
echo %g%_____________________________________
echo.
echo %r%Please select a number from the Main
echo %r%Menu [1-8] or type 'Quit' to Leave.
echo %g%_____________________________________
echo.
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

pause >nul
goto PrivacyMenu


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
echo                        %c%║%u%           [%c%5%u%] Program Debloats                   %c%║%u%
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
echo %g%============INVALID INPUT============
echo.
echo.
echo %g%_____________________________________
echo.
echo %r%Please select a number from the Main
echo %r%Menu [1-8] or type 'Quit' to Leave.
echo %g%_____________________________________
echo.
echo.
echo %g%======PRESS ANY KEY TO CONTINUE======

:ProgramDebloat
cls
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "EulaAccepted" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "Windowplacement" /t REG_BINARY /d "2c0000000200000003000000ffffffffffffffffffffffffffffffff75030000110000009506000069020000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "FindWindowplacement" /t REG_BINARY /d "2c00000000000000000000000000000000000000000000000000000096000000960000000000000000000000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "SysinfoWindowplacement" /t REG_BINARY /d "2c00000000000000010000000000000000000000ffffffffffffffff28000000280000002b0300002b020000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "PropWindowplacement" /t REG_BINARY /d "2c00000000000000000000000000000000000000000000000000000028000000280000000000000000000000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DllPropWindowplacement" /t REG_BINARY /d "2c00000000000000010000000000000000000000ffffffffffffffff2800000028000000e70100009f020000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "UnicodeFont" /t REG_BINARY /d "080000000000000000000000000000009001000000000000000000004d00530020005300680065006c006c00200044006c00670000000000000000000000000000000000000000000000000000000000000000000000000000000000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "Divider" /t REG_BINARY /d "531f0e151662ea3f" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "SavedDivider" /t REG_BINARY /d "531f0e151662ea3f" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ProcessImageColumnWidth" /t REG_DWORD /d "261" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowUnnamedHandles" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowDllView" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HandleSortColumn" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HandleSortDirection" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DllSortColumn" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DllSortDirection" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ProcessSortColumn" /t REG_DWORD /d "4294967295" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ProcessSortDirection" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightServices" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightOwnProcesses" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightRelocatedDlls" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightJobs" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightNewProc" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightDelProc" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightImmersive" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightProtected" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightPacked" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightNetProcess" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightSuspend" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HighlightDuration" /t REG_DWORD /d "1000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowCpuFractions" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowLowerpane" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowAllUsers" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowProcessTree" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "SymbolWarningShown" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HideWhenMinimized" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "AlwaysOntop" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "OneInstance" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "NumColumnSets" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ConfirmKill" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "RefreshRate" /t REG_DWORD /d "5000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "PrcessColumnCount" /t REG_DWORD /d "18" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DllColumnCount" /t REG_DWORD /d "5" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "HandleColumnCount" /t REG_DWORD /d "2" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DefaultProcPropPage" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DefaultSysInfoPage" /t REG_DWORD /d "4" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DefaultDllPropPage" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "DbgHelpPath" /t REG_SZ /d "C:\Windows\SYSTEM32\dbghelp.dll" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "SymbolPath" /t REG_SZ /d "" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorPacked" /t REG_DWORD /d "16711808" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorImmersive" /t REG_DWORD /d "15395328" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorOwn" /t REG_DWORD /d "16765136" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorServices" /t REG_DWORD /d "13684991" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorRelocatedDlls" /t REG_DWORD /d "10551295" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorGraphBk" /t REG_DWORD /d "15790320" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorJobs" /t REG_DWORD /d "27856" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorDelProc" /t REG_DWORD /d "4605695" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorNewProc" /t REG_DWORD /d "4652870" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorNet" /t REG_DWORD /d "10551295" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorProtected" /t REG_DWORD /d "8388863" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowHeatmaps" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ColorSuspend" /t REG_DWORD /d "8421504" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "StatusBarColumns" /t REG_DWORD /d "13589" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowAllCpus" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowAllGpus" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "Opacity" /t REG_DWORD /d "100" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "GpuNodeUsageMask" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "GpuNodeUsageMask1" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "VerifySignatures" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "VirusTotalCheck" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "VirusTotalSubmitUnknown" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ToolbarBands" /t REG_BINARY /d "0601000000000000000000004b00000001000000000000004b00000002000000000000004b00000003000000000000004b0000000400000000000000400000000500000000000000500000000600000000000000930400000700000000000000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "UseGoogle" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowNewProcesses" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "TrayCPUHistory" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowIoTray" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowNetTray" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowDiskTray" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowPhysTray" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowCommitTray" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ShowGpuTray" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "FormatIoBytes" /t REG_DWORD /d "1" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "StackWindowPlacement" /t REG_BINARY /d "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer" /v "ETWstandardUserWarning" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumnMap" /v "0" /t REG_DWORD /d "26" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumnMap" /v "1" /t REG_DWORD /d "42" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumnMap" /v "2" /t REG_DWORD /d "1033" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumnMap" /v "3" /t REG_DWORD /d "1111" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumnMap" /v "4" /t REG_DWORD /d "1670" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumns" /v "0" /t REG_DWORD /d "110" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumns" /v "1" /t REG_DWORD /d "180" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumns" /v "2" /t REG_DWORD /d "140" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumns" /v "3" /t REG_DWORD /d "300" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\DllColumns" /v "4" /t REG_DWORD /d "100" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\HandleColumnMap" /v "0" /t REG_DWORD /d "21" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\HandleColumnMap" /v "1" /t REG_DWORD /d "22" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\HandleColumns" /v "0" /t REG_DWORD /d "100" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\HandleColumns" /v "1" /t REG_DWORD /d "450" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "0" /t REG_DWORD /d "3" /f
cls
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "1" /t REG_DWORD /d "1055" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "2" /t REG_DWORD /d "1650" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "3" /t REG_DWORD /d "1200" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "4" /t REG_DWORD /d "1092" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "5" /t REG_DWORD /d "1333" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "6" /t REG_DWORD /d "1622" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "7" /t REG_DWORD /d "1636" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "8" /t REG_DWORD /d "1179" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "9" /t REG_DWORD /d "1340" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "10" /t REG_DWORD /d "5" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "11" /t REG_DWORD /d "1339" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "12" /t REG_DWORD /d "1060" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "13" /t REG_DWORD /d "1063" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "14" /t REG_DWORD /d "4" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "15" /t REG_DWORD /d "1065" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "16" /t REG_DWORD /d "18" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "17" /t REG_DWORD /d "1670" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "18" /t REG_DWORD /d "1653" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumnMap" /v "19" /t REG_DWORD /d "1653" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "0" /t REG_DWORD /d "261" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "1" /t REG_DWORD /d "35" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "2" /t REG_DWORD /d "37" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "3" /t REG_DWORD /d "82" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "4" /t REG_DWORD /d "81" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "5" /t REG_DWORD /d "65" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "6" /t REG_DWORD /d "93" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "7" /t REG_DWORD /d "76" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "8" /t REG_DWORD /d "55" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "9" /t REG_DWORD /d "60" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "10" /t REG_DWORD /d "39" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "11" /t REG_DWORD /d "80" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "12" /t REG_DWORD /d "70" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "13" /t REG_DWORD /d "70" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "14" /t REG_DWORD /d "31" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "15" /t REG_DWORD /d "52" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "16" /t REG_DWORD /d "52" /f
Reg.exe add "HKCU\SOFTWARE\Sysinternals\Process Explorer\ProcessColumns" /v "17" /t REG_DWORD /d "44" /f
PowerShell -Command "Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.BingWeather* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.Getstarted* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.Messaging* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.Microsoft3DViewer* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.MicrosoftOfficeHub* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.NetworkSpeedTest* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.News* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.Office.Lens* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.Office.OneNote* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.Office.Sway* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.OneConnect* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.People* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.Print3D* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.SkypeApp* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.Office.Todo.List* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.Whiteboard* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.WindowsAlarms* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *microsoft.windowscommunicationsapps* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.WindowsMaps* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.WindowsSoundRecorder* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.Xbox.TCUI* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.WindowsStore* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.StorePurchaseApp* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.XboxApp* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.XboxGameOverlay* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.XboxIdentityProvider* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.XboxSpeechToTextOverlay* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.ZuneMusic* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.ZuneVideo* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *EclipseManager* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *ActiproSoftwareLLC* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *AdobeSystemsIncorporated.AdobePhotoshopExpress* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Duolingo-LearnLanguagesforFree* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *PandoraMediaInc* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *CandyCrush* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *BubbleWitch3Saga* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Wunderlist* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Flipboard* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Facebook* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Royal Revolt* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Sway* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Speed Test* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Dolby* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.MSPaint* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.MicrosoftStickyNotes* | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.549981C3F5F10' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.WindowsFeedbackHub' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.WindowsMaps' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.Advertising.Xaml' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.NetworkSpeedTest' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.BingWeather' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.BingSports' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.BingNews' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.BingFinance' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.MicrosoftOfficeHub' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.XboxApp' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.Xbox.TCUI' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.XboxGamingOverlay' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.XboxGameOverlay' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.XboxIdentityProvider' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.XboxSpeechToTextOverlay' | Remove-AppxPackage"
PowerShell -ExecutionPolicy Unrestricted -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Windows.Holographic.FirstRun'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
PowerShell -ExecutionPolicy Unrestricted -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Windows.ParentalControls'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
PowerShell -ExecutionPolicy Unrestricted -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.WindowsFeedback'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
PowerShell -ExecutionPolicy Unrestricted -Command "$package = Get-AppxPackage -AllUsers 'Windows.CBSPreview'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Applied Debloat Tweaks.
timeout /t 3 >nul
pause >nul
goto :GameBoosters

:Affinity
cls
for /f "tokens=*" %%f in ('wmic cpu get NumberOfCores /value ^| find "="') do set %%f
for /f "tokens=*" %%f in ('wmic cpu get NumberOfLogicalProcessors /value ^| find "="') do set %%f
if "!NumberOfCores!" == "2" (
	goto HyperThreading
)
if !NumberOfCores! gtr 4 (
	for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
		reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "3" /f
		reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /f
	) > nul 2> nul
	for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
		reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "5" /f
		reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /f
	) > nul 2> nul
)

:: Hyper Threading ; Credits to HoneCtrl
:HyperThreading
if !NumberOfLogicalProcessors! gtr !NumberOfCores! (
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "4" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /t REG_BINARY /d "C0" /f
	) > nul 2> nul
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "4" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /t REG_BINARY /d "C0" /f
	) > nul 2> nul
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "4" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /t REG_BINARY /d "30" /f
	) > nul 2> nul
)
echo Applied Affinity Tweaks.
timeout /t 3 >nul
pause >nul
goto :GameBoosters

:MSIMode
cls
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
) > nul 2> nul

for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
) > nul 2> nul

for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
) > nul 2> nul

for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID ^| findstr /l "PCI\VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f
) > nul 2> nul

:: Set Priority to Normal if used on VMWare
for /f %%i in ('wmic path win32_NetworkAdapter get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" (
for /f "delims=" %%# in ('"wmic computersystem get manufacturer /format:value"') do set "%%#" >nul & if "!Manufacturer:VMWare=!" neq "!Manufacturer!" (set "VMWare= /t REG_DWORD /d 2") else (set "VMWare=")
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority"%VMWare% /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "2" /f
) > nul 2> nul
echo Applied MSI Mode.
timeout /t 3 >nul
pause >nul
goto :GameBoosters

:ScheduledTasks
cls
schtasks /change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /DISABLE
schtasks /change /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /DISABLE
schtasks /change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /DISABLE
schtasks /Change /TN "Microsoft\Windows\ErrorDetails\EnableErrorDetailsUpdate" /Disable
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable
schtasks /change /TN "Microsoft\Windows\Device Information\Device" /disable
schtasks /change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable
schtasks /change /TN "Microsoft\Windows\Application Experience\AitAgent" /disable
schtasks /change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /disable
schtasks /change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable
schtasks /Change /TN "Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh" /Disable 2>nul
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Disable 2>nul
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Disable 2>nul
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Disable 2>nul
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /Disable 2>nul
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Uploader" /Disable
schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyUpload" /Disable
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /Disable
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /Disable
schtasks /Change /TN "Microsoft\Office\Office 15 Subscription Heartbeat" /Disable
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Diagnosis\Scheduled" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\DiskFootprint\Diagnostics" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\InstallService\ScanForUpdates" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Registry\RegIdleBackup" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\StateRepository\MaintenanceTasks" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\SystemRestore\SR" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\WDI\ResolutionHost" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\ApplicationData\appuriverifierdaily" >nul 2>&11
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Application Experience\StartupAppTask" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Application Experience\MareBackup" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Autochk\Proxy" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Device Information\Device User" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Device Information\Device" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Feedback\Siuf\DmClient" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Flighting\FeatureConfig\ReconcileFeatures" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Flighting\FeatureConfig\UsageDataFlushing" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Flighting\FeatureConfig\UsageDataReporting" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Input\InputSettingsRestoreDataAvailable" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Input\LocalUserSyncDataAvailable" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Input\MouseSyncDataAvailable" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Input\PenSyncDataAvailable" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Input\syncpensettings" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Input\TouchpadSyncDataAvailable" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Location\Notifications" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Location\WindowsActionDialog" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\ApplicationData\DsSvcCleanup" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Maintenance\WinSAT" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\PI\Sqm-Tasks" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Maps\MapsToastTask" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\Maps\MapsUpdateTask" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" >nul 2>&1
powerrun "schtasks.exe" /change /disable /TN "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" >nul 2>&1
powerrun "schtasks.exe" /delete /f /tn "\Microsoft\Windows\TaskScheduler" >nul 2>&1
powerrun "schtasks.exe" /delete /f /tn "\Microsoft\Windows\WaaSMedic" >nul 2>&1
powerrun "schtasks.exe" /delete /f /tn "\Microsoft\Windows\WindowsUpdate" >nul 2>&1
powerrun "schtasks.exe" /delete /f /tn "\Microsoft\Windows\WindowsUpdate\Scheduled Start" >nul 2>&1
powerrun "schtasks.exe" /delete /f /tn "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" >nul 2>&1
powerrun "schtasks.exe" /delete /f /tn "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task" >nul 2>&1
powerrun "schtasks.exe" /delete /f /tn "\Microsoft\Windows\UpdateOrchestrator\Schedule Wake To Work" >nul 2>&1
powerrun "schtasks.exe" /delete /f /tn "\Microsoft\Windows\UpdateOrchestrator\Start Oobe Expedite Work" >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\ErrorDetails\EnableErrorDetailsUpdate" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Application Experience\AitAgent" /DISABLE >nul
schtasks /Change /TN "\Microsoft\Windows\Media Center\ehDRMInit" /DISABLE > nul
schtasks /change /TN NvTmMon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8} /DISABLE
schtasks /change /TN NvTmRep_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8} /DISABLE
schtasks /change /TN NvTmRepOnLogon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8} /DISABLE
schtasks /change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /DISABLE
schtasks /change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack2016" /DISABLE
schtasks /change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /DISABLE
schtasks /change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn2016" /DISABLE
schtasks /change /tn "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable
schtasks /Change /TN "Microsoft\Windows\AppID\SmartScreenSpecific" /Disable
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable
schtasks /Change /TN "Microsoft\Windows\FileHistory\File History (maintenance mode)" /Disable
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /Disable
schtasks /Change /TN "Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable
schtasks /Change /TN "Microsoft\Windows\PI\Sqm-Tasks" /Disable
schtasks /Change /TN "Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" /Disable
schtasks /Change /TN "Microsoft\Windows\Time Synchronization\SynchronizeTime" /Disable
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Enable
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Enable
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Enable
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /Enable
schtasks /Delete /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /F
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM"
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM" /disable
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /disable
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader"
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" /disable
schtasks /end /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable
schtasks /end /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
schtasks /change /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable
schtasks /end /tn "\Microsoft\Windows\Application Experience\StartupAppTask"
schtasks /change /tn "\Microsoft\Windows\Application Experience\StartupAppTask" /disable
schtasks /end /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable
schtasks /end /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver"
schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver" /disable
schtasks /end /tn "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
schtasks /change /tn "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /disable
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyMonitor"
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyMonitor" /disable
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyRefresh"
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyRefresh" /disable
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyUpload"
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyUpload" /disable
schtasks /end /tn "\Microsoft\Windows\Autochk\Proxy"
schtasks /change /tn "\Microsoft\Windows\Autochk\Proxy" /disable
schtasks /end /tn "\Microsoft\Windows\Maintenance\WinSAT"
schtasks /change /tn "\Microsoft\Windows\Maintenance\WinSAT" /disable
schtasks /end /tn "\Microsoft\Windows\Application Experience\AitAgent"
schtasks /change /tn "\Microsoft\Windows\Application Experience\AitAgent" /disable
schtasks /end /tn "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
schtasks /change /tn "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable
schtasks /end /tn "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
schtasks /change /tn "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /disable
schtasks /end /tn "\Microsoft\Windows\DiskFootprint\Diagnostics"
schtasks /change /tn "\Microsoft\Windows\DiskFootprint\Diagnostics" /disable
schtasks /end /tn "\Microsoft\Windows\FileHistory\File History (maintenance mode)"
schtasks /change /tn "\Microsoft\Windows\FileHistory\File History (maintenance mode)" /disable
schtasks /end /tn "\Microsoft\Windows\PI\Sqm-Tasks"
schtasks /change /tn "\Microsoft\Windows\PI\Sqm-Tasks" /disable
schtasks /end /tn "\Microsoft\Windows\NetTrace\GatherNetworkInfo"
schtasks /change /tn "\Microsoft\Windows\NetTrace\GatherNetworkInfo" /disable
schtasks /end /tn "\Microsoft\Windows\AppID\SmartScreenSpecific"
schtasks /change /tn "\Microsoft\Windows\AppID\SmartScreenSpecific" /disable
schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentFallBack2016"
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentFallBack2016" /disable
schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn2016"
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn2016" /disable
schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn"
schtasks /change /TN "\Microsoft\Office\OfficeTelemetryAgentLogOn" /disable
schtasks /end /tn "\Microsoftd\Office\OfficeTelemetryAgentFallBack"
schtasks /change /TN "\Microsoftd\Office\OfficeTelemetryAgentFallBack" /disable
schtasks /end /tn "\Microsoft\Office\Office 15 Subscription Heartbeat"
schtasks /change /TN "\Microsoft\Office\Office 15 Subscription Heartbeat" /disable
schtasks /end /tn "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime"
schtasks /change /TN "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" /disable
schtasks /end /tn "\Microsoft\Windows\Time Synchronization\SynchronizeTime"
schtasks /change /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime" /disable
schtasks /end /tn "\Microsoft\Windows\WindowsUpdate\Automatic App Update"
schtasks /change /TN "\Microsoft\Windows\WindowsUpdate\Automatic App Update" /disable
schtasks /end /tn "\Microsoft\Windows\Device Information\Device"
schtasks /change /TN "\Microsoft\Windows\Device Information\Device" /disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\PcaPatchDbTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
schtasks /Change /TN "Microsoft\Windows\Defrag\ScheduledDefrag" /Disable
schtasks /Change /TN "Microsoft\Windows\Device Information\Device" /Disable
schtasks /Change /TN "Microsoft\Windows\Device Information\Device User" /Disable
schtasks /Change /TN "Microsoft\Windows\DiskCleanup\SilentCleanup" /Disable
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable
schtasks /Change /TN "Microsoft\Windows\DiskFootprint\Diagnostics" /Disable
schtasks /Change /TN "Microsoft\Windows\DiskFootprint\StorageSense" /Disable
schtasks /Change /TN "Microsoft\Windows\DUSM\dusmtask" /Disable
schtasks /Change /TN "Microsoft\Windows\EnterpriseMgmt\MDMMaintenenceTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClient" /Disable
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /Disable
schtasks /Change /TN "Microsoft\Windows\Flighting\FeatureConfig\ReconcileFeatures" /Disable
schtasks /Change /TN "Microsoft\Windows\Flighting\FeatureConfig\UsageDataFlushing" /Disable
schtasks /Change /TN "Microsoft\Windows\Flighting\FeatureConfig\UsageDataReporting" /Disable
schtasks /Change /TN "Microsoft\Windows\Flighting\OneSettings\RefreshCache" /Disable
schtasks /Change /TN "Microsoft\Windows\Input\LocalUserSyncDataAvailable" /Disable
schtasks /Change /TN "Microsoft\Windows\Input\MouseSyncDataAvailable" /Disable
schtasks /Change /TN "Microsoft\Windows\Input\PenSyncDataAvailable" /Disable
schtasks /Change /TN "Microsoft\Windows\Input\TouchpadSyncDataAvailable" /Disable
schtasks /Change /TN "Microsoft\Windows\International\Synchronize Language Settings" /Disable
schtasks /Change /TN "Microsoft\Windows\LanguageComponentsInstaller\Installation" /Disable
schtasks /Change /TN "Microsoft\Windows\LanguageComponentsInstaller\ReconcileLanguageResources" /Disable
schtasks /Change /TN "Microsoft\Windows\LanguageComponentsInstaller\Uninstallation" /Disable
schtasks /Change /TN "Microsoft\Windows\License Manager\TempSignedLicenseExchange" /Disable
schtasks /Change /TN "Microsoft\Windows\License Manager\TempSignedLicenseExchange" /Disable
schtasks /Change /TN "Microsoft\Windows\Management\Provisioning\Cellular" /Disable
schtasks /Change /TN "Microsoft\Windows\Management\Provisioning\Logon" /Disable
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /Disable
schtasks /Change /TN "Microsoft\Windows\Maps\MapsToastTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Maps\MapsUpdateTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser" /Disable
schtasks /Change /TN "Microsoft\Windows\MUI\LPRemove" /Disable
schtasks /Change /TN "Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable
schtasks /Change /TN "Microsoft\Windows\PI\Sqm-Tasks" /Disable
schtasks /Change /TN "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /Disable
schtasks /Change /TN "Microsoft\Windows\PushToInstall\Registration" /Disable
schtasks /Change /TN "Microsoft\Windows\Ras\MobilityManager" /Disable
schtasks /Change /TN "Microsoft\Windows\RecoveryEnvironment\VerifyWinRE" /Disable
schtasks /Change /TN "Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" /Disable
schtasks /Change /TN "Microsoft\Windows\RetailDemo\CleanupOfflineContent" /Disable
schtasks /Change /TN "Microsoft\Windows\Servicing\StartComponentCleanup" /Disable
schtasks /Change /TN "Microsoft\Windows\SettingSync\NetworkStateChangeTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Setup\SetupCleanupTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Setup\SnapshotCleanupTask" /Disable
schtasks /Change /TN "Microsoft\Windows\SpacePort\SpaceAgentTask" /Disable
schtasks /Change /TN "Microsoft\Windows\SpacePort\SpaceManagerTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Speech\SpeechModelDownloadTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Storage Tiers Management\Storage Tiers Management Initialization" /Disable
schtasks /Change /TN "Microsoft\Windows\Sysmain\ResPriStaticDbSync" /Disable
schtasks /Change /TN "Microsoft\Windows\Sysmain\WsSwapAssessmentTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Task Manager\Interactive" /Disable
schtasks /Change /TN "Microsoft\Windows\TPM\Tpm-HASCertRetr" /Disable
schtasks /Change /TN "Microsoft\Windows\TPM\Tpm-Maintenance" /Disable
schtasks /Change /TN "Microsoft\Windows\UPnP\UPnPHostConfig" /Disable
schtasks /Change /TN "Microsoft\Windows\User Profile Service\HiveUploadTask" /Disable
schtasks /Change /TN "Microsoft\Windows\WDI\ResolutionHost" /Disable
schtasks /Change /TN "Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange" /Disable
schtasks /Change /TN "Microsoft\Windows\WOF\WIM-Hash-Management" /Disable
schtasks /Change /TN "Microsoft\Windows\WOF\WIM-Hash-Validation" /Disable
schtasks /Change /TN "Microsoft\Windows\Work Folders\Work Folders Logon Synchronization" /Disable
schtasks /Change /TN "Microsoft\Windows\Work Folders\Work Folders Maintenance Work" /Disable
schtasks /Change /TN "Microsoft\Windows\Workplace Join\Automatic-Device-Join" /Disable
schtasks /Change /TN "Microsoft\Windows\WwanSvc\NotificationTask" /Disable
schtasks /Change /TN "Microsoft\Windows\WwanSvc\OobeDiscovery" /Disable
schtasks /Change /Disable /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\WindowsUpdate\sihpostreboot" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\PcaPatchDbTask" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\StartupAppTask" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Device Information\Device" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Device Information\Device User" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\WaaSMedic\PerformRemediation" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskFootprint\Diagnostics" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskFootprint\StorageSense" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Registry\RegIdleBackup" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork"  > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskLogon" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\StateRepository\MaintenanceTasks" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UPnP\UPnPHostConfig" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\RetailDemo\CleanupOfflineContent" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\ScanForUpdates" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\SmartRetry" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\International\Synchronize Language Settings" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Printing\EduPrintProv" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Ras\MobilityManager" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Zone\SynchronizeTimeZone" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskCleanup\SilentCleanup" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Diagnosis\Scheduled" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Wininet\CacheTask" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\NetTrace\GatherNetworkInfo" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\TPM\Tpm-HASCertRetr" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\TPM\Tpm-Maintenance" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Sysmain\ResPriStaticDbSync" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\ApplicationData\appuriverifierdaily" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\ApplicationData\appuriverifierinstall" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\ApplicationData\DsSvcCleanup" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64 Critical" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 Critical" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\XblGameSave\XblGameSaveTask" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\XblGameSave\XblGameSaveTaskLogon" > nul 2> nul
schtasks /Change /Disable /TN "\Microsoft\WindowsManagement\Provisioning\Cellular" > nul 2> nul
echo Applied Scheduled Tasks Tweaks.
timeout /t 3 >nul
pause >nul
goto :GameBoosters

:Boosters
cls
color 03
cls
echo ---------------------------------------------------------------------------------------------------------------------
echo       Game Boosters
echo ---------------------------------------------------------------------------------------------------------------------
echo 0. Go Back
echo 1. Valorant
echo 2. Counter-Strike 2
echo 3. Minecraft
echo 4. Fortnite
echo 5. Warzone                                                                                                                                                                                                                                                             
echo --------------------------------------------------------------------------------------------------------------------
set choice=
set /p choice=Type A Number:
if not '%choice%'=='' set choice=%choice:~0,100%
if '%choice%'=='0' goto AdvancedMenu
if '%choice%'=='1' goto Valorant
if '%choice%'=='2' goto CS2
if '%choice%'=='3' goto Minecraft
if '%choice%'=='4' goto Fortnite
if '%choice%'=='4' goto Warzone

:Valorant
:: Enable CFG for Valorant
for %%i in (valorant valorant-win64-shipping vgtray vgc) do (
    PowerShell -NoProfile -Command "Set-ProcessMitigation -Name %%i.exe -Enable CFG"
)
bcdedit /set testsigning Off
bcdedit /set nointegritychecks Off

::reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t REG_BINARY /d "222222222222222222222222222222222222222222222222" /f
::reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "232222222223222222222222222222222222222222222222" /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Version" /t REG_SZ /d "1.0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Application Name" /t REG_SZ /d "valorant.exe" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Protocol" /t REG_SZ /d "*" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Local Port" /t REG_SZ /d "*" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Local IP" /t REG_SZ /d "*" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Local IP Prefix Length" /t REG_SZ /d "*" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Remote Port" /t REG_SZ /d "*" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Remote IP" /t REG_SZ /d "*" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Remote IP Prefix Length" /t REG_SZ /d "*" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "DSCP Value" /t REG_SZ /d "46" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Throttle Rate" /t REG_SZ /d "-1" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Version" /t REG_SZ /d "1.0" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Application Name" /t REG_SZ /d "VALORANT-Win64-Shipping.exe" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Protocol" /t REG_SZ /d "*" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Local Port" /t REG_SZ /d "*" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Local IP" /t REG_SZ /d "*" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Local IP Prefix Length" /t REG_SZ /d "*" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Remote Port" /t REG_SZ /d "*" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Remote IP" /t REG_SZ /d "*" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Remote IP Prefix Length" /t REG_SZ /d "*" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "DSCP Value" /t REG_SZ /d "46" /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Throttle Rate" /t REG_SZ /d "-1" /f
wmic process where name="RiotClientServices.exe" CALL setpriority "high priority"
reg add "HKCU\Software\Riot Games\Riot Client" /v "autoUpdateOnLaunch" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Riot Games\Riot Client" /v "pingUrl" /t REG_SZ /d "" /f
echo.
echo Applied Valorant Tweaks.
timeout /t 3 >nul
pause >nul
goto :GameBoosters

:Fortnite
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions" /t REG_DWORD /v CpuPriorityClass /d 3 /f
cd %localappdata%
rmdir /s /q FortniteGame
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 00000026 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 00000010 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\WMPlayer" /v "Priority" /t REG_DWORD /d 00000002 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\Audio" /v "Priority" /t REG_DWORD /d 00000001 /f
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.ResolutionQuality" /t REG_DWORD /d 30 /f
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.ShadowQuality" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.EffectsQuality" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.TexturesQuality" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.bSmoothFrameRate" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.ViewDistanceQuality" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Epic Games\Unreal Engine\Identifiers\Fortnite" /v "sg.GameThreadPriority" /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f
reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_DWORD /d 10 /f
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_DWORD /d 1 /f
cls
echo Applied Fortnite Tweaks.
timeout /t 3 >nul
pause >nul
goto :GameBoosters

:CS2
mic process where name="cs2.exe" CALL setpriority "high priority"
reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_DWORD /d 10 /f
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "Path\To\cs2.exe" /t REG_SZ /d "~DISABLEMOUSEACCELERATION" /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPerServer" /t REG_DWORD /d 8 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPer1_0Server" /t REG_DWORD /d 8 /f
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=false
wmic pagefileset where name="_Total" set InitialSize=8192, MaximumSize=8192
reg add "HKCU\System\GameConfigStore" /v "GameBarEnabled" /t REG_DWORD /d 0 /f
taskkill /f /im "steam.exe"
reg add "HKCU\Software\Valve\Steam" /v "EnableOverlay" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Valve\Steam" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Valve\Steam" /v "TcpNoDelay" /t REG_DWORD /d 1 /f
rd /s /q "%APPDATA%\Steam\htmlcache"
rd /s /q "%PROGRAMFILES(X86)%\Steam\appcache"
reg add "HKCU\Software\Valve\Steam" /v "AutoUpdateEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Valve\Steam" /v "SilentStartup" /t REG_DWORD /d 1 /f
cls
echo Applied CS2 Tweaks.
timeout /t 3 >nul
pause >nul
goto :GameBoosters

:Warzone
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ModernWarfare.exe" /v "Win32PrioritySeparation" /t REG_DWORD /d 26 /f
reg add "HKCU\Software\Activision\ModernWarfare" /v "VideoMemoryScale" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Activision\ModernWarfare" /v "VerticalSyncEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t REG_DWORD /d 65536 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d 65536 /f
reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_DWORD /d 10 /f
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_DWORD /d 1 /f
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=false
wmic pagefileset where name="_Total" set InitialSize=8192, MaximumSize=8192
cls
echo Applied Warzone Tweaks.
timeout /t 3 >nul
pause >nul
goto :GameBoosters

:Minecraft
echo   Open Minecraft launcher and put the code inside JVMarguments in JVM Arguments
timeout /t 3 >nul
pause >nul
(
	echo of -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=10 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=true -Daikars.new.flags=true
) > JVMarguments.txt
echo.
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
	echo ofStars:fale
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
echo Applied Minecraft Tweaks.
timeout /t 3 >nul
pause >nul
goto :GameBoosters

:Toolbox
cls
color 03
echo ____________________________________________________________________________________________
echo.
color 03
echo                                          Hello %username%
echo.
echo.
echo                               You are currently on version %version%
echo.
echo                             - Thank you for using Batlez Toolbox! -
echo ____________________________________________________________________________________________
echo.                                                        
echo           ===========================================================================
echo           " For Batlez Toolbox - please note that this is currently in development! "
echo           ===========================================================================
echo           ===========================================================================
echo           "  Currently working on every Windows build Please be aware of any bugs   "
echo           ===========================================================================
echo.
echo                               Press any key to start Batlez Toolbox!
pause >nul
:continue
cls
color 03
cls
echo ---------------------------------------------------------------------------------------------------------------------
echo       Tweaks and Software
echo ---------------------------------------------------------------------------------------------------------------------
echo 0. Go Back
echo 1. Software Installs (Chocolately)                                                                                                                                                                                                                                                               
echo --------------------------------------------------------------------------------------------------------------------
set choice=
set /p choice=Type A Number:
if not '%choice%'=='' set choice=%choice:~0,100%
if '%choice%'=='0' goto AdvancedMenu
if '%choice%'=='1' goto continue1

:continue1
cls
if exist "C:\ProgramData\chocolatey" goto 89
if not exist "C:\ProgramData\chocolatey" goto InstallChoco

:InstallChoco
cls
mode con cols=100 lines=30
echo Installing Chocolatey Please Wait.
timeout 1 > nul
powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
"%ALLUSERSPROFILE%\chocolatey\bin\RefreshEnv.cmd
if %errorlevel% equ 0 goto ChocoFailed
if %errorlevel% neq 0 goto ChocoNice
goto 89

:ChocoFailed
:: Dialog Box to show Chocolatey Failed to install.
cls
set msgboxTitle=Chocolatey Installation
set msgboxBody=Failed to install Chocolatey. Any software you try to install in the Toolbox will NOT work.
set tmpmsgbox=%temp%\~tmpmsgbox.vbs
if exist "%tmpmsgbox%" DEL /F /Q "%tmpmsgbox%"
echo msgbox "%msgboxBody%",0,"%msgboxTitle%">"%tmpmsgbox%"
WSCRIPT "%tmpmsgbox%" && goto start

:ChocoNice
cls
:: Dialog Box to show Chocolatey installed successfully.
set msgboxTitle=Chocolatey Installation
set msgboxBody=Successfully installed Chocolatey. All softwares you try to install in the optimizer should work.
set tmpmsgbox=%temp%\~tmpmsgbox.vbs
if exist "%tmpmsgbox%" DEL /F /Q "%tmpmsgbox%"
echo msgbox "%msgboxBody%",0,"%msgboxTitle%">"%tmpmsgbox%"
WSCRIPT "%tmpmsgbox%" && goto 89

:89
cls
title Batlez Tweaks - Toolbox
echo -----------------------------------------------------------------------------------------------------------------------
echo Users Request
echo 1. Avast                         17. Paint.net
echo 2. AnyDesk                       18. Rufus
echo 3. Audacity                      19. Winrar Themes
echo 4. Blender                       20. Image Glass
echo 5. "C++ RunTime"                 21. Windows Terminal and Icons Mod
echo 6. MS Office                     22. Google Chrome
echo 7. .NET Framework 3              23. GitHub
echo 8. winrar                        24. Visual Studio Code
echo 9. DirectX                       25. Discord and Discord Canary
echo 10. VMware 16.0                  26. Spotify and Toastify Mod
echo 11. Adobe Acrobat Reader DC      27. Razer Cortex
echo 12. JavaSE RuntimeEnvironment 8  28. ApowerMirror
echo 13. Notepad++                    29. Aimp 
echo 14. VLC                          30. Google Chrome
echo 15. Pyhton                       31. Google Drive
echo 16. Office 365 Business          32. Steam
echo 33. Epic Games                   34. Glary Utilities 5
echo 35. Malwarebytes                 36. CCleaner
echo 37. Winamp                       38. Foobar2000
echo 39. Twitch                       40. WPS Office
echo 41. Camtasia                     42. Sysinternals
echo 43. Chromium                     44. CygWim
echo 45. Dropbox                      46. Virtualbox
echo 47. Winaero Tweaker              48. Iobit Program Pack
echo 49. Process Explorer             50. WinDirStat
echo 51. Everything                   52. Visual Studio 2022 Pro
echo 53. Adobe Shockwave Player       54. Roblox
echo 55. Opera Browser                56. Mario Bros
echo 57. Popcorn Time                 58. Qbitorrent
echo 59. TeamViewer                   60. AnyDesk
echo 61. OneDrive                     62. Process Hacker    
echo ---------------------------------------------------------------------------------------------------------------------
echo 0. Back to menu
set choice=
set /p choice=Type A Number:
if not '%choice%'=='' set choice=%choice:~0,100%
if '%choice%'=='1' choco install avastfreeantivirus -y
if '%choice%'=='2' choco install anydesk anydesk.install anydesk.portable -y
if '%choice%'=='3' choco install audacity -y
if '%choice%'=='4' choco install blender -y
if '%choice%'=='5' choco install vcredist2005 vcredist2008 vcredist2010  vcredist2012 msvisualcplusplus2012-redist vcredist2013 msvisualcplusplus2013-redis vcredist2017 vcredist140 vcredist-all -y
if '%choice%'=='6' choco install office365business -y
if '%choice%'=='7' DISM /Online /Enable-Feature /FeatureName:NetFx3 /All 
if '%choice%'=='8' choco install winrar -y
if '%choice%'=='9' choco install directx -y
if '%choice%'=='10' choco install vmware-workstation-player -y
if '%choice%'=='11' choco install adobereader -y
if '%choice%'=='12' choco install jre8 -y
if '%choice%'=='13' choco install notepadplusplus.install -y
if '%choice%'=='14' choco install vlc -y
if '%choice%'=='15' choco install python3 -y
if '%choice%'=='16' choco install office365business -y
if '%choice%'=='17' choco install paint.net -y
if '%choice%'=='18' choco install rufus -y
if '%choice%'=='19' choco install winrar -y
if '%choice%'=='20' choco install imageglass -y
if '%choice%'=='21' choco install microsoft-windows-te          rminal terminal-icons.powershell -y
if '%choice%'=='22' choco install googlechrome -y
if '%choice%'=='23' choco install github github-desktop -y
if '%choice%'=='24' choco install vscode -y
if '%choice%'=='25' choco install discord discord.install discord-canary -y
if '%choice%'=='26' choco install spotify toastify -y
if '%choice%'=='27' choco install gamebooster -y
if "%choice%"=="28" (
    choco install curl
    curl -o "%TEMP%\apowermirror-setup.exe" "https://download.apowersoft.com/down.php?softid=apowermirror"
    pause /5
    start "" "%TEMP%\apowermirror-setup.exe"
)
if '%choice%'=='29' choco install aimp -y
if '%choice%'=='30' choco install googlechrome  google-translate-chrome save-to-google-drive-chrome -y
if '%choice%'=='31' choco install googledrive -y
if '%choice%'=='32' choco install steam-client -y
if '%choice%'=='33' choco install epicgameslauncher -y
if '%choice%'=='34' choco install glaryutilities-pro
if '%choice%'=='35' choco install malwarebytes -y
if '%choice%'== '36' choco install ccleaner ccleaner.portable -y
if '%choice%'== '37' choco install winamp -y
if '%choice%'== '38' choco install foobar2000 -y
if '%choice%'== '39' choco install twitch -y
if '%choice%'== '40' choco install wps-office-free -y
if '%choice%'== '41' choco install camtasia -y
if '%choice%'== '42' choco install sysinternals -y
if '%choice%'== '43' choco install chromium -y
if '%choice%'== '44' choco install cygwin -y
if '%choice%'== '45' choco install dropbox -y
if '%choice%'== '46' choco install virtualbox -y
if '%choice%'== '47' choco install winaero-tweaker -y
if '%choice%'== '48' choco install iobit-uninstaller iobit-malware-fighter io-unlocker -y
if '%choice%'== '49' choco install procexp -y
if '%choice%'== '50' choco install windirstat -y
if '%choice%'== '51' choco install everything -y
if '%choice%'== '52' choco install visualstudio2022professional -y
if '%choice%'== '53' choco install adobeshockwaveplayer -y
if "%choice%"=="54" (
    choco install curl
    curl -o %TEMP%\RobloxPlayerLauncher.exe https://setup.rbxcdn.com/version-c1236188328f4133-Roblox.exe
    start "" %TEMP%\RobloxPlayerLauncher.exe
)
if '%choice%'== '55' choco install opera -y
if '%choice%'== '56' choco install super-mario-bros-java -y
if '%choice%'== '57' choco install popcorntime -y
if '%choice%'== '58' choco install qbittorrent-enhanced -y
if '%choice%'== '59' choco install teamviewer -y  
if '%choice%'== '60' choco install anydesk -y
if '%choice%'== '61' choco install onedrive onedrivebully -y
if '%choice%'== '62' choco install processhacker.install -y 
if '%choice%'=='0' goto start
ECHO.
goto Toolbox

:Destruct
title Thanks for using Batlez Tweaks!
cls
echo.            
echo %u%Developed by: %c%Croakq
echo %u%Github: %c%https://github.com/Batlez
timeout /t 5 >nul
exit
