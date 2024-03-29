function newundo()
	--MF_alert("Newundo: " .. tostring(updateundo) .. ", " .. tostring(doundo))
	
	if (updateundo == false) or (doundo == false) then
		table.remove(undobuffer, 1)
	else
		generaldata2.values[UNDOTOOLTIPTIMER] = 0
	end
	
	table.insert(undobuffer, 1, {})
	
	local thisundo = undobuffer[1]
	thisundo.key = last_key
	thisundo.fixedseed = Fixedseed
	
	--MF_alert("Stored " .. tostring(Fixedseed))
	
	if (thisundo ~= nil) then
		thisundo.wordunits = {}
		thisundo.wordrelatedunits = {}
		thisundo.visiontargets = {}
		
		if (#wordunits > 0) then
			for i,v in ipairs(wordunits) do
				local wunit = mmf.newObject(v[1])
				table.insert(thisundo.wordunits, wunit.values[ID])
			end
		end
		
		if (#visiontargets > 0) then
			for i,v in ipairs(visiontargets) do
				local wunit = mmf.newObject(v)
				table.insert(thisundo.visiontargets, wunit.values[ID])
			end
		end
		
		if (#wordrelatedunits > 0) then
			for i,v in ipairs(wordrelatedunits) do
				if (v[1] ~= 2) then
					local wunit = mmf.newObject(v[1])
					table.insert(thisundo.wordrelatedunits, wunit.values[ID])
				else
					--table.insert(thisundo.wordrelatedunits, wunit.values[ID])
				end
			end
		end
	end
	
	updateundo = false
end

function addundo(line,uid_)
	local uid = tostring(uid_)
	if doundo then
		local currentundo = undobuffer[1]
		local text = tostring(#undobuffer) .. ", "
		
		table.insert(currentundo, 1, {})
		currentundo[1] = {}
		
		for i,v in ipairs(line) do
			table.insert(currentundo[1], v)
			text = text .. tostring(v) .. ", "
		end
		
		text = text .. uid
		
		local ename = line[1]
		
		if generaldata.flags[LOGGING] and logevents then
			local details = ""
			
			if (ename == "update") then
				details = line[2] .. ":" .. tostring(line[6]) .. ":" .. tostring(line[7]) .. ":" .. tostring(line[8])
			elseif (ename == "remove") then
				details = line[2] .. ":" .. tostring(line[3]) .. ":" .. tostring(line[4]) .. ":" .. tostring(line[5])
			elseif (ename == "create") then
				details = line[2] .. ":" .. tostring(line[6]) .. ":" .. tostring(line[7]) .. ":" .. tostring(line[8])
			elseif (ename == "float") then
				details = line[2] .. ":" .. tostring(line[4]) .. ":" .. tostring(line[5])
			elseif (ename == "levelupdate") then
				details = tostring(line[4]) .. ":" .. tostring(line[5])
			elseif (ename == "maprotation") then
				details = tostring(line[3]) .. ":" .. tostring(line[4])
			elseif (ename == "mapcursor") then
				details = tostring(line[8]) .. ":" .. tostring(line[9]) .. ":" .. tostring(line[10])
			elseif (ename == "broken") then
				details = tostring(line[4]) .. ":" .. tostring(line[2])
			elseif (ename == "followed") then
				details = tostring(line[5]) .. ":" .. tostring(line[3])
			end
			
			dolog(ename,"change",details)
		end
		
		--MF_alert(text)
	end
end

function undo()
	local result = 0
	HACK_INFINITY = 0
	logevents = false
	if ((not resetting) and (hasfeature("level","is","noundo",1) ~= nil)) then
		return result
	end
	
	if (#undobuffer > 1) then
		result = 1
		local currentundo = undobuffer[2]
		
		-- MF_alert("Undoing: " .. tostring(#undobuffer))
		
		do_mod_hook("undoed")
		
		last_key = currentundo.key or 0
		Fixedseed = currentundo.fixedseed or 100
		
		if (currentundo ~= nil) then
			for i,line in ipairs(currentundo) do
				local style = line[1]
				
				if (style == "update") then
					local uid = line[9]
					
					if (paradox[uid] == nil) then
						local unitid = getunitid(line[9])
						
						local unit = mmf.newObject(unitid) --paradox-proofing
						local unitname = nil
						if (unit ~= nil) then
							local unitname = getname(unit)
						end
						if unit ~= nil and not unit_ignores_undos(unitid) then
							local oldx,oldy = unit.values[XPOS],unit.values[YPOS]
							local x,y,dir = line[3],line[4],line[5]
							unit.values[XPOS] = x
							unit.values[YPOS] = y
							unit.values[DIR] = dir
							unit.values[POSITIONING] = 0
							
							updateunitmap(unitid,oldx,oldy,x,y,unit.strings[UNITNAME])
							dynamic(unitid)
							dynamicat(oldx,oldy)
							
							if (spritedata.values[CAMTARGET] == uid) then
								MF_updatevision(dir)
							end
							
							local ox = math.abs(oldx-x)
							local oy = math.abs(oldy-y)
							
							if (ox + oy == 1) and (unit.values[TILING] == 2) then
								unit.values[VISUALDIR] = ((unit.values[VISUALDIR] - 1)+4) % 4
								unit.direction = unit.values[DIR] * 8 + unit.values[VISUALDIR]
							end
							
							if (unit.strings[UNITTYPE] == "text") then
								updatecode = 1
							end
							
							local undowordunits = currentundo.wordunits
							local undowordrelatedunits = currentundo.wordrelatedunits
							
							if (#undowordunits > 0) then
								for a,b in pairs(undowordunits) do
									if (b == line[9]) then
										updatecode = 1
									end
								end
							end
							
							if (#undowordrelatedunits > 0) then
								for a,b in pairs(undowordrelatedunits) do
									if (b == line[9]) then
										updatecode = 1
									end
								end
							end
						end
					else
						particles("hot",line[3],line[4],1,{1, 1})
					end
				elseif (style == "remove") then
					local uid = line[6]
					local baseuid = line[7] or -1
					
					if (paradox[uid] == nil) and (paradox[baseuid] == nil) then
						local x,y,dir,levelfile,levelname,vislevel,complete,visstyle,maplevel,colour,clearcolour,followed,back_init,ogname,signtext,convert,oldid = line[3],line[4],line[5],line[8],line[9],line[10],line[11],line[12],line[13],line[14],line[15],line[16],line[17],line[18],line[19],line[20],line[21]
						local name = line[2]
						
						local unitname = ""
						local unitid = 0

						--If the unit was converted into 'no undo' byproducts that still exist, don't bring it back.
						local proceed = true;
						if (convert and (featureindex["noundo"] ~= nil or featureindex["noreset"] ~= nil)) then
							proceed = not turnedIntoOnlyNoUndoUnits(i, oldid);
						end

						if (proceed) then
							--MF_alert("Trying to create " .. name .. ", " .. tostring(unitreference[name]))
							unitname = unitreference[name]
							unitid = MF_emptycreate(unitname,x,y)
							
							local unit = mmf.newObject(unitid)
							unit.values[ONLINE] = 1
							unit.values[XPOS] = x
							unit.values[YPOS] = y
							unit.values[DIR] = dir
							unit.values[ID] = line[6]
							unit.flags[9] = true
							
							unit.strings[U_LEVELFILE] = levelfile
							unit.strings[U_LEVELNAME] = levelname
							unit.flags[MAPLEVEL] = maplevel
							unit.values[VISUALLEVEL] = vislevel
							unit.values[VISUALSTYLE] = visstyle
							unit.values[COMPLETED] = complete
							
							unit.strings[COLOUR] = colour
							unit.strings[CLEARCOLOUR] = clearcolour
							unit.strings[UNITSIGNTEXT] = signtext or ""
							
							if (unit.className == "level") then
								MF_setcolourfromstring(unitid,colour)
							end
							
							addunit(unitid,true)
							addunitmap(unitid,x,y,unit.strings[UNITNAME])
							dynamic(unitid)
							
							unit.followed = followed
							unit.back_init = back_init
							unit.originalname = ogname
							
							if (unit.strings[UNITTYPE] == "text") then
								updatecode = 1
							end
							
							if (spritedata.values[VISION] == 1) then
								unit.x = -24
								unit.y = -24
							end
							
							local undowordunits = currentundo.wordunits
							local undowordrelatedunits = currentundo.wordrelatedunits
							
							if (#undowordunits > 0) then
								for a,b in ipairs(undowordunits) do
									if (b == line[6]) then
										updatecode = 1
									end
								end
							end
							
							if (#undowordrelatedunits > 0) then
								for a,b in ipairs(undowordrelatedunits) do
									if (b == line[6]) then
										updatecode = 1
									end
								end
							end

							--If the unit was actually a destroyed 'PERSIST', oops. Don't actually bring it back. It's dead, Jim.
							if (not convert and unit_ignores_undos(unitid)) then
								unit = {}
								delunit(unitid)
								MF_remove(unitid)
								dynamicat(x,y)
							end
						end
					else
						particles("hot",line[3],line[4],1,{1, 1})
					end
				elseif (style == "create") then
					local uid = line[3]
					local baseid = line[4]
					local source = line[5]
					
					if (paradox[uid] == nil) then
						local unitid = getunitid(line[3])
						
						local unit = mmf.newObject(unitid)
						--paradox-proofing
						local unitname = nil
						local x,y = nil,nil
						local unittype = nil
						if (unit ~= nil) then
							unitname = unit.strings[UNITNAME]
							x,y = unit.values[XPOS],unit.values[YPOS]
							unittype = unit.strings[UNITTYPE]
						end
						
						if (unit ~= nil) and (not unit_ignores_undos(unitid)) then
							unit = {}
							delunit(unitid)
							MF_remove(unitid)
							dynamicat(x,y)
							
							if (unittype == "text") then
								updatecode = 1
							end
							
							local undowordunits = currentundo.wordunits
							local undowordrelatedunits = currentundo.wordrelatedunits
							
							if (#undowordunits > 0) then
								for a,b in ipairs(undowordunits) do
									if (b == line[3]) then
										updatecode = 1
									end
								end
							end
							
							if (#undowordrelatedunits > 0) then
								for a,b in ipairs(undowordrelatedunits) do
									if (b == line[3]) then
										updatecode = 1
									end
								end
							end
						end
					end
				elseif (style == "backset") then
					local uid = line[3]
					
					if (paradox[uid] == nil) then
						local unitid = getunitid(line[3])
						local unit = mmf.newObject(unitid)
						
						unit.back_init = line[4]
					end
				elseif (style == "done") then
					local unitid = line[7]
					--print(unitid)
					local unit = mmf.newObject(unitid)
					
					unit.values[FLOAT] = line[8]
					unit.angle = 0
					unit.values[POSITIONING] = 0
					unit.values[A] = 0
					unit.values[VISUALLEVEL] = 0
					unit.flags[DEAD] = false
					
					--print(unit.className .. ", " .. tostring(unitid) .. ", " .. tostring(line[3]) .. ", " .. unit.strings[UNITNAME])
					
					addunit(unitid,true)
					
					if (unit.values[TILING] == 1) then
						dynamic(unitid)
					end
				elseif (style == "float") then
					local uid = line[3]
					
					if (paradox[uid] == nil) then
						local unitid = getunitid(line[3])
						
						-- K�kk� ratkaisu!
						if (unitid ~= nil) and (unitid ~= 0) then
							local unit = mmf.newObject(unitid)
							if (unit ~= nil) then --paradox-proofing
								unit.values[FLOAT] = tonumber(line[4])
							end
						end
					end
				elseif (style == "levelupdate") then
					MF_setroomoffset(line[2],line[3])
					mapdir = line[6]
				elseif (style == "maprotation") then
					maprotation = line[2]
					MF_levelrotation(maprotation)
				elseif (style == "mapdir") then
					mapdir = line[2]
				elseif (style == "mapcursor") then
					mapcursor_set(line[3],line[4],line[5],line[10])
					
					local undowordunits = currentundo.wordunits
					local undowordrelatedunits = currentundo.wordrelatedunits
					
					local unitid = getunitid(line[10])
					if (unitid ~= nil) and (unitid ~= 0) then
						local unit = mmf.newObject(unitid)
						
						if (unit.strings[UNITTYPE] == "text") then
							updatecode = 1
						end
					end
					
					if (#undowordunits > 0) then
						for a,b in pairs(undowordunits) do
							if (b == line[10]) then
								updatecode = 1
							end
						end
					end
					
					if (#undowordrelatedunits > 0) then
						for a,b in pairs(undowordrelatedunits) do
							if (b == line[10]) then
								updatecode = 1
							end
						end
					end
				elseif (style == "colour") then
					local unitid = getunitid(line[2])
					MF_setcolour(unitid,line[3],line[4])
					local unit = mmf.newObject(unitid)
					if (unit ~= nil) then --paradox-proofing
						unit.values[A] = line[5]
					end
				elseif (style == "broken") then
					local unitid = getunitid(line[3])
					local unit = mmf.newObject(unitid)
					if (unit ~= nil) then --paradox-proofing
					--MF_alert(unit.strings[UNITNAME])
						unit.broken = 1 - line[2]
					end
				elseif (style == "bonus") then
					local style = 1 - line[2]
					MF_bonus(style)
				elseif (style == "followed") then
					local unitid = getunitid(line[2])
					local unit = mmf.newObject(unitid)
					if (unit ~= nil) then --paradox-proofing
						unit.followed = line[3]
					end
				elseif (style == "startvision") then
					local target = line[2]
					
					if (line[2] ~= 0) and (line[2] ~= 0.5) then
						target = getunitid(line[2])
					end
					
					visionmode(0,target,true)
				elseif (style == "stopvision") then
					local target = line[2]
					
					if (line[2] ~= 0) and (line[2] ~= 0.5) then
						target = getunitid(line[2])
					end
					
					visionmode(1,target,true,{line[3],line[4],line[5]})
				elseif (style == "visiontarget") then
					local unitid = getunitid(line[2])
					
					if (spritedata.values[VISION] == 1) and (unitid ~= 0) then
						local unit = mmf.newObject(unitid)
						if (unit ~= nil) then --paradox-proofing
							MF_updatevision(unit.values[DIR])
							MF_updatevisionpos(unit.values[XPOS],unit.values[YPOS])
							spritedata.values[CAMTARGET] = line[2]
						end
					end
				elseif (style == "holder") then
					local unitid = getunitid(line[2])
					local unit = mmf.newObject(unitid)
					if (unit ~= nil) then --paradox-proofing
						unit.holder = line[3]
					end
				end
			end
		end
		
		local nextundo = undobuffer[1]
		nextundo.wordunits = {}
		nextundo.wordrelatedunits = {}
		nextundo.visiontargets = {}
		nextundo.fixedseed = Fixedseed
		
		for i,v in ipairs(currentundo.wordunits) do
			table.insert(nextundo.wordunits, v)
		end
		for i,v in ipairs(currentundo.wordrelatedunits) do
			table.insert(nextundo.wordrelatedunits, v)
		end
		
		if (#currentundo.visiontargets > 0) then
			visiontargets = {}
			for i,v in ipairs(currentundo.visiontargets) do
				table.insert(nextundo.visiontargets, v)
				
				local fix = MF_getfixed(v)
				if (fix ~= nil) then
					table.insert(visiontargets, fix)
				end
			end
		end
		
		table.remove(undobuffer, 2)
	end
	
	--MF_alert("Current fixed seed: " .. tostring(Fixedseed))
	
	do_mod_hook("undoed_after")
	logevents = true
	
	return result
end

function undostate(state)
	if (state ~= nil) then
		doundo = state
	end
end 

--If gras becomes roc, then later roc becomes undo, when it disappears we want the gras to come back. This is how we code that - by scanning for the related remove event and undoing that too.
--[[function scanAndRecreateOldUnit(i, unit_id, created_from_id, ignore_no_undo)
	while (true) do
		local v = undobuffer[2][i]
		if (v == nil) then
			return
		end
		local action = v[1]
		--TODO: implement for MOUS
		if (action == "remove") then
			local old_creator_id = v[7];
			if v[7] == created_from_id then
				--no exponential cloning if gras turned into 2 rocs - abort if there's already a unit with that name on that tile
				local tile, x, y = v[2], v[3], v[4];
				local data = tiles_list[tile];
				local stuff = getUnitsOnTile(x, y, nil, true);
				for _,on in ipairs(stuff) do
					if on.name == data.name then
						return
					end
				end
				local _, new_unit = undoOneAction(turn, i, v, ignore_no_undo);
				if (new_unit ~= nil) then
					addUndo({"create", new_unit.id, true, created_from_id = unit_id})
				end
				return
			end
		end
		i = i - 1;
	end
end]]

--if water becomes roc, and roc is no undo, if we undo then the water shouldn't come back. This is how we code that - by scanning for all related create events. If we find one existing no undo byproduct and no existing non-no undo byproducts, we return false.
function turnedIntoOnlyNoUndoUnits(i, unit_id)
	local found_no_undo = false;
	local found_non_no_undo = false;
	while (true) do
		local v = undobuffer[2][i]
		if (v == nil) then
			break
		end
		local action = v[1];
		local created_from_id = v[9]
		local created_id = v[10]
		if (action == "create") and created_from_id == unit_id then
			local still_exists = mmf.newObject(created_id)
			if (still_exists ~= nil) then
				if unit_ignores_undos(created_id) then
					found_no_undo = true;
				else
					found_non_no_undo = true;
					break;
				end
			end
		end
		i = i + 1;
	end
	return not (found_non_no_undo or not found_no_undo);
end

function unit_ignores_undos(unitid)
	local still_exists = mmf.newObject(unitid)
	if (still_exists ~= nil) then
		local name = getname(still_exists)
		if resetting then
			return hasfeature(name,"is","noreset",unitid)
		else
			return hasfeature(name,"is","noundo",unitid)
		end
	end
end