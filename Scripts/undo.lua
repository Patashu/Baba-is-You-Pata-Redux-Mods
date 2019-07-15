function newundo()
	if (updateundo == false) or (doundo == false) then
		table.remove(undobuffer, 1)
	else
		generaldata2.values[UNDOTOOLTIPTIMER] = 0
	end
	
	table.insert(undobuffer, 1, {})
	
	local thisundo = undobuffer[1]
	thisundo.key = last_key
	thisundo.powered = powered
	
	if (thisundo ~= nil) then
		thisundo.wordunits = {}
		
		if (#wordunits > 0) then
			for i,v in ipairs(wordunits) do
				local wunit = mmf.newObject(v[1])
				table.insert(thisundo.wordunits, wunit.values[ID])
			end
		end
	end
	
	updateundo = false
end

function addundo(line)
	if doundo then
		local currentundo = undobuffer[1]
		local text = tostring(#undobuffer) .. ", "
		
		table.insert(currentundo, 1, {})
		currentundo[1] = {}
		
		for i,v in ipairs(line) do
			table.insert(currentundo[1], v)
			text = text .. tostring(v) .. " "
		end
		
		--MF_alert(text)
	end
end

function undoRemove(turn, i, line)
	local uid = line[6]
	local baseuid = line[7] or -1
	local unit = nil
	
	if (paradox[uid] == nil) and (paradox[baseuid] == nil) then
		local x,y,dir,levelfile,levelname,vislevel,complete,visstyle,maplevel,colour,clearcolour,convert,oldid = line[3],line[4],line[5],line[8],line[9],line[10],line[11],line[12],line[13],line[14],line[15],line[16],line[17]
		local name = line[2]
		
		local unitname = ""
		local unitid = 0
		
		--If the unit was converted into 'no undo' byproducts that still exist, don't bring it back.
		local proceed = true;
		if (convert and featureindex["persist"] ~= nil) then
			proceed = not turnedIntoOnlyNoUndoUnits(turn, i, oldid);
		end
		
		if (proceed) then
			unitname = unitreference[name]
			unitid = MF_emptycreate(unitname,x,y)
		
			unit = mmf.newObject(unitid)
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
			
			if (unit.className == "level") then
				MF_setcolourfromstring(unitid,colour)
			end
			
			--If the unit was actually a destroyed 'no undo', oops. Don't actually bring it back. It's dead, Jim.
			addunit(unitid,true)
			addunitmap(unitid,x,y,unit.strings[UNITNAME])
			dynamic(unitid)
			if (not convert and (hasfeature(getname(unit),"is","persist",unitid))) then
				delunit(unitid)
				MF_remove(unitid)
			else
				if (unit.strings[UNITTYPE] == "text") then
					updatecode = 1
				end
				
				local undowordunits = undobuffer[turn].wordunits
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
				return unit
			end
		end
	else
		particles("hot",line[3],line[4],1,{1, 1})
	end
	return nil
end

function undo()
	if (#undobuffer > 1) then
		local currentundo = undobuffer[2]
		
		last_key = currentundo.key or 0
		powered = currentundo.powered or false
		
		if (currentundo ~= nil) then
			for i,line in ipairs(currentundo) do
				local style = line[1]
				
				if (style == "update") then
					local uid = line[9]
					
					if (paradox[uid] == nil) then
						local unitid = getunitid(line[9])
						
						local unit = mmf.newObject(unitid)
						local unitname = getname(unit)
						if not hasfeature(unitname,"is","persist",unitid) then	
							local oldx,oldy = unit.values[XPOS],unit.values[YPOS]
							local x,y,dir = line[3],line[4],line[5]
							unit.values[XPOS] = x
							unit.values[YPOS] = y
							unit.values[DIR] = dir
							unit.values[POSITIONING] = 0
							
							updateunitmap(unitid,oldx,oldy,x,y,unit.strings[UNITNAME])
							dynamic(unitid)
							dynamicat(oldx,oldy)
							
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
							
							if (#undowordunits > 0) then
								for a,b in pairs(undowordunits) do
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
					undoRemove(2, i, line)
				elseif (style == "create") then
					local uid = line[3]
					
					if (paradox[uid] == nil) then
						local unitid = getunitid(line[3])
						
						local unit = mmf.newObject(unitid)
						local x,y = unit.values[XPOS],unit.values[YPOS]
						local unittype = unit.strings[UNITTYPE]
						
						if not hasfeature(getname(unit),"is","persist",unitid) then
							unit = {}
							delunit(unitid)
							MF_remove(unitid)
							dynamicat(x,y)
							
							if (unittype == "text") then
								updatecode = 1
							end
							
							local undowordunits = currentundo.wordunits
							if (#undowordunits > 0) then
								for a,b in ipairs(undowordunits) do
									if (b == line[3]) then
										updatecode = 1
									end
								end
							end
						end
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
				elseif (style == "visibility") then
					local uid = line[3]
					
					if (paradox[uid] == nil) then
						local unitid = getunitid(line[3])
						local unit = mmf.newObject(unitid)
						if (line[4] == 0) then
							unit.visible = true
						elseif (line[4] == 1) then
							unit.visible = false
						end
					end
				elseif (style == "float") then
					local uid = line[3]
					
					if (paradox[uid] == nil) then
						local unitid = getunitid(line[3])
						
						-- Kökkö ratkaisu!
						if (unitid ~= nil) and (unitid ~= 0) then
							local unit = mmf.newObject(unitid)
							unit.values[FLOAT] = tonumber(line[4])
						end
					end
				elseif (style == "levelupdate") then
					MF_setroomoffset(line[2],line[3])
					mapdir = line[6]
				elseif (style == "maprotation") then
					maprotation = line[2]
					MF_levelrotation(maprotation)
				elseif (style == "mapcursor") then
					mapcursor_set(line[3],line[4],line[5],line[10])
				elseif (style == "colour") then
					local unitid = getunitid(line[2])
					MF_setcolour(unitid,line[3],line[4])
					local unit = mmf.newObject(unitid)
					unit.values[A] = line[5]
				elseif (style == "backer_turn") then
					local unitid = line[2]
					local backer_turn = line[3]
					backers_cache[unitid] = backer_turn;
				end
			end
		end
		
		local nextundo = undobuffer[1]
		nextundo.wordunits = {}
		for i,v in ipairs(currentundo.wordunits) do
			table.insert(nextundo.wordunits, v)
		end
		table.remove(undobuffer, 2)
	end
end

function undostate(state)
	if (state ~= nil) then
		doundo = state
	end
end 

function doBack(unit, turn)
	local unitid = unit.fixed
	if (turn <= #undobuffer) and (turn > 0) then
		local currentundo = undobuffer[turn]
		
		if (currentundo ~= nil) then
			--add a dummy action so that undoing happens
			updateundo = true
			for a,line in ipairs(currentundo) do
				local style = line[1]
				if (style == "update") and (line[9] == unit.values[ID]) then
					local uid = line[9]
					
					if (paradox[uid] == nil) then
						local oldx,oldy = unit.values[XPOS],unit.values[YPOS]
						local x,y,dir = line[3],line[4],line[5]
						
						addaction(unitid,{"update",x,y,dir})
					else
						particles("hot",line[3],line[4],1,{1, 1})
						updateundo = true
					end
				elseif (style == "create") and (line[3] == unit.values[ID]) then
					local uid = line[3]
					local created_from_id = line[5]
					local created_id = line[6]
					local backer_turn = backers_cache[unit.fixed]
					if (backer_turn > 0) then
						addundo({"backer_turn", unitid, backer_turn})
					end
					
					if (paradox[uid] == nil) then
						local name = unit.strings[UNITNAME]
						scanAndRecreateOldUnit(turn, a, unit.fixed, created_from_id);
						
						addundo({"remove",unit.strings[UNITNAME],unit.values[XPOS],unit.values[YPOS],unit.values[DIR],unit.values[ID],unit.values[ID],unit.strings[U_LEVELFILE],unit.strings[U_LEVELNAME],unit.values[VISUALLEVEL],unit.values[COMPLETED],unit.values[VISUALSTYLE],unit.flags[MAPLEVEL],unit.strings[COLOUR],unit.strings[CLEARCOLOUR],false,unitid})
						
						delunit(unitid)
						dynamic(unitid)
						MF_specialremove(unitid,2)
					end
				end
			end
		end
	end
end

--If gras becomes roc, then later roc becomes undo, when it disappears we want the gras to come back. This is how we code that - by scanning for the related remove event and undoing that too.
function scanAndRecreateOldUnit(turn, i, unit_id, created_from_id)
	while (true) do
		local v = undobuffer[turn][i]
		if (v == nil) then
			return
		end
		local action = v[1]
		if (action == "remove") then
			local old_creator_id = v[17];
			if old_creator_id == created_from_id then
				--no exponential cloning if gras turned into 2 rocs - abort if there's already a unit with that name on that tile
				local name, x, y = v[2], v[3], v[4];
				local stuff = findobstacle(x, y);
				for _,on in ipairs(stuff) do
					if on > 2 then
						local other = mmf.newObject(on);
						if other ~= nil and getname(other) == name then
							return
						end
					end
				end
				local new_unit = undoRemove(turn, i, v);
				if (new_unit ~= nil) then
					addundo({"create",new_unit.strings[UNITNAME],new_unit.values[ID],new_unit.values[ID],unit_id,new_unit.fixed})
				end
				return
			end
		end
		i = i - 1;
	end
end

--if water becomes roc, and roc is no undo, if we undo then the water shouldn't come back. This is how we code that - by scanning for all related create events. If we find one existing no undo byproduct and no existing non-no undo byproducts, we return false.
function turnedIntoOnlyNoUndoUnits(turn, i, unit_id)
	local found_no_undo = false;
	local found_non_no_undo = false;
	while (true) do
		local v = undobuffer[turn][i]
		if (v == nil) then
			break
		end
		local action = v[1];
		local created_from_id = v[5]
		local created_id = v[6]
		if (action == "create") and created_from_id == unit_id then
			local still_exists = mmf.newObject(created_id)
			if (still_exists ~= nil) then
				local name = getname(still_exists)
				if (hasfeature(name,"is","persist",created_id)) then
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