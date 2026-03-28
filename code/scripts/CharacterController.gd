extends CharacterBody3D

const JUMP_VELOCITY = 4.5

func _physics_process(delta: float) -> void:
	if get_slide_collision_count() > 0:
		print(get_slide_collision(0).get_collider(0).name)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY

	move_and_slide()
