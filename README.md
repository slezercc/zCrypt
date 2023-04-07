# DiskTool
This tool allows you to encrypt all the files in a configured folder using AES encryption. It supports 1 and 2 layer encryption for additional security. I personally use this on my USB drive to keep all my files encrypted and decrypt the specific folder with this tool when I need to use some files & run the done command to delete the decrypted files.

![image](https://user-images.githubusercontent.com/37955902/226117989-a8f9ca50-4f14-4cc6-bdf2-d06b912f47a0.png)


# Installation
1, In DiskTool.bat, edit YOURPASSWORD on line 63 and 64 to your preferred password to use when decrypting your files.  
```batch
if NOT %pass%==YOURPASSWORD echo Decryption key incorrect, please try again. && goto :GetPass
if %pass%==YOURPASSWORD set PassCheck=Valid && goto :login
```

2, Obfuscate DiskTool.bat using [batch-obfuscator.tk](https://batch-obfuscator.tk/) and make sure your new obfuscated bat file works.  
![image](https://user-images.githubusercontent.com/37955902/230526254-4bd102a4-f1e7-4a65-b51c-dac0fa57f78b.png)  

3, Convert DiskTool.exe to an exe file using Bat to Exe Converter. You can download it from [MajorGeeks](https://www.majorgeeks.com/files/details/bat_to_exe_converter.html), make sure you use these exact settings (I only had to change delete on exit to yes):  
![image](https://user-images.githubusercontent.com/37955902/230525268-35e0db4b-ee72-460d-a086-348743b0a132.png)  
  
4, In the embed tab, drag and drop aes.exe, 7z.exe and 7z.dll.

5, (Optional) You can add this icon in the options:  
![image](https://slezer.cc/assets/img/disktool/icon.ico)

6, Convert DiskTool to an exe file using the convert button and you're good to go!

# Usage
encrypt - Encrypts files stored in %VaultPath%  
decrypt - Decrypts all files stored in %VaultPath%  
newkey - Create a new text file in %VaultPath%Keys\ for secure password or private key storing.  
help - Displays this text.  
done - Deletes your decrypted files.  
clear, cls - Clears the console.  