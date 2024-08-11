@echo off
REM group by entry points - filter by extensions - enumerate all "exfat drives" - launch by nested vimium approach
REM above too hard, use prepared file-based profiles
set ENTRYPOINT=fear
SETLOCAL DisableDelayedExpansion
REM SETLOCAL EnableDelayedExpansion
REM Any ExFAT Drive Ruled Launcher
REM ss64.com
set EXFATDRIVESCOUNT=0
set "EXFATDRIVESLIST="
echo Searching for the entry exFAT drives...
REM https://stackoverflow.com/questions/53541731/remove-unwanted-spaces-in-wmic-results-through-batch-file
for /f "skip=1 delims=" %%x in ('wmic logicaldisk where FileSystem^="exFAT" get caption') do (
rem /* Tokenise the output as needed in the inner loop;
rem    remember that `tokens` defaults to `1` and `delims` defaults to SPACE and TAB: */
for /F %%J in ("%%x") do (
call :exappend %%J
set /a EXFATDRIVESCOUNT+=1
))
goto :exdisplay

:exappend
REM to avoid SETLOCAL EnableDelayedExpansion
set EXFATDRIVESLIST=%EXFATDRIVESLIST% %1
goto :eof


:exdisplay
echo Found %EXFATDRIVESLIST%
REM https://stackoverflow.com/questions/7105433/windows-batch-echo-without-new-line
REM <NUL set /p=Total %EXFATDRIVESCOUNT%
echo Total %EXFATDRIVESCOUNT%

REM iteration over each drive root
for %%G in (%EXFATDRIVESLIST%) do (
call :iteratexdrive %%G\
)
goto :final

:iteratexdrive
echo Jumped into %1 drive...
cd /D %1
if EXIST %1\exl.ignore (
echo Skipping cuz exl.ingore!
goto :eof
)
if NOT EXIST %1\%ENTRYPOINT% (
echo Entrypoint not present, skipping!
goto :eof
)
for /D %%I in (%CD%%ENTRYPOINT%\*) do (
call %~dp0BIGOPSEC.cmd call %~dp0iteratexdirs.cmd "%%I" || echo %%I too long for entry...
rem call :iteratexdirs "%%I"
)
goto :eof

:iteratexdirs
rem echo iterating over %1

rem set demo=%1
rem set "demo=%demo:"=%"
rem <nul set /p "=%demo%"
rem echo: iterated over
REM https://stackoverflow.com/questions/4087695/escaping-ampersands-in-windows-batch-files
REM setlocal DisableDelayedExpansion
REM set "var=%~1"
REM setlocal EnableDelayedExpansion
REM echo !var!
REM initial
REM if EXIST %~1\exl.ignore (
REM echo Skipping cuz exl.ingore!
REM goto :eof
REM )

dir "%~1\exl.ignore" >nul 2>&1
if %ERRORLEVEL% NEQ 1 (
echo Skipping %1 cuz exl.ingore!
goto :eof
)
cd %1
call %~dp0BIGOPSEC.cmd call %~dp0filereact.cmd || echo %1 took a bit long...
REM for %%I in (.\*) do (
REM call :filereact "%CD%\%%~nxI"
REM )

rem call %~dp0BIGOPSEC.cmd call %~dp0iteratexdirs.cmd || echo %1 took a bit long...
REM for /D %%I in (.\*) do (
REM call :iteratexdirs "%CD%\%%~nxI"
REM )
goto :eof

:filereact
rem echo Reacting to %~1, ext as %~x1
if "%~x1"==".exe" echo found %CD%\%~nx1
goto :eof

:final
echo "Done"