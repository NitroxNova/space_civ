extends Resource
class_name Biome

enum {GRASSLAND,GRASSLAND_HILLS,OCEAN,MOUNTAIN}

const display = ["Grassland","Grassland Hills","Ocean","Mountains"]

const spawns = {
	GRASSLAND : {"winter_wheat_plant"=1},
	GRASSLAND_HILLS : {"winter_wheat_plant"=1,"iron_ore"=.5},
	MOUNTAIN : {"iron_ore"=1},
	OCEAN : {"tuna_fish_animal"=1},
}

static func spawn_material(biome:int):
	var mat_name = spawns[biome].keys().pick_random()
	return mat_name
	#return load("res://game/items/" + mat_name + ".res")
