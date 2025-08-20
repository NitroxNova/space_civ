extends StaticBody3D

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
var raw_material : Material_Type
var vertices : PackedVector3Array #relative to planet
var center_point : Vector3
signal tile_selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(_on_input_event)
	#build_tile()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	if raw_material != null:
		var sprite = Sprite3D.new()
		sprite.rotation.x = -PI/2
		sprite.position.y = 2
		sprite.texture = load(raw_material.resource_path.get_basename() + ".png")
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
