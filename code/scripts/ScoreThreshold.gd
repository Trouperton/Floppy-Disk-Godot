extends Area3D

signal score_threshold_triggered(points: int)
@onready var level_manager = $"../../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.score_threshold_triggered.connect(level_manager._on_score_threshold_triggered)


func _on_body_entered(body: Node3D) -> void:
	for group in body.get_groups():
		if group == "player":
			score_threshold_triggered.emit(100)
			
			self.queue_free()
