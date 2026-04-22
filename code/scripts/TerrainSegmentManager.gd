extends Node3D


## How fast the terrain will scroll by default in metres per second.
@export var base_terrain_speed: float = 1.0

@export_category("Terrain Spawning")
## The distance to the left from the centre of the screen at which terrain segments get
## deleted to avoid major performance impact.
@export var terrain_delete_threshold: float = -30
## The distance to the right from the centre of the screen, if there is terrain
## missing to the left of this point; more terrain gets spawned.
@export var terrain_spawning_threshold: float = 30
## The minimum number of segments that will be spawned whenever the manager spawns more.
@export var minimum_segments_to_spawn: int = 5
## The selection of terrain segments that will be spawned by the terrain segment manager.
@export var terrain_segment_spawn_collection: Array[PackedScene]


## The current speed at which the terrain gets moved each physics process.
var terrain_speed: float
## The collection of terrain segments that the manager is currently managing.
var terrain_segments


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	terrain_speed = base_terrain_speed
	find_segments()
	check_terrain() 


func _physics_process(delta: float) -> void:
	move_terrain(delta)


## Moves all terrain segments to the left based on [member terrain_speed].
func move_terrain(delta: float):
	for segment in terrain_segments:
		segment.position.x -= terrain_speed * delta


#region Terrain Checking
## Looks for all the child ones of the empty "TerrainSegments" node and adds them
## to [member terrain_segments].
func find_segments():
	terrain_segments = $TerrainSegments.get_children()
	#print_debug(name, " node found ", terrain_segments)
	if terrain_segments.size() == 0:
		printerr(name, " failed to find terrain segments!")


## Checks what [member terrain_segments] are currently present.[br][br]
## 
## Any segments past the [member terrain_delete_threshold], get deleted.[br][br]
##
## And if there isn't enough terrain segments ahead of the [member terrain_spawning_threshold],
## spawns more based on [member minimum_segments_to_spawn].
func check_terrain():
	var segments_changed = false
	var furthest_forward: GridMap = null
	
	for segment in terrain_segments:
		if furthest_forward == null or segment.position.x > furthest_forward.position.x:
			furthest_forward = segment
		
		if segment.position.x < terrain_delete_threshold:
			segments_changed = true
			$TerrainSegments.remove_child(segment)
			segment.queue_free()
	
	if furthest_forward.position.x < terrain_spawning_threshold:
		for i in minimum_segments_to_spawn:
			var new_segment: GridMap = terrain_segment_spawn_collection[randi_range(0, terrain_segment_spawn_collection.size() - 1)].instantiate()
			$TerrainSegments.add_child(new_segment)
			new_segment.position.x = furthest_forward.position.x + (7 * (i + 1)) #7 corresponds to terrain segment width and the + 1 is there so it counts from 1 not 0.
		
		segments_changed = true
	
	if segments_changed:
		find_segments()


func _on_terrain_check_timer_timeout() -> void:
	check_terrain()
#endregion
