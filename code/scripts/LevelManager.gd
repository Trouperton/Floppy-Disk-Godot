extends Node3D


@export var score: int = 0
@export var score_label: Label
@export var difficulty_curve: Curve


var can_score_from_vertical_dash: bool = true
var can_score_from_forward_dash: bool = true
var pillars_passed = 0
var forward_dash_speed_factor: float = 2
@onready var player_character = $PlayerFloppy
@onready var terrain_manager = $TerrainSegmentManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	forward_dash_speed_factor = player_character.forward_dash_speed_factor


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


#region Score Manipulation
func _on_score_threshold_triggered(points: int):
	pillars_passed += 1
	
	# TODO: Change direct manipulation of terrain speed in another class to a
	# signal that will be read instead by the terrain manager.
	terrain_manager.terrain_speed = difficulty_speed()
	
	# Re-enables the player character's gravity.
	# NOTE: might be worth changing to a signal in the future.
	player_character.gravity_enabled = true
	
	increase_score(points)
	
	can_score_from_vertical_dash = true
	can_score_from_forward_dash = true

## Increases the score and updates the score label with the new value.
func increase_score(points: int):
	score += points
	#print_debug(name," node added ",points, " points, new score is " , score)
	
	# TODO: change the direct manipulation of score label to a signal.
	score_label.text = "Score: " + str(score)


#region Movement
func _on_player_floppy_dashed_vertically(points: int) -> void:
	if can_score_from_vertical_dash:
		increase_score(points)
		can_score_from_vertical_dash = false


func _on_player_floppy_dashed_forward(points: int) -> void:
	if can_score_from_forward_dash:
		increase_score(points)
		can_score_from_forward_dash = false
	terrain_manager.terrain_speed = difficulty_speed() * forward_dash_speed_factor
	
	# Resets velocity to 0 and disables gravity so the dash motion is a straight
	# line forward
	player_character.gravity_enabled = false
	player_character.velocity = Vector3(0, 0, 0)

## Returns the sum of base terrain speed and the difficulty curve sample based on
## the number of pillars that were passed.
func difficulty_speed():
	return terrain_manager.base_terrain_speed + difficulty_curve.sample(pillars_passed)
#endregion

#endregion


#region Player State
func _on_player_floppy_died() -> void:
	$HUD.hide()
	$EndScreen/Panel/VBoxContainer/ScoreDisplayLabel.text = str(score)
	$EndScreen.show()
#endregion
