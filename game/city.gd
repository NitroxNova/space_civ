extends Resource
class_name City

var display_name = ""
var center #town hall, main district
var tiles = []
var material : StandardMaterial3D
var expansion_counter:float = 1 * 24 * 60 * 60

func randomize_color():
	material = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(randf(),randf(),randf(),.3)

func expand_borders():
	var potential_tiles = []
	for tile in tiles:
		for nb_tile in tile.neighbor_tiles:
			if nb_tile in tiles:
				continue
			if nb_tile in potential_tiles:
				continue
			potential_tiles.append(nb_tile)
	var closest_tile = potential_tiles[0]
	for tile in potential_tiles:
		if center.distance_to(tile) < center.distance_to(closest_tile):
			closest_tile = tile
	add_tile(closest_tile)
	expansion_counter += (tiles.size()) * 24 * 60 * 60

func add_tile(tile):
	tiles.append(tile)
	tile.set_city(self)
			

func process(delta:float):
	expansion_counter -= delta
	if expansion_counter < 0:
		expand_borders()
	for tile in tiles:
		tile.process(delta)
