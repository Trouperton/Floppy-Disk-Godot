extends Node3D

## How fast the terrain will scroll by default in metres per second.
@export var base_terrain_speed: float = 1.0
var terrain_segments

@export_category("Terrain Spawning")
## The minimum number of segments that will be spawned whenever the manager spawns more.
@export var minimum_segments_to_spawn: int = 5
## The selection of terrain segments that will be spawned by the terrain segment manager.
@export var terrain_segment_spawn_collection: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	find_segments()
	check_terrain() 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for segment in terrain_segments:
		segment.position.x -= base_terrain_speed * delta


func find_segments():
	terrain_segments = $TerrainSegments.get_children()
	print_debug(name, " node found ", terrain_segments)
	if terrain_segments.size() == 0:
		printerr(name, " failed to find terrain segments!")


func check_terrain():
	var segments_changed = false
	var furthest_forward: GridMap
	
	for segment in terrain_segments:
		if furthest_forward == null or segment.position.x > furthest_forward.position.x:
			furthest_forward = segment
		
		if segment.position.x < -20:
			segments_changed = true
			$TerrainSegments.remove_child(segment)
			segment.queue_free()
	
	if furthest_forward.position.x < 25:
		for i in minimum_segments_to_spawn:
			var new_segment: GridMap = terrain_segment_spawn_collection[randi_range(0, terrain_segment_spawn_collection.size() - 1)].instantiate()
			$TerrainSegments.add_child(new_segment)
			new_segment.position.x = furthest_forward.position.x + (7 * (i + 1))
	
	if segments_changed:
		find_segments()


func _on_terrain_check_timer_timeout() -> void:
	check_terrain()
