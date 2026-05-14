extends Button


@export var parent_to_hide: Control


func _pressed() -> void:
	parent_to_hide.hide()
	get_tree().paused = false
