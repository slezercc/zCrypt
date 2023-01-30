# DiskTool
This tool allows you to encrypt all the files in a configured folder using AES. It supports 1 and 2 layer encryption for additional security. I personally use this on my USB drive to keep all my files encrypted and decrypt the specific folder with this tool when I need to use some files & run the done command to delete the decrypted files.

# Installation
Edit \Documents\ on line 3 in DiskTool.bat with the path of the folder to encrypt.  
```batch
set VaultPath=\Documents\
```

Change Documents on line 4 with the name of the 7z archive that will be created when using 2 layer encryption.  
```batch
set VaultName=Documents
```

Change YOURPASSWORD on line 40 to your preferred password to use when decrypting your files.  
```batch
if NOT %pass%==YOURPASSWORD goto :Fail
```

# Usage
encrypt - Encrypts files stored in %VaultPath%  
decrypt - Decrypts all files stored in %VaultPath%  
newkey - Create a new text file in %VaultPath%Keys\ for secure password or private key storing.  
help - Displays this text.  
done - Deletes your decrypted files.  
clear, cls - Clears the console.  

# Suggestions
I heavily suggest you use 2 layer encryption for storing sensitive files, if you need to decrypt a specific folder without decrypting all of your documents, use the decrypt command as usual, enter your password and it will ask if you want to decrypt a specific folder, enter the path of the folder, example: if the folder is a folder named Keys inside your vault, simply enter Keys, if it is a folder, inside the Keys directory, enter it as follows: Keys\Crypto  

# Functioning
1 layer encryption encrypts every file in the filevault directory using AES; 2 layer encryption does the same but then adds every file to a .7z archive, compresses it, and encrypts it using a different encryption key for a second layer of protection and to hide the filenames.  
Decryption is all automatic. DiskTool detects if you used 1 or 2 layer encryption automatically, asks for your defined password, and if you used 2 layer encryption, asks if you want to decrypt a specific folder.
