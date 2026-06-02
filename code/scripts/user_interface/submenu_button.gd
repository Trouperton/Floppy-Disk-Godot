extends Button


@export var parent_to_hide: Control
@export var menu_to_show: Control


func _pressed() -> void:
	parent_to_hide.hide()
	
	menu_to_show.show()
