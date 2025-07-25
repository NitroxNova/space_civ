extends Node3D
class_name Planet

signal tile_selected(tile)
var radius = 10

var tiles = []

func on_tile_selected(tile):
	print(tile.get_display_type() + " tile selected ")
	print("Elevation: ",tile.elevation)
	print("Temperature: ", tile.temperature)
	print("Precipitation: ", tile.precipitation)
	print("Lat/Lon: ", tile.lat_lon)
	tile_selected.emit(tile)
