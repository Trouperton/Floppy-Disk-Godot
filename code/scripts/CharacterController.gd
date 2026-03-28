extends CharacterBody3D

@export var jump_velocity = 4.5

func _physics_process(delta: float) -> void:
	if get_slide_collision_count() > 0:
		print(get_slide_collision(0).get_collider(0).get_groups())
		for group in get_slide_collision(0).get_collider(0).get_groups():
			if group == "obstacle":
				print("lose")
				get_tree().reload_current_scene()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_velocity

	move_and_slide()
