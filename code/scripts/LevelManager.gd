extends Node3D

@export var score: int = 0
@export var score_label: Label

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_score_threshold_triggered(points: int):
	increase_score(points)


func increase_score(points: int):
	score += points
	print_debug(name," node added ",points, " points, new score is " , score)
	score_label.text = "Score: " + str(score)
