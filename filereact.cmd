for %%I in (.\*) do (
call :filereact "%CD%\%%~nxI"
)

:filereact
rem echo Reacting to %~1, ext as %~x1
if "%~x1"==".exe" echo found %CD%\%~nx1
goto :eof