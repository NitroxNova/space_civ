extends StaticBody3D

var biome = "" #grassland, desert
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
signal tile_selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(_on_input_event)
	build_tile()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func build_tile():
	var mesh = MeshInstance3D.new()
	if water == "salt":
		mesh.mesh = load("res://tiles/terrain/blank_tile.res")
		var material = StandardMaterial3D.new()
		material.albedo_texture = load("res://tiles/biome/ocean/flat.png")
		mesh.set_surface_override_material(0,material)
		#print(mesh)
	else:
		mesh.mesh = load("res://tiles/terrain/blank_tile.res")
		var material = StandardMaterial3D.new()
		material.albedo_texture = load("res://tiles/biome/grassland/flat.png")
		mesh.set_surface_override_material(0,material)
		
	add_child(mesh)		

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
