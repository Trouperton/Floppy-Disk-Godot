extends Node3D

@export var base_terrain_speed = 1.0
var terrain_segments

const DEBUG_IDENTIFIER = "[TerrainSegmentManager.gd]"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	find_segments()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for segment in terrain_segments:
		segment.position.x -= base_terrain_speed * delta

func find_segments():
	terrain_segments = get_children()
	print(terrain_segments)
