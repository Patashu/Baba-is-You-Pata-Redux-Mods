local mod = activemod

-- Properties
mod.enabled["slip"] = true
mod.enabled["slide"] = true
mod.enabled["likes"] = true
mod.enabled["hates"] = true
mod.enabled["sidekick"] = true
mod.enabled["lazy"] = true
--mod.enabled["lean"] = true
--mod.enabled["turn"] = true
--mod.enabled["spin"] = true
mod.enabled["moonwalk"] = true
mod.enabled["drunk"] = true
mod.enabled["drunker"] = true
mod.enabled["skip"] = true
mod.enabled["oneway"] = true
mod.enabled["tall"] = true
mod.enabled["copy"] = true
--mod.enabled["stubborn"] = true
mod.enabled["reset"] = true
mod.enabled["persist"] = true
--mod.enabled["back"] = true
--mod.enabled["with"] = true
--mod.enabled["reverse"] = true
--mod.enabled["vall"] = true

--If true, MOONWALK and related properties (DRUNK, DRUNKER, SKIP) apply to PUSH, PULL, SHIFT and YEET in addition to basically everything else. Defaults to true.
activemod.very_drunk = true

mod.tile["slip"] = {
	name = "text_slip",
	sprite = "text_slip",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {1, 3},
	active = {1, 4},
	tile = {96, 1},
	layer = 20,
}

mod.tile["slide"] = {
	name = "text_slide",
	sprite = "text_slide",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {1, 3},
	active = {1, 4},
	tile = {96, 2},
	layer = 20,
}

mod.tile["likes"] = {
	name = "text_likes",
	sprite = "text_likes",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 1,
	operatortype = "verb",
	colour = {5, 0},
	active = {5, 1},
	tile = {96, 3},
	layer = 20,
}

mod.tile["hates"] = {
	name = "text_hates",
	sprite = "text_hates",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 1,
	operatortype = "verb",
	colour = {5, 0},
	active = {5, 1},
	tile = {96, 4},
	layer = 20,
}

mod.tile["sidekick"] = {
	name = "text_sidekick",
	sprite = "text_sidekick",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {6, 0},
	active = {6, 1},
	tile = {96, 5},
	layer = 20,
}

mod.tile["lazy"] = {
	name = "text_lazy",
	sprite = "text_lazy",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {6, 1},
	active = {6, 2},
	tile = {96, 6},
	layer = 20,
}

mod.tile["lean"] = {
	name = "text_lean",
	sprite = "text_lean",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {5, 2},
	active = {5, 3},
	tile = {96, 7},
	layer = 20,
}

mod.tile["turn"] = {
	name = "text_turn",
	sprite = "text_turn",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {5, 2},
	active = {5, 3},
	tile = {96, 8},
	layer = 20,
}

mod.tile["spin"] = {
	name = "text_spin",
	sprite = "text_spin",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {1, 3},
	active = {1, 4},
	tile = {96, 9},
	layer = 20,
}

mod.tile["moonwalk"] = {
	name = "text_moonwalk",
	sprite = "text_moonwalk",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {1, 3},
	active = {1, 4},
	tile = {96, 10},
	layer = 20,
}

mod.tile["drunk"] = {
	name = "text_drunk",
	sprite = "text_drunk",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {1, 3},
	active = {1, 4},
	tile = {96, 11},
	layer = 20,
}

mod.tile["drunker"] = {
	name = "text_drunker",
	sprite = "text_drunker",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {1, 3},
	active = {1, 4},
	tile = {96, 12},
	layer = 20,
}

mod.tile["skip"] = {
	name = "text_skip",
	sprite = "text_skip",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {1, 3},
	active = {1, 4},
	tile = {96, 13},
	layer = 20,
}

mod.tile["oneway"] = {
	name = "text_oneway",
	sprite = "text_oneway",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {1, 3},
	active = {1, 4},
	tile = {96, 14},
	layer = 20,
}

mod.tile["tall"] = {
	name = "text_tall",
	sprite = "text_tall",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {0, 0},
	active = {0, 1},
	tile = {96, 15},
	layer = 20,
}

mod.tile["stubborn"] = {
	name = "text_stubborn",
	sprite = "text_stubborn",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {6, 1},
	active = {6, 2},
	tile = {96, 16},
	layer = 20,
}

mod.tile["copy"] = {
	name = "text_copy",
	sprite = "text_copy",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 1,
	operatortype = "verb",
	colour = {2, 1},
	active = {2, 2},
	tile = {96, 17},
	layer = 20,
}

mod.tile["reset"] = {
	name = "text_reset",
	sprite = "text_reset",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {3, 0},
	active = {3, 1},
	tile = {96, 18},
	layer = 20,
}

mod.tile["persist"] = {
	name = "text_persist",
	sprite = "text_persist",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {0, 2},
	active = {0, 3},
	tile = {96, 19},
	layer = 20,
}

mod.tile["back"] = {
	name = "text_back",
	sprite = "text_back",
	sprite_in_root = true,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {6, 0},
	active = {6, 1},
	tile = {96, 20},
	layer = 20,
}

mod.tile["with"] = {
	name = "text_with",
	sprite = "text_with",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 7,
	operatortype = "cond_arg",
	argtype = {2},
	colour = {0, 1},
	active = {0, 3},
	tile = {96, 21},
	layer = 20,
}

mod.tile["reverse"] = {
	name = "text_reverse",
	sprite = "text_reverse",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 9,
	colour = {2, 1},
	active = {2, 2},
	tile = {96,22},
	layer = 20,
}

--[[
mod.tile["vall"] = {
	name = "text_vall",
	sprite = "text_vall",
	sprite_in_root = false,
	unittype = "text",
	tiling = -1,
	type = 2,
	colour = {2, 1},
	active = {2, 2},
	tile = {96,23},
	layer = 20,
}
]]

reversefeatures =
{
	push = "pull",
	pull = "push",
	swap = "stop",
	up = "down",
	down = "up",
	left = "right",
	right = "left",
	win = "defeat",
	defeat = "win",
	stop = "swap",
	open = "shut",
	shut = "open",
	melt = "hot",
	hot = "melt",
	fall = "vall",
	vall = "fall",
	best = "sad",
	sad = "best",
	red = "blue",
	blue = "red",
	float = "tall",
	make = "eat",
	eat = "make",
	fear = "follow",
	follow = "fear",
	safe = "weak",
	word = "text",
	on = "not on",
	near = "not near",
	lonely = "not lonely",
	group = "not group",
	sleep = "move",
	bonus = "done",
	done = "bonus",
	
	--mods
	likes = "hates",
	hates = "likes",
	drunk = "drunker",
	drunker = "drunk",
	stubborn = "lazy",
	lazy = "stubborn",
	persist = "back",
	back = "persist",
}

reversefeatures["end"] = "reset"
reversefeatures["reset"] = "end"
reversefeatures["not"] = "not not"