function miscblock()
	local ispowered = findallfeature(nil,"is","power")
	
	if (#ispowered > 0) then
		powered = true
	else
		powered = false
	end
end

function statusblock(ids,undoing_)
	local checkthese = {}
	local undoing = undoing_ or false
	
	if (ids == nil) then
		for k,unit in ipairs(units) do
			table.insert(checkthese, unit)
		end
	else
		for i,v in ipairs(ids) do
			local vunit = mmf.newObject(v)
			table.insert(checkthese, vunit)
		end
	end
	
	for i,unit in pairs(checkthese) do
		local name = getname(unit)
		
		local oldfloat = unit.values[FLOAT]
		local newfloat = 0
		if (unit.values[FLOAT] < 2) and (generaldata.values[MODE] == 0) then
			unit.values[FLOAT] = 0
		end
		
		local isfloat = hasfeature(name,"is","float",unit.fixed)
		
		if (isfloat ~= nil) and (generaldata.values[MODE] == 0) then
			unit.values[FLOAT] = 1
			newfloat = 1
		end
		
		if (undoing == false) then
			if (oldfloat ~= newfloat) and (generaldata.values[MODE] == 0) and (generaldata2.values[ENDINGGOING] == 0) then
				addaction(unit.fixed,{"dofloat",oldfloat,newfloat,unit.values[ID],unit.fixed,name})
			end
			
			local right = hasfeature(name,"is","right",unit.fixed)
			local up = hasfeature(name,"is","up",unit.fixed)
			local left = hasfeature(name,"is","left",unit.fixed)
			local down = hasfeature(name,"is","down",unit.fixed)
			
			if (issleep(unit.fixed) == false) then
				if (right ~= nil) then
					updatedir(unit.fixed,0)
				end
				if (up ~= nil) then
					updatedir(unit.fixed,1)
				end
				if (left ~= nil) then
					updatedir(unit.fixed,2)
				end
				if (down ~= nil) then
					updatedir(unit.fixed,3)
				end
			end
		end
		
		if (unit.visible == false) and (generaldata2.values[ENDINGGOING] == 0) then
			local hide = hasfeature(name,"is","hide",unit.fixed)
			
			if (hide == nil) and (name ~= "level") then
				unit.visible = true
				
				if (undoing == false) then
					addundo({"visibility",name,unit.values[ID],1})
				end
			end
		end
		
		if (unit.values[A] == 1) or (unit.values[A] == 2) then
			local red = hasfeature(name,"is","red",unit.fixed)
			local blue = hasfeature(name,"is","blue",unit.fixed)
			
			if (red == nil) and (blue == nil) then
				if (unit.strings[UNITTYPE] ~= "text") and (unit.className ~= "level") then
					setcolour(unit.fixed)
					
					if (unit.values[A] == 1) then
						addundo({"colour",unit.values[ID],2,2,unit.values[A]})
					elseif (unit.values[A] == 2) then
						addundo({"colour",unit.values[ID],1,3,unit.values[A]})
					end
					
					unit.values[A] = 0
				end
			end
		end
	end
end

function moveblock()
	local isshift = findallfeature(nil,"is","shift",true)
	local isrevshift = findallfeature(nil,"is","reverse shift",true)
	local istele = findallfeature(nil,"is","tele",true)
	local isrevtele = findallfeature(nil,"is","reverse tele",true)
	local isfollow = findfeature(nil,"follow",nil,true)
	local isspin = findallfeature(nil,"is","spin",true)
	local isrevspin = findallfeature(nil,"is","reverse spin",true)
	local islean = findallfeature(nil,"is","lean",true)
	local isrevlean = findallfeature(nil,"is","reverse lean",true)
	local isturn = findallfeature(nil,"is","turn",true)
	local isrevturn = findallfeature(nil,"is","reverse turn",true)
	
	local doned = {}
	
	if (isfollow ~= nil) then
		for h,j in ipairs(isfollow) do
			local allfollows = findall(j)
			
			if (#allfollows > 0) then
				for k,l in ipairs(allfollows) do
					if (issleep(l) == false) then
						local unit = mmf.newObject(l)
						local x,y,name = unit.values[XPOS],unit.values[YPOS],unit.strings[UNITNAME]
						local unitrules = {}
						
						if (unit.strings[UNITTYPE] == "text") then
							name = "text"
						end
						
						if (featureindex[name] ~= nil) then					
							for a,b in ipairs(featureindex[name]) do
								local baserule = b[1]
								local conds = b[2]
								
								local verb = baserule[2]
								
								if (verb == "follow") then
									if testcond(conds,l) then
										table.insert(unitrules, b)
									end
								end
							end
						end
						
						local follow = xthis(unitrules,name,"follow")
						
						if (#follow > 0) then
							local distance = 9999
							local targetdir = -1
							
							for i,v in ipairs(follow) do
								local these = findall({v})
								
								if (#these > 0) then
									for a,b in ipairs(these) do
										if (b ~= unit.fixed) then
											local funit = mmf.newObject(b)
											
											local fx,fy = funit.values[XPOS],funit.values[YPOS]
											
											local xdir = fx-x
											local ydir = fy-y
											local dist = math.abs(xdir) + math.abs(ydir)
											local fdir = -1
											
											if (math.abs(xdir) <= math.abs(ydir)) then
												if (ydir >= 0) then
													fdir = 3
												else
													fdir = 1
												end
											else
												if (xdir > 0) then
													fdir = 0
												else
													fdir = 2
												end
											end
											
											if (dist < distance) then
												distance = dist
												targetdir = fdir
											end
										end
									end
								end
							end
			
							if (targetdir >= 0) then
								updatedir(unit.fixed,targetdir)
							end
						end
					end
				end
			end
		end
	end
	
	if memoryneeded then
		--[[
		for name,memgroup in pairs(memory) do
			local found = false
			
			if (featureindex["back"] ~= nil) then
				for a,b in ipairs(featureindex["back"]) do
					local rule = b[1]
					local conds = b[2]
					
					if (rule[1] == name) and (#conds == 0) then
						found = true
					end
				end
			end
			
			local delmem = {}
			
			for i,v in ipairs(memgroup) do
				if found then
					v.timer = v.timer + 2
					updateundo = true
					
					local undooffset = #undobuffer - v.undobuffer
					local undotargetid = undooffset - v.timer + 2
					local currundoid = #undobuffer - v.undobuffer + 1
					
					MF_alert(tostring(undotargetid) .. ", " .. tostring(#undobuffer) .. ", " .. tostring(undooffset))
					
					if (undotargetid == 0) and (currundoid > 0) then
						local currentundo = undobuffer[currundoid]
						
						MF_alert("Trying to load memory at slot " .. tostring(#currentundo - v.undoid))
						MF_alert("Undobuffer size = " .. tostring(#undobuffer[currundoid]))
						
						local line_ = #currentundo - v.undoid
						local line = currentundo[line_]
						
						local x,y,dir,levelfile,levelname,vislevel,complete,visstyle,maplevel,colour,clearcolour = line[3],line[4],line[5],line[8],line[9],line[10],line[11],line[12],line[13],line[14],line[15]
						local name = line[2]
						
						MF_alert("Object name: " .. tostring(name) .. ", " .. tostring(line[1]))
						
						local unitname = ""
						local unitid = 0
						
						if (name ~= "cursor") then
							unitname = unitreference[name]
							unitid = MF_emptycreate(unitname,x,y)
						else
							unitname = "Editor_selector"
							unitid = MF_specialcreate(unitname)
							setundo(1)
						end
						
						local unit = mmf.newObject(unitid)
						unit.values[ONLINE] = 1
						unit.values[XPOS] = x
						unit.values[YPOS] = y
						unit.values[DIR] = dir
						unit.values[ID] = line[6]
						unit.flags[9] = true
						
						MF_alert(v.undobuffer)
						MF_alert(math.floor(v.timer/2))
						
						unit.values[MISC_A] = v.undobuffer + math.floor(v.timer/2)
						unit.values[MISC_B] = math.floor(v.timer/2)
						
						if (name == "cursor") then
							unit.values[POSITIONING] = 7
						end
						
						unit.strings[U_LEVELFILE] = levelfile
						unit.strings[U_LEVELNAME] = levelname
						unit.flags[MAPLEVEL] = maplevel
						unit.values[VISUALLEVEL] = vislevel
						unit.values[VISUALSTYLE] = visstyle
						unit.values[COMPLETED] = complete
						
						unit.strings[COLOUR] = colour
						unit.strings[CLEARCOLOUR] = clearcolour
						
						if (unit.className == "level") then
							MF_setcolourfromstring(unitid,colour)
						end
						
						if (name ~= "cursor") then
							addunit(unitid)
							addunitmap(unitid,x,y,unit.strings[UNITNAME])
							dynamic(unitid)
						else
							MF_setcolour(unitid,4,2)
							unit.visible = true
							unit.layer = 2
						end
						
						if (unit.strings[UNITTYPE] == "text") then
							updatecode = 1
						end
						
						local undowordunits = currentundo.wordunits
						if (#undowordunits > 0) then
							for a,b in ipairs(undowordunits) do
								if (b == line[6]) then
									updatecode = 1
								end
							end
						end
						
						local visibility = hasfeature(name,"is","hide",unitid)
						
						if (visibility ~= nil) then
							unit.visible = false
						end
						
						table.insert(delmem, i)
					end
				else
					v.timer = 0
				end
			end
			
			for i,v in ipairs(delmem) do
				table.remove(memgroup, v + (i - 1))
			end
			
			if (#memgroup == 0) then
				memory[name] = nil
			end
		end
		]]--
	end
	
	local backed_this_turn = {};
	local not_backed_this_turn = {};
	
	local isback = findallfeature(nil,"is","back",true)
	for _,unitid in pairs(isback) do
		local unit = mmf.newObject(unitid)
		local name = getname(unit)
		backed_this_turn[unit.fixed] = true;
		if (backers_cache[unit.fixed] == 0 or backers_cache[unit.fixed] == nil) then
			addundo({"backer_turn", unit.fixed, 0})
			backers_cache[unit.fixed] = #undobuffer;
		end
		doBack(unit, 2*(#undobuffer-backers_cache[unit.fixed]));
	end
	
	for unit,turn in pairs(backers_cache) do
		if turn ~= nil and not backed_this_turn[unit] then
			not_backed_this_turn[unit] = true;
		end
	end
	
	for unitid,_ in pairs(not_backed_this_turn) do
		addundo({"backer_turn", unitid, backers_cache[unitid]})
		backers_cache[unitid] = nil;
	end
	
	doupdate()
	
	for i,unitid in ipairs(istele) do
		if (isgone(unitid) == false) then
			local unit = mmf.newObject(unitid)
			local name = getname(unit)
			local x,y = unit.values[XPOS],unit.values[YPOS]
		
			local targets = findallhere(x,y)
			local telethis = false
			local telethisx,telethisy = 0,0
			
			if (#targets > 0) then
				for i,v in ipairs(targets) do
					local vunit = mmf.newObject(v)
					local thistype = vunit.strings[UNITTYPE]
					
					local targetgone = isgone(v)
					-- Luultavasti ei väliä, onko kohde tuhoutumassa?
					targetgone = false
					
					if (targetgone == false) and floating(v,unitid) then
						local targetname = getname(vunit)
						if (objectdata[v] == nil) then
							objectdata[v] = {}
						end
						
						local odata = objectdata[v]
						
						if (odata.tele == nil) then
							if (targetname ~= name) and (v ~= unitid) then
								local teles = istele
								
								if (#teles > 1) then
									local teletargets = {}
									local targettele = 0
									
									for a,b in ipairs(teles) do
										local tele = mmf.newObject(b)
										local telename = getname(tele)
										
										if (b ~= unitid) and (telename == name) then
											table.insert(teletargets, b)
										end
									end
									
									if (#teletargets > 0) then
										targettele = teletargets[math.random(#teletargets)]
										local limit = 0
										
										while (targettele == unitid) and (limit < 10) do
											targettele = teletargets[math.random(#teletargets)]
											limit = limit + 1
										end
										
										odata.tele = 1
										
										local tele = mmf.newObject(targettele)
										local tx,ty = tele.values[XPOS],tele.values[YPOS]
										local vx,vy = vunit.values[XPOS],vunit.values[YPOS]
									
										update(v,tx,ty)
										
										local pmult,sound = checkeffecthistory("tele")
										
										MF_particles("glow",vx,vy,5 * pmult,1,4,1,1)
										MF_particles("glow",tx,ty,5 * pmult,1,4,1,1)
										setsoundname("turn",6,sound)
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	for a,unitid in ipairs(isrevtele) do
		local unit = mmf.newObject(unitid)
		local name = getname(unit)
		local x,y = unit.values[XPOS],unit.values[YPOS]
		
		local tx,ty = math.random(1,roomsizex-2),math.random(1,roomsizey-2)
		
		if (issafe(unitid) == false) then
			update(unitid,tx,ty)
			
			local pmult,sound = checkeffecthistory("tele")
			MF_particles("glow",x,y,5 * pmult,1,4,1,1)
			MF_particles("glow",tx,ty,5 * pmult,1,4,1,1)
			setsoundname("turn",6,sound)
		end
	end
	
	for a,unitid in ipairs(isshift) do
		if (unitid ~= 2) and (unitid ~= 1) then
			local unit = mmf.newObject(unitid)
			local x,y,dir = unit.values[XPOS],unit.values[YPOS],unit.values[DIR]
			
			local things = findallhere(x,y,unitid)
			
			if (#things > 0) and (isgone(unitid) == false) then
				for e,f in ipairs(things) do
					if floating(unitid,f) then
						local newunit = mmf.newObject(f)
						local name = newunit.strings[UNITNAME] 
						
						addundo({"update",name,x,y,newunit.values[DIR],x,y,unit.values[DIR],newunit.values[ID]})
						newunit.values[DIR] = unit.values[DIR]
					end
				end
			end
		end
	end
	
	for a,unitid in ipairs(isrevshift) do
		if (unitid ~= 2) and (unitid ~= 1) then
			local unit = mmf.newObject(unitid)
			local x,y,dir = unit.values[XPOS],unit.values[YPOS],rotate(unit.values[DIR])
			
			local things = findallhere(x,y,unitid)
			
			if (#things > 0) and (isgone(unitid) == false) then
				for e,f in ipairs(things) do
					if floating(unitid,f) then
						local newunit = mmf.newObject(f)
						local name = newunit.strings[UNITNAME] 
						
						addundo({"update",name,x,y,newunit.values[DIR],x,y,rotate(unit.values[DIR]),newunit.values[ID]})
						newunit.values[DIR] = unit.values[DIR]
					end
				end
			end
		end
	end
	
	for a,unitid in ipairs(isspin) do
		if (unitid ~= 2) and (unitid ~= 1) then
			local unit = mmf.newObject(unitid)
			local x,y,dir = unit.values[XPOS],unit.values[YPOS],unit.values[DIR]
			updatedir(unitid,(dir+3)%4);
		end
	end
	
	for a,unitid in ipairs(isrevspin) do
		if (unitid ~= 2) and (unitid ~= 1) then
			local unit = mmf.newObject(unitid)
			local x,y,dir = unit.values[XPOS],unit.values[YPOS],unit.values[DIR]
			updatedir(unitid,(dir+1)%4);
		end
	end
	
	for a,unitid in ipairs(islean) do
		if (unitid ~= 2) and (unitid ~= 1) then
			local unit = mmf.newObject(unitid)
			local fwd = unit.values[DIR]
			local right = (fwd+3)%4
			local bwd = (fwd+2)%4
			local left = (fwd+1)%4
			local result = changeDirIfFree(unitid, right) or changeDirIfFree(unitid, fwd) or changeDirIfFree(unitid, left) or changeDirIfFree(unitid, bwd);
		end
	end
	
	for a,unitid in ipairs(isrevlean) do
		if (unitid ~= 2) and (unitid ~= 1) then
			local unit = mmf.newObject(unitid)
			local fwd = rotate(unit.values[DIR])
			local right = (fwd+3)%4
			local bwd = (fwd+2)%4
			local left = (fwd+1)%4
			local result = changeDirIfFree(unitid, right) or changeDirIfFree(unitid, fwd) or changeDirIfFree(unitid, left) or changeDirIfFree(unitid, bwd);
		end
	end
	
	for a,unitid in ipairs(isturn) do
		if (unitid ~= 2) and (unitid ~= 1) then
			local unit = mmf.newObject(unitid)
			local fwd = unit.values[DIR]
			local right = (fwd+3)%4
			local bwd = (fwd+2)%4
			local left = (fwd+1)%4
			local result = changeDirIfFree(unitid, fwd) or changeDirIfFree(unitid, right) or changeDirIfFree(unitid, left) or changeDirIfFree(unitid, bwd);
		end
	end
	
	for a,unitid in ipairs(isturn) do
		if (unitid ~= 2) and (unitid ~= 1) then
			local unit = mmf.newObject(unitid)
			local fwd = rotate(unit.values[DIR])
			local right = (fwd+3)%4
			local bwd = (fwd+2)%4
			local left = (fwd+1)%4
			local result = changeDirIfFree(unitid, fwd) or changeDirIfFree(unitid, right) or changeDirIfFree(unitid, left) or changeDirIfFree(unitid, bwd);
		end
	end
	
	--Fix the 'txt be undo' bug by checking an additional time if we need to unset backer_turn for a unit.
	
	local backed_this_turn = {};
	local not_backed_this_turn = {};
	
	local isback = findallfeature(nil,"is","back",true)
	for _,unitid in pairs(isback) do
		backed_this_turn[unitid] = true;
	end
	
	for unit,turn in pairs(backers_cache) do
		if turn ~= nil and not backed_this_turn[unit] then
			not_backed_this_turn[unit] = true;
		end
	end
	
	for unitid,_ in pairs(not_backed_this_turn) do
		addundo({"backer_turn", unitid, backers_cache[unitid]})
		backers_cache[unitid] = nil;
	end
	
	doupdate()
end

function changeDirIfFree(unitid, dir)
	local unit = mmf.newObject(unitid)
	if simplecouldenter(unitid, unit.values[XPOS],unit.values[YPOS], ndirs[dir+1][1], ndirs[dir+1][2], true, false, true) then
		updatedir(unitid, dir);
		return true
	end
	return false
end

function fallblock(things)
	local checks = {}
	local fallcount = {}
	local vallcount = {}
	
	if (things == nil) then
		local isfall = findallfeature(nil,"is","fall",true)
		local isvall = findallfeature(nil,"is","vall",true)

		for a,unitid in ipairs(isfall) do
			if not fallcount[unitid] then
				fallcount[unitid] = 1
			else
				fallcount[unitid] = fallcount[unitid] + 1
			end
			table.insert(checks, unitid)
		end
		
		for a,unitid in ipairs(isvall) do
			if not vallcount[unitid] then
				vallcount[unitid] = 1
			else
				vallcount[unitid] = vallcount[unitid] + 1
			end
		end
	else
		for a,unitid in ipairs(things) do
			table.insert(checks, unitid)
		end
	end
	
	local done = false
	
	while (done == false) do
		local settled = true
		
		if (#checks > 0) then
			for a,unitid in pairs(checks) do
				local unit = mmf.newObject(unitid)
				local x,y,dir = unit.values[XPOS],unit.values[YPOS],unit.values[DIR]
				local name = getname(unit)
				local onground = false
				
				while (onground == false) do
					local below,below_,specials = check(unitid,x,y,3,false,"fall")
					
					local result = 0
					
					local falls = fallcount[unitid] or 0
					local valls = vallcount[unitid] or 0
					if falls <= valls then
						result = 1
					end
					
					for c,d in pairs(below) do
						if (d ~= 0) then
							result = 1
						else
							if (below_[c] ~= 0) and (result ~= 1) then
								if (result ~= 0) then
									result = 2
								else
									for e,f in ipairs(specials) do
										if (f[1] == below_[c]) then
											result = 2
										end
									end
								end
							end
						end
						
						--MF_alert(tostring(y) .. " -- " .. tostring(d) .. " (" .. tostring(below_[c]) .. ")")
					end
					
					--MF_alert(tostring(y) .. " -- result: " .. tostring(result))
					
					if (result ~= 1) then
						local gone = false
						
						if (result == 0) then
							update(unitid,x,y+1)
						elseif (result == 2) then
							gone = move(unitid,0,1,dir,specials,true,true)
						end
						
						-- Poista tästä kommenttimerkit jos haluat, että fall tsekkaa juttuja per pudottu tile
						if (gone == false) then
							y = y + 1
							--block({unitid},true)
							settled = false
							
							if unit.flags[DEAD] then
								onground = true
								table.remove(checks, a)
							else
								--[[
								local stillgoing = hasfeature(name,"is","fall",unitid,x,y)
								if (stillgoing == nil) then
									onground = true
									table.remove(checks, a)
								end
								]]--
							end
						else
							onground = true
							settled = true
						end
					else
						onground = true
					end
				end
			end
			
			if settled then
				done = true
			end
		else
			done = true
		end
	end
	
	vallblock(things)
end

function vallblock(things)
	local checks = {}
	local vallcount = {}
	local fallcount = {}
	
	if (things == nil) then
		local isvall = findallfeature(nil,"is","vall",true)
		local isfall = findallfeature(nil,"is","fall",true)

		for a,unitid in ipairs(isvall) do
			if not vallcount[unitid] then
				vallcount[unitid] = 1
			else
				vallcount[unitid] = vallcount[unitid] + 1
			end
			table.insert(checks, unitid)
		end
		
		for a,unitid in ipairs(isfall) do
			if not fallcount[unitid] then
				fallcount[unitid] = 1
			else
				fallcount[unitid] = fallcount[unitid] + 1
			end
		end
	else
		for a,unitid in ipairs(things) do
			table.insert(checks, unitid)
		end
	end
	
	local done = false
	
	while (done == false) do
		local settled = true
		
		if (#checks > 0) then
			for a,unitid in pairs(checks) do
				local unit = mmf.newObject(unitid)
				local x,y,dir = unit.values[XPOS],unit.values[YPOS],unit.values[DIR]
				local name = getname(unit)
				local onground = false
				
				while (onground == false) do
					local below,below_,specials = check(unitid,x,y,1,false,"vall")
					
					local result = 0
					
					local valls = vallcount[unitid] or 0
					local falls = fallcount[unitid] or 0
					if valls <= falls then
						result = 1
					end
					
					for c,d in pairs(below) do
						if (d ~= 0) then
							result = 1
						else
							if (below_[c] ~= 0) and (result ~= 1) then
								if (result ~= 0) then
									result = 2
								else
									for e,f in ipairs(specials) do
										if (f[1] == below_[c]) then
											result = 2
										end
									end
								end
							end
						end
						
						--MF_alert(tostring(y) .. " -- " .. tostring(d) .. " (" .. tostring(below_[c]) .. ")")
					end
					
					--MF_alert(tostring(y) .. " -- result: " .. tostring(result))
					
					if (result ~= 1) then
						local gone = false
						
						if (result == 0) then
							update(unitid,x,y-1)
						elseif (result == 2) then
							gone = move(unitid,0,1,rotate(dir),specials,true,true)
						end
						
						-- Poista tästä kommenttimerkit jos haluat, että vall tsekkaa juttuja per pudottu tile
						if (gone == false) then
							y = y - 1
							--block({unitid},true)
							settled = false
							
							if unit.flags[DEAD] then
								onground = true
								table.remove(checks, a)
							else
								--[[
								local stillgoing = hasfeature(name,"is","vall",unitid,x,y)
								if (stillgoing == nil) then
									onground = true
									table.remove(checks, a)
								end
								]]--
							end
						else
							onground = true
							settled = true
						end
					else
						onground = true
					end
				end
			end
			
			if settled then
				done = true
			end
		else
			done = true
		end
	end
end

function block(small_)
	local delthese = {}
	local doned = {}
	local unitsnow = #units
	local removalsound = 1
	local removalshort = ""
	
	local small = small_ or false
	
	local doremovalsound = false
	
	if (small == false) then
		if (generaldata2.values[ENDINGGOING] == 0) then
			local isdone = getunitswitheffect("done",delthese)
			
			for id,unit in ipairs(isdone) do
				table.insert(doned, unit)
			end
			
			if (#doned > 0) then
				setsoundname("turn",10)
			end
		end
		
		local isblue = getunitswitheffect("blue",delthese)
		local isred = getunitswitheffect("red",delthese)
		
		for id,unit in ipairs(isred) do
			MF_setcolour(unit.fixed,2,2)
			
			if (unit.values[A] ~= 1) then
				local c1,c2 = 0,0
				
				if (unit.values[A] == 0) then
					c1,c2 = getcolour(unit.fixed)
				elseif (unit.values[A] == 2) then
					c1,c2 = 1,3
				end
				
				addundo({"colour",unit.values[ID],c1,c2,unit.values[A]})
				unit.values[A] = 1
			end
		end
		
		for id,unit in ipairs(isblue) do
			MF_setcolour(unit.fixed,1,3)
			
			if (unit.values[A] ~= 2) then
				local c1,c2 = 0,0
				
				if (unit.values[A] == 0) then
					c1,c2 = getcolour(unit.fixed)
				elseif (unit.values[A] == 1) then
					c1,c2 = 2,2
				end
				
				addundo({"colour",unit.values[ID],c1,c2,unit.values[A]})
				unit.values[A] = 2
			end
		end
		
		local ismore = findallfeature(nil,"is","more")
		local isless = findallfeature(nil,"is","reverse more")
		
		local ismoreness = {}
		local anythingness = {}
		
		for i,unit in ipairs(ismore) do
			id = unit
			if (id > 2) then
				anythingness[id] = true
				if (ismoreness[id] == nil) then
					ismoreness[id] = 1
				else
					ismoreness[id] = ismoreness[id] + 1
				end
			end
		end
		
		for i,unit in ipairs(isless) do
			id = unit
			if (id > 2) then
				anythingness[id] = true
				if (ismoreness[id] == nil) then
					ismoreness[id] = -1
				else
					ismoreness[id] = ismoreness[id] - 1
				end
			end
		end
		
		delthese = {}
		
		for id,dummy in pairs(anythingness) do
			local unit = mmf.newObject(id)
			local x,y = unit.values[XPOS],unit.values[YPOS]
			local name = unit.strings[UNITNAME]
			local moreness = ismoreness[id]
			--print(tostring(moreness)..","..tostring(multness))
			
			--handle MORE
			while (moreness > 0) do
				moreness = moreness - 1
				
				for i=1,4 do
					local drs = dirs_diagonals[i]
					ox = drs[1]
					oy = drs[2]
					
					local valid = simplecouldenter(unit.fixed, x, y, ox, oy, true, true, activemod.more_checks_empty)
					
					if valid then
						local newunit = copy(unit.fixed,x+ox,y+oy)
					end
				end
			end
			
			--handle LESS
			while (moreness < 0) do
				moreness = moreness + 1
				if (issafe(unit.fixed) == false) then	
					local could_grow = false
					
					for i=1,4 do
						local drs = dirs_diagonals[i]
						ox = drs[1]
						oy = drs[2]
						
						local valid = simplecouldenter(unit.fixed, x, y, ox, oy, true, true, activemod.more_checks_empty)
						
						if valid then
							could_grow = true
							break
						end
					end
				
					if (could_grow) then
						local pmult,sound = checkeffecthistory("defeat")
						MF_particles("destroy",x,y,5 * pmult,0,3,1,1)
						table.insert(delthese, unit.fixed)
					end
				end
			end
		end
	end
	
	local issink = getunitswitheffect("sink",delthese)
	
	for id,unit in ipairs(issink) do
		local x,y = unit.values[XPOS],unit.values[YPOS]
		local tileid = x + y * roomsizex
		
		if (unitmap[tileid] ~= nil) then
			local water = findallhere(x,y)
			local boat = findfeatureat(nil,"is","reverse sink",x,y)
			local sunk = false
			
			if (#water > 0) then
				for a,b in ipairs(water) do
					if floating(b,unit.fixed) then
						if (issafe(b) == false) and (b ~= unit.fixed) and (boat == nil) then
							local dosink = true
							
							for c,d in ipairs(delthese) do
								if (d == unit.fixed) or (d == b) then
									dosink = false
								end
							end
							
							if dosink then
								generaldata.values[SHAKE] = 3
								table.insert(delthese, b)
								
								local pmult,sound = checkeffecthistory("sink")
								removalshort = sound
								removalsound = 3
								local c1,c2 = getcolour(unit.fixed)
								MF_particles("destroy",x,y,15 * pmult,c1,c2,1,1)
								
								if (b ~= unit.fixed) and (issafe(unit.fixed) == false) then
									sunk = true
								end
							end
						end
					end
				end
			end
			
			if sunk then
				table.insert(delthese, unit.fixed)
			end
		end
	end
	
	delthese,doremovalsound = handledels(delthese,doremovalsound)
	
	local isweak = getunitswitheffect("weak",delthese)
	
	for id,unit in ipairs(isweak) do
		if (issafe(unit.fixed) == false) then
			local x,y = unit.values[XPOS],unit.values[YPOS]
			local stuff = findallhere(x,y)
			
			if (#stuff > 0) then
				for i,v in ipairs(stuff) do
					if floating(v,unit.fixed) then
						local vunit = mmf.newObject(v)
						local thistype = vunit.strings[UNITTYPE]
						if (v ~= unit.fixed) then
							local pmult,sound = checkeffecthistory("weak")
							MF_particles("destroy",x,y,5 * pmult,0,3,1,1)
							removalshort = sound
							removalsound = 1
							generaldata.values[SHAKE] = 4
							table.insert(delthese, unit.fixed)
							break
						end
					end
				end
			end
		end
	end
	
	local isstrong = getunitswitheffect("reverse weak",delthese)
	
	for id,unit in ipairs(isstrong) do
		local x,y = unit.values[XPOS],unit.values[YPOS]
		local stuff = findallhere(x,y)
		
		if (#stuff > 0) then
			for i,v in ipairs(stuff) do
				if floating(v,unit.fixed) and not issafe(v) then
					local vunit = mmf.newObject(v)
					local thistype = vunit.strings[UNITTYPE]
					if (v ~= unit.fixed) then
						local pmult,sound = checkeffecthistory("strong")
						MF_particles("destroy",x,y,5 * pmult,0,3,1,1)
						removalshort = sound
						removalsound = 1
						generaldata.values[SHAKE] = 4
						table.insert(delthese, v)
						break
					end
				end
			end
		end
	end
	
	delthese,doremovalsound = handledels(delthese,doremovalsound)
	
	local ismelt = getunitswitheffect("melt",delthese)
	
	for id,unit in ipairs(ismelt) do
		local hot = findfeature(nil,"is","hot")
		local x,y = unit.values[XPOS],unit.values[YPOS]
		
		if (hot ~= nil) then
			for a,b in ipairs(hot) do
				local lava = findtype(b,x,y,0)
			
				if (#lava > 0) and (issafe(unit.fixed) == false) then
					for c,d in ipairs(lava) do
						if floating(d,unit.fixed) then
							local pmult,sound = checkeffecthistory("hot")
							MF_particles("smoke",x,y,5 * pmult,0,1,1,1)
							generaldata.values[SHAKE] = 5
							removalshort = sound
							removalsound = 9
							table.insert(delthese, unit.fixed)
							break
						end
					end
				end
			end
		end
	end
	
	delthese,doremovalsound = handledels(delthese,doremovalsound)
	
	local isyou = getunitswitheffect("you",delthese)
	local isyou2 = getunitswitheffect("you2",delthese)
	local isrevyou = getunitswitheffect("reverse you",delthese)
	
	for i,v in ipairs(isyou2) do
		table.insert(isyou, v)
	end
	
	for i,v in ipairs(isrevyou) do
		table.insert(isyou, v)
	end
	
	for id,unit in ipairs(isyou) do
		local x,y = unit.values[XPOS],unit.values[YPOS]
		local defeat = findfeature(nil,"is","defeat")
		
		if (defeat ~= nil) then
			for a,b in ipairs(defeat) do
				if (b[1] ~= "empty") then
					local skull = findtype(b,x,y,0)
					
					if (#skull > 0) and (issafe(unit.fixed) == false) then
						for c,d in ipairs(skull) do
							local doit = false
							
							if (d ~= unit.fixed) then
								if floating(d,unit.fixed) then
									local kunit = mmf.newObject(d)
									local kname = getname(kunit)
									
									local weakskull = hasfeature(kname,"is","weak",d)
									
									if (weakskull == nil) or ((weakskull ~= nil) and issafe(d)) then
										doit = true
									end
								end
							else
								doit = true
							end
							
							if doit then
								local pmult,sound = checkeffecthistory("defeat")
								MF_particles("destroy",x,y,5 * pmult,0,3,1,1)
								generaldata.values[SHAKE] = 5
								removalshort = sound
								removalsound = 1
								table.insert(delthese, unit.fixed)
							end
						end
					end
				end
			end
		end
	end
	
	delthese,doremovalsound = handledels(delthese,doremovalsound)
	
	local isshut = getunitswitheffect("shut",delthese)
	
	for id,unit in ipairs(isshut) do
		local open = findfeature(nil,"is","open")
		local x,y = unit.values[XPOS],unit.values[YPOS]
		
		if (open ~= nil) then
			for i,v in ipairs(open) do
				local key = findtype(v,x,y,0)
				
				if (#key > 0) then
					local doparts = false
					for a,b in ipairs(key) do
						if (b ~= 0) and floating(b,unit.fixed) then
							if (issafe(unit.fixed) == false) then
								generaldata.values[SHAKE] = 8
								table.insert(delthese, unit.fixed)
								doparts = true
								online = false
							end
							
							if (b ~= unit.fixed) and (issafe(b) == false) then
								table.insert(delthese, b)
								doparts = true
							end
							
							if doparts then
								local pmult,sound = checkeffecthistory("unlock")
								setsoundname("turn",7,sound)
								MF_particles("unlock",x,y,15 * pmult,2,4,1,1)
							end
							
							break
						end
					end
				end
			end
		end
	end
	
	delthese,doremovalsound = handledels(delthese,doremovalsound)
	
	local iseat = getunitswithverb("eat",delthese)
	
	for id,ugroup in ipairs(iseat) do
		local v = ugroup[1]
		
		for a,unit in ipairs(ugroup[2]) do
			local x,y = unit.values[XPOS],unit.values[YPOS]
			local things = findtype({v,nil},x,y,unit.fixed)
			
			if (#things > 0) then
				for a,b in ipairs(things) do
					if (issafe(b) == false) and floating(b,unit.fixed) and (b ~= unit.fixed) then
						generaldata.values[SHAKE] = 4
						table.insert(delthese, b)
						
						local pmult,sound = checkeffecthistory("eat")
						MF_particles("eat",x,y,5 * pmult,0,3,1,1)
						removalshort = sound
						removalsound = 1
					end
				end
			end
		end
	end
	
	delthese,doremovalsound = handledels(delthese,doremovalsound)
	
	local isplay = getunitswithverb("play",delthese)
	
	for id,ugroup in ipairs(isplay) do
		local sound_freq = ugroup[1]
		local sound_units = ugroup[2]
		local sound_name = ugroup[3]
		
		if (#sound_units > 0) then
			local tunes = {
				baba = "tune",
				box = "drum_kick",
				rock = "drum_snare",
				key = "drum_hat",
				keke = "tune_blop",
				skull = "tune_short",
			}
				
			local freqs = {
				a = 44000,
				b = 49388,
				c = 52325,
				d = 58733,
				e = 65925,
				f = 69846,
				g = 78399,
			}
				
			local tune = tunes[sound_name] or "tune"
			local freq = freqs[sound_freq] or 44000
			
			MF_playsound_freq(tune,freq)
			setsoundname("turn",11,nil)
			
			for a,unit in ipairs(sound_units) do
				local x,y = unit.values[XPOS],unit.values[YPOS]
				
				MF_particles("music",unit.values[XPOS],unit.values[YPOS],1,0,3,3,1)
			end
		end
	end
	
	isyou = getunitswitheffect("you",delthese)
	isyou2 = getunitswitheffect("you2",delthese)
	isrevyou = getunitswitheffect("reverse you",delthese)
	
	for i,v in ipairs(isyou2) do
		table.insert(isyou, v)
	end
	
	for i,v in ipairs(isrevyou) do
		table.insert(isyou, v)
	end
	
	for id,unit in ipairs(isyou) do
		if (unit.flags[DEAD] == false) and (delthese[unit.fixed] == nil) then
			local x,y = unit.values[XPOS],unit.values[YPOS]
			
			if (small == false) then
				local bonus = findfeature(nil,"is","bonus")
				
				if (bonus ~= nil) then
					for a,b in ipairs(bonus) do
						if (b[1] ~= "empty") then
							local flag = findtype(b,x,y,0)
							
							if (#flag > 0) then
								for c,d in ipairs(flag) do
									if floating(d,unit.fixed) then
										local pmult,sound = checkeffecthistory("bonus")
										MF_particles("bonus",x,y,10 * pmult,4,1,1,1)
										removalshort = sound
										removalsound = 2
										MF_playsound("bonus")
										MF_bonus()
										generaldata.values[SHAKE] = 5
										table.insert(delthese, d)
									end
								end
							end
						end
					end
				end
				
				local ending = findfeature(nil,"is","end")
				
				if (ending ~= nil) then
					for a,b in ipairs(ending) do
						if (b[1] ~= "empty") then
							local flag = findtype(b,x,y,0)
							
							if (#flag > 0) then
								for c,d in ipairs(flag) do
									if floating(d,unit.fixed) and (generaldata.values[MODE] == 0) then
										MF_particles("unlock",x,y,10,1,4,1,1)
										MF_end(unit.fixed,d)
										break
									end
								end
							end
						end
					end
				end
			end
			
			local reset = findfeature(nil,"is","reset")
			
			if (reset ~= nil) and not doreset then
				for a,b in ipairs(reset) do
					if (b[1] ~= "empty") then
						local flag = findtype(b,x,y,0)
						
						if (#flag > 0) then
							for c,d in ipairs(flag) do
								if floating(d,unit.fixed) then
									doreset = true
									break
								end
							end
						end
					end
				end
			end
			
			local win = findfeature(nil,"is","win")
			
			if (win ~= nil) then
				for a,b in ipairs(win) do
					if (b[1] ~= "empty") then
						local flag = findtype(b,x,y,0)
						
						if (#flag > 0) then
							for c,d in ipairs(flag) do
								if floating(d,unit.fixed) then
									local pmult = checkeffecthistory("win")
									
									MF_particles("win",x,y,10 * pmult,2,4,1,1)
									MF_win()
									break
								end
							end
						end
					end
				end
			end
		end
	end
	
	delthese,doremovalsound = handledels(delthese,doremovalsound)
	
	if (small == false) then
		local ismake = getunitswithverb("make",delthese)
		
		for id,ugroup in ipairs(ismake) do
			local v = ugroup[1]
			
			for a,unit in ipairs(ugroup[2]) do
				local x,y,dir,name = 0,0,4,""
				
				if (ugroup[3] ~= "empty") then
					x,y,dir = unit.values[XPOS],unit.values[YPOS],unit.values[DIR]
					name = getname(unit)
				else
					x = math.floor(unit % roomsizex)
					y = math.floor(unit / roomsizex)
					name = "empty"
					dir = emptydir(x,y)
				end
				
				if (dir == 4) then
					dir = math.random(0,3)
				end
				
				local exists = false
				
				if (v ~= "text") and (v ~= "all") then
					for b,mat in pairs(objectlist) do
						if (b == v) then
							exists = true
						end
					end
				else
					exists = true
				end
				
				if exists then
					local domake = true
					
					if (name ~= "empty") then
						local thingshere = findallhere(x,y)
						
						if (#thingshere > 0) then
							for a,b in ipairs(thingshere) do
								local thing = mmf.newObject(b)
								local thingname = thing.strings[UNITNAME]
								
								if (thingname == v) or ((thing.strings[UNITTYPE] == "text") and (v == "text")) then
									domake = false
								end
							end
						end
					end
					
					if domake then
						if (v ~= "empty") and (v ~= "all") and (v ~= "text") and (v ~= "group") then
							create(v,x,y,dir,x,y)
						elseif (v == "all") then
							--[[
							for b,mat in pairs(objectlist) do
								local ishere = findtype(b,x,y,0)
								
								if (#ishere == 0) and (b ~= "empty") and (b ~= "all") and (b ~= "group") then
									create(b,x,y,dir,x,y)
								end
							end
							]]--
						elseif (v == "text") then
							if (name ~= "text") and (name ~= "all") then
								create("text_" .. name,x,y,dir,x,y)
								updatecode = 1
							end
						end
					end
				end
			end
		end
		
		for i,unit in ipairs(doned) do
			addundo({"done",unit.strings[UNITNAME],unit.values[XPOS],unit.values[YPOS],unit.values[DIR],unit.values[ID],unit.fixed,unit.values[FLOAT]})
			
			unit.values[FLOAT] = 2
			unit.values[EFFECTCOUNT] = math.random(-10,10)
			unit.values[POSITIONING] = 7
			unit.flags[DEAD] = true
			
			delunit(unit.fixed)
		end
	end
	
	delthese,doremovalsound = handledels(delthese,doremovalsound)
	
	if (small == false) then
		local ishide = getunitswitheffect("hide",delthese)
		
		for id,unit in ipairs(ishide) do
			local name = unit.strings[UNITNAME]
			if unit.visible then
				unit.visible = false
				addundo({"visibility",name,unit.values[ID],0})
			end
		end
	end
	
	if doremovalsound then
		setsoundname("removal",removalsound,removalshort)
	end
end

function handledels(delthese,doremovalsound)
	local result = doremovalsound or false
	
	for i,uid in pairs(delthese) do
		result = true
		
		if (deleted[uid] == nil) then
			delete(uid)
			deleted[uid] = 1
		end
	end
	
	return {},result
end

function startblock(light_)
	local light = light_ or false
	
	if (light == false) and (featureindex["level"] ~= nil) then
		MF_levelrotation(0)
		maprotation = 0
		for i,v in ipairs(featureindex["level"]) do
			local rule = v[1]
			local conds = v[2]
			
			if testcond(conds,1) then
				if (rule[1] == "level") and (rule[2] == "is") then
					if (rule[3] == "right") then
						maprotation = 90
						mapdir = 0
						MF_levelrotation(90)
					elseif (rule[3] == "up") then
						maprotation = 180
						mapdir = 1
						MF_levelrotation(180)
					elseif (rule[3] == "left") then
						maprotation = 270
						mapdir = 2
						MF_levelrotation(270)
					elseif (rule[3] == "down") then
						maprotation = 0
						mapdir = 3
						MF_levelrotation(0)
					end
				end
			end
		end
	end
	
	for i,unit in ipairs(units) do
		local name = unit.strings[UNITNAME]
		local unitid = unit.fixed
		local unitrules = {}
		
		if (unit.strings[UNITTYPE] == "text") then
			name = "text"
		end
		
		if (featureindex[name] ~= nil) then
			for a,b in ipairs(featureindex[name]) do
				local conds = b[2]
				
				if testcond(conds,unitid) then
					table.insert(unitrules, b)
				end
			end
			
			local ishide = isthis(unitrules,"hide")
			local isfollow = xthis(unitrules,name,"follow")
			local isfloat = isthis(unitrules,"float")
			local sleep = isthis(unitrules,"sleep")
			local isred = isthis(unitrules,"red")
			local isblue = isthis(unitrules,"blue")
			local ismake = xthis(unitrules,name,"make")
			
			local isright = isthis(unitrules,"right")
			local isup = isthis(unitrules,"up")
			local isleft = isthis(unitrules,"left")
			local isdown = isthis(unitrules,"down")
			
			if (sleep == false) then
				if isright then
					updatedir(unit.fixed,0)
				end
				if isup then
					updatedir(unit.fixed,1)
				end
				if isleft then
					updatedir(unit.fixed,2)
				end
				if isdown then
					updatedir(unit.fixed,3)
				end
			end
			
			if ishide then
				if unit.visible then
					unit.visible = false
				end
			end
			
			if isfloat then
				unit.values[FLOAT] = 1
			end
			
			if sleep then
				if (unit.values[TILING] == 2) or (unit.values[TILING] == 3) then
					unit.values[VISUALDIR] = -1
					unit.direction = ((unit.values[DIR] * 8 + unit.values[VISUALDIR]) + 32) % 32
				end
			end
			
			if isblue then
				MF_setcolour(unitid,1,3)
				unit.values[A] = 2
			end
			
			if isred then
				MF_setcolour(unitid,2,2)
				unit.values[A] = 1
			end
			
			if (light == false) and (#isfollow > 0) then
				local x,y = unit.values[XPOS],unit.values[YPOS]
				local distance = 9999
				local targetdir = -1
				
				for c,v in ipairs(isfollow) do
					local these = findall({v})
					
					if (#these > 0) then
						for a,b in ipairs(these) do
							if (b ~= unit.fixed) then
								local funit = mmf.newObject(b)
								
								local fx,fy = funit.values[XPOS],funit.values[YPOS]
								
								local xdir = fx-x
								local ydir = fy-y
								local dist = math.abs(xdir) + math.abs(ydir)
								local fdir = -1
								
								if (math.abs(xdir) <= math.abs(ydir)) then
									if (ydir >= 0) then
										fdir = 3
									else
										fdir = 1
									end
								else
									if (xdir >= 0) then
										fdir = 0
									else
										fdir = 2
									end
								end
								
								if (dist < distance) then
									distance = dist
									targetdir = fdir
								end
							end
						end
					end
				end
				
				
				if (targetdir >= 0) then
					updatedir(unit.fixed,targetdir)
				end
			end
				
			if (light == false) and (#ismake > 0) and (isgone(unitid) == false) then
				local x,y,dir = unit.values[XPOS],unit.values[YPOS],unit.values[DIR]
				local thingshere = findallhere(x,y)
				
				for c,v in ipairs(ismake) do
					local domake = true
					local exists = false
					
					if (v ~= "text") and (v ~= "all") then
						for b,mat in pairs(objectlist) do
							if (b == v) then
								exists = true
							end
						end
					else
						exists = true
					end
					
					if exists then
						if (#thingshere > 0) then
							for a,b in ipairs(thingshere) do
								local thing = mmf.newObject(b)
								local thingname = thing.strings[UNITNAME]
								
								if (thingname == v) or ((thing.strings[UNITTYPE] == "text") and (v == "text")) then
									domake = false
								end
							end
						end
						
						if domake then
							if (v ~= "empty") and (v ~= "all") and (v ~= "text") then
								create(v,x,y,dir,x,y)
							elseif (v == "all") then
								for b,mat in pairs(objectlist) do
									local ishere = findtype(b,x,y,0)
									
									if (#ishere == 0) then
										create(b,x,y,dir,x,y)
									end
								end
							elseif (v == "text") then
								if (name ~= "empty") and (name ~= "text") and (name ~= "all") then
									create("text_" .. name,x,y,dir,x,y)
									updatecode = 1
								end
							end
						end
					end
				end
			end
		end
	end
end

function levelblock()
	local unlocked = false
	local things = {}
	local donethings = {}
	
	local emptythings = {}
	
	if (featureindex["level"] ~= nil) then
		for i,v in ipairs(featureindex["level"]) do
			table.insert(things, v)
		end
	end
	
	if (featureindex["empty"] ~= nil) then
		for i,v in ipairs(featureindex["empty"]) do
			local rule = v[1]
			
			if (rule[1] == "empty") and (rule[2] == "is") then
				table.insert(emptythings, v)
			end
		end
	end
	
	if (#emptythings > 0) then
		for i=1,roomsizex-2 do
			for j=1,roomsizey-2 do
				local tileid = i + j * roomsizex
				
				if (unitmap[tileid] == nil) or (#unitmap[tileid] == 0) then
					--MF_alert(tostring(i) .. ", " .. tostring(j))
					local keypair = ""
					local unlock = false
					
					for a,rules in ipairs(emptythings) do
						local rule = rules[1]
						local conds = rules[2]
						
						if (rule[3] == "open") and testcond(conds,2,i,j) then
							if (string.len(keypair) == 0) then
								keypair = "shut"
							elseif (keypair == "open") then
								unlock = true
							end
						elseif (rule[3] == "shut") and testcond(conds,2,i,j) then
							if (string.len(keypair) == 0) then
								keypair = "open"
							elseif (keypair == "shut") then
								unlock = true
							end
						end
					end
					
					if unlock then
						setsoundname("turn",7)
						
						if (math.random(1,4) == 1) then
							MF_particles("unlock",i,j,1,2,4,1,1)
						end
						
						delete(2,i,j)
					end
				end
			end
		end
	end
	
	if (#things > 0) then
		for i,rules in ipairs(things) do
			local rule = rules[1]
			local conds = rules[2]
			
			if testcond(conds,1) and (rule[2] == "is") then
				local action = rule[3]
				
				if (action == "reset" or action == "win") then
					local yous = findfeature(nil,"is","you")
					local yous2 = findfeature(nil,"is","you2")
					local revyous = findfeature(nil,"is","reverse you")
					
					if (yous == nil) then
						yous = {}
					end
					
					if (yous2 ~= nil) then
						for i,v in ipairs(yous2) do
							table.insert(yous, v)
						end
					end
					
					if (revyous ~= nil) then
						for i,v in ipairs(revyous) do
							table.insert(yous, v)
						end
					end
					
					local canwin = false
					
					if (yous ~= nil) then
						for a,b in ipairs(yous) do
							local allyous = findall(b)
							local doit = false
							
							for c,d in ipairs(allyous) do
								if floating_level(d) then
									doit = true
								end
							end
							
							if doit then
								canwin = true
								if action == "win" then
									for c,d in ipairs(allyous) do
										local unit = mmf.newObject(d)
										local pmult,sound = checkeffecthistory("win")
										MF_particles("win",unit.values[XPOS],unit.values[YPOS],10 * pmult,2,4,1,1)
									end
								end
							end
						end
					end
					
					if (hasfeature("level","is","you",1) ~= nil) or (hasfeature("level","is","you2",1) ~= nil) then
						canwin = true
					end
					
					if canwin then
						if action == "win" then MF_win() else doreset = true end
					end
				elseif (action == "defeat") then
					local yous = findfeature(nil,"is","you")
					local yous2 = findfeature(nil,"is","you2")
					local revyous = findfeature(nil,"is","reverse you")
					
					if (yous == nil) then
						yous = {}
					end
					
					if (yous2 ~= nil) then
						for i,v in ipairs(yous2) do
							table.insert(yous, v)
						end
					end
					
					if (revyous ~= nil) then
						for i,v in ipairs(revyous) do
							table.insert(yous, v)
						end
					end
					
					if (yous ~= nil) then
						for a,b in ipairs(yous) do
							if (b[1] ~= "level") then
								local allyous = findall(b)
								
								if (#allyous > 0) then
									for c,d in ipairs(allyous) do
										if (issafe(d) == false) and floating_level(d) then
											local unit = mmf.newObject(d)
											
											local pmult,sound = checkeffecthistory("defeat")
											MF_particles("destroy",unit.values[XPOS],unit.values[YPOS],5 * pmult,0,3,1,1)
											setsoundname("removal",1,sound)
											generaldata.values[SHAKE] = 2
											delete(d)
										end
									end
								end
							else
								destroylevel()
							end
						end
					end
				elseif (action == "weak") then
					for i,unit in ipairs(units) do
						local name = unit.strings[UNITNAME]
						if (unit.strings[UNITTYPE] == "text") then
							name = "text"
						end
						
						if floating_level(unit.fixed) and (issafe(unit.fixed) == false) then
							destroylevel()
						end
					end
				elseif (action == "hot") then
					local melts = findfeature(nil,"is","melt")
					
					if (melts ~= nil) then
						for a,b in ipairs(melts) do
							local allmelts = findall(b)
							
							if (#allmelts > 0) then
								for c,d in ipairs(allmelts) do
									if (issafe(d) == false) and floating_level(d) then
										local unit = mmf.newObject(d)
										
										local pmult,sound = checkeffecthistory("hot")
										MF_particles("smoke",unit.values[XPOS],unit.values[YPOS],5 * pmult,0,1,1,1)
										generaldata.values[SHAKE] = 2
										setsoundname("removal",9,sound)
										delete(d)
									end
								end
							end
						end
					end
				elseif (action == "reverse weak") then
					if (units ~= nil) then
						delthese = {}
						doremovalsound = true
						for a,b in ipairs(units) do
							print(b)
							if (issafe(b.fixed) == false) and floating_level(b.fixed) then
								local unit = b
								local pmult,sound = checkeffecthistory("weak")
								local x,y = unit.values[XPOS],unit.values[YPOS]
								MF_particles("destroy",x,y,5 * pmult,0,3,1,1)
								removalshort = sound
								removalsound = 1
								generaldata.values[SHAKE] = 4
								table.insert(delthese, unit.fixed)
							end
						end
						delthese,doremovalsound = handledels(delthese,doremovalsound)
					end
				elseif (action == "melt") then
					local hots = findfeature(nil,"is","hot")
					
					if (hots ~= nil) then
						for a,b in ipairs(hots) do
							local doit = false
							
							if (b[1] ~= "level") then
								local allhots = findall(b)
								
								for c,d in ipairs(allhots) do
									if floating_level(d) then
										doit = true
									end
								end
							else
								doit = true
							end
							
							if doit then
								destroylevel()
							end
						end
					end
				elseif (action == "open") then
					local shuts = findfeature(nil,"is","shut")
					
					if (shuts ~= nil) then
						for a,b in ipairs(shuts) do
							local doit = false
							
							if (b[1] ~= "level") then
								local allshuts = findall(b)
								
								
								for c,d in ipairs(allshuts) do
									if floating_level(d) then
										doit = true
									end
								end
							else
								doit = true
							end
							
							if doit then
								destroylevel()
							end
						end
					end
				elseif (action == "shut") then
					local opens = findfeature(nil,"is","open")
					
					if (opens ~= nil) then
						for a,b in ipairs(opens) do
							local doit = false
							
							if (b[1] ~= "level") then
								local allopens = findall(b)
								
								for c,d in ipairs(allopens) do
									if floating_level(d) then
										doit = true
									end
								end
							else
								doit = true
							end
							
							if doit then
								destroylevel()
							end
						end
					end
				elseif (action == "sink") then
					for a,unit in ipairs(units) do
						local name = unit.strings[UNITNAME]
						if (unit.strings[UNITTYPE] == "text") then
							name = "text"
						end
						if floating_level(unit.fixed) then
							destroylevel()
						end
					end
				elseif (action == "tele") or (action == "reverse tele") then
					for a,unit in ipairs(units) do
						local x,y = unit.values[XPOS],unit.values[YPOS]
						
						local tx,ty = math.random(1,roomsizex-2),math.random(1,roomsizey-2)
						
						if (issafe(unit.fixed) == false) and floating_level(unit.fixed) then
							update(unit.fixed,tx,ty)
							
							local pmult,sound = checkeffecthistory("tele")
							MF_particles("glow",x,y,5 * pmult,1,4,1,1)
							MF_particles("glow",tx,ty,5 * pmult,1,4,1,1)
							setsoundname("turn",6,sound)
						end
					end
				elseif (action == "move") then
					local dir = mapdir
					
					local drs = ndirs[dir + 1]
					local ox,oy = drs[1],drs[2]
					
					addundo({"levelupdate",Xoffset,Yoffset,Xoffset + ox * tilesize,Yoffset + oy * tilesize,dir,dir})
					MF_scrollroom(ox * tilesize,oy * tilesize)
					updateundo = true
				elseif (action == "reverse move") then
					local dir = rotate(mapdir)
					
					local drs = rotate(ndirs[dir + 1])
					local ox,oy = drs[1],drs[2]
					
					addundo({"levelupdate",Xoffset,Yoffset,Xoffset + ox * tilesize,Yoffset + oy * tilesize,dir,dir})
					MF_scrollroom(ox * tilesize,oy * tilesize)
					updateundo = true
				elseif (action == "fall") then
					local drop = 20
					local dir = mapdir
					
					addundo({"levelupdate",Xoffset,Yoffset,Xoffset,Yoffset + tilesize * drop,dir,dir})
					MF_scrollroom(0,tilesize * drop)
					updateundo = true
				elseif (action == "vall") then
					local drop = 20
					local dir = rotate(mapdir)
					
					addundo({"levelupdate",Xoffset,Yoffset,Xoffset,Yoffset + tilesize * drop,dir,dir})
					MF_scrollroom(0,tilesize * drop)
					updateundo = true
				end
			end
		end
	end
	
	if (featureindex["done"] ~= nil) then
		for i,v in ipairs(featureindex["done"]) do
			table.insert(donethings, v)
		end
	end
	
	if (#donethings > 0) and (generaldata.values[WINTIMER] == 0) then
		for i,rules in ipairs(donethings) do
			local rule = rules[1]
			local conds = rules[2]
			
			if (#conds == 0) and (generaldata.strings[WORLD] == generaldata.strings[BASEWORLD]) then
				if (rule[1] == "all") and (rule[2] == "is") and (rule[3] == "done") then
					MF_playsound("doneall_c")
					MF_allisdone()
				end
			end
		end
	end
	
	if (generaldata.strings[WORLD] == generaldata.strings[BASEWORLD]) and (generaldata.strings[CURRLEVEL] == "305level") then
		local numfound = false
		
		if (featureindex["image"] ~= nil) then
			for i,v in ipairs(featureindex["image"]) do
				local rule = v[1]
				local conds = v[2]
				
				if (rule[1] == "image") and (rule[2] == "is") and (#conds == 0) then
					local num = rule[3]
					
					local nums = {
						one = {1, "a very early version of the game."},
						two = {2, "mockups made while figuring out the artstyle."},
						three = {3, "early tests for different palettes."},
						four = {4, "a very early version of the map."},
						five = {5, "how the map was supposed to be laid out."},
						six = {6, "first iterations of a non-abstract world map."},
						seven = {7, "trying to figure out the pulling mechanic."},
						eight = {8, "watercolour - title"},
						nine = {9, "watercolour - space"},
						ten = {10, "watercolour - keke"},
						fourteen = {11, "sudden inspiration led to a three-eyed baba."},
						sixteen = {12, "the pushing system was very hard to construct."},
						minusone = {13, "some to-do notes, in finnish!"},
						minustwo = {14, "a mockup of the map."},
						minusthree = {15, "trying to plot out the 'default' objects."},
						minusten = {16, "a flowchart for seeing which levels are 'related'."},
						win = {0, "win"}
					}
					
					if (nums[num] ~= nil) then
						local data = nums[num]
						
						if (data[2] ~= "win") then
							MF_setart(data[1], data[2])
							numfound = true
						else
							local yous = findallfeature(nil,"is","you",true)
							local yous2 = findallfeature(nil,"is","you2",true)
							
							if (#yous2 > 0) then
								for a,b in ipairs(yous2) do
									table.insert(yous, b)
								end
							end
							
							for a,b in ipairs(yous) do
								local unit = mmf.newObject(b)
								local x,y = unit.values[XPOS],unit.values[YPOS]
								
								if (x > roomsizex - 16) then
									local pmult = checkeffecthistory("win")
									
									MF_particles("win",x,y,10 * pmult,2,4,1,1)
									MF_win()
									break
								end
							end
						end
					end
				end
			end
		end
			
		if (numfound == false) then
			MF_setart(0,"")
		end
	end
	
	if unlocked then
		setsoundname("turn",7)
	end
end

function findplayer()
	local playerfound = false
	
	local players = findfeature(nil,"is","you") or findfeature(nil,"is","you2") or findfeature(nil,"is","reverse you")
	
	if (players ~= nil) then
		for i,v in ipairs(players) do
			if (v[1] ~= "level") and (v[1] ~= "empty") then
				local allplayers = findall(v)
				
				if (#allplayers > 0) then
					playerfound = true
				end
			else
				playerfound = true
			end
		end
	end
	
	if playerfound then
		MF_musicstate(0)
		generaldata2.values[NOPLAYER] = 0
	else
		MF_musicstate(1)
		generaldata2.values[NOPLAYER] = 1
	end
end

function findfears(unitid)
	local unit = mmf.newObject(unitid)
	
	local result,resultid = false,4
	
	local ox,oy = 0,0
	local x,y = unit.values[XPOS],unit.values[YPOS]
	
	local name = unit.strings[UNITNAME]
	if (unit.strings[UNITTYPE] == "text") then
		name = "text"
	end
	
	local feartargets = {}
	if (featureindex[name] ~= nil) then
		for i,v in ipairs(featureindex[name]) do
			local rule = v[1]
			local conds = v[2]
			
			if (rule[2] == "fear") then
				if testcond(conds,unitid) then
					table.insert(feartargets, rule[3])
				end
			end
		end
	end
	
	for i=1,4 do
		local ndrs = ndirs[i]
		ox = ndrs[1]
		oy = ndrs[2]
		
		for j,v in ipairs(feartargets) do
			local foundfears = findtype({v, nil},x+ox,y+oy,unitid)
			
			if (#foundfears > 0) then
				result = true
				resultdir = rotate(i-1)
			end
		end
	end
	
	return result,resultdir
end

function resetlevel()
	MF_playsound("restart")
	resetting = true
	while #undobuffer > 1 do
		undo()
	end
	resetting = false
	undobuffer = {}
	newundo()
	doreset = false
	resetcount = resetcount + 1
	resetmoves = resetcount
end