extends CharacterBody3D

@export var jump_velocity: float = 4.5

@export var vertical_dash_velocity: float = 14
var can_dash = true

enum Animation_States {RISING, FALLING}
var animation_state: int

func _physics_process(delta: float) -> void:
	if get_slide_collision_count() > 0:
		for group in get_slide_collision(0).get_collider(0).get_groups():
			if group == "obstacle":
				print("lose")
				get_tree().reload_current_scene()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
	
	dash()
	
	move_and_slide()
	
	animate()


func dash():
	if can_dash:
		if Input.is_action_just_pressed("dash_up"):
			velocity.y = vertical_dash_velocity
			start_dash_cooldown()
		elif Input.is_action_just_pressed("dash_down"):
			velocity.y = -vertical_dash_velocity
			start_dash_cooldown()
	
	match animation_state:
		Animation_States.RISING:
			$"Floppy Disk".rotation_degrees.z = 15
		Animation_States.FALLING:
			$"Floppy Disk".rotation_degrees.z -= 1.5

func animate():
	if velocity.y > 0:
		animation_state = Animation_States.RISING
	else:
		animation_state = Animation_States.FALLING

func start_dash_cooldown():
	can_dash = false
	$DashCooldownTimer.start()


func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
