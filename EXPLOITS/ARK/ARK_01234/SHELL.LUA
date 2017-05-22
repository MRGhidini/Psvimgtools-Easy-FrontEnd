--Resources exclusives in PBP lite
--Resources exclusives in PBP lite
button = image.getbuttons()--Sprites buttons from vram in PBP
mimes = image.geticons()--Sprites icons from vram in PBP

--button = image.loadv("buttons.png",20,20)--Sprites buttons from vram in PBP
--mimes = image.loadv("icons.png",16,16)--Sprites icons from vram in PBP
------------------------------------------------------------------------------------------------------------
pic = image.load("PIC.PNG")
jump=sound.load("JUMP.S3M")
slide=sound.load("SLIDE.S3M")
option,nivel=1,10
menu_slide = { x=480, y=24, v=10, open=false }
menu_slide.boot=0

col={
    color.new(0,0,0,55),		--1 BlackTrans
	color.new(139,0,0,135),		--2 RedTrans
	color.new(0,255,0,95),		--3 GreenTrans
	color.new(255,255,0,95),	--4 YellowTrans
	color.new(64,224,208,135),	--5 TurquoiseTrans
	color.new(105,105,105,135),	--6 GrayTrans
	color.black,				--7 Black
	color.new(55,72,251,105),	--8 BlueTrans
}

--------------------------------------main_draw()---------------------------------------------------------------
graphics = {}
function main_draw()
	if #games[cat] == 0 then return screen.print(5,5, strings.nogames,0.8) end	-- No games?
	x,y,y2=40,125,195
if #games[cat]>0 then
	for i=games[cat].ini,games[cat].lim do -- imprimimos la lista con ini&lim
		if i==games[cat].sel then -- si i == sel entonces set el index focus
			--- Se dibuja en graphics.focus_icon()
			focus_index,x = i,x+105
		else
			if games[cat].sel>1 then
				if i==games[cat].ini then
					graphics.icons(i,-35,100)
				else
					graphics.icons(i,x,100)
					x+=105
				end
			else
				graphics.icons(i,x,100)
				x+=105
			end
		end
	end

	graphics.focus_icon()-- Dibuja el icono enfocado sobre los demas y mayor
	graphics.label_efect()
end
end

-- Dibuja los iconos con efecto espejo
function graphics.icons(i,z,z1)
	if (games[cat][i].icono:getw() > 80) then
		games[cat][i].icono:blit(z,y,175)
		newx=z+z1-20
	else
		games[cat][i].icono:blit(z+20,y,175)--z + (144-80)/2
		newx=z+z1-32
	end
	if boots[games[cat][i].path] then -- aqui hacer al vuelo con una tabla de boot :D
		if boots[games[cat][i].path] < 4 then
			button:blitsprite(newx,y,boots[games[cat][i].path],175)
		end
	end
	games[cat][i].icono:flipv()
	if (games[cat][i].icono:getw() > 80) then
		games[cat][i].icono:blit(z,y2,54)
	else
		games[cat][i].icono:blit(z+20,y2,54)--z + (144-80)/2
	end
	games[cat][i].icono:flipv()
end

-- Dibuja el icono enfocado sobre los demas y mayor
function graphics.focus_icon()
	draw.fillrect(0,0,480,24, BarColor) --UP
	screen.print(5,5,games[cat][focus_index].title,0.6)

	if (games[cat][focus_index].icono:getw() > 80) then 
		games[cat][focus_index].icono:resize(144,80)
		newx=165
	else
		games[cat][focus_index].icono:resize(80,80)
		newx=103
	end
	games[cat][focus_index].icono:blit(45,100 - (graphics.elev / 2))

    if boots[games[cat][focus_index].path] then
        if boots[games[cat][focus_index].path] < 4 then
            button:blitsprite(newx,100 - (graphics.elev / 2),boots[games[cat][focus_index].path],175)
        end
    end

    games[cat][focus_index].icono:flipv()
    games[cat][focus_index].icono:blit(45,205 + (graphics.elev / 2),60)
    games[cat][focus_index].icono:flipv()

    graphics.elev+=2
    if graphics.elev > 20 then graphics.elev = 20 end

	if (games[cat][focus_index].icono:getw() > 80) then 
		games[cat][focus_index].icono:resize(100,68)
	else
		games[cat][focus_index].icono:resize(68,68)
	end

    draw.fillrect(0,252,480,20, BarColor)--Down
    if not scrollx_name then scrollx_name = 12 end
    scrollx_name = screen.print(scrollx_name,255,games[cat][focus_index].name,0.6,color.white,0x0,__SLEFT,300)
    screen.print(475,255,os.date("%H:%M"),0.5,color.white,color.gray,__ARIGHT)--os.date("%I:%M %p")
end

graphics.label = {} -- Tabla para las etiquetas de categoria
graphics.label[1] = { x=0 , acel=7 , img=image.load("GAME.PNG") }
graphics.label[2] = { x=0 , acel=7 , img=image.load("HB.PNG") }
graphics.label[3] = { x=0 , acel=7 , img=image.load("PS1.PNG") }
graphics.label[4] = { x=0 , acel=7 , img=image.load("ZIP.PNG") }
graphics.label[5] = { x=0 , acel=7 , img=image.load("HID.PNG") }
graphics.elev = 0
graphics.efc = {}-- aqui se almacenaran variables numericas de efecto

