extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var nav_agent = $NavigationAgent3D

var target_position = Vector3.ZERO

func _physics_process(delta):
	if target_position != Vector3.ZERO:
		nav_agent.target_position = target_position
		var next_path_position = nav_agent.get_next_path_position()
		if next_path_position != Vector3.INF:
			var direction = (next_path_position - global_position).normalized()
			velocity = direction * 5 # Adjust speed as needed
			move_and_slide()
		else:
			# Reached the target, stop or do something else
			velocity = Vector3.ZERO
			target_position = Vector3.ZERO # Reset target

#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()
	
	
