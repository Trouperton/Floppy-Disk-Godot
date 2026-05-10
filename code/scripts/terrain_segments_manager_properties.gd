extends Resource

@export var parent_node: NodePath
@export var segment_width: float = 7
## The distance to the left from the centre of the screen at which terrain segments get
## deleted to avoid major performance impact.
@export var delete_threshold: float = -30
## The distance to the right from the centre of the screen, if there is terrain
## missing to the left of this point; more terrain gets spawned.
@export var spawning_threshold: float = 30
## The minimum number of segments that will be spawned whenever the manager spawns more.
@export var number_to_spawn: int = 5
## The selection of terrain segments that will be spawned by the terrain segment manager.
@export var segment_collection: Array[PackedScene]


var segments
