extends Button


@export var scene_to_open: PackedScene


func _pressed() -> void:
	print_debug("Loading ", scene_to_open)
	get_tree().change_scene_to_packed(scene_to_open)
