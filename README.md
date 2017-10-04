# Psvimgtools-Easy-FrontEnd

This is a graphical interface for the PSVIMGTools Team Molecule / Yifanlu Which is a tool that can be used to decrypt and extract backup files PSVita (.psvimg) You just need to know the AID (QCMA Key) of the account that created the backup,

This works on all firmwares to date, including 3.65. And probably all future firmwares

# Requirements

Operational system:
Windows 7 (32bits / 64bits), Windows 8 (32bits / 64bits), Windows 8 (32bits / 64bits), Windows Server 2008 (32bits / 64bits) and UP

Taget Framework:
.NET Framework 4.5.2 - Minimum required

QCMA program installed:
https://codestation.github.io/qcma/

# Usage

Clicking on the magnifying glass, the program automatically searches for the last key used by QCMA! Or you can inform it manually!

# Extracting of pkg to NoNpDrm

Just download pkg, if you want suggestions there is a list in the file Download.txt, after download put your file.pkg in the PKG folder, if there is a zRIF add to the file ListKey.txt: ex: Title_ID;zRIF
* List the Title_ID of pkg that are in the PKG folder
* Extract pkg with zRIF, zRIF needs to be added in ListKey.txt together with Title_ID
* Extract pkg without zRIF
In the PKG folder, you have a list of suggestions for downloading from the Zeus list, with the zRIF already added to the ListKey.txt file.
You need the NoNpDrm plugin in your vita.

# Automatic Clone PSP games

Added ability to clone PSP games, doing all the work, automatic
* Copy the PSP game and sequence the renamed folder
* Change param.sfo with new numbering
* Extract the changed game.
* Change the VITA_PATH.txt with the new numbering.
* Recreate cloned games.

# Automatic themes

List of themes that are included in themas folder, but you can add more
* Theme Flatcons
* Theme GraceUX
* Theme HACKINFORMER
* Theme Mario
* Theme Nighttime
* To add more, just copy your custom internet theme to the THEME folder

# Automatic SQL commands

List of SQL commands included in the SQL folder, but you can add more
* Package-Installer
* RemoveFeatured-PSTV
* Whitelist-PSTV
* To add more, just create a .txt file with the SQL command and copy it to the SQL folder


Added ability to add custom themes

# Automatic mode exploits:

When pressing the Exploits Automatic button, the program searches all PSP games in the PGAME\ID folder in a listbox, after selecting the game, should select which exploit will use VHBL or ARK, confirming the program will extract and recreate the game with the informed exploit Automatically, and add the folder of the chosen exploit, within the SAVEDATA automatically

# Manual option for PSP/PS1

Extract PSP/PS1
The program will look for the PSP games in PGAME / ID and extract the game in a folder Psvita / EXTRAIR

Recreate PSP / PS1
The program will look PSP games extracted in Ps vita / EXTRAIR, and recreate in PGAME / ID

# Backup Options

Extract Backup
The program will look for your backups in Psvita / SYSTEM / ID and extract in PSvita EXTRAIRBackup

Recreat Backup
The program will look your backups in EXTRAIRBackup and recreate in PSvita Ps vita / SYSTEM / ID

# Manual option for APP / Games - PSVITA

Extract APP / Games 
The program will look for the APP / Games in APP / ID and extract the game in a folder Psvita / EXTRAIRAppGame

Recreat APP / Games
The program will look for the APP / Games in EXTRAIRAppGame and recreate in PSvita Ps vita / APP / ID

# Option for App´s

In this option, it searches all APP in the root of the APPGAMES folder list program in a listbox, and after selecting loads within Ps vita / APP

