extends Node3D

@export var score: int = 0
@export var score_label: Label

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_score_threshold_triggered(points: int):
	increase_score(points)


func increase_score(points: int):
	score += points
	print_debug(name," node added ",points, " points, new score is " , score)
	score_label.text = "Score: " + str(score)


func _on_player_floppy_died() -> void:
	$HUD.hide()
	$EndScreen/Panel/VBoxContainer/ScoreDisplayLabel.text = str(score)
	$EndScreen.show()
