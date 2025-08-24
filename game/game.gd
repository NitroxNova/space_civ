extends Node3D

var curr_player
var curr_planet 
var city_namer : City_Namer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	city_namer = City_Namer.new()
	city_namer.parse_names()
	var planet_builder = Planet_Builder.new()
	var mesh = planet_builder.build()
	#$MeshInstance3D.mesh = mesh
	curr_planet = planet_builder.planet
	add_child(curr_planet)
	curr_planet.build_tiles()
	planet_builder.planet.tile_selected.connect(on_tile_selected)
	curr_player = load("res://game/player.tscn").instantiate()
	curr_player.global_transform = curr_planet.tiles[0].global_transform
	curr_player.scale = Vector3.ONE
	curr_planet.add_child(curr_player)
	Game.planets.append(curr_planet)

func on_tile_selected(tile):
	print("moving to " + str(tile.global_position))
	curr_player.target_position = tile.global_position
	$GUI.on_tile_selected(tile)

func _process(delta: float) -> void:
	
	$GUI/HBoxContainer/date_label.text = Time.get_datetime_string_from_unix_time(Game.time)

func _input(event):
	var camera_speed = 1
	var camera_forward = - %Camera3D.global_basis.z
	var camera_velocity = camera_forward * camera_speed   # Calculate the movement vector
	if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#print("Left button was clicked at ", event.position)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			#print("Wheel up")
			%Camera3D.global_translate(camera_velocity) # Move the camera
			
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			#print("Wheel down")
			%Camera3D.global_translate(-camera_velocity) # Move the camera
	elif event is InputEventMouseMotion:
		if Input.is_action_pressed("mouse_button_middle"):
			var mouse_velocity = event.relative
			#print("Mouse velocity: ", mouse_velocity)
			%Camera_Arm.rotation.y += mouse_velocity.x/-100
			%Camera_Base.rotation.x += mouse_velocity.y/-100
			
	else:
		print(event)
		
func _on_gui_new_building(tile: Variant, building_type: Building_Type) -> void:
	if building_type.type == "city_center":
		var city = City.new()
		city.display_name = city_namer.generate_name()
		#print("new city ", city.display_name)
		city.center = tile
		city.randomize_color()
		curr_planet.add_city(city)
		city.add_tile(tile)
	var building = Building.new()
	building.type = building_type
	tile.add_building(building)
