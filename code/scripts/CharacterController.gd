extends CharacterBody3D

@export var jump_velocity: float = 4.5

@export var vertical_dash_velocity: float = 14
var can_dash = true

enum Animation_States {RESTING ,RISING, FALLING, VERTICAL_DASH}
var animation_state: int

signal died

func _ready() -> void:
	$"Floppy Disk/AnimationPlayer".animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	animation_state = Animation_States.RESTING
	if velocity.y > 0:
		if can_dash:
			animation_state = Animation_States.RISING
		else:
			pass
	else:
		if can_dash:
			animation_state = Animation_States.FALLING
		else:
			pass
	
	if get_slide_collision_count() > 0:
		for group in get_slide_collision(0).get_collider(0).get_groups():
			if group == "obstacle":
				print("lose")
				#get_tree().reload_current_scene()
				get_tree().paused = true
				died.emit()
	
	# Add the gravity.
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
			animation_state = Animation_States.VERTICAL_DASH
			start_dash_cooldown()
		elif Input.is_action_just_pressed("dash_down"):
			velocity.y = -vertical_dash_velocity
			animation_state = Animation_States.VERTICAL_DASH
			start_dash_cooldown()


func start_dash_cooldown():
	can_dash = false
	$DashCooldownTimer.start()


func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true


func animate():
	match animation_state:
		Animation_States.RISING:
			$"Floppy Disk/AnimationPlayer".play("idle")
		Animation_States.FALLING:
			if $"Floppy Disk/AnimationPlayer".current_animation != "falling_1":
				$"Floppy Disk/AnimationPlayer".play("falling_0")
		Animation_States.VERTICAL_DASH:
			$"Floppy Disk".rotation_degrees = Vector3(0, 0, 0)
			$"Floppy Disk/AnimationPlayer".play("spin")


func _on_animation_finished(animation_name: String):
	if animation_name == "falling_0":
		$"Floppy Disk/AnimationPlayer".play("falling_1")
