extends StaticBody3D
class_name Game_Tile

var biome : int
var elevation = 0
var temperature = 0
var precipitation = 0 #mm per year?
var water = "none" #freshwater, salt water 
var plant_resource 
var animal_resource
var mineral_resource
var forest_type
var ground_type #stone, sand, water?
var lat_lon : Vector2 #latitude and longitude
var raw_material : String
var vertices : PackedVector3Array #relative to planet
var city
var neighbor_tiles = []
var diagonal_tiles = [] #touching on just one vertex
var building : Building
var center_point : Vector3
signal tile_selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(_on_input_event)
	#build_tile()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> void:
	if building != null:
		building.process(delta)

func is_hills():
	if elevation < 1500:
		return false
	if elevation > 3000:
		return false
	return true

func distance_to(target):
	if target is City:
		return center_point.distance_to(target.center.center_point)
	if target is Game_Tile:
		return center_point.distance_to(target.center_point)
	
func add_building(_building:Building):
	building = _building
	var mesh_inst = MeshInstance3D.new()
	mesh_inst.mesh = building.type.mesh
	if is_hills():
		mesh_inst.position.y += .3
	add_child(mesh_inst)
	
func set_city(_city:City):
	city = _city
	%city_colors.set_surface_override_material(0,city.material)
	%city_colors.show()

func build_tile():
	#print("building tile")
	var mesh = MeshInstance3D.new()
	if biome == Biome.OCEAN:
		mesh.mesh = load("res://tiles/terrain/blank_tile.res")
		var material = StandardMaterial3D.new()
		material.albedo_texture = load("res://tiles/biome/ocean/flat.png")
		mesh.set_surface_override_material(0,material)
		#print(mesh)
	elif biome == Biome.MOUNTAIN:
		mesh.mesh = load("res://tiles/terrain/mountain_tile.res")
		var material = StandardMaterial3D.new()
		material.albedo_texture = load("res://tiles/biome/mountain/tile_grass.png")
		mesh.set_surface_override_material(0,material)
		
	elif biome == Biome.GRASSLAND_HILLS:
		mesh.mesh = load("res://tiles/terrain/hills_tile.res")
		var material = StandardMaterial3D.new()
		material.albedo_texture = load("res://tiles/biome/grassland/hills.png")
		mesh.set_surface_override_material(0,material)
	elif biome == Biome.GRASSLAND:
		mesh.mesh = load("res://tiles/terrain/blank_tile.res")
		var material = StandardMaterial3D.new()
		material.albedo_texture = load("res://tiles/biome/grassland/flat.png")
		mesh.set_surface_override_material(0,material)
		
	add_child(mesh)		
	if raw_material != null and raw_material != "":
		var sprite = Sprite3D.new()
		sprite.rotation.x = -PI/2
		sprite.position.y = 2
		#sprite.texture = load(raw_material.resource_path.get_basename() + ".png")
		var item_data = Item.list(raw_material)
		sprite.texture = load("res://game/items/icon/" + item_data.icon + ".png")
		#print(sprite.texture.get_size())
		var new_scale = Vector2(64,64) / sprite.texture.get_size()
		sprite.scale = Vector3(new_scale.x,new_scale.y,1.0)
		add_child(sprite)
	
func get_display_type():
	if water == "salt":
		return "ocean"
	elif water == "fresh":
		return "lake"
	return ""

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		#print(type + " tile selected")
		tile_selected.emit(self)
