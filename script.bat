@echo off
SETLOCAL EnableDelayedExpansion

SET _line=
SET _tmpstring=
SET _filepath=%~dp0
SET _prefix=en_US_


REM For loop for all files in directory
REM

FOR /R %%G IN (*.txt) DO ( SET _tmpstring=%%G & CALL :loop1 )
GOTO:eof


REM Check if file with `en_US` prefix exist.
REM If not, create it.
REM

:loop1
SET _tmpstring=!_tmpstring:%_filepath%=!

echo !_tmpstring! | FINDSTR /R /C:"en_US_" > nul
IF !ERRORLEVEL! EQU 0 (
	REM echo JEST
	GOTO:eof
) ELSE (
	REM New file find
	REM

	SET _prefix=en_US_!_tmpstring!
	echo.>!_prefix!
	CALL :loop2
	REM del %_tmpstring%
)
GOTO:eof


REM Loop line by line for new file
REM

:loop2
FOR /F "delims=" %%I IN ( !_tmpstring! ) DO (
SET _line=%%I & CALL :loop3 )
GOTO:eof


REM Change `,` to `.` and `pl_PL` to 'en_US`
REM

:loop3
echo %_line% | FINDSTR /R /C:"[,]" > nul

IF !ERRORLEVEL! EQU 0 (
	SET "_line2=%_line:,=.%"
	echo !_line2!>>%_prefix%
) ELSE (
	IF "!_line:~0,5!"=="pl_PL" (
		echo en_US>>%_prefix%
	) ELSE (
		echo !_line!>>%_prefix%
	)
)
GOTO:eof

