extends Button


@export var parent_to_hide: Control
@export var grandparent_to_show: Control


func _pressed() -> void:
	parent_to_hide.hide()
	
	grandparent_to_show.show()
