extends Area3D


signal score_threshold_triggered(points: int)


@export var points: int = 100


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		score_threshold_triggered.emit(points)
		
		self.queue_free()
