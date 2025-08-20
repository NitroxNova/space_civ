extends Resource
class_name Biome

enum {GRASSLAND,GRASSLAND_HILLS,OCEAN,MOUNTAIN}

const display = ["Grassland","Grassland Hills","Ocean","Mountains"]

const spawns = {
	GRASSLAND : {"wheat"=1},
	GRASSLAND_HILLS : {"wheat"=1,"iron_ore"=.5},
	MOUNTAIN : {"iron_ore"=1},
	OCEAN : {"tuna"=1},
}

static func spawn_material(biome:int):
	var mat_name = spawns[biome].keys().pick_random()
	return load("res://game/materials/" + mat_name + ".res")
