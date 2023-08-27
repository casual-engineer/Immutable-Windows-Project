@echo off

REM Check for admin rights, and restart with elevated privileges if not already elevated
>nul 2>&1 "%SYSTEMROOT%\System32\cacls.exe" "%SYSTEMROOT%\System32\config\system"

REM If the error level is 0, the script is running with admin rights
if "%errorlevel%"=="0" (
    goto :run
) else (
    goto :getadmin
)

:getadmin
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B

:run
REM Your script code starts here

REM Step 1: Stop the Windows Update service
net stop wuauserv

REM Step 2: Disable the Windows Update service
sc config wuauserv start= disabled

REM Step 3: Force a Group Policy update
gpupdate /force

echo Windows Update service has been stopped and disabled.
echo Group Policy has been updated.

pause

