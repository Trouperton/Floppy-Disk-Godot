extends Area3D

signal triggered_threshold(points: int)
@onready var level_manager = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.triggered_threshold.connect(level_manager._on_triggered_threshold)
	#connect("triggered_threshold", level_manager, "_on_triggered_threshold")
	pass # Replace with function body.


func _on_body_entered(body: Node3D) -> void:
	for group in body.get_groups():
		if group == "player":
			triggered_threshold.emit(100)
			
			self.queue_free()
