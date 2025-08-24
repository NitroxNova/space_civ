extends Control

var selected_tile

signal new_building (tile,building)


func on_tile_selected(tile):
	selected_tile = tile
	$Tile_Info/type.text = Biome.display[tile.biome]
	if tile.city == null:
		%city_name_label.text = ""
	else:	
		%city_name_label.text = tile.city.display_name
	if tile.building == null:
		%CurrentBuildingDisplay.hide()
		%NewBuildTypeOptions.clear()
		%NewBuildTypeOptions.add_item(" -- Build -- ")
		if tile.city == null:
			var city_list = Game.planets[0].cities
			if city_list.size() == 0:
				%NewBuildTypeOptions.add_item("Campsite")
			else:
				var closest_city = city_list.keys()[0]
				closest_city = city_list[closest_city]
				#check if far enough from other cities
				for city_name in city_list:
					var city = city_list[city_name]
					if tile.distance_to(city) < tile.distance_to(closest_city):
						closest_city = city
				print(tile.distance_to(closest_city))
				if tile.distance_to(closest_city) > 1.5:	
					%NewBuildTypeOptions.add_item("Campsite")
		else:
			if tile.raw_material == "winter_wheat_plant":
				%NewBuildTypeOptions.add_item("Wheat Farm")
		%NewBuildContainer.show()
	else:
		%NewBuildContainer.hide()
		%CurrentBuildingDisplay.show()
		%CurrentBuildingDisplay/building_name.text = tile.building.type.display_name
		%CurrentBuildingDisplay/storage.text = str(tile.building.storage)
			
		


func _on_confirm_build_pressed() -> void:
	var build_string = %NewBuildTypeOptions.get_item_text(%NewBuildTypeOptions.selected)
	var building = Building.new()
	if build_string == "" or build_string == " -- Build -- ":
		return
	if build_string == "Wheat Farm":
		building =  load("res://game/buildings/wheat_farm/wheat_farm_building.res")
		#building_mesh.mesh = load("res://game/buildings/wheat_farm.res")
	elif build_string == "Campsite":
		building = load("res://game/buildings/camp/camp_building.res")
	new_building.emit(selected_tile,building)

func _on_faster_button_pressed() -> void:
	Engine.time_scale *= 10


func _on_slower_button_pressed() -> void:
	Engine.time_scale /= 10
