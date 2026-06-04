class_name BaseUI
extends Control


## This node will be focused to when the element becomes visible.
@export var element_to_focus: Control


func _ready() -> void:
	if visible:
		element_to_focus.grab_focus()


func _on_visibility_changed() -> void:
	if visible and element_to_focus.is_inside_tree():
		element_to_focus.grab_focus()
