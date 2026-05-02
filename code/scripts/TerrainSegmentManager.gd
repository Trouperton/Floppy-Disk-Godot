extends Node3D


signal segment_spawned(segment: GridMap)


## How fast the terrain will scroll by default in metres per second.
@export var base_terrain_speed: float = 1.0

@export_category("Terrain Spawning")
@export var terrains: Array[Resource]


## The current speed at which the terrain gets moved each physics process.
var terrain_speed: float
var terrain_segments_distant


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	terrain_speed = base_terrain_speed
	find_segments()
	
	for segment in terrains[0].segments:
		segment_spawned.emit(segment)
	
	check_terrain() 


func _physics_process(delta: float) -> void:
	move_terrain(delta)


## Moves all terrain segments to the left based on [member terrain_speed].
func move_terrain(delta: float):
	for segment in terrains[0].segments:
		segment.position.x -= terrain_speed * delta
	
	for segment in terrain_segments_distant:
		segment.position.x -= terrain_speed * delta


#region Terrain Checking
## Looks for all the child ones of the empty "TerrainSegments" node and adds them
## to [member terrain_segments].
func find_segments():
	terrains[0].segments = $TerrainSegments.get_children()
	#print_debug(name, " node found ", terrain_segments)
	if terrains[0].segments.size() == 0:
		printerr(name, " failed to find terrain segments!")
	
	terrain_segments_distant = $TerrainSegmentsDistant.get_children()


## Checks what [member terrain_segments] are currently present.[br][br]
## 
## Any segments past the [member terrain_delete_threshold], get deleted.[br][br]
##
## And if there isn't enough terrain segments ahead of the [member terrain_spawning_threshold],
## spawns more based on [member segments_to_spawn].
func check_terrain():
	var segments_changed = false
	var furthest_forward: GridMap = null
	var segments_to_delete: Array[GridMap]
	
	if terrains[0].segments.size() == 0:
		printerr(name, " has no terrain segments, can't check terrain!")
		return
	
	for segment in terrains[0].segments:
		if furthest_forward == null or segment.position.x > furthest_forward.position.x:
			furthest_forward = segment
		
		if segment.position.x < terrains[0].delete_threshold:
			segments_changed = true
			segments_to_delete.append(segment)
	
	for segment in segments_to_delete:
		$TerrainSegments.remove_child(segment)
		segment.queue_free()
	
	if furthest_forward == null:
		printerr(name, " could not determine the further forward segment!")
		return
	
	if furthest_forward.position.x < terrains[0].spawning_threshold:
		for i in terrains[0].number_to_spawn:
			var new_segment: GridMap = terrains[0].segment_collection[randi_range(0, terrains[0].segment_collection.size() - 1)].instantiate()
			$TerrainSegments.add_child(new_segment)
			new_segment.position.x = furthest_forward.position.x + (terrains[0].segment_width * (i + 1))
			segment_spawned.emit(new_segment)
		
		segments_changed = true
	
	if segments_changed:
		find_segments()


func _on_terrain_check_timer_timeout() -> void:
	check_terrain()
#endregion
