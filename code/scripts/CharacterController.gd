extends CharacterBody3D
## Script that allows the player to interact with the game world
##
## Handles gameplay related player inputs such as the movement based ones.
## Also manipulates the player's CharacterBody3D instance.


signal died()
signal jumped()
signal dashed_vertically(points: int)
signal dashed_forward(points: int)


enum AnimationStates {
	RESTING,
	RISING,
	FALLING,
	VERTICAL_DASH,
	FORWARD_DASH
}


const OBSTACLE_GROUP = "obstacle"


@export var jump_velocity: float = 4.5
@export var vertical_dash_velocity: float = 14
@export var vertical_dash_points: int = 25
@export var forward_dash_speed_factor: float = 3
@export var forward_dash_points: int = 25


var gravity_enabled: bool = true
var can_dash = true
var animation_state: int = AnimationStates.FALLING
var is_dead = false
var all_shape_casts: Array[ShapeCast3D]


func _ready() -> void:
	$"Floppy Disk/AnimationPlayer".animation_finished.connect(_on_animation_finished)
	
	for i in $ShapeCasts.get_children():
		all_shape_casts.append(i)

func _physics_process(delta: float) -> void:
	if Engine.get_physics_frames() % 3 == 0:
		check_collisions()
	
	if velocity.y > 0 and velocity.y < vertical_dash_velocity / 2:
		animation_state = AnimationStates.RISING
	elif animation_state == AnimationStates.RISING:
		animation_state = AnimationStates.FALLING
	
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
	if is_dead:
		return
	
	# Checks if the player collided using a cast
	for cast in all_shape_casts:
		for i in cast.get_collision_count():
			if cast.get_collider(i).is_in_group(OBSTACLE_GROUP):
				is_dead = true
				kill_player()


func kill_player():
	get_tree().paused = true
	died.emit()
	$DeathAudioPlayer.play()


#region Movement
## Checks the player inputs and applies player behaviours accordingly.
func player_input():
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
		animation_state = AnimationStates.RISING
		$JumpAudioPlayer.play()
		jumped.emit()
	
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
	animation_state = AnimationStates.VERTICAL_DASH
	$DashVerticalAudioPlayer.play()
	dashed_vertically.emit(vertical_dash_points)
	start_dash_cooldown()


## Emits a signal to trigger behaviour needed to perform the forward dash.
func forward_dash():
	velocity = Vector3(0, 0, 0)
	dashed_forward.emit(forward_dash_points)
	
	# TODO: Add an audio player to play a sound when the player dashes forward.
	animation_state = AnimationStates.FORWARD_DASH


func start_dash_cooldown():
	can_dash = false
	$DashCooldownTimer.start()


func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true


func _on_world_passed_pillar() -> void:
	animation_state = AnimationStates.FALLING
#endregion


#region Animation
## Sets the current animation being played by the animator based on the current
## animation state and some extra logic for certain behaviours.
func animate():
	match animation_state:
		AnimationStates.RESTING:
			$"Floppy Disk/AnimationPlayer".play("idle")
		AnimationStates.RISING:
			if velocity.y > 4:
				$"Floppy Disk/AnimationPlayer".play("jump_0")
			else:
				$"Floppy Disk/AnimationPlayer".play("jump_1")
		AnimationStates.FALLING:
			if $"Floppy Disk/AnimationPlayer".current_animation != "falling_1":
				$"Floppy Disk/AnimationPlayer".play("falling_0")
		AnimationStates.VERTICAL_DASH:
			$"Floppy Disk/AnimationPlayer".play("spin")
		AnimationStates.FORWARD_DASH:
			$"Floppy Disk/AnimationPlayer".play("roll")


func _on_animation_finished(animation_name: String):
	if animation_name == "falling_0":
		$"Floppy Disk/AnimationPlayer".play("falling_1")
#endregion
