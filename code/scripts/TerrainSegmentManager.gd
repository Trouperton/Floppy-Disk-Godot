extends Node3D

@export var base_terrain_speed: float = 1.0
var terrain_segments

@export var terrain_check_interval: float = 5;
var terrain_check_timer: float = 0

@export var terrain_segment_spawn_collection: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	find_segments()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for segment in terrain_segments:
		segment.position.x -= base_terrain_speed * delta
	
	check_terrain()
	
	terrain_check_timer += delta


func find_segments():
	terrain_segments = get_children()
	print_debug(name, " node found ", terrain_segments)
	if terrain_segments.size() == 0:
		printerr(name, " failed to find terrain segments!")


func check_terrain():
	if terrain_check_timer > terrain_check_interval:
		var segments_changed = false
		var furthest_forward: GridMap
		for segment in terrain_segments:
			if segment.position.x < -20:
				segments_changed = true
				remove_child(segment)
				segment.queue_free()
			
			if furthest_forward == null or segment.position.x > furthest_forward.position.x:
				furthest_forward = segment
		
		if furthest_forward.position.x < 20:
			print("should create more terrain")
			for i in 5:
				print("placing segment")
		
		if segments_changed:
			find_segments()
		
		terrain_check_timer = 0
