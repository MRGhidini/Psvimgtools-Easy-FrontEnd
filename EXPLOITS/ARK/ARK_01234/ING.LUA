--Texts (translate)
if buttons.assign() then _button = "X" else _button = "O" end

strings = {

--Config Menu
"Scan Saves",			--1
"Scan VHBL",			--2
"Scan Games",			--3
"Scan Categories",		--4
"Slides",				--5
"Scan Hidden",			--6
"Show Hidden",			--7
"Delete Hidden",		--8
"Show PICs",			--9
"BarColor",				--10
"Boot",					--11
"Restart",				--12
"Delete",				--13
"Hide",					--14
"Square",				--15 boot 0
"Triangle",				--16 boot 1
"Circle",				--17 boot 2
"Cross",				--18 boot 3
"No",					--19 boot4
"Show",					--20
"Press ".._button,		--21

--Options
yes="Yes",
no="No",
up="Up",
down="Down",

--Delete ONEMenu.ini
delini="Delete ONEMENU.INI",

--Menu
nogames="NO GAMES",

--Scans
saves="Scanning SAVES",
catiso="Scanning ISO (Includes Categories)",
iso="Scanning ISO",
vhbl="Scanning PSP/VHBL",
gamecat="Scanning PSP/GAME (Includes Categories)",
game="Scanning PSP/GAME",

--Install Zip
progress="Install on Progress",
file="File: ",
rem="Remaining: ",
spd="Speed: ",
nospace="Insufficient Space",
start=_button.." to start the installation",
nopbp="No PBPs!",
already="This content is already installed. X: Overwrite - O: Rename ?",
startin=_button.." to start the installation in ",
-- ## Opciones del Menu Explorer ##
back=" Return ",
copyfile="Copying File : ",
label="Waiting...\nLoading Image...",
background="Background: Press Triangle",
dir="<DIR>",
copy = "Copy",
delete = "Delete ",
makedir = "MakeDir",
rename = "Rename",
extract = "Extract",
cancel = "Cancel",
extractto = "Extract To",
paste = "Paste",
move = "Move",
pass="Use Pass ?",
creatfolder="Create Folder",
newfolder="New Folder",
ospass="PASS",
}
