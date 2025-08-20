extends Node3D

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var planet_builder = Planet_Builder.new()
	var mesh = planet_builder.build()
	#$MeshInstance3D.mesh = mesh
	var planet = planet_builder.planet
	add_child(planet)
	planet.build_tiles()
	planet_builder.planet.tile_selected.connect(on_tile_selected)
	player = load("res://game/player.tscn").instantiate()
	player.global_transform = planet.tiles[0].global_transform
	player.scale = Vector3.ONE
	planet.add_child(player)

func on_tile_selected(tile):
	print("moving to " + str(tile.global_position))
	player.target_position = tile.global_position
	$GUI.on_tile_selected(tile)

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
		
			
