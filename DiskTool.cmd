@echo off
color a
title DiskTool - %time%
set VaultPath=\FOLDER TO ENCRYPT\ rem CHANGE THIS
set VaultName=Documents rem change this to set the name of the layer 2 encryption archive
set encryptionKey=133521 rem DO NOT CHANGE THIS

:login
cls
echo     ___  _     __  ______          __
echo    / _ \(_)__ / /_/_  __/__  ___  / /
echo   / // / (_- /  '_// / / _ \/ _ \/ / 
echo  /____/_/___/_/\_\/_/  \___/\___/_/  v1.2
echo.
echo Welcome to DiskTool, type "help" to view all commands.
echo.
:actionask
set/p "action=> "
set result=true
if %action%==encrypt call :InitForEncrypt
if %action%==decrypt call :InitForDecrypt
if %action%==newkey call :NewKey
if %action%==help call :Help
if %action%==clear goto :login
if %action%==cls goto :login
if %action%==exit exit

echo Command "%action%" not recognised, type "help" to view all commands.
goto :actionask

:GetPass
echo Enter your decryption key to decrypt this disk.
set /p "pass=> "
if NOT %pass%==YOURPASSWORD goto :Fail
exit /b

:InitForEncrypt
echo Use layer 1 encryption (1) or 2 layer encryption (2)?
set/p "layer=> "
if %layer%==1 goto :1layer
if %layer%==2 goto :1layer
echo Invalid choice.
goto :InitForEncrypt

:1layer
echo Encrypting disk, this may take a while.
set ForLoopFile=%VaultPath%
FOR /f "delims=" %%G IN ('dir /s /b /a-d %ForLoopFile%') DO if /i "%%~xG" neq ".aes" (call :Encrypt "%%G")
if %layer%==2 goto :2layer
goto :actionask

:2layer
7z a %VaultName%.7z -pjX2wp%85XBOgVO#hatNm -mhe \Documents\ >NUL
rmdir %VaultPath% /q /s
goto :actionask

:InitForDecrypt
call :GetPass
echo Decrypting disk, this may take a while.
if exist %VaultName%.7z 7z x %VaultName%.7z -pjX2wp%85XBOgVO#hatNm >NUL && del /q %VaultName%.7z >NUL
:1layerd
set ForLoopFile=%VaultPath%
FOR /f "delims=" %%G IN ('dir /s /b /a-d %ForLoopFile%') DO (call :Decrypt "%%G")
goto :actionask

:Encrypt
aes -e %encryptionKey% "%~1" "%~1.aes" >NUL
del /f "%~1"
exit /b

:Decrypt
aes -d %encryptionKey% "%~1" "%~dpn1" >NUL
del /f "%~1"
exit /b

:Fail
echo Incorrect password, please try again.
goto GetPass

:newkeyfail
echo Can't create new keys when files are encrypted.
goto :actionask

:NewKey
if exist %VaultName%.7z goto :newkeyfail
echo Enter Key Name:
set/p "KeyName=> "
echo Enter Key Content:
set/p "KeyContent=> "
echo %KeyContent% > "%VaultPath%Keys\%KeyName%.txt" >NUL
echo Created %KeyName%.txt
goto :actionask

:Help
echo encrypt - Encrypts files stored in %VaultPath%
echo decrypt - Decrypts all files when password is correct.
echo newkey - Create a new text key in %VaultPath%Keys\.
echo help - displays this command.
echo clear - clears the console.
goto :actionask
