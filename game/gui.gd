extends Control

var selected_tile

func on_tile_selected(tile):
	selected_tile = tile
	$Tile_Info/type.text = Biome.display[tile.biome]


func _on_confirm_build_pressed() -> void:
	var building_mesh = MeshInstance3D.new()
	var build_string = %NewBuildTypeOptions.get_item_text(%NewBuildTypeOptions.selected)
	if build_string == "":
		return
	if build_string == "Farm":
		building_mesh.mesh = load("res://game/buildings/wheat_farm.res")
	else:
		building_mesh.mesh = load("res://game/buildings/camp.res")
	selected_tile.add_child(building_mesh)
