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
	print("Materials: ",tile.raw_material)
	tile_selected.emit(tile)

func add_tile(tile):
	#print("Adding tile " , tile)
	tiles.append(tile)
	#add_child(tile)

func build_tiles():
	#print("building tiles")
	
	for tile_id in tiles.size():
		place_triangle(tile_id)
	for tile in tiles:
		tile.build_tile()

func place_triangle(tile_id:int):
	var tile_mesh = tiles[tile_id]
	var origin = get_node("origin")
	origin.rotation = Vector3.ZERO
	#var center_point = (tile[0] + tile[1] + tile[2]) /3
	#var tile_mesh = get_tile_type(tile.center_point)
	origin.add_child(tile_mesh)
	var tm_scale = max(tile_mesh.vertices[0].distance_to(tile_mesh.center_point),tile_mesh.vertices[1].distance_to(tile_mesh.center_point),tile_mesh.vertices[2].distance_to(tile_mesh.center_point))
	tile_mesh.scale = Vector3(tm_scale,tm_scale,tm_scale)
	tile_mesh.position = Vector3.UP * Vector3.ZERO.distance_to(tile_mesh.center_point)
	origin.look_at(tile_mesh.center_point)
	origin.rotation.x -= PI/2
	#print(tile_mesh.global_position)
	#print(center_point)
	var axis = tile_mesh.center_point.normalized()
	tile_mesh.look_at(tile_mesh.vertices[0],axis)
	var xform = tile_mesh.global_transform
	origin.remove_child(tile_mesh)
	add_child(tile_mesh)
	tile_mesh.global_transform = xform
	tile_mesh.tile_selected.connect(on_tile_selected)
	#tiles[tile_id] = tile_mesh
	#planet.add_tile(tile_mesh)
