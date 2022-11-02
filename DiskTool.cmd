@echo off
color a
mode con: cols=62 lines=10
title DiskTool - %time%
set VaultPath=\FOLDER TO ENCRYPT\ rem CHANGE THIS!
set encryptionKey=133521 rem DO NOT CHANGE THIS!

:Menu
cls
echo Welcome to DiskTool, type "help" to view all commands.
echo.
set/p "action=root@vault:~# "
set result=true
if %action%==encrypt call :InitForEncrypt
if %action%==decrypt call :InitForDecrypt
if %action%==newkey call :NewKey
if %action%==help call :Help
if %action%==exit exit

echo Command "%action%" not recognised, type "help" to view all commands.
echo.
pause
goto Menu

:GetPass
cls
echo Enter your decryption key to decrypt this disk.
echo.
set /p "pass=root@vault:~# "
if NOT %pass%== YOURPASSWORD goto :Fail rem CHANGE THIS!
exit /b

:InitForEncrypt
cls
echo Encrypting Disk with AES-256 algorithm, this may take a while.
set ForLoopFile=%VaultPath%
FOR /f %%G IN ('dir /s /b /a-d %ForLoopFile%') DO (call :Encrypt %%G)
goto :Menu

:InitForDecrypt
call :GetPass
cls
echo Decrypting Disk with AES-256 algorithm, this may take a while.
set ForLoopFile=%VaultPath%
FOR /f %%G IN ('dir /s /b /a-d %ForLoopFile%') DO (call :Decrypt %%G)
goto :Menu

:Encrypt
set targetFile=%1
set outputFile=%targetFile:txt=txt.aes%
aes -e %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:exe=exe.aes%
aes -e %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:zip=zip.aes%
aes -e %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:rar=rar.aes%
aes -e %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:png=png.aes%
aes -e %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:jpg=jpg.aes%
aes -e %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:ico=ico.aes%
aes -e %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:gif=gif.aes%
aes -e %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:mp4=mp4.aes%
aes -e %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:m4v=m4v.aes%
aes -e %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:.py=.py.aes%
aes -e %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:asc=asc.aes%
aes -e %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:vbs=vbs.aes%
aes -e %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:bat=bat.aes%
aes -e %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:ovpn=ovpn.aes%
aes -e %encryptionKey% %targetFile% %outputFile% >NUL
del /f %targetFile%
exit /b

:Decrypt
set targetFile=%1
set outputFile=%targetFile:txt.aes=txt%
aes -d %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:exe.aes=exe%
aes -d %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:zip.aes=zip%
aes -d %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:rar.aes=rar%
aes -d %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:png.aes=png%
aes -d %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:jpg.aes=jpg%
aes -d %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:ico.aes=ico%
aes -d %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:gif.aes=gif%
aes -d %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:mp4.aes=mp4%
aes -d %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:m4v.aes=m4v%
aes -d %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:.py.aes=.py%
aes -d %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:asc.aes=asc%
aes -d %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:vbs.aes=vbs%
aes -d %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:bat.aes=bat%
aes -d %encryptionKey% %targetFile% %outputFile% >NUL
set outputFile=%targetFile:ovpn.aes=ovpn%
aes -d %encryptionKey% %targetFile% %outputFile% >NUL
del /f %targetFile%
exit /b

:Fail
echo Incorrect password, please try again.
pause
goto GetPass

:NewKey
cls
echo Enter Key Name:
set /p KeyName=
cls
echo Enter Key Content:
set /p KeyContent=
echo %KeyContent% > "%VaultPath%Keys\%KeyName%.txt"
ping 127.0.0.1 -n 2 > nul
goto :Menu

:Help
echo encrypt - Encrypts all files stored on this USB device.
echo decrypt - Decrypts all files when password is correct.
echo newkey - Create a new text key in %VaultPath%Keys\.
echo help - displays this command.
echo.
pause
goto :Menu
