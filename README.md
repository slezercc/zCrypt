# zTool
This tool allows you to encrypt all the files in a configured folder using AES encryption. It supports 1 and 2 layer encryption for additional security. I personally use this on my USB drive to keep all my files encrypted and decrypt the specific folder with this tool when I need to use some files & run the done command to delete the decrypted files.

![image](https://user-images.githubusercontent.com/37955902/235500936-70319d50-f886-4818-a3bb-be20a6c97dce.png)

# Setup
1, In zTool.bat, edit line 3, 4 and 6  
```batch
set VaultName=Documents
set password=YOURPASSWORD
set aesKey=7g3f8j2w9
```
VaultName is the name of the folder where your files will be stored/encrypted.
password is the password you will use when decrypting your files.
aesKey is the encryption string that will be used to encrypt your files (Note: this needs to be an alphanumeric string containing no special characters.)

2, Convert zTool.exe to an exe file using Bat to Exe Converter. You can download it from [MajorGeeks](https://www.majorgeeks.com/files/details/bat_to_exe_converter.html), make sure you use these exact settings (I only had to change delete on exit to yes):  
![image](https://user-images.githubusercontent.com/37955902/230525268-35e0db4b-ee72-460d-a086-348743b0a132.png)  
  
3, In the embed tab, drag and drop aes.exe, 7z.exe and 7z.dll.  

4, (Optional) Add this icon in the options:  
![image](https://raw.githubusercontent.com/slezercc/zTool/main/icon.ico)

5, Convert zTool to an exe file using the convert button and you're good to go!

# Usage
encrypt - Encrypts files stored in %VaultPath%  
decrypt - Decrypts all files stored in %VaultPath%  
newkey - Create a new text file in %VaultPath%Keys\ for secure password or private key storing.  
help - Displays this text.  
done - Deletes your decrypted files.  
clear, cls - Clears the console.  
