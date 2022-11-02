# DiskTool
Bathfile encryption tool using the AES algorithm. (Designed for USB Sticks but works on any hard drive.)

# Installation and Setup
Installation is very simple, just edit the DiskTool.cmd file and change the %VaultPath% variable to the path of the folder which contents will be encrypted (encrypts all subfolders too), when you're done, change the %pass% variable in the DiskTool.cmd file on line 30:

```batch
if NOT %pass%== YOURPASSWORD goto :Fail rem change YOURPASSWORD to your preferred password.
```

# Usage
DiskTool has 4 commands: encrypt, decrypt, help and newkey.  
"encrypt" will encrypt the selected folder on your drive.  
"decrypt" will decrypt the selected folde ron your drive if the passwrd is enetered correctly.  
"newkey" will create a text file in %folder%/Keys/ with your specified content so that it can be encrypted and stored safely. (Made to store information such as mnemonic keys safely.). 
"help" will display all commands ands their usage.  
"exit" will... exit.  