--encargada de hacer el efecto de cambio de categoria
function graphics.label_efect()
	graphics.efc.posy = posy--50up/195down
	for i=1,#graphics.label do
		if i == cat then
			graphics.label[i].acel = 1
			graphics.label[i].x-=8 
			if graphics.label[i].x < -179 then graphics.label[i].x = -179 end
			graphics.label[i].img:blit(480 + graphics.label[i].x,graphics.efc.posy)
		else
			graphics.label[i].x+=graphics.label[i].acel
			graphics.label[i].acel+=2.5
			if graphics.label[i].x >= 0 then
				graphics.label[i].x = 0	-- Si es mayor o igual a zero (yo) no dibujamos nada
			else
				graphics.label[i].img:blit(480 + graphics.label[i].x,graphics.efc.posy)
			end
		end
	end
end
--------------------------------------main_draw()---------------------------------------------------------------

--------------------------------------main_controls()-----------------------------------------------------------
function main_controls()

	if buttons.right or buttons.held.r then
		if games[cat].sel<games[cat].lim then
			games[cat].sel+=1
			if buttons.right then
				if slide then
					if slide:playing() then slide:stop() slide:play()
					else slide:stop() slide:play() end
				end
				pic1=nil
				if config[9] then buttons.interval() pic1=game.getpic1(games[cat][games[cat].sel].path)
				else buttons.interval(10,10) end
				trans = 0 -- Fade in 0
			end
			if games[cat].sel-1==1 then 
				if games[cat].lim+1<=#games[cat] then games[cat].lim+=1 end
				else games[cat].ini+=1
				if games[cat].lim+1<=#games[cat] then games[cat].lim+=1 end
			end
			graphics.elev=0
		end
	end

	if buttons.left or buttons.held.l then
		if games[cat].sel>games[cat].ini then
			games[cat].sel-=1
			if buttons.left then
				if slide then
					if slide:playing() then slide:stop() slide:play()
					else slide:stop() slide:play() end
				end
				pic1=nil
				if config[9] then buttons.interval() pic1=game.getpic1(games[cat][games[cat].sel].path)
				else buttons.interval(10,10) end
				trans = 0 -- Fade in 0
			end
			if games[cat].sel==1 then 
				if games[cat].lim-games[cat].ini>=5 then games[cat].lim-=1 end
				else games[cat].ini-=1
					if games[cat].lim-games[cat].ini>=6 then games[cat].lim-=1 end
			end
			graphics.elev=0
		end
	end

	if buttons.released.l or buttons.released.r then
		pic1=nil
		if config[9] then pic1=game.getpic1(games[cat][games[cat].sel].path) end
		trans = 0 -- Fade in 0
	end

	if (buttons.up or buttons.down) and #games[cat] != 0 then
		if config[7] then desp=#games else desp=#games-1 end--Show Hiddens?
		local temp=cat
		if not config[9] then buttons.interval(30,20) end

		if buttons.up then
			cat-=1
			if cat < 1 then cat = desp end
			while #games[cat] < 1 do
				cat-=1
				if cat < 1 then cat = desp end
			end
		end
		
		if buttons.down then
			cat+=1
			if cat > desp then cat = 1 end
			while #games[cat] < 1 do
				cat+=1
				if cat > desp then cat = 1 end
			end
		end

		if temp != cat then
			if jump then
				if jump:playing() then jump:stop() jump:play()
				else jump:stop() jump:play() end
			end
			pic1=nil
			if config[9] then pic1=game.getpic1(games[cat][games[cat].sel].path) end
			trans = 0 -- Fade in 0
			graphics.elev=0
		end
	end

	if buttons[selection] and #games[cat] != 0 then				-- Launch Game
		local capt = screen.buffertoimage()
		launch()
		capt:blit(0,0)
	end
	
	if buttons.triangle then--and #games[cat] != 0 then				-- Launch Menu
		buttons.interval(10,10)
		if slide then
			if slide:playing() then slide:stop() end
		end
		if jump then
			if jump:playing() then jump:stop() jump:play()
			else jump:stop() jump:play() end
		end

		menu_slide.open = true
		option,Seccion = 1,2
		menu_slide.boot = 4
		if games[cat][games[cat].sel] != nil then
			if boots[games[cat][games[cat].sel].path] then 
				menu_slide.boot = boots[games[cat][games[cat].sel].path]
			end
		end
	end

end

function splash(pics,delay,vel)

	pics:center()

	for i = 0, 255, vel do
		pics:blit(240,136,i)
		screen.flip()
	end

	os.delay(delay)

	for i = 255, 0, -vel do
		pics:blit(240,136,i)
		screen.flip()
	end

end

 -- Callback Pmf
function onPmfPlay(state)
    buttons.read()
    if buttons[cancel] then pmf.stop() end

    if buttons[selection] and explorer.list then
        if state then
            pmf.pause()
        else
            pmf.play()
        end
    end
end

