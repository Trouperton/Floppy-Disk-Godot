extends CharacterBody3D
## Script that allows the player to interact with the game world
##
## Handles gameplay related player inputs such as the movement based ones.
## Also manipulates the player's CharacterBody3D instance.

@export var jump_velocity: float = 4.5
var gravity_enabled: bool = true

@export var vertical_dash_velocity: float = 14
@export var forward_dash_speed_factor: float = 3
var can_dash = true
var has_dashed_vertically = false

enum Animation_States {
	RESTING,
	RISING,
	FALLING,
	VERTICAL_DASH
}

var animation_state: int = Animation_States.FALLING

signal died
signal dashed_vertically(points: int)
signal dashed_forward(points: int)

func _ready() -> void:
	$"Floppy Disk/AnimationPlayer".animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	check_collisions()
	
	if velocity.y > 0 and velocity.y < vertical_dash_velocity / 2:
		animation_state = Animation_States.RISING
	elif animation_state == Animation_States.RISING:
		animation_state = Animation_States.FALLING
	
	# Add the gravity.
	if gravity_enabled:
		velocity += get_gravity() * delta
	
	player_input()
	
	# Built in method that moves the player based on velocity
	move_and_slide()
	
	# Changes animation's played by the animator based on current animation state
	animate()

## Handles collision checks that are detected by move_and_slide() and
## WallCheckCast3D node looking for collisions with obstacles.
func check_collisions():
	# Checks for collisions detected by move_and_slide()
	for i in get_slide_collision_count():
		for group in get_slide_collision(i).get_collider(0).get_groups():
			if group == "obstacle":
				get_tree().paused = true
				died.emit()
				$DeathAudioPlayer.play()
	
	# Checks if the player collided with a wall with a cast
	for i in $WallCheckCast3D.get_collision_count():
		for group in $WallCheckCast3D.get_collider(i).get_groups():
			if group == "obstacle":
				get_tree().paused = true
				died.emit()
				$DeathAudioPlayer.play()


#region Movement
## Checks the player inputs and applies player behaviours accordingly.
func player_input():
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
		animation_state = Animation_States.RISING
		$JumpAudioPlayer.play()
	
	check_dash()


## Checks both whether the dash is ready and if the player pressed relevant inputs.
func check_dash():
	if can_dash:
		if Input.is_action_just_pressed("dash_up"):
			vertical_dash(true)
		elif Input.is_action_just_pressed("dash_down"):
			vertical_dash(false)
		elif Input.is_action_just_pressed("dash_forward"):
			forward_dash()


## Executes an up or down dash depending on the value parsed through the property.
func vertical_dash(dash_up: bool):
	if dash_up:
		velocity.y = vertical_dash_velocity
	else:
		velocity.y = -vertical_dash_velocity
	animation_state = Animation_States.VERTICAL_DASH
	$DashVerticalAudioPlayer.play()
	dashed_vertically.emit(25)
	start_dash_cooldown()


## Emits a signal to trigger behaviour needed to perform the forward dash.
func forward_dash():
	dashed_forward.emit(25)


func start_dash_cooldown():
	can_dash = false
	$DashCooldownTimer.start()


func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
	has_dashed_vertically = false
#endregion


#region Animation
## Sets the current animation being played by the animator based on the current
## animation state and some extra logic for certain behaviours.
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
#endregion
