extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and !$"../EndScreen".visible:
		visible = !visible


func _on_visibility_changed() -> void:
	if visible:
		get_tree().paused = true
		$Panel2/VBoxContainer/ScoreDisplayLabel.text = str($"..".score)
	else:
		get_tree().paused = false
