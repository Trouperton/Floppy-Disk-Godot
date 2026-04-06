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
	if can_dash:
		if velocity.y > 0:
			animation_state = Animation_States.RISING
		else:
			animation_state = Animation_States.FALLING
	
	if get_slide_collision_count() > 0:
		for i in get_slide_collision_count():
			for group in get_slide_collision(i).get_collider(0).get_groups():
				if group == "obstacle":
					#print("lose")
					#get_tree().reload_current_scene()
					get_tree().paused = true
					died.emit()
					$DeathAudioPlayer.play()
	
	# Add the gravity.
	velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
		animation_state = Animation_States.RISING
		$JumpAudioPlayer.play()
	
	dash()
	
	move_and_slide()
	
	animate()


func dash():
	if can_dash:
		if Input.is_action_just_pressed("dash_up"):
			velocity.y = vertical_dash_velocity
			animation_state = Animation_States.VERTICAL_DASH
			$DashVerticalAudioPlayer.play()
			start_dash_cooldown()
		elif Input.is_action_just_pressed("dash_down"):
			velocity.y = -vertical_dash_velocity
			animation_state = Animation_States.VERTICAL_DASH
			$DashVerticalAudioPlayer.play()
			start_dash_cooldown()


func start_dash_cooldown():
	can_dash = false
	$DashCooldownTimer.start()


func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true


func animate():
	match animation_state:
		Animation_States.RISING:
			if velocity.y > 4:
				$"Floppy Disk/AnimationPlayer".play("jump_0")
			else:
				$"Floppy Disk/AnimationPlayer".play("jump_1")
		Animation_States.FALLING:
			if $"Floppy Disk/AnimationPlayer".current_animation != "falling_1":
				$"Floppy Disk/AnimationPlayer".play("falling_0")
		Animation_States.VERTICAL_DASH:
			$"Floppy Disk/AnimationPlayer".play("spin")


func _on_animation_finished(animation_name: String):
	if animation_name == "falling_0":
		$"Floppy Disk/AnimationPlayer".play("falling_1")
