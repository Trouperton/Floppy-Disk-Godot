extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_button_focus_entered() -> void:
	print(name, " received button focus signal")
	$"Hover Audio".play()
