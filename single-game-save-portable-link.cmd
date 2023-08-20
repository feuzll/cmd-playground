:: INTERNAL
@Echo Off
SetLocal EnableExtensions


:: UTIL VARIABLES
:: define this script path
Set _cmdFolderPath=%~dp0
Set _cmdFolderPathName=%_cmdFolderPath:~0,-1%

:: define colorful step indicators
For /F %%a in ('"prompt $E$S & echo on & for %%b in (1) do rem"') do set "_ESC=%%a"
Rem 31 - red, 32 - green, 33 - yellow, 36 - cyan
Set _indicatorStep=%_ESC%[36m[STEP]%_ESC%[0m
Set _indicatorSuccess=%_ESC%[32m[SUCCESS]%_ESC%[0m
Set _indicatorError=%_ESC%[31m[ERROR]%_ESC%[0m
Set _indicatorInfo=%_ESC%[33m[INFO]%_ESC%[0m


:: JOB VARIABLES
Rem EDIT ME HERE
Set _gameSaveLocationPathName=%APPDATA%\some\publisher\folder
Set _gameSaveName=saveEndPointName
Set _yourSavePathName=D:\your\portable\device\save\full\path
Set _gameSavePathName=%_gameSaveLocationPathName%\%_gameSaveName%



:: SKIP SUBROUTINES
Goto :execution

:: UTIL SUBROUTINES
:echoStep
Echo %_indicatorStep% %~1
Exit /B

:echoError
Echo %_indicatorError% %~1
Exit /B

:echoInfo
Echo %_indicatorInfo% %~1
Exit /B

:echoSuccess
Echo %_indicatorSuccess% %~1
Exit /B

:: JOB SUBROUTINES
:backupPresentSave
Rem Count already made backups...
Set _backupCount=0
For /d %%a in (%_gameSaveName%.backup*) do set /a _backupCount+=1
Rem Rename existing save...
Set /a _newBackupNumber=_backupCount+1
Ren %_gameSaveName% %_gameSaveName%.backup-%_newBackupNumber%
Call :echoInfo "Made a new backup at place. Total: %_newBackupNumber%"
Exit /B



:: JOB
:execution

Call :echoStep "Ensuring of the game save location..."
Md %_gameSaveLocationPathName% 2>nul && (
	Call :echoSuccess "Created %_gameSaveLocationPathName%!"
) || (
	Call :echoSuccess "%_gameSaveLocationPathName% already present!"
)
echo:

Call :echoStep "Jump to the game save location..."
Cd /D %_gameSaveLocationPathName% && (
	Call :echoSuccess "Ready for the next step!"
) || (
	Call :echoError "Something went wrong, check the path access."
)
Echo:

Call :echoStep "Rename already present save, if necessary..."
If Exist %_gameSaveName% (
	Call :backupPresentSave	
	Call :echoSuccess "Proceed to the next step!"
) Else (
	Call :echoSuccess "Not necessary, ready for the next step!"
)
Echo:

Call :echoStep "Making a link..."
If Exist %_yourSavePathName%\ (
	Mklink /D /j %_gameSavePathName% %_yourSavePathName% >nul
	Call :echoSuccess "Linked %_yourSavePathName% as %_gameSavePathName%!"
) Else (
	Call :echoError "Can't find your game save file, check the path to it!"
)
Echo:
