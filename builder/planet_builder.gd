extends Resource
class_name Planet_Builder

var tiles = []
var planet : Node3D = Node3D.new()
var ocean_noise : FastNoiseLite

const OCEAN_TILE = preload("res://terrain_tiles/ocean/ocean_tile.tscn")
const PLAINS_TILE = preload("res://terrain_tiles/plains/plains_tile.tscn")

func _init(_planet:Node3D=null):
	if _planet != null:
		planet = _planet
	var origin = Node3D.new()
	origin.name = "origin"
	planet.add_child(origin)
	ocean_noise = FastNoiseLite.new()
	#ocean_noise.sca

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

func get_tile_type(tile_pos:Vector3):
	var noise_pos = tile_pos.normalized()
	noise_pos *= 100
	var noise = ocean_noise.get_noise_3dv(noise_pos)
	#print(noise)
	var tile : Node3D
	if noise > 0:
		tile = OCEAN_TILE.instantiate()
	else:
		tile = PLAINS_TILE.instantiate()
	return tile
