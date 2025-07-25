extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var planet_builder = Planet_Builder.new($Planet)
	var mesh = planet_builder.build()
	$MeshInstance3D.mesh = mesh
	add_child(planet_builder.planet)
	planet_builder.planet.tile_selected.connect(on_tile_selected)
	var player = load("res://game/player.tscn").instantiate()
	player.global_transform = $Planet.tiles[0].global_transform
	player.scale = Vector3.ONE
	$Planet.add_child(player)

func on_tile_selected(tile):
	print("moving to " + str(tile.global_position))
	$Planet/Player.target_position = tile.global_position

func _input(event):
	var camera_speed = 1
	var camera_forward = - $Camera3D.global_basis.z
	var camera_velocity = camera_forward * camera_speed   # Calculate the movement vector
	if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#print("Left button was clicked at ", event.position)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			#print("Wheel up")
			$Camera3D.global_translate(camera_velocity) # Move the camera
			
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			#print("Wheel down")
			$Camera3D.global_translate(-camera_velocity) # Move the camera
