@echo off
REM callback for BIG OPeration time in SEConds
REM intended for external .cmd usage in form of:
REM call BIGOPSEC.cmd yourcrazycommand || echo reaction
SETLOCAL DisableDelayedExpansion
set TS=%time%
REM set TS=04:04:08.99
rem set TS=00:01:41.99
rem set TS=23:59:41.99




rem PING -n 3 127.0.0.1>nul
rem react to cli arg
%*




set TE=%time%
REM set TE=04:05:09.99
rem set TE=00:02:35.10
rem set TE=00:00:00

REM echo start=%TS%
REM echo end=%TE%

for /F "tokens=1-3 delims=:." %%i in ("%TS%") do (
REM set /a TSH=%%i*3600
call :hsanitizer %%i TSH
REM set /a TSH=%TSH%*3600

REM set /a TSM=%%j*60
call :msanitizer %%j TSM
REM set /a TSM=%TSM%*60

call :ssanitizer %%k TSS
)

REM Get start clocktime in seconds
set /a TSTOTALSEC=TSH+TSM+TSS
REM echo TSTOTALSEC=%TSTOTALSEC%

for /F "tokens=1-3 delims=:." %%i in ("%TE%") do (
REM set /a TEH=%%i*3600
call :hsanitizer %%i TEH
REM set /a TEH=%TEH%*3600

REM set /a TEM=%%j*60
call :msanitizer %%j TEM
REM set /a TEM=%TEM%*60

call :ssanitizer %%k TES
)

REM Get end clocktime in seconds
set /a TETOTALSEC=%TEH%+%TEM%+%TES%

REM react to midnight timepass
if %TETOTALSEC% LSS %TSTOTALSEC% set /a TETOTALSEC+=60*60*24


REM echo TETOTALSEC=%TETOTALSEC%

set /a diff=%TETOTALSEC%-%TSTOTALSEC%
REM echo timediff=%diff%

if %diff% GEQ 2 exit /b 1
goto :eof

:ssanitizer 
set SS=%1
if %SS:~0,1% EQU 0 set SS=%SS:~1,2%
if %2 EQU TSS set TSS=%SS%
if %2 EQU TES set TES=%SS%
goto :eof

:msanitizer 
set MM=%1
if %MM:~0,1% EQU 0 set MM=%MM:~1,2%
if %2 EQU TSM (
REM set TSM=%MM%
set /a TSM=%MM%*60
)
if %2 EQU TEM (
REM set TEM=%MM%
set /a TEM=%MM%*60
)
goto :eof

:hsanitizer 
set HH=%1
if %HH:~0,1% EQU 0 set HH=%HH:~1,2%
if %2 EQU TSH (
REM set TSH=%HH%
set /a TSH=%HH%*3600
)
if %2 EQU TEH (
REM set TEH=%HH%
set /a TEH=%HH%*3600
)
goto :eof