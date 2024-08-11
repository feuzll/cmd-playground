echo off
dir "%~1\exl.ignore" >nul 2>&1
REM echo aga
if %ERRORLEVEL% NEQ 1 (
echo Skipping %1 cuz exl.ingore!
goto :eof
)
cd %1
call %~dp0BIGOPSEC.cmd call %~dp0filereact.cmd || echo Too many files in %1
REM for %%I in (.\*) do (
REM call :filereact "%CD%\%%~nxI"
REM )


for /D %%I in (.\*) do (
REM call :iteratexdirs "%CD%\%%~nxI"
call %~dp0BIGOPSEC.cmd call %~dp0iteratexdirs.cmd "%CD%\%%~nxI" || echo Too many folders in "%CD%\%%~nxI"
)
goto :eof