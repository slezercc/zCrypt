@echo off
title DiskTool v1.4
set VaultPath=Documents\
set VaultName=Documents
set aesKey=7g3f8j2w9
set Authenticated=false
set new=true
if exist %VaultPath% set new=false
if exist %VaultName%.7z set new=false
if %new%==true mkdir %VaultName%

:login
cls
echo     ___  _     __  ______          __
echo    / _ \(_)__ / /_/_  __/__  ___  / /
echo   / // / (_- /   _// / / _ \/ _ \/ / 
echo  /____/_/___/_/\_\/_/  \___/\___/_/  v1.4
echo.
echo Welcome to DiskTool, type "help" to view all commands.
if %Authenticated%==true echo. && goto :sectorAsk
if %new%==true echo %VaultPath% folder created, files stored inside this folder can now be encrypted.
echo.
:actionask
set/p "action=> "
if %action%==encrypt call :InitForEncrypt
if %action%==decrypt call :InitForDecrypt
if %action%==newkey call :NewKey
if %action%==help call :Help
if %action%==clear goto :login
if %action%==cls goto :login
if %action%==done goto :done
if %action%==exit exit
echo Command "%action%" not recognised, type "help" to view all commands.
goto :actionask

:done
echo This will delete \%VaultPath%, are you sure? (y/n)
set/p "delete=> "
if %delete%==y rmdir %VaultPath% /q /s && goto :actionask
if %delete%==n goto :actionask
goto :done

:InitForEncrypt
if exist %VaultName%.7z echo Files are already encrypted. && goto :actionask
echo Use layer 1 encryption (1) or 2 layer encryption (2)?
set/p "layer=> "
if %layer%==1 goto :1layer
if %layer%==2 goto :1layer
echo Invalid choice.
goto :InitForEncrypt

:InitForConvert


:1layer
echo Encrypting \%VaultPath%, this may take a while.
FOR /f "delims=" %%G IN ('dir /s /b /a-d %VaultPath%') DO if /i "%%~xG" neq ".aes" (call :Encrypt "%%G")
if %layer%==2 goto :2layer
goto :actionask

:2layer
echo Adding \%VaultPath% to %VaultName%.7z, this may take a while.
7z a %VaultName%.7z -pSsvdFxQ3N7Z7 -mhe %VaultPath% >NUL
rmdir %VaultPath% /q /s
goto :actionask

:InitForDecrypt
if exist %VaultName% set name=\%VaultName%\
if exist %VaultName%.7z set name=%VaultName%.7z
if %Authenticated%==true goto :sectorAsk
if %Authenticated%==false echo Enter your decryption password to decrypt %name%.
:GetPass
set /p "pass=> "
if NOT %pass%==YOURPASSWORD echo Decryption password incorrect, please try again. && goto :GetPass
if %pass%==YOURPASSWORD set Authenticated=true && goto :login

:sectorAsk
echo Decrypt specific folder? (y/n)
set/p "sector=> "
if %sector%==y goto :spec
if %sector%==n goto :nospec
echo Invalid choice.
goto :sectorAsk

:spec
echo Enter the name of the folder you want to decrypt.
set/p "specFolder=> "
set specPath=%VaultName%\%specFolder%
if NOT exist %VaultName%.7z echo Decrypting %specPath%, this may take a while. && goto :1layerdspec
echo Extracting %specPath%, this may take a while.
7z e %VaultName%.7z -spf -pSsvdFxQ3N7Z7 %specPath% -r >NUL
echo Decrypting %specPath%, this may take a while.
goto :1layerdspec

:nospec
echo Extracting %Vaultname%.7z, this may take a while.
if exist %VaultName%.7z 7z x %VaultName%.7z -pSsvdFxQ3N7Z7 >NUL && del /q %VaultName%.7z >NUL
echo Decrypting %VaultPath%, this may take a while.

:1layerd
FOR /f "delims=" %%G IN ('dir /s /b /a-d %VaultPath%') DO (call :Decrypt "%%G")
goto :actionask

:1layerdspec
FOR /f "delims=" %%G IN ('dir /s /b /a-d %specPath%') DO (call :Decrypt "%%G")
goto :actionask

:Encrypt
aes -e %aesKey% "%~1" "%~1.aes" >NUL
del /f "%~1"
exit /b

:Decrypt
aes -d %aesKey% "%~1" "%~dpn1" >NUL
del /f "%~1"
exit /b

:newkeyfail
echo Can't create new keys when files are encrypted.
goto :actionask

:NewKey
if exist %VaultName%.7z goto :newkeyfail
if exist %VaultPath%*.aes goto :newkeyfail
echo Enter Key Name:
set/p "KeyName=> "
echo Enter Key Content:
set/p "KeyContent=> "
echo %KeyContent% > "%VaultPath%Keys\%KeyName%.txt" >NUL
echo Created %KeyName%.txt
goto :actionask

:Help
echo encrypt - encrypts files stored in %VaultPath%.
echo decrypt - decrypts all files stored in %VaultPath%.
echo newkey - create a new text key in %VaultPath%Keys\.
echo help - displays this text.
echo clear, cls - clears the console.
echo done - delete decrypted files.
echo exit - closes the DiskTool console.
goto :actionask