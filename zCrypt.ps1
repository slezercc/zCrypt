$VaultName = "Documents"
$password = "YOURPASSWORD"
$VaultPath = "$VaultName\"
$aesKey = "7g3f8j2w9"
$Authenticated = $false
$new = $true

if (Test-Path $VaultPath) { $new = $false }
if (Test-Path "$VaultName.7z") { $new = $false }

function Login {
    cls
    Write-Host "        ______                 __"
    Write-Host "  ____  / ____/______  ______  / /_"
    Write-Host " /_  / / /   / ___/ / / / __ \/ __/"
    Write-Host "  / /_/ /___/ /  / /_/ / /_/ / /_"
    Write-Host " /___/\____/_/   \__, / .___/\__/"
    Write-Host "              /____/_/           v1.5"
    Write-Host ""
    Write-Host "Welcome to zCrypt, type 'help' to view all commands."
    if ($Authenticated) {
        Write-Host ""
        goto SectorAsk
    }
    if ($new) {
        Write-Host "\"$VaultPath\" folder created, files stored inside this folder can now be encrypted."
        Write-Host ""
    }
}

function ActionAsk {
    $action = Read-Host "action> "
    switch ($action) {
        "encrypt" { InitForEncrypt }
        "decrypt" { InitForDecrypt }
        "newkey" { NewKey }
        "help" { Help }
        "clear" { Login }
        "cls" { Login }
        "done" { Done }
        "exit" { Exit }
        default { Write-Host "Command ""$action"" not recognized, type 'help' to view all commands." }
    }
    goto ActionAsk
}

function Done {
    Write-Host "This will delete \"$VaultPath\", are you sure? (y/n)"
    $delete = Read-Host "delete> "
    if ($delete -eq "y") {
        Remove-Item -Path $VaultPath -Recurse -Force
    }
    goto ActionAsk
}

function InitForEncrypt {
    if (Test-Path "$VaultName.7z") {
        Write-Host "Files are already encrypted."
        goto ActionAsk
    }
    $layer = Read-Host "Use 1 layer encryption or 2 layer encryption (1/2)?"
    if ($layer -eq "1" -or $layer -eq "2") {
        goto 1layer
    } else {
        Write-Host "Invalid choice."
        goto InitForEncrypt
    }
}

function 1layer {
    Write-Host "Encrypting \"$VaultPath\", this may take a while."
    Get-ChildItem -Path $VaultPath -Recurse -File | ForEach-Object {
        if ($_.Extension -ne ".aes") {
            Encrypt $_.FullName
        }
    }
    if ($layer -eq "2") {
        goto 2layer
    } else {
        goto ActionAsk
    }
}

function 2layer {
    Write-Host "Adding \"$VaultPath\" to \"$VaultName.7z\", this may take a while."
    & 7z a "$VaultName.7z" -pSsvdFxQ3N7Z7 -mhe "$VaultPath" > $null
    Remove-Item -Path $VaultPath -Recurse -Force
    goto ActionAsk
}

function InitForDecrypt {
    $name = ""
    if (Test-Path $VaultName) { $name = "\$VaultName\" }
    if (Test-Path "$VaultName.7z") { $name = "$VaultName.7z" }
    if (-not $Authenticated) {
        Write-Host "Enter your decryption password to decrypt $name."
        do {
            $pass = Read-Host "pass> "
        } while ($pass -ne $password)
        $Authenticated = $true
        goto Login
    }
    SectorAsk
}

function SectorAsk {
    $sector = Read-Host "Decrypt specific folder? (y/n)"
    if ($sector -eq "y") {
        goto spec
    } elseif ($sector -eq "n") {
        goto nospec
    } else {
        Write-Host "Invalid choice."
        goto SectorAsk
    }
}

function spec {
    $specFolder = Read-Host "Enter the name of the folder you want to decrypt."
    $specPath = "$VaultName\$specFolder"
    if (-not (Test-Path "$VaultName.7z")) {
        Write-Host "Decrypting $specPath, this may take a while."
        goto 1layerdspec
    } else {
        Write-Host "Extracting $specPath, this may take a while."
        & 7z e "$VaultName.7z" -spf -pSsvdFxQ3N7Z7 "$specPath" -r > $null
        Write-Host "Decrypting $specPath, this may take a while."
        goto 1layerdspec
    }
}

function nospec {
    Write-Host "Extracting \"$Vaultname.7z\", this may take a while."
    if (Test-Path "$VaultName.7z") {
        & 7z x "$VaultName.7z" -pSsvdFxQ3N7Z7 > $null
        Remove-Item -Path "$VaultName.7z" -Force
    }
    Write-Host "Decrypting \"$VaultPath\", this may take a while."
    goto 1layerd
}

function 1layerd {
    Get-ChildItem -Path $VaultPath -Recurse -File | ForEach-Object {
        Decrypt $_.FullName
    }
    goto ActionAsk
}

function 1layerdspec {
    Get-ChildItem -Path $specPath -Recurse -File | ForEach-Object {
        Decrypt $_.FullName
    }
    goto ActionAsk
}

function Encrypt {
    aes -e $aesKey $args[0] "$args[0].aes" > $null
    Remove-Item -Path $args[0] -Force
}

function Decrypt {
    aes -d $aesKey $args[0] "$args[0].dec" > $null
    Remove-Item -Path $args[0] -Force
}

function NewKey {
    if (Test-Path "$VaultName.7z" -or (Test-Path "$VaultPath*.aes")) {
        Write-Host "Can't create new keys when files are encrypted."
        goto ActionAsk
    }
    $KeyName = Read-Host "Enter Key Name:"
    $KeyContent = Read-Host "Enter Key Content:"
    if (-not (Test-Path "$VaultPath\Keys")) {
        New-Item -ItemType Directory -Path "$VaultPath\Keys" | Out-Null
    }
    $KeyContent | Out-File "$VaultPath\Keys\$KeyName.txt"
    Write-Host "Created $KeyName.txt"
    goto ActionAsk
}

function Help {
    Write-Host "encrypt - encrypts files stored in $VaultPath."
    Write-Host "decrypt - decrypts all files stored in $VaultPath."
    Write-Host "newkey - create a new text file in $VaultPath\Keys."
    Write-Host "help - displays this text."
    Write-Host "clear, cls - clears the console."
    Write-Host "done - delete decrypted files."
    Write-Host "exit - closes zCrypt."
    goto ActionAsk
}

# Start of the script
Login
ActionAsk
