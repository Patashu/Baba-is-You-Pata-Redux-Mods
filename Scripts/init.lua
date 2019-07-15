local mod = {}

-- options.lua to edit
mod.enabled = {}
mod.tile = {}
mod.macros = {}

mod.tilecount = 0

-- Calls when a world is first loaded
function mod.load(dir)
	-- Load mod code
	loadscript(dir .. "options")
	loadscript(dir .. "blocks")
	loadscript(dir .. "conditions")
	loadscript(dir .. "movement")
	loadscript(dir .. "tools")
	loadscript(dir .. "undo")
	loadscript(dir .. "syntax")
	loadscript(dir .. "convert")
	loadscript(dir .. "rules")

	-- Load mod tiles enabled in options.lua
	for _,v in ipairs(mod.alltiles) do
		if mod.enabled[v] then
			mod.addblock(mod.tile[v])
		end
	end
end

-- Calls when another world is loaded while this mod is active
function mod.unload(dir)
	-- Unload mod code
	loadscript("Data/values")
	loadscript("Data/blocks")
	loadscript("Data/conditions")
	loadscript("Data/movement")
	loadscript("Data/tools")
	loadscript("Data/undo")
	loadscript("Data/syntax")
	loadscript("Data/convert")
	loadscript("Data/rules")
end

mod.alltiles = {
	"slip",
	"slide",
	"likes",
	"hates",
	"sidekick",
	"lazy",
	"lean",
	"turn",
	"spin",
	"moonwalk",
	"drunk",
	"drunker",
	"skip",
	"oneway",
	"tall",
	"copy",
	"stubborn",
	"reset",
	"persist",
	"back",
	"with",
	"reverse",
	"vall"
}

function mod.addblock(tile)
	if mod.tilecount >= 30 then
		return
	end

	local tileindex = 120 + mod.tilecount
	local tilename = "object" .. tileindex

	tileslist[tilename] = tile
	--+1 because of cursor
	tileslist[tilename].grid = {11 + math.floor((mod.tilecount+1) / 11), (mod.tilecount+1) % 11}

	mod.tilecount = mod.tilecount + 1
end

return mod