extends Node3D

var terrain_segments

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	terrain_segments = get_children()
	print(terrain_segments)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for segment in terrain_segments:
		segment.position.x -= 1 * delta
	pass
