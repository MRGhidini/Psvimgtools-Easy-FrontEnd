if buttons.assign() then selection,cancel = "cross","circle"
else selection,cancel = "circle","cross" end

buttons.read()
os.cpu(333)
color.loadpalette()
cfw=os.cfw()
if string.find(cfw,"ME/LME",1,true) then me=1 else me=0 end

--Guardar Configuracion en el menu
pathini=files.cdir():sub(1,5).."ONEMENU.INI"
function write_table(pathini, tb)
    local file = io.open(pathini, "w+")
	file:write("config = {\n")
	for s,t in pairs(tb) do
		if type(t) == "string" then
			file:write(string.format('"%s",\n', tostring(t)))
		else
			file:write(string.format('%s,\n', tostring(t)))
		end
	end
	file:write("}")
	file:close()
end

--1 saves, 2 vhbl, 3 games, 4 cats, 5 slides, 6 scan hiddens, 7 show hiddens, 8 DeletListHiddens, 9 Show PICs
--10 Barcolor
--11 square, 12 triangle, 13 circle, 14 cross, 15 ListHiddens 16 CustomColor 17 Background

config = {true,true,false,false,true,false,false,false,false,8,"","","","","",0xffffff,"BACK.PNG"}--Supertable

if buttons.held.r then
	if files.delete(pathini) then delini=1 end
end

if files.exists(pathini) then
	dofile(pathini)
	local _write=0
	if #config < 15 then
		table.insert(config,3,false)
		_write=1
	end
	if #config < 16 then
		table.insert(config,16,0xffffff)
		_write=1
	end
	if #config < 17 then
		table.insert(config,17,"BACK.PNG")
		_write=1
	end
	if _write then write_table(pathini, config) end
else 
	write_table(pathini, config)
end

--Boot
if buttons.held.square and #config[11] > 1 then game.launch(config[11])
elseif buttons.held.triangle and #config[12] > 1 then game.launch(config[12])
elseif buttons.held.circle and #config[13] > 1 then game.launch(config[13])
elseif buttons.held.cross and #config[14] > 1 then game.launch(config[14])
elseif buttons.held.l then debug_mode= true --Debug
end

background = image.load(config[17])
if not background then background = image.load("BACK.PNG") end
default_icon = image.load("ICODEF.PNG")
--------------------Scanning-----------------------------------------------------------------
-- Languague
if files.exists("LANG.LUA") then dofile("LANG.LUA") else dofile("ING.LUA") end
dofile("SCAN.LUA") --Functions SCAN

--Prints OneMenu Initials
function init_msg(_msg)
	table.insert(debug_table,_msg)
	background:blit(0,0)
	y=5
	if #debug_table<=26 then I=1 else I=#debug_table-25 end
	for i=I, #debug_table do
		screen.print(10,y,debug_table[i],0.5)
		y+=10
	end
	screen.print(475,5,cfw,0.5,color.white,color.gray,__ARIGHT)
	screen.flip()
	os.delay(5)
end

--[[
	games[1] for ISO/CSO and PSN (UG & EG)
	games[2] for HBs (MG)
	games[3] for PS1 (ME)
	games[4] for .Zips
	games[5] for Hiddens Hbs
]]

games = { {},{},{},{},{} }--SuperTable
debug_table={}

if delini==1 then init_msg(strings.delini) end

if config[1] then						--Scanning for Zips/Iso/Cso/PBP in SAVEDATA
	init_msg(strings.saves)
	scanning_saves()
	scanning_pbps("ms0:/PSP/SAVEDATA/")
end

if config[2] then						--Scanning for HBs in PSP/VHBL
	init_msg(strings.vhbl)
	scanning_pbps("ms0:/PSP/VHBL/")
end

--Scanning for iso/cso in ms0:/ISO
if cfw!="VHBL" then
	if config[4] then init_msg(strings.catiso) else init_msg(strings.iso) end
	scanning_isos("ms0:/ISO")
	if hw.getmodel() =="Go" then scanning_isos("ef0:/ISO") end
end

--Scanning for HBs in PSP/GAME
if config[3] then
	if config[4] then init_msg(strings.gamecat) else init_msg(strings.game) end
	scanning_pbps("ms0:/PSP/GAME/")
	if hw.getmodel() =="Go" then scanning_pbps("ef0:/PSP/GAME/") end
end

for i=1,#games do
	if #games[i]>0 then
		table.sort(games[i],function(a,b) return a.title:lower()<b.title:lower() end)
	end
	games[i].ini=1
	games[i].sel=1
	if #games[i] > 5 then games[i].lim=5 else games[i].lim=#games[i] end
end

if #games[1]>0 then cat=1 else cat=2 end

default_icon,msg=nil,nil
collectgarbage("collect")

Seccion,trans = 1,0
dofile("SHELL.LUA")

if config[9] then 
    if (games[cat][1] != nil) then
		pic1=game.getpic1(games[cat][1].path) 
    end
end-- 1er PIC1

function color.getChRaw(data)-- Funciones para la manipulacion de RawColor
	return ((data)&0xff), (((data)>>8)&0xff), (((data)>>16)&0xff) ,(((data)>>24)&0xff)
end

function color.rawTo(val)
	local r,g,b,a = color.getChRaw(val)
	return color.new(r,g,b,a)
end

BarColor = color.rawTo(config[16])--Barcolor

while true do
	buttons.read()

	if pic1 then pic1:center() pic1:blit(240,136,trans) -- Background or PIC1
	elseif background then background:blit(0,0)	end

	if config[5] then posy=50 else posy=195 end--Slides

	if Seccion == 1 then--Games Menu
		main_draw()
		main_controls()
	elseif Seccion == 2 then--Config Menu
		menu_draw()
		menu_controls()
	end
	if buttons.select and Seccion == 1 then--Explorer
		explorer.main()
	end

	screen.flip()
	if trans < 255 then trans+=5 end
end
