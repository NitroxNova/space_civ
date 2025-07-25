extends Resource
class_name Planet_Builder

var tiles = []
var planet : Planet = Planet.new()
var ocean_noise : FastNoiseLite
var mountain_noise : FastNoiseLite

const TILE_NAVIGATION_REGION = preload("res://tiles/navigation_region_3d.tscn")

#const OCEAN_TILE = preload("res://terrain_tiles/ocean/ocean_tile.tscn")
#const PLAINS_TILE = preload("res://terrain_tiles/plains/plains_tile.tscn")
#const MOUNTAIN_TILE = preload("res://terrain_tiles/mountain/mountain.tscn")
#const GRASSLAND_HILLS_TILE = preload("res://terrain_tiles/grassland_hills/grassland_hills_tile.tscn")

const BLANK_TILE = preload("res://tiles/terrain/blank_tile.tscn")
var latitude_rain_temperature = ""

func _init(_planet:Planet=null):
	
	if _planet != null:
		planet = _planet
	var origin = Node3D.new()
	origin.name = "origin"
	planet.add_child(origin)
	ocean_noise = FastNoiseLite.new()
	mountain_noise = FastNoiseLite.new()
	ocean_noise.seed = randi()
	mountain_noise.seed = randi()
	
	var file_path = "res://builder/lat_lon/latitude_temperature_rain.json"
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		latitude_rain_temperature = JSON.parse_string(json_string)

func build():
	var ico_builder = Icosahedron_Builder.new(15)
	var mesh = ico_builder.create_mesh()
	get_tiles(mesh)
	for tile_id in tiles.size():
		place_triangle(tile_id)
	return mesh
	
func get_tiles(mesh:ArrayMesh):
	var sf_arrays = mesh.surface_get_arrays(0)
	var sf_vertex = sf_arrays[Mesh.ARRAY_VERTEX]
	var sf_index = sf_arrays[Mesh.ARRAY_INDEX]
	for tile_id in sf_index.size()/3:
		var tile = []
		for i in 3:
			tile.append(sf_vertex[sf_index[tile_id*3+i]])
		tiles.append(tile)
		#print(tile)


func place_triangle(tile_id:int):
	var tile = tiles[tile_id]
	var origin = planet.get_node("origin")
	origin.rotation = Vector3.ZERO
	var center_point = (tile[0] + tile[1] + tile[2]) /3
	var tile_mesh = get_tile_type(center_point)
	origin.add_child(tile_mesh)
	var tm_scale = max(tile[0].distance_to(center_point),tile[1].distance_to(center_point),tile[2].distance_to(center_point))
	tile_mesh.scale = Vector3(tm_scale,tm_scale,tm_scale)
	tile_mesh.position = Vector3.UP * Vector3.ZERO.distance_to(center_point)
	origin.look_at(center_point)
	origin.rotation.x -= PI/2
	#print(tile_mesh.global_position)
	#print(center_point)
	var axis = center_point.normalized()
	tile_mesh.look_at(tile[0],axis)
	var xform = tile_mesh.global_transform
	origin.remove_child(tile_mesh)
	planet.add_child(tile_mesh)
	tile_mesh.global_transform = xform
	tiles[tile_id] = tile_mesh
	tile_mesh.tile_selected.connect(planet.on_tile_selected)
	planet.tiles.append(tile_mesh)

func get_tile_type(tile_pos:Vector3):
	var noise_pos = tile_pos.normalized()
	var noise = ocean_noise.get_noise_3dv(noise_pos*100)
	##print(noise)
	var tile = BLANK_TILE.instantiate()
	tile.lat_lon = lat_lon_from_position(tile_pos,planet.radius)
	var rain_temp = rain_temp_from_latitude(tile.lat_lon[0])
	tile.precipitation = rain_temp.rain
	tile.temperature = rain_temp.temp
	var travel_cost = 1 
	if noise > 0:
		#tile = OCEAN_TILE.instantiate()
		travel_cost = 10
		tile.water = "salt"
	#else: #land
		#var mtn_noise_value = mountain_noise.get_noise_3dv(noise_pos*300)
		#if mtn_noise_value < 0:
			#tile = PLAINS_TILE.instantiate()
			#travel_cost = 1
		#elif mtn_noise_value < 0.3:
			#tile = GRASSLAND_HILLS_TILE.instantiate()
			#travel_cost = 3
		#else:
			#tile = MOUNTAIN_TILE.instantiate()
			#travel_cost = 10
	
	
		
	tile.add_child(TILE_NAVIGATION_REGION.instantiate())
	var nav_reg : NavigationRegion3D = tile.get_node("NavigationRegion3D")	
	nav_reg.travel_cost = travel_cost
	return tile

static func lat_lon_from_position(position:Vector3, sphereRadius:float):
	var lat:float = acos(position.y / sphereRadius); #theta
	var lon:float = atan(position.x / position.z); #phi
	return Vector2(lat, lon);

func rain_temp_from_latitude(latitude):
	#from -90 to 90
	var percent = latitude / PI
	var index:int = percent * latitude_rain_temperature.rain.size()
	if index >= latitude_rain_temperature.rain.size():
		index = latitude_rain_temperature.rain.size() -1
	var rain = latitude_rain_temperature.rain[index]
	var temp = latitude_rain_temperature.temp[index]
	return {temp=temp,rain=rain}
