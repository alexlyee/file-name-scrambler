set V=1.0
@echo off
cls
echo.
echo Initializing Batch Scripts Managment system. . . (Vertion %V%)
set BSMS_workspace_Dir="%CD%\workspace"
set BSMS_workspace_Main="%CD%
set ProgramV=1.0
title Program Vertion %ProgramV%
REM =================================== Batch Scripts Managment system
SET TranslationFile=__Translation.txt
cls
echo.
echo The scramble will look something like this: !RANDOM!-!RANDOM!-!RANDOM! unless you prepend
echo.
echo (0) - Rename the file randomly.
echo (1) - Prepend the existing file name with randomly generated string.
echo.
set /p PrependOnly=TYPE DOWN THAT OPTION ONLY: 
echo.
echo (0) - Rename the file randomly.
echo (1) - Undo changes according to the translation file.
echo ......................... This will only work if the file "__Translation.txt" is in the same folder.
echo ......................... If you delete the translaction file, you will not be able to undo the changes!
echo ......................... Make sure it is named "__Translation.txt" and in the same dir as the batch file!
echo.
set /p Undo=TYPE DOWN THAT OPTION ONLY: 
echo.
echo Enter the COMPLETE DIR BRANCH
echo Example: "C:\Users\Alex\Desktop" Would scramble every file in Alex's desktop.
echo Only type down: C:\Users\Alex\Desktop
echo No ""
echo.
set /p DIRECTORY=Enter the dir: 
echo.
IF NOT {%Undo%}=={1} (
	cls
	ECHO You are about to randomly rename every file in the following folder:
	ECHO %DIRECTORY%
	ECHO.
	ECHO A file named %TranslationFile% will be created which allows you to undo this.
	ECHO Warning: If %TranslationFile% is lost/deleted, this action cannot be undone.
	ECHO Type "OK" to continue.
	echo.
	SET /P Confirm= 
	cls
	echo.
	echo Begin Processing. . .
	echo.
	IF /I NOT {!Confirm!}=={OK} (
		ECHO.
		ECHO Aborting.
		GOTO :EOF
	)
	ECHO Original Name/Random Name Recovery File > %TranslationFile%
	ECHO The folder these come from is "%DIRECTORY%" >> %TranslationFile%
	ECHO ------------------------- >> %TranslationFile%
	FOR /F "tokens=*" %%A IN ('DIR "%DIRECTORY%" /A:-D /B') DO (
		IF NOT %%A==%~nx0 (
			IF NOT %%A==%TranslationFile% (
				SET Use=%%~xA
				IF {%PrependOnly%}=={1} SET Use=_%%A
				SET NewName=!RANDOM!-!RANDOM!-!RANDOM!!Use!
				ECHO Change "%%A" To "!NewName!". . .
				echo.
				ECHO %%A/!NewName!>> %TranslationFile%
				RENAME "%DIRECTORY%\%%A" "!NewName!"
			)
		)
	)
	echo.
	echo Done ;)
	echo.
	pause
	exit
) ELSE (
	ECHO Undo mode.
	IF NOT EXIST %TranslationFile% (
		ECHO Missing translation file: %TranslationFile%
		PAUSE
		GOTO :EOF
	)
	FOR /F "skip=2 tokens=1,2 delims=/" %%A IN (%TranslationFile%) DO (
	RENAME "%DIRECTORY%\%%B" "%%A"
	echo "%DIRECTORY%\%%B" Back To "%%A". . .
	echo.
	)
	echo Delete TranslationFile. . .
	DEL /F /Q %TranslationFile%
	echo.
	echo Done ;)
	echo.
	pause
	exit
)