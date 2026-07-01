extends Control


@export var music_player: OvaniPlayer
@export var main_music_list: Array[OvaniSong]
@export var game_over_music_list: Array[OvaniSong]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().scene_changed.connect(_on_scene_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if music_player.Intensity < 1.0 and music_player.is_node_ready():
		music_player.Intensity = music_player.Intensity + (0.1 * delta)


func _on_scene_changed() -> void:
	music_player.Intensity = 0
