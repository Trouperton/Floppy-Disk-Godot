extends Node3D

@export var score: int = 0
@export var score_label: Label

@export var difficulty_curve: Curve
var pillars_passed = 0

var terrain_manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	terrain_manager = $TerrainSegmentManager
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

## ========================== SCORE MANIPULATION ===============================


func _on_score_threshold_triggered(points: int):
	pillars_passed += 1
	terrain_manager.terrain_speed = terrain_manager.base_terrain_speed + difficulty_curve.sample(pillars_passed)
	increase_score(points)

func _on_dashed_vertically(points: int):
	increase_score(points)

func increase_score(points: int):
	score += points
	print_debug(name," node added ",points, " points, new score is " , score)
	score_label.text = "Score: " + str(score)

## ============================= PLAYER STATE ==================================


func _on_player_floppy_died() -> void:
	$HUD.hide()
	$EndScreen/Panel/VBoxContainer/ScoreDisplayLabel.text = str(score)
	$EndScreen.show()
