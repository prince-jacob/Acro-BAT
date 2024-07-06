@echo off
:: BatchGotAdmin
:-------------------------------------
REM --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

@echo off
echo Welcome to Acro-BAT!
echo.
echo install Adobe Acrobat DC Version:2023.006.20320 64bit and patch it to work with Windows 10 1903 and above.
echo https://github.com/prince-jacob
echo Press any key to continue...
pause > nul

md "%TEMP%\Pirate"
cls
echo Acro-BAT V1.9(2023) by V.
echo.
echo Downloading Adobe Acrobat DC...

rem Download the standalone Acrobat version needed
curl --output "%TEMP%\Pirate\Acrobat_DC_Web_x64_WWMUI.zip" https://####################/06072024/Acrobat_DC_Web_x64_WWMUI.zip

rem Check if the download was successful
if not exist "%TEMP%\Pirate\Acrobat_DC_Web_x64_WWMUI.zip" (
    echo Error: Failed to download Adobe Acrobat DC. Please check your internet connection, disable your Antivirus and try again.
    pause
    exit /b
)

echo Downloading Patch...

rem Download the Acrobat.dll
curl --output "%TEMP%\Pirate\AcrobatV.zip" https://#################/06072024/AcrobatV.zip

rem Check if the download was successful
if not exist "%TEMP%\Pirate\AcrobatV.zip" (
    echo Error: Failed to download the patch. Please check your internet connection, disable your Antivirus and try again.
    pause
    exit /b
)

echo.
rem Extracting Adobe Acrobat DC...
tar -xf "%TEMP%\Pirate\Acrobat_DC_Web_x64_WWMUI.zip" -C "%TEMP%\Pirate"

rem Extracting Patch file...
tar -xf "%TEMP%\Pirate\AcrobatV.zip" -C "%TEMP%\Pirate"
echo.

del /f "%TEMP%\Pirate\AcrobatV.zip"
del /f "%TEMP%\Pirate\Acrobat_DC_Web_x64_WWMUI.zip"

echo Installing Adobe Acrobat DC, uncheck genuine service, don't change anything else and don't close the installer.
echo After the installation, click FINISH!

rem Run the setup file silently
"%TEMP%\Pirate\Adobe Acrobat\setup.exe" /quiet

rem Replace the file inside Acrobat with the patched file.
xcopy /y "%TEMP%\Pirate\acrotray.exe" "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrotray.exe"
xcopy /y "%TEMP%\Pirate\Acrobat.dll" "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.dll"
xcopy /y "%TEMP%\Pirate\acrodistdll.dll" "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrodistdll.dll"

echo Patched!
echo.

rem Disable Adobe updater
sc config "AdobeARMservice" start= disabled
sc stop "AdobeARMservice"
echo Successfully disabled Adobe updater service!
echo.
echo Installation done!
echo.
echo If you want to avoid updates and be on the safe side, you can disable updates in Acrobat settings.
echo Acrobat: Edit ^> Preferences ^> Updater. Uncheck everything and click OK.

echo.

rmdir /s /q "%TEMP%\Pirate"
pause
