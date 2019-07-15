moving_units = {}

function movecommand(ox,oy,dir_,playerid_)
	statusblock()
	movelist = {}
	
	local take = 0
	local takecount = 3
	local finaltake = false
	
	slipped = {}
	
	local still_moving = {}
	
	local levelpush = -1
	local levelpull = -1
	local levelmove = findfeature("level","is","you")
	if (levelmove ~= nil) then
		local valid = false
		
		for i,v in ipairs(levelmove) do
			if (valid == false) and testcond(v[2],1) then
				valid = true
			end
		end
		
		if valid then
			local ndrs = ndirs[dir_ + 1]
			local ox,oy = ndrs[1],ndrs[2]
			
			addundo({"levelupdate",Xoffset,Yoffset,Xoffset + ox * tilesize,Yoffset + oy * tilesize,mapdir,dir_})
			MF_scrollroom(ox * tilesize,oy * tilesize)
			mapdir = dir_
			updateundo = true
		end
	end
	
	local levelrevmove = findfeature("level","is","reverse you")
	if (levelrevmove ~= nil) then
		local valid = false
		
		for i,v in ipairs(levelrevmove) do
			if (valid == false) and testcond(v[2],1) then
				valid = true
			end
		end
		
		if valid then
			local ndrs = ndirs[rotate(dir_) + 1]
			local ox,oy = ndrs[1],ndrs[2]
			
			addundo({"levelupdate",Xoffset,Yoffset,Xoffset + ox * tilesize,Yoffset + oy * tilesize,mapdir,dir_})
			MF_scrollroom(ox * tilesize,oy * tilesize)
			mapdir = dir_
			updateundo = true
		end
	end
	
	while (take <= takecount) or finaltake do
		moving_units = {}
		local been_seen = {}
		
		if (finaltake == false) then
			if (take == 0) then
				local slipperys = findallfeature(nil,"is","slip",true)
				
				for i,v in ipairs(slipperys) do
					if (v ~= 2) then
						local unit = mmf.newObject(v)
						
						local x,y = unit.values[XPOS],unit.values[YPOS]
						local tileid = x + y * roomsizex
						
						if (unitmap[tileid] ~= nil) then
							if (#unitmap[tileid] > 1) then
								for a,b in ipairs(unitmap[tileid]) do
									if (b ~= v) and floating(b,v) then
										local newunit = mmf.newObject(b)
										local unitname = getname(newunit)

										if (been_seen[b] == nil) then
											table.insert(moving_units, {unitid = b, reason = "slip", state = 0, moves = 1, dir = unit.values[DIR], xpos = x, ypos = y})
											been_seen[b] = #moving_units
										else
											local id = been_seen[b]
											local this = moving_units[id]
											this.moves = this.moves + 1
										end
									end
								end
							end
						end
					end
				end
				
				local revslipperys = findallfeature(nil,"is","reverse slip",true)
				
				for i,v in ipairs(revslipperys) do
					if (v ~= 2) then
						local unit = mmf.newObject(v)
						
						local x,y = unit.values[XPOS],unit.values[YPOS]
						local tileid = x + y * roomsizex
						
						if (unitmap[tileid] ~= nil) then
							if (#unitmap[tileid] > 1) then
								for a,b in ipairs(unitmap[tileid]) do
									if (b ~= v) and floating(b,v) then
										local newunit = mmf.newObject(b)
										local unitname = getname(newunit)

										if (been_seen[b] == nil) then
											table.insert(moving_units, {unitid = b, reason = "slip", state = 0, moves = 1, dir = rotate(unit.values[DIR]), xpos = x, ypos = y})
											been_seen[b] = #moving_units
										else
											local id = been_seen[b]
											local this = moving_units[id]
											this.moves = this.moves + 1
										end
									end
								end
							end
						end
					end
				end
			end
		
			if (dir_ ~= 4) and (take == 1) then
				local players = {}
				local empty = {}
				local playerid = 1
				
				if (playerid_ ~= nil) then
					playerid = playerid_
				end
				
				if (playerid == 1) then
					players,empty = findallfeature(nil,"is","you")
					revplayers,revempty = findallfeature(nil,"is","reverse you")
				elseif (playerid == 2) then
					players,empty = findallfeature(nil,"is","you2")
					
					if (#players == 0) then
						players,empty = findallfeature(nil,"is","you")
						revplayers,revempty = findallfeature(nil,"is","reverse you")
					end
				end
				
				for i,v in ipairs(players) do
					local sleeping = false
					
					if (slipped[v] ~= nil) then
						sleeping = true
					elseif (v ~= 2) then
						local unit = mmf.newObject(v)
						
						local unitname = getname(unit)
						local sleep = hasfeature(unitname,"is","sleep",v)
						
						if (sleep ~= nil) then
							sleeping = true
						else
							updatedir(v, dir_)
						end
					else
						local thisempty = empty[i]
						
						for a,b in pairs(thisempty) do
							local x = a % roomsizex
							local y = math.floor(a / roomsizex)
							
							local sleep = hasfeature("empty","is","sleep",2,x,y)
							
							if (sleep ~= nil) then
								thisempty[a] = nil
							end
						end
					end
					
					if (sleeping == false) then
						if (been_seen[v] == nil) then
							local x,y = -1,-1
							if (v ~= 2) then
								local unit = mmf.newObject(v)
								x,y = unit.values[XPOS],unit.values[YPOS]
								
								table.insert(moving_units, {unitid = v, reason = "you", state = 0, moves = 1, dir = dir_, xpos = x, ypos = y})
								been_seen[v] = #moving_units
							else
								local thisempty = empty[i]
								
								for a,b in pairs(thisempty) do
									x = a % roomsizex
									y = math.floor(a / roomsizex)
								
									table.insert(moving_units, {unitid = 2, reason = "you", state = 0, moves = 1, dir = dir_, xpos = x, ypos = y})
									been_seen[v] = #moving_units
								end
							end
						else
							local id = been_seen[v]
							local this = moving_units[id]
							--this.moves = this.moves + 1
						end
					end
				end
				
				for i,v in ipairs(revplayers) do
					local sleeping = false
					
					if (v ~= 2) then
						local unit = mmf.newObject(v)
						
						local unitname = getname(unit)
						local sleep = hasfeature(unitname,"is","sleep",v)
						
						if (sleep ~= nil) then
							sleeping = true
						else
							updatedir(v, rotate(dir_))
						end
					else
						local thisempty = revempty[i]
						
						for a,b in pairs(thisempty) do
							local x = a % roomsizex
							local y = math.floor(a / roomsizex)
							
							local sleep = hasfeature("empty","is","sleep",2,x,y)
							
							if (sleep ~= nil) then
								thisempty[a] = nil
							end
						end
					end
					
					if (sleeping == false) then
						if (been_seen[v] == nil) then
							local x,y = -1,-1
							if (v ~= 2) then
								local unit = mmf.newObject(v)
								x,y = unit.values[XPOS],unit.values[YPOS]
								
								table.insert(moving_units, {unitid = v, reason = "you", state = 0, moves = 1, dir = rotate(dir_), xpos = x, ypos = y})
								been_seen[v] = #moving_units
							else
								local thisempty = revempty[i]
								
								for a,b in pairs(thisempty) do
									x = a % roomsizex
									y = math.floor(a / roomsizex)
								
									table.insert(moving_units, {unitid = 2, reason = "you", state = 0, moves = 1, dir = rotate(dir_), xpos = x, ypos = y})
									been_seen[v] = #moving_units
								end
							end
						else
							local id = been_seen[v]
							local this = moving_units[id]
							--this.moves = this.moves + 1
						end
					end
				end
			end
			
			if (take == 2) then
				local movers,mempty = findallfeature(nil,"is","move")
				moving_units,been_seen = add_moving_units("move",movers,moving_units,been_seen,mempty)
				
				local revmovers,revmempty = findallfeature(nil,"is","reverse move")
				moving_units,been_seen = add_moving_units("reverse move",revmovers,moving_units,been_seen,revmempty)
				
				local chillers,cempty = findallfeature(nil,"is","chill")
				moving_units,been_seen = add_moving_units("chill",chillers,moving_units,been_seen,cempty)
				
				local fears,empty = findallfeature(nil,"fear",nil)
				
				for i,v in ipairs(fears) do
					local valid,feardir = findfears(v)
					local sleeping = false
					
					if valid then
						if (v ~= 2) then
							local unit = mmf.newObject(v)
						
							local unitname = getname(unit)
							local sleep = hasfeature(unitname,"is","sleep",v)
							
							if (sleep ~= nil) then
								sleeping = true
							else
								updatedir(v, feardir)
							end
						else
							local thisempty = empty[i]
							
							for a,b in pairs(thisempty) do
								local x = a % roomsizex
								local y = math.floor(a / roomsizex)
								
								local sleep = hasfeature("empty","is","sleep",2,x,y)
								
								if (sleep ~= nil) then
									thisempty[a] = nil
								end
							end
						end
						
						if (sleeping == false) then
							if (been_seen[v] == nil) then
								local x,y = -1,-1
								if (v ~= 2) then
									local unit = mmf.newObject(v)
									x,y = unit.values[XPOS],unit.values[YPOS]
									
									table.insert(moving_units, {unitid = v, reason = "you", state = 0, moves = 1, dir = feardir, xpos = x, ypos = y})
									been_seen[v] = #moving_units
								else
									local thisempty = empty[i]
								
									for a,b in pairs(thisempty) do
										x = a % roomsizex
										y = math.floor(a / roomsizex)
									
										table.insert(moving_units, {unitid = 2, reason = "you", state = 0, moves = 1, dir = feardir, xpos = x, ypos = y})
										been_seen[v] = #moving_units
									end
								end
							else
								local id = been_seen[v]
								local this = moving_units[id]
								this.moves = this.moves + 1
							end
						end
					end
				end
			elseif (take == 3) then
				local shifts = findallfeature(nil,"is","shift",true)
				local revshifts = findallfeature(nil,"is","reverse shift",true)
				
				for i,v in ipairs(shifts) do
					if (v ~= 2) then
						local affected = {}
						local unit = mmf.newObject(v)
						
						local x,y = unit.values[XPOS],unit.values[YPOS]
						local tileid = x + y * roomsizex
						
						if (unitmap[tileid] ~= nil) then
							if (#unitmap[tileid] > 1) then
								for a,b in ipairs(unitmap[tileid]) do
									if (b ~= v) and floating(b,v) then
										local newunit = mmf.newObject(b)
										
										updatedir(b, unit.values[DIR])
										--newunit.values[DIR] = unit.values[DIR]
										
										if (been_seen[b] == nil) then
											table.insert(moving_units, {unitid = b, reason = "shift", state = 0, moves = 1, dir = unit.values[DIR], xpos = x, ypos = y})
											been_seen[b] = #moving_units
										else
											local id = been_seen[b]
											local this = moving_units[id]
											this.moves = this.moves + 1
										end
									end
								end
							end
						end
					end
				end
				
				for i,v in ipairs(revshifts) do
					if (v ~= 2) then
						local affected = {}
						local unit = mmf.newObject(v)
						
						local x,y = unit.values[XPOS],unit.values[YPOS]
						local tileid = x + y * roomsizex
						
						if (unitmap[tileid] ~= nil) then
							if (#unitmap[tileid] > 1) then
								for a,b in ipairs(unitmap[tileid]) do
									if (b ~= v) and floating(b,v) then
										local newunit = mmf.newObject(b)
										
										updatedir(b, rotate(unit.values[DIR]))
										--newunit.values[DIR] = unit.values[DIR]
										
										if (been_seen[b] == nil) then
											table.insert(moving_units, {unitid = b, reason = "shift", state = 0, moves = 1, dir = rotate(unit.values[DIR]), xpos = x, ypos = y})
											been_seen[b] = #moving_units
										else
											local id = been_seen[b]
											local this = moving_units[id]
											this.moves = this.moves + 1
										end
									end
								end
							end
						end
					end
				end
				
				local levelshift = findfeature("level","is","shift")
				local levelrevshift = findfeature("level","is","reverse shift")
				
				if (levelshift ~= nil) then
					local leveldir = mapdir
						
					for a,unit in ipairs(units) do
						local x,y = unit.values[XPOS],unit.values[YPOS]
						
						if floating_level(unit.fixed) then
							updatedir(unit.fixed, leveldir)
							table.insert(moving_units, {unitid = unit.fixed, reason = "shift", state = 0, moves = 1, dir = unit.values[DIR], xpos = x, ypos = y})
						end
					end
				end
				
				if (levelrevshift ~= nil) then
					local leveldir = rotate(mapdir)
						
					for a,unit in ipairs(units) do
						local x,y = unit.values[XPOS],unit.values[YPOS]
						
						if floating_level(unit.fixed) then
							updatedir(unit.fixed, leveldir)
							table.insert(moving_units, {unitid = unit.fixed, reason = "shift", state = 0, moves = 1, dir = rotate(unit.values[DIR]), xpos = x, ypos = y})
						end
					end
				end
			end
		else
			for i,data in ipairs(still_moving) do
				if (data.unitid ~= 2) then
					local unit = mmf.newObject(data.unitid)
					
					table.insert(moving_units, {unitid = data.unitid, reason = data.reason, state = data.state, moves = data.moves, dir = unit.values[DIR], xpos = unit.values[XPOS], ypos = unit.values[YPOS]})
				else
					table.insert(moving_units, {unitid = data.unitid, reason = data.reason, state = data.state, moves = data.moves, dir = data.dir, xpos = -1, ypos = -1})
				end
			end
			
			still_moving = {}
		end
		
		local unitcount = #moving_units
			
		for i,data in ipairs(moving_units) do
			if (i <= unitcount) then
				if (data.unitid == 2) and (data.xpos == -1) and (data.ypos == -1) then
					local positions = getemptytiles()
					
					for a,b in ipairs(positions) do
						local x,y = b[1],b[2]
						table.insert(moving_units, {unitid = 2, reason = data.reason, state = data.state, moves = data.moves, dir = data.dir, xpos = x, ypos = y})
					end
				end
			else
				break
			end
		end
		
		local done = false
		local state = 0
		
		while (done == false) do
			local smallest_state = 99
			local delete_moving_units = {}
			
			for i,data in ipairs(moving_units) do
				local solved = false
				smallest_state = math.min(smallest_state,data.state)
				
				if (data.unitid == 0) then
					solved = true
				end
				
				if (data.state == state) and (data.moves > 0) and (data.unitid ~= 0) then
					local unit = {}
					local dir,name = 4,""
					local x,y = data.xpos,data.ypos
					
					if (data.unitid ~= 2) then
						unit = mmf.newObject(data.unitid)
						dir = unit.values[DIR]
						name = getname(unit)
						x,y = unit.values[XPOS],unit.values[YPOS]
					else
						dir = data.dir
						name = "empty"
					end
					
					if (x ~= -1) and (y ~= -1) then
						local result = -1
						solved = false
						
						if (state == 0) then
							if (data.reason == "chill") then
								dir = math.random(0,3)
								
								if (data.unitid ~= 2) then
									updatedir(data.unitid, dir)
									--unit.values[DIR] = dir
								end
							end
							
							if (data.reason == "move") and (data.unitid == 2) then
								dir = math.random(0,3)
							end
						elseif (state == 3) then
							if ((data.reason == "move") or (data.reason == "chill") or (data.reason == "reverse move")) then
								if (not hasfeature(name,"is","stubborn",data.unitid,x,y)) then
									dir = rotate(dir)
									
									if (data.unitid ~= 2) then
										updatedir(data.unitid, dir)
										--unit.values[DIR] = dir
									end
								end
							end
						end
						
						local revmove = hasfeature(name,"is","reverse move",data.unitid,x,y)
						
						if (revmove ~= nil) then
							dir = rotate(dir)
						end
						
						local ndrs = ndirs[dir + 1]
						local ox,oy = ndrs[1],ndrs[2]
						if (activemod.very_drunk or (data.reason ~= "shift" and data.reason ~= "reverse shift" and data.reason ~= "yeet")) then
							dir, ox, oy = apply_moonwalk(data.unitid,x,y,dir,ox,oy,false)
						end
						
						local pushobslist = {}
						
						local obslist,allobs,specials = check(data.unitid,x,y,dir,false,data.reason)
						local pullobs,pullallobs,pullspecials = check(data.unitid,x,y,dir,true,data.reason)
						
						local swap = hasfeature(name,"is","swap",data.unitid,x,y)
						
						for c,obs in pairs(obslist) do
							if (solved == false) then
								if (obs == 0) then
									if (state == 0) then
										result = math.max(result, 0)
									else
										result = math.max(result, 0)
									end
								elseif (obs == -1) then
									result = math.max(result, 2)
									
									local levelpush_ = findfeature("level","is","push")
									
									if (levelpush_ ~= nil) then
										for e,f in ipairs(levelpush_) do
											if testcond(f[2],1) then
												levelpush = dir
											end
										end
									end
								else
									if (swap == nil) then
										if (#allobs == 0) then
											obs = 0
										end
										
										if (obs == 1) then
											local thisobs = allobs[c]
											local solid = true
											
											for f,g in pairs(specials) do
												if (g[1] == thisobs) and (g[2] == "weak") then
													solid = false
													obs = 0
													result = math.max(result, 0)
												end
											end
											
											if solid then
												if (state < 2) then
													data.state = math.max(data.state, 2)
													result = math.max(result, 2)
												else
													result = math.max(result, 2)
												end
											end
										else
											if (state < 1) then
												data.state = math.max(data.state, 1)
												result = math.max(result, 1)
											else
												table.insert(pushobslist, obs)
												result = math.max(result, 1)
											end
										end
									else
										result = math.max(result, 0)
									end
								end
							end
						end
						
						local result_check = false
						
						while (result_check == false) and (solved == false) do
							if (result == 0) then
								if (state > 0) then
									for j,jdata in pairs(moving_units) do
										if (jdata.state >= 2) then
											jdata.state = 0
										end
									end
								end
								
								queue_move(data.unitid,ox,oy,dir,specials, data.reason)
								--move(data.unitid,ox,oy,dir,specials)
								
								local swapped = {}
								
								if (swap ~= nil) then
									for a,b in ipairs(allobs) do
										if (b ~= -1) and (b ~= 2) and (b ~= 0) then
											addaction(b,{"update",x,y,nil})
											swapped[b] = 1
										end
									end
								end
								
								local swaps = findfeatureat(nil,"is","swap",x+ox,y+oy)
								if (swaps ~= nil) then
									for a,b in ipairs(swaps) do
										if (swapped[b] == nil) then
											addaction(b,{"update",x,y,nil})
										end
									end
								end
								
								local finalpullobs = {}
								
								for c,pobs in ipairs(pullobs) do
									if (pobs < -1) or (pobs > 1) then
										local paobs = pullallobs[c]
										
										local hm = trypush(paobs,ox,oy,dir,true,x,y,data.reason,data.unitid)
										if (hm == 0) then
											table.insert(finalpullobs, paobs)
										end
									elseif (pobs == -1) then
										local levelpull_ = findfeature("level","is","pull")
									
										if (levelpull_ ~= nil) then
											for e,f in ipairs(levelpull_) do
												if testcond(f[2],1) then
													levelpull = dir
												end
											end
										end
									end
								end
								
								for c,pobs in ipairs(finalpullobs) do
									pushedunits = {}
									dopush(pobs,ox,oy,dir,true,x,y,data.reason,data.unitid)
								end
								
								solved = true
							elseif (result == 1) then
								if (state < 1) then
									data.state = math.max(data.state, 1)
									result_check = true
								else
									local finalpushobs = {}
									
									for c,pushobs in ipairs(pushobslist) do
										local hm = trypush(pushobs,ox,oy,dir,false,x,y,data.reason,data.unitid)
										if (hm == 0) then
											table.insert(finalpushobs, pushobs)
										elseif (hm == 1) or (hm == -1) then
											result = math.max(result, 2)
										else
											MF_alert("HOO HAH")
											return
										end
									end
									
									if (result == 1) then
										for c,pushobs in ipairs(finalpushobs) do
											pushedunits = {}
											dopush(pushobs,ox,oy,dir,false,x,y,data.reason,data.unitid)
										end
										result = 0
									end
								end
							elseif (result == 2) then
								if (state < 2) then
									data.state = math.max(data.state, 2)
									result_check = true
								else
									if (state < 3) then
										data.state = math.max(data.state, 3)
										result_check = true
									else
										if ((data.reason == "move") or (data.reason == "chill")) and (state < 4) then
											data.state = math.max(data.state, 4)
											result_check = true
										else
											local weak = hasfeature(name,"is","weak",data.unitid,x,y)
											
											if (weak ~= nil) then
												delete(data.unitid,x,y)
												generaldata.values[SHAKE] = 3
												
												local pmult,sound = checkeffecthistory("weak")
												MF_particles("destroy",x,y,5 * pmult,0,3,1,1)
												setsoundname("removal",1,sound)
												data.moves = 1
											end
											solved = true
										end
									end
								end
							else
								result_check = true
							end
						end
					else
						solved = true
					end
				end
				
				if solved then
					data.moves = data.moves - 1
					data.state = 10
					
					local tunit = mmf.newObject(data.unitid)
					
					if (data.moves == 0) then
						--print(tunit.strings[UNITNAME] .. " - removed from queue")
						table.insert(delete_moving_units, i)
					else
						if (data.unitid ~= 2) or ((data.unitid == 2) and (data.xpos == -1) and (data.ypos == -1)) then
							table.insert(still_moving, {unitid = data.unitid, reason = data.reason, state = data.state, moves = data.moves, dir = data.dir, xpos = data.xpos, ypos = data.ypos})
						end
						--print(tunit.strings[UNITNAME] .. " - removed from queue")
						table.insert(delete_moving_units, i)
					end
				end
			end
			
			local deloffset = 0
			for i,v in ipairs(delete_moving_units) do
				local todel = v - deloffset
				table.remove(moving_units, todel)
				deloffset = deloffset + 1
			end
			
			if (#movelist > 0) then
				if featureindex["copy"] ~= nil then
					for i,data in ipairs(movelist) do
						unitid = data[1]
						--implement COPY
						if (unitid ~= 2) then
							local unit = mmf.newObject(unitid)
							unitname = getname(unit)
							local copys = find_copys(unitid, data[4]);
							for _,copyid in ipairs(copys) do
								--no multiplicative cascades in copy - only start copying if we're not already copying
								local copy = mmf.newObject(copyid)
								local alreadycopying = false
								for _,other in ipairs(still_moving) do
									if other.unitid == copyid then
										alreadycopying = true
										break
									end
								end
								if not alreadycopying then
									updatedir(copyid, data[4])
									table.insert(still_moving, {unitid = copyid, reason = "copy", state = 0, moves = 1, dir = data[4], xpos = copy.values[XPOS], ypos = copy.values[YPOS]})
								end
							end
						end
					end
				end
			
				for i,data in ipairs(movelist) do
					local success = move(data[1],data[2],data[3],data[4],data[5])
					if (success) then
						if (data[6] == "slip") then
							slipped[data[1]] = true
						end
						unitid = data[1]
						
						--implement SLIDE
						if (unitid ~= 2) then
							local unit = mmf.newObject(unitid)
							unitname = getname(unit)
							local x = unit.values[XPOS] + data[2]
							local y = unit.values[YPOS] + data[3]
							local slides = findfeatureat(nil,"is","slide",x,y) and true or (hasfeature("empty","is","slide",2,x,y) and #findobstacle(x,y) == 0)
							if slides then
								--no multiplicative cascades in slide - only start sliding if we're not already sliding
								local alreadysliding = false
								for _,other in ipairs(still_moving) do
									if other.unitid == unitid and other.reason == "slide" then
										alreadysliding = true
										break
									end
								end
								if not alreadysliding then
									table.insert(still_moving, {unitid = unitid, reason = "slide", state = 0, moves = 1, dir = unit.values[DIR], xpos = unit.values[XPOS], ypos = unit.values[YPOS]})
								end
							end
							
							local revslides = findfeatureat(nil,"is","reverse slide",x,y) and true or (hasfeature("empty","is"," reverse slide",2,x,y) and #findobstacle(x,y) == 0)
							if revslides then
								local alreadysliding = false
								for _,other in ipairs(still_moving) do
									if other.unitid == unitid and other.reason == "slide" then
										alreadysliding = true
										break
									end
								end
								if not alreadysliding then
									table.insert(still_moving, {unitid = unitid, reason = "slide", state = 0, moves = 1, dir = rotate(unit.values[DIR]), xpos = unit.values[XPOS], ypos = unit.values[YPOS]})
								end
							end
						end
					end
				end
			end
			
			movelist = {}
			
			if (smallest_state > state) then
				state = state + 1
			else
				state = smallest_state
			end
			
			if (#moving_units == 0) then
				doupdate()
				done = true
			end
		end

		if (#still_moving > 0) then
			finaltake = true
			moving_units = {}
		else
			finaltake = false
		end
		
		if (finaltake == false) then
			take = take + 1
		end
	end
	
	if (levelpush >= 0) then
		local ndrs = ndirs[levelpush + 1]
		local ox,oy = ndrs[1],ndrs[2]
		
		mapdir = levelpush
		
		addundo({"levelupdate",Xoffset,Yoffset,Xoffset + ox * tilesize,Yoffset + oy * tilesize,mapdir,levelpush})
		MF_scrollroom(ox * tilesize,oy * tilesize)
		updateundo = true
	end
	
	if (levelpull >= 0) then
		local ndrs = ndirs[levelpull + 1]
		local ox,oy = ndrs[1],ndrs[2]
		
		mapdir = levelpush
		
		addundo({"levelupdate",Xoffset,Yoffset,Xoffset + ox * tilesize,Yoffset + oy * tilesize,mapdir,levelpull})
		MF_scrollroom(ox * tilesize,oy * tilesize)
		updateundo = true
	end
	
	doupdate()
	code()
	conversion()
	doupdate()
	code()
	moveblock()
	
	if (dir_ ~= nil) then
		mapcursor_move(ox,oy,dir_)
	end
end

function check(unitid,x,y,dir,pulling_,reason)
	local pulling = false
	if (pulling_ ~= nil) then
		pulling = pulling_
	end
	
	local dir_ = dir
	if pulling then
		dir_ = rotate(dir)
	end
	
	local ndrs = ndirs[dir_ + 1]
	local ox,oy = ndrs[1],ndrs[2]
	
	local result = {}
	local results = {}
	local specials = {}
	
	local emptystop = hasfeature("empty","is","stop",2,x+ox,y+oy)
	local emptypush = hasfeature("empty","is","push",2,x+ox,y+oy)
	local emptypull = hasfeature("empty","is","pull",2,x+ox,y+oy)
	local emptyswap = hasfeature("empty","is","swap",2,x+ox,y+oy)
	
	local unit = {}
	local name = ""
	
	if (unitid ~= 2) then
		unit = mmf.newObject(unitid)
		name = getname(unit)
	else
		name = "empty"
	end
	
	emptystop = emptystop or hasfeature(name,"hates","empty",unitid,x,y)
	emptystop = emptystop or hasfeature("empty","is","sidekick",2,x+ox,y+oy)
	
	if (hasfeature(name,"hates","level",unitid,x,y)) then
		return {-1},{-1},specials
	end
	
	local lockpartner = ""
	local open = hasfeature(name,"is","open",unitid,x,y)
	local shut = hasfeature(name,"is","shut",unitid,x,y)
	local eat = hasfeature(name,"eat",nil,unitid,x,y)
	
	if (open ~= nil) then
		lockpartner = "shut"
	elseif (shut ~= nil) then
		lockpartner = "open"
	end
	
	local obs = findobstacle(x+ox,y+oy)
	
	--likes: if we like stuff and there are no units in the destination that we like AND there's no units at our feet that would be moving there to carry us, we can't go
	local likes = hasfeature(name,"likes",nil,unitid,x,y)
	if (likes ~= nil) then
		local success = false
		if (#obs > 0) then
			for i,id in ipairs(obs) do
				if (id ~= -1) then
					local obsunit = mmf.newObject(id)
					local obsname = getname(obsunit)
					if hasfeature(name,"likes",obsname,unitid,x,y) then
						success = true
						break
					end
				end
			end
		else
			success = hasfeature(name,"likes","empty",unitid,x,y)
		end
		if (not success) then
			local carry = findobstacle(x,y)
			if (#carry > 0) then
				for i,id in ipairs(carry) do
					if (id ~= -1) then
						local obsunit = mmf.newObject(id)
						local obsname = getname(obsunit)
						local alreadymoving = findupdate(id,"update")
						if (#alreadymoving > 0) then
							for a,b in ipairs(alreadymoving) do
								local nx,ny = b[3],b[4]
								if (nx == x+ox and ny == y+oy) then
									if hasfeature(name,"likes",obsname,unitid,x,y) then
										success = true
										break
									end
								end
							end
						end
					end
					if (success) then
						break
					end
				end
			end
		end
		if (not success) then
			return {-1},{-1},specials
		end
	end
	
	if (#obs > 0) then
		for i,id in ipairs(obs) do
			if (id == -1) then
				table.insert(result, -1)
				table.insert(results, -1)
			else
				local obsunit = mmf.newObject(id)
				local obsname = getname(obsunit)
				
				local alreadymoving = findupdate(id,"update")
				local valid = true
				
				local localresult = 0
				
				if (#alreadymoving > 0) then
					for a,b in ipairs(alreadymoving) do
						local nx,ny = b[3],b[4]
						
						if ((nx ~= x) and (ny ~= y)) and ((reason == "shift") and (pulling == false)) then
							valid = false
						end
						
						if ((nx == x) and (ny == y + oy * 2)) or ((ny == y) and (nx == x + ox * 2)) then
							valid = false
						end
					end
				end
				
				if (lockpartner ~= "") and (pulling == false) then
					local partner = hasfeature(obsname,"is",lockpartner,id)
					
					if (partner ~= nil) and ((issafe(id) == false) or (issafe(unitid) == false)) and (floating(id, unitid)) then
						valid = false
						table.insert(specials, {id, "lock"})
					end
				end
				
				if (eat ~= nil) and (pulling == false) then
					local eats = hasfeature(name,"eat",obsname,unitid)
					
					if (eats ~= nil) and (issafe(id) == false) then
						valid = false
						table.insert(specials, {id, "eat"})
					end
				end
				
				local weak = hasfeature(obsname,"is","weak",id)
				if (weak ~= nil) and (pulling == false) then
					if (issafe(id) == false) and (floating(id, unitid)) then
						--valid = false
						table.insert(specials, {id, "weak"})
					end
				end
				
				local added = false
				
				if valid then
					--MF_alert("checking for solidity for " .. obsname .. " by " .. name .. " at " .. tostring(x) .. ", " .. tostring(y))
					
					local isstop = hasfeature(obsname,"is","stop",id) or hasfeature(obsname,"is","sidekick",id) or hasfeature(obsname,"is","reverse sidekick",id) or (featureindex["hates"] ~= nil and hasfeature(name,"hates",obsname,id,x,y)) or (hasfeature(obsname,"is","oneway",id) and dir == rotate(obsunit.values[DIR])) or (hasfeature(obsname,"is","reverse oneway",id) and dir == obsunit.values[DIR])
					if (not isstop) then isstop = nil end
					local ispush = hasfeature(obsname,"is","push",id)
					local ispull = hasfeature(obsname,"is","pull",id)
					local isswap = hasfeature(obsname,"is","swap",id)
					
					--MF_alert(obsname .. " -- stop: " .. tostring(isstop) .. ", push: " .. tostring(ispush))
					
					if (isstop ~= nil) and (obsname == "level") and (obsunit.visible == false) then
						isstop = nil
					end
					
					if (((isstop ~= nil) and (ispush == nil) and ((ispull == nil) or ((ispull ~= nil) and (pulling == false)))) or ((ispull ~= nil) and (pulling == false) and (ispush == nil))) and (isswap == nil) then
						if (weak == nil) or ((weak ~= nil) and (floating(id,unitid) == false)) then
							table.insert(result, 1)
							table.insert(results, id)
							localresult = 1
							added = true
						end
					end
					
					if (localresult ~= 1) and (localresult ~= -1) then
						if (ispush ~= nil) and (pulling == false) and (isswap == nil) then
							--MF_alert(obsname .. " added to push list")
							table.insert(result, id)
							table.insert(results, id)
							added = true
						end
						
						if (ispull ~= nil) and pulling then
							table.insert(result, id)
							table.insert(results, id)
							added = true
						end
					end
				end
				
				if (added == false) then
					table.insert(result, 0)
					table.insert(results, id)
				end
			end
		end
	else
		local localresult = 0
		local valid = true
		local bname = "empty"
		
		if (eat ~= nil) and (pulling == false) then
			local eats = hasfeature(name,"eat",bname,unitid,x+ox,y+oy)
			
			if (eats ~= nil) and (issafe(2,x+ox,y+oy) == false) then
				valid = false
				table.insert(specials, {2, "eat"})
			end
		end
		
		if (lockpartner ~= "") and (pulling == false) then
			local partner = hasfeature(bname,"is",lockpartner,2,x+ox,y+oy)
			
			if (partner ~= nil) and ((issafe(2,x+ox,y+oy) == false) or (issafe(unitid) == false)) then
				valid = false
				table.insert(specials, {2, "lock"})
			end
		end
		
		local weak = hasfeature(bname,"is","weak",2,x+ox,y+oy)
		if (weak ~= nil) and (pulling == false) then
			if (issafe(2,x+ox,y+oy) == false) then
				--valid = false
				table.insert(specials, {2, "weak"})
			end
		end
		
		local added = false
		
		if valid and (emptyswap == nil) then
			if (emptystop ~= nil) or ((emptypull ~= nil) and (pulling == false)) then
				localresult = 1
				table.insert(result, 1)
				table.insert(results, 2)
				added = true
			end
			
			if (localresult ~= 1) then
				if (emptypush ~= nil) or ((emptypull ~= nil) and pulling) then
					table.insert(result, 2)
					table.insert(results, 2)
				end
				added = true
			end
		end
		
		if (added == false) then
			table.insert(result, 0)
			table.insert(results, 2)
		end
	end
	
	if (#results == 0) then
		result = {0}
		results = {0}
	end
	
	return result,results,specials
end

function trypush(unitid,ox,oy,dir,pulling_,x_,y_,reason,pusherid)
	local x,y = 0,0
	local unit = {}
	local name = ""
	
	if (unitid ~= 2) then
		unit = mmf.newObject(unitid)
		x,y = unit.values[XPOS],unit.values[YPOS]
		name = getname(unit)
	else
		x = x_
		y = y_
		name = "empty"
	end
	
	if (activemod.very_drunk) then
		dir, ox, oy = apply_moonwalk(unitid,x,y,dir,ox,oy,false)
	end
	
	local pulling = pulling_ or false
	
	local weak = hasfeature(name,"is","weak",unitid,x_,y_)
	
	local pushername = "empty";
	if (pusherid > 2) then
		local pusherunit = mmf.newObject(pusherid);
		pushername = getname(pusherunit);
	end
	local lazypusher = hasfeature(pushername,"is","lazy",pusherid,x,y) ~= nil

	if (weak == nil) or pulling then
		local hmlist,hms,specials = check(unitid,x,y,dir,false,reason)
		
		local result = 0
		
		for i,hm in pairs(hmlist) do
			local done = false
			
			while (done == false) do
				if (lazypusher) then
					return 1
				elseif (hm == 0) then
					result = math.max(0, result)
					done = true
				elseif (hm == 1) or (hm == -1) then
					if (pulling == false) or (pulling and (hms[i] ~= pusherid)) then
						result = math.max(1, result)
						done = true
					else
						result = math.max(0, result)
						done = true
					end
				else
					if (pulling == false) then
						hm = trypush(hm,ox,oy,dir,pulling,x+ox,y+oy,reason,unitid)
					else
						result = math.max(0, result)
						done = true
					end
				end
			end
		end
		
		return result
	else
		return 0
	end
end

function dopush(unitid,ox,oy,dir,pulling_,x_,y_,reason,pusherid)
	local pid2 = tostring(ox + oy * roomsizex) .. tostring(unitid)
	pushedunits[pid2] = 1
	
	local x,y = 0,0
	local unit = {}
	local name = ""
	local pushsound = false
	
	if (unitid ~= 2) then
		unit = mmf.newObject(unitid)
		x,y = unit.values[XPOS],unit.values[YPOS]
		name = getname(unit)
	else
		x = x_
		y = y_
		name = "empty"
	end
	
	if (activemod.very_drunk) then
		dir, ox, oy = apply_moonwalk(unitid,x,y,dir,ox,oy,false) 
	end
	
	local pushername = "empty";
	if (pusherid > 2) then
		local pusherunit = mmf.newObject(pusherid);
		pushername = getname(pusherunit);
	end
	local lazypusher = hasfeature(pushername,"is","lazy",pusherid,x,y) ~= nil
	local lazyid = hasfeature(name,"is","lazy",unitid,x,y) ~= nil
	
	local pulling = false
	if (pulling_ ~= nil) then
		pulling = pulling_
	end
	
	local swaps = findfeatureat(nil,"is","swap",x+ox,y+oy)
	if (swaps ~= nil) and ((unitid ~= 2) or ((unitid == 2) and (pulling == false))) then
		for a,b in ipairs(swaps) do
			if (pulling == false) or (pulling and (b ~= pusherid)) then
				local alreadymoving = findupdate(b,"update")
				local valid = true
				
				if (#alreadymoving > 0) then
					valid = false
				end
				
				if valid then
					addaction(b,{"update",x,y,nil})
				end
			end
		end
	end
	
	if pulling then
		local swap = hasfeature(name,"is","swap",unitid,x,y)
		
		if swap then
			local swapthese = findallhere(x+ox,y+oy)
			
			for a,b in ipairs(swapthese) do
				local alreadymoving = findupdate(b,"update")
				local valid = true
				
				if (#alreadymoving > 0) then
					valid = false
				end
				
				if valid then
					addaction(b,{"update",x,y,nil})
					pushsound = true
				end
			end
		end
	end

	local hm = 0
	
	if (HACK_MOVES < 10000) then
		local hmlist,hms,specials = check(unitid,x,y,dir,false,reason)
		local pullhmlist,pullhms,pullspecials = check(unitid,x,y,dir,true,reason)
		local result = 0
		
		local weak = hasfeature(name,"is","weak",unitid,x_,y_)
		
			--MF_alert(name .. " is looking... (" .. tostring(unitid) .. ")" .. ", " .. tostring(pulling))
		for i,obs in pairs(hmlist) do
			local done = false
			while (done == false) do
				if (lazypusher) then
					return 1
				elseif (obs == 0) then
					result = math.max(0, result)
					done = true
				elseif (obs == 1) or (obs == -1) then
					if (pulling == false) or (pulling and (hms[i] ~= pusherid)) then
						result = math.max(2, result)
						done = true
					else
						result = math.max(0, result)
						done = true
					end
				else
					if (pulling == false) or (pulling and (hms[i] ~= pusherid)) then
						result = math.max(1, result)
						done = true
					else
						result = math.max(0, result)
						done = true
					end
				end
			end
		end
			
		local finaldone = false
		
		while (finaldone == false) and (HACK_MOVES < 10000) do
			if (result == 0) then
				queue_move(unitid,ox,oy,dir,specials,reason)
				--move(unitid,ox,oy,dir,specials)
				pushsound = true
				finaldone = true
				hm = 0
				
				if (pulling == false) then
					for i,obs in ipairs(pullhmlist) do
						if (obs < -1) or (obs > 1) and (obs ~= pusherid) then
							if (obs ~= 2) then
								queue_move(obs,ox,oy,dir,pullspecials,reason)
								pushsound = true
								--move(obs,ox,oy,dir,specials)
							end
							
							local pid = tostring(x-ox + (y-oy) * roomsizex) .. tostring(obs)
							
							if (pushedunits[pid] == nil) then
								pushedunits[pid] = 1
								hm = dopush(obs,ox,oy,dir,true,x-ox,y-oy,reason,unitid)
							end
						end
					end
				end
			elseif (result == 1) then
				for i,v in ipairs(hmlist) do
					if (v ~= -1) and (v ~= 0) and (v ~= 1) then
						local pid = tostring(x+ox + (y+oy) * roomsizex) .. tostring(v)
						
						if (pulling == false) or (pulling and (hms[i] ~= pusherid)) and (pushedunits[pid] == nil) then
							pushedunits[pid] = 1
							hm = dopush(v,ox,oy,dir,false,x+ox,y+oy,reason,unitid)
						end
					end
				end
				
				if (hm == 0) then
					result = 0
				else
					result = 2
				end
			elseif (result == 2) then
				hm = 1
				
				if (weak ~= nil) then
					delete(unitid,x,y)
					
					local pmult,sound = checkeffecthistory("weak")
					setsoundname("removal",1,sound)
					generaldata.values[SHAKE] = 3
					MF_particles("destroy",x,y,5 * pmult,0,3,1,1)
					result = 0
					hm = 0
				end
				
				finaldone = true
			end
		end
		
		if pulling and (HACK_MOVES < 10000) then
			if (lazypusher) then
				return 1
			end
			hmlist,hms,specials = check(unitid,x,y,dir,pulling,reason)
			hm = 0
			
			for i,obs in pairs(hmlist) do
				if (obs < -1) or (obs > 1) then
					if (not lazyid) then
						--Mostly the lazypusher stuff is self-explanatory - don't do a push if we're lazy.
						--But in the case of pulling, the item one ahead of us does a pull 'early', so we have to stop it in advance.
						if (obs ~= 2) then
							table.insert(movelist, {obs,ox,oy,dir,specials,1,reason})
							pushsound = true
							--move(obs,ox,oy,dir,specials)
						end

						local pid = tostring(x-ox + (y-oy) * roomsizex) .. tostring(obs)
						
						if (pushedunits[pid] == nil) then
							pushedunits[pid] = 1
							hm = dopush(obs,ox,oy,dir,pulling,x-ox,y-oy,reason,unitid)
						end
					end
				end
			end
		end
		
		if pushsound and (generaldata2.strings[TURNSOUND] == "") then
			setsoundname("turn",5)
		end
	end
	
	HACK_MOVES = HACK_MOVES + 1
	
	return hm
end

function move(unitid,ox,oy,dir,specials_,instant_,simulate_)
	local instant = instant_ or false
	local simulate = simulate_ or false
	local success = false
	
	if (unitid ~= 2) then
		local unit = mmf.newObject(unitid)
		local x,y = unit.values[XPOS],unit.values[YPOS]
		
		local specials = {}
		if (specials_ ~= nil) then
			specials = specials_
		end
		
		local gone = false
		
		for i,v in pairs(specials) do
			if (gone == false) then
				local b = v[1]
				local reason = v[2]
				local dodge = false
				
				local bx,by = 0,0
				if (b ~= 2) then
					local bunit = mmf.newObject(b)
					bx,by = bunit.values[XPOS],bunit.values[YPOS]
					
					if (bx ~= x+ox) or (by ~= y+oy) then
						dodge = true
					else
						for c,d in ipairs(movelist) do
							if (d[1] == b) then
								local nx,ny = d[2],d[3]
								
								--print(tostring(nx) .. "," .. tostring(ny) .. " --> " .. tostring(x+ox) .. "," .. tostring(y+oy) .. " (" .. tostring(bx) .. "," .. tostring(by) .. ")")
								if (nx ~= x+ox) or (ny ~= y+oy) then
									dodge = true
								end
							end
						end
					end
				else
					bx,by = x+ox,y+oy
				end
				
				if (dodge == false) then
					if (reason == "lock") then
						local unlocked = false
						local valid = true
						local soundshort = ""
						
						if (b ~= 2) then
							local bunit = mmf.newObject(b)
							
							if bunit.flags[DEAD] then
								valid = false
							end
						end
						
						if unit.flags[DEAD] then
							valid = false
						end
						
						if valid then
							local pmult = 1.0
							local effect1 = false
							local effect2 = false
							
							if (issafe(b,bx,by) == false) then
								delete(b,bx,by)
								unlocked = true
								effect1 = true
							end
							
							if (issafe(unitid) == false) then
								delete(unitid,x,y)
								unlocked = true
								gone = true
								effect2 = true
							end
							
							if effect1 or effect2 then
								local pmult,sound = checkeffecthistory("unlock")
								soundshort = sound
							end
							
							if effect1 then
								MF_particles("unlock",bx,by,15 * pmult,2,4,1,1)
								generaldata.values[SHAKE] = 8
							end
							
							if effect2 then
								MF_particles("unlock",x,y,15 * pmult,2,4,1,1)
								generaldata.values[SHAKE] = 8
							end
						end
						
						if unlocked then
							setsoundname("turn",7,soundshort)
						end
					elseif (reason == "eat") then
						local pmult,sound = checkeffecthistory("eat")
						MF_particles("eat",bx,by,10 * pmult,0,3,1,1)
						generaldata.values[SHAKE] = 3
						delete(b,bx,by)
						
						setsoundname("removal",1,sound)
					elseif (reason == "weak") then
						--[[
						MF_particles("destroy",bx,by,5,0,3,1,1)
						generaldata.values[SHAKE] = 3
						delete(b,bx,by)
						]]--
					end
				end
			end
		end
		
		if (gone == false) and (simulate == false) then
			local revmove = hasfeature(unitname,"is","reverse move",unitid,x,y)
			
			if (revmove ~= nil) then
				dir = rotate(dir)
			end
			
			success = true
			dir = apply_moonwalk(unitid, x, y, dir, nil, nil, true)
			if instant then
				update(unitid,x+ox,y+oy,dir)
				MF_alert("Instant movement on " .. tostring(unitid))
			else
				addaction(unitid,{"update",x+ox,y+oy,dir})
			end
			
			if unit.visible and (#movelist < 700) then
				if (generaldata.values[DISABLEPARTICLES] == 0) then
					local effectid = MF_effectcreate("effect_bling")
					local effect = mmf.newObject(effectid)
					
					local midx = math.floor(roomsizex * 0.5)
					local midy = math.floor(roomsizey * 0.5)
					local mx = x - midx
					local my = y - midy
					
					local c1,c2 = getcolour(unitid)
					MF_setcolour(effectid,c1,c2)
					
					local xvel,yvel = 0,0
					
					if (ox ~= 0) then
						xvel = 0 - ox / math.abs(ox)
					end
					
					if (oy ~= 0) then
						yvel = 0 - oy / math.abs(oy)
					end
					
					local dx = mx + 0.5
					local dy = my + 0.75
					local dxvel = xvel
					local dyvel = yvel
					
					if (generaldata2.values[ROOMROTATION] == 90) then
						dx = my + 0.75
						dy = 0 - mx - 0.5
						dxvel = yvel
						dyvel = 0 - xvel
					elseif (generaldata2.values[ROOMROTATION] == 180) then
						dx = 0 - mx - 0.5
						dy = 0 - my - 0.75
						dxvel = 0 - xvel
						dyvel = 0 - yvel
					elseif (generaldata2.values[ROOMROTATION] == 270) then
						dx = 0 - my - 0.75
						dy = mx + 0.5
						dxvel = 0 - yvel
						dyvel = xvel
					end
					
					effect.values[ONLINE] = 3
					effect.values[XPOS] = Xoffset + (midx + (dx) * generaldata2.values[ZOOM]) * tilesize * spritedata.values[TILEMULT]
					effect.values[YPOS] = Yoffset + (midy + (dy) * generaldata2.values[ZOOM]) * tilesize * spritedata.values[TILEMULT]
					effect.scaleX = generaldata2.values[ZOOM] * spritedata.values[TILEMULT]
					effect.scaleY = generaldata2.values[ZOOM] * spritedata.values[TILEMULT]
					
					effect.values[XVEL] = dxvel * math.random(10,30) * 0.1 * spritedata.values[TILEMULT] * generaldata2.values[ZOOM]
					effect.values[YVEL] = dyvel * math.random(10,30) * 0.1 * spritedata.values[TILEMULT] * generaldata2.values[ZOOM]
				end
				
				if (unit.values[TILING] == 2) then
					unit.values[VISUALDIR] = ((unit.values[VISUALDIR] + 1) + 4) % 4
				end
			end
		end
		
		return success
	end
end

function add_moving_units(rule,newdata,data,been_seen,empty_)
	local result = data
	local seen = been_seen
	local empty = empty_ or {}
	
	for i,v in ipairs(newdata) do
		local sleeping = false
		
		if (rule == "slip") then
			--slip can't be stopped by sleeping/slipping
		elseif (slipped[v] ~= nil) then
			sleeping = true
		elseif (v ~= 2) then
			local unit = mmf.newObject(v)
			local unitname = getname(unit)
			local sleep = hasfeature(unitname,"is","sleep",v)
			
			if (sleep ~= nil) then
				sleeping = true
			end
		else
			local thisempty = empty[i]
			
			for a,b in pairs(thisempty) do
				local x = a % roomsizex
				local y = math.floor(a / roomsizex)
				
				local sleep = hasfeature("empty","is","sleep",2,x,y)
				
				if (sleep ~= nil) then
					thisempty[a] = nil
				end
			end
		end
		
		if (sleeping == false) then
			if (seen[v] == nil) then
				-- Dir set only for the purposes of Empty
				local dir_ = math.random(0,3)
				
				local x,y = -1,-1
				if (v ~= 2) then
					local unit = mmf.newObject(v)
					x,y = unit.values[XPOS],unit.values[YPOS]
					
					table.insert(result, {unitid = v, reason = rule, state = 0, moves = 1, dir = dir_, xpos = x, ypos = y})
					seen[v] = #result
				else
					local thisempty = empty[i]
				
					for a,b in pairs(thisempty) do
						x = a % roomsizex
						y = math.floor(a / roomsizex)
					
						table.insert(result, {unitid = 2, reason = rule, state = 0, moves = 1, dir = dir_, xpos = x, ypos = y})
						seen[v] = #result
					end
				end
			else
				local id = seen[v]
				local this = result[id]
				this.moves = this.moves + 1
			end
		end
	end
	
	return result,seen
end

function find_copys(unitid,dir)
	--fast track
	if featureindex["copy"] == nil then return {} end
	local result = {}
	local unit = mmf.newObject(unitid)
	local unitname = getname(unit)
	local iscopy = findallfeature(nil,"copy",unitname,true)
	for _,copyid in ipairs(iscopy) do
		local copyunit = mmf.newObject(copyid)
		local copyname = getname(copyunit)
		if not hasfeature(copyname,"is","sleep",copyid) then
			table.insert(result, copyid)
		end
	end
	return result;
end

function find_sidekicks(unitid,dir)
	--fast track
	if featureindex["sidekick"] == nil then return {} end
	local result = {}
	local unit = mmf.newObject(unitid)
	local unitname = getname(unit)
	local lazy = hasfeature(unitname,"is","lazy",unitid)
	if lazy ~= nil then
		return result;
	end
	local x,y = unit.values[XPOS],unit.values[YPOS]
	local dir90 = (dir+1) % 4;
	for i = 1,2 do
		local curdir = (dir90+2*i) % 4;
		local curdx = ndirs[curdir+1][1];
		local curdy = ndirs[curdir+1][2];
		local curx = x+curdx;
		local cury = y+curdy;
		local obs = findobstacle(curx,cury);
		for i,id in ipairs(obs) do
			if (id ~= -1) then
				local obsunit = mmf.newObject(id)
				local obsname = getname(obsunit)
				if hasfeature(obsname,"is","sidekick",id) then
					table.insert(result, id);
				end
			end
		end
	end
	return result;
end

function find_revsidekicks(unitid,dir)
	if featureindex["reverse sidekick"] == nil then return {} end
	local result = {}
	local unit = mmf.newObject(unitid)
	local unitname = getname(unit)
	local lazy = hasfeature(unitname,"is","lazy",unitid)
	if lazy ~= nil then
		return result;
	end
	local x,y = unit.values[XPOS],unit.values[YPOS]
	local dir90 = (dir+1) % 4;
	for i = 1,2 do
		local curdir = (dir90+2*i) % 4;
		local curdx = ndirs[curdir+1][1];
		local curdy = ndirs[curdir+1][2];
		local curx = x+curdx;
		local cury = y+curdy;
		local obs = findobstacle(curx,cury);
		for i,id in ipairs(obs) do
			if (id ~= -1) then
				local obsunit = mmf.newObject(id)
				local obsname = getname(obsunit)
				if hasfeature(obsname,"is","reverse sidekick",id) then
					table.insert(result, id);
				end
			end
		end
	end
	return result;
end

function apply_moonwalk(unitid, x, y, dir, ox, oy, reverse)
	local name = "empty"
	local sgn = reverse == true and -1 or 1
	if (unitid ~= 2) then
		local unit = mmf.newObject(unitid)
		name = getname(unit)
	end
	local rotatedness = 0;
	rotatedness = rotatedness + sgn*countfeature(name,"is","moonwalk",unitid,x,y)*2;
	rotatedness = rotatedness + sgn*countfeature(name,"is","drunk",unitid,x,y);
	rotatedness = rotatedness + sgn*countfeature(name,"is","drunker",unitid,x,y)*0.5;
	local mag = 1;
	mag = mag + countfeature(name,"is","skip",unitid,x,y) - countfeature(name,"is","reverse skip",unitid,x,y)
	if (dir ~= nil and ox ~= nil and oy ~= nil) then
		dir = (dir + trunc(rotatedness)) % 4
		ox, oy = dirtooxoy(oxoytodir(ox, oy) + rotatedness)
		ox = ox * mag;
		oy = oy * mag;
		return dir, ox, oy
	elseif (dir ~= nil) then
		dir = (dir + trunc(rotatedness)) % 4
		return dir
	elseif (ox ~= nil and oy ~= nil) then
		ox, oy = dirtooxoy(oxoytodir(ox, oy) + rotatedness)
		ox = ox * mag;
		oy = oy * mag;
		return ox, oy
	else
		return nil
	end
end

function oxoytodir(ox, oy)
	ox = sign(ox)
	oy = sign(oy)
	if ox == 1 and oy == 0 then
		return 0
	elseif ox == 1 and oy == -1 then
		return 0.5
	elseif ox == 0 and oy == -1 then
		return 1
	elseif ox == -1 and oy == -1 then
		return 1.5
	elseif ox == -1 and oy == 0 then
		return 2
	elseif ox == -1 and oy == 1 then
		return 2.5
	elseif ox == 0 and oy == 1 then
		return 3
	elseif ox == 1 and oy == 1 then
		return 3.5
	end
	return nil
end

function dirtooxoy(dir)
	dir = dir % 4
	if dir == math.floor(dir) then
		local result = ndirs[dir+1]
		return result[1], result[2]
	elseif dir == 0.5 then
		return 1, -1
	elseif dir == 1.5 then
		return -1, -1
	elseif dir == 2.5 then
		return -1, 1
	elseif dir == 3.5 then
		return 1, 1
	end
	return 0, 0
end

function sign(num)
	if num > 0 then
		return 1
	elseif num < 0 then
		return -1
	else
		return 0
	end
end

function trunc(num)
	if num > 0 then
		return math.floor(num)
	elseif num < 0 then
		return math.ceil(num)
	else
		return 0
	end
end

function queue_move(unitid,ox,oy,dir,specials,reason)
	table.insert(movelist, {unitid,ox,oy,dir,specials,reason})
	
	--implement SIDEKICK
	if (unitid ~= 2) then
		local unit = mmf.newObject(unitid)
		unitname = getname(unit)
		local sidekicks = find_sidekicks(unitid, dir);
		for _,sidekickid in ipairs(sidekicks) do
			--no multiplicative cascades in sidekick - only start sidekicking if we're not already sidekicking
			local sidekick = mmf.newObject(sidekickid)
			local alreadysidekicking = false
			for _,other in ipairs(moving_units) do
				if other.unitid == sidekickid then
					alreadysidekicking = true
					break
				end
			end
			if not alreadysidekicking then
				updatedir(sidekickid, dir)
				table.insert(moving_units, {unitid = sidekickid, reason = "sidekick", state = 0, moves = 1, dir = dir, xpos = sidekick.values[XPOS], ypos = sidekick.values[YPOS]})
			end
		end
		
		local revsidekicks = find_revsidekicks(unitid, dir);
		for _,sidekickid in ipairs(revsidekicks) do
			local sidekick = mmf.newObject(sidekickid)
			local alreadysidekicking = false
			for _,other in ipairs(moving_units) do
				if other.unitid == sidekickid then
					alreadysidekicking = true
					break
				end
			end
			if not alreadysidekicking then
				updatedir(sidekickid, rotate(dir))
				table.insert(moving_units, {unitid = sidekickid, reason = "sidekick", state = 0, moves = 1, dir = rotate(dir), xpos = sidekick.values[XPOS], ypos = sidekick.values[YPOS]})
			end
		end
	end
end