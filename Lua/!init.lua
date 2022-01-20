--If true, MOONWALK and related properties (DRUNK, DRUNKER, SKIP) apply to PUSH, PULL, SHIFT and YEET in addition to basically everything else. Defaults to true.
very_drunk = true

print("Start of !init.lua")

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

table.insert(editor_objlist_order, "text_likes")
editor_objlist["text_likes"] = {
	name = "text_likes",
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

table.insert(editor_objlist_order, "text_sidekick")
editor_objlist["text_sidekick"] = {
	name = "text_sidekick",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {6, 0},
	colour_active = {6, 1},
}

table.insert(editor_objlist_order, "text_lazy")
editor_objlist["text_lazy"] = {
	name = "text_lazy",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {6, 1},
	colour_active = {6, 2},
}

table.insert(editor_objlist_order, "text_moonwalk")
editor_objlist["text_moonwalk"] = {
	name = "text_moonwalk",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_drunk")
editor_objlist["text_drunk"] = {
	name = "text_drunk",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_drunker")
editor_objlist["text_drunker"] = {
	name = "text_drunker",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_skip")
editor_objlist["text_skip"] = {
	name = "text_skip",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_tall")
editor_objlist["text_tall"] = {
	name = "text_tall",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {0, 0},
	colour_active = {0, 1},
}

table.insert(editor_objlist_order, "text_oneway")
editor_objlist["text_oneway"] = {
	name = "text_oneway",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_copy")
editor_objlist["text_copy"] = {
	name = "text_copy",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {2, 1},
	colour_active = {2, 2},
}

table.insert(editor_objlist_order, "text_reset")
editor_objlist["text_reset"] = {
	name = "text_reset",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {3, 0},
	colour_active = {3, 1},
	layer = 20,
}

table.insert(editor_objlist_order, "text_persist")
editor_objlist["text_persist"] = {
	name = "text_persist",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {0, 2},
	colour_active = {0, 3},
}

table.insert(editor_objlist_order, "text_stops")
editor_objlist["text_stops"] = {
	name = "text_stops",
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

table.insert(editor_objlist_order, "text_pushes")
editor_objlist["text_pushes"] = {
	name = "text_pushes",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {6, 0},
	colour_active = {6, 1},
}

table.insert(editor_objlist_order, "text_pulls")
editor_objlist["text_pulls"] = {
	name = "text_pulls",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {6, 1},
	colour_active = {6, 2},
}

table.insert(editor_objlist_order, "text_sinks")
editor_objlist["text_sinks"] = {
	name = "text_sinks",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {1, 2},
	colour_active = {1, 3},
}

table.insert(editor_objlist_order, "text_defeats")
editor_objlist["text_defeats"] = {
	name = "text_defeats",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {2, 0},
	colour_active = {2, 1},
}

table.insert(editor_objlist_order, "text_opens")
editor_objlist["text_opens"] = {
	name = "text_opens",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {6, 1},
	colour_active = {2, 4},
}

table.insert(editor_objlist_order, "text_shifts")
editor_objlist["text_shifts"] = {
	name = "text_shifts",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {1, 2},
	colour_active = {1, 3},
}

table.insert(editor_objlist_order, "text_teles")
editor_objlist["text_teles"] = {
	name = "text_teles",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {1, 2},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_swaps")
editor_objlist["text_swaps"] = {
	name = "text_swaps",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {3, 0},
	colour_active = {3, 1},
}

table.insert(editor_objlist_order, "text_melts")
editor_objlist["text_melts"] = {
	name = "text_melts",
	sprite_in_root = false,
	unittype = "text",
	tags = {"patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {2, 2},
	colour_active = {2, 3},
}

formatobjlist()

print("End of !init.lua")