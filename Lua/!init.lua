--[[local mod = activemod

-- Properties
mod.enabled["slip"] = true
mod.enabled["slide"] = true
mod.enabled["likes"] = true
mod.enabled["hates"] = true
mod.enabled["sidekick"] = true
mod.enabled["lazy"] = true
mod.enabled["moonwalk"] = true
mod.enabled["drunk"] = true
mod.enabled["drunker"] = true
mod.enabled["skip"] = true
mod.enabled["oneway"] = true
mod.enabled["tall"] = true
mod.enabled["copy"] = true
mod.enabled["reset"] = true
mod.enabled["persist"] = true

--If true, MOONWALK and related properties (DRUNK, DRUNKER, SKIP) apply to PUSH, PULL, SHIFT and YEET in addition to basically everything else. Defaults to true.
activemod.very_drunk = true]]

print("hi")

table.insert(editor_objlist_order, "text_slip")
editor_objlist["text_slip"] = {
	name = "text_slip",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_slide")
editor_objlist["text_slide"] = {
	name = "text_slide",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 2,
  layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_hates")
editor_objlist["text_hates"] = {
	name = "text_hates",
	sprite_in_root = false,
	unittype = "text",
  tags = {"patashu"},
	tiling = -1,
	type = 1,
  layer = 20,
	operatortype = "verb",
	colour = {5, 0},
	colour_active = {5, 1},
}

--[[editor_objlist["likes"] = {
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

editor_objlist["sidekick"] = {
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

editor_objlist["lazy"] = {
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

editor_objlist["moonwalk"] = {
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

editor_objlist["drunk"] = {
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

editor_objlist["drunker"] = {
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

editor_objlist["skip"] = {
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

editor_objlist["oneway"] = {
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

editor_objlist["tall"] = {
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

editor_objlist["copy"] = {
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

editor_objlist["reset"] = {
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

editor_objlist["persist"] = {
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
}]]--

formatobjlist()