function rungameboot(pathtogame)
	pic1=nil

	if jump and slide then
		if slide:playing() then slide:stop() end
		if jump:playing() then jump:stop() end
	end

	local list_files = files.listfiles(files.cdir())--"ms0:/gameboot" change for your path to the pmfs :P 
	if list_files then
		local list_pmf={}
		for i=1,#list_files do
			if list_files[i].ext=="pmf" then
				table.insert(list_pmf,list_files[i])
			end
		end
		if #list_pmf>0 then
			math.randomseed(os.time())
			pmf.run(list_pmf[math.random(1,#list_pmf)].path)
		else
			local snd=sound.load("SND.S3M")
			if snd then snd:play() end

			if pic then splash(pic,10,3) end

			if snd then
				if snd:playing() then snd:stop() end
			end
		end
	else
		local snd=sound.load("SND.S3M")
		if snd then snd:play() end

		if pic then splash(pic,10,3) end

		if snd then
			if snd:playing() then snd:stop() end
		end
	end

	game.launch(pathtogame)
end

--scanning ms0:/PSP/GAME or ms0:/PSP/VHBL
--tmp0.CATEGORY: ISO/CSO UG, PSN EG, HBs MG, PS1 ME
function launch() -- Launch Game or Install.zip
	if not files.exists(games[cat][games[cat].sel].path) then return end
	if cat != 4 then
		if cfw=="VHBL" and games[cat][games[cat].sel].cat =="MG" then
			rungameboot(games[cat][games[cat].sel].path)
		end
		if cfw!="VHBL" then rungameboot(games[cat][games[cat].sel].path) end
	else -- ZIP
		if jump and slide then
			if slide:playing() then slide:stop() end
			if jump:playing() then jump:stop() end
		end

		overwrite=nil
		files_zip = files.scan(games[cat][games[cat].sel].path)
		size_total,pbp_exist = 0,nil
		if files_zip then
			for i=1,#files_zip do
				size_total = size_total+files_zip[i].size

				if files.nopath(files_zip[i].name) == "FBOOT.PBP" or 
					files.nopath(files_zip[i].name) == "VBOOT.PBP" or
					files.nopath(files_zip[i].name) == "WMENU.BIN" or
					files.nopath(files_zip[i].name) == "EBOOT.PBP"
					then pbp_exist = i end
				y=y+15
			end
		end

		ms0=os.infoms0()
		if size_total >= ms0.free then -- no hay suficiente espacio, se aborta
			screen.print(475,5, strings.space ,0.5,color.white,color.gray,__ARIGHT)
			screen.flip()
			if buttons.waitforkey() then return end -- no podemos continuar, no hay espacio
		end

		if ms0.free > 1073741824 then
			screen.print(420,255,string.format("%0.2f",(ms0.free/1024/1024)/1024).." GB",0.5,color.white,color.gray,__ARIGHT)
		else screen.print(420,255,string.format("%0.2f",ms0.free/1024/1024).." MB",0.5,color.white,color.gray,__ARIGHT) end

		if string.find(games[cat][games[cat].sel].path,"P_",1,true) then--P_PLUGIN
			screen.print(475,5,strings.start,0.5,color.white,color.gray,__ARIGHT)
			screen.flip()
			if buttons.waitforkey() != 15 then --  no es X, abortaron
				return --abortaron
			end
			files.extract_w_bar(games[cat][games[cat].sel].path,"ms0:/")
		else
			if not pbp_exist then
				screen.print(475,5,strings.nopbp,0.5,color.white,color.gray,__ARIGHT)
				screen.flip()
				buttons.waitforkey()
				return
			end	-- No PBPs??

			_path="ms0:/"
			if not files.exists("ms0:/PSP/VHBL/") then files.mkdir("ms0:/PSP/VHBL/") end

			if files.exists(_path..files.nofile(files_zip[pbp_exist].name)) then -- ya existe el contenido?
				screen.print(475,5,strings.already,0.5,color.white,color.gray,__ARIGHT)
				screen.flip()
				local resp = buttons.waitforkey()
				if resp == 15 then overwrite = true	elseif resp == 14 then overwrite = false
				else -- No es X/O
					return -- abortaron
				end
			else --primera vez del contenido
				screen.print(470,5,strings.startin.._path,0.5,color.white,color.gray,__ARIGHT)
				screen.flip()
				if buttons.waitforkey() != 15 then --  no es X, abortaron
					return --abortaron
				end
			end

			--Install
			path=nil
			path = files.nofile(files_zip[pbp_exist].name)
			if files.exists(_path..path) and not overwrite then
				local root = path:sub(1,#path-1)
				files.rename(_path..root,root.."_orig")
				files.extract_w_bar(games[cat][games[cat].sel].path,_path)
				local i = 1
				while files.exists(_path..root.."_"..i.."/") do i = i + 1 end
				files.rename(_path..root,root.."_"..i)
				path = root.."_"..i.."/"
				files.rename(_path..root.."_orig",root)
			else -- No existe y se instala
				files.extract_w_bar(games[cat][games[cat].sel].path,_path)
			end

			os.delay(200)
			pbp=nil
			if files.exists(_path..path.."EBOOT.PBP") then pbp="EBOOT.PBP"
			elseif files.exists(_path..path.."FBOOT.PBP") then pbp="FBOOT.PBP"
			elseif files.exists(_path..path.."VBOOT.PBP") then pbp="VBOOT.PBP"
			elseif files.exists(_path..path.."WMENU.BIN") then pbp="WMENU.BIN"
			end

			if pbp then
				local tmp0 = game.info(_path..path..pbp)
				if tmp0 then
					local ind = index[tmp0.CATEGORY] or 2
					if not overwrite then -- es un nuevo contenido :)
						local name=string.gsub(files.nopath(path),"/","") -- obtenemos el nombre de ruta
						fill_scan(ind,tmp0,_path..path..pbp,name) -- llenamos tabla con datos
						games[ind].ini=1--refresh
						games[ind].sel=1
						if #games[ind] > 5 then games[ind].lim=5 else games[ind].lim=#games[ind] end
						name=nil
					else -- estamos reecribiendo
						local _index = search_repeat(ind, _path..path..pbp)
						if _index then
							local name=string.gsub(files.nopath(path),"/","") -- obtenemos el nombre de ruta
							fill_scan(ind, tmp0, _path..path..pbp, name, _index)
							name=nil
						end
					end
				end
			end
		end
	end
	collectgarbage("collect")
	os.delay(5)
end

function search_repeat(show, dir) -- puesto en funcion para romperse con un return
	local up,i = #games[show], 1
	while i <= up do
		if games[show][i].path == dir then return i end
		i+=1
	end
end
--------------------------------------main_controls()-----------------------------------------------------------

-- Bool to Text
function parseTxt(values,this)
	if this!=5 then
		if values then return strings.yes else return strings.no end
	else
		if values then return strings.up else return strings.down end
	end
end

----------------------------------------menu_draw()---------------------------------------------------------------
function menu_draw()
	if #games[cat]>0 then
		graphics.focus_icon()
	end
	if menu_slide.open and menu_slide.x > 240 then
		menu_slide.x-=menu_slide.v
	end
	if not menu_slide.open and menu_slide.x < 480 then
		menu_slide.x+=menu_slide.v
	end
	if menu_slide.x > 478 then Seccion = 1 end-- Back to Menu

	draw.fillrect(menu_slide.x,menu_slide.y,240,228,BarColor)

	if menu_slide.x == 240 then
		if cat==4 then nivel=13 else nivel=14 end
		y=40
		for i=1,nivel do
			if i==option then draw.fillrect(240,y,240,13,color.new(220,220,220,65))	end

			if i == 14 and cat==5 then
				screen.print(250,y,strings[20],0.6)
			else
				screen.print(250,y,strings[i],0.6)
			end
			if i < 10 then
				screen.print(440,y,parseTxt(config[i],i),0.6,color.white,0x0,512)
			elseif i == 10 then screen.print(440,y,config[i],0.6,color.white,0x0,512) -- color
			elseif i == 11 then--Boot
				screen.print(440,y,strings[15+menu_slide.boot],0.6,color.white,0x0,512)
			elseif i > 11 then
				screen.print(440,y,strings[21],0.6,color.white,0x0,512)
			end
			y+=13
		end
	end
end

--Controles Menu
channel =1
function menu_controls()
	if menu_slide.x == 240 then --Slide Open???
		if buttons.held.r and option == 10 then -- Mezclador
		else
			buttons.interval(10,10)
			if buttons.up then
				option-=1
				if option < 1 then
					option=nivel
				end
			end
			if buttons.down then
				option+=1
				if option > nivel then
					option = 1
				end
			end
			if (buttons.left or buttons.right) and option < 10 then
				config[option]=not config[option]
				changed=true
			end
		end
		-- Color theme (BarColor)
		if buttons.held.r and option == 10 then -- Mezclador
			if buttons.right then								--Change channel+1
				buttons.interval()
				channel+=1;
			elseif buttons.left then							--Change channel-1
				buttons.interval()
				channel-=1;
			end
			if channel<1 then channel=1 end
			if channel>4 then channel=4 end

			if buttons.up then
				buttons.interval(10,1)
				BarColor = color.changeRGBA(channel,1)
				config[16] = color.toRaw(BarColor)
				changed=true
			elseif buttons.down then
				buttons.interval(10,1)
				BarColor = color.changeRGBA(channel,-1)
				config[16] = color.toRaw(BarColor)
				changed=true
			end
			local chs={c1="R:",c2="G:",c3="B:",c4="A:"}
			chs[1],chs[2],chs[3],chs[4] = BarColor:getChs()

			local _x=300
			for i=1,4 do
				if i==channel then
					screen.print(_x,235,chs["c"..i]..chs[i],0.6,color.red,color.black,__ARIGHT)
				else
					screen.print(_x,235,chs["c"..i]..chs[i],0.6,color.white,color.black,__ARIGHT)
				end
				_x+=40
			end
		elseif option == 10 then								-- Colors for Default
			buttons.interval(10,10)
			if buttons.right then
				config[10]+=1
				if config[10]>#col then config[10]=1 end
				BarColor = col[config[10]]--Barcolor
				config[16] = color.toRaw(BarColor)
				changed=true
			end
			if buttons.left then
				config[10]-=1
				if config[10]<1 then config[10]=#col end
				BarColor = col[config[10]]--Barcolor
				config[16] = color.toRaw(BarColor)
				changed=true
			end
		end

		if #games[cat]>0 then
			if cat != 4 and cat != 5 and option == 11 then			--Boot
				buttons.interval(10,10)
				if buttons.right then
					menu_slide.boot+=1
					if menu_slide.boot > 4 then menu_slide.boot=0 end
					boots[games[cat][games[cat].sel].path] = menu_slide.boot
					changed=true
				end
				if buttons.left then
					menu_slide.boot-=1
					if menu_slide.boot < 0 then menu_slide.boot = 4 end
					boots[games[cat][games[cat].sel].path] = menu_slide.boot
					changed=true
				end
			end
		end

		if buttons[selection] and option == 12 then					--Restart
			if changed then save_config() end
				os.restart()
		end

		if buttons[selection] and option> 12 and #games[cat]>0 then
			if option == 13 then									--Delete
				local state = os.message(strings.delete.." ?",1)
				if state == 1 then
					del()
				end
			elseif option == 14 then								--Hidden/Show
				local puntero = 5
				if cat==5 then
					puntero = index[games[cat][games[cat].sel].cat]
				end
				hidden(puntero)
			end

			if changed then save_config() end
			if config[9] then buttons.interval()
				if #games[cat]>0 then pic1=game.getpic1(games[cat][games[cat].sel].path) end
			else buttons.interval(10,10) end

			trans, menu_slide.open = 0,false
			if jump then
				if jump:playing() then jump:stop() jump:play()
				else jump:stop() jump:play() end
			end
		end
	end

	if buttons.triangle then
		if changed then save_config() end
		if config[9] then buttons.interval()
			if #games[cat]>0 then pic1=game.getpic1(games[cat][games[cat].sel].path) end
		else buttons.interval(10,10) end
		menu_slide.open = false
		if jump then
			if jump:playing() then jump:stop() jump:play()
			else jump:stop() jump:play() end
		end
	end
end

function save_config()
	if #games[cat]>0 then
		if menu_slide.boot < 4 then
			for i=11,14 do 
				if config[i] == games[cat][games[cat].sel].path then config[i] = "" end
				if boots[config[i]] == menu_slide.boot then boots[config[i]],config[i] = 4,"" end
			end
			config[11 + menu_slide.boot]=games[cat][games[cat].sel].path
			boots[games[cat][games[cat].sel].path] = menu_slide.boot
		else 
			for i=11,14 do
				if config[i] == games[cat][games[cat].sel].path then config[i] = ""	end
			end
		end
	end
	if config[8] then
		config[8]= not config[8]
		config[15] = ""
	end
	write_table(pathini, config)
	changed=false
end

--Delete 
function del()
	if files.ext(games[cat][games[cat].sel].path):upper()=="PBP" then
		files.delete(games[cat][games[cat].sel].path)
		if not files.exists(games[cat][games[cat].sel].path) then
			files.delete(files.nofile(games[cat][games[cat].sel].path))
		end
	else
		files.delete(games[cat][games[cat].sel].path)
	end
	if not files.exists(games[cat][games[cat].sel].path) then
		games[cat][games[cat].sel].icono=nil
		table.remove(games[cat],games[cat].sel)
		refresh()
	end
	collectgarbage("collect")
	os.delay(5)
end

--Hidden/Show
function hidden(point)
	table.insert(games[point],{})
	games[point][#games[point]]=games[cat][games[cat].sel]--Copy
	games[point].ini=1
	games[point].sel=1
	if #games[point] > 5 then games[point].lim=5 else games[point].lim=#games[point] end

	if point == 5 then 
		config[15]=config[15]..","..games[cat][games[cat].sel].name
	else
		config[15]=string.gsub(config[15], ","..games[cat][games[cat].sel].name, "")		
	end
	
	write_table(pathini, config)

	--Delete Table original
	table.remove(games[cat],games[cat].sel)

	--Refresh table
	refresh()
end

--Refrescamos la lista
function refresh()
	if games[cat].sel==games[cat].lim then
		if games[cat].ini != 1 then games[cat].ini-=1 end
		games[cat].sel-=1
		games[cat].lim=games[cat].sel
		main_draw()
	elseif games[cat].lim>#games[cat] then games[cat].lim-=1 end

--[[
	games[1] for ISO/CSO and PSN (UG & EG)
	games[2] for HBs (MG)
	games[3] for PS1 (ME)
	games[4] for .Zips
	games[5] for Hiddens Hbs
]]
	_exit=1
	while #games[cat] < 1 and _exit<=5 do
		cat,_exit = cat + 1, _exit+1
		if cat > #games then cat = 1 end
	end
	if cat == 5 and not config[7] then config[7]=true end
	os.delay(250)
end

--[[
	=======================
	Funciones de extraccion
	=======================
]]

--Callback Extract
function files.extract_w_bar(file,path,pass)
	local result=1000
	total_size,total_write,antbytes = 0,0,0
	fileant = ""
	local lect = files.scan(file) --Escanea los files contenidos
	if lect then
		local i = 1
		while i <= #lect do
			total_size+=lect[i].size
			i+=1
		end
		if pass then result = files.threadextract(file,path,pass)
		else result = files.threadextract(file,path) end
		while __FILES_THREAD_STATE == 2 do
			onExtractFiles(__FILES_THREAD_SIZE,__FILES_THREAD_WRITTEN,__FILES_THREAD_FILE)
		end
	end
	return result
end

-- CallBack Extraction
function onExtractFiles(size,written,file)

	if background then background:blit(0,0) end
	draw.fillrect(0,0,480,24, BarColor)

	porcentaje=math.floor(written*(100)/size)
	screen.print(15,5,strings.progress,0.6,color.white,0x0)
	screen.print(15,25,strings.file..files.nopath(file),0.6,color.white,0x0)
	screen.print(460,25,porcentaje.." %",0.6,color.white,0x0,__ARIGHT)

	porcentaje_total=math.floor(total_write*(100)/total_size)
	screen.print(460,5,porcentaje_total.." % ",0.6,color.white,0x0,512)--240,110

	if file == fileant then
		total_write+=written - antbytes
	else
		total_write+=written
	end

	screen.flip()
	antbytes = written
	fileant = file
end

 -- CallBack CopyFiles
function onCopyFiles(size,written,file)
    if background then background:blit(0,0) end
    draw.fillrect(0,0,480,24, BarColor)
    porcentaje=math.floor(written*(100)/size)
    screen.print(15,5,strings.copyfile,0.6,color.white,0x0)
	screen.print(15,25,file,0.6,color.white,0x0)
    screen.print(460,5,porcentaje.." % ",0.6,color.white,0x0,512)--240,110
    screen.flip()
end

-- ## Library Scroll ## --
scroll = {}

function scroll.set(num,tab,mxn)
	scroll[num] = {ini=1,sel=1,lim=1,maxim=1}
	if #tab > mxn then scroll[num].lim=mxn else scroll[num].lim=#tab end
	scroll[num].maxim = #tab
end

function scroll.max(num,mx)
scroll[num].maxim = #mx
end

function scroll.up(num)
	if scroll[num].sel>scroll[num].ini then scroll[num].sel-=1
	elseif scroll[num].ini-1>=1 then
		scroll[num].ini,scroll[num].sel,scroll[num].lim=scroll[num].ini-1,scroll[num].sel-1,scroll[num].lim-1
	end
end

function scroll.down(num)
	if scroll[num].sel<scroll[num].lim then scroll[num].sel+=1
	elseif scroll[num].lim+1<=scroll[num].maxim then
		scroll[num].ini,scroll[num].sel,scroll[num].lim=scroll[num].ini+1,scroll[num].sel+1,scroll[num].lim+1
	end
end

-- ## Muestra Un texto mientras algo se carga 'LABEL' ## --
function label(txt) -- mensaje de loading resource
	local scrback = screen.buffertoimage()
	draw.fillrect(180,100,120,72,color.new(128,128,128,150))
	draw.rect(180,100,120,72,color.black)
	screen.print(240,120,txt,0.6,color.white,color.black,512)
	screen.flip()
	scrback:blit(0,0)
end

-- ## Visor De imagenes ## --
function visorimg(path) -- Version simplificada del visor del shell
	collectgarbage("collect")
	os.delay(5)
	local scrback = screen.buffertoimage()
	label(strings.label)
	local tmp = image.load(path)
	if tmp then
		local infoimg = {}
		infoimg.name = files.nopath(path)
		infoimg.w,infoimg.h = image.getrealw(tmp),image.getrealh(tmp)
		local show_bar_upper = true
		tmp:center()

		bar=20
		if infoimg.w==480 and infoimg.h==272 then bar=30 end
		for i=0,bar,1 do
			tmp:blit(240,136)
			draw.fillrect(0,0,480,i,color.new(255,255,255,100))
			screen.flip() 
		end

		while true do
			buttons.read()
			tmp:blit(240,136)
			if show_bar_upper then
				draw.fillrect(0,0,480,bar,color.new(255,255,255,100))
				screen.print(10,3,infoimg.name,0.7,color.white,color.black)
				screen.print(420,3,"w:"..infoimg.w,0.7,color.white,color.black,__ARIGHT)
				screen.print(470,3,"h:"..infoimg.h,0.7,color.white,color.black,__ARIGHT)
				if infoimg.w==480 and infoimg.h==272 then
					screen.print(10,15,strings.background,0.6,color.white,color.black)
				end
			end
			screen.flip()

			if buttons.square then show_bar_upper = not show_bar_upper end

			if buttons.triangle and infoimg.w==480 and infoimg.h==272 then
				config[17] = path
				background = image.load(config[17])
				if not background then background = image.load("BACK.PNG") end
				save_config()
			end

			if buttons[cancel] or buttons[selection] then
				break
			end
		end

		if show_bar_upper then
			for i=20,0,-1 do
				tmp:blit(240,136)
					draw.fillrect(0,0,480,i,color.new(255,255,255,100))
				screen.flip() 
			end
		end

		tmp = nil
		collectgarbage("collect")
		os.delay(5)
	end
	scrback:blit(0,0)
end

-- ## File Size Format 'B,KB,MB,GB' ##
function files.sizeformat(bytes) -- Add files module function, esta retorna el size en unidad 
	local u,c = {"B","KB","MB","GB"},1
	while bytes>1024 do
		bytes/=1024
		c+=1
	end
	return string.format("%.2f "..u[c],bytes)
end

function files.listsort(path)
	local tmp1 = files.listdirs(path)
	if tmp1 then 
		table.sort(tmp1,function(a,b) return string.lower(a.name)<string.lower(b.name) end)
	else
		tmp1 = {}
	end
	local tmp2 = files.listfiles(path) 
	if tmp2 then
		table.sort(tmp2,function(a,b) return string.lower(a.name)<string.lower(b.name) end)
		for s,t in pairs(tmp2) do
			t.size = files.sizeformat(t.size)
			table.insert(tmp1,t)-- esto es por que son subtablas, realmente no puedo hacer un cont con tmp2
		end
	end
	return tmp1
end

-- ## Explorador ## --
explorer = {} -- All explorer functions
	-- index for scroll
	-- 1: List
	-- 2: Menu

-- ## Explorer Refresh ## --
function explorer.refresh()
explorer.list = files.listsort(Root[Dev])
scroll.set(1,explorer.list,15)
end

icons={1,pbp=2,prx=2,
png=3,gif=3,jpg=3,bmp=3,
mp3=4,s3m=4,wav=4,at3=4,
rar=5,zip=5,
cso=6,iso=6,dax=6
}
-- ## Explorer Drawer List ## --
function explorer.listshow()
	local h=25
	for i=scroll[1].ini,scroll[1].lim do -- Aunmento en un 75% de rendimiento al ser while
		if i==scroll[1].sel then draw.fillrect(0,h,480,15,color.new(128,128,128,100)) end
		if explorer.list[i].size then
			if icons[explorer.list[i].ext] then mimes:blitsprite(5,h, icons[explorer.list[i].ext])
			else mimes:blitsprite(5,h, 0) end
		else
			mimes:blitsprite(5,h, 1)
		end
		screen.print(25, h, explorer.list[i].name or "",0.6, isopened[explorer.list[i].ext] or color.white, color.black)
		screen.print(470, h, explorer.list[i].size or strings.dir, 0.6, color.white, color.black, __ARIGHT)
		h+=15
	end
end

-- ## Explorer Drawer Menu ## --
function explorer.menushow()
	local h = slide_y + 5
	local i = scroll[2].ini
	while i <= scroll[2].lim do
		if i==scroll[2].sel then cc=color.new(255,130,0) else cc=color.white end
		screen.print(slide_x+45,h,slide_opts_txt[i],0.6,cc,color.black,512)
		h,i=h+15, i+1
	end	
end


isopened = { png = color.green, jpg = color.green, gif = color.green, bmp = color.green,
pmf=color.blue, iso = color.orange, pbp = color.orange, cso = color.orange, dax = color.orange, zip = color.orange, rar = color.orange }

function refresh_opt()
	slide_open[2]=false
end

function copysrc()
	explorer.src = explorer.list[scroll[1].sel].path
	explorer.action = scroll[2].sel
	refresh_opt()
	scroll.set(2,slide_opts_txt,7)
end

function _refresh()
	explorer.refresh()
	refresh_opt()
	slide_opts_txt = {strings.copy,strings.move,strings.extract,strings.delete,strings.makedir,strings.rename,strings.cancel}
	scroll.set(2,slide_opts_txt,7)
	explorer.action = 0
	explorer.src, explorer.dst = "",""
end

function explorer.main()
	local scrback = screen.buffertoimage()
	Root = {"ms0:/","ef0:/"}
	if string.find(files.cdir(),"ef0") then Dev=2 else Dev=1 end--Only PSPGo

	back={}
	slide_open = {false,false}
	slide_x,slide_y,slide_h = 340,130,0
	slide_opts_txt = {strings.copy,strings.move,strings.extract,strings.delete,strings.makedir,strings.rename,strings.cancel}
	scroll.set(2,slide_opts_txt,7)
	explorer.refresh()
	explorer.src,explorer.dst = "",""
	explorer.action = 0
	divsect = 1
	buttons.interval(10,10)
	while true do
		buttons.read()
		if background then background:blit(0,0)	end
		if divsect == 1 then -- List
			show_explorer_list() -- regla siempre el draw
			ctrls_explorer_list()
			if buttons.triangle then
				BackExpl = screen.buffertoimage()
				divsect, slide_open = 2, {true,true}
			end
		elseif divsect == 2 then -- Menu
			if BackExpl then BackExpl:blit(0,0) end
			show_explorer_menu() -- correccion igual para el draw list
			if slide_h > 100 then ctrls_explorer_menu() end -- evita uso de controles si se esta abriendo o cerrando
			if buttons.triangle or buttons[cancel] then refresh_opt() end
		end
		screen.flip()
		if buttons.select and not slide_open[2] then -- Salimos del explorer
			explorer.list=nil
			break
		end
	end
	scrback:blit(0,0)
end
	
function ctrls_explorer_list()

	if buttons[cancel] then -- return directory
		Root[Dev]=files.nofile(Root[Dev])
		explorer.refresh()
		if #back>0 then
			if scroll[1].maxim == back[#back].maxim then
				scroll[1]=back[#back]
			end
			back[#back] = nil
		end
	end

	if scroll[1].maxim > 0 then												-- Is exists any?
		if buttons.up or buttons.held.l then scroll.up(1) end
		if buttons.down or buttons.held.r then scroll.down(1) end

		if buttons[selection] then
			local extension = explorer.list[scroll[1].sel].ext
			if extension == "png" or extension == "jpg" or extension == "gif" or extension == "bmp" then
				visorimg(explorer.list[scroll[1].sel].path)
			elseif extension == "pmf" then
				pmf.run(explorer.list[scroll[1].sel].path)
			elseif extension == "cso" or extension == "iso" or extension == "pbp" or extension == "bin" or extension == "dax" then
				if (extension == "cso" or extension == "iso") and cfw!="VHBL" then
					rungameboot(explorer.list[scroll[1].sel].path)
				elseif (extension == "dax" and me==1) then rungameboot(explorer.list[scroll[1].sel].path)
				elseif (extension == "pbp" or extension == "bin") then
					local tmp0 = game.info(explorer.list[scroll[1].sel].path)
					if tmp0 then
						if cfw=="VHBL" and tmp0.CATEGORY=="MG" then
							rungameboot(explorer.list[scroll[1].sel].path)
						elseif cfw!="VHBL" then
							rungameboot(explorer.list[scroll[1].sel].path)
						end
					end
					tmp0=nil
				end
			end

			extension=nil
			if not explorer.list[scroll[1].sel].size then 					-- Its Dir
				table.insert(back,scroll[1])
				Root[Dev]=explorer.list[scroll[1].sel].path
				explorer.refresh()
			end
		end

	end

	if buttons.start and not slide_open[2] then								-- Switch device
		if Dev == 1 and files.exists("ef0:/") then
			Dev = 2
			explorer.refresh()
		elseif Dev == 2 and files.exists("ms0:/") then
			Dev = 1
			explorer.refresh()
		end
	end
end

function show_explorer_list()
	screen.print(5,5,Root[Dev],0.6,color.new(255,69,0),color.black)
	screen.print(475,5,#explorer.list,0.6,color.new(255,69,0),color.black,__ARIGHT)
	if scroll[1].maxim > 0 then 
		if scroll[1].maxim> 15 then -- Draw Scroll Bar
			local pos_height = math.max(225/scroll[1].maxim, 15)
			draw.fillrect(475, 25, 5, 225, color.new(255,255,255,100))
			draw.fillrect(475, 25+((225-pos_height)/(scroll[1].maxim-1))*(scroll[1].sel-1), 5, pos_height, color.new(0,255,0))
		end
		explorer.listshow()
	else
		screen.print(10,25,"...".."\n"..strings.back,0.7,color.white,color.black)
	end
	screen.print(240,240,explorer.src or "",0.5,color.white,color.black,512)
	screen.print(240,250,explorer.dst or "",0.5,color.white,color.black,512)
end

function show_explorer_menu()
	if slide_open[2] and slide_h < 110 then slide_h+=8 end
	if not slide_open[2] and slide_h > 0 then slide_h-=8 end
	if not slide_open[2] and slide_h < 2 then slide_open[1] = false end
	if not slide_open[1] and slide_h < 2 then divsect = 1 end
	draw.fillrect(slide_x,slide_y,90,slide_h,color.new(255,255,255,100))
	if slide_h > 100 then explorer.menushow() end -- la pongo aqui pues de lo contrario no actuan los ifÅLs
end

function ctrls_explorer_menu()
	if buttons.up or buttons.held.l then scroll.up(2) end
	if buttons.down or buttons.held.r then scroll.down(2) end

	if buttons[selection] then
		local numerador = 0
		if explorer.src == "" and scroll[2].sel <= 3 then
			if #explorer.list > 0 then
				if scroll[2].sel == 1 or scroll[2].sel == 2 then			--Copy/Move
					slide_opts_txt = {strings.paste,strings.delete,strings.makedir,strings.rename,strings.cancel}
					copysrc()
				else														--Extract
					if explorer.list[scroll[1].sel].ext and (files.ext(explorer.list[scroll[1].sel].path):upper()=="ZIP" or
						files.ext(explorer.list[scroll[1].sel].path):upper()=="RAR") then
						slide_opts_txt = {strings.extractto,strings.delete,strings.makedir,strings.rename,strings.cancel}
						copysrc()
					end
				end
			end
		elseif string.len(explorer.src) > 0 then
			if scroll[2].sel == 1 then
				explorer.dst = Root[Dev].."/"..files.nopath(explorer.src)
				if Root[Dev]:sub(#Root[Dev]) == "/" then
					explorer.dst = Root[Dev]..files.nopath(explorer.src)	
				end
				local screenback = screen.buffertoimage()
				if explorer.action == 1 then								--Paste from Copy
					explorer.dst = Root[Dev]
					files.copy(explorer.src,explorer.dst)
					screenback:blit(0,0)
				elseif explorer.action == 2 then							--Paste from Move
					if hw.getmodel() == "Vita" then explorer.dst=Root[Dev]
						if files.copy(explorer.src,explorer.dst) == 1 and files.exists(explorer.dst) then
							files.delete(explorer.src)
						end
						screenback:blit(0,0)
					else
						files.move(explorer.src,explorer.dst)
					end
				elseif explorer.action == 3 then							--Extract
					explorer.dst = files.nofile(explorer.dst)
					if os.message(strings.pass,1) == 1 then
						local pass = osk.init(strings.ospass,"")
						if pass then files.extract_w_bar(explorer.src,explorer.dst,pass) end
					else
						files.extract_w_bar(explorer.src,explorer.dst)
					end
					screenback:blit(0,0)
				end
				_refresh()
			end
			numerador = 2
		end -- end of string len

		if scroll[2].sel == (4 - numerador) and #explorer.list > 0 then		--Delete
			if os.message(strings.delete..explorer.list[scroll[1].sel].name.."?",1) == 1 then
				files.delete(explorer.list[scroll[1].sel].path)
				_refresh()
			end
		end
		if scroll[2].sel == (5 - numerador) then							--MakeDir
			local newfolder = osk.init(strings.creatfolder, strings.newfolder)
			if newfolder then
				local dest = Root[Dev].."/"..newfolder
				if Root[Dev]:sub(#Root[Dev]) == "/" then dest = Root[Dev]..newfolder end
				files.mkdir(dest)
				_refresh()
			end
		end
		if scroll[2].sel == (6 - numerador) and #explorer.list > 0 then		--Rename
			local name = osk.init(strings.rename,files.nopath(explorer.list[scroll[1].sel].path))
			if name then
				files.rename(explorer.list[scroll[1].sel].path, name)
				_refresh()
			end
		end
		if scroll[2].sel == (7-numerador) then								--Cancel
			_refresh()
		end
	end--if buttons[selection]
end

-- Functions for Colors
function color.getChs(val)-- retorna todos los canales..
	return val:r(),val:g(),val:b(),val:a()
end

function color.changeRGBA(channel,step)
	local channels = {}
	channels[1],channels[2],channels[3],channels[4] = BarColor:getChs()

	channels[channel]+=step

	if channels[channel] > 255 then channels[channel] = 255 end
	if channels[channel] < 0 then channels[channel] = 0 end

	return color.new(channels[1],channels[2],channels[3],channels[4])
end

function color.setChRaw(r,g,b,a)
	return ((r) | ((g)<<8) | ((b)<<16) | ((a)<<24))
end

function color.toRaw(val) -- obj color to RawColor
	local r,g,b,a = val:getChs()
	return color.setChRaw(r,g,b,a)
end
