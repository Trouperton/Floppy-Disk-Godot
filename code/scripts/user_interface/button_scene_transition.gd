extends Button


@export var scene_to_open: String


func _pressed() -> void:
	print_debug("Loading ", scene_to_open)
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_to_open)
