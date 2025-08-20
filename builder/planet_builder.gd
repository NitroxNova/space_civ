extends Resource
class_name Planet_Builder

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
	if _planet == null:
		planet = Planet.new()
	else:
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
	#spawn materials
	for i in 5000:
		var rand_tile = planet.tiles.pick_random()
		var rand_mat = Biome.spawn_material(rand_tile.biome)
		rand_tile.raw_material = rand_mat
	#planet.build_tiles()
	return mesh
	
func get_tiles(mesh:ArrayMesh):
	var sf_arrays = mesh.surface_get_arrays(0)
	var sf_vertex = sf_arrays[Mesh.ARRAY_VERTEX]
	var sf_index = sf_arrays[Mesh.ARRAY_INDEX]
	for tile_id in sf_index.size()/3:
		var tile_pos = PackedVector3Array()
		for i in 3:
			tile_pos.append(sf_vertex[sf_index[tile_id*3+i]])
		var center_point = (tile_pos[0] + tile_pos[1] + tile_pos[2]) /3
		var tile = get_tile_type(center_point)
		tile.vertices = tile_pos
		planet.tiles.append(tile)
		#tiles.append(tile)
		#print(tile)


func get_tile_type(tile_pos:Vector3):
	
	var noise_pos = tile_pos.normalized()
	var noise = ocean_noise.get_noise_3dv(noise_pos*100)
	##print(noise)
	var tile = BLANK_TILE.instantiate()
	tile.center_point = tile_pos
	tile.lat_lon = lat_lon_from_position(tile_pos,planet.radius)
	var rain_temp = rain_temp_from_latitude(tile.lat_lon[0])
	tile.precipitation = rain_temp.rain
	tile.temperature = rain_temp.temp
	var travel_cost = 1 
	if noise > 0:
		#tile = OCEAN_TILE.instantiate()
		travel_cost = 10
		tile.water = "salt"
		tile.biome = Biome.OCEAN
		tile.elevation = 0
	else: #land
		var mtn_noise_value = mountain_noise.get_noise_3dv(noise_pos*300)
		tile.elevation = pow((mtn_noise_value + 1)/2,3) * 10000 
		if tile.elevation > 3000:
			tile.biome = Biome.MOUNTAIN
		elif tile.elevation > 1500:
			tile.biome = Biome.GRASSLAND_HILLS
		else:
			tile.biome = Biome.GRASSLAND
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
