extends Button


func _ready() -> void:
	if OS.has_feature("web"):
		disabled = true


func _pressed() -> void:
	get_tree().quit()
