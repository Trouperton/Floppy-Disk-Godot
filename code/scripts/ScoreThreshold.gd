extends Area3D


signal score_threshold_triggered(points: int)


@export var points: int = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.score_threshold_triggered.connect($"../../../.."._on_score_threshold_triggered)


func _on_body_exited(body: Node3D) -> void:
	for group in body.get_groups():
		if group == "player":
			score_threshold_triggered.emit(points)
			
			self.queue_free()